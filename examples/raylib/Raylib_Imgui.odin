package main

// Code Transformed from the imgui/raylib backend here:
// https://github.com/oskaritimperi/imgui-impl-raylib/blob/master/imgui_impl_raylib.cpp
// So thank you to oskaritimperi & WEREMSOFT for the initial
// inspiration for use with ODIN.

import "core:math"
import c "core:c/libc"
import "shared:imgui"
import rl "vendor:raylib"

g_Time := 0.0
g_UnloadAtlas := false
g_AtlasTexID : u32 = 0

ImGui_ImplRaylib_GetClipboardText :: proc "c" (data : rawptr) -> cstring {
    return rl.GetClipboardText()
}

ImGui_ImplRaylib_SetClipboardText :: proc "c" (data : rawptr, text : cstring) {
    rl.SetClipboardText(text)
}

ImGui_ImplRaylib_Init :: proc() -> bool {
    io := imgui.get_io();

    io.backend_platform_name = "imgui_impl_raylib";

    io.key_map[imgui.Key.Tab] = cast(i32)rl.KeyboardKey.TAB;
    io.key_map[imgui.Key.LeftArrow] = cast(i32)rl.KeyboardKey.LEFT;
    io.key_map[imgui.Key.RightArrow] = cast(i32)rl.KeyboardKey.RIGHT;
    io.key_map[imgui.Key.UpArrow] = cast(i32)rl.KeyboardKey.UP;
    io.key_map[imgui.Key.DownArrow] = cast(i32)rl.KeyboardKey.DOWN;
    io.key_map[imgui.Key.PageUp] = cast(i32)rl.KeyboardKey.PAGE_DOWN;
    io.key_map[imgui.Key.PageDown] = cast(i32)rl.KeyboardKey.PAGE_UP;
    io.key_map[imgui.Key.Home] = cast(i32)rl.KeyboardKey.HOME;
    io.key_map[imgui.Key.End] = cast(i32)rl.KeyboardKey.END;
    io.key_map[imgui.Key.Insert] = cast(i32)rl.KeyboardKey.INSERT;
    io.key_map[imgui.Key.Delete] = cast(i32)rl.KeyboardKey.DELETE;
    io.key_map[imgui.Key.Backspace] = cast(i32)rl.KeyboardKey.BACKSPACE;
    io.key_map[imgui.Key.Space] = cast(i32)rl.KeyboardKey.SPACE;
    io.key_map[imgui.Key.Enter] = cast(i32)rl.KeyboardKey.ENTER;
    io.key_map[imgui.Key.Escape] = cast(i32)rl.KeyboardKey.ESCAPE;
    io.key_map[imgui.Key.KeyPadEnter] = cast(i32)rl.KeyboardKey.KP_ENTER;
    io.key_map[imgui.Key.A] = cast(i32)rl.KeyboardKey.A;
    io.key_map[imgui.Key.C] = cast(i32)rl.KeyboardKey.C;
    io.key_map[imgui.Key.V] = cast(i32)rl.KeyboardKey.V;
    io.key_map[imgui.Key.X] = cast(i32)rl.KeyboardKey.X;
    io.key_map[imgui.Key.Y] = cast(i32)rl.KeyboardKey.Y;
    io.key_map[imgui.Key.Z] = cast(i32)rl.KeyboardKey.Z;

    io.mouse_pos = imgui.Vec2{ -math.F32_MAX, -math.F32_MAX };

    io.set_clipboard_text_fn = ImGui_ImplRaylib_SetClipboardText;
    io.get_clipboard_text_fn = ImGui_ImplRaylib_GetClipboardText;
    io.clipboard_user_data = nil;

    ImGui_ImplRaylib_LoadDefaultFontAtlas();

    return true;
}

ImGui_ImplRaylib_Shutdown :: proc() {
    if g_UnloadAtlas {
        io := imgui.get_io()
        imgui.ImFontAtlas_ClearTexData(io.fonts)
    }
    g_Time = 0.0
}


