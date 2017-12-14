/*
 *  @Name:     dear_imgui
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hoej@northwolfprod.com
 *  @Creation: 10-05-2017 21:11:30
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 14-12-2017 06:54:11 UTC+1
 *  
 *  @Description:
 *      Wrapper for Dear ImGui 1.52
 */
foreign import "cimgui.lib";

import "core:fmt.odin";
import "core:mem.odin";
import "core:math.odin";
import "core:strings.odin"; 

DrawIdx    :: u16;
Wchar      :: u16;
TextureID  :: rawptr;
GuiId      :: u32;
Cstring    :: ^u8;
Font       :: struct #ordered {}
Storage :: struct #ordered {}
Context :: struct #ordered {}
FontAtlas  :: struct #ordered {}
DrawList   :: struct #ordered {}
TextFilter :: struct #ordered {}
TextBuffer :: struct #ordered {}

Vec2 :: struct #ordered {
    x : f32,
    y : f32,
}

Vec4 :: struct #ordered {
    x : f32,
    y : f32,
    z : f32,
    w : f32,
}

TextEditCallbackData :: struct #ordered {
    event_flag      : InputTextFlags,
    flags           : InputTextFlags,
    user_data       : rawptr,
    read_only       : bool,
    event_char      : Wchar,
    event_key       : Key,
    buf             : Cstring,
    buf_text_len    : i32,
    buf_size        : i32,
    buf_dirty       : bool,
    cursor_pos      : i32,
    selection_start : i32,
    selection_end   : i32,
}

SizeConstraintCallbackData :: struct #ordered {
    user_date    : rawptr,
    pos          : Vec2,
    current_size : Vec2,
    desired_size : Vec2,
}

DrawCmd :: struct #ordered {
    elem_count         : u32,
    clip_rect          : Vec4,
    texture_id         : TextureID,
    user_callback      : draw_callback,
    user_callback_data : rawptr,
}

DrawVert :: struct #ordered {
    pos : Vec2,
    uv  : Vec2,
    col : u32,
}

DrawData :: struct #ordered {
    valid           : bool,
    cmd_lists       : ^^DrawList,
    cmd_lists_count : i32,
    total_vtx_count : i32,
    total_idx_count : i32,
}

FontConfig :: struct #ordered {
    font_data                : rawptr,
    font_data_size           : i32,
    font_data_owned_by_atlas : bool,
    font_no                  : i32,
    size_pixels              : f32,
    over_sample_h            : i32, 
    over_sample_v            : i32,
    pixel_snap_h             : bool,
    glyph_extra_spacing      : Vec2,
    glyph_ranges             : ^Wchar,
    merge_mode               : bool,
    merge_glyph_center_v     : bool,
    name                     : [32]u8,
    dest_font                : ^Font,
}

ListClipper :: struct {
    start_pos_y   : f32,
    items_height  : f32,
    items_count   : i32,
    step_no       : i32,
    display_start : i32,
    display_end   : i32,
}


Style :: struct #ordered {
    alpha                     : f32,
    window_padding            : Vec2,
    window_min_size           : Vec2,
    window_rounding           : f32,
    window_title_align        : Vec2,
    child_window_rounding     : f32,
    frame_padding             : Vec2,
    frame_rounding            : f32,
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
    anti_aliased_lines        : bool,
    anti_aliased_shapes       : bool,
    curve_tessellation_tol    : f32,
    colors                    : [Color.COUNT]Vec4,
}

IO :: struct #ordered {
    display_size                : Vec2,
    delta_time                  : f32,
    ini_saving_rate             : f32,
    ini_filename                : Cstring,
    log_filename                : Cstring,
    mouse_double_click_time     : f32,
    mouse_double_click_max_dist : f32,
    mouse_drag_threshold        : f32,
    key_map                     : [Key.COUNT]i32,
    key_repeat_delay            : f32,
    key_repeat_rate             : f32,
    user_data                   : rawptr, 
    fonts                       : ^FontAtlas,
    font_global_scale           : f32,
    font_allow_user_scaling     : bool,
    font_default                : ^Font,
    display_framebuffer_scale   : Vec2,
    display_visible_min         : Vec2,
    display_visible_max         : Vec2,
    o_s_x_behaviors             : bool,
    render_draw_lists_fn        : proc "c"(data : ^DrawData),
    get_clipboard_text_fn       : proc "c"(user_data : rawptr) -> Cstring,
    set_clipboard_text_fn       : proc "c"(user_data : rawptr, text : Cstring),
    clipboard_user_data         : rawptr,
    mem_alloc_fn                : proc "c"(sz : i64) -> rawptr,
    mem_free_fn                 : proc "c"(ptr : rawptr),
    ime_set_input_screen_pos_fn : proc "c"(x, y : i32),
    ime_window_handle           : rawptr,
    mouse_pos                   : Vec2,
    mouse_down                  : [5]bool,
    mouse_wheel                 : f32,
    mouse_draw_cursor           : bool,
    key_ctrl                    : bool,
    key_shift                   : bool,
    key_alt                     : bool,
    key_super                   : bool,
    keys_down                   : [512]bool,
    input_characters            : [16 + 1]Wchar,
    want_capture_mouse          : bool,
    want_capture_keyboard       : bool,
    want_text_input             : bool,
    framerate                   : f32,
    metrics_allocs              : i32,
    metrics_render_vertices     : i32,
    metrics_render_indices      : i32,
    metrics_active_windows      : i32,
    mouse_delta                 : Vec2,
    mouse_pos_prev              : Vec2,
    mouse_clicked               : [5]bool,
    mouse_clicked_pos           : [5]Vec2,
    mouse_clicked_time          : [5]f32,
    mouse_double_clicked        : [5]bool,
    mouse_released              : [5]bool,
    mouse_down_owned            : [5]bool,
    mouse_down_duration         : [5]f32,
    mouse_down_duration_prev    : [5]f32,
    mouse_drag_max_distance_sqr : [5]f32,
    keys_down_duration          : [512]f32,
    keys_down_duration_prev     : [512]f32,
}

text_edit_callback       :: proc "c"(data : ^TextEditCallbackData) -> i32;
size_constraint_callback :: proc "c"(data : ^SizeConstraintCallbackData);
draw_callback            :: proc "c"(parent_list : ^DrawList, cmd : ^DrawCmd);

WindowFlags :: enum i32 {
    NoTitleBar                = 1 << 0,
    NoResize                  = 1 << 1,
    NoMove                    = 1 << 2,
    NoScrollbar               = 1 << 3,
    NoScrollWithMouse         = 1 << 4,
    NoCollapse                = 1 << 5,
    AlwaysAutoResize          = 1 << 6,
    ShowBorders               = 1 << 7,
    NoSavedSettings           = 1 << 8,
    NoInputs                  = 1 << 9,
    MenuBar                   = 1 << 10,
    HorizontalScrollbar       = 1 << 11,
    NoFocusOnAppearing        = 1 << 12,
    NoBringToFrontOnFocus     = 1 << 13,
    AlwaysVerticalScrollbar   = 1 << 14,
    AlwaysHorizontalScrollbar = 1 << 15,
    AlwaysUseWindowPadding    = 1 << 16
}

InputTextFlags :: enum i32 {
    CharsDecimal              = 1 << 0,
    CharsHexadecimal          = 1 << 1,
    CharsUppercase            = 1 << 2,
    CharsNoBlank              = 1 << 3,
    AutoSelectAll             = 1 << 4,
    EnterReturnsTrue          = 1 << 5,
    CallbackCompletion        = 1 << 6,
    CallbackHistory           = 1 << 7,
    CallbackAlways            = 1 << 8,
    CallbackCharFilter        = 1 << 9,
    AllowTabInput             = 1 << 10,
    CtrlEnterForNewLine       = 1 << 11,
    NoHorizontalScroll        = 1 << 12,
    AlwaysInsertMode          = 1 << 13,
    ReadOnly                  = 1 << 14,
    Password                  = 1 << 15
}

