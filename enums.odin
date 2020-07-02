package imgui;

Draw_Corner_Flags :: enum i32 {
	None     = 0,
	TopLeft  = 1 << 0,
	TopRight = 1 << 1,
	BotLeft  = 1 << 2,
	BotRight = 1 << 3,
	Top      = TopLeft | TopRight,
	Bot      = BotLeft | BotRight,
	Left     = TopLeft | BotLeft,
	Right    = TopRight | BotRight,
	All      = 0xF,
}

Draw_List_Flags :: enum i32 {
	None             = 0,
	AntiAliasedLines = 1 << 0,
	AntiAliasedFill  = 1 << 1,
	AllowVtxOffset   = 1 << 2,
}

Font_Atlas_Flags :: enum i32 {
	None               = 0,
	NoPowerOfTwoHeight = 1 << 0,
	NoMouseCursors     = 1 << 1,
}

Axis :: enum i32 {
	None = -1,
	X    = 0,
	Y    = 1,
}

Backend_Flags :: enum i32 {
	None                 = 0,
	HasGamepad           = 1 << 0,
	HasMouseCursors      = 1 << 1,
	HasSetMousePos       = 1 << 2,
	RendererHasVtxOffset = 1 << 3,
}

Button_Flags :: enum i32 {
	None                          = 0,
	Repeat                        = 1 << 0,
	PressedOnClick                = 1 << 1,
	PressedOnClickRelease         = 1 << 2,
	PressedOnClickReleaseAnywhere = 1 << 3,
	PressedOnRelease              = 1 << 4,
	PressedOnDoubleClick          = 1 << 5,
	PressedOnDragDropHold         = 1 << 6,
	FlattenChildren               = 1 << 7,
	AllowItemOverlap              = 1 << 8,
	DontClosePopups               = 1 << 9,
	Disabled                      = 1 << 10,
	AlignTextBaseLine             = 1 << 11,
	NoKeyModifiers                = 1 << 12,
	NoHoldingActiveId             = 1 << 13,
	NoNavFocus                    = 1 << 14,
	NoHoveredOnFocus              = 1 << 15,
	MouseButtonLeft               = 1 << 16,
	MouseButtonRight              = 1 << 17,
	MouseButtonMiddle             = 1 << 18,
	MouseButtonMask               = MouseButtonLeft | MouseButtonRight | MouseButtonMiddle,
	MouseButtonShift              = 16,
	MouseButtonDefault            = MouseButtonLeft,
	PressedOnMask                 = PressedOnClick | PressedOnClickRelease | PressedOnClickReleaseAnywhere | PressedOnRelease | PressedOnDoubleClick | PressedOnDragDropHold,
	PressedOnDefault              = PressedOnClickRelease,
}

Col :: enum i32 {
	Text                  = 0,
	TextDisabled          = 1,
	WindowBg              = 2,
	ChildBg               = 3,
	PopupBg               = 4,
	Border                = 5,
	BorderShadow          = 6,
	FrameBg               = 7,
	FrameBgHovered        = 8,
	FrameBgActive         = 9,
	TitleBg               = 10,
	TitleBgActive         = 11,
	TitleBgCollapsed      = 12,
	MenuBarBg             = 13,
	ScrollbarBg           = 14,
	ScrollbarGrab         = 15,
	ScrollbarGrabHovered  = 16,
	ScrollbarGrabActive   = 17,
	CheckMark             = 18,
	SliderGrab            = 19,
	SliderGrabActive      = 20,
	Button                = 21,
	ButtonHovered         = 22,
	ButtonActive          = 23,
	Header                = 24,
	HeaderHovered         = 25,
	HeaderActive          = 26,
	Separator             = 27,
	SeparatorHovered      = 28,
	SeparatorActive       = 29,
	ResizeGrip            = 30,
	ResizeGripHovered     = 31,
	ResizeGripActive      = 32,
	Tab                   = 33,
	TabHovered            = 34,
	TabActive             = 35,
	TabUnfocused          = 36,
	TabUnfocusedActive    = 37,
	PlotLines             = 38,
	PlotLinesHovered      = 39,
	PlotHistogram         = 40,
	PlotHistogramHovered  = 41,
	TextSelectedBg        = 42,
	DragDropTarget        = 43,
	NavHighlight          = 44,
	NavWindowingHighlight = 45,
	NavWindowingDimBg     = 46,
	ModalWindowDimBg      = 47,
	Count                 = 48,
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
	NoBorder         = 1 << 10,
	AlphaBar         = 1 << 16,
	AlphaPreview     = 1 << 17,
	AlphaPreviewHalf = 1 << 18,
	Hdr              = 1 << 19,
	DisplayRgb       = 1 << 20,
	DisplayHsv       = 1 << 21,
	DisplayHex       = 1 << 22,
	Uint8            = 1 << 23,
	Float            = 1 << 24,
	PickerHueBar     = 1 << 25,
	PickerHueWheel   = 1 << 26,
	InputRgb         = 1 << 27,
	InputHsv         = 1 << 28,
	OptionsDefault   = Uint8 | DisplayRgb | InputRgb | PickerHueBar,
	DisplayMask      = DisplayRgb | DisplayHsv | DisplayHex,
	DataTypeMask     = Uint8 | Float,
	PickerMask       = PickerHueWheel | PickerHueBar,
	InputMask        = InputRgb | InputHsv,
}

