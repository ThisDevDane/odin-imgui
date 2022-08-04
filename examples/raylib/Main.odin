package main

// Code Transformed from the imgui/raylib backend here:
// https://github.com/oskaritimperi/imgui-impl-raylib/blob/master/imgui_impl_raylib.cpp
// So thank you to oskaritimperi & WEREMSOFT for the initial
// inspiration for use with ODIN.

import "core:fmt"
import "shared:imgui"
import rl "vendor:raylib"

main :: proc()
{
    rl.InitWindow(1600, 900, "Test Dear ImGui + Raylib")
    rl.SetTargetFPS(60)

    context_ := imgui.igCreateContext(nil)
    imgui.igSetCurrentContext(context_)

    ImGui_ImplRaylib_Init()

    show_demo_window := true
    show_another_window := false

    clear_color := imgui.Vec4{ 0.45, 0.55, 0.60, 1.0 }

    for !rl.WindowShouldClose() {
        ImGui_ImplRaylib_NewFrame()
        ImGui_ImplRaylib_ProcessEvent()
        imgui.igNewFrame()

        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)

        if imgui.swr_igButton("Click Me!##Click", imgui.Vec2{ 100, 20 }) {
            fmt.println("Item clicked.")
        }

        imgui.igRender()
        ImGui_ImplRaylib_Render(imgui.igGetDrawData())
        rl.EndDrawing()
    }

    rl.CloseWindow()
}