@(private="file")
ImGui_ImplRaylib_UpdateMousePosAndButtons :: proc() {
    io := imgui.get_io()

    if io.want_set_mouse_pos {
        rl.SetMousePosition(i32(io.mouse_pos.x), i32(io.mouse_pos.y))
    }
    else {
        io.mouse_pos = imgui.Vec2{ -math.F32_MAX, -math.F32_MAX }
    }

    io.mouse_down[0] = rl.IsMouseButtonDown(.LEFT)
    io.mouse_down[1] = rl.IsMouseButtonDown(.RIGHT)
    io.mouse_down[2] = rl.IsMouseButtonDown(.MIDDLE)

    if !rl.IsWindowMinimized() {
        io.mouse_pos = imgui.Vec2{ f32(rl.GetMouseX()), f32(rl.GetMouseY()) }
    }
}

ImGui_ImplRaylib_UpdateMouseCursor :: proc() {
    io := imgui.get_io()
    // can't use odin native flag checking here as the imgui wrapper
    // isn't setup for it
    if (cast(i32)io.config_flags & cast(i32)imgui.Config_Flags.NoMouseCursorChange) == 0 {
        return
    }

    imgui_cursor := imgui.igGetMouseCursor()
    if io.mouse_draw_cursor || imgui_cursor == imgui.Mouse_Cursor.None {
        rl.HideCursor()
    }
    else {
        rl.ShowCursor()
    }
}

ImGui_ImplRaylib_NewFrame :: proc() {
    io := imgui.get_io()

    io.display_size = imgui.Vec2{ f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight()) }

    current_time := rl.GetTime()
    io.delta_time = g_Time > 0.0 ? f32(current_time - g_Time) : f32(1.0 / 60.0)
    g_Time = current_time

    io.key_ctrl = rl.IsKeyDown(.RIGHT_CONTROL) || rl.IsKeyDown(.LEFT_CONTROL)
    io.key_shift = rl.IsKeyDown(.RIGHT_SHIFT) || rl.IsKeyDown(.LEFT_SHIFT)
    io.key_alt = rl.IsKeyDown(.RIGHT_ALT) || rl.IsKeyDown(.LEFT_ALT)
    io.key_super = rl.IsKeyDown(.RIGHT_SUPER) || rl.IsKeyDown(.LEFT_SHIFT)

    ImGui_ImplRaylib_UpdateMousePosAndButtons()
    ImGui_ImplRaylib_UpdateMouseCursor()

    if rl.GetMouseWheelMove() > 0 {
        io.mouse_wheel += 1
    }
    else if rl.GetMouseWheelMove() < 0 {
        io.mouse_wheel -= 1
    }
}

