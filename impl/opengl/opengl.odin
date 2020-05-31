package imgui_impl_opengl;

import "core:mem";
import "core:log";
import "core:strings";

import gl  "shared:odin-gl";

import imgui "../..";

OpenGL_State :: struct {
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

OpenGL_Backup_State :: struct {
    last_active_texture: i32,
    last_program:        i32,
    last_texture:        i32,
    last_array_buffer:   i32,
    last_vao:            i32,

    last_polygon_mode: [2]i32,
    last_viewport:     [4]i32,
    last_scissor_box:  [4]i32,

    last_blend_src_rgb:        i32,
    last_blend_dst_rgb:        i32,
    last_blend_src_alpha:      i32,
    last_blend_dst_alpha:      i32,
    last_blend_equation_rgb:   i32,
    last_blend_equation_alpha: i32,

    last_enabled_blend:       bool,
    last_enable_cull_face:    bool,
    last_enable_depth_test:   bool,
    last_enable_scissor_test: bool,
}

setup_state :: proc(using state: ^OpenGL_State) {
    io := imgui.get_io();
    io.backend_renderer_name = "OpenGL";
    io.backend_flags |= .RendererHasVtxOffset;
    
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
}

imgui_render :: proc(data: ^imgui.Draw_Data, state: OpenGL_State) {
    state := state;
    fb_width  := data.display_size.x * data.framebuffer_scale.x;
    fb_height := data.display_size.y * data.framebuffer_scale.y;
    if fb_width <= 0 do return;
    if fb_height <= 0 do return;

    opengl_backup := OpenGL_Backup_State{};
    backup_opengl_state(&opengl_backup);
    defer restore_opengl_state(opengl_backup);

    gl.GenVertexArrays(1, &state.vao_handle);
    defer gl.DeleteVertexArrays(1, &state.vao_handle);
    imgui_setup_render_state(data, state);
    lists := mem.slice_ptr(data.cmd_lists, int(data.cmd_lists_count));
    for list in lists {
        gl.BufferData(gl.ARRAY_BUFFER,         int(list.vtx_buffer.size) * size_of(imgui.Draw_Vert), list.vtx_buffer.data, gl.STREAM_DRAW);
        gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, int(list.idx_buffer.size) * size_of(imgui.Draw_Idx),  list.idx_buffer.data, gl.STREAM_DRAW);

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
                    //glDrawElementsBaseVertex(GL_TRIANGLES, (GLsizei)pcmd->ElemCount, sizeof(ImDrawIdx) == 2 ? GL_UNSIGNED_SHORT : GL_UNSIGNED_INT, (void*)(intptr_t)(pcmd->IdxOffset * sizeof(ImDrawIdx)), (GLint)pcmd->VtxOffset);
                    gl.DrawElementsBaseVertex(gl.TRIANGLES, i32(cmd.elem_count), gl.UNSIGNED_SHORT, rawptr(uintptr(cmd.idx_offset * size_of(imgui.Draw_Idx))), i32(cmd.vtx_offset));
                    gl.DrawElements(gl.TRIANGLES, 
                                    i32(cmd.elem_count), 
                                    gl.UNSIGNED_SHORT, 
                                    rawptr(uintptr(cmd.idx_offset * size_of(imgui.Draw_Idx))));
                }
            }
        }
    }
}

imgui_setup_render_state :: proc(data: ^imgui.Draw_Data, state: OpenGL_State) {
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

backup_opengl_state :: proc(state: ^OpenGL_Backup_State) {
    gl.GetIntegerv(gl.ACTIVE_TEXTURE, &state.last_active_texture);
    gl.ActiveTexture(gl.TEXTURE0);
    gl.GetIntegerv(gl.CURRENT_PROGRAM, &state.last_program);
    gl.GetIntegerv(gl.TEXTURE_BINDING_2D, &state.last_texture);
    gl.GetIntegerv(gl.ARRAY_BUFFER_BINDING, &state.last_array_buffer);
    gl.GetIntegerv(gl.VERTEX_ARRAY_BINDING, &state.last_vao);

    gl.GetIntegerv(gl.POLYGON_MODE, &state.last_polygon_mode[0]);
    gl.GetIntegerv(gl.VIEWPORT, &state.last_viewport[0]);
    gl.GetIntegerv(gl.SCISSOR_BOX, &state.last_scissor_box[0]);

    gl.GetIntegerv(gl.BLEND_SRC_RGB, &state.last_blend_src_rgb);
    gl.GetIntegerv(gl.BLEND_DST_RGB, &state.last_blend_dst_rgb);
    gl.GetIntegerv(gl.BLEND_SRC_ALPHA, &state.last_blend_src_alpha);
    gl.GetIntegerv(gl.BLEND_DST_ALPHA, &state.last_blend_dst_alpha);
    gl.GetIntegerv(gl.BLEND_EQUATION_RGB, &state.last_blend_equation_rgb);
    gl.GetIntegerv(gl.BLEND_EQUATION_ALPHA, &state.last_blend_equation_alpha);

    state.last_enabled_blend = gl.IsEnabled(gl.BLEND) != 0;
    state.last_enable_cull_face = gl.IsEnabled(gl.CULL_FACE) != 0;
    state.last_enable_depth_test = gl.IsEnabled(gl.DEPTH_TEST) != 0;
    state.last_enable_scissor_test = gl.IsEnabled(gl.SCISSOR_TEST) != 0;
}

restore_opengl_state :: proc(state: OpenGL_Backup_State) {
    gl.UseProgram(u32(state.last_program));
    gl.BindTexture(gl.TEXTURE_2D, u32(state.last_texture));
    gl.ActiveTexture(u32(state.last_active_texture));
    gl.BindVertexArray(u32(state.last_vao));
    gl.BindBuffer(gl.ARRAY_BUFFER, u32(state.last_array_buffer));

    gl.BlendEquationSeparate(u32(state.last_blend_equation_rgb), u32(state.last_blend_equation_alpha));
    gl.BlendFuncSeparate(u32(state.last_blend_src_rgb), 
                         u32(state.last_blend_dst_rgb), 
                         u32(state.last_blend_src_alpha), 
                         u32(state.last_blend_dst_alpha));

    if state.last_enabled_blend       do gl.Enable(gl.BLEND)        else do gl.Disable(gl.BLEND);
    if state.last_enable_cull_face    do gl.Enable(gl.CULL_FACE)    else do gl.Disable(gl.CULL_FACE);
    if state.last_enable_depth_test   do gl.Enable(gl.DEPTH_TEST)   else do gl.Disable(gl.DEPTH_TEST);
    if state.last_enable_scissor_test do gl.Enable(gl.SCISSOR_TEST) else do gl.Disable(gl.SCISSOR_TEST);

    gl.PolygonMode(gl.FRONT_AND_BACK, u32(state.last_polygon_mode[0]));
    gl.Viewport(state.last_viewport[0],   state.last_viewport[1],    state.last_viewport[2],    state.last_viewport[2]);
    gl.Scissor(state.last_scissor_box[0], state.last_scissor_box[1], state.last_scissor_box[2], state.last_scissor_box[2]);
}

@(private="package")
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

@(private="package")
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

@(private="package")
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

@(private="package")
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
