package imgui;

ImID :: distinct u32;

Draw_Idx :: distinct u16;

Wchar :: distinct u16;

Wchar16 :: distinct u16;

Wchar32 :: distinct u32;

Texture_ID :: distinct rawptr;

File_Handle :: distinct uintptr;

Alloc_Func :: #type proc "c" (size: i64, user_data: rawptr) -> rawptr;

Free_Func :: #type proc "c" (ptr: rawptr, user_data: rawptr);

Items_Getter_Proc :: #type proc "c" (data: rawptr, idx: i32, out_text: ^cstring) -> bool;

Value_Getter_Proc :: #type proc "c" (data: rawptr, idx: i32) -> f32;

Draw_Callback :: #type proc "c" (parent_list: ^Draw_List, cmd: ^Draw_Cmd);

Input_Text_Callback :: #type proc "c" (data: ^Input_Text_Callback_Data) -> int;

Size_Callback :: #type proc "c" (data: ^Size_Callback_Data);

Draw_List_Shared_Data :: opaque struct {};

Context :: opaque struct {};

Im_Vector :: struct(T : typeid) {
    size:     i32, 
    capacity: i32,
    data:     ^T,
}

