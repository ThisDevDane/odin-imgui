package main;


structs_predefined := map[string]string {
    "ImGuiStoragePair" = "Storage_Pair",
    "ImDrawListSharedData" = "Draw_List_Shared_Data",
    "ImVec2" = "Vec2",
    "ImVec4" = "Vec4",
};

predefined_defaults_by_value := map[string]string {
    "(((ImU32)(255)<<24)|((ImU32)(255)<<16)|((ImU32)(255)<<8)|((ImU32)(255)<<0))" = "0xffffffff"
};

proc_name_by_link_name := map[string]string {
    "ImGuiStoragePair_ImGuiStoragePairInt" = "StoragePair_i32_ctor",
    "ImGuiStoragePair_ImGuiStoragePairFloat" = "StoragePair_f32_ctor",
    "ImGuiStoragePair_ImGuiStoragePairPtr" = "StoragePair_rawptr_ctor",
};

wrappers : map[string]Proc_Wrapper;

predefined_type_by_name := map[string]string {
    // IO
    "GetClipboardTextFn" = "get_clipboard_text_function",
    "SetClipboardTextFn" = "set_clipboard_text_function",
    "ImeSetInputScreenPosFn" = "ime_set_input_screen_pos_function",

    // PROCS
    "values_getter" = "proc \"c\"(data : rawptr, idx : i32) -> f32",
    "items_getter" = "proc \"c\"(data : rawptr, idx : i32, out_text : ^^u8) -> bool",
    "alloc_func" = "proc \"c\"(sz : uint, user_date : rawptr) -> rawptr",
    "free_func" = "proc \"c\"(ptr : rawptr, user_date : rawptr) -> rawptr",
};

predefined_base_type_by_type := map[string]string {

    "char"           = "i8",
    "unsigned char"  = "u8",
    "unsigned short" = "u16",
    "short"          = "i16",
    "unsigned int"   = "u32",
    "int"            = "i32",
    "float"          = "f32",
    "double"         = "f64",
    "size_t"         = "uint",
    "bool"           = "bool",

    "ImU32" = "u32",
};

predefined_type_by_type := map[string]string {
    "ImVector_ImTextureID" = "Im_Vector(Texture_ID)",
    "ImVector_ImWchar" = "Im_Vector(Wchar)",
    "ImVector_ImVec2" = "Im_Vector(Vec2)",
    "ImVector_ImVec4" = "Im_Vector(Vec4)",
    
    "ImVector_ImGuiTextRange" = "Im_Vector(Text_Range)",
    "ImVector_ImGuiStoragePair" = "Im_Vector(Storage_Pair)",
    
    "ImVector_ImFontConfig" = "Im_Vector(Font_Config)",
    "ImVector_ImFontAtlasCustomRect" = "Im_Vector(Font_Atlas_Custom_Rect)",
    "ImVector_ImFontPtr" = "Im_Vector(^Font)",
    "ImVector_ImFontGlyph" = "Im_Vector(Font_Glyph)",
    
    "ImVector_ImDrawChannel" = "Im_Vector(Draw_Channel)",
    "ImVector_ImDrawCmd" = "Im_Vector(Draw_Cmd)",
    "ImVector_ImDrawIdx" = "Im_Vector(Draw_Idx)",
    "ImVector_ImDrawVert" = "Im_Vector(Draw_Vert)",

    "ImVector_ImU32" = "Im_Vector(u32)",
    "ImVector_float" = "Im_Vector(f32)",
    "ImVector_char" = "Im_Vector(u8)",

    "ImTextureID" = "Texture_ID",
    "ImGuiID" = "ID",

    "ImVec2" = "Vec2",
    "ImVec4" = "Vec4",
};