TreeNodeFlags :: enum i32 {
    Selected                  = 1 << 0,
    Framed                    = 1 << 1,
    AllowOverlapMode          = 1 << 2,
    NoTreePushOnOpen          = 1 << 3,
    NoAutoOpenOnLog           = 1 << 4,
    DefaultOpen               = 1 << 5,
    OpenOnDoubleClick         = 1 << 6,
    OpenOnArrow               = 1 << 7,
    Leaf                      = 1 << 8,
    Bullet                    = 1 << 9,
    CollapsingHeader          = Framed | NoAutoOpenOnLog
}

SelectableFlags :: enum {
    DontClosePopups           = 1 << 0,
    SpanAllColumns            = 1 << 1,
    AllowDoubleClick          = 1 << 2
}

Key :: enum i32 {
    Tab,
    LeftArrow,
    RightArrow,
    UpArrow,
    DownArrow,
    PageUp,
    PageDown,
    Home,
    End,
    Delete,
    Backspace,
    Enter,
    Escape,
    A,
    C,
    V,
    X,
    Y,
    Z,
    COUNT
}

Color :: enum i32 {
    Text,
    TextDisabled,
    WindowBg,
    ChildWindowBg,
    PopupBg,
    Border,
    BorderShadow,
    FrameBg,
    FrameBgHovered,
    FrameBgActive,
    TitleBg,
    TitleBgActive,
    TitleBgCollapsed,
    MenuBarBg,
    ScrollbarBg,
    ScrollbarGrab,
    ScrollbarGrabHovered,
    ScrollbarGrabActive,
    ComboBg,
    CheckMark,
    SliderGrab,
    SliderGrabActive,
    Button,
    ButtonHovered,
    ButtonActive,
    Header,
    HeaderHovered,
    HeaderActive,
    Separator,
    SeparatorHovered,
    SeparatorActive,
    ResizeGrip,
    ResizeGripHovered,
    ResizeGripActive,
    CloseButton,
    CloseButtonHovered,
    CloseButtonActive,
    PlotLines,
    PlotLinesHovered,
    PlotHistogram,
    PlotHistogramHovered,
    TextSelectedBg,
    ModalWindowDarkening,
    COUNT
}

StyleVar :: enum i32 {
    Alpha,
    WindowPadding,
    WindowRounding,
    WindowMinSize,
    ChildWindowRounding,
    FramePadding,
    FrameRounding,
    ItemSpacing,
    ItemInnerSpacing,
    IndentSpacing,
    GrabMinSize
}

Align :: enum i32 {
    Left     = 1 << 0,
    Center   = 1 << 1,
    Right    = 1 << 2,
    Top      = 1 << 3,
    VCenter  = 1 << 4,
    Default  = Left | Top
}

ColorEditMode :: enum i32 {
    UserSelect           = -2,
    UserSelectShowButton = -1,
    RGB                  = 0,
    HSV                  = 1,
    HEX                  = 2
}

MouseCursor :: enum i32 {
    Arrow = 0,
    TextInput,
    Move,
    ResizeNS,
    ResizeEW,
    ResizeNESW,
    ResizeNWSE,
    Count_
}

SetCond :: enum i32 {
    Always        = 1 << 0,
    Once          = 1 << 1,
    FirstUseEver  = 1 << 2,
    Appearing     = 1 << 3
}

ColorEditFlags :: enum i32 {
    NoAlpha         = 1 << 1,
    NoPicker        = 1 << 2,
    NoOptions       = 1 << 3,
    NoSmallPreview  = 1 << 4,
    NoInputs        = 1 << 5,
    NoTooltip       = 1 << 6,
    NoLabel         = 1 << 7,
    NoSidePreview   = 1 << 8,
    AlphaBar        = 1 << 9,
    AlphaPreview    = 1 << 10,
    AlphaPreviewHalf= 1 << 11,
    HDR             = 1 << 12,
    RGB             = 1 << 13,
    HSV             = 1 << 14,
    HEX             = 1 << 15,
    Uint8           = 1 << 16,
    Float           = 1 << 17,
    PickerHueBar    = 1 << 18,
    PickerHueWheel  = 1 << 19
};

HoveredFlags :: enum i32
{
    Default                       = 0,        
    AllowWhenBlockedByPopup       = 1 << 0,   
    AllowWhenBlockedByActiveItem  = 1 << 2, 
    AllowWhenOverlapped           = 1 << 3,   
    RectOnly                      = AllowWhenBlockedByPopup | AllowWhenBlockedByActiveItem | AllowWhenOverlapped
}


///////////////////////// Odin UTIL /////////////////////////

_LABEL_BUF_SIZE        :: 4096;
_TEXT_BUF_SIZE         :: 4096;
_DISPLAY_FMT_BUF_SIZE  :: 256;
_MISC_BUF_SIZE         :: 1024;

//TODO(Hoej): Handle when a "\x00" is passed

@(thread_local) _text_buf        : [_TEXT_BUF_SIZE       ]u8;
@(thread_local) _label_buf       : [_LABEL_BUF_SIZE      ]u8;
@(thread_local) _display_fmt_buf : [_DISPLAY_FMT_BUF_SIZE]u8;
@(thread_local) _misc_buf        : [_MISC_BUF_SIZE       ]u8;

_make_text_string :: proc       (fmt_: string, args: ...any) -> Cstring {
    s := fmt.bprintf(_text_buf[..], fmt_, ...args);
    _text_buf[len(s)] = 0;
    return Cstring(&_text_buf[0]);
}

_make_label_string :: proc      (label : string) -> Cstring {
    s := fmt.bprintf(_label_buf[..], "%s", label);
    _label_buf[len(s)] = 0;
    return Cstring(&_label_buf[0]);
}

_make_display_fmt_string :: proc(display_fmt : string) -> Cstring {
    s := fmt.bprintf(_display_fmt_buf[..], "%s", display_fmt);
    _display_fmt_buf[len(s)] = 0;
    return Cstring(&_display_fmt_buf[0]);
}

_make_misc_string :: proc       (misc : string) -> Cstring {
    s := fmt.bprintf(_misc_buf[..], "%s", misc);
    _misc_buf[len(s)] = 0;
    return Cstring(&_misc_buf[0]);
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
    @(link_name = "igShowTestWindow")    show_test_window    :: proc(opened : ^bool = nil) ---;
    @(link_name = "igShowMetricsWindow") show_metrics_window :: proc(opened : ^bool = nil) ---;
    @(link_name = "igShowStyleEditor")   show_style_editor   :: proc(ref : ^Style = nil) ---;
    @(link_name = "igShowUserGuide")     show_user_guide     :: proc() ---;
}


// Window
begin                         :: proc (name : string, open : ^bool = nil, flags : WindowFlags = 0) -> bool                                    { return im_begin(_make_label_string(name), open, flags); }
begin_child                   :: proc (str_id : string, size : Vec2 = Vec2{0,0}, border : bool = true, extra_flags : WindowFlags = 0) -> bool { return im_begin_child(_make_label_string(str_id), size, border, extra_flags); }
get_content_region_max        :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_content_region_max(&res); return res; }
get_content_region_avail      :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_content_region_avail(&res); return res; }
get_window_content_region_min :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_window_content_region_min(&res); return res; }
get_window_content_region_max :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_window_content_region_max(&res); return res; }
get_window_pos                :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_window_pos(&res); return res; }
get_window_size               :: proc() -> Vec2                                                                                                  { res : Vec2 = ---; im_get_content_region_max(&res); return res; }
    
@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igBegin")                       im_begin                         :: proc(name : Cstring, p_open : ^bool, flags : WindowFlags) -> bool ---;
    @(link_name = "igEnd")                         end                              :: proc() ---;
    @(link_name = "igBeginChild")                  im_begin_child                   :: proc(str_id : Cstring, size : Vec2, border : bool, extra_flags : WindowFlags) -> bool ---;
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

