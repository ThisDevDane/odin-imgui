/*
 *  @Name:     imgui_types
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    fyoucon@gmail.com
 *  @Creation: 02-09-2018 15:59:43 UTC+1
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 06-10-2018 14:13:07 UTC+1
 *  
 *  @Description:
 *  
 */

package imgui

import "core:mem";

////////////////////////////
// Types
ID        :: distinct u32;
DrawIdx   :: distinct u16; 
Wchar     :: distinct u16; 
TextureID :: distinct rawptr; 

///////////////////////////
// DUMMY STRUCTS
Context            :: struct {}
DrawListSharedData :: struct {}

///////////////////////////
// Actual structs
Vec2 :: struct {
    x : f32,
    y : f32,
}

Vec4 :: struct {
    x : f32,
    y : f32,
    z : f32,
    w : f32,
}

Style :: struct {
    alpha                     : f32,
    window_padding            : Vec2,
    window_rounding           : f32,
    window_border_size        : f32,
    window_min_size           : Vec2,
    window_title_align        : Vec2,
    child_rounding            : f32,
    child_border_size         : f32,
    popup_rounding            : f32,
    popup_border_size         : f32,
    frame_padding             : Vec2,
    frame_rounding            : f32,
    frame_border_size         : f32,
    item_spacing              : Vec2,
    item_inner_spacing        : Vec2,
    touch_extra_padding       : Vec2,
    indent_spacing            : f32,
    columns_min_spacing       : f32,
    scrollbar_size            : f32,
    scrollbar_rounding        : f32,
    grab_min_size             : f32,
    grab_rounding             : f32,
    button_text_align         : Vec2,
    display_window_padding    : Vec2,
    display_safe_area_padding : Vec2,
    mouse_cursor_scale        : f32,
    aa_lines                  : bool,
    aa_fill                   : bool,
    curve_tessellation_tol    : f32,
    colors                    : [Style_Color.COUNT]Vec4, 
}

IO :: struct {
    config_flags                     : Config_Flags,
    backend_flags                    : Backend_Flags,
    display_size                     : Vec2,
    delta_time                       : f32,
    ini_saving_rate                  : f32,
    ini_filename                     : cstring,
    log_filename                     : cstring,
    mouse_double_click_time          : f32,
    mouse_double_click_max_dist      : f32,
    mouse_drag_threshold             : f32,
    key_map                          : [Key.COUNT]i32,
    key_repeat_delay                 : f32,
    key_repeat_rate                  : f32,
    user_data                        : rawptr,
    fonts                            : ^FontAtlas,
    font_global_scale                : f32,
    font_allow_user_scaling          : bool,
    font_default                     : ^Font,
    display_framebuffer_scale        : Vec2,
    display_visible_min              : Vec2,
    display_visible_max              : Vec2,
    config_mac_o_s_x_behaviors       : bool,
    config_cursor_blink              : bool,
    config_resize_windows_from_edges : bool,
    get_clipboard_text_fn            : proc "c"(user_data : rawptr) -> cstring,
    set_clipboard_text_fn            : proc "c"(user_data : rawptr, text : cstring),
    ClipboardUserData                : rawptr,
    ime_set_input_screen_pos_fn      : proc "c"(x, y : i32),
    ime_window_handle                : rawptr,
    render_draw_lists_fn_unused      : rawptr,
    mouse_pos                        : Vec2,
    mouse_down                       : [5]bool,
    mouse_wheel                      : f32,
    mouse_wheel_h                    : f32,
    mouse_draw_cursor                : bool,
    key_ctrl                         : bool,
    key_shift                        : bool,
    key_alt                          : bool,
    key_super                        : bool,
    keys_down                        : [512]bool,
    input_characters                 : [16+1]Wchar,
    nav_inputs                       : [Nav_Input.COUNT]f32,
    want_capture_mouse               : bool,
    want_capture_keyboard            : bool,
    want_text_input                  : bool,
    want_set_mouse_pos               : bool,
    want_save_ini_settings           : bool,
    nav_active                       : bool,
    nav_visible                      : bool,
    framerate                        : f32,
    metrics_render_vertices          : i32,
    metrics_render_indices           : i32,
    metrics_render_windows           : i32,
    metrics_active_windows           : i32,
    metrics_active_allocations       : i32,
    mouse_delta                      : Vec2,
    mouse_pos_prev                   : Vec2,
    mouse_clicked_pos                : [5]Vec2,
    mouse_clicked_time               : [5]f64,
    mouse_clicked                    : [5]bool,
    mouse_double_clicked             : [5]bool,
    mouse_released                   : [5]bool,
    mouse_down_owned                 : [5]bool,
    mouse_down_duration              : [5]f32,
    mouse_down_duration_prev         : [5]f32,
    mouse_drag_max_distance_abs      : [5]Vec2,
    mouse_drag_max_distance_sqr      : [5]f32,
    keys_down_duration               : [512]f32,
    keys_down_duration_prev          : [512]f32,
    nav_inputs_down_duration         : [Nav_Input.COUNT]f32,
    nav_inputs_down_duration_prev    : [Nav_Input.COUNT]f32,
}

ImVector :: struct(T : typeid) {
    size     : i32,
    capacity : i32,
    data     : ^T,
}

ImNewDummy :: struct {} //TODO(Hoej): ?????

OnceUponAFrame :: struct {
    ref_frame : i32,
}

TextFilter :: struct {
    input_buf  : [256]byte,
    filters    : ImVector(TextRange), //<TextRange>
    count_grep : i32,
}

TextBuffer :: struct {
    buf : ImVector(byte), // <char>
}

Storage :: struct
{
    data : ImVector(Pair), // <Pair>
}

