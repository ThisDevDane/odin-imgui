package main

import "core:log"
import "core:runtime"
import "core:strings"

import gl   "vendor:OpenGL"
import "vendor:glfw"

DESIRED_GL_MAJOR_VERSION :: 4;
DESIRED_GL_MINOR_VERSION :: 5;

import imgui  "../..";
import imgl   "../../impl/opengl";
import imglfw "../../impl/glfw";

show_demo_window := false;

main :: proc() {
    context.logger = get_logger();

    if !bool(glfw.Init()) {
        desc, err := glfw.GetError();
        log.error("GLFW init failed:", err, desc);
        return;
    }
    defer glfw.Terminate();

    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, DESIRED_GL_MAJOR_VERSION);
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, DESIRED_GL_MINOR_VERSION);
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE);
    glfw.WindowHint(glfw.DOUBLEBUFFER, 1);
    glfw.WindowHint(glfw.DEPTH_BITS, 24);
    glfw.WindowHint(glfw.STENCIL_BITS, 8);
    window := glfw.CreateWindow(1280, 720, "odin-imgui GLFW+OpenGL example", nil, nil);
    if window == nil {
        desc, err := glfw.GetError();
        log.error("GLFW window creation failed:", err, desc);
        return;
    }
    defer glfw.DestroyWindow(window);

    glfw.SetErrorCallback(error_callback);
    glfw.SetKeyCallback(window, key_callback);

    glfw.MakeContextCurrent(window);
    glfw.SwapInterval(1);

    gl.load_up_to(DESIRED_GL_MAJOR_VERSION, DESIRED_GL_MINOR_VERSION, glfw.gl_set_proc_address);
    gl.ClearColor(0.25, 0.25, 0.25, 1);

    imgui_state := init_imgui_state(window);
    io := imgui.get_io();

    running := true;
    for !glfw.WindowShouldClose(window) {

        imgui_new_frame();
        imgui.new_frame();
        {
            info_overlay();

            if show_demo_window do imgui.show_demo_window(&show_demo_window);
            text_test_window();
            input_text_test_window();
            misc_test_window();
            combo_test_window();
        }
        imgui.render();

        gl.Viewport(0, 0, i32(io.display_size.x), i32(io.display_size.y));
        gl.Scissor(0, 0, i32(io.display_size.x), i32(io.display_size.y));
        gl.Clear(gl.COLOR_BUFFER_BIT);
        imgl.imgui_render(imgui.get_draw_data(), imgui_state.opengl_state);

        glfw.SwapBuffers(window);
        glfw.PollEvents();
    }
}

get_logger :: proc() -> log.Logger {
    logger_opts := log.Options {
        .Level,
        .Line,
        .Procedure,
    };
    return log.create_console_logger(opt = logger_opts);
}

key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
    context = runtime.default_context();

    if action == glfw.PRESS {
        switch key {
        case glfw.KEY_ESCAPE:
            glfw.SetWindowShouldClose(window, true);
        case glfw.KEY_TAB:
            io := imgui.get_io();
            if io.want_capture_keyboard == false {
                show_demo_window = true;
            }
        }
    }
}

error_callback :: proc "c" (error: i32, description: cstring) {
    context = runtime.default_context();
    context.logger = get_logger();
    log.error("GLFW error:", error, description);
}

info_overlay :: proc() {
    imgui.set_next_window_pos(imgui.Vec2{10, 10});
    imgui.set_next_window_bg_alpha(0.2);
    overlay_flags: imgui.Window_Flags = .NoDecoration |
                                        .AlwaysAutoResize |
                                        .NoSavedSettings |
                                        .NoFocusOnAppearing |
                                        .NoNav |
                                        .NoMove;
    imgui.begin("Info", nil, overlay_flags);
    imgui.text_unformatted("Press Esc to close the application");
    imgui.text_unformatted("Press Tab to show demo window");
    imgui.end();
}

text_test_window :: proc() {
    imgui.begin("Text test");
    imgui.text("NORMAL TEXT: {}", 1);
    imgui.text_colored(imgui.Vec4{1, 0, 0, 1}, "COLORED TEXT: {}", 2);
    imgui.text_disabled("DISABLED TEXT: {}", 3);
    imgui.text_unformatted("UNFORMATTED TEXT");
    imgui.text_wrapped("WRAPPED TEXT: {}", 4);
    imgui.end();
}

input_text_test_window :: proc() {
    imgui.begin("Input text test");
    @static buf: [256]u8;
    @static ok := false;
    imgui.input_text("Test input", buf[:]);
    imgui.input_text("Test password input", buf[:], .Password);
    if imgui.input_text("Test returns true input", buf[:], .EnterReturnsTrue) {
        ok = !ok;
    }
    imgui.checkbox("OK?", &ok);
    imgui.text_wrapped("Buf content: %s", string(buf[:]));
    imgui.end();
}

misc_test_window :: proc() {
    imgui.begin("Misc tests");
    pos := imgui.get_window_pos();
    size := imgui.get_window_size();
    imgui.text("pos: {}", pos);
    imgui.text("size: {}", size);
    imgui.end();
}

combo_test_window :: proc() {
    imgui.begin("Combo tests");
    @static items := []string {"1", "2", "3"};
    @static curr_1 := i32(0);
    @static curr_2 := i32(1);
    @static curr_3 := i32(2);
    if imgui.begin_combo("begin combo", items[curr_1]) {
        for item, idx in items {
            is_selected := idx == int(curr_1);
            if imgui.selectable(item, is_selected) {
                curr_1 = i32(idx);
            }

            if is_selected {
                imgui.set_item_default_focus();
            }
        }
        defer imgui.end_combo();
    }

    imgui.combo_str_arr("combo str arr", &curr_2, items);

    item_getter : imgui.Items_Getter_Proc : proc "c" (data: rawptr, idx: i32, out_text: ^cstring) -> bool {
        context = runtime.default_context();
        items := (cast(^[]string)data);
        out_text^ = strings.clone_to_cstring(items[idx], context.temp_allocator);
        return true;
    }

    imgui.combo_fn_bool_ptr("combo fn ptr", &curr_3, item_getter, &items, i32(len(items)));

    imgui.end();
}

Imgui_State :: struct {
    opengl_state: imgl.OpenGL_State,
}

init_imgui_state :: proc(window: glfw.WindowHandle) -> Imgui_State {
    res := Imgui_State{};

    imgui.create_context();
    imgui.style_colors_dark();

    imglfw.setup_state(window, true);

    imgl.setup_state(&res.opengl_state);

    return res;
}

imgui_new_frame :: proc() {
    imglfw.update_display_size();
    imglfw.update_mouse();
    imglfw.update_dt();
}