set_window_collapsed  :: proc (name : string, collapsed : bool, cond : SetCond)    { im_set_window_collapsed(_make_label_string(name), collapsed, cond); }
set_window_size       :: proc (name : string, size : Vec2, cond : SetCond)         { im_set_window_size(_make_label_string(name), size, cond); }
set_window_focus      :: proc (name : string)                                      { im_set_window_focus(_make_label_string(name)); }
set_window_pos        :: proc (name : string, pos : Vec2, cond : SetCond)          { im_set_window_pos(_make_label_string(name), pos, cond); }
get_cursor_pos        :: proc () -> Vec2                                           { res : Vec2 = ---; im_get_cursor_pos(&res); return res; }
get_cursor_start_pos  :: proc () -> Vec2                                           { res : Vec2 = ---; im_get_cursor_start_pos(&res); return res; }
get_cursor_screen_pos :: proc () -> Vec2                                           { res : Vec2 = ---; im_get_cursor_screen_pos(&res); return res;}



@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igSetNextWindowPos")              set_next_window_pos                :: proc (pos : Vec2, cond : SetCond = 0, pivot : Vec2 = Vec2{0, 0}) ---;
    @(link_name = "igSetNextWindowSize")             set_next_window_size               :: proc (size : Vec2, cond : SetCond = 0) ---;
    @(link_name = "igSetNextWindowSizeConstraints")  set_next_window_size_constraints   :: proc (size_min : Vec2, size_max : Vec2, custom_callback : size_constraint_callback =  nil, custom_callback_data : rawptr = nil) ---;
    @(link_name = "igSetNextWindowContentSize")      set_next_window_content_size       :: proc (size : Vec2) ---;
    @(link_name = "igSetNextWindowContentWidth")     set_next_window_content_width      :: proc (width : f32) ---;
    @(link_name = "igSetNextWindowCollapsed")        set_next_window_collapsed          :: proc (collapsed : bool, cond : SetCond = 0) ---;
    @(link_name = "igSetNextWindowFocus")            set_next_window_focus              :: proc () ---;
    @(link_name = "igSetWindowPos")                  set_window_pos_                    :: proc (pos : Vec2, cond : SetCond = 0) ---;
    @(link_name = "igSetWindowSize")                 set_window_size_                    :: proc (size : Vec2, cond : SetCond = 0) ---;
    @(link_name = "igSetWindowCollapsed")            set_window_collapsed_               :: proc (collapsed : bool, cond : SetCond = 0) ---;
    @(link_name = "igSetWindowFocus")                set_window_focus_                   :: proc () ---;
    @(link_name = "igSetWindowPosByName")            im_set_window_pos                  :: proc (name : Cstring, pos : Vec2, cond : SetCond = 0) ---;
    @(link_name = "igSetWindowSize2")                im_set_window_size                 :: proc (name : Cstring, size : Vec2, cond : SetCond = 0) ---;
    @(link_name = "igSetWindowCollapsed2")           im_set_window_collapsed            :: proc (name : Cstring, collapsed : bool, cond : SetCond = 0) ---;
    @(link_name = "igSetWindowFocus2")               im_set_window_focus                :: proc (name : Cstring) ---;

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
    @(link_name = "igPushFont")                      push_font                          :: proc (font : ^Font) ---;
    @(link_name = "igPopFont")                       pop_font                           :: proc () ---;
    @(link_name = "igPushStyleColorU32")             push_style_colorU32                :: proc (idx : Color, col : u32) ---;
    @(link_name = "igPushStyleColor")                push_style_color_                  :: proc (idx : Color, col : Vec4) ---;
}

push_style_color :: proc[push_style_color_, push_style_colorU32];

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igPopStyleColor")                 pop_style_color                    :: proc (count : i32 = 1) ---;
    @(link_name = "igPushStyleVar")                  push_style_var_                    :: proc (idx : StyleVar, val : f32) ---;
    @(link_name = "igPushStyleVarVec")               push_style_var_vec                 :: proc (idx : StyleVar, val : Vec2) ---;
}

push_style_var :: proc[push_style_var_, push_style_var_vec];

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

get_color_u32 :: proc[get_color_u32_, get_color_u32_vec, get_color_u32_u32];

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
    @(link_name = "igGetItemsLineHeightWithSpacing") get_items_line_height_with_spacing :: proc () -> f32 ---;
}

//Columns
columns :: proc (count : i32, id : string = "", border : bool = true) { im_columns(count, _make_label_string(id), border); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igColumns")         im_columns        :: proc (count : i32, id : Cstring, border : bool)  ---;
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
    @(link_name = "igPushIDStr")       push_id_cstr       :: proc (str_id : Cstring)  ---;
    @(link_name = "igPushIDStrRange")  push_id_cstr_range :: proc (str_begin : Cstring, str_end : Cstring)  ---;
    @(link_name = "igPushIDPtr")       push_id_ptr        :: proc (ptr_id : rawptr)  ---;
    @(link_name = "igPushIDInt")       push_id_int        :: proc (int_id : i32)  ---;
    @(link_name = "igPopID")           pop_id             :: proc ()  ---;
    @(link_name = "igGetIDStr")        get_id_str         :: proc (str_id : Cstring) -> GuiId  ---;
    @(link_name = "igGetIDStrRange")   get_id_str_range   :: proc (str_begin : Cstring, str_end : Cstring) -> GuiId  ---;
    @(link_name = "igGetIDPtr")        get_id_ptr         :: proc (ptr_id : rawptr) -> GuiId  ---;
}

push_id_str :: proc(str_id : string) { push_id_cstr(_make_label_string(str_id)); }

push_id :: proc[push_id_str, push_id_cstr_range, push_id_ptr, push_id_int];
get_id :: proc[get_id_str, get_id_str_range, get_id_ptr];