Columns_Flags :: enum i32 {
	None                   = 0,
	NoBorder               = 1 << 0,
	NoResize               = 1 << 1,
	NoPreserveWidths       = 1 << 2,
	NoForceWithinWindow    = 1 << 3,
	GrowParentContentsSize = 1 << 4,
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
	HeightMask     = HeightSmall | HeightRegular | HeightLarge | HeightLargest,
}

Cond :: enum i32 {
	None         = 0,
	Always       = 1 << 0,
	Once         = 1 << 1,
	FirstUseEver = 1 << 2,
	Appearing    = 1 << 3,
}

Config_Flags :: enum i32 {
	None                 = 0,
	NavEnableKeyboard    = 1 << 0,
	NavEnableGamepad     = 1 << 1,
	NavEnableSetMousePos = 1 << 2,
	NavNoCaptureKeyboard = 1 << 3,
	NoMouse              = 1 << 4,
	NoMouseCursorChange  = 1 << 5,
	IsSrgb               = 1 << 20,
	IsTouchScreen        = 1 << 21,
}

Data_Type :: enum i32 {
	S8     = 0,
	U8     = 1,
	S16    = 2,
	U16    = 3,
	S32    = 4,
	U32    = 5,
	S64    = 6,
	U64    = 7,
	Float  = 8,
	Double = 9,
	Count  = 10,
}

Dir :: enum i32 {
	None  = -1,
	Left  = 0,
	Right = 1,
	Up    = 2,
	Down  = 3,
	Count = 4,
}

Drag_Drop_Flags :: enum i32 {
	None                     = 0,
	SourceNoPreviewTooltip   = 1 << 0,
	SourceNoDisableHover     = 1 << 1,
	SourceNoHoldToOpenOthers = 1 << 2,
	SourceAllowNullId        = 1 << 3,
	SourceExtern             = 1 << 4,
	SourceAutoExpirePayload  = 1 << 5,
	AcceptBeforeDelivery     = 1 << 10,
	AcceptNoDrawDefaultRect  = 1 << 11,
	AcceptNoPreviewTooltip   = 1 << 12,
	AcceptPeekOnly           = AcceptBeforeDelivery | AcceptNoDrawDefaultRect,
}

Drag_Flags :: enum i32 {
	None     = 0,
	Vertical = 1 << 0,
}

Focused_Flags :: enum i32 {
	None                = 0,
	ChildWindows        = 1 << 0,
	RootWindow          = 1 << 1,
	AnyWindow           = 1 << 2,
	RootAndChildWindows = RootWindow | ChildWindows,
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
	RootAndChildWindows          = RootWindow | ChildWindows,
}

Input_Read_Mode :: enum i32 {
	Down       = 0,
	Pressed    = 1,
	Released   = 2,
	Repeat     = 3,
	RepeatSlow = 4,
	RepeatFast = 5,
}

Input_Source :: enum i32 {
	None        = 0,
	Mouse       = 1,
	Nav         = 2,
	NavKeyboard = 3,
	NavGamepad  = 4,
	Count       = 5,
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
	Multiline           = 1 << 20,
	NoMarkEdited        = 1 << 21,
}

Item_Flags :: enum i32 {
	None                     = 0,
	NoTabStop                = 1 << 0,
	ButtonRepeat             = 1 << 1,
	Disabled                 = 1 << 2,
	NoNav                    = 1 << 3,
	NoNavDefaultFocus        = 1 << 4,
	SelectableDontClosePopup = 1 << 5,
	MixedValue               = 1 << 6,
	Default                  = 0,
}

Item_Status_Flags :: enum i32 {
	None             = 0,
	HoveredRect      = 1 << 0,
	HasDisplayRect   = 1 << 1,
	Edited           = 1 << 2,
	ToggledSelection = 1 << 3,
	ToggledOpen      = 1 << 4,
	HasDeactivated   = 1 << 5,
	Deactivated      = 1 << 6,
}

Key_Mod_Flags :: enum i32 {
	None  = 0,
	Ctrl  = 1 << 0,
	Shift = 1 << 1,
	Alt   = 1 << 2,
	Super = 1 << 3,
}

