/*
 *  @Name:     imgui
 *
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hoej@northwolfprod.com
 *  @Creation: 10-05-2017 21:11:30
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 06-10-2018 14:15:29 UTC+1
 *
 *  @Description:
 *      Wrapper for Dear ImGui 1.52
 */

package imgui

when ODIN_DEBUG {
    foreign import cimgui "external/cimgui_debug.lib";
} else {
    foreign import "external/cimgui.lib";
} 

import "core:fmt";
import "core:mem";
import "core:math";
import "core:strings";

///////////////////////// Odin UTIL /////////////////////////

_LABEL_BUF_SIZE        :: 4096;
_TEXT_BUF_SIZE         :: 4096*2;
_DISPLAY_FMT_BUF_SIZE  :: 256;
_MISC_BUF_SIZE         :: 1024;

//TODO(Hoej): Handle when a "\x00" is passed

@(thread_local) _text_buf        : [_TEXT_BUF_SIZE       ]u8;
@(thread_local) _label_buf       : [_LABEL_BUF_SIZE      ]u8;
@(thread_local) _display_fmt_buf : [_DISPLAY_FMT_BUF_SIZE]u8;
@(thread_local) _misc_buf        : [_MISC_BUF_SIZE       ]u8;

_make_text_string :: proc       (fmt_: string, args: ..any) -> cstring {
    if fmt_ == "\x00" do return cstring(nil);
    s := fmt.bprintf(_text_buf[:], fmt_, ..args);
    _text_buf[len(s)] = 0;
    return cstring(&_text_buf[0]);
}

_make_label_string :: proc      (label : string) -> cstring {
    if label == "\x00" do return cstring(nil);
    s := fmt.bprint(_label_buf[:], label);
    _label_buf[len(s)] = 0;
    return cstring(&_label_buf[0]);
}

_make_display_fmt_string :: proc(display_fmt : string) -> cstring {
    if display_fmt == "\x00" do return cstring(nil);
    s := fmt.bprint(_display_fmt_buf[:], display_fmt);
    _display_fmt_buf[len(s)] = 0;
    return cstring(&_display_fmt_buf[0]);
}

_make_misc_string :: proc       (misc : string) -> cstring {
    if misc == "\x00" do return cstring(nil);
    s := fmt.bprint(_misc_buf[:], misc);
    _misc_buf[len(s)] = 0;
    return cstring(&_misc_buf[0]);
}

//////////////////////// Functions ////////////////////////
@(default_calling_convention="c")
foreign cimgui {
    // Main
    @(link_name = "igGetIO")             get_io        :: proc() -> ^IO ---;
    @(link_name = "igGetStyle")          get_style     :: proc() -> ^Style ---;
    @(link_name = "igGetDrawData")       get_draw_data :: proc() -> ^DrawData ---;
    @(link_name = "igNewFrame")          new_frame     :: proc() ---;
    @(link_name = "igRender")            render        :: proc() ---;
    @(link_name = "igShutdown")          shutdown      :: proc() ---;

    // Demo/Debug/Info
    @(link_name = "igShowDemoWindow")    show_demo_window    :: proc(opened : ^bool = nil) ---;
    @(link_name = "igShowMetricsWindow") show_metrics_window :: proc(opened : ^bool = nil) ---;
    @(link_name = "igShowStyleEditor")   show_style_editor   :: proc(ref : ^Style = nil) ---;
    @(link_name = "igShowUserGuide")     show_user_guide     :: proc() ---;
}


// Window
begin                         :: proc (name : string, open : ^bool = nil, flags := Window_Flags(0)) -> bool                                      { return im_begin(_make_label_string(name), open, flags); }
begin_child                   :: proc (str_id : string, size : Vec2 = Vec2{0,0}, border : bool = true, extra_flags := Window_Flags(0)) -> bool   { return im_begin_child(_make_label_string(str_id), size, border, extra_flags); }
get_content_region_max        :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_content_region_max(&res); return res; }
get_content_region_avail      :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_content_region_avail(&res); return res; }
get_window_content_region_min :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_window_content_region_min(&res); return res; }
get_window_content_region_max :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_window_content_region_max(&res); return res; }
get_window_pos                :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_window_pos(&res); return res; }
get_window_size               :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_content_region_max(&res); return res; }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igBegin")                       im_begin                         :: proc(name : cstring, p_open : ^bool, flags : Window_Flags) -> bool ---;
    @(link_name = "igEnd")                         end                              :: proc() ---;
    @(link_name = "igBeginChild")                  im_begin_child                   :: proc(str_id : cstring, size : Vec2, border : bool, extra_flags : Window_Flags) -> bool ---;
    @(link_name = "igEndChild")                    end_child                        :: proc() ---;
    @(link_name = "igGetContentRegionMax")         im_get_content_region_max        :: proc(out : ^Vec2) ---;
    @(link_name = "igGetContentRegionAvail")       im_get_content_region_avail      :: proc(out : ^Vec2) ---;
    @(link_name = "igGetContentRegionAvailWidth")  get_content_region_avail_width   :: proc() -> f32 ---;
    @(link_name = "igGetWindowContentRegionMin")   im_get_window_content_region_min :: proc(out : ^Vec2) ---;
    @(link_name = "igGetWindowContentRegionMax")   im_get_window_content_region_max :: proc(out : ^Vec2) ---;
    @(link_name = "igGetWindowContentRegionWidth") get_window_content_region_width  :: proc() -> f32 ---;
    @(link_name = "igGetWindowDrawList")           get_window_draw_list             :: proc() -> ^DrawList ---;
    @(link_name = "igGetWindowPos")                im_get_window_pos                :: proc(out : ^Vec2) ---;
    @(link_name = "igGetWindowSize")               im_get_window_size               :: proc(out : ^Vec2) ---;
    @(link_name = "igGetWindowWidth")              get_window_width                 :: proc() -> f32 ---;
    @(link_name = "igGetWindowHeight")             get_window_height                :: proc() -> f32 ---;
    @(link_name = "igIsWindowCollapsed")           is_window_collapsed              :: proc() -> bool ---;
    @(link_name = "igIsWindowAppearing")           is_window_appearing              :: proc() -> bool ---;
    @(link_name = "igSetWindowFontScale")          set_window_font_scale            :: proc(scale : f32) ---;
}

set_window_collapsed  :: proc (name : string, collapsed : bool, cond : Set_Cond)    { im_set_window_collapsed(_make_label_string(name), collapsed, cond); }
set_window_size       :: proc (name : string, size : Vec2, cond : Set_Cond)         { im_set_window_size(_make_label_string(name), size, cond); }
set_window_focus      :: proc (name : string)                                      { im_set_window_focus(_make_label_string(name)); }
set_window_pos        :: proc (name : string, pos : Vec2, cond : Set_Cond)          { im_set_window_pos(_make_label_string(name), pos, cond); }
get_cursor_pos        :: proc () -> Vec2                                           { res : Vec2 = ---; im_get_cursor_pos(&res); return res; }
get_cursor_start_pos  :: proc () -> Vec2                                           { res : Vec2 = ---; im_get_cursor_start_pos(&res); return res; }
get_cursor_screen_pos :: proc () -> Vec2                                           { res : Vec2 = ---; im_get_cursor_screen_pos(&res); return res;}



@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igSetNextWindowPos")              set_next_window_pos                :: proc (pos : Vec2, cond := Set_Cond(0), pivot : Vec2 = Vec2{0, 0}) ---;
    @(link_name = "igSetNextWindowSize")             set_next_window_size               :: proc (size : Vec2, cond := Set_Cond(0)) ---;
    @(link_name = "igSetNextWindowSizeConstraints")  set_next_window_size_constraints   :: proc (size_min : Vec2, size_max : Vec2, custom_callback : size_constraint_callback =  nil, custom_callback_data : rawptr = nil) ---;
    @(link_name = "igSetNextWindowContentSize")      set_next_window_content_size       :: proc (size : Vec2) ---;
    @(link_name = "igSetNextWindowContentWidth")     set_next_window_content_width      :: proc (width : f32) ---;
    @(link_name = "igSetNextWindowCollapsed")        set_next_window_collapsed          :: proc (collapsed : bool, cond := Set_Cond(0)) ---;
    @(link_name = "igSetNextWindowFocus")            set_next_window_focus              :: proc () ---;
    @(link_name = "igSetWindowPos")                  set_window_pos_                    :: proc (pos : Vec2, cond := Set_Cond(0)) ---;
    @(link_name = "igSetWindowSize")                 set_window_size_                    :: proc (size : Vec2, cond := Set_Cond(0)) ---;
    @(link_name = "igSetWindowCollapsed")            set_window_collapsed_               :: proc (collapsed : bool, cond := Set_Cond(0)) ---;
    @(link_name = "igSetWindowFocus")                set_window_focus_                   :: proc () ---;
    @(link_name = "igSetWindowPosByName")            im_set_window_pos                  :: proc (name : cstring, pos : Vec2, cond := Set_Cond(0)) ---;
    @(link_name = "igSetWindowSize2")                im_set_window_size                 :: proc (name : cstring, size : Vec2, cond := Set_Cond(0)) ---;
    @(link_name = "igSetWindowCollapsed2")           im_set_window_collapsed            :: proc (name : cstring, collapsed : bool, cond := Set_Cond(0)) ---;
    @(link_name = "igSetWindowFocus2")               im_set_window_focus                :: proc (name : cstring) ---;

    @(link_name = "igGetScrollX")                    get_scroll_x                       :: proc () -> f32 ---;
    @(link_name = "igGetScrollY")                    get_scroll_y                       :: proc () -> f32 ---;
    @(link_name = "igGetScrollMaxX")                 get_scroll_max_x                   :: proc () -> f32 ---;
    @(link_name = "igGetScrollMaxY")                 get_scroll_max_y                   :: proc () -> f32 ---;
    @(link_name = "igSetScrollX")                    set_scroll_x                       :: proc (scroll_x : f32) ---;
    @(link_name = "igSetScrollY")                    set_scroll_y                       :: proc (scroll_y : f32) ---;
    @(link_name = "igSetScrollHere")                 set_scroll_here                    :: proc (center_y_ratio : f32 = 0.5) ---;
    @(link_name = "igSetScrollFromPosY")             set_scroll_from_pos_y              :: proc (pos_y : f32, center_y_ratio : f32 = 0.5) ---;
    @(link_name = "igSetKeyboardFocusHere")          set_keyboard_focus_here            :: proc (offset : i32 = 0) ---;
    @(link_name = "igSetStateStorage")               set_state_storage                  :: proc (tree : ^Storage) ---;
    @(link_name = "igGetStateStorage")               get_state_storage                  :: proc () -> ^Storage ---;

    // Parameters stacks (shared)
    @(link_name = "igPushFont")                      push_font                          :: proc (font : ^Font = nil) ---;
    @(link_name = "igPopFont")                       pop_font                           :: proc () ---;
    @(link_name = "igPushStyleColorU32")             push_style_colorU32                :: proc (idx : Color, col : u32) ---;
    @(link_name = "igPushStyleColor")                push_style_color_                  :: proc (idx : Color, col : Vec4) ---;
}

