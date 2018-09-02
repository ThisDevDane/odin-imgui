/*
 *  @Name:     imgui_enums
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    fyoucon@gmail.com
 *  @Creation: 02-09-2018 16:01:49 UTC+1
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 02-09-2018 18:13:55 UTC+1
 *  
 *  @Description:
 *  
 */

package imgui;

Window_Flags :: enum i32 {
    None                      = 0,
    NoTitleBar                = 1 << 0,
    NoResize                  = 1 << 1,
    NoMove                    = 1 << 2,
    NoScrollbar               = 1 << 3,
    NoScrollWithMouse         = 1 << 4,
    NoCollapse                = 1 << 5,
    AlwaysAutoResize          = 1 << 6,
    NoSavedSettings           = 1 << 8,
    NoInputs                  = 1 << 9,
    MenuBar                   = 1 << 10,
    HorizontalScrollbar       = 1 << 11,
    NoFocusOnAppearing        = 1 << 12,
    NoBringToFrontOnFocus     = 1 << 13,
    AlwaysVerticalScrollbar   = 1 << 14,
    AlwaysHorizontalScrollbar = 1 << 15,
    AlwaysUseWindowPadding    = 1 << 16,
    NoNavInputs               = 1 << 18,
    NoNavFocus                = 1 << 19,
    NoNav                     = NoNavInputs | NoNavFocus,
    NavFlattened              = 1 << 23,
    ChildWindow               = 1 << 24,
    Tooltip                   = 1 << 25,
    Popup                     = 1 << 26,
    Modal                     = 1 << 27,
    ChildMenu                 = 1 << 28
}

Input_Text_Flags :: enum i32 {
    None                = 0,
    CharsDecimal        = 1 << 0,
    CharsHexadecimal    = 1 << 1,
    CharsUppercase      = 1 << 2,
    CharsNoBlank        = 1 << 3,
    AutoSelectAll       = 1 << 4,
    EnterReturnsTrue    = 1 << 5,
    CallbackCompletion  = 1 << 6,
    CallbackHistory     = 1 << 7,
    CallbackAlways      = 1 << 8,
    CallbackCharFilter  = 1 << 9,
    AllowTabInput       = 1 << 10,
    CtrlEnterForNewLine = 1 << 11,
    NoHorizontalScroll  = 1 << 12,
    AlwaysInsertMode    = 1 << 13,
    ReadOnly            = 1 << 14,
    Password            = 1 << 15,
    NoUndoRedo          = 1 << 16,
    CharsScientific     = 1 << 17,
    CallbackResize      = 1 << 18,
    Multiline           = 1 << 20
}

Tree_Node_Flags :: enum i32 {
    None                 = 0,
    Selected             = 1 << 0,
    Framed               = 1 << 1,
    AllowItemOverlap     = 1 << 2,
    NoTreePushOnOpen     = 1 << 3,
    NoAutoOpenOnLog      = 1 << 4,
    DefaultOpen          = 1 << 5,
    OpenOnDoubleClick    = 1 << 6,
    OpenOnArrow          = 1 << 7,
    Leaf                 = 1 << 8,
    Bullet               = 1 << 9,
    FramePadding         = 1 << 10,
    NavLeftJumpsBackHere = 1 << 13,
    CollapsingHeader     = Framed | NoTreePushOnOpen | NoAutoOpenOnLog
}

Selectable_Flags :: enum i32 {
    None             = 0,
    DontClosePopups  = 1 << 0,
    SpanAllColumns   = 1 << 1,
    AllowDoubleClick = 1 << 2,
    Disabled         = 1 << 3
}

Combo_Flags :: enum i32 {
    None           = 0,
    PopupAlignLeft = 1 << 0,
    HeightSmall    = 1 << 1,
    HeightRegular  = 1 << 2,
    HeightLarge    = 1 << 3,
    HeightLargest  = 1 << 4,
    NoArrowButton  = 1 << 5,
    NoPreview      = 1 << 6,
    HeightMask     = HeightSmall | HeightRegular | HeightLarge | HeightLargest
}

Focused_Flags :: enum i32 {
    None                = 0,
    ChildWindows        = 1 << 0,
    RootWindow          = 1 << 1,
    AnyWindow           = 1 << 2,
    RootAndChildWindows = RootWindow | ChildWindows
}

Hovered_Flags :: enum i32 {
    None                         = 0,
    ChildWindows                 = 1 << 0,
    RootWindow                   = 1 << 1,
    AnyWindow                    = 1 << 2,
    AllowWhenBlockedByPopup      = 1 << 3,
    AllowWhenBlockedByActiveItem = 1 << 5,
    AllowWhenOverlapped          = 1 << 6,
    AllowWhenDisabled            = 1 << 7,
    RectOnly                     = AllowWhenBlockedByPopup | AllowWhenBlockedByActiveItem | AllowWhenOverlapped,
    RootAndChildWindows          = RootWindow | ChildWindows
}