ImGui_ImplRaylib_ProcessEvent :: proc() -> bool {
    io := imgui.get_io()

    io.keys_down[cast(i32)rl.KeyboardKey.APOSTROPHE]   = rl.IsKeyDown(.APOSTROPHE)
    io.keys_down[cast(i32)rl.KeyboardKey.COMMA]        = rl.IsKeyDown(.COMMA)
    io.keys_down[cast(i32)rl.KeyboardKey.MINUS]        = rl.IsKeyDown(.MINUS)
    io.keys_down[cast(i32)rl.KeyboardKey.PERIOD]       = rl.IsKeyDown(.PERIOD)
    io.keys_down[cast(i32)rl.KeyboardKey.SLASH]        = rl.IsKeyDown(.SLASH)
    io.keys_down[cast(i32)rl.KeyboardKey.ZERO]         = rl.IsKeyDown(.ZERO)
    io.keys_down[cast(i32)rl.KeyboardKey.ONE]          = rl.IsKeyDown(.ONE)
    io.keys_down[cast(i32)rl.KeyboardKey.TWO]          = rl.IsKeyDown(.TWO)
    io.keys_down[cast(i32)rl.KeyboardKey.THREE]        = rl.IsKeyDown(.THREE)
    io.keys_down[cast(i32)rl.KeyboardKey.FOUR]         = rl.IsKeyDown(.FOUR)
    io.keys_down[cast(i32)rl.KeyboardKey.FIVE]         = rl.IsKeyDown(.FIVE)
    io.keys_down[cast(i32)rl.KeyboardKey.SIX]          = rl.IsKeyDown(.SIX)
    io.keys_down[cast(i32)rl.KeyboardKey.SEVEN]        = rl.IsKeyDown(.SEVEN)
    io.keys_down[cast(i32)rl.KeyboardKey.EIGHT]        = rl.IsKeyDown(.EIGHT)
    io.keys_down[cast(i32)rl.KeyboardKey.NINE]         = rl.IsKeyDown(.NINE)
    io.keys_down[cast(i32)rl.KeyboardKey.SEMICOLON]    = rl.IsKeyDown(.SEMICOLON)
    io.keys_down[cast(i32)rl.KeyboardKey.EQUAL]        = rl.IsKeyDown(.EQUAL)
    io.keys_down[cast(i32)rl.KeyboardKey.A]            = rl.IsKeyDown(.A)
    io.keys_down[cast(i32)rl.KeyboardKey.B]            = rl.IsKeyDown(.B)
    io.keys_down[cast(i32)rl.KeyboardKey.C]            = rl.IsKeyDown(.C)
    io.keys_down[cast(i32)rl.KeyboardKey.D]            = rl.IsKeyDown(.D)
    io.keys_down[cast(i32)rl.KeyboardKey.E]            = rl.IsKeyDown(.E)
    io.keys_down[cast(i32)rl.KeyboardKey.F]            = rl.IsKeyDown(.F)
    io.keys_down[cast(i32)rl.KeyboardKey.G]            = rl.IsKeyDown(.G)
    io.keys_down[cast(i32)rl.KeyboardKey.H]            = rl.IsKeyDown(.H)
    io.keys_down[cast(i32)rl.KeyboardKey.I]            = rl.IsKeyDown(.I)
    io.keys_down[cast(i32)rl.KeyboardKey.J]            = rl.IsKeyDown(.J)
    io.keys_down[cast(i32)rl.KeyboardKey.K]            = rl.IsKeyDown(.K)
    io.keys_down[cast(i32)rl.KeyboardKey.L]            = rl.IsKeyDown(.L)
    io.keys_down[cast(i32)rl.KeyboardKey.M]            = rl.IsKeyDown(.M)
    io.keys_down[cast(i32)rl.KeyboardKey.N]            = rl.IsKeyDown(.N)
    io.keys_down[cast(i32)rl.KeyboardKey.O]            = rl.IsKeyDown(.O)
    io.keys_down[cast(i32)rl.KeyboardKey.P]            = rl.IsKeyDown(.P)
    io.keys_down[cast(i32)rl.KeyboardKey.Q]            = rl.IsKeyDown(.Q)
    io.keys_down[cast(i32)rl.KeyboardKey.R]            = rl.IsKeyDown(.R)
    io.keys_down[cast(i32)rl.KeyboardKey.S]            = rl.IsKeyDown(.S)
    io.keys_down[cast(i32)rl.KeyboardKey.T]            = rl.IsKeyDown(.T)
    io.keys_down[cast(i32)rl.KeyboardKey.U]            = rl.IsKeyDown(.U)
    io.keys_down[cast(i32)rl.KeyboardKey.V]            = rl.IsKeyDown(.V)
    io.keys_down[cast(i32)rl.KeyboardKey.W]            = rl.IsKeyDown(.W)
    io.keys_down[cast(i32)rl.KeyboardKey.X]            = rl.IsKeyDown(.X)
    io.keys_down[cast(i32)rl.KeyboardKey.Y]            = rl.IsKeyDown(.Y)
    io.keys_down[cast(i32)rl.KeyboardKey.Z]            = rl.IsKeyDown(.Z)
    io.keys_down[cast(i32)rl.KeyboardKey.SPACE]        = rl.IsKeyDown(.SPACE)
    io.keys_down[cast(i32)rl.KeyboardKey.ESCAPE]       = rl.IsKeyDown(.ESCAPE)
    io.keys_down[cast(i32)rl.KeyboardKey.ENTER]        = rl.IsKeyDown(.ENTER)
    io.keys_down[cast(i32)rl.KeyboardKey.TAB]          = rl.IsKeyDown(.TAB)
    io.keys_down[cast(i32)rl.KeyboardKey.BACKSPACE]    = rl.IsKeyDown(.BACKSPACE)
    io.keys_down[cast(i32)rl.KeyboardKey.INSERT]       = rl.IsKeyDown(.INSERT)
    io.keys_down[cast(i32)rl.KeyboardKey.DELETE]       = rl.IsKeyDown(.DELETE)
    io.keys_down[cast(i32)rl.KeyboardKey.RIGHT]        = rl.IsKeyDown(.RIGHT)
    io.keys_down[cast(i32)rl.KeyboardKey.LEFT]         = rl.IsKeyDown(.LEFT)
    io.keys_down[cast(i32)rl.KeyboardKey.DOWN]         = rl.IsKeyDown(.DOWN)
    io.keys_down[cast(i32)rl.KeyboardKey.UP]           = rl.IsKeyDown(.UP)
    io.keys_down[cast(i32)rl.KeyboardKey.PAGE_UP]      = rl.IsKeyDown(.PAGE_UP)
    io.keys_down[cast(i32)rl.KeyboardKey.PAGE_DOWN]    = rl.IsKeyDown(.PAGE_DOWN)
    io.keys_down[cast(i32)rl.KeyboardKey.HOME]         = rl.IsKeyDown(.HOME)
    io.keys_down[cast(i32)rl.KeyboardKey.END]          = rl.IsKeyDown(.END)
    io.keys_down[cast(i32)rl.KeyboardKey.CAPS_LOCK]    = rl.IsKeyDown(.CAPS_LOCK)
    io.keys_down[cast(i32)rl.KeyboardKey.SCROLL_LOCK]  = rl.IsKeyDown(.SCROLL_LOCK)
    io.keys_down[cast(i32)rl.KeyboardKey.NUM_LOCK]     = rl.IsKeyDown(.NUM_LOCK)
    io.keys_down[cast(i32)rl.KeyboardKey.PRINT_SCREEN] = rl.IsKeyDown(.PRINT_SCREEN)
    io.keys_down[cast(i32)rl.KeyboardKey.PAUSE]        = rl.IsKeyDown(.PAUSE)
    io.keys_down[cast(i32)rl.KeyboardKey.F1]           = rl.IsKeyDown(.F1)
    io.keys_down[cast(i32)rl.KeyboardKey.F2]           = rl.IsKeyDown(.F2)
    io.keys_down[cast(i32)rl.KeyboardKey.F3]           = rl.IsKeyDown(.F3)
    io.keys_down[cast(i32)rl.KeyboardKey.F4]           = rl.IsKeyDown(.F4)
    io.keys_down[cast(i32)rl.KeyboardKey.F5]           = rl.IsKeyDown(.F5)
    io.keys_down[cast(i32)rl.KeyboardKey.F6]           = rl.IsKeyDown(.F6)
    io.keys_down[cast(i32)rl.KeyboardKey.F7]           = rl.IsKeyDown(.F7)
    io.keys_down[cast(i32)rl.KeyboardKey.F8]           = rl.IsKeyDown(.F8)
    io.keys_down[cast(i32)rl.KeyboardKey.F9]           = rl.IsKeyDown(.F9)
    io.keys_down[cast(i32)rl.KeyboardKey.F10]          = rl.IsKeyDown(.F10)
    io.keys_down[cast(i32)rl.KeyboardKey.F11]          = rl.IsKeyDown(.F11)
    io.keys_down[cast(i32)rl.KeyboardKey.F12]          = rl.IsKeyDown(.F12)
    io.keys_down[cast(i32)rl.KeyboardKey.LEFT_SHIFT]   = rl.IsKeyDown(.LEFT_SHIFT)
    io.keys_down[cast(i32)rl.KeyboardKey.LEFT_CONTROL] = rl.IsKeyDown(.LEFT_CONTROL)
    io.keys_down[cast(i32)rl.KeyboardKey.LEFT_ALT]     = rl.IsKeyDown(.LEFT_ALT)
    io.keys_down[cast(i32)rl.KeyboardKey.LEFT_SUPER]   = rl.IsKeyDown(.LEFT_SUPER)
    io.keys_down[cast(i32)rl.KeyboardKey.RIGHT_SHIFT]  = rl.IsKeyDown(.RIGHT_SHIFT)
    io.keys_down[cast(i32)rl.KeyboardKey.RIGHT_CONTROL] = rl.IsKeyDown(.RIGHT_CONTROL)
    io.keys_down[cast(i32)rl.KeyboardKey.RIGHT_ALT]    = rl.IsKeyDown(.RIGHT_ALT)
    io.keys_down[cast(i32)rl.KeyboardKey.RIGHT_SUPER]  = rl.IsKeyDown(.RIGHT_SUPER)
    io.keys_down[cast(i32)rl.KeyboardKey.KB_MENU]      = rl.IsKeyDown(.KB_MENU)
    io.keys_down[cast(i32)rl.KeyboardKey.LEFT_BRACKET] = rl.IsKeyDown(.LEFT_BRACKET)
    io.keys_down[cast(i32)rl.KeyboardKey.BACKSLASH]    = rl.IsKeyDown(.BACKSLASH)
    io.keys_down[cast(i32)rl.KeyboardKey.RIGHT_BRACKET] = rl.IsKeyDown(.RIGHT_BRACKET)
    io.keys_down[cast(i32)rl.KeyboardKey.GRAVE]        = rl.IsKeyDown(.GRAVE)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_0]         = rl.IsKeyDown(.KP_0)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_1]         = rl.IsKeyDown(.KP_1)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_2]         = rl.IsKeyDown(.KP_2)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_3]         = rl.IsKeyDown(.KP_3)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_4]         = rl.IsKeyDown(.KP_4)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_5]         = rl.IsKeyDown(.KP_5)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_6]         = rl.IsKeyDown(.KP_6)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_7]         = rl.IsKeyDown(.KP_7)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_8]         = rl.IsKeyDown(.KP_8)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_9]         = rl.IsKeyDown(.KP_9)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_DECIMAL]   = rl.IsKeyDown(.KP_DECIMAL)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_DIVIDE]    = rl.IsKeyDown(.KP_DIVIDE)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_MULTIPLY]  = rl.IsKeyDown(.KP_MULTIPLY)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_SUBTRACT]  = rl.IsKeyDown(.KP_SUBTRACT)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_ADD]       = rl.IsKeyDown(.KP_ADD)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_ENTER]     = rl.IsKeyDown(.KP_ENTER)
    io.keys_down[cast(i32)rl.KeyboardKey.KP_EQUAL]     = rl.IsKeyDown(.KP_EQUAL)
    io.keys_down[cast(i32)rl.KeyboardKey.BACK]         = rl.IsKeyDown(.BACK)
    io.keys_down[cast(i32)rl.KeyboardKey.MENU]         = rl.IsKeyDown(.MENU)
    io.keys_down[cast(i32)rl.KeyboardKey.VOLUME_UP]    = rl.IsKeyDown(.VOLUME_UP)
    io.keys_down[cast(i32)rl.KeyboardKey.VOLUME_DOWN]  = rl.IsKeyDown(.VOLUME_DOWN)
    
    length : i32
    imgui.ImGuiIO_AddInputCharactersUTF8(io, rl.CodepointToUTF8(rl.GetCharPressed(), &length))

    return true
}