push_style_color :: proc{push_style_color_, push_style_colorU32};

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igPopStyleColor")                 pop_style_color                    :: proc (count : i32 = 1) ---;
    @(link_name = "igPushStyleVar")                  push_style_var_                    :: proc (idx : Style_Var, val : f32) ---;
    @(link_name = "igPushStyleVarVec")               push_style_var_vec                 :: proc (idx : Style_Var, val : Vec2) ---;
}

push_style_var :: proc{push_style_var_, push_style_var_vec};

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igPopStyleVar")                   pop_style_var                      :: proc (count : i32 = 1) ---;
    @(link_name = "igGetStyleColorVec4")             get_style_color_vec4               :: proc (idx : Color) ---;
    @(link_name = "igGetFont")                       get_font                           :: proc () -> ^Font ---;
    @(link_name = "igGetFontSize")                   get_font_size                      :: proc () -> f32 ---;
    @(link_name = "igGetFontTexUvWhitePixel")        get_font_tex_uv_white_pixel        :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetColorU32")                   get_color_u32_                     :: proc (idx : Color, alpha_mul : f32 = 1.0) -> u32 ---;
    @(link_name = "igGetColorU32Vec")                get_color_u32_vec                  :: proc (col : ^Vec4) -> u32 ---;
    @(link_name = "igGetColorU32U32c")               get_color_u32_u32                  :: proc (col : u32) -> u32 ---;
}

get_color_u32 :: proc{get_color_u32_, get_color_u32_vec, get_color_u32_u32};

@(default_calling_convention="c")
foreign cimgui {
    // Parameters stacks (current window)
    @(link_name = "igPushItemWidth")                 push_item_width                    :: proc (item_width : f32) ---;
    @(link_name = "igPopItemWidth")                  pop_item_width                     :: proc () ---;
    @(link_name = "igCalcItemWidth")                 calc_item_width                    :: proc () -> f32 ---;
    @(link_name = "igPushTextWrapPos")               push_text_wrap_pos                 :: proc (wrap_pos_x : f32 = 0) ---;
    @(link_name = "igPopTextWrapPos")                pop_text_wrap_pos                  :: proc () ---;
    @(link_name = "igPushAllowKeyboardFocus")        push_allow_keyboard_focus          :: proc (v : bool) ---;
    @(link_name = "igPopAllowKeyboardFocus")         pop_allow_keyboard_focus           :: proc () ---;
    @(link_name = "igPushButtonRepeat")              push_button_repeat                 :: proc (repeat : bool) ---;
    @(link_name = "igPopButtonRepeat")               pop_button_repeat                  :: proc () ---;

    // Cursor / Layout
    @(link_name = "igSeparator")                     separator                          :: proc () ---;
    @(link_name = "igSameLine")                      same_line                          :: proc (pos_x : f32 = 0, spacing_w : f32 = -1) ---;
    @(link_name = "igNewLine")                       new_line                           :: proc () ---;
    @(link_name = "igSpacing")                       spacing                            :: proc () ---;
    @(link_name = "igDummy")                         dummy                              :: proc (size : ^Vec2) ---;
    @(link_name = "igIndent")                        indent                             :: proc (indent_w : f32 = 0.0) ---;
    @(link_name = "igUnindent")                      unindent                           :: proc (indent_w : f32 = 0.0) ---;
    @(link_name = "igBeginGroup")                    begin_group                        :: proc () ---;
    @(link_name = "igEndGroup")                      end_group                          :: proc () ---;
    @(link_name = "igGetCursorPos")                  im_get_cursor_pos                  :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetCursorPosX")                 get_cursor_pos_x                   :: proc () -> f32 ---;
    @(link_name = "igGetCursorPosY")                 get_cursor_pos_y                   :: proc () -> f32 ---;
    @(link_name = "igSetCursorPos")                  set_cursor_pos                     :: proc (local_pos : Vec2) ---;
    @(link_name = "igSetCursorPosX")                 set_cursor_pos_x                   :: proc (x : f32) ---;
    @(link_name = "igSetCursorPosY")                 set_cursor_pos_y                   :: proc (y : f32) ---;
    @(link_name = "igGetCursorStartPos")             im_get_cursor_start_pos            :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetCursorScreenPos")            im_get_cursor_screen_pos           :: proc (pOut : ^Vec2) ---;
    @(link_name = "igSetCursorScreenPos")            set_cursor_screen_pos              :: proc (pos : Vec2) ---;
    @(link_name = "igAlignTextToFramePadding")       align_text_to_frame_padding        :: proc () ---;
    @(link_name = "igGetTextLineHeight")             get_text_line_height               :: proc () -> f32 ---;
    @(link_name = "igGetTextLineHeightWithSpacing")  get_text_line_height_with_spacing  :: proc () -> f32 ---;
    @(link_name = "igGetFrameHeight")                get_frame_height                   :: proc () -> f32 ---;
    @(link_name = "igGetFrameHeightWithSpacing")     get_frame_height_with_spacing      :: proc () -> f32 ---;
}

//Columns
columns :: proc (count : i32, id : string = "\x00", border : bool = true) { im_columns(count, _make_label_string(id), border); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igColumns")         im_columns        :: proc (count : i32, id : cstring, border : bool)  ---;
    @(link_name = "igNextColumn")      next_column       :: proc ()  ---;
    @(link_name = "igGetColumnIndex")  get_column_index  :: proc () -> i32  ---;
    @(link_name = "igGetColumnWidth")  get_column_width  :: proc (column_index : i32 = -1) -> f32  ---;
    @(link_name = "igSetColumnWidth")  set_column_width  :: proc (column_index : i32 = -1, width : f32) -> f32  ---;
    @(link_name = "igGetColumnOffset") get_column_offset :: proc (column_index : i32 = -1) -> f32  ---;
    @(link_name = "igSetColumnOffset") set_column_offset :: proc (column_index : i32, offset_x : f32)  ---;
    @(link_name = "igGetColumnsCount") get_columns_count :: proc () -> i32  ---;

    // ID scopes
    // If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them
    // You can also use "##extra" within your widget name to distinguish them from each others (see 'Programmer Guide')
    //@TODO(Hoej): Figure out what to do here
    @(link_name = "igPushIDStr")       push_id_cstr       :: proc (str_id : cstring)  ---;
    @(link_name = "igPushIDStrRange")  push_id_cstr_range :: proc (str_begin : cstring, str_end : cstring)  ---;
    @(link_name = "igPushIDPtr")       push_id_ptr        :: proc (ptr_id : rawptr)  ---;
    @(link_name = "igPushIDInt")       push_id_i32        :: proc (int_id : i32)  ---;
    @(link_name = "igPopID")           pop_id             :: proc ()  ---;
    @(link_name = "igGetIDStr")        get_id_str         :: proc (str_id : cstring) -> ID  ---;
    @(link_name = "igGetIDStrRange")   get_id_str_range   :: proc (str_begin : cstring, str_end : cstring) -> ID  ---;
    @(link_name = "igGetIDPtr")        get_id_ptr         :: proc (ptr_id : rawptr) -> ID  ---;
}

push_id_uint :: proc(uint_id : uint)  { push_id_i32(cast(i32) uint_id); }  
push_id_int  :: proc(int_id : int)    { push_id_i32(cast(i32) int_id); }
push_id_str  :: proc(str_id : string) { push_id_cstr(_make_label_string(str_id)); }

push_id :: proc{push_id_str, push_id_cstr_range, push_id_ptr, push_id_int, push_id_i32};
get_id :: proc{get_id_str, get_id_str_range, get_id_ptr};

