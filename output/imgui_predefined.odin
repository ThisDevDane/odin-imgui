package imgui

////////////////////////////
// Predefined Types
ID         :: distinct u32;
Draw_Idx   :: distinct u16; 
Wchar      :: distinct u16; 
Texture_ID :: distinct rawptr; 

///////////////////////////
// DUMMY STRUCTS
Context               :: opaque struct {};
Draw_List_Shared_Data :: opaque struct {};

///////////////////////////
// Predefined structs
Im_Vector :: struct(T : typeid) {
    size     : i32,
    capacity : i32,
    data     : ^T,
}

Storage_Pair :: struct {
    key : ID,
    using _: struct #raw_union { 
        val_i : i32, 
        val_f : f32, 
        val_p : rawptr, 
    }
}

Vec2 :: struct {
    x : f32,
    y : f32,
};

Vec4 :: struct {
    x : f32,
    y : f32,
    z : f32,
    w : f32,
};



///////////////////////////
// Predefined proc protoypes
get_clipboard_text_function :: proc "c"(user_data : rawptr) -> cstring;
set_clipboard_text_function :: proc "c"(user_data : rawptr, text : cstring);
ime_set_input_screen_pos_function :: proc "c"(x, y : i32);