InputTextCallbackData :: struct {
    event_flag      : Input_Text_Flags,
    flags           : Input_Text_Flags,
    user_data       : rawptr,
    event_char      : Wchar,
    event_key       : Key,
    buf             : ^byte,
    buf_text_len    : i32,
    buf_size        : i32,
    buf_dirty       : bool,
    cursor_pos      : i32,
    selection_start : i32,
    selection_end   : i32,
}

SizeCallbackData :: struct {
    user_data    : rawptr,
    pos          : Vec2,
    current_size : Vec2,
    desired_size : Vec2,
}

Payload :: struct {
    data             : rawptr,
    data_size        : i32,
    source_id        : ID,
    source_parent_id : ID,
    data_frame_count : i32,
    data_type        : [32+1]byte,
    preview          : bool,
    delivery         : bool,
}

Color :: struct {
    value : Vec4,
}

ListClipper :: struct {
    start_pos_y   : f32,
    items_height  : f32,
    items_count   : i32, 
    step_no       : i32, 
    display_start : i32, 
    display_end   : i32,
}

DrawCmd :: struct {
    elem_count         : u32,
    clip_rect          : Vec4,
    texture_id         : TextureID,
    user_callback      : draw_callback,
    user_callback_data : rawptr,
}

DrawVert :: struct {
    pos : Vec2,
    uv  : Vec2,
    col : u32,
}

DrawChannel :: struct {
    cmd_buffer : ImVector(DrawCmd), // <ImDrawCmd>
    idx_buffer : ImVector(DrawIdx), // <ImDrawIdx>
}

DrawList :: struct {
    cmd_buffer        : ImVector(DrawCmd), // <ImDrawCmd>
    idx_buffer        : ImVector(DrawIdx), // <ImDrawIdx>
    vtx_buffer        : ImVector(DrawVert), // <ImDrawVert>
    flags             : Draw_List_Flags,
    _data             : ^DrawListSharedData,
    _owner_name       : cstring,
    _vtx_current_idx  : u32,
    _vtx_write_ptr    : ^DrawVert,
    _idx_write_ptr    : ^DrawIdx,
    _clip_rect_stack  : ImVector(Vec4), // <ImVec4>
    _texture_id_stack : ImVector(TextureID), // <ImTextureID>
    _path             : ImVector(Vec2), // <ImVec2>
    _channels_current : i32,
    _channels_count   : i32,
    _channels         : ImVector(DrawChannel), // <ImDrawChannel>
}

DrawData :: struct {
    valid           : bool,
    cmd_lists       : ^^DrawList,
    cmd_lists_count : i32,
    total_idx_count : i32,
    total_vtx_count : i32,
    display_pos     : Vec2,
    display_size    : Vec2,
}

FontConfig :: struct {
    font_data                : rawptr,
    font_data_size           : i32,
    font_data_owned_by_atlas : bool,
    font_no                  : i32,
    size_pixels              : f32,
    oversample_h             : i32,
    oversample_v             : i32,
    pixel_snap_h             : bool,
    glyph_extra_spacing      : Vec2,
    glyph_offset             : Vec2,
    glyph_ranges             : ^Wchar,
    glyph_min_advance_x      : f32,
    glyph_max_advance_x      : f32,
    merge_mode               : bool,
    rasterizer_flags         : u32,
    rasterizer_multiply      : f32,
    name                     : [40]byte,
    dst_font                 : ^Font,
}

FontGlyph :: struct {
    Codepoint      : Wchar
    AdvanceX       : f32,
    X0, Y0, X1, Y1 : f32,
    U0, V0, U1, V1 : f32
}

FontAtlas :: struct {
    locked             : bool,
    flags              : Font_Atlas_Flags,
    tex_id             : TextureID,
    tex_desired_width  : i32,
    tex_glyph_padding  : i32,
    tex_pixels_alpha8  : ^byte,
    tex_pixels_rgba32  : ^u32,
    tex_width          : i32,
    tex_height         : i32,
    tex_uv_scale       : Vec2,
    tex_uv_white_pixel : Vec2,
    fonts              : ImVector(^Font),
    custom_rects       : ImVector(CustomRect), 
    config_data        : ImVector(FontConfig),
    custom_rect_ids    : [1]i32,
}

Font :: struct {
    font_size             : f32,
    scale                 : f32,
    display_offset        : Vec2,
    glyphs                : ImVector(FontGlyph),
    index_advance_x       : ImVector(f32),
    index_lookup          : ImVector(u32), 
    fallback_glyph        : ^FontGlyph,
    fallback_advance_x    : f32,
    fallback_char         : Wchar,
    config_data_count     : i16,
    config_data           : ^FontConfig,
    container_atlas       : ^FontAtlas,
    ascent                : f32, Descent,
    dirty_lookup_tables   : bool,
    metrics_total_surface : int,
};

GlyphRangesBuilder :: struct{
    used_chars : ImVector(u8),
}

CustomRect :: struct {
    id              : u32,
    width, height   : u32,
    x, y            : u32,
    glyph_advance_x : f32,
    glyph_offset    : Vec2,
    font            : ^Font,
}

TextRange :: struct {
    b : cstring,
    e : cstring,
}

Pair :: struct {
    key : ID,
    using _: struct #raw_union { 
        val_i : i32, 
        val_f : f32, 
        val_p : rawptr, 
    }
}

text_edit_callback       :: proc "c"(data : ^InputTextCallbackData) -> i32;
size_constraint_callback :: proc "c"(data : ^SizeCallbackData);
draw_callback            :: proc "c"(parent_list : ^DrawList, cmd : ^DrawCmd);