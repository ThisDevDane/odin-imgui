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

Im_Chunk_Stream :: struct(T : typeid) {
    buf: Im_Vector(T),
}

Im_Vector :: struct(T : typeid) {
    size:     i32, 
    capacity: i32,
    data:     ^T,
}

Im_Pool :: struct(T : typeid) {
    buf:      Im_Vector(T),
    map_:     Storage,
    free_idx: i32,
}

STB_Textedit_State :: struct {
    cursor:                i32,
    select_start:          i32,
    select_end:            i32,
    insert_mode:           u8,
    cursor_at_end_of_line: u8,
    initialized:           u8,
    has_preferred_x:       u8,
    single_line:           u8,
    padding1:              u8, 
    padding2:              u8, 
    padding3:              u8,
    preferred_x:           f32,
    undo_state:            STB_Undo_State,
}

STB_Undo_State :: struct {
    undo_rec:        [99]STB_Undo_Record,
    undo_char:       [999]Wchar,
    undo_point:      i16, 
    redo_point:      i16,
    undo_char_point: i32, 
    redo_char_point: i32,
}

STB_Undo_Record :: struct {
    where_:        i32,
    insert_length: i32,
    delete_length: i32,
    char_storage:  i32,
}