Key :: enum i32 {
	Tab         = 0,
	LeftArrow   = 1,
	RightArrow  = 2,
	UpArrow     = 3,
	DownArrow   = 4,
	PageUp      = 5,
	PageDown    = 6,
	Home        = 7,
	End         = 8,
	Insert      = 9,
	Delete      = 10,
	Backspace   = 11,
	Space       = 12,
	Enter       = 13,
	Escape      = 14,
	KeyPadEnter = 15,
	A           = 16,
	C           = 17,
	V           = 18,
	X           = 19,
	Y           = 20,
	Z           = 21,
	Count       = 22,
}

Layout_Type :: enum i32 {
	Horizontal = 0,
	Vertical   = 1,
}

Log_Type :: enum i32 {
	None      = 0,
	Tty       = 1,
	File      = 2,
	Buffer    = 3,
	Clipboard = 4,
}

Mouse_Button :: enum i32 {
	Left   = 0,
	Right  = 1,
	Middle = 2,
	Count  = 5,
}

Mouse_Cursor :: enum i32 {
	None       = -1,
	Arrow      = 0,
	TextInput  = 1,
	ResizeAll  = 2,
	ResizeNs   = 3,
	ResizeEw   = 4,
	ResizeNesw = 5,
	ResizeNwse = 6,
	Hand       = 7,
	NotAllowed = 8,
	Count      = 9,
}

Nav_Dir_Source_Flags :: enum i32 {
	None      = 0,
	Keyboard  = 1 << 0,
	PadDpad   = 1 << 1,
	PadLstick = 1 << 2,
}

Nav_Forward :: enum i32 {
	None          = 0,
	ForwardQueued = 1,
	ForwardActive = 2,
}

Nav_Highlight_Flags :: enum i32 {
	None        = 0,
	TypeDefault = 1 << 0,
	TypeThin    = 1 << 1,
	AlwaysDraw  = 1 << 2,
	NoRounding  = 1 << 3,
}

Nav_Input :: enum i32 {
	Activate      = 0,
	Cancel        = 1,
	Input         = 2,
	Menu          = 3,
	DpadLeft      = 4,
	DpadRight     = 5,
	DpadUp        = 6,
	DpadDown      = 7,
	LstickLeft    = 8,
	LstickRight   = 9,
	LstickUp      = 10,
	LstickDown    = 11,
	FocusPrev     = 12,
	FocusNext     = 13,
	TweakSlow     = 14,
	TweakFast     = 15,
	KeyMenu       = 16,
	KeyLeft       = 17,
	KeyRight      = 18,
	KeyUp         = 19,
	KeyDown       = 20,
	Count         = 21,
	InternalStart = KeyMenu,
}

Nav_Layer :: enum i32 {
	Main  = 0,
	Menu  = 1,
	Count = 2,
}

Nav_Move_Flags :: enum i32 {
	None                = 0,
	LoopX               = 1 << 0,
	LoopY               = 1 << 1,
	WrapX               = 1 << 2,
	WrapY               = 1 << 3,
	AllowCurrentNavId   = 1 << 4,
	AlsoScoreVisibleSet = 1 << 5,
	ScrollToEdge        = 1 << 6,
}

Next_Item_Data_Flags :: enum i32 {
	None     = 0,
	HasWidth = 1 << 0,
	HasOpen  = 1 << 1,
}

Next_Window_Data_Flags :: enum i32 {
	None              = 0,
	HasPos            = 1 << 0,
	HasSize           = 1 << 1,
	HasContentSize    = 1 << 2,
	HasCollapsed      = 1 << 3,
	HasSizeConstraint = 1 << 4,
	HasFocus          = 1 << 5,
	HasBgAlpha        = 1 << 6,
	HasScroll         = 1 << 7,
}

Plot_Type :: enum i32 {
	Lines     = 0,
	Histogram = 1,
}

Popup_Flags :: enum i32 {
	None                    = 0,
	MouseButtonLeft         = 0,
	MouseButtonRight        = 1,
	MouseButtonMiddle       = 2,
	MouseButtonMask         = 0x1F,
	MouseButtonDefault      = 1,
	NoOpenOverExistingPopup = 1 << 5,
	NoOpenOverItems         = 1 << 6,
	AnyPopupId              = 1 << 7,
	AnyPopupLevel           = 1 << 8,
	AnyPopup                = AnyPopupId | AnyPopupLevel,
}

Popup_Position_Policy :: enum i32 {
	Default  = 0,
	ComboBox = 1,
}

Selectable_Flags_Private :: enum i32 {
	NgActiveId   = 1 << 20,
	NClick       = 1 << 21,
	NRelease     = 1 << 22,
	IlWidth      = 1 << 23,
	EredWhenHeld = 1 << 24,
	DOnHover     = 1 << 25,
}

