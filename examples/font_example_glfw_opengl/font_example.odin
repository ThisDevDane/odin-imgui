package main

import "core:log"
import "core:runtime"
import "core:strings"
import "core:mem"
import "core:fmt"

import gl "vendor:OpenGL"
import "vendor:glfw"

DESIRED_GL_MAJOR_VERSION :: 4
DESIRED_GL_MINOR_VERSION :: 5

import imgui "../.."
import imgl "../../impl/opengl"
import imglfw "../../impl/glfw"

show_demo_window := false

main :: proc() {
	context.logger = get_logger()
	defer free(context.logger.data)

	if !bool(glfw.Init()) {
		desc, err := glfw.GetError()
		log.error("GLFW init failed:", err, desc)
		return
	}
	defer glfw.Terminate()

	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, DESIRED_GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, DESIRED_GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
	glfw.WindowHint(glfw.DOUBLEBUFFER, 1)
	glfw.WindowHint(glfw.DEPTH_BITS, 24)
	glfw.WindowHint(glfw.STENCIL_BITS, 8)
	window := glfw.CreateWindow(1280, 720, "odin-imgui GLFW+OpenGL FONTS", nil, nil)
	if window == nil {
		desc, err := glfw.GetError()
		log.error("GLFW window creation failed:", err, desc)
		return
	}
	defer glfw.DestroyWindow(window)

	glfw.SetErrorCallback(error_callback)
	glfw.SetKeyCallback(window, key_callback)

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1)

	gl.load_up_to(
		DESIRED_GL_MAJOR_VERSION,
		DESIRED_GL_MINOR_VERSION,
		glfw.gl_set_proc_address,
	)
	gl.ClearColor(0.25, 0.25, 0.25, 1)

	imgui_state := init_imgui_state(window)

	roboto_regular := imgl.imgui_load_font_from_file("Roboto/Roboto-Regular.ttf", 16, true)
	roboto_bold := imgl.imgui_load_font_from_file("Roboto/Roboto-Bold.ttf", 48)
	
	io := imgui.get_io()

	running := true
	for !glfw.WindowShouldClose(window) {

		imglfw_new_frame_update_inputs()
		imgui.new_frame()
		{
			info_overlay()

			if show_demo_window do imgui.show_demo_window(&show_demo_window)

			{
				imgui.begin("Misc tests")
					pos := imgui.get_window_pos()
					size := imgui.get_window_size()
					imgui.push_font(roboto_bold)
					imgui.text("pos: {}", pos)
					imgui.text("size: {}", size)
					imgui.pop_font()

					imgui.text("pos: {}", pos)
					imgui.text("size: {}", size)
				imgui.end()
			}
		}
		imgui.render()

		gl.Viewport(0, 0, i32(io.display_size.x), i32(io.display_size.y))
		gl.Scissor(0, 0, i32(io.display_size.x), i32(io.display_size.y))
		gl.Clear(gl.COLOR_BUFFER_BIT)
		imgl.imgui_render(imgui.get_draw_data(), imgui_state.opengl_state)

		glfw.SwapBuffers(window)
		glfw.PollEvents()
	}
}

get_logger :: proc() -> log.Logger {
	logger_opts := log.Options{.Level, .Line, .Procedure}
	return log.create_console_logger(opt = logger_opts)
}

key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	context = runtime.default_context()

	if action == glfw.PRESS {
		switch key {
		case glfw.KEY_ESCAPE:
			glfw.SetWindowShouldClose(window, true)
		case glfw.KEY_TAB:
			io := imgui.get_io()
			if io.want_capture_keyboard == false {
				show_demo_window = true
			}
		}
	}
}

error_callback :: proc "c" (error: i32, description: cstring) {
	context = runtime.default_context()
	context.logger = get_logger()
	log.error("GLFW error:", error, description)
}

info_overlay :: proc() {
	imgui.set_next_window_pos(imgui.Vec2{10, 10})
	imgui.set_next_window_bg_alpha(0.2)
	overlay_flags: imgui.Window_Flags = .NoDecoration | .AlwaysAutoResize | .NoSavedSettings |
                                     .NoFocusOnAppearing | .NoNav | .NoMove
	imgui.begin("Info", nil, overlay_flags)
	imgui.text_unformatted("Press Esc to close the application")
	imgui.text_unformatted("Press Tab to show demo window")
	imgui.end()
}

Imgui_State :: struct {
	opengl_state: imgl.OpenGL_State,
}

init_imgui_state :: proc(window: glfw.WindowHandle) -> Imgui_State {
	res := Imgui_State{}

	imgui.create_context()
	imgui.style_colors_dark()

	imglfw.setup_state(window, true)

	imgl.setup_state(&res.opengl_state)

	return res
}

imglfw_new_frame_update_inputs :: proc() {
	imglfw.update_display_size()
	imglfw.update_mouse()
	imglfw.update_dt()
}