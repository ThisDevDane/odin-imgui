package imgui_impl_glfw

import "core:runtime"
import "core:strings"
import glfw "shared:odin-glfw"

import imgui "../..";

@private
state: GLFW_State;

GLFW_State :: struct {
    window: glfw.Window_Handle,
    time: f64,
    mouse_just_pressed: [imgui.Mouse_Button.Count]bool,
    mouse_cursors: [imgui.Mouse_Cursor.Count]glfw.Cursor_Handle,
    installed_callbacks: bool,
    prev_user_callback_mouse_button: glfw.Mouse_Button_Proc,
    prev_user_callback_scroll: glfw.Scroll_Proc,
    prev_user_callback_key: glfw.Key_Proc,
    prev_user_callback_char: glfw.Char_Proc,
}

setup_state :: proc(window: glfw.Window_Handle, install_callbacks: bool) {
    state.window = window;
    state.time = 0.0;

    io := imgui.get_io();
    io.backend_flags |= .HasMouseCursors;
    io.backend_flags |= .HasSetMousePos;
    io.backend_platform_name = "GLFW";

    io.key_map[imgui.Key.Tab]         = i32(glfw.KEY_TAB);
    io.key_map[imgui.Key.LeftArrow]   = i32(glfw.KEY_LEFT);
    io.key_map[imgui.Key.RightArrow]  = i32(glfw.KEY_RIGHT);
    io.key_map[imgui.Key.UpArrow]     = i32(glfw.KEY_UP);
    io.key_map[imgui.Key.DownArrow]   = i32(glfw.KEY_DOWN);
    io.key_map[imgui.Key.PageUp]      = i32(glfw.KEY_PAGE_UP);
    io.key_map[imgui.Key.PageDown]    = i32(glfw.KEY_PAGE_DOWN);
    io.key_map[imgui.Key.Home]        = i32(glfw.KEY_HOME);
    io.key_map[imgui.Key.End]         = i32(glfw.KEY_END);
    io.key_map[imgui.Key.Insert]      = i32(glfw.KEY_INSERT);
    io.key_map[imgui.Key.Delete]      = i32(glfw.KEY_DELETE);
    io.key_map[imgui.Key.Backspace]   = i32(glfw.KEY_BACKSPACE);
    io.key_map[imgui.Key.Space]       = i32(glfw.KEY_SPACE);
    io.key_map[imgui.Key.Enter]       = i32(glfw.KEY_ENTER);
    io.key_map[imgui.Key.Escape]      = i32(glfw.KEY_ESCAPE);
    io.key_map[imgui.Key.KeyPadEnter] = i32(glfw.KEY_KP_ENTER);
    io.key_map[imgui.Key.A]           = i32(glfw.KEY_A);
    io.key_map[imgui.Key.C]           = i32(glfw.KEY_C);
    io.key_map[imgui.Key.V]           = i32(glfw.KEY_V);
    io.key_map[imgui.Key.X]           = i32(glfw.KEY_X);
    io.key_map[imgui.Key.Y]           = i32(glfw.KEY_Y);
    io.key_map[imgui.Key.Z]           = i32(glfw.KEY_Z);

    io.get_clipboard_text_fn = get_clipboard_text;
    io.set_clipboard_text_fn = set_clipboard_text;
    io.clipboard_user_data = state.window;

    when ODIN_OS == "windows" {
        io.ime_window_handle = rawptr(glfw.get_win32_window(state.window));
    }

    prev_error_callback: glfw.Error_Proc = glfw.set_error_callback(nil);

    state.mouse_cursors[imgui.Mouse_Cursor.Arrow]      = glfw.create_standard_cursor(glfw.ARROW_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.TextInput]  = glfw.create_standard_cursor(glfw.IBEAM_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.ResizeNs]   = glfw.create_standard_cursor(glfw.VRESIZE_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.ResizeEw]   = glfw.create_standard_cursor(glfw.HRESIZE_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.Hand]       = glfw.create_standard_cursor(glfw.HAND_CURSOR);

    /* GLFW 3.4 cursors (not supported by odin-glfw yet)
    state.mouse_cursors[imgui.Mouse_Cursor.ResizeAll]  = glfw.create_standard_cursor(glfw.RESIZE_ALL_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.ResizeNESW] = glfw.create_standard_cursor(glfw.RESIZE_NESW_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.ResizeNWSE] = glfw.create_standard_cursor(glfw.RESIZE_NWSE_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.NotAllowed] = glfw.create_standard_cursor(glfw.NOT_ALLOWED_CURSOR);
    */
    state.mouse_cursors[imgui.Mouse_Cursor.ResizeAll]  = glfw.create_standard_cursor(glfw.ARROW_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.ResizeNesw] = glfw.create_standard_cursor(glfw.ARROW_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.ResizeNwse] = glfw.create_standard_cursor(glfw.ARROW_CURSOR);
    state.mouse_cursors[imgui.Mouse_Cursor.NotAllowed] = glfw.create_standard_cursor(glfw.ARROW_CURSOR);

    glfw.set_error_callback(prev_error_callback);

    state.prev_user_callback_mouse_button = nil;
    state.prev_user_callback_scroll       = nil;
    state.prev_user_callback_key          = nil;
    state.prev_user_callback_char         = nil;
    if (install_callbacks)
    {
        state.installed_callbacks = true;
        state.prev_user_callback_mouse_button = glfw.set_mouse_button_callback(window, mouse_button_callback);
        state.prev_user_callback_scroll       = glfw.set_scroll_callback(window, scroll_callback);
        state.prev_user_callback_key          = glfw.set_key_callback(window, key_callback);
        state.prev_user_callback_char         = glfw.set_char_callback(window, char_callback);
    }
}

