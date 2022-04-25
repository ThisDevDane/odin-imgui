package imgui_impl_sdl;

import "core:runtime";
import "core:fmt";

import sdl "vendor:sdl2";

import imgui "../..";

SDL_State :: struct {
    time: u64,
    mouse_down: [3]bool,
    cursor_handles: [imgui.Mouse_Cursor.Count]^sdl.Cursor,
}

setup_state :: proc(using state: ^SDL_State) {
    io := imgui.get_io();
    io.backend_platform_name = "SDL";
    io.backend_flags |= .HasMouseCursors;

    io.key_map[imgui.Key.Tab]         = i32(sdl.Scancode.TAB);
    io.key_map[imgui.Key.LeftArrow]   = i32(sdl.Scancode.LEFT);
    io.key_map[imgui.Key.RightArrow]  = i32(sdl.Scancode.RIGHT);
    io.key_map[imgui.Key.UpArrow]     = i32(sdl.Scancode.UP);
    io.key_map[imgui.Key.DownArrow]   = i32(sdl.Scancode.DOWN);
    io.key_map[imgui.Key.PageUp]      = i32(sdl.Scancode.PAGEUP);
    io.key_map[imgui.Key.PageDown]    = i32(sdl.Scancode.PAGEDOWN);
    io.key_map[imgui.Key.Home]        = i32(sdl.Scancode.HOME);
    io.key_map[imgui.Key.End]         = i32(sdl.Scancode.END);
    io.key_map[imgui.Key.Insert]      = i32(sdl.Scancode.INSERT);
    io.key_map[imgui.Key.Delete]      = i32(sdl.Scancode.DELETE);
    io.key_map[imgui.Key.Backspace]   = i32(sdl.Scancode.BACKSPACE);
    io.key_map[imgui.Key.Space]       = i32(sdl.Scancode.SPACE);
    io.key_map[imgui.Key.Enter]       = i32(sdl.Scancode.RETURN);
    io.key_map[imgui.Key.Escape]      = i32(sdl.Scancode.ESCAPE);
    io.key_map[imgui.Key.KeyPadEnter] = i32(sdl.Scancode.KP_ENTER);
    io.key_map[imgui.Key.A]           = i32(sdl.Scancode.A);
    io.key_map[imgui.Key.C]           = i32(sdl.Scancode.C);
    io.key_map[imgui.Key.V]           = i32(sdl.Scancode.V);
    io.key_map[imgui.Key.X]           = i32(sdl.Scancode.X);
    io.key_map[imgui.Key.Y]           = i32(sdl.Scancode.Y);
    io.key_map[imgui.Key.Z]           = i32(sdl.Scancode.Z);

    io.get_clipboard_text_fn = get_clipboard_text;
    io.set_clipboard_text_fn = set_clipboard_text;
    
    cursor_handles[imgui.Mouse_Cursor.Arrow]      = sdl.CreateSystemCursor(sdl.SystemCursor.ARROW);
    cursor_handles[imgui.Mouse_Cursor.TextInput]  = sdl.CreateSystemCursor(sdl.SystemCursor.IBEAM);
    cursor_handles[imgui.Mouse_Cursor.ResizeAll]  = sdl.CreateSystemCursor(sdl.SystemCursor.SIZEALL);
    cursor_handles[imgui.Mouse_Cursor.ResizeNs]   = sdl.CreateSystemCursor(sdl.SystemCursor.SIZENS);
    cursor_handles[imgui.Mouse_Cursor.ResizeEw]   = sdl.CreateSystemCursor(sdl.SystemCursor.SIZEWE);
    cursor_handles[imgui.Mouse_Cursor.ResizeNesw] = sdl.CreateSystemCursor(sdl.SystemCursor.SIZENESW);
    cursor_handles[imgui.Mouse_Cursor.ResizeNwse] = sdl.CreateSystemCursor(sdl.SystemCursor.SIZENWSE);
    cursor_handles[imgui.Mouse_Cursor.Hand]       = sdl.CreateSystemCursor(sdl.SystemCursor.HAND);
    cursor_handles[imgui.Mouse_Cursor.NotAllowed] = sdl.CreateSystemCursor(sdl.SystemCursor.NO);
} 