Selectable_Flags :: enum i32 {
	None             = 0,
	DontClosePopups  = 1 << 0,
	SpanAllColumns   = 1 << 1,
	AllowDoubleClick = 1 << 2,
	Disabled         = 1 << 3,
	AllowItemOverlap = 1 << 4,
}

Separator_Flags :: enum i32 {
	None           = 0,
	Horizontal     = 1 << 0,
	Vertical       = 1 << 1,
	SpanAllColumns = 1 << 2,
}

Slider_Flags :: enum i32 {
	None     = 0,
	Vertical = 1 << 0,
}

Style_Var :: enum i32 {
	Alpha               = 0,
	WindowPadding       = 1,
	WindowRounding      = 2,
	WindowBorderSize    = 3,
	WindowMinSize       = 4,
	WindowTitleAlign    = 5,
	ChildRounding       = 6,
	ChildBorderSize     = 7,
	PopupRounding       = 8,
	PopupBorderSize     = 9,
	FramePadding        = 10,
	FrameRounding       = 11,
	FrameBorderSize     = 12,
	ItemSpacing         = 13,
	ItemInnerSpacing    = 14,
	IndentSpacing       = 15,
	ScrollbarSize       = 16,
	ScrollbarRounding   = 17,
	GrabMinSize         = 18,
	GrabRounding        = 19,
	TabRounding         = 20,
	ButtonTextAlign     = 21,
	SelectableTextAlign = 22,
	Count               = 23,
}

Tab_Bar_Flags_Private :: enum i32 {
	E     = 1 << 20,
	Ed    = 1 << 21,
	Tings = 1 << 22,
}

Tab_Bar_Flags :: enum i32 {
	None                         = 0,
	Reorderable                  = 1 << 0,
	AutoSelectNewTabs            = 1 << 1,
	TabListPopupButton           = 1 << 2,
	NoCloseWithMiddleMouseButton = 1 << 3,
	NoTabListScrollingButtons    = 1 << 4,
	NoTooltip                    = 1 << 5,
	FittingPolicyResizeDown      = 1 << 6,
	FittingPolicyScroll          = 1 << 7,
	FittingPolicyMask            = FittingPolicyResizeDown | FittingPolicyScroll,
	FittingPolicyDefault         = FittingPolicyResizeDown,
}

Tab_Item_Flags_Private :: enum i32 {
	Button = 1 << 20,
}

Tab_Item_Flags :: enum i32 {
	None                         = 0,
	UnsavedDocument              = 1 << 0,
	SetSelected                  = 1 << 1,
	NoCloseWithMiddleMouseButton = 1 << 2,
	NoPushId                     = 1 << 3,
	NoTooltip                    = 1 << 4,
}

Text_Flags :: enum i32 {
	None                       = 0,
	NoWidthForLargeClippedText = 1 << 0,
}

Tooltip_Flags :: enum i32 {
	None                    = 0,
	OverridePreviousTooltip = 1 << 0,
}

Tree_Node_Flags_Private :: enum i32 {
	ElForTrailingButton = 1 << 20,
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
	SpanAvailWidth       = 1 << 11,
	SpanFullWidth        = 1 << 12,
	NavLeftJumpsBackHere = 1 << 13,
	CollapsingHeader     = Framed | NoTreePushOnOpen | NoAutoOpenOnLog,
}

Window_Flags :: enum i32 {
	None                      = 0,
	NoTitleBar                = 1 << 0,
	NoResize                  = 1 << 1,
	NoMove                    = 1 << 2,
	NoScrollbar               = 1 << 3,
	NoScrollWithMouse         = 1 << 4,
	NoCollapse                = 1 << 5,
	AlwaysAutoResize          = 1 << 6,
	NoBackground              = 1 << 7,
	NoSavedSettings           = 1 << 8,
	NoMouseInputs             = 1 << 9,
	MenuBar                   = 1 << 10,
	HorizontalScrollbar       = 1 << 11,
	NoFocusOnAppearing        = 1 << 12,
	NoBringToFrontOnFocus     = 1 << 13,
	AlwaysVerticalScrollbar   = 1 << 14,
	AlwaysHorizontalScrollbar = 1<< 15,
	AlwaysUseWindowPadding    = 1 << 16,
	NoNavInputs               = 1 << 18,
	NoNavFocus                = 1 << 19,
	UnsavedDocument           = 1 << 20,
	NoNav                     = NoNavInputs | NoNavFocus,
	NoDecoration              = NoTitleBar | NoResize | NoScrollbar | NoCollapse,
	NoInputs                  = NoMouseInputs | NoNavInputs | NoNavFocus,
	NavFlattened              = 1 << 23,
	ChildWindow               = 1 << 24,
	Tooltip                   = 1 << 25,
	Popup                     = 1 << 26,
	Modal                     = 1 << 27,
	ChildMenu                 = 1 << 28,
}

