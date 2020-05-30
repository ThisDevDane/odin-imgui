package main

import "core:mem";
import "core:log";
import "core:strings";

import sdl "shared:odin-sdl2";
import gl  "shared:odin-gl";

import imgui "../../output";

DESIRED_GL_MAJOR_VERSION :: 4;
DESIRED_GL_MINOR_VERSION :: 5;

main :: proc() {
    logger_opts := log.Options {
        .Level,
        .Line,
        .Procedure,
    };
    context.logger = log.create_console_logger(opt = logger_opts);

    log.info("Starting SDL Example...");
    init_err := sdl.init(.Video);
    defer sdl.quit();
    if init_err == 0 {
        log.info("Setting up the window...");
        window := sdl.create_window("odin-imgui SDL+OpenGL example", 100, 100, 1280, 720, .Open_GL|.Mouse_Focus|.Shown);
        if window == nil {
            log.debugf("Error during window creation: %s", sdl.get_error());
            sdl.quit();
            return;
        }
        defer sdl.destroy_window(window);

        log.info("Setting up the OpenGL...");
        sdl.gl_set_attribute(.Context_Major_Version, DESIRED_GL_MAJOR_VERSION);
        sdl.gl_set_attribute(.Context_Minor_Version, DESIRED_GL_MINOR_VERSION);
        sdl.gl_set_attribute(.Context_Profile_Mask, i32(sdl.GL_Context_Profile.Core));
        gl_ctx := sdl.gl_create_context(window);
        if gl_ctx == nil {
            log.debugf("Error during window creation: %s", sdl.get_error());
            return;
        }
        sdl.gl_make_current(window, gl_ctx);
        defer sdl.gl_delete_context(gl_ctx);
        if sdl.gl_set_swap_interval(1) != 0 {
            log.debugf("Error during window creation: %s", sdl.get_error());
            return;
        }
        gl.load_up_to(DESIRED_GL_MAJOR_VERSION, DESIRED_GL_MINOR_VERSION, 
                      proc(p: rawptr, name: cstring) do (cast(^rawptr)p)^ = sdl.gl_get_proc_address(name); );
        gl.ClearColor(0.25, 0.25, 0.25, 1);

        imgui_state := init_imgui_state(window);

        running := true;
        e := sdl.Event{};
        for running {
            for sdl.poll_event(&e) != 0 {
                imgui_process_event(e, &imgui_state);
                #partial switch e.type {
                    case .Quit:
                        log.info("Got SDL_QUIT event!");
                        running = false;

                    case .Key_Down:
                        if is_key_down(e, .Escape) {
                            qe := sdl.Event{};
                            qe.type = .Quit;
                            sdl.push_event(&qe);
                        }
                }
            }

            new_frame(window, &imgui_state);
            imgui.new_frame();
            {
                imgui.show_demo_window();
            }
            imgui.render();

            io := imgui.get_io();
            gl.Viewport(0, 0, i32(io.display_size.x), i32(io.display_size.y));
            gl.Clear(gl.COLOR_BUFFER_BIT);
            imgui_render(imgui.get_draw_data(), imgui_state);
            sdl.gl_swap_window(window);
        }
        log.info("Shutting down...");
        
    } else {
        log.debugf("Error during SDL init: (%d)%s", init_err, sdl.get_error());
    }
}

is_key_down :: proc(e: sdl.Event, sc: sdl.Scancode) -> bool {
    return e.key.type == .Key_Down && e.key.keysym.scancode == sc;
}

//Draw_Callback_ResetRenderState :: imgui.Draw_Callback(rawptr(~uintptr(0)));