/////// Widgtes: Text
text_unformatted :: proc (fmt_  : string)                                 { im_text_unformatted(_make_text_string(fmt_)); }
text             :: proc (fmt_  : string, args: ..any)                   { im_text_unformatted(_make_text_string(fmt_, ..args)); }
text_colored     :: proc (col   : Vec4,   fmt_: string,  args: ..any)    { im_text_colored(col, _make_text_string(fmt_, ..args)); }
text_disabled    :: proc (fmt_  : string, args: ..any)                   { im_text_disabled(_make_text_string(fmt_, ..args)); }
text_wrapped     :: proc (fmt_  : string, args: ..any)                   { im_text_wrapped(_make_text_string(fmt_, ..args)); }
label_text       :: proc (label : string, fmt_ : string, args : ..any)   { im_label_text(_make_label_string(label), _make_text_string(fmt_, ..args)); }
bullet_text      :: proc (fmt_  : string, args: ..any)                   { im_bullet_text(_make_text_string(fmt_, ..args)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igText")            im_text             :: proc(fmt: cstring) ---;
    @(link_name = "igTextColored")     im_text_colored     :: proc(col : Vec4, fmt_ : cstring) ---;
    @(link_name = "igTextDisabled")    im_text_disabled    :: proc(fmt_ : cstring) ---;
    @(link_name = "igTextWrapped")     im_text_wrapped     :: proc(fmt: cstring) ---;
    @(link_name = "igLabelText")       im_label_text       :: proc(label : cstring, fmt_ : cstring) ---;
    @(link_name = "igBulletText")      im_bullet_text      :: proc(fmt_ : cstring) ---;
    @(link_name = "igTextUnformatted") im_text_unformatted :: proc(text : cstring, text_end : cstring = nil) ---;
    @(link_name = "igBullet")          bullet              :: proc() ---;
}

///// Widgets: Main
button           :: proc (label : string, size : Vec2 = Vec2{0, 0}) -> bool                                                                                                                                           { return im_button(_make_label_string(label), size); }
small_button     :: proc (label : string) -> bool                                                                                                                                                                     { return im_small_button(_make_label_string(label)); }
invisible_button :: proc (str_id : string, size : Vec2) -> bool                                                                                                                                                       { return im_invisible_button(_make_label_string(str_id), size);}
checkbox         :: proc (label : string, v : ^bool) -> bool                                                                                                                                                          { return im_checkbox(_make_label_string(label), v); }
checkbox_flags   :: proc (label : string, flags : ^u32, flags_value : u32) -> bool                                                                                                                                    { return im_checkbox_flags(_make_label_string(label), flags, flags_value); }
radio_buttons    :: proc (label : string, active : bool) -> bool                                                                                                                                                      { return im_radio_buttons_bool(_make_label_string(label), active); }
radio_button     :: proc (label : string, v : ^i32, v_button : i32) -> bool                                                                                                                                           { return im_radio_button(_make_label_string(label), v, v_button); }
plot_histogram   :: proc (label : string, values : []f32, overlay_text : string = "\x00", scale_min : f32 = math.F32_MAX, scale_max : f32 = math.F32_MAX, graph_size : Vec2 = Vec2{0,0}, stride : i32 = size_of(f32)) { im_plot_histogram(_make_label_string(label), &values[0], i32(len(values)), 0, _make_misc_string(overlay_text), scale_min, scale_max, graph_size, stride); }
progress_bar     :: proc (fraction : f32, size_arg : ^Vec2, overlay : string = "\x00")                                                                                                                   { im_progress_bar(fraction, size_arg, _make_misc_string(overlay)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igButton")          im_button             :: proc (label : cstring, size : Vec2) -> bool ---;
    @(link_name = "igSmallButton")     im_small_button       :: proc(label : cstring) -> bool ---;
    @(link_name = "igInvisibleButton") im_invisible_button   :: proc(str_id : cstring, size : Vec2) -> bool ---;
    @(link_name = "igImage")           image                 :: proc(user_texture_id : TextureID, size : Vec2, uv0 : Vec2 = Vec2{0, 0}, uv1 : Vec2 = Vec2{1, 1}, tint_col : Vec4 = Vec4{1, 1, 1, 1}, border_col : Vec4 = Vec4{0, 0, 0, 0}) ---;
    @(link_name = "igImageButton")     image_button          :: proc(user_texture_id : TextureID, size : Vec2, uv0 : Vec2 = Vec2{0, 0}, uv1 : Vec2 = Vec2{1, 1}, frame_padding : i32 = -1, bg_col : Vec4 = Vec4{0, 0, 0, 0}, tint_col : Vec4 = Vec4{1, 1, 1, 1}) -> bool ---;
    @(link_name = "igCheckbox")        im_checkbox           :: proc(label : cstring, v : ^bool) -> bool ---;
    @(link_name = "igCheckboxFlags")   im_checkbox_flags     :: proc(label : cstring, flags : ^u32, flags_value : u32) -> bool ---;
    @(link_name = "igRadioButtonBool") im_radio_buttons_bool :: proc(label : cstring, active : bool) -> bool ---;
    @(link_name = "igRadioButton")     im_radio_button       :: proc(label : cstring, v : ^i32, v_button : i32) -> bool ---;
    @(link_name = "igPlotLines")       plot_lines            :: proc(label : cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) ---;
    @(link_name = "igPlotLines2")      plot_lines2           :: proc(label : cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) ---;
    @(link_name = "igPlotHistogram")   im_plot_histogram     :: proc(label : cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) ---;
    @(link_name = "igPlotHistogram2")  plot_histogram2       :: proc(label : cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) ---;
    @(link_name = "igProgressBar")     im_progress_bar       :: proc(fraction : f32, size_arg : ^Vec2, overlay : cstring) ---;
    @(link_name = "igBeginCombo")      im_begin_combo        :: proc(label : cstring, preview_value : cstring, flags : Combo_Flags) -> bool ---;
    @(link_name = "igEndCombo")        end_combo             :: proc() -> bool ---;
    @(link_name = "igCombo")           im_combo              :: proc(label : cstring, current_item : ^i32, items : ^cstring, items_count : i32, height_in_items : i32) -> bool ---;
    @(link_name = "igCombo2")          combo2                :: proc(label : cstring, current_item : ^i32, items_separated_by_zeros : cstring, height_in_items : i32) -> bool ---;
    @(link_name = "igCombo3")          combo3                :: proc(label : cstring, current_item : ^i32, items_getter : proc "cdecl"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, height_in_items : i32) -> bool ---;
}

combo            :: proc (label : string, current_item : ^i32, items : []string, height_in_items : i32 = -1) -> bool {
    data := make([]cstring, len(items)); defer delete(data);
    for item, idx in items {
        data[idx] = strings.clone_to_cstring(item);
    }
    return im_combo(_make_label_string(label), current_item, &data[0], i32(len(items)), height_in_items);
}

drag_float :: proc{drag_float1, drag_float2, drag_float3, drag_float4};

// Widgets: Drags (tip: ctrl+click on a drag box to input text)
drag_float1 :: proc(label : string, v : ^f32,    v_speed : f32 = 1, v_min : f32 = 0, v_max : f32 = 0, display_format : string = "%.3f", power : f32 = 1)         { im_drag_float(_make_label_string(label), v, v_speed, v_min, v_max, _make_display_fmt_string(display_format), power); }
drag_float2 :: proc(label : string, v : ^[2]f32, v_speed : f32 = 1, v_min : f32 = 0, v_max : f32 = 0, display_format : string = "%.3f", power : f32 = 1) -> bool { return im_drag_float2(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power); }
drag_float3 :: proc(label : string, v : ^[3]f32, v_speed : f32 = 1, v_min : f32 = 0, v_max : f32 = 0, display_format : string = "%.3f", power : f32 = 1) -> bool { return im_drag_float3(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power); }
drag_float4 :: proc(label : string, v : ^[4]f32, v_speed : f32 = 1, v_min : f32 = 0, v_max : f32 = 0, display_format : string = "%.3f", power : f32 = 1) -> bool { return im_drag_float4(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power); }
drag_float_range :: proc(label : string, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : string, power : f32) -> bool {
    id  := _make_label_string(label);
    df  := _make_display_fmt_string(display_format);
    mdf := _make_misc_string(display_format_max);
    return im_drag_float_range(id, v_current_min, v_current_max, v_speed, v_min, v_max, df, mdf, power);
}

drag_int :: proc{drag_int1, drag_int2, drag_int3, drag_int4};
drag_int1 :: proc(label : string, v : ^i32,    v_speed : f32 = 1, v_min : i32 = 0, v_max : i32 = 0, display_format : string = "%d") { im_drag_int(_make_label_string(label), v, v_speed, v_min, v_max, _make_display_fmt_string(display_format)); }
drag_int2 :: proc(label : string, v : ^[2]i32, v_speed : f32 = 1, v_min : i32 = 0, v_max : i32 = 0, display_format : string = "%d") { im_drag_int2(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format)); }
drag_int3 :: proc(label : string, v : ^[3]i32, v_speed : f32 = 1, v_min : i32 = 0, v_max : i32 = 0, display_format : string = "%d") { im_drag_int3(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format)); }
drag_int4 :: proc(label : string, v : ^[4]i32, v_speed : f32 = 1, v_min : i32 = 0, v_max : i32 = 0, display_format : string = "%d") { im_drag_int4(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format)); }
drag_int_range :: proc(label : string, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : string) -> bool {
    id  := _make_label_string(label);
    df  := _make_display_fmt_string(display_format);
    mdf := _make_misc_string(display_format_max);
    return im_drag_int_range(id, v_current_min, v_current_max, v_speed, v_min, v_max, df, mdf);
}

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igDragFloat")       im_drag_float       :: proc(label : cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : cstring, power : f32) ---;
    @(link_name = "igDragFloat2")      im_drag_float2      :: proc(label : cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : cstring, power : f32) -> bool ---;
    @(link_name = "igDragFloat3")      im_drag_float3      :: proc(label : cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : cstring, power : f32) -> bool ---;
    @(link_name = "igDragFloat4")      im_drag_float4      :: proc(label : cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : cstring, power : f32) -> bool ---;
    @(link_name = "igDragFloatRange2") im_drag_float_range :: proc(label : cstring, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : cstring, power : f32) -> bool ---;
    @(link_name = "igDragInt")         im_drag_int         :: proc(label : cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : cstring) ---;
    @(link_name = "igDragInt2")        im_drag_int2        :: proc(label : cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : cstring) ---;
    @(link_name = "igDragInt3")        im_drag_int3        :: proc(label : cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : cstring) ---;
    @(link_name = "igDragInt4")        im_drag_int4        :: proc(label : cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : cstring) ---;
    @(link_name = "igDragIntRange2")   im_drag_int_range   :: proc(label : cstring, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : cstring) -> bool ---;
}

// Widgets: Input with Keyboard
input_text           :: proc(label : string, buf : []u8, flags := Input_Text_Flags(0), callback : text_edit_callback = nil, user_data : rawptr = nil) -> bool              { return im_input_text(_make_label_string(label), cstring(&buf[0]), uint(len(buf)), flags, callback, user_data); }
input_text_multiline :: proc(label : string, buf : []u8, size : Vec2, flags := Input_Text_Flags(0), callback : text_edit_callback = nil, user_data : rawptr = nil) -> bool { return im_input_text_multiline(_make_label_string(label), cstring(&buf[0]), uint(len(buf)), size, flags, callback, user_data); }