Drag_Drop_Flags :: enum i32 {
    None                     = 0,
    SourceNoPreviewTooltip   = 1 << 0,
    SourceNoDisableHover     = 1 << 1,
    SourceNoHoldToOpenOthers = 1 << 2,
    SourceAllowNullID        = 1 << 3,
    SourceExtern             = 1 << 4,
    SourceAutoExpirePayload  = 1 << 5,
    AcceptBeforeDelivery     = 1 << 10,
    AcceptNoDrawDefaultRect  = 1 << 11,
    AcceptNoPreviewTooltip   = 1 << 12,
    AcceptPeekOnly           = AcceptBeforeDelivery | AcceptNoDrawDefaultRect
}

Data_Type :: enum i32 {
    S32,
    U32,
    S64,
    U64,
    Float,
    Double,
    COUNT
}

Dir :: enum i32 {
    None  = -1,
    Left  = 0,
    Right = 1,
    Up    = 2,
    Down  = 3,
    COUNT,
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
    Insert,
    Delete,
    Backspace,
    Space,
    Enter,
    Escape,
    A,
    C,
    V,
    X,
    Y,
    Z,
    COUNT,
}

Nav_Input :: enum i32 {
    Activate,
    Cancel,
    Input,
    Menu,
    DpadLeft,
    DpadRight,
    DpadUp,
    DpadDown,
    LStickLeft,
    LStickRight,
    LStickUp,
    LStickDown,
    FocusPrev,
    FocusNext,
    TweakSlow,
    TweakFast,
    KeyMenu,
    KeyLeft,
    KeyRight,
    KeyUp,
    KeyDown,
    COUNT,
    InternalStart = KeyMenu
};

Config_Flags :: enum i32 {
    NavEnableKeyboard    = 1 << 0,
    NavEnableGamepad     = 1 << 1,
    NavEnableSetMousePos = 1 << 2,
    NavNoCaptureKeyboard = 1 << 3,
    NoMouse              = 1 << 4,
    NoMouseCursorChange  = 1 << 5,
    IsSRGB               = 1 << 20,
    IsTouchScreen        = 1 << 21
}

Backend_Flags :: enum i32 {
    HasGamepad      = 1 << 0,
    HasMouseCursors = 1 << 1,
    HasSetMousePos  = 1 << 2
}

Style_Color :: enum i32 {
    Text,
    TextDisabled,
    WindowBg,
    ChildBg,
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
    PlotLines,
    PlotLinesHovered,
    PlotHistogram,
    PlotHistogramHovered,
    TextSelectedBg,
    DragDropTarget,
    NavHighlight,
    NavWindowingHighlight,
    NavWindowingDimBg,
    ModalWindowDimBg,
    COUNT,
}

Style_Var :: enum i32 {
    Alpha,
    WindowPadding,
    WindowRounding,
    WindowBorderSize,
    WindowMinSize,
    WindowTitleAlign,
    ChildRounding,
    ChildBorderSize,
    PopupRounding,
    PopupBorderSize,
    FramePadding,
    FrameRounding,
    FrameBorderSize,
    ItemSpacing,
    ItemInnerSpacing,
    IndentSpacing,
    ScrollbarSize,
    ScrollbarRounding,
    GrabMinSize,
    GrabRounding,
    ButtonTextAlign,
    COUNT
}

Color_Edit_Flags :: enum i32 {
    None             = 0,
    NoAlpha          = 1 << 1,
    NoPicker         = 1 << 2,
    NoOptions        = 1 << 3,
    NoSmallPreview   = 1 << 4,
    NoInputs         = 1 << 5,
    NoTooltip        = 1 << 6,
    NoLabel          = 1 << 7,
    NoSidePreview    = 1 << 8,
    NoDragDrop       = 1 << 9,
    AlphaBar         = 1 << 16,
    AlphaPreview     = 1 << 17,
    AlphaPreviewHalf = 1 << 18,
    HDR              = 1 << 19,
    RGB              = 1 << 20,
    HSV              = 1 << 21,
    HEX              = 1 << 22,
    Uint8            = 1 << 23,
    Float            = 1 << 24,
    PickerHueBar     = 1 << 25,
    PickerHueWheel   = 1 << 26,
    InputsMask       = RGB | HSV | HEX,
    DataTypeMask     = Uint8 | Float,
    PickerMask       = PickerHueWheel | PickerHueBar,
    OptionsDefault   = Uint8 | RGB | PickerHueBar
}

Mouse_Cursor :: enum i32 {
    None = -1,
    Arrow = 0,
    TextInput,
    ResizeAll,
    ResizeNS,
    ResizeEW,
    ResizeNESW,
    ResizeNWSE,
    Hand,
    COUNT,
}

Set_Cond :: enum i32 {
    Always       = 1 << 0,
    Once         = 1 << 1,
    FirstUseEver = 1 << 2,
    Appearing    = 1 << 3
}

Draw_Corner_Flags :: enum i32 {
    TopLeft  = 1 << 0,
    TopRight = 1 << 1,
    BotLeft  = 1 << 2,
    BotRight = 1 << 3,
    Top      = TopLeft  | TopRight,
    Bot      = BotLeft  | BotRight,
    Left     = TopLeft  | BotLeft,
    Right    = TopRight | BotRight,
    All      = 0xF
}

Draw_List_Flags :: enum i32 {
    AntiAliasedLines = 1 << 0,
    AntiAliasedFill  = 1 << 1
}

Font_Atlas_Flags :: enum i32 {
    None               = 0,
    NoPowerOfTwoHeight = 1 << 0,
    NoMouseCursors     = 1 << 1
}