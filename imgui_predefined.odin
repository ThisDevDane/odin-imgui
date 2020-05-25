package imgui;

////////////////////////////
// Predefined Types
@output_copy ID :: distinct u32;
@output_copy Draw_Idx :: distinct u16; 
@output_copy Wchar :: distinct u16; 
@output_copy Texture_ID :: distinct rawptr; 

@output_copy Alloc_Func :: #type proc "c" (size: i64, user_data: rawptr) -> rawptr;
@output_copy Free_Func :: #type proc "c" (ptr: rawptr, user_data: rawptr);
@output_copy Items_Getter_Proc :: #type proc "c" (data: rawptr, idx: i32, out_text: ^cstring) -> bool;
@output_copy Value_Getter_Proc :: #type proc "c" (data: rawptr, idx: i32) -> f32;


///////////////////////////
// DUMMY STRUCTS
@output_copy Context :: opaque struct {};
@output_copy Draw_List_Shared_Data :: opaque struct {};

// ///////////////////////////
// // Predefined structs
@output_copy
Im_Vector :: struct(T : typeid) {
    size:     i32,
    capacity: i32,
    data:     ^T,
}

@(struct_overwrite="ImGuiStoragePair") 
Storage_Pair :: struct {
    key: ID,
    using _: struct #raw_union { 
        val_i: i32, 
        val_f: f32, 
        val_p: rawptr, 
    }
}

///////////////////////////
// Overwriting foreign declerations
@(foreign_overwrite="igSetAllocatorFunctions")
igSetAllocatorFunctions :: proc(alloc_func: Alloc_Func, free_func: Free_Func) ---;
@(foreign_overwrite="igPlotHistogramFnPtr")
igPlotHistogramFnPtr :: proc(label: cstring, values_getter: Value_Getter_Proc, data: rawptr, values_count: i32, values_offset: i32, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: Vec2) ---;
@(foreign_overwrite="igPlotLinesFnPtr")
igPlotLinesFnPtr :: proc(label: cstring, values_getter: Value_Getter_Proc, data: rawptr, values_count: i32, values_offset: i32, overlay_text: cstring, scale_min: f32, scale_max: f32, graph_size: Vec2) ---;
@(foreign_overwrite="igListBoxFnPtr")
igListBoxFnPtr :: proc(label: cstring, current_item: ^i32, items_getter: Items_Getter_Proc, data: rawptr, items_count: i32, height_in_items: i32) -> bool ---;
@(foreign_overwrite="igComboFnPtr")
igComboFnPtr :: proc(label: cstring, current_item: ^i32, items_getter: Items_Getter_Proc, data: rawptr, items_count: i32, popup_max_height_in_items: i32) -> bool ---;

///////////////////////////
// Predefined wrappers
@(wrapper="igSetAllocatorFunctions")
wrapper_set_allocator_functions :: inline proc(alloc_func: Alloc_Func, free_func: Free_Func) {
    igSetAllocatorFunctions(alloc_func, free_func);
}

@(wrapper="igPlotHistogramFnPtr")
wrapper_plot_histogram_fn_ptr :: proc(label: string,
                                      values_getter: Value_Getter_Proc,
                                      data: rawptr,
                                      values_count: i32,
                                      values_offset: i32,
                                      overlay_text: string,
                                      scale_min: f32,
                                      scale_max: f32,
                                      graph_size: Vec2) {
    l := fmt.tprintf("{}\x00", label);
    overlay := fmt.tprintf("{}\x00", overlay_text);
    igPlotHistogramFnPtr(l, values_getter, data, values_count, values_offset, cstring(&overlay[0]), scale_min, scale_max, graph_size);
}

@(wrapper="igPlotLinesFnPtr")
wrapper_plot_lines_fn_ptr :: proc(label: string, 
                                  values_getter: Value_Getter_Proc, 
                                  data: rawptr, 
                                  values_count: i32, 
                                  values_offset: i32, 
                                  overlay_text: string, 
                                  scale_min: f32, 
                                  scale_max: f32, 
                                  graph_size: Vec2) {
    l := fmt.tprintf("{}\x00", label);
    overlay := fmt.tprintf("{}\x00", overlay_text);
    igPlotLinesFnPtr(l, values_getter, data, values_count, values_offset, cstring(&overlay[0]), scale_min, scale_max, graph_size);
}

@(wrapper="igListBoxFnPtr")
wrapper_list_box_fn_ptr :: proc(label: string, current_item: ^i32, items_getter: Items_Getter_Proc, data: rawptr, items_count: i32, height_in_items: i32) -> bool {
    l := fmt.tprintf("{}\x00", label);
    return igListBoxFnPtr(cstring(&label[0]), current_item, items_getter, data, items_count, height_in_items);
}

@(wrapper="igComboFnPtr")
wrapper_combo_fn_ptr :: proc(label: string, current_item: ^i32, items_getter: Items_Getter_Proc, data: rawptr, items_count: i32, popup_max_height_in_items: i32) -> bool {
    l := fmt.tprintf("{}\x00", label);
    return igComboFnPtr(cstring(&label[0]), current_item, items_getter, data, items_count, popup_max_height_in_items);
}

@(wrapper="igTextColored") 
wrapper_text_colored :: proc(col: Vec4, fmt : string, args : ..any) {
    fmt_str := fmt.tprinf("{}\x00", fmt);
    str := fmt.tprinf(fmt_str, ..args);
    igTextColored(col, cstring(&str[0]), nil);
}

@(wrapper="igTextUnformatted") 
wrapper_unformatted_text :: proc(text: string) {
    igTextUnformatted(cstring(&text[0]), cstring(&text[len(text)]));
}

@(wrapper="igText") 
wrapper_text :: proc(fmt : string, args : ..any) {
    str := fmt.tprinf(fmt, ..args);
    igTextUnformatted(cstring(&str[0]), cstring(&str[len(str)]));
}