input_float          :: proc{input_float1, input_float2, input_float3, input_float4};
input_float1         :: proc(label : string, v : ^f32, step : f32 = 0, step_fast : f32 = 0, decimal_precision : i32 = -1, extra_flags := Input_Text_Flags(0)) -> bool          { return im_input_float(_make_label_string(label), v, step, step_fast, decimal_precision, extra_flags); }
input_float2         :: proc(label : string, v : ^[2]f32, decimal_precision : i32 = -1, extra_flags := Input_Text_Flags(0)) -> bool                                            { return im_input_float2(_make_label_string(label), &v[0], decimal_precision, extra_flags); }
input_float3         :: proc(label : string, v : ^[3]f32, decimal_precision : i32 = -1, extra_flags := Input_Text_Flags(0)) -> bool                                            { return im_input_float3(_make_label_string(label), &v[0], decimal_precision, extra_flags); }
input_float4         :: proc(label : string, v : ^[4]f32, decimal_precision : i32 = -1, extra_flags := Input_Text_Flags(0)) -> bool                                            { return im_input_float4(_make_label_string(label), &v[0], decimal_precision, extra_flags); }

input_int            :: proc{input_int1, input_int2, input_int3, input_int4};
input_int1           :: proc(label : string, v : ^i32, step : i32 = 0, step_fast : i32 = 0, extra_flags := Input_Text_Flags(0)) -> bool                                        { return im_input_int(_make_label_string(label), v, step, step_fast, extra_flags); }
input_int2           :: proc(label : string, v : ^[2]i32, extra_flags := Input_Text_Flags(0)) -> bool                                                                          { return im_input_int2(_make_label_string(label), &v[0], extra_flags); }
input_int3           :: proc(label : string, v : ^[3]i32, extra_flags := Input_Text_Flags(0)) -> bool                                                                          { return im_input_int3(_make_label_string(label), &v[0], extra_flags); }
input_int4           :: proc(label : string, v : ^[4]i32, extra_flags := Input_Text_Flags(0)) -> bool                                                                          { return im_input_int4(_make_label_string(label), &v[0], extra_flags); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igInputText")          im_input_text           :: proc(label : cstring, buf : cstring, buf_size : uint /*size_t*/, flags : Input_Text_Flags, callback : text_edit_callback, user_data : rawptr) -> bool ---;
    @(link_name = "igInputTextMultiline") im_input_text_multiline :: proc(label : cstring, buf : cstring, buf_size : uint /*size_t*/, size : Vec2, flags : Input_Text_Flags, callback : text_edit_callback, user_data : rawptr) -> bool ---;
    @(link_name = "igInputFloat")         im_input_float          :: proc(label : cstring, v : ^f32, step : f32, step_fast : f32, decimal_precision : i32, extra_flags : Input_Text_Flags) -> bool ---;
    @(link_name = "igInputFloat2")        im_input_float2         :: proc(label : cstring, v : ^f32, decimal_precision : i32, extra_flags : Input_Text_Flags) -> bool ---;
    @(link_name = "igInputFloat3")        im_input_float3         :: proc(label : cstring, v : ^f32, decimal_precision : i32, extra_flags : Input_Text_Flags) -> bool ---;
    @(link_name = "igInputFloat4")        im_input_float4         :: proc(label : cstring, v : ^f32, decimal_precision : i32, extra_flags : Input_Text_Flags) -> bool ---;
    @(link_name = "igInputInt")           im_input_int            :: proc(label : cstring, v : ^i32, step : i32, step_fast : i32, extra_flags : Input_Text_Flags) -> bool ---;
    @(link_name = "igInputInt2")          im_input_int2           :: proc(label : cstring, v : ^i32, extra_flags : Input_Text_Flags) -> bool ---;
    @(link_name = "igInputInt3")          im_input_int3           :: proc(label : cstring, v : ^i32, extra_flags : Input_Text_Flags) -> bool ---;
    @(link_name = "igInputInt4")          im_input_int4           :: proc(label : cstring, v : ^i32, extra_flags : Input_Text_Flags) -> bool ---;
}