ImGui_ImplRaylib_LoadDefaultFontAtlas :: proc() {
    if !g_UnloadAtlas {
        io := imgui.get_io()
        pixels : ^u8
        width, height, bpp : i32
        image : rl.Image

        imgui.ImFontAtlas_GetTexDataAsRGBA32(io.fonts, &pixels, &width, &height, &bpp)
        size := rl.GetPixelDataSize(width, height, .UNCOMPRESSED_R8G8B8A8)
        image.data = c.malloc(uint(size))
        c.memcpy(image.data, pixels, uint(size))
        image.width = width
        image.height = height
        image.mipmaps = 1
        image.format = .UNCOMPRESSED_R8G8B8A8
        tex := rl.LoadTextureFromImage(image)
        g_AtlasTexID = tex.id
        io.fonts.tex_id = cast(imgui.Texture_ID)&g_AtlasTexID
        c.free(pixels)
        c.free(image.data)
        g_UnloadAtlas = true
    }
}

ImGui_ImplRaylib_Render :: proc(draw_data : ^imgui.Draw_Data) {
    DrawTriangleVertex :: proc(idx_vert : imgui.Draw_Vert) {
        c : rl.Color = rl.Color{ cast(u8)(idx_vert.col >> 0), cast(u8)(idx_vert.col >> 8), cast(u8)(idx_vert.col >> 16), cast(u8)(idx_vert.col >> 24) }
        rl.rlColor4ub(c.r, c.g, c.b, c.a)
        rl.rlTexCoord2f(idx_vert.uv.x, idx_vert.uv.y)
        rl.rlVertex2f(idx_vert.pos.x, idx_vert.pos.y)
    }

    rl.rlDisableBackfaceCulling()
    for n in 0..<draw_data.cmd_lists_count {
        cmd_list := (cast([^]^imgui.Draw_List)draw_data.cmd_lists)[n]
        idx_index : u32 = 0

        vtx_buffer := cast([^]imgui.Draw_Vert)cmd_list.vtx_buffer.data
        idx_buffer := cast([^]imgui.Draw_Idx)cmd_list.idx_buffer.data
        for i in 0..<cmd_list.cmd_buffer.size {
            pcmd := &(cast([^]imgui.Draw_Cmd)cmd_list.cmd_buffer.data)[i]
            if pcmd.user_callback != nil {
                pcmd.user_callback(cmd_list, pcmd)
            }
            else {
                pos := draw_data.display_pos
                rectX := i32(pcmd.clip_rect.x - pos.x)
                rectY := i32(pcmd.clip_rect.y - pos.y)
                rectW := i32(pcmd.clip_rect.z) - rectX
                rectH := i32(pcmd.clip_rect.w) - rectY
                rl.BeginScissorMode(rectX, rectY, rectW, rectH)
                {
                    ti : ^u32 = cast(^u32)pcmd.texture_id
                    for j : u32 = 0; j <= (pcmd.elem_count - 3); j += 3 {
                        if pcmd.elem_count == 0 {
                            break
                        }

                        rl.rlPushMatrix()
                        rl.rlBegin(rl.RL_TRIANGLES)
                        rl.rlSetTexture(ti^)

                        index : imgui.Draw_Idx
                        vertex : imgui.Draw_Vert

                        index = idx_buffer[j + idx_index]
                        vertex = vtx_buffer[index]
                        DrawTriangleVertex(vertex)

                        index = idx_buffer[j + 2 + idx_index]
                        vertex = vtx_buffer[index]
                        DrawTriangleVertex(vertex)

                        index = idx_buffer[j + 1 + idx_index]
                        vertex = vtx_buffer[index]
                        DrawTriangleVertex(vertex)

                        rl.rlDisableTexture()
                        rl.rlEnd()
                        rl.rlPopMatrix()
                    }
                }
            }

            idx_index += pcmd.elem_count
        }
    }

    rl.EndScissorMode()
    rl.rlEnableBackfaceCulling()
}