/////// Widgtes: Text
text_unformatted :: proc (fmt_: string)                                 { im_text_unformatted(_make_text_string(fmt_)); }
text             :: proc (fmt_: string, args: ...any)                   { im_text_unformatted(_make_text_string(fmt_, ...args)); }
text_colored     :: proc (col : Vec4, fmt_: string, args: ...any)       { im_text_colored(col, _make_text_string(fmt_, ...args)); }
text_disabled    :: proc (fmt_: string, args: ...any)                   { im_text_disabled(_make_text_string(fmt_, ...args)); }
text_wrapped     :: proc (fmt_: string, args: ...any)                   { im_text_wrapped(_make_text_string(fmt_, ...args)); }
label_text       :: proc (label : string, fmt_ : string, args : ...any) { im_label_text(_make_label_string(label), _make_text_string(fmt_, ...args)); }
bullet_text      :: proc (fmt_: string, args: ...any)                   { im_bullet_text(_make_text_string(fmt_, ...args)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igText")            im_text             :: proc(fmt: Cstring) ---; 
    @(link_name = "igTextColored")     im_text_colored     :: proc(col : Vec4, fmt_ : Cstring) ---;
    @(link_name = "igTextDisabled")    im_text_disabled    :: proc(fmt_ : Cstring) ---;
    @(link_name = "igTextWrapped")     im_text_wrapped     :: proc(fmt: Cstring) ---;
    @(link_name = "igLabelText")       im_label_text       :: proc(label : Cstring, fmt_ : Cstring) ---;
    @(link_name = "igBulletText")      im_bullet_text      :: proc(fmt_ : Cstring) ---;
    @(link_name = "igTextUnformatted") im_text_unformatted :: proc(text : Cstring, text_end : Cstring = nil) ---;
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
combo            :: proc (label : string, current_item : ^i32, items : []string, height_in_items : i32 = -1) -> bool {
    data := make([]^u8, len(items)); defer free(data);
    for item, idx in items {
        data[idx] = strings.new_c_string(item);
    }
    return im_combo(_make_label_string(label), current_item, &data[0], i32(len(items)), height_in_items); 
}
plot_histogram   :: proc (label : string, values : []f32, overlay_text : string = "\x00", scale_min : f32 = math.F32_MAX, scale_max : f32 = math.F32_MAX, graph_size : Vec2 = Vec2{0,0}, stride : i32 = size_of(f32)) { im_plot_histogram(_make_label_string(label), &values[0], i32(len(values)), 0, _make_misc_string(overlay_text), scale_min, scale_max, graph_size, stride); }
progress_bar     :: proc (fraction : f32, size_arg : ^Vec2 = Vec2{0, 0}, overlay : string = "\x00")                                                                                                                   { im_progress_bar(fraction, size_arg, _make_misc_string(overlay)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igButton")          im_button             :: proc (label : Cstring, size : Vec2) -> bool ---;
    @(link_name = "igSmallButton")     im_small_button       :: proc(label : Cstring) -> bool ---;
    @(link_name = "igInvisibleButton") im_invisible_button   :: proc(str_id : Cstring, size : Vec2) -> bool ---;
    @(link_name = "igImage")           image                 :: proc(user_texture_id : TextureID, size : Vec2, uv0 : Vec2 = Vec2{0, 0}, uv1 : Vec2 = Vec2{1, 1}, tint_col : Vec4 = Vec4{1, 1, 1, 1}, border_col : Vec4 = Vec4{0, 0, 0, 0}) ---;
    @(link_name = "igImageButton")     image_button          :: proc(user_texture_id : TextureID, size : Vec2, uv0 : Vec2 = Vec2{0, 0}, uv1 : Vec2 = Vec2{1, 1}, frame_padding : i32 = -1, bg_col : Vec4 = Vec4{0, 0, 0, 0}, tint_col : Vec4 = Vec4{1, 1, 1, 1}) -> bool ---;
    @(link_name = "igCheckbox")        im_checkbox           :: proc(label : Cstring, v : ^bool) -> bool ---;
    @(link_name = "igCheckboxFlags")   im_checkbox_flags     :: proc(label : Cstring, flags : ^u32, flags_value : u32) -> bool ---;
    @(link_name = "igRadioButtonBool") im_radio_buttons_bool :: proc(label : Cstring, active : bool) -> bool ---;
    @(link_name = "igRadioButton")     im_radio_button       :: proc(label : Cstring, v : ^i32, v_button : i32) -> bool ---;
    @(link_name = "igCombo")           im_combo              :: proc(label : Cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool ---;
    @(link_name = "igCombo2")          combo2                :: proc(label : Cstring, current_item : ^i32, items_separated_by_zeros : Cstring, height_in_items : i32) -> bool ---;
    @(link_name = "igCombo3")          combo3                :: proc(label : Cstring, current_item : ^i32, items_getter : proc "cdecl"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, height_in_items : i32) -> bool ---;
    @(link_name = "igPlotLines")       plot_lines            :: proc(label : Cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) ---;
    @(link_name = "igPlotLines2")      plot_lines2           :: proc(label : Cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) ---;
    @(link_name = "igPlotHistogram")   im_plot_histogram     :: proc(label : Cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) ---;
    @(link_name = "igPlotHistogram2")  plot_histogram2       :: proc(label : Cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) ---;
    @(link_name = "igProgressBar")     im_progress_bar       :: proc(fraction : f32, size_arg : ^Vec2, overlay : Cstring) ---;
}

drag_float :: proc[drag_float1, drag_float2, drag_float3, drag_float4];

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

drag_int :: proc[drag_int1, drag_int2, drag_int3, drag_int4];
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
    @(link_name = "igDragFloat")       im_drag_float       :: proc(label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) ---;
    @(link_name = "igDragFloat2")      im_drag_float2      :: proc(label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool ---;
    @(link_name = "igDragFloat3")      im_drag_float3      :: proc(label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool ---;
    @(link_name = "igDragFloat4")      im_drag_float4      :: proc(label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool ---;
    @(link_name = "igDragFloatRange2") im_drag_float_range :: proc(label : Cstring, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : Cstring, power : f32) -> bool ---;
    @(link_name = "igDragInt")         im_drag_int         :: proc(label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring) ---;
    @(link_name = "igDragInt2")        im_drag_int2        :: proc(label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring) ---;
    @(link_name = "igDragInt3")        im_drag_int3        :: proc(label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring) ---;
    @(link_name = "igDragInt4")        im_drag_int4        :: proc(label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring) ---;
    @(link_name = "igDragIntRange2")   im_drag_int_range   :: proc(label : Cstring, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : Cstring) -> bool ---;
}

// Widgets: Input with Keyboard
input_text           :: proc(label : string, buf : []u8, flags : InputTextFlags = 0, callback : text_edit_callback = nil, user_data : rawptr = nil) -> bool              { return im_input_text(_make_label_string(label), Cstring(&buf[0]), uint(len(buf)), flags, callback, user_data); }
input_text_multiline :: proc(label : string, buf : []u8, size : Vec2, flags : InputTextFlags = 0, callback : text_edit_callback = nil, user_data : rawptr = nil) -> bool { return im_input_text_multiline(_make_label_string(label), Cstring(&buf[0]), uint(len(buf)), size, flags, callback, user_data); }

input_float          :: proc[input_float1, input_float2, input_float3, input_float4];
input_float1         :: proc(label : string, v : ^f32, step : f32 = 0, step_fast : f32 = 0, decimal_precision : i32 = -1, extra_flags : InputTextFlags = 0) -> bool          { return im_input_float(_make_label_string(label), v, step, step_fast, decimal_precision, extra_flags); }
input_float2         :: proc(label : string, v : ^[2]f32, decimal_precision : i32 = -1, extra_flags : InputTextFlags = 0) -> bool                                            { return im_input_float2(_make_label_string(label), &v[0], decimal_precision, extra_flags); }
input_float3         :: proc(label : string, v : ^[3]f32, decimal_precision : i32 = -1, extra_flags : InputTextFlags = 0) -> bool                                            { return im_input_float3(_make_label_string(label), &v[0], decimal_precision, extra_flags); }
input_float4         :: proc(label : string, v : ^[4]f32, decimal_precision : i32 = -1, extra_flags : InputTextFlags = 0) -> bool                                            { return im_input_float4(_make_label_string(label), &v[0], decimal_precision, extra_flags); }

input_int            :: proc[input_int1, input_int2, input_int3, input_int4];
input_int1           :: proc(label : string, v : ^i32, step : i32 = 0, step_fast : i32 = 0, extra_flags : InputTextFlags = 0) -> bool                                        { return im_input_int(_make_label_string(label), v, step, step_fast, extra_flags); }
input_int2           :: proc(label : string, v : ^[2]i32, extra_flags : InputTextFlags = 0) -> bool                                                                          { return im_input_int2(_make_label_string(label), &v[0], extra_flags); }
input_int3           :: proc(label : string, v : ^[3]i32, extra_flags : InputTextFlags = 0) -> bool                                                                          { return im_input_int3(_make_label_string(label), &v[0], extra_flags); }
input_int4           :: proc(label : string, v : ^[4]i32, extra_flags : InputTextFlags = 0) -> bool                                                                          { return im_input_int4(_make_label_string(label), &v[0], extra_flags); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igInputText")          im_input_text           :: proc(label : Cstring, buf : Cstring, buf_size : uint /*size_t*/, flags : InputTextFlags, callback : text_edit_callback, user_data : rawptr) -> bool ---;
    @(link_name = "igInputTextMultiline") im_input_text_multiline :: proc(label : Cstring, buf : Cstring, buf_size : uint /*size_t*/, size : Vec2, flags : InputTextFlags, callback : text_edit_callback, user_data : rawptr) -> bool ---;
    @(link_name = "igInputFloat")         im_input_float          :: proc(label : Cstring, v : ^f32, step : f32, step_fast : f32, decimal_precision : i32, extra_flags : InputTextFlags) -> bool ---;
    @(link_name = "igInputFloat2")        im_input_float2         :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : InputTextFlags) -> bool ---;
    @(link_name = "igInputFloat3")        im_input_float3         :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : InputTextFlags) -> bool ---;
    @(link_name = "igInputFloat4")        im_input_float4         :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : InputTextFlags) -> bool ---;
    @(link_name = "igInputInt")           im_input_int            :: proc(label : Cstring, v : ^i32, step : i32, step_fast : i32, extra_flags : InputTextFlags) -> bool ---;
    @(link_name = "igInputInt2")          im_input_int2           :: proc(label : Cstring, v : ^i32, extra_flags : InputTextFlags) -> bool ---;
    @(link_name = "igInputInt3")          im_input_int3           :: proc(label : Cstring, v : ^i32, extra_flags : InputTextFlags) -> bool ---;
    @(link_name = "igInputInt4")          im_input_int4           :: proc(label : Cstring, v : ^i32, extra_flags : InputTextFlags) -> bool ---;
}

// Widgets: Sliders (tip: ctrl+click on a slider to input text)
slider_float   :: proc[slider_float1, slider_float2, slider_float3, slider_float4];
slider_float1  :: proc(label : string, v : ^f32, v_min : f32, v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool               { return im_slider_float(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format), power); }
slider_float2  :: proc(label : string, v : ^[2]f32, v_min : f32, v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool            { return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power); }
slider_float3  :: proc(label : string, v : ^[3]f32, v_min : f32, v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool            { return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power); }
slider_float4  :: proc(label : string, v : ^[4]f32, v_min : f32, v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool            { return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power); }
slider_angle   :: proc(label : string, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool                                              { return im_slider_angle(_make_label_string(label),v_rad, v_degrees_min, v_degrees_max); }

slider_int     :: proc[slider_int1, slider_int2, slider_int3, slider_int4];
slider_int1    :: proc(label : string, v : ^i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                                  { return im_slider_int(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format)); }
slider_int2    :: proc(label : string, v : ^[2]i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                               { return im_slider_int2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format)); }
slider_int3    :: proc(label : string, v : ^[3]i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                               { return im_slider_int3(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format)); }
slider_int4    :: proc(label : string, v : ^[4]i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                               { return im_slider_int4(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format)); }
vslider_float  :: proc(label : string, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : string = "%.3f", power : f32 = 1) -> bool { return im_vslider_float(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format), power); }
vslider_int    :: proc(label : string, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : string = "%d") -> bool                     { return im_vslider_int(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igSliderFloat")  im_slider_float  :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool ---;
    @(link_name = "igSliderFloat2") im_slider_float2 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool ---;
    @(link_name = "igSliderFloat3") im_slider_float3 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool ---;
    @(link_name = "igSliderFloat4") im_slider_float4 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool ---;
    @(link_name = "igSliderAngle")  im_slider_angle  :: proc(label : Cstring, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool                    ---;
    @(link_name = "igSliderInt")    im_slider_int    :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool ---;
    @(link_name = "igSliderInt2")   im_slider_int2   :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool ---;
    @(link_name = "igSliderInt3")   im_slider_int3   :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool ---;
    @(link_name = "igSliderInt4")   im_slider_int4   :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool ---;
    @(link_name = "igVSliderFloat") im_vslider_float :: proc(label : Cstring, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : Cstring, power : f32) -> bool ---;
    @(link_name = "igVSliderInt")   im_vslider_int   :: proc(label : Cstring, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool               ---;
}

color_edit    :: proc[color_edit3, color_edit4];
color_edit3   :: proc(label : string, col : [3]f32, flags : ColorEditFlags = 0) -> bool                           { return im_color_edit3(_make_label_string(label), &col[0], flags) }
color_edit4   :: proc(label : string, col : [4]f32, flags : ColorEditFlags = 0) -> bool                           { return im_color_edit4(_make_label_string(label), &col[0], flags) }

color_picker  :: proc[color_picker3, color_picker4];
color_picker3 :: proc(label : string, col : [3]f32, flags : ColorEditFlags = 0) -> bool                           { return im_color_picker3(_make_label_string(label), &col[0], flags) }
color_picker4 :: proc(label : string, col : [4]f32, flags : ColorEditFlags = 0) -> bool                           { return im_color_picker4(_make_label_string(label), &col[0], flags) }
color_button  :: proc(desc_id : string, col : Vec4, flags : ColorEditFlags = 0, size : Vec2 = Vec2{0, 0}) -> bool { return im_color_button(_make_label_string(desc_id), col, flags, size) }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igColorEdit3")          im_color_edit3         :: proc(label : Cstring, col : ^f32, flags : ColorEditFlags) -> bool ---;
    @(link_name = "igColorEdit4")          im_color_edit4         :: proc(label : Cstring, col : ^f32, flags : ColorEditFlags) -> bool ---;
    @(link_name = "igColorPicker3")        im_color_picker3       :: proc(label : Cstring, col : ^f32, flags : ColorEditFlags) -> bool ---;
    @(link_name = "igColorPicker4")        im_color_picker4       :: proc(label : Cstring, col : ^f32, flags : ColorEditFlags, ref_col : ^f32 = nil) -> bool ---;
    @(link_name = "igColorButton")         im_color_button        :: proc(desc_id : Cstring, col : Vec4, flags : ColorEditFlags, size : Vec2) -> bool ---;
    @(link_name = "igSetColorEditOptions") set_color_edit_options :: proc(flags : ColorEditFlags)  ---;
}

// Widgets: Trees
tree_node               :: proc[tree_node_str, tree_node_str_fmt, tree_node_ptr];
tree_node_str           :: proc(label : string) -> bool                                                              { return im_tree_node(_make_label_string(label)); }
tree_node_str_fmt       :: proc(str_id : string, fmt_ : string, args : ...any) -> bool                               { return im_tree_node_str(_make_label_string(str_id), _make_text_string(fmt_, ...args)); }
tree_node_ptr           :: proc(ptr_id : rawptr, fmt_ : string, args : ...any) -> bool                               { return im_tree_node_ptr(ptr_id, _make_text_string(fmt_, ...args)); }

tree_node_ext           :: proc[tree_node_ext_str, tree_node_ext_str_fmt, tree_node_ext_ptr];
tree_node_ext_str       :: proc(label : string, flags : TreeNodeFlags = 0) -> bool                                { return im_tree_node_ex(_make_label_string(label), flags); }
tree_node_ext_str_fmt   :: proc(str_id : string, flags : TreeNodeFlags = 0, fmt_ : string, args : ...any) -> bool { return im_tree_node_ex_str(_make_label_string(str_id), flags, _make_text_string(fmt_, ...args)); }
tree_node_ext_ptr       :: proc(ptr_id : rawptr, flags : TreeNodeFlags = 0, fmt_ : string, args : ...any) -> bool { return im_tree_node_ex_ptr(ptr_id, flags, _make_text_string(fmt_, ...args)); }

tree_push               :: proc[tree_push_str, tree_push_ptr];
tree_push_str           :: proc(str_id : string)                                                                     { im_tree_push_str(_make_label_string(str_id)); }

collapsing_header       :: proc[collapsing_header_, collapsing_header_ext];
collapsing_header_      :: proc(label : string, flags : TreeNodeFlags = 0) -> bool                                { return im_collapsing_header(_make_label_string(label), flags); }
collapsing_header_ext   :: proc(label : string, p_open : ^bool, flags : TreeNodeFlags = 0) -> bool                { return im_collapsing_header_ex(_make_label_string(label), p_open, flags); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igTreeNode")                  im_tree_node                   :: proc(label : Cstring) -> bool ---;
    @(link_name = "igTreeNodeStr")               im_tree_node_str               :: proc(str_id : Cstring, fmt_ : Cstring) -> bool ---;
    @(link_name = "igTreeNodePtr")               im_tree_node_ptr               :: proc(ptr_id : rawptr, fmt_ : Cstring) -> bool ---;
    @(link_name = "igTreeNodeEx")                im_tree_node_ex                :: proc(label : Cstring, flags : TreeNodeFlags) -> bool ---;
    @(link_name = "igTreeNodeExStr")             im_tree_node_ex_str            :: proc(str_id : Cstring, flags : TreeNodeFlags, fmt_ : Cstring) -> bool ---;
    @(link_name = "igTreeNodeExPtr")             im_tree_node_ex_ptr            :: proc(ptr_id : rawptr, flags : TreeNodeFlags, fmt_ : Cstring) -> bool ---;
    @(link_name = "igTreePushStr")               im_tree_push_str               :: proc(str_id : Cstring) ---;
    @(link_name = "igTreePushPtr")               tree_push_ptr                  :: proc(ptr_id : rawptr) ---;

    @(link_name = "igTreePop")                   tree_pop                       :: proc() ---;
    @(link_name = "igTreeAdvanceToLabelPos")     tree_advance_to_label_pos      :: proc() ---;
    @(link_name = "igGetTreeNodeToLabelSpacing") get_tree_node_to_label_spacing :: proc() -> f32 ---;
    @(link_name = "igSetNextTreeNodeOpen")       set_next_tree_node_open        :: proc(opened : bool, cond : SetCond) ---;
    @(link_name = "igCollapsingHeader")          im_collapsing_header           :: proc(label : Cstring, flags : TreeNodeFlags) -> bool ---;
    @(link_name = "igCollapsingHeaderEx")        im_collapsing_header_ex        :: proc(label : Cstring, p_open : ^bool, flags : TreeNodeFlags) -> bool ---;
}

// Widgets: Selectable / Lists
selectable      :: proc[selectable_val, selectable_ptr];
selectable_val  :: proc(label : string, selected : bool = false, flags : SelectableFlags = 0, size : Vec2 = Vec2{0,0}) -> bool { return im_selectable(_make_label_string(label), selected, flags, size); }
selectable_ptr  :: proc(label : string, p_selected : ^bool, flags : SelectableFlags = 0, size : Vec2 = Vec2{0,0}) -> bool      { return im_selectable_ex(_make_label_string(label), p_selected, flags, size); }

list_box_header        :: proc[list_box_header_simple, list_box_header_count];
list_box_header_simple :: proc(label : string, size : Vec2 = Vec2{0, 0}) -> bool                      { return im_list_box_header(_make_label_string(label), size); }
list_box_header_count  :: proc(label : string, items_count : i32, height_in_items : i32 = -1) -> bool { return im_list_box_header2(_make_label_string(label), items_count, height_in_items); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igSelectable")     im_selectable      :: proc(label : Cstring, selected : bool, flags : SelectableFlags, size : Vec2) -> bool ---;
    @(link_name = "igSelectableEx")   im_selectable_ex   :: proc(label : Cstring, p_selected : ^bool, flags : SelectableFlags, size : Vec2) -> bool ---;
    @(link_name = "igListBox")        list_box1          :: proc(label : Cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool ---;
    @(link_name = "igListBox2")       list_box2          :: proc(label : Cstring, current_item : ^i32, items_getter : proc "cdecl"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, height_in_items : i32) -> bool ---;
}

list_box :: proc[list_box1, list_box2];

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igListBoxHeader")  im_list_box_header :: proc(label : Cstring, size : Vec2) -> bool ---;
    @(link_name = "igListBoxHeader2") im_list_box_header2 :: proc(label : Cstring, items_count : i32, height_in_items : i32) -> bool ---;
    @(link_name = "igListBoxFooter")  list_box_footer    :: proc() ---;
}

// Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare your own within the ImGui namespace!)
value       :: proc[value_bool, value_int, value_uint, value_float, value_color];
value_bool  :: proc(prefix : string, b : bool)                          { im_value_bool(_make_label_string(prefix), b); }
value_int   :: proc(prefix : string, v : i32)                           { im_value_int(_make_label_string(prefix), v); }
value_uint  :: proc(prefix : string, v : u32)                           { im_value_uint(_make_label_string(prefix), v); }
value_float :: proc(prefix : string, v : f32, format : string = "\x00") { im_value_float(_make_label_string(prefix), v, _make_misc_string(format)); }
value_color :: proc(prefix : string, v : Vec4)                          { im_value_color(_make_label_string(prefix), v); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igValueBool")  im_value_bool  :: proc(prefix : Cstring, b : bool) ---;
    @(link_name = "igValueInt")   im_value_int   :: proc(prefix : Cstring, v : i32) ---;
    @(link_name = "igValueUInt")  im_value_uint  :: proc(prefix : Cstring, v : u32) ---;
    @(link_name = "igValueFloat") im_value_float :: proc(prefix : Cstring, v : f32, float_format : Cstring) ---;
    @(link_name = "igValueColor") im_value_color :: proc(prefix : Cstring, v : Vec4) ---;
}

// Tooltip
set_tooltip :: proc(fmt_ : string, args : ...any) { im_set_tooltip(_make_text_string(fmt_, ...args)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igSetTooltip")   im_set_tooltip :: proc(fmt : Cstring) ---; 
    @(link_name = "igBeginTooltip") begin_tooltip  :: proc() ---;
    @(link_name = "igEndTooltip")   end_tooltip    :: proc() ---;
}

begin_menu :: proc(label : string, enabled : bool = true) -> bool                                                      { return im_begin_menu(_make_label_string(label), enabled); }

menu_item   :: proc[menu_item1, menu_item2];
menu_item1  :: proc(label : string, shortcut : string = "\x00", selected : bool = false, enabled : bool = true) -> bool { return im_menu_item(_make_label_string(label), _make_misc_string(shortcut), selected, enabled); }
menu_item2  :: proc(label : string, shortcut : string, selected : ^bool , enabled : bool = true) -> bool                { return im_menu_item_ptr(_make_label_string(label), _make_misc_string(shortcut), selected, enabled); }

// Widgets: Menus
@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igBeginMainMenuBar") begin_main_menu_bar :: proc() -> bool ---;
    @(link_name = "igEndMainMenuBar")   end_main_menu_bar   :: proc() ---;
    @(link_name = "igBeginMenuBar")     begin_menu_bar      :: proc() -> bool ---;
    @(link_name = "igEndMenuBar")       end_menu_bar        :: proc() ---;
    @(link_name = "igBeginMenu")        im_begin_menu       :: proc(label : Cstring, enabled : bool) -> bool ---;
    @(link_name = "igEndMenu")          end_menu            :: proc() ---;
    @(link_name = "igMenuItem")         im_menu_item        :: proc(label : Cstring, shortcut : Cstring, selected : bool, enabled : bool) -> bool ---;   
    @(link_name = "igMenuItemPtr")      im_menu_item_ptr    :: proc(label : Cstring, shortcut : Cstring, p_selected : ^bool, enabled : bool) -> bool ---;
}

// Popup
open_popup                 :: proc(str_id : string)                                                         { im_open_popup(_make_label_string(str_id)); }
open_popup_on_item_click   :: proc(str_id : string, mouse_button : int = 1) -> bool                         { return im_open_popup_on_item_click(_make_label_string(str_id), mouse_button) }
begin_popup                :: proc(str_id : string) -> bool                                                 { return im_begin_popup(_make_label_string(str_id)); }
begin_popup_modal          :: proc(name : string, open : ^bool, extra_flags : WindowFlags = 0) -> bool   { return im_begin_popup_modal(_make_label_string(name), open, extra_flags); }
begin_popup_context_item   :: proc(str_id : string, mouse_button : i32 = 1) -> bool                         { return im_begin_popup_context_item(_make_label_string(str_id), mouse_button); }
begin_popup_context_window :: proc(also_over_items : bool, str_id : string, mouse_button : i32 = 1) -> bool { return im_begin_popup_context_window(also_over_items, _make_label_string(str_id), mouse_button); }
begin_popup_context_void   :: proc(str_id : string, mouse_button : i32 = 1) -> bool                         { return im_begin_popup_context_void(_make_label_string(str_id), mouse_button); }
is_popup_open              :: proc(str_id : string) -> bool                                                 { return im_is_popup_open(_make_label_string(str_id)); }

@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "igOpenPopup")               im_open_popup                 :: proc(str_id : Cstring) ---;
    @(link_name = "igOpenPopupOnItemClick")    im_open_popup_on_item_click   :: proc(str_id : Cstring, mouse_button : int) -> bool ---;
    @(link_name = "igBeginPopup")              im_begin_popup                :: proc(str_id : Cstring) -> bool ---;
    @(link_name = "igBeginPopupModal")         im_begin_popup_modal          :: proc(name : Cstring, p_open : ^bool, extra_flags : WindowFlags) -> bool ---;
    @(link_name = "igBeginPopupContextItem")   im_begin_popup_context_item   :: proc(str_id : Cstring, mouse_button : i32) -> bool ---;
    @(link_name = "igBeginPopupContextWindow") im_begin_popup_context_window :: proc(also_over_items : bool, str_id : Cstring, mouse_button : i32) -> bool ---;
    @(link_name = "igBeginPopupContextVoid")   im_begin_popup_context_void   :: proc(str_id : Cstring, mouse_button : i32) -> bool ---;
    @(link_name = "igEndPopup")                end_popup                     :: proc() ---;
    @(link_name = "igIsPopupOpen")             im_is_popup_open              :: proc(str_id : Cstring) -> bool ---;
    @(link_name = "igCloseCurrentPopup")       close_current_popup           :: proc() ---;
}

log_text :: proc(fmt_ : string, args : ...any) { im_log_text(_make_text_string(fmt_, ...args)); }

@(default_calling_convention="c")
foreign cimgui {
    // Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened.
    @(link_name = "igLogToTTY")       log_to_tty       :: proc(max_depth : i32) ---;
    @(link_name = "igLogToFile")      log_to_file      :: proc(max_depth : i32, filename : Cstring) ---;
    @(link_name = "igLogToClipboard") log_to_clipboard :: proc(max_depth : i32) ---;
    @(link_name = "igLogFinish")      log_finish       :: proc() ---;
    @(link_name = "igLogButtons")     log_buttons      :: proc() ---;
    @(link_name = "igLogText")        im_log_text      :: proc(fmt_ : Cstring) ---;
}

@(default_calling_convention="c")
foreign cimgui {
    // Clipping
    @(link_name = "igPushClipRect")                     push_clip_rect                         :: proc(clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) ---;
    @(link_name = "igPopClipRect")                      pop_clip_rect                          :: proc() ---;

    // Styles
    @(link_name = "igStyleColorsClassic")               style_colors_classic                   :: proc(dst : ^Style) ---;

    // Utilities
    @(link_name = "igIsItemHovered")                    is_item_hovered                        :: proc (flags : HoveredFlags = 0) -> bool ---;
    @(link_name = "igIsItemActive")                     is_item_active                         :: proc () -> bool ---;
    @(link_name = "igIsItemClicked")                    is_item_clicked                        :: proc (mouse_button : i32 = 0) -> bool ---;
    @(link_name = "igIsItemVisible")                    is_item_visible                        :: proc () -> bool ---;
    @(link_name = "igIsAnyItemHovered")                 is_any_item_hovered                    :: proc () -> bool ---;
    @(link_name = "igIsAnyItemActive")                  is_any_item_active                     :: proc () -> bool ---;
    @(link_name = "igGetItemRectMin")                   get_item_rect_min                      :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetItemRectMax")                   get_item_rect_max                      :: proc (pOut : ^Vec2) ---;
    @(link_name = "igGetItemRectSize")                  get_item_rect_size                     :: proc (pOut : ^Vec2) ---;
    @(link_name = "igSetItemAllowOverlap")              set_item_allow_overlap                 :: proc () ---;
    @(link_name = "igIsWindowFocused")                  is_window_focused                      :: proc () -> bool ---;
    @(link_name = "igIsWindowHovered")                  is_window_hovered                      :: proc (flags : HoveredFlags = 0) -> bool ---;
    @(link_name = "igIsRootWindowFocused")              is_root_window_focused                 :: proc () -> bool ---;
    @(link_name = "igIsRootWindowOrAnyChildFocused")    is_root_window_or_any_child_focused    :: proc () -> bool ---;
    @(link_name = "igIsRootWindowOrAnyChildHovered")    is_root_window_or_any_child_hovered    :: proc (flags : HoveredFlags = 0) -> bool ---;
    @(link_name = "igIsRectVisible")                    is_rect_visible                        :: proc (item_size : Vec2) -> bool ---;
    @(link_name = "igIsPosHoveringAnyWindow")           is_pos_hovering_any_window             :: proc (pos : Vec2) -> bool ---;
    @(link_name = "igGetTime")                          get_time                               :: proc () -> f32 ---;
    @(link_name = "igGetFrameCount")                    get_frame_count                        :: proc () -> i32 ---;
    @(link_name = "igGetStyleColName")                  get_style_col_name                     :: proc (idx : Color) -> Cstring ---;
    @(link_name = "igCalcItemRectClosestPoint")         calc_item_rect_closest_point           :: proc (pOut : ^Vec2, pos : Vec2 , on_edge : bool, outward : f32 = 0) ---;
    @(link_name = "igCalcTextSize")                     calc_text_size                         :: proc (pOut : ^Vec2, text : Cstring, text_end : Cstring, hide_text_after_double_hash : bool, wrap_width : f32 = -1) ---;
    @(link_name = "igCalcListClipping")                 calc_list_clipping                     :: proc (items_count : i32, items_height : f32, out_items_display_start : ^i32, out_items_display_end : ^i32) ---;

    @(link_name = "igBeginChildFrame")                  begin_child_frame                      :: proc(id : GuiId, size : Vec2, extra_flags : WindowFlags = 0) -> bool ---;
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
    @(link_name = "igGetMouseCursor")                   get_mouse_cursor                       :: proc () -> MouseCursor ---;
    @(link_name = "igSetMouseCursor")                   set_mouse_cursor                       :: proc (type_ : MouseCursor) ---;
    @(link_name = "igCaptureKeyboardFromApp")           capture_keyboard_from_app              :: proc (capture : bool) ---;
    @(link_name = "igCaptureMouseFromApp")              capture_mouse_from_app                 :: proc (capture : bool) ---;
}

get_clipboard_text :: proc() -> string { c_str := im_get_clipboard_text(); o_str := strings.to_odin_string(cast(^u8)c_str); return o_str; }
set_clipboard_text :: proc(text : string) { im_set_clipboard_text(_make_text_string(text)); }

@(default_calling_convention="c")
foreign cimgui {
// Helpers functions to access functions pointers in ImGui::GetIO()
    @(link_name = "igMemAlloc")          mem_alloc             :: proc(sz : uint) -> rawptr ---;
    @(link_name = "igMemFree")           mem_free              :: proc(ptr : rawptr) ---;
    @(link_name = "igGetClipboardText")  im_get_clipboard_text :: proc() -> Cstring ---;
    @(link_name = "igSetClipboardText")  im_set_clipboard_text :: proc(text : Cstring) ---;

// Internal state access - if you want to share ImGui state between modules (e.g. DLL) or allocate it yourself
    @(link_name = "igGetVersion")        get_version           :: proc() -> Cstring ---;
    @(link_name = "igCreateContext")     create_context        :: proc(malloc_fn : proc(size : uint) -> rawptr, free_fn : proc(data : rawptr)) -> ^Context ---;
    @(link_name = "igDestroyContext")    destroy_context       :: proc(ctx : ^Context) ---;
    @(link_name = "igGetCurrentContext") get_current_context   :: proc() -> ^Context ---;
    @(link_name = "igSetCurrentContext") set_current_context   :: proc(ctx : ^Context) ---;

///// Misc    
    @(link_name = "ImFontConfig_DefaultConstructor") font_config_default_constructor  :: proc(config : ^FontConfig) ---;
    @(link_name = "ImGuiIO_AddInputCharacter")       gui_io_add_input_character       :: proc(c : u16) ---;
    @(link_name = "ImGuiIO_AddInputCharactersUTF8")  gui_io_add_input_characters_utf8 :: proc(utf8_chars : ^u8) ---;
    @(link_name = "ImGuiIO_ClearInputCharacters")    gui_io_clear_input_characters    :: proc() ---;

///// TextFilter
    @(link_name = "igImGuiTextFilter_Create")      text_filter_create        :: proc(default_filter : Cstring = "\x00") -> ^TextFilter ---;
    @(link_name = "igImGuiTextFilter_Destroy")     text_filter_destroy       :: proc(filter : ^TextFilter) ---;
    @(link_name = "igImGuiTextFilter_Clear")       text_filter_clear         :: proc(filter : ^TextFilter) ---;
    @(link_name = "igImGuiTextFilter_Draw")        text_filter_draw          :: proc(filter : ^TextFilter, label : Cstring, width : f32) -> bool ---;
    @(link_name = "igImGuiTextFilter_PassFilter")  text_filter_pass_filter   :: proc(filter : ^TextFilter, text : Cstring, text_end : Cstring) -> bool ---;
    @(link_name = "igImGuiTextFilter_IsActive")    text_filter_is_active     :: proc(filter : ^TextFilter) -> bool ---;
    @(link_name = "igImGuiTextFilter_Build")       text_filter_build         :: proc(filter : ^TextFilter) ---;
    @(link_name = "igImGuiTextFilter_GetInputBuf") text_filter_get_input_buf :: proc(filter : ^TextFilter) -> Cstring ---;
}

text_buffer_append :: proc(buffer : ^TextBuffer, fmt_ : string, args : ...any) { im_text_buffer_append(buffer, _make_text_string(fmt_, ...args)); }

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
    @(link_name = "ImGuiTextBuffer_c_str")   text_buffer_c_str     :: proc(buffer : ^TextBuffer) -> Cstring ---;
    @(link_name = "ImGuiTextBuffer_append")  im_text_buffer_append :: proc(buffer : ^TextBuffer, fmt_ : Cstring) ---;

///// ImGuiStorage
    @(link_name = "ImGuiStorage_Create")        storage_create           :: proc() -> ^Storage ---;
    @(link_name = "ImGuiStorage_Destroy")       storage_destroy          :: proc(storage : ^Storage) ---;
    @(link_name = "ImGuiStorage_GetInt")        storage_get_int          :: proc(storage : ^Storage, key : GuiId, default_val : i32 = 0) -> int ---;
    @(link_name = "ImGuiStorage_SetInt")        storage_set_int          :: proc(storage : ^Storage, key : GuiId, val : i32) ---;
    @(link_name = "ImGuiStorage_GetBool")       storage_get_bool         :: proc(storage : ^Storage, key : GuiId, default_val : bool = false) -> bool ---;
    @(link_name = "ImGuiStorage_SetBool")       storage_set_bool         :: proc(storage : ^Storage, key : GuiId, val : bool) ---;
    @(link_name = "ImGuiStorage_GetFloat")      storage_get_float        :: proc(storage : ^Storage, key : GuiId, default_val : f32 = 0) -> f32 ---;
    @(link_name = "ImGuiStorage_SetFloat")      storage_set_float        :: proc(storage : ^Storage, key : GuiId, val : f32) ---;
    @(link_name = "ImGuiStorage_GetVoidPtr")    storage_get_void_ptr     :: proc(storage : ^Storage, key : GuiId) -> rawptr ---;
    @(link_name = "ImGuiStorage_SetVoidPtr")    storage_set_void_ptr     :: proc(storage : ^Storage, key : GuiId, val : rawptr) ---;
    @(link_name = "ImGuiStorage_GetIntRef")     storage_get_int_ref      :: proc(storage : ^Storage, key : GuiId, default_val : i32 = 0) -> ^int ---;
    @(link_name = "ImGuiStorage_GetBoolRef")    storage_get_bool_ref     :: proc(storage : ^Storage, key : GuiId, default_val : bool = false) -> ^bool ---;
    @(link_name = "ImGuiStorage_GetFloatRef")   storage_get_float_ref    :: proc(storage : ^Storage, key : GuiId, default_val : f32 = 0) -> ^f32 ---;
    @(link_name = "ImGuiStorage_GetVoidPtrRef") storage_get_void_ptr_ref :: proc(storage : ^Storage, key : GuiId, default_val : rawptr = nil) -> ^rawptr ---;
    @(link_name = "ImGuiStorage_SetAllInt")     storage_set_all_int      :: proc(storage : ^Storage, val : i32) ---;

///// TextEditCallbackData TODO

///// ListClipper
    @(link_name = "ImGuiListClipper_Step")            list_clipper_step              :: proc (clipper : ^ListClipper) -> bool ---;
    @(link_name = "ImGuiListClipper_Begin")           list_clipper_begin             :: proc (clipper : ^ListClipper, count : i32, items_height : f32 = -1) ---;
    @(link_name = "ImGuiListClipper_End")             list_clipper_end               :: proc (clipper : ^ListClipper) ---;
}

///// FontAtlas  
font_atlas_add_font_from_file_ttf :: proc(atlas : ^FontAtlas, filename : string, size_pixels : f32, font_cfg : ^FontConfig = nil, glyph_ranges : ^Wchar = nil) -> ^Font { return im_font_atlas_add_font_from_file_ttf(atlas, _make_misc_string(filename), size_pixels, font_cfg, glyph_ranges); }
foreign cimgui {
    @(link_name = "ImFontAtlas_GetTexDataAsRGBA32")                   font_atlas_get_text_data_as_rgba32                    :: proc(atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) ---;
    @(link_name = "ImFontAtlas_GetTexDataAsAlpha8")                   font_atlas_get_text_data_as_alpha8                    :: proc(atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) ---;
    @(link_name = "ImFontAtlas_SetTexID")                             font_atlas_set_text_id                                :: proc(atlas : ^FontAtlas, tex : rawptr) ---;
    @(link_name = "ImFontAtlas_AddFont")                              font_atlas_add_font_                                  :: proc(atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font ---;
    @(link_name = "ImFontAtlas_AddFontDefault")                       font_atlas_add_font_default                           :: proc(atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font ---;
    @(link_name = "ImFontAtlas_AddFontFromFileTTF")                   im_font_atlas_add_font_from_file_ttf                  :: proc(atlas : ^FontAtlas, filename : Cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font  ---;
    @(link_name = "ImFontAtlas_AddFontFromMemoryTTF")                 font_atlas_add_font_from_memory_ttf                   :: proc(atlas : ^FontAtlas, ttf_data : rawptr, ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
    @(link_name = "ImFontAtlas_AddFontFromMemoryCompressedTTF")       font_atlas_add_font_from_memory_compressed_ttf        :: proc(atlas : ^FontAtlas, compressed_ttf_data : rawptr, compressed_ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font ---;
    @(link_name = "ImFontAtlas_AddFontFromMemoryCompressedBase85TTF") font_atlas_add_font_from_memory_compressed_base85_ttf :: proc(atlas : ^FontAtlas, compressed_ttf_data_base85 : Cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font ---;
    @(link_name = "ImFontAtlas_ClearTexData")                         font_atlas_clear_tex_data                             :: proc(atlas : ^FontAtlas) ---;
    @(link_name = "ImFontAtlas_Clear")                                font_atlas_clear                                      :: proc(atlas : ^FontAtlas) ---;
}
///// DrawList
@(default_calling_convention="c")
foreign cimgui {
    @(link_name = "ImDrawList_GetVertexBufferSize")      draw_list_get_vertex_buffer_size       :: proc(list : ^DrawList) -> i32 ---;
    @(link_name = "ImDrawList_GetVertexPtr")             draw_list_get_vertex_ptr               :: proc(list : ^DrawList, n : i32) -> ^DrawVert ---;
    @(link_name = "ImDrawList_GetIndexBufferSize")       draw_list_get_index_buffer_size        :: proc(list : ^DrawList) -> i32 ---;
    @(link_name = "ImDrawList_GetIndexPtr")              draw_list_get_index_ptr                :: proc(list : ^DrawList, n : i32) -> ^DrawIdx ---;
    @(link_name = "ImDrawList_GetCmdSize")               draw_list_get_cmd_size                 :: proc(list : ^DrawList) -> i32 ---;
    @(link_name = "ImDrawList_GetCmdPtr")                draw_list_get_cmd_ptr                  :: proc(list : ^DrawList, n : i32) -> ^DrawCmd ---;

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


    @(link_name = "ImDrawList_AddText")                  draw_list_add_text                     :: proc(list : ^DrawList, pos : Vec2, col : u32, text_begin : Cstring, text_end : Cstring) ---;
    @(link_name = "ImDrawList_AddTextExt")               draw_list_add_text_ext                 :: proc(list : ^DrawList, font : ^Font, font_size : f32, pos : Vec2, col : u32, text_begin : Cstring, text_end : Cstring, wrap_width : f32, cpu_fine_clip_rect : ^Vec4) ---;

    @(link_name = "ImDrawList_AddImage")                 draw_list_add_image                    :: proc(list : ^DrawList, user_texture_id : TextureID, a : Vec2, b : Vec2, uv0 : Vec2, uv1 : Vec2, col : u32) ---;
    @(link_name = "ImDrawList_AddPolyline")              draw_list_add_poly_line                :: proc(list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, closed : bool, thickness : f32, anti_aliased : bool) ---;
    @(link_name = "ImDrawList_AddConvexPolyFilled")      draw_list_add_convex_poly_filled       :: proc(list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, anti_aliased : bool) ---;
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