// Widgets: Sliders (tip: ctrl+click on a slider to input text)
slider_float   :: proc{slider_float1, slider_float2, slider_float3, slider_float4};
slider_float1  :: proc(label : string, v : ^f32, v_min : f32, v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool               { return im_slider_float(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format), power); }
slider_float2  :: proc(label : string, v : ^[2]f32, v_min : f32, v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool            { return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power); }
slider_float3  :: proc(label : string, v : ^[3]f32, v_min : f32, v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool            { return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power); }
slider_float4  :: proc(label : string, v : ^[4]f32, v_min : f32, v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool            { return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power); }
slider_angle   :: proc(label : string, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool                                              { return im_slider_angle(_make_label_string(label),v_rad, v_degrees_min, v_degrees_max); }

slider_int     :: proc{slider_int1, slider_int2, slider_int3, slider_int4};
slider_int1    :: proc(label : string, v : ^i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                                  { return im_slider_int(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format)); }
slider_int2    :: proc(label : string, v : ^[2]i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                               { return im_slider_int2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format)); }
slider_int3    :: proc(label : string, v : ^[3]i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                               { return im_slider_int3(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format)); }
slider_int4    :: proc(label : string, v : ^[4]i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                               { return im_slider_int4(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format)); }
vslider_float  :: proc(label : string, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool { return im_vslider_float(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format), power); }
vslider_int    :: proc(label : string, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                     { return im_vslider_int(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igSliderFloat")  im_slider_float  :: proc(label : cstring, v : ^f32, v_min : f32, v_max : f32, display_format : cstring, power : f32) -> bool ---;
    @(link_name = "igSliderFloat2") im_slider_float2 :: proc(label : cstring, v : ^f32, v_min : f32, v_max : f32, display_format : cstring, power : f32) -> bool ---;
    @(link_name = "igSliderFloat3") im_slider_float3 :: proc(label : cstring, v : ^f32, v_min : f32, v_max : f32, display_format : cstring, power : f32) -> bool ---;
    @(link_name = "igSliderFloat4") im_slider_float4 :: proc(label : cstring, v : ^f32, v_min : f32, v_max : f32, display_format : cstring, power : f32) -> bool ---;
    @(link_name = "igSliderAngle")  im_slider_angle  :: proc(label : cstring, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool                    ---;
    @(link_name = "igSliderInt")    im_slider_int    :: proc(label : cstring, v : ^i32, v_min : i32, v_max : i32, display_format : cstring) -> bool ---;
    @(link_name = "igSliderInt2")   im_slider_int2   :: proc(label : cstring, v : ^i32, v_min : i32, v_max : i32, display_format : cstring) -> bool ---;
    @(link_name = "igSliderInt3")   im_slider_int3   :: proc(label : cstring, v : ^i32, v_min : i32, v_max : i32, display_format : cstring) -> bool ---;
    @(link_name = "igSliderInt4")   im_slider_int4   :: proc(label : cstring, v : ^i32, v_min : i32, v_max : i32, display_format : cstring) -> bool ---;
    @(link_name = "igVSliderFloat") im_vslider_float :: proc(label : cstring, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : cstring, power : f32) -> bool ---;
    @(link_name = "igVSliderInt")   im_vslider_int   :: proc(label : cstring, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : cstring) -> bool               ---;
}

color_edit    :: proc{color_edit3, color_edit4};
color_edit3   :: proc(label : string, col : [3]f32, flags := Color_Edit_Flags(0)) -> bool                           { return im_color_edit3(_make_label_string(label), &col[0], flags) }
color_edit4   :: proc(label : string, col : [4]f32, flags := Color_Edit_Flags(0)) -> bool                           { return im_color_edit4(_make_label_string(label), &col[0], flags) }

color_picker  :: proc{color_picker3, color_picker4};
color_picker3 :: proc(label : string, col : [3]f32, flags := Color_Edit_Flags(0)) -> bool                           { return im_color_picker3(_make_label_string(label), &col[0], flags) }
color_picker4 :: proc(label : string, col : [4]f32, flags := Color_Edit_Flags(0)) -> bool                           { return im_color_picker4(_make_label_string(label), &col[0], flags) }
color_button  :: proc(desc_id : string, col : Vec4, flags := Color_Edit_Flags(0), size : Vec2 = Vec2{0, 0}) -> bool { return im_color_button(_make_label_string(desc_id), col, flags, size) }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igColorEdit3")          im_color_edit3         :: proc(label : cstring, col : ^f32, flags : Color_Edit_Flags) -> bool ---;
    @(link_name = "igColorEdit4")          im_color_edit4         :: proc(label : cstring, col : ^f32, flags : Color_Edit_Flags) -> bool ---;
    @(link_name = "igColorPicker3")        im_color_picker3       :: proc(label : cstring, col : ^f32, flags : Color_Edit_Flags) -> bool ---;
    @(link_name = "igColorPicker4")        im_color_picker4       :: proc(label : cstring, col : ^f32, flags : Color_Edit_Flags, ref_col : ^f32 = nil) -> bool ---;
    @(link_name = "igColorButton")         im_color_button        :: proc(desc_id : cstring, col : Vec4, flags : Color_Edit_Flags, size : Vec2) -> bool ---;
    @(link_name = "igSetColorEditOptions") set_color_edit_options :: proc(flags : Color_Edit_Flags)  ---;
}

// Widgets: Trees
tree_node               :: proc{tree_node_str, tree_node_str_fmt, tree_node_ptr};
tree_node_str           :: proc(label : string) -> bool                                                              { return im_tree_node(_make_label_string(label)); }
tree_node_str_fmt       :: proc(str_id : string, fmt_ : string, args : ..any) -> bool                               { return im_tree_node_str(_make_label_string(str_id), _make_text_string(fmt_, ..args)); }
tree_node_ptr           :: proc(ptr_id : rawptr, fmt_ : string, args : ..any) -> bool                               { return im_tree_node_ptr(ptr_id, _make_text_string(fmt_, ..args)); }

tree_node_ext           :: proc{tree_node_ext_str, tree_node_ext_str_fmt, tree_node_ext_ptr};
tree_node_ext_str       :: proc(label : string, flags := Tree_Node_Flags(0)) -> bool                                { return im_tree_node_ex(_make_label_string(label), flags); }
tree_node_ext_str_fmt   :: proc(str_id : string, flags := Tree_Node_Flags(0), fmt_ : string, args : ..any) -> bool { return im_tree_node_ex_str(_make_label_string(str_id), flags, _make_text_string(fmt_, ..args)); }
tree_node_ext_ptr       :: proc(ptr_id : rawptr, flags := Tree_Node_Flags(0), fmt_ : string, args : ..any) -> bool { return im_tree_node_ex_ptr(ptr_id, flags, _make_text_string(fmt_, ..args)); }

tree_push               :: proc{tree_push_str, tree_push_ptr};
tree_push_str           :: proc(str_id : string)                                                                     { im_tree_push_str(_make_label_string(str_id)); }

collapsing_header       :: proc{collapsing_header_, collapsing_header_ext};
collapsing_header_      :: proc(label : string, flags := Tree_Node_Flags(0)) -> bool                                { return im_collapsing_header(_make_label_string(label), flags); }
collapsing_header_ext   :: proc(label : string, p_open : ^bool, flags := Tree_Node_Flags(0)) -> bool                { return im_collapsing_header_ex(_make_label_string(label), p_open, flags); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igTreeNode")                  im_tree_node                   :: proc(label : cstring) -> bool ---;
    @(link_name = "igTreeNodeStr")               im_tree_node_str               :: proc(str_id : cstring, fmt_ : cstring) -> bool ---;
    @(link_name = "igTreeNodePtr")               im_tree_node_ptr               :: proc(ptr_id : rawptr, fmt_ : cstring) -> bool ---;
    @(link_name = "igTreeNodeEx")                im_tree_node_ex                :: proc(label : cstring, flags : Tree_Node_Flags) -> bool ---;
    @(link_name = "igTreeNodeExStr")             im_tree_node_ex_str            :: proc(str_id : cstring, flags : Tree_Node_Flags, fmt_ : cstring) -> bool ---;
    @(link_name = "igTreeNodeExPtr")             im_tree_node_ex_ptr            :: proc(ptr_id : rawptr, flags : Tree_Node_Flags, fmt_ : cstring) -> bool ---;
    @(link_name = "igTreePushStr")               im_tree_push_str               :: proc(str_id : cstring) ---;
    @(link_name = "igTreePushPtr")               tree_push_ptr                  :: proc(ptr_id : rawptr) ---;

    @(link_name = "igTreePop")                   tree_pop                       :: proc() ---;
    @(link_name = "igTreeAdvanceToLabelPos")     tree_advance_to_label_pos      :: proc() ---;
    @(link_name = "igGetTreeNodeToLabelSpacing") get_tree_node_to_label_spacing :: proc() -> f32 ---;
    @(link_name = "igSetNextTreeNodeOpen")       set_next_tree_node_open        :: proc(opened : bool, cond : Set_Cond) ---;
    @(link_name = "igCollapsingHeader")          im_collapsing_header           :: proc(label : cstring, flags : Tree_Node_Flags) -> bool ---;
    @(link_name = "igCollapsingHeaderEx")        im_collapsing_header_ex        :: proc(label : cstring, p_open : ^bool, flags : Tree_Node_Flags) -> bool ---;
}

// Widgets: Selectable / Lists
selectable      :: proc{selectable_val, selectable_ptr};
selectable_val  :: proc(label : string, selected : bool = false, flags := Selectable_Flags(0), size : Vec2 = Vec2{0,0}) -> bool { return im_selectable(_make_label_string(label), selected, flags, size); }
selectable_ptr  :: proc(label : string, p_selected : ^bool, flags := Selectable_Flags(0), size : Vec2 = Vec2{0,0}) -> bool      { return im_selectable_ex(_make_label_string(label), p_selected, flags, size); }

list_box_header        :: proc{list_box_header_simple, list_box_header_count};
list_box_header_simple :: proc(label : string, size : Vec2 = Vec2{0, 0}) -> bool                      { return im_list_box_header(_make_label_string(label), size); }
list_box_header_count  :: proc(label : string, items_count : i32, height_in_items : i32 = -1) -> bool { return im_list_box_header2(_make_label_string(label), items_count, height_in_items); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igSelectable")     im_selectable      :: proc(label : cstring, selected : bool, flags : Selectable_Flags, size : Vec2) -> bool ---;
    @(link_name = "igSelectableEx")   im_selectable_ex   :: proc(label : cstring, p_selected : ^bool, flags : Selectable_Flags, size : Vec2) -> bool ---;
    @(link_name = "igListBox")        list_box1          :: proc(label : cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool ---;
    @(link_name = "igListBox2")       list_box2          :: proc(label : cstring, current_item : ^i32, items_getter : proc "cdecl"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, height_in_items : i32) -> bool ---;
}

list_box :: proc{list_box1, list_box2};

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igListBoxHeader")  im_list_box_header :: proc(label : cstring, size : Vec2) -> bool ---;
    @(link_name = "igListBoxHeader2") im_list_box_header2 :: proc(label : cstring, items_count : i32, height_in_items : i32) -> bool ---;
    @(link_name = "igListBoxFooter")  list_box_footer    :: proc() ---;
}

// Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare your own within the ImGui namespace!)
value       :: proc{value_bool, value_int, value_uint, value_float, value_color};
value_bool  :: proc(prefix : string, b : bool)                          { im_value_bool(_make_label_string(prefix), b); }
value_int   :: proc(prefix : string, v : i32)                           { im_value_int(_make_label_string(prefix), v); }
value_uint  :: proc(prefix : string, v : u32)                           { im_value_uint(_make_label_string(prefix), v); }
value_float :: proc(prefix : string, v : f32, format : string = "\x00") { im_value_float(_make_label_string(prefix), v, _make_misc_string(format)); }
value_color :: proc(prefix : string, v : Vec4)                          { im_value_color(_make_label_string(prefix), v); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igValueBool")  im_value_bool  :: proc(prefix : cstring, b : bool) ---;
    @(link_name = "igValueInt")   im_value_int   :: proc(prefix : cstring, v : i32) ---;
    @(link_name = "igValueUInt")  im_value_uint  :: proc(prefix : cstring, v : u32) ---;
    @(link_name = "igValueFloat") im_value_float :: proc(prefix : cstring, v : f32, float_format : cstring) ---;
    @(link_name = "igValueColor") im_value_color :: proc(prefix : cstring, v : Vec4) ---;
}

// Tooltip
set_tooltip :: proc(fmt_ : string, args : ..any) { im_set_tooltip(_make_text_string(fmt_, ..args)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igSetTooltip")   im_set_tooltip :: proc(fmt : cstring) ---;
    @(link_name = "igBeginTooltip") begin_tooltip  :: proc() ---;
    @(link_name = "igEndTooltip")   end_tooltip    :: proc() ---;
}

begin_menu :: proc(label : string, enabled : bool = true) -> bool                                                      { return im_begin_menu(_make_label_string(label), enabled); }

menu_item   :: proc{menu_item1, menu_item2};
menu_item1  :: proc(label : string, shortcut : string = "\x00", selected : bool = false, enabled : bool = true) -> bool { return im_menu_item(_make_label_string(label), _make_misc_string(shortcut), selected, enabled); }
menu_item2  :: proc(label : string, shortcut : string, selected : ^bool , enabled : bool = true) -> bool                { return im_menu_item_ptr(_make_label_string(label), _make_misc_string(shortcut), selected, enabled); }

// Widgets: Menus
@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igBeginMainMenuBar") begin_main_menu_bar :: proc() -> bool ---;
    @(link_name = "igEndMainMenuBar")   end_main_menu_bar   :: proc() ---;
    @(link_name = "igBeginMenuBar")     begin_menu_bar      :: proc() -> bool ---;
    @(link_name = "igEndMenuBar")       end_menu_bar        :: proc() ---;
    @(link_name = "igBeginMenu")        im_begin_menu       :: proc(label : cstring, enabled : bool) -> bool ---;
    @(link_name = "igEndMenu")          end_menu            :: proc() ---;
    @(link_name = "igMenuItem")         im_menu_item        :: proc(label : cstring, shortcut : cstring, selected : bool, enabled : bool) -> bool ---;
    @(link_name = "igMenuItemPtr")      im_menu_item_ptr    :: proc(label : cstring, shortcut : cstring, p_selected : ^bool, enabled : bool) -> bool ---;
}

// Popup
open_popup                 :: proc(str_id : string)                                                         { im_open_popup(_make_label_string(str_id)); }
open_popup_on_item_click   :: proc(str_id : string, mouse_button : int = 1) -> bool                         { return im_open_popup_on_item_click(_make_label_string(str_id), mouse_button) }
begin_popup                :: proc(str_id : string) -> bool                                                 { return im_begin_popup(_make_label_string(str_id)); }
begin_popup_modal          :: proc(name : string, open : ^bool = nil, extra_flags := Window_Flags(0)) -> bool   { return im_begin_popup_modal(_make_label_string(name), open, extra_flags); }
begin_popup_context_item   :: proc(str_id : string, mouse_button : i32 = 1) -> bool                         { return im_begin_popup_context_item(_make_label_string(str_id), mouse_button); }
begin_popup_context_window :: proc(also_over_items : bool, str_id : string, mouse_button : i32 = 1) -> bool { return im_begin_popup_context_window(also_over_items, _make_label_string(str_id), mouse_button); }
begin_popup_context_void   :: proc(str_id : string, mouse_button : i32 = 1) -> bool                         { return im_begin_popup_context_void(_make_label_string(str_id), mouse_button); }
is_popup_open              :: proc(str_id : string) -> bool                                                 { return im_is_popup_open(_make_label_string(str_id)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igOpenPopup")               im_open_popup                 :: proc(str_id : cstring) ---;
    @(link_name = "igOpenPopupOnItemClick")    im_open_popup_on_item_click   :: proc(str_id : cstring, mouse_button : int) -> bool ---;
    @(link_name = "igBeginPopup")              im_begin_popup                :: proc(str_id : cstring) -> bool ---;
    @(link_name = "igBeginPopupModal")         im_begin_popup_modal          :: proc(name : cstring, p_open : ^bool, extra_flags : Window_Flags) -> bool ---;
    @(link_name = "igBeginPopupContextItem")   im_begin_popup_context_item   :: proc(str_id : cstring, mouse_button : i32) -> bool ---;
    @(link_name = "igBeginPopupContextWindow") im_begin_popup_context_window :: proc(also_over_items : bool, str_id : cstring, mouse_button : i32) -> bool ---;
    @(link_name = "igBeginPopupContextVoid")   im_begin_popup_context_void   :: proc(str_id : cstring, mouse_button : i32) -> bool ---;
    @(link_name = "igEndPopup")                end_popup                     :: proc() ---;
    @(link_name = "igIsPopupOpen")             im_is_popup_open              :: proc(str_id : cstring) -> bool ---;
    @(link_name = "igCloseCurrentPopup")       close_current_popup           :: proc() ---;
}

log_text :: proc(fmt_ : string, args : ..any) { im_log_text(_make_text_string(fmt_, ..args)); }

@(default_calling_convention="c")
foreign cimgui {
    // Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened.
    @(link_name = "igLogToTTY")       log_to_tty       :: proc(max_depth : i32) ---;
    @(link_name = "igLogToFile")      log_to_file      :: proc(max_depth : i32, filename : cstring) ---;
    @(link_name = "igLogToClipboard") log_to_clipboard :: proc(max_depth : i32) ---;
    @(link_name = "igLogFinish")      log_finish       :: proc() ---;
    @(link_name = "igLogButtons")     log_buttons      :: proc() ---;
    @(link_name = "igLogText")        im_log_text      :: proc(fmt_ : cstring) ---;

    //Drag n' Drop
    @(link_name = "igBeginDragDropSource")   begin_drag_drop_source      :: proc(flags : Drag_Drop_Flags, mouse_button : i32) -> bool ---;
    @(link_name = "igSetDragDropPayload")    im_set_drag_drop_payload    :: proc(type_ : cstring, data : rawptr, size : uint, cond : Set_Cond) -> bool ---;
    @(link_name = "igEndDragDropSource")     end_drag_drop_source        :: proc() ---;
    @(link_name = "igBeginDragDropTarget")   begin_drag_drop_target      :: proc() -> bool ---;
    @(link_name = "igAcceptDragDropPayload") im_accept_drag_drop_payload :: proc(type_ : cstring, flags : Drag_Drop_Flags) -> ^Payload ---;
    @(link_name = "igEndDragDropTarget")     end_drag_drop_target        :: proc() ---;
}

set_drag_drop_payload :: proc(type_ : string, data : rawptr, size : uint, cond : Set_Cond) -> bool { return im_set_drag_drop_payload(_make_misc_string(type_), data, size, cond) }
accept_drag_drop_payload :: proc(type_ : string, flags : Drag_Drop_Flags) -> ^Payload             { return im_accept_drag_drop_payload(_make_misc_string(type_), flags) }

@(default_calling_convention="c")
foreign cimgui {
    // Clipping
    @(link_name = "igPushClipRect")                     push_clip_rect                         :: proc(clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) ---;
    @(link_name = "igPopClipRect")                      pop_clip_rect                          :: proc() ---;

    // Styles
    @(link_name = "igStyleColorsClassic")               style_colors_classic                   :: proc(dst : ^Style) ---;
    @(link_name = "igStyleColorsDark")                  style_colors_dark                      :: proc(dst : ^Style) ---;
    @(link_name = "igStyleColorsLight")                 style_colors_light                     :: proc(dst : ^Style) ---;

    // Utilities
    @(link_name = "igIsItemHovered")                    is_item_hovered                        :: proc (flags := Hovered_Flags(0)) -> bool ---;
    @(link_name = "igIsItemActive")                     is_item_active                         :: proc () -> bool ---;
    @(link_name = "igIsItemClicked")                    is_item_clicked                        :: proc (mouse_button : i32 = 0) -> bool ---;
    @(link_name = "igIsItemVisible")                    is_item_visible                        :: proc () -> bool ---;
    @(link_name = "igIsAnyItemHovered")                 is_any_item_hovered                    :: proc () -> bool ---;
    @(link_name = "igIsAnyItemActive")                  is_any_item_active                     :: proc () -> bool ---;
    @(link_name = "igGetItemRectMin")                   get_item_rect_min                      :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetItemRectMax")                   get_item_rect_max                      :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetItemRectSize")                  get_item_rect_size                     :: proc (pOut : ^Vec2) ---;
    @(link_name = "igSetItemAllowOverlap")              set_item_allow_overlap                 :: proc () ---;
    @(link_name = "igIsWindowFocused")                  is_window_focused                      :: proc (flags := Hovered_Flags(0)) -> bool ---;
    @(link_name = "igIsWindowHovered")                  is_window_hovered                      :: proc (flags := Hovered_Flags(0)) -> bool ---;
    @(link_name = "igIsRootWindowFocused")              is_root_window_focused                 :: proc () -> bool ---;
    @(link_name = "igIsRootWindowOrAnyChildFocused")    is_root_window_or_any_child_focused    :: proc () -> bool ---;
    @(link_name = "igIsRootWindowOrAnyChildHovered")    is_root_window_or_any_child_hovered    :: proc (flags := Hovered_Flags(0)) -> bool ---;
    @(link_name = "igIsRectVisible")                    is_rect_visible_size                   :: proc (item_size : Vec2) -> bool ---;
    @(link_name = "igIsRectVisible2")                   is_rect_visible_minmax                 :: proc (min : ^Vec2, max : ^Vec2) -> bool ---;
}

is_rect_visible :: proc{is_rect_visible_size, is_rect_visible_minmax};

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igIsPosHoveringAnyWindow")           is_pos_hovering_any_window             :: proc (pos : Vec2) -> bool ---;
    @(link_name = "igGetTime")                          get_time                               :: proc () -> f32 ---;
    @(link_name = "igGetFrameCount")                    get_frame_count                        :: proc () -> i32 ---;
    @(link_name = "igGetOverlayDrawList")               get_overlay_draw_list                  :: proc () -> ^DrawList ---;
    //@(link_name = "igGetDrawListSharedData")          get_draw_list_shared_data            :: proc () -> ^DrawListSharedData ---; NOTE(Hoej): Missing struct definiton.
    @(link_name = "igGetStyleColName")                  get_style_col_name                     :: proc (idx : Color) -> cstring ---;
    @(link_name = "igCalcItemRectClosestPoint")         calc_item_rect_closest_point           :: proc (pOut : ^Vec2, pos : Vec2 , on_edge : bool, outward : f32 = 0) ---;
    @(link_name = "igCalcTextSize")                     calc_text_size                         :: proc (pOut : ^Vec2, text : cstring, text_end : cstring, hide_text_after_double_hash : bool, wrap_width : f32 = -1) ---;
    @(link_name = "igCalcListClipping")                 calc_list_clipping                     :: proc (items_count : i32, items_height : f32, out_items_display_start : ^i32, out_items_display_end : ^i32) ---;

    @(link_name = "igBeginChildFrame")                  begin_child_frame                      :: proc(id : ID, size : Vec2, extra_flags := Window_Flags(0)) -> bool ---;
    @(link_name = "igEndChildFrame")                    end_child_frame                        :: proc  () ---;

    @(link_name = "igColorConvertU32ToFloat4")          color_convert_u32_to_float4            :: proc(pOut : ^Vec4 , in_ : u32) ---;
    @(link_name = "igColorConvertFloat4ToU32")          color_convert_float4_to_u32            :: proc(in_ : Vec4) -> u32 ---;
    @(link_name = "igColorConvertRGBtoHSV")             color_convert_rgb_to_hsv               :: proc(r : f32, g : f32, b : f32, out_h : ^f32, out_s : ^f32, out_v : ^f32) ---;
    @(link_name = "igColorConvertHSVtoRGB")             color_convert_hsv_to_rgb               :: proc(h : f32, s : f32, v : f32, out_r : ^f32, out_g : ^f32, out_b : ^f32) ---;

    @(link_name = "igGetKeyIndex")                      get_key_index                          :: proc (key : Key) -> i32 ---;
    @(link_name = "igIsKeyDown")                        is_key_down                            :: proc (key_index : i32) -> bool ---;
    @(link_name = "igIsKeyPressed")                     is_key_pressed                         :: proc (key_index : i32, repeat : bool = true) -> bool ---;
    @(link_name = "igIsKeyReleased")                    is_key_released                        :: proc (key_index : i32) -> bool ---;
    @(link_name = "igGetKeyPressedAmount")              get_key_pressed_amount                 :: proc (key_index : i32, key_repeat_delay : f32, rate : f32) -> i32 ---;
    @(link_name = "igIsMouseDown")                      is_mouse_down                          :: proc (button : i32) -> bool ---;
    @(link_name = "igIsMouseClicked")                   is_mouse_clicked                       :: proc (button : i32, repeat : bool) -> bool ---;
    @(link_name = "igIsMouseDoubleClicked")             is_mouse_double_clicked                :: proc (button : i32) -> bool ---;
    @(link_name = "igIsMouseReleased")                  is_mouse_released                      :: proc (button : i32) -> bool ---;
    @(link_name = "igIsMouseDragging")                  is_mouse_dragging                      :: proc (button : i32 = 0, lock_threshold : f32 = -1) -> bool ---;
    @(link_name = "igIsMouseHoveringRect")              is_mouse_hovering_rect                 :: proc (r_min : Vec2, r_max : Vec2, clip : bool = true) -> bool ---;
    @(link_name = "igGetMousePos")                      get_mouse_pos                          :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetMousePosOnOpeningCurrentPopup") get_mouse_pos_on_opening_current_popup :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetMouseDragDelta")                get_mouse_drag_delta                   :: proc (pOut : ^Vec2, button : i32 = 0, lock_threshold : f32 = -1) ---;
    @(link_name = "igResetMouseDragDelta")              reset_mouse_drag_delta                 :: proc (button : i32 = 0) ---;
    @(link_name = "igGetMouseCursor")                   get_mouse_cursor                       :: proc () -> Mouse_Cursor ---;
    @(link_name = "igSetMouseCursor")                   set_mouse_cursor                       :: proc (type_ : Mouse_Cursor) ---;
    @(link_name = "igCaptureKeyboardFromApp")           capture_keyboard_from_app              :: proc (capture : bool) ---;
    @(link_name = "igCaptureMouseFromApp")              capture_mouse_from_app                 :: proc (capture : bool) ---;
}