imgui_render :: proc(data: ^imgui.Draw_Data, state: Imgui_State) {
    state := state;
    fb_width  := data.display_size.x * data.framebuffer_scale.x;
    fb_height := data.display_size.y * data.framebuffer_scale.y;
    if fb_width <= 0 do return;
    if fb_height <= 0 do return;

    gl.GenVertexArrays(1, &state.vao_handle);
    defer gl.DeleteVertexArrays(1, &state.vao_handle);
    imgui_setup_render_state(data, state);
    lists := mem.slice_ptr(data.cmd_lists, int(data.cmd_lists_count));
    for list in lists {
        gl.BufferData(gl.ARRAY_BUFFER,         int(list.vtx_buffer.size) * size_of(imgui.Draw_Vert), list.vtx_buffer.data, gl.STREAM_DRAW);
        gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, int(list.idx_buffer.size) * size_of(imgui.Draw_Vert), list.idx_buffer.data, gl.STREAM_DRAW);

        cmds := mem.slice_ptr(list.cmd_buffer.data, int(list.cmd_buffer.size));
        for cmd, idx in cmds {
            if cmd.user_callback != nil {
                if false {
                //if cmd.user_callback == Draw_Callback_ResetRenderState {
                    imgui_setup_render_state(data, state);
                } else {
                    cmd.user_callback(list, &cmds[idx]);
                }
            } else {
                clip_off   := data.display_pos;
                clip_scale := data.framebuffer_scale;
                clip_rect := imgui.Vec4{};
                clip_rect.x = (cmd.clip_rect.x - clip_off.x) * clip_scale.x;
                clip_rect.y = (cmd.clip_rect.y - clip_off.y) * clip_scale.y;
                clip_rect.z = (cmd.clip_rect.z - clip_off.x) * clip_scale.x;
                clip_rect.w = (cmd.clip_rect.w - clip_off.y) * clip_scale.y;

                if (clip_rect.x < fb_width && 
                    clip_rect.y < fb_height && 
                    clip_rect.z >= 0 && 
                    clip_rect.w >= 0) {
                    gl.Scissor(i32(clip_rect.x), 
                               i32(fb_height - clip_rect.w), 
                               i32(clip_rect.z - clip_rect.x), 
                               i32(clip_rect.w - clip_rect.y));
                    gl.BindTexture(gl.TEXTURE_2D, u32(uintptr(cmd.texture_id)));
                    gl.DrawElements(gl.TRIANGLES, 
                                    i32(cmd.elem_count), 
                                    gl.UNSIGNED_SHORT, 
                                    rawptr(uintptr(cmd.idx_offset * size_of(imgui.Draw_Idx))));
                }
            }
        }
    }
}

imgui_setup_render_state :: proc(data: ^imgui.Draw_Data, state: Imgui_State) {
    gl.Enable(gl.BLEND);
    gl.BlendEquation(gl.FUNC_ADD);
    gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    gl.Disable(gl.CULL_FACE);
    gl.Disable(gl.DEPTH_TEST);
    gl.Enable(gl.SCISSOR_TEST);

    fb_width  := data.display_size.x * data.framebuffer_scale.x;
    fb_height := data.display_size.y * data.framebuffer_scale.y;
    gl.Viewport(0, 0, i32(fb_width), i32(fb_height));
    l := data.display_pos.x;
    r := data.display_pos.x + data.display_size.x;
    t := data.display_pos.y;
    b := data.display_pos.y + data.display_size.y;
    ortho_projection := [4][4]f32
    {
        { 2.0/(r-l),   0.0,          0.0, 0.0 },
        { 0.0,         2.0/(t-b),    0.0, 0.0 },
        { 0.0,         0.0,         -1.0, 0.0 },
        { (r+l)/(l-r), (t+b)/(b-t),  0.0, 1.0 },
    };
    gl.UseProgram(state.shader_program);
    gl.Uniform1i(state.uniform_tex, 0);
    gl.UniformMatrix4fv(state.uniform_proj_mtx, 1, gl.FALSE, &ortho_projection[0][0]);

    gl.BindVertexArray(state.vao_handle);
    gl.BindBuffer(gl.ARRAY_BUFFER, state.vbo_handle);
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, state.elements_handle);

    gl.EnableVertexAttribArray(u32(state.attrib_vtx_pos));
    gl.EnableVertexAttribArray(u32(state.attrib_vtx_uv));
    gl.EnableVertexAttribArray(u32(state.attrib_vtx_color));
    gl.VertexAttribPointer(u32(state.attrib_vtx_pos),   2, gl.FLOAT,         gl.FALSE, size_of(imgui.Draw_Vert), rawptr(offset_of(imgui.Draw_Vert, pos)));
    gl.VertexAttribPointer(u32(state.attrib_vtx_uv),    2, gl.FLOAT,         gl.FALSE, size_of(imgui.Draw_Vert), rawptr(offset_of(imgui.Draw_Vert, uv)));
    gl.VertexAttribPointer(u32(state.attrib_vtx_color), 4, gl.UNSIGNED_BYTE, gl.TRUE,  size_of(imgui.Draw_Vert), rawptr(offset_of(imgui.Draw_Vert, col)));
}

Imgui_State :: struct {
    // Per frame stuff
    mouse_down: [3]bool,

    // OpenGL stuff
    shader_program: u32,
    
    uniform_tex:       i32,
    uniform_proj_mtx:  i32,

    attrib_vtx_pos:   i32,
    attrib_vtx_uv:    i32,
    attrib_vtx_color: i32,

    vao_handle:      u32,
    vbo_handle:      u32,
    elements_handle: u32,
}

