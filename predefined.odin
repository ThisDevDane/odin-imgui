package main;

////////////////////////////
// Predefined Types
ID        :: distinct u32;
DrawIdx   :: distinct u16; 
Wchar     :: distinct u16; 
TextureID :: distinct rawptr; 

///////////////////////////
// DUMMY STRUCTS
Context            :: struct {}
DrawListSharedData :: struct {}

///////////////////////////
// Predefined structs
ImVector :: struct(T : typeid) {
    size     : i32,
    capacity : i32,
    data     : ^T,
}

StoragePair :: struct {
    key : ID,
    using _: struct #raw_union { 
        val_i : i32, 
        val_f : f32, 
        val_p : rawptr, 
    }
}

///////////////////////////
// Predefined proc protoypes
get_clipboard_text_function :: proc "c"(user_data : rawptr) -> cstring;
set_clipboard_text_function :: proc "c"(user_data : rawptr, text : cstring);
ime_set_input_screen_pos_function :: proc "c"(x, y : i32);


///////////////////////////
// 
structs_predefined := map[string]string {
    "ImGuiStoragePair" = "StoragePair",
    "ImDrawListSharedData" = "DrawListSharedData",
};

proc_name_by_link_name := map[string]string {
    "ImGuiStoragePair_ImGuiStoragePairInt" = "StoragePair_i32_ctor",
    "ImGuiStoragePair_ImGuiStoragePairFloat" = "StoragePair_f32_ctor",
    "ImGuiStoragePair_ImGuiStoragePairPtr" = "StoragePair_rawptr_ctor",
};

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

predefined_type_by_type := map[string]string {

    "char"           = "i8",
    "unsigned char"  = "u8",
    "unsigned short" = "u16",
    "short"          = "i16",
    "unsigned int"   = "u32",
    "int"            = "i32",
    "float"          = "f32",
    "double"         = "f64",
    "size_t"         = "uint",

    "ImU32" = "u32",

    "ImVector_ImTextureID" = "ImVector(TextureID)",
    "ImVector_ImWchar" = "ImVector(Wchar)",
    "ImVector_ImVec2" = "ImVector(Vec2)",
    "ImVector_ImVec4" = "ImVector(Vec4)",
    
    "ImVector_ImGuiTextRange" = "ImVector(TextRange)",
    "ImVector_ImGuiStoragePair" = "ImVector(StoragePair)",
    
    "ImVector_ImFontConfig" = "ImVector(FontConfig)",
    "ImVector_ImFontAtlasCustomRect" = "ImVector(FontAtlasCustomRect)",
    "ImVector_ImFontPtr" = "ImVector(^Font)",
    "ImVector_ImFontGlyph" = "ImVector(FontGlyph)",
    
    "ImVector_ImDrawChannel" = "ImVector(DrawChannel)",
    "ImVector_ImDrawCmd" = "ImVector(DrawCmd)",
    "ImVector_ImDrawIdx" = "ImVector(DrawIdx)",
    "ImVector_ImDrawVert" = "ImVector(DrawVert)",

    "ImVector_ImU32" = "ImVector(u32)",
    "ImVector_float" = "ImVector(f32)",
    "ImVector_char" = "ImVector(u8)",
};