get_clipboard_text :: proc() -> string { c_str := im_get_clipboard_text(); o_str := string(cstring(c_str)); return o_str; }
set_clipboard_text :: proc(text : string) { im_set_clipboard_text(_make_text_string(text)); }

@(default_calling_convention="c")
foreign cimgui {
// Helpers functions to access functions pointers in ImGui::GetIO()
    @(link_name = "igMemAlloc")          mem_alloc             :: proc(sz : uint) -> rawptr ---;
    @(link_name = "igMemFree")           mem_free              :: proc(ptr : rawptr) ---;
    @(link_name = "igGetClipboardText")  im_get_clipboard_text :: proc() -> cstring ---;
    @(link_name = "igSetClipboardText")  im_set_clipboard_text :: proc(text : cstring) ---;

// Internal state access - if you want to share ImGui state between modules (e.g. DLL) or allocate it yourself
    @(link_name = "igGetVersion")        get_version           :: proc() -> cstring ---;
    @(link_name = "igCreateContext")     create_context        :: proc(shared : ^FontAtlas = nil) -> ^Context ---;
    @(link_name = "igDestroyContext")    destroy_context       :: proc(ctx : ^Context) ---;
    @(link_name = "igGetCurrentContext") get_current_context   :: proc() -> ^Context ---;
    @(link_name = "igSetCurrentContext") set_current_context   :: proc(ctx : ^Context) ---;

///// Misc
    @(link_name = "ImFontConfig_DefaultConstructor") font_config_default_constructor  :: proc(config : ^FontConfig) ---;
    @(link_name = "ImGuiIO_AddInputCharacter")       io_add_input_character           :: proc(self : ^IO, c : Wchar) ---;
    @(link_name = "ImGuiIO_AddInputCharactersUTF8")  io_add_input_characters_utf8     :: proc(self : ^IO, utf8_chars : ^u8) ---;
    @(link_name = "ImGuiIO_ClearInputCharacters")    io_clear_input_characters        :: proc(self : ^IO, ) ---;

///// TextFilter
    @(link_name = "igImGuiTextFilter_Create")      text_filter_create        :: proc(default_filter : cstring = "\x00") -> ^TextFilter ---;
    @(link_name = "igImGuiTextFilter_Destroy")     text_filter_destroy       :: proc(filter : ^TextFilter) ---;
    @(link_name = "igImGuiTextFilter_Clear")       text_filter_clear         :: proc(filter : ^TextFilter) ---;
    @(link_name = "igImGuiTextFilter_Draw")        text_filter_draw          :: proc(filter : ^TextFilter, label : cstring, width : f32) -> bool ---;
    @(link_name = "igImGuiTextFilter_PassFilter")  text_filter_pass_filter   :: proc(filter : ^TextFilter, text : cstring, text_end : cstring) -> bool ---;
    @(link_name = "igImGuiTextFilter_IsActive")    text_filter_is_active     :: proc(filter : ^TextFilter) -> bool ---;
    @(link_name = "igImGuiTextFilter_Build")       text_filter_build         :: proc(filter : ^TextFilter) ---;
    @(link_name = "igImGuiTextFilter_GetInputBuf") text_filter_get_input_buf :: proc(filter : ^TextFilter) -> cstring ---;
}