init_imgui_state :: proc(window: ^sdl.Window) -> Imgui_State {
    using res := Imgui_State{};

    //////////////////////
    // ImGUI Stuff
    imgui.create_context();
    imgui.style_colors_dark();

    io := imgui.get_io();

    io.key_map[imgui.Key.Tab]         = i32(sdl.Scancode.Tab);
    io.key_map[imgui.Key.LeftArrow]   = i32(sdl.Scancode.Left);
    io.key_map[imgui.Key.RightArrow]  = i32(sdl.Scancode.Right);
    io.key_map[imgui.Key.UpArrow]     = i32(sdl.Scancode.Up);
    io.key_map[imgui.Key.DownArrow]   = i32(sdl.Scancode.Down);
    io.key_map[imgui.Key.PageUp]      = i32(sdl.Scancode.Page_Up);
    io.key_map[imgui.Key.PageDown]    = i32(sdl.Scancode.Page_Down);
    io.key_map[imgui.Key.Home]        = i32(sdl.Scancode.Home);
    io.key_map[imgui.Key.End]         = i32(sdl.Scancode.End);
    io.key_map[imgui.Key.Insert]      = i32(sdl.Scancode.Insert);
    io.key_map[imgui.Key.Delete]      = i32(sdl.Scancode.Delete);
    io.key_map[imgui.Key.Backspace]   = i32(sdl.Scancode.Backspace);
    io.key_map[imgui.Key.Space]       = i32(sdl.Scancode.Space);
    io.key_map[imgui.Key.Enter]       = i32(sdl.Scancode.Return);
    io.key_map[imgui.Key.Escape]      = i32(sdl.Scancode.Escape);
    io.key_map[imgui.Key.KeyPadEnter] = i32(sdl.Scancode.Kp_Enter);
    io.key_map[imgui.Key.A]           = i32(sdl.Scancode.A);
    io.key_map[imgui.Key.C]           = i32(sdl.Scancode.C);
    io.key_map[imgui.Key.V]           = i32(sdl.Scancode.V);
    io.key_map[imgui.Key.X]           = i32(sdl.Scancode.X);
    io.key_map[imgui.Key.Y]           = i32(sdl.Scancode.Y);
    io.key_map[imgui.Key.Z]           = i32(sdl.Scancode.Z);

    update_imgui_size(window);

    //////////////////////
    // Renderer stuff
    shader_program = setup_imgui_shaders();

    uniform_tex      = gl.GetUniformLocation(shader_program, "Texture");
    uniform_proj_mtx = gl.GetUniformLocation(shader_program, "ProjMtx");

    attrib_vtx_pos   = gl.GetAttribLocation(shader_program, "Position");
    attrib_vtx_uv    = gl.GetAttribLocation(shader_program, "UV");
    attrib_vtx_color = gl.GetAttribLocation(shader_program, "Color");

    gl.GenBuffers(1, &vbo_handle);
    gl.GenBuffers(1, &elements_handle);

    //////////////////////
    // Font stuff
    pixels: ^u8;
    width, height: i32;
    imgui.font_atlas_get_tex_data_as_rgba32(io.fonts, &pixels, &width, &height);
    font_tex_h: u32;
    gl.GenTextures(1, &font_tex_h);
    gl.BindTexture(gl.TEXTURE_2D, font_tex_h);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, pixels);
    io.fonts.tex_id = imgui.Texture_ID(uintptr(font_tex_h));

    return res;
}

new_frame :: proc(window: ^sdl.Window, state: ^Imgui_State) {
    io := imgui.get_io();
    update_imgui_size(window);
    io.mouse_pos = imgui.Vec2{min(f32), min(f32)};

    mx, my: i32;
    buttons := sdl.get_mouse_state(&mx, &my);
    io.mouse_down[0] = state.mouse_down[0] || (buttons & u32(sdl.Mousecode.Left))   != 0;
    io.mouse_down[1] = state.mouse_down[1] || (buttons & u32(sdl.Mousecode.Right))  != 0;
    io.mouse_down[2] = state.mouse_down[2] || (buttons & u32(sdl.Mousecode.Middle)) != 0;
    state.mouse_down[0] = false;
    state.mouse_down[1] = false;
    state.mouse_down[2] = false;

    if sdl.get_keyboard_focus() == window {
        io.mouse_pos = imgui.Vec2{f32(mx), f32(my)};
    }
}