update_mouse :: proc() {
    io := imgui.get_io();

    for i in 0..<len(io.mouse_down) {
        io.mouse_down[i] = state.mouse_just_pressed[i] || glfw.get_mouse_button(state.window, glfw.Mouse_Button(i)) != .RELEASE;
        state.mouse_just_pressed[i] = false;
    }

    mouse_pos_backup := io.mouse_pos;
    io.mouse_pos = { min(f32), min(f32) };

    if glfw.get_window_attrib(state.window, .FOCUSED) != 0 {
        if io.want_set_mouse_pos {
            glfw.set_cursor_pos(state.window, f64(mouse_pos_backup.x), f64(mouse_pos_backup.y));
        } else {
            x, y := glfw.get_cursor_pos(state.window);
            io.mouse_pos = { f32(x), f32(y) };
        }
    }

    if io.config_flags & .NoMouseCursorChange != .NoMouseCursorChange {
        desired_cursor := imgui.get_mouse_cursor();
        if(io.mouse_draw_cursor || desired_cursor == .None) {
            glfw.set_input_mode(state.window, .CURSOR, int(glfw.CURSOR_HIDDEN));
        } else {
            new_cursor: glfw.Cursor_Handle;
            if state.mouse_cursors[desired_cursor] != nil {
                new_cursor = state.mouse_cursors[desired_cursor];
            } else {
                new_cursor = state.mouse_cursors[imgui.Mouse_Cursor.Arrow];
            }
            glfw.set_cursor(state.window, new_cursor);
            glfw.set_input_mode(state.window, .CURSOR, int(glfw.CURSOR_NORMAL));
        }
    }
}

update_display_size :: proc() {
    w, h := glfw.get_window_size(state.window);
    io := imgui.get_io();
    io.display_size = { f32(w), f32(h) };
    if w > 0 && h > 0 {
        display_w, display_h := glfw.get_framebuffer_size(state.window);
        io.display_framebuffer_scale = { f32(display_w) / f32(w), f32(display_h) / f32(h) };
    }
}

update_dt :: proc() {
    io := imgui.get_io();
    now := glfw.get_time();
    io.delta_time = state.time > 0.0 ? f32(now - state.time) : f32(1.0/60.0);
    state.time = now;
}

@private
get_clipboard_text :: proc "c" (user_data: rawptr) -> cstring
{
    context = runtime.default_context();
    s := glfw.get_clipboard_string(glfw.Window_Handle(user_data));
    return strings.unsafe_string_to_cstring(s);
}

@private
set_clipboard_text :: proc "c" (user_data: rawptr, text: cstring)
{
    context = runtime.default_context();
    glfw.set_clipboard_string(glfw.Window_Handle(user_data), string(text));
}

@private
key_callback :: proc "c" (window: glfw.Window_Handle, key, scancode, action, mods: i32) {
    context = runtime.default_context();

    if (state.prev_user_callback_key != nil) {
        state.prev_user_callback_key(window, key, scancode, action, mods);
    }

    io := imgui.get_io();

    if      action == i32(glfw.PRESS)   do io.keys_down[key] = true;
    else if action == i32(glfw.RELEASE) do io.keys_down[key] = false;

    io.key_ctrl  = io.keys_down[glfw.KEY_LEFT_CONTROL] || io.keys_down[glfw.KEY_RIGHT_CONTROL];
    io.key_shift = io.keys_down[glfw.KEY_LEFT_SHIFT] || io.keys_down[glfw.KEY_RIGHT_SHIFT];
    io.key_alt   = io.keys_down[glfw.KEY_LEFT_ALT] || io.keys_down[glfw.KEY_RIGHT_ALT];

    when ODIN_OS == "windows" {
        io.key_super = false;
    } else {
        io.key_super = io.keys_down[glfw.KEY_LEFT_SUPER] || io.keys_down[glfw.KEY_RIGHT_SUPER];
    }
}

@private
mouse_button_callback :: proc "c" (window: glfw.Window_Handle, button, action, mods: i32) {
    context = runtime.default_context();

    if (state.prev_user_callback_mouse_button != nil) {
        state.prev_user_callback_mouse_button(window, button, action, mods);
    }

    if action == i32(glfw.PRESS) && button >= 0 && button < len(state.mouse_just_pressed) {
        state.mouse_just_pressed[button] = true;
    }
}

@private
scroll_callback :: proc "c" (window: glfw.Window_Handle, xoffset, yoffset: f64) {
    context = runtime.default_context();

    if (state.prev_user_callback_scroll != nil) {
        state.prev_user_callback_scroll(window, xoffset, yoffset);
    }

    io := imgui.get_io();
    io.mouse_wheel_h += f32(xoffset);
    io.mouse_wheel   += f32(yoffset);
}

@private
char_callback :: proc "c" (window: glfw.Window_Handle, codepoint: rune) {
    context = runtime.default_context();

    if (state.prev_user_callback_char != nil) {
        state.prev_user_callback_char(window, codepoint);
    }

    imgui.io_add_input_character(imgui.get_io(), u32(codepoint));
}