text_buffer_append :: proc(buffer : ^TextBuffer, fmt_ : string, args : ..any) { im_text_buffer_append(buffer, _make_text_string(fmt_, ..args)); }

@(default_calling_convention="c")
foreign cimgui {
///// TextBuffer
    @(link_name = "ImGuiTextBuffer_Create")  text_buffer_create    :: proc() -> ^TextBuffer ---;
    @(link_name = "ImGuiTextBuffer_Destroy") text_buffer_destroy   :: proc(buffer : ^TextBuffer) ---;
    @(link_name = "ImGuiTextBuffer_index")   text_buffer_index     :: proc(buffer : ^TextBuffer, i : i32) -> u8 ---;
    @(link_name = "ImGuiTextBuffer_begin")   text_buffer_begin     :: proc(buffer : ^TextBuffer) -> ^u8 ---;
    @(link_name = "ImGuiTextBuffer_end")     text_buffer_end       :: proc(buffer : ^TextBuffer) -> ^u8 ---;
    @(link_name = "ImGuiTextBuffer_size")    text_buffer_size      :: proc(buffer : ^TextBuffer) -> i32 ---;
    @(link_name = "ImGuiTextBuffer_empty")   text_buffer_empty     :: proc(buffer : ^TextBuffer) -> bool ---;
    @(link_name = "ImGuiTextBuffer_clear")   text_buffer_clear     :: proc(buffer : ^TextBuffer) ---;
    @(link_name = "ImGuiTextBuffer_c_str")   text_buffer_c_str     :: proc(buffer : ^TextBuffer) -> cstring ---;
    @(link_name = "ImGuiTextBuffer_append")  im_text_buffer_append :: proc(buffer : ^TextBuffer, fmt_ : cstring) ---;

///// ImGuiStorage
    @(link_name = "ImGuiStorage_Create")        storage_create           :: proc() -> ^Storage ---;
    @(link_name = "ImGuiStorage_Destroy")       storage_destroy          :: proc(storage : ^Storage) ---;
    @(link_name = "ImGuiStorage_GetInt")        storage_get_int          :: proc(storage : ^Storage, key : ID, default_val : i32 = 0) -> int ---;
    @(link_name = "ImGuiStorage_SetInt")        storage_set_int          :: proc(storage : ^Storage, key : ID, val : i32) ---;
    @(link_name = "ImGuiStorage_GetBool")       storage_get_bool         :: proc(storage : ^Storage, key : ID, default_val : bool = false) -> bool ---;
    @(link_name = "ImGuiStorage_SetBool")       storage_set_bool         :: proc(storage : ^Storage, key : ID, val : bool) ---;
    @(link_name = "ImGuiStorage_GetFloat")      storage_get_float        :: proc(storage : ^Storage, key : ID, default_val : f32 = 0) -> f32 ---;
    @(link_name = "ImGuiStorage_SetFloat")      storage_set_float        :: proc(storage : ^Storage, key : ID, val : f32) ---;
    @(link_name = "ImGuiStorage_GetVoidPtr")    storage_get_void_ptr     :: proc(storage : ^Storage, key : ID) -> rawptr ---;
    @(link_name = "ImGuiStorage_SetVoidPtr")    storage_set_void_ptr     :: proc(storage : ^Storage, key : ID, val : rawptr) ---;
    @(link_name = "ImGuiStorage_GetIntRef")     storage_get_int_ref      :: proc(storage : ^Storage, key : ID, default_val : i32 = 0) -> ^int ---;
    @(link_name = "ImGuiStorage_GetBoolRef")    storage_get_bool_ref     :: proc(storage : ^Storage, key : ID, default_val : bool = false) -> ^bool ---;
    @(link_name = "ImGuiStorage_GetFloatRef")   storage_get_float_ref    :: proc(storage : ^Storage, key : ID, default_val : f32 = 0) -> ^f32 ---;
    @(link_name = "ImGuiStorage_GetVoidPtrRef") storage_get_void_ptr_ref :: proc(storage : ^Storage, key : ID, default_val : rawptr = nil) -> ^rawptr ---;
    @(link_name = "ImGuiStorage_SetAllInt")     storage_set_all_int      :: proc(storage : ^Storage, val : i32) ---;

///// TextEditCallbackData TODO

///// ListClipper
    @(link_name = "ImGuiListClipper_Step")            list_clipper_step              :: proc (clipper : ^ListClipper) -> bool ---;
    @(link_name = "ImGuiListClipper_Begin")           list_clipper_begin             :: proc (clipper : ^ListClipper, count : i32, items_height : f32 = -1) ---;
    @(link_name = "ImGuiListClipper_End")             list_clipper_end               :: proc (clipper : ^ListClipper) ---;
}

