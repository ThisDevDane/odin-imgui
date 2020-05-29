package main

import "core:log";

import sdl "shared:odin-sdl2";

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
        window := sdl.create_window("odin-imgui SDL example", 100, 100, 1280, 720, .Open_GL|.Mouse_Focus|.Shown);
        if window == nil {
            log.debugf("Error during window creation: %s", sdl.get_error());
            sdl.quit();
            return;
        }

        log.info("Setting up the renderer...");
        renderer := sdl.create_renderer(window, -1, .Accelerated|.Present_VSync);
        if renderer == nil {
            log.debugf("Error during renderer creation: %s", sdl.get_error());
            sdl.quit();
            return;
        }

        log.info("Setting up the OpenGL...");
        sdl.gl_set_attribute(.Context_Major_Version, 4);
        sdl.gl_set_attribute(.Context_Minor_Version, 5);
        sdl.gl_set_attribute(.Context_Profile_Mask, i32(sdl.GL_Context_Profile.Core));
        gl_ctx := sdl.gl_create_context(window);
        sdl.gl_set_swap_interval(1);

        running := true;
        e := sdl.Event{};
        for running {
            for sdl.poll_event(&e) != 0 {
                #partial switch e.type {
                    case .Quit:
                        running = false;

                    case .Key_Down:
                        if is_key_down(e, .Escape) {
                            running = false;
                        }
                }
            }

            sdl.render_clear(renderer);
            sdl.render_present(renderer);
        }
        log.info("Shutting down...");
        
    } else {
        log.debugf("Error during SDL init: (%d)%s", init_err, sdl.get_error());
    }
}


is_key_down :: proc(e: sdl.Event, sc: sdl.Scancode) -> bool {
    return e.key.type == .Key_Down && e.key.keysym.scancode == sc;
}