process_event :: proc(e: sdl.Event, state: ^SDL_State) {
    io := imgui.get_io();
    #partial switch e.type {
        case .MOUSEWHEEL: {
            if e.wheel.x > 0 do io.mouse_wheel_h += 1;
            if e.wheel.x < 0 do io.mouse_wheel_h -= 1;
            if e.wheel.y > 0 do io.mouse_wheel   += 1;
            if e.wheel.y < 0 do io.mouse_wheel   -= 1;
        }

        case .TEXTINPUT: {
            text := e.text;
            imgui.ImGuiIO_AddInputCharactersUTF8(io, cstring(&text.text[0]));
        }

        case .MOUSEBUTTONDOWN: {
            if e.button.button == u8(sdl.BUTTON_LEFT)   do state.mouse_down[0] = true;
            if e.button.button == u8(sdl.BUTTON_RIGHT)  do state.mouse_down[1] = true;
            if e.button.button == u8(sdl.BUTTON_MIDDLE) do state.mouse_down[2] = true;
        }

        case .KEYDOWN, .KEYUP: {
            sc := e.key.keysym.scancode;
            io.keys_down[sc] = e.type == .KEYDOWN;
            io.key_shift = i32(transmute(u16)(sdl.GetModState())) & i32(sdl.Keycode.LSHIFT | sdl.Keycode.RSHIFT) != 0;
            io.key_ctrl  = i32(transmute(u16)(sdl.GetModState())) & i32(sdl.Keycode.LCTRL | sdl.Keycode.RCTRL)   != 0;
            io.key_alt   = i32(transmute(u16)(sdl.GetModState())) & i32(sdl.Keycode.LALT | sdl.Keycode.RALT)     != 0;

            when ODIN_OS == .Windows{
                io.key_super = false;
            } else {
                io.key_super = i32(transmute(u16)(sdl.GetModState())) & i32(sdl.Keycode.LGUI|sdl.Keycode.RGUI) != 0;
            }
        }
    }
}

update_dt :: proc(state: ^SDL_State) {
    io := imgui.get_io();
    freq := sdl.GetPerformanceFrequency();
    curr_time := sdl.GetPerformanceCounter();
    io.delta_time = state.time > 0 ? f32(f64(curr_time - state.time) / f64(freq)) : f32(1/60);
    state.time = curr_time;
}

update_mouse :: proc(state: ^SDL_State, window: ^sdl.Window) {
    io := imgui.get_io();
    mx, my: i32;
    buttons := sdl.GetMouseState(&mx, &my);
    io.mouse_down[0] = state.mouse_down[0] || (buttons & u32(sdl.BUTTON_LEFT))   != 0;
    io.mouse_down[1] = state.mouse_down[1] || (buttons & u32(sdl.BUTTON_RIGHT))  != 0;
    io.mouse_down[2] = state.mouse_down[2] || (buttons & u32(sdl.BUTTON_MIDDLE)) != 0;
    state.mouse_down[0] = false;
    state.mouse_down[1] = false;
    state.mouse_down[2] = false;

    // Set mouse pos if window is focused
    io.mouse_pos = imgui.Vec2{min(f32), min(f32)};
    if sdl.GetKeyboardFocus() == window {
        io.mouse_pos = imgui.Vec2{f32(mx), f32(my)};
    }

    if io.config_flags & .NoMouseCursorChange != .NoMouseCursorChange {
        desired_cursor := imgui.get_mouse_cursor();
        if(io.mouse_draw_cursor || desired_cursor == .None) {
            sdl.ShowCursor(0);
        } else {
            chosen_cursor := state.cursor_handles[imgui.Mouse_Cursor.Arrow];
            if state.cursor_handles[desired_cursor] != nil {
                chosen_cursor = state.cursor_handles[desired_cursor];
            }
            sdl.SetCursor(chosen_cursor);
            sdl.ShowCursor(1);
        }
    }
}

update_display_size :: proc(window: ^sdl.Window) {
    w, h, display_h, display_w: i32;
    sdl.GetWindowSize(window, &w, &h);
    if sdl.GetWindowFlags(window) & u32(sdl.WindowFlags.MINIMIZED) == 0 {
        w = 0;
        h = 0;
    }
    sdl.GL_GetDrawableSize(window, &display_w, &display_h);

    io := imgui.get_io();
    io.display_size = imgui.Vec2{f32(w), f32(h)};
    if w > 0 && h > 0 {
        io.display_framebuffer_scale = imgui.Vec2{f32(display_w / w), f32(display_h / h)};
    }
}

set_clipboard_text :: proc "c"(user_data : rawptr, text : cstring) {
    context = runtime.default_context();
    sdl.SetClipboardText(text);
}

get_clipboard_text :: proc "c"(user_data : rawptr) -> cstring {
    context = runtime.default_context();
    @static text_ptr: cstring;
    if text_ptr != nil {
        sdl.free(cast(^byte)text_ptr);
    }
    text_ptr = sdl.GetClipboardText();

    return text_ptr;
}