update_imgui_size :: proc(window: ^sdl.Window) {
    w, h, display_h, display_w: i32;
    sdl.get_window_size(window, &w, &h);
    if sdl.get_window_flags(window) & u32(sdl.Window_Flags.Minimized) != 0 {
        w = 0;
        h = 0;
    }
    sdl.gl_get_drawable_size(window, &display_w, &display_h);

    io := imgui.get_io();
    io.display_size = imgui.Vec2{f32(w), f32(h)};
    if w > 0 && h > 0 {
        io.display_framebuffer_scale = imgui.Vec2{f32(display_w / w), f32(display_h / h)};
    }
}

imgui_process_event :: proc(e: sdl.Event, imgui_state: ^Imgui_State) {
    #partial switch e.type {
        case .Window_Event: {
            #partial switch e.window.event {
                case .Size_Changed, .Resized: {
                    log.debugf("{}x{}", e.window.data1, e.window.data2);
                }
            }
        }

        case .Mouse_Wheel: {
            io := imgui.get_io();
            if e.wheel.x > 0 do io.mouse_wheel_h += 1;
            if e.wheel.x < 0 do io.mouse_wheel_h -= 1;
            if e.wheel.y > 0 do io.mouse_wheel   += 1;
            if e.wheel.y < 0 do io.mouse_wheel   -= 1;
        }

        case .Text_Input: {
            io := imgui.get_io();
            //TODO(Hoej): Write imgui wrapper first
            //imgui.io_add_input_characters_utf8(io, e.text.text);
        }

        case .Mouse_Button_Down: {
            io := imgui.get_io();
            //TODO(Hoej): Not sure this is correct
            if e.button.button == u8(sdl.Mousecode.Left)   do imgui_state.mouse_down[0] = true;
            if e.button.button == u8(sdl.Mousecode.Right)  do imgui_state.mouse_down[1] = true;
            if e.button.button == u8(sdl.Mousecode.Middle) do imgui_state.mouse_down[2] = true;
        }

        case .Key_Down, .Key_Up: {
            io := imgui.get_io();
            sc := e.key.keysym.scancode;
            io.keys_down[sc] = e.type == .Key_Down;
            io.key_shift = sdl.get_mod_state() & (sdl.Keymod.LShift|sdl.Keymod.RShift) != nil;
            io.key_ctrl  = sdl.get_mod_state() & (sdl.Keymod.LCtrl|sdl.Keymod.RCtrl)   != nil;
            io.key_alt   = sdl.get_mod_state() & (sdl.Keymod.LAlt|sdl.Keymod.RAlt)     != nil;
        }
    }
}

compile_shader :: proc(kind: u32, shader_src: string) -> u32 {
    h := gl.CreateShader(kind);
    data := cast(^u8)strings.clone_to_cstring(shader_src, context.temp_allocator);
    gl.ShaderSource(h, 1, &data, nil);
    gl.CompileShader(h);
    ok: i32;
    gl.GetShaderiv(h, gl.COMPILE_STATUS, &ok);
    if ok != gl.TRUE {
        log.errorf("Unable to compile shader: {}", h);
        return 0;
    }

    return h;
}

setup_imgui_shaders :: proc() -> u32 {
    vert_h := compile_shader(gl.VERTEX_SHADER, vert_shader_src);
    frag_h := compile_shader(gl.FRAGMENT_SHADER, frag_shader_src);

    program_h := gl.CreateProgram();
    gl.AttachShader(program_h, frag_h);
    gl.AttachShader(program_h, vert_h);
    gl.LinkProgram(program_h);
    
    ok: i32;
    gl.GetProgramiv(program_h, gl.LINK_STATUS, &ok);
    if ok != gl.TRUE {
        log.errorf("Error linking program: {}", program_h);
    }

    return program_h;
}

frag_shader_src :: `
#version 450
in vec2 Frag_UV;
in vec4 Frag_Color;
uniform sampler2D Texture;
layout (location = 0) out vec4 Out_Color;
void main()
{
    Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
}
`;

vert_shader_src :: `
#version 450
layout (location = 0) in vec2 Position;
layout (location = 1) in vec2 UV;
layout (location = 2) in vec4 Color;
uniform mat4 ProjMtx;
out vec2 Frag_UV;
out vec4 Frag_Color;
void main()
{
    Frag_UV = UV;
    Frag_Color = Color;
    gl_Position = ProjMtx * vec4(Position.xy,0,1);
}
`;