///// FontAtlas
font_atlas_add_font_from_file_ttf :: proc(atlas : ^FontAtlas, filename : string, size_pixels : f32, font_cfg : ^FontConfig = nil, glyph_ranges : []Wchar = nil) -> ^Font { return im_font_atlas_add_font_from_file_ttf(atlas, _make_misc_string(filename), size_pixels, font_cfg, glyph_ranges == nil ? nil : &glyph_ranges[0]); }
foreign cimgui {
    @(link_name = "ImFontAtlas_GetTexDataAsRGBA32")                   font_atlas_get_text_data_as_rgba32                    :: proc(atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) ---;
    @(link_name = "ImFontAtlas_GetTexDataAsAlpha8")                   font_atlas_get_text_data_as_alpha8                    :: proc(atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) ---;
    @(link_name = "ImFontAtlas_SetTexID")                             font_atlas_set_text_id                                :: proc(atlas : ^FontAtlas, tex : rawptr) ---;
    @(link_name = "ImFontAtlas_AddFont")                              font_atlas_add_font_                                  :: proc(atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font ---;
    @(link_name = "ImFontAtlas_AddFontDefault")                       font_atlas_add_font_default                           :: proc(atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font ---;
    @(link_name = "ImFontAtlas_AddFontFromFileTTF")                   im_font_atlas_add_font_from_file_ttf                  :: proc(atlas : ^FontAtlas, filename : cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font  ---;
    @(link_name = "ImFontAtlas_AddFontFromMemoryTTF")                 font_atlas_add_font_from_memory_ttf                   :: proc(atlas : ^FontAtlas, ttf_data : rawptr, ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
    @(link_name = "ImFontAtlas_AddFontFromMemoryCompressedTTF")       font_atlas_add_font_from_memory_compressed_ttf        :: proc(atlas : ^FontAtlas, compressed_ttf_data : rawptr, compressed_ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font ---;
    @(link_name = "ImFontAtlas_AddFontFromMemoryCompressedBase85TTF") font_atlas_add_font_from_memory_compressed_base85_ttf :: proc(atlas : ^FontAtlas, compressed_ttf_data_base85 : cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font ---;
    @(link_name = "ImFontAtlas_ClearTexData")                         font_atlas_clear_tex_data                             :: proc(atlas : ^FontAtlas) ---;
    @(link_name = "ImFontAtlas_Clear")                                font_atlas_clear                                      :: proc(atlas : ^FontAtlas) ---;
}
///// DrawList
@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "ImDrawData_ScaleClipRects")           draw_data_scale_clip_rects             :: proc(self : ^DrawData, sc : Vec2) ---;

    @(link_name = "ImDrawList_Clear")                    draw_list_clear                        :: proc(list : ^DrawList) ---;
    @(link_name = "ImDrawList_ClearFreeMemory")          draw_list_clear_free_memory            :: proc(list : ^DrawList) ---;
    @(link_name = "ImDrawList_PushClipRect")             draw_list_push_clip_rect               :: proc(list : ^DrawList, clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) ---;
    @(link_name = "ImDrawList_PushClipRectFullScreen")   draw_list_push_clip_rect_full_screen   :: proc(list : ^DrawList) ---;
    @(link_name = "ImDrawList_PopClipRect")              draw_list_pop_clip_rect                :: proc(list : ^DrawList) ---;
    @(link_name = "ImDrawList_PushTextureID")            draw_list_push_texture_id              :: proc(list : ^DrawList, texture_id : TextureID) ---;
    @(link_name = "ImDrawList_PopTextureID")             draw_list_pop_texture_id               :: proc(list : ^DrawList) ---;

///// Primitives
    @(link_name = "ImDrawList_AddLine")                  draw_list_add_line                     :: proc(list : ^DrawList, a : Vec2, b : Vec2, col : u32, thickness : f32) ---;
    @(link_name = "ImDrawList_AddRect")                  draw_list_add_rect                     :: proc(list : ^DrawList, a : Vec2, b : Vec2, col : u32, rounding : f32, rounding_corners : i32, thickness : f32) ---;
    @(link_name = "ImDrawList_AddRectFilled")            draw_list_add_rect_filled              :: proc(list : ^DrawList, a : Vec2, b : Vec2, col : u32, rounding : f32, rounding_corners : i32) ---;
    @(link_name = "ImDrawList_AddRectFilledMultiColor")  draw_list_add_rect_filled_multi_color  :: proc(list : ^DrawList, a : Vec2, b : Vec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32) ---;
    @(link_name = "ImDrawList_AddQuad")                  draw_list_add_quad                     :: proc(list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, d : Vec2, col : u32, thickness : f32) ---;
    @(link_name = "ImDrawList_AddQuadFilled")            draw_list_add_quad_filled              :: proc(list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, d : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_AddTriangle")              draw_list_add_triangle                 :: proc(list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, col : u32, thickness : f32) ---;
    @(link_name = "ImDrawList_AddTriangleFilled")        draw_list_add_triangle_filled          :: proc(list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_AddCircle")                draw_list_add_circle                   :: proc(list : ^DrawList, centre : Vec2, radius : f32, col : u32, num_segments : i32, thickness : f32) ---;
    @(link_name = "ImDrawList_AddCircleFilled")          draw_list_add_circle_filled            :: proc(list : ^DrawList, centre : Vec2, radius : f32, col : u32, num_segments : i32) ---;


    @(link_name = "ImDrawList_AddText")                  draw_list_add_text                     :: proc(list : ^DrawList, pos : Vec2, col : u32, text_begin : cstring, text_end : cstring) ---;
    @(link_name = "ImDrawList_AddTextExt")               draw_list_add_text_ext                 :: proc(list : ^DrawList, font : ^Font, font_size : f32, pos : Vec2, col : u32, text_begin : cstring, text_end : cstring, wrap_width : f32, cpu_fine_clip_rect : ^Vec4) ---;

    @(link_name = "ImDrawList_AddImage")                 draw_list_add_image                    :: proc(list : ^DrawList, user_texture_id : TextureID, a : Vec2, b : Vec2, uv0 : Vec2, uv1 : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_AddImageQuad")             draw_list_add_image_quad               :: proc(list : ^DrawList, user_texture_id : TextureID, a : Vec2, b : Vec2, c : Vec2, d : Vec2, uv_a : Vec2, uv_b : Vec2, uv_c : Vec2, uv_d : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_AddImageRounded")          draw_list_add_image_rounded            :: proc(list : ^DrawList, user_texture_id : TextureID, a : Vec2, b : Vec2, uv_a : Vec2, uv_b : Vec2, col : u32, rounding : f32, rounding_corners : i32) ---;
    @(link_name = "ImDrawList_AddPolyline")              draw_list_add_poly_line                :: proc(list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, closed : bool, thickness : f32) ---;
    @(link_name = "ImDrawList_AddConvexPolyFilled")      draw_list_add_convex_poly_filled       :: proc(list : ^DrawList, points : ^Vec2, num_points : i32, col : u32) ---;
    @(link_name = "ImDrawList_AddBezierCurve")           draw_list_add_bezier_curve             :: proc(list : ^DrawList, pos0 : Vec2, cp0 : Vec2, cp1 : Vec2, pos1 : Vec2, col : u32, thickness : f32, num_segments : i32) ---;

///// Stateful path API, add points then finish with PathFill() or PathStroke()
    @(link_name = "ImDrawList_PathClear")                draw_list_path_clear                   :: proc(list : ^DrawList) ---;
    @(link_name = "ImDrawList_PathLineTo")               draw_list_path_line_to                 :: proc(list : ^DrawList, pos : Vec2) ---;
    @(link_name = "ImDrawList_PathLineToMergeDuplicate") draw_list_path_line_to_merge_duplicate :: proc(list : ^DrawList, pos : Vec2) ---;
    @(link_name = "ImDrawList_PathFill")                 draw_list_path_fill                    :: proc(list : ^DrawList, col : u32) ---;
    @(link_name = "ImDrawList_PathStroke")               draw_list_path_stroke                  :: proc(list : ^DrawList, col : u32, closed : bool, thickness : f32) ---;
    @(link_name = "ImDrawList_PathArcTo")                draw_list_path_arc_to                  :: proc(list : ^DrawList, centre : Vec2, radius : f32, a_min : f32, a_max : f32, num_segments : i32) ---;
    @(link_name = "ImDrawList_PathArcToFast")            draw_list_path_arc_to_fast             :: proc(list : ^DrawList, centre : Vec2, radius : f32, a_min_of_12 : i32, a_max_of_12 : i32) ---; // Use precomputed angles for a 12 steps circle
    @(link_name = "ImDrawList_PathBezierCurveTo")        draw_list_path_bezier_curve_to         :: proc(list : ^DrawList, p1 : Vec2, p2 : Vec2, p3 : Vec2, num_segments : i32) ---;
    @(link_name = "ImDrawList_PathRect")                 draw_list_path_rect                    :: proc(list : ^DrawList, rect_min : Vec2, rect_max : Vec2, rounding : f32, rounding_corners : i32) ---;

///// Channels
    @(link_name = "ImDrawList_ChannelsSplit")            draw_list_channels_split               :: proc(list : ^DrawList, channels_count : i32) ---;
    @(link_name = "ImDrawList_ChannelsMerge")            draw_list_channels_merge               :: proc(list : ^DrawList) ---;
    @(link_name = "ImDrawList_ChannelsSetCurrent")       draw_list_channels_set_current         :: proc(list : ^DrawList, channel_index : i32) ---;

///// Advanced
    // Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles.
    @(link_name = "ImDrawList_AddCallback")              draw_list_add_callback                 :: proc(list : ^DrawList, callback : draw_callback, callback_data : rawptr) ---;
    // This is useful if you need to forcefully create a new draw call(to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible
    @(link_name = "ImDrawList_AddDrawCmd")               draw_list_add_draw_cmd                 :: proc(list : ^DrawList) ---;
    // Internal helpers
    @(link_name = "ImDrawList_PrimReserve")              draw_list_prim_reserve                 :: proc(list : ^DrawList, idx_count : i32, vtx_count : i32) ---;
    @(link_name = "ImDrawList_PrimRect")                 draw_list_prim_rect                    :: proc(list : ^DrawList, a : Vec2, b : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_PrimRectUV")               draw_list_prim_rectuv                  :: proc(list : ^DrawList, a : Vec2, b : Vec2, uv_a : Vec2, uv_b : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_PrimQuadUV")               draw_list_prim_quaduv                  :: proc(list : ^DrawList,a : Vec2, b : Vec2, c : Vec2, d : Vec2, uv_a : Vec2, uv_b : Vec2, uv_c : Vec2, uv_d : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_PrimWriteVtx")             draw_list_prim_writevtx                :: proc(list : ^DrawList, pos : Vec2, uv : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_PrimWriteIdx")             draw_list_prim_writeidx                :: proc(list : ^DrawList, idx : DrawIdx) ---;
    @(link_name = "ImDrawList_PrimVtx")                  draw_list_prim_vtx                     :: proc(list : ^DrawList, pos : Vec2, uv : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_UpdateClipRect")           draw_list_update_clip_rect             :: proc(list : ^DrawList) ---;
    @(link_name = "ImDrawList_UpdateTextureID")          draw_list_update_texture_id            :: proc(list : ^DrawList) ---;
}