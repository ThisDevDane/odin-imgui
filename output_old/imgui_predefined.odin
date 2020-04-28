package imgui

import "core:fmt"

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

@(type="ImGuiStoragePair") 
Storage_Pair :: struct {
    key : ID,
    using _: struct #raw_union { 
        val_i : i32, 
        val_f : f32, 
        val_p : rawptr, 
    }
}

@(type="ImVec2") 
Vec2 :: struct {
    x : f32,
    y : f32,
};

@(type="ImVec4") 
Vec4 :: struct {
    x : f32,
    y : f32,
    z : f32,
    w : f32,
};



///////////////////////////
// Predefined proc protoypes
@(predefined="GetClipboardTextFn")
get_clipboard_text_function :: proc "c"(user_data : rawptr) -> cstring;
@(predefined="SetClipboardTextFn")
set_clipboard_text_function :: proc "c"(user_data : rawptr, text : cstring);
@(predefined="ImeSetInputScreenPosFn")
ime_set_input_screen_pos_function :: proc "c"(x, y : i32);

///////////////////////////
// Predefined wrappers

@(wrapper="igBeginCombo") 
wrapper_begin_combo       :: proc(label : string, preview : string, flags : Combo_Flags = 0) -> bool {
    return igBeginCombo(_make_label_string(label), fmt.tprint(preview), flags);
}

@(wrapper="igDragFloat")
wrapper_drag_float        :: proc(label : string, v : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : string = "%.3f", power : f32 = 1.0) -> bool {
    return igDragFloat(_make_label_string(label), v, v_speed, v_min, v_max, fmt.tprint(format), power);
}

@(wrapper="igDragFloat2")
wrapper_drag_float2       :: proc(label : string, v : [2]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : string = "%.3f", power : f32 = 1.0) -> bool {
    return igDragFloat2(_make_label_string(label), v, v_speed, v_min, v_max, fmt.tprint(format), power);
}

@(wrapper="igDragFloat3")
wrapper_drag_float3       :: proc(label : string, v : [3]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : string = "%.3f", power : f32 = 1.0) -> bool {
    return igDragFloat3(_make_label_string(label), v, v_speed, v_min, v_max, fmt.tprint(format), power);
}

@(wrapper="igDragFloat4")
wrapper_drag_float4       :: proc(label : string, v : [4]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : string = "%.3f", power : f32 = 1.0) -> bool {
    return igDragFloat4(_make_label_string(label), v, v_speed, v_min, v_max, fmt.tprint(format), power);
}

@(wrapper="igDragFloatRange2")
wrapper_drag_float_range2 :: proc(label : string, v_current_min : ^f32, v_current_max : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", format_max : cstring = nil, power : f32 = 1.0) -> bool {
    return igDragFloatRange2(_make_label_string(label), v_current_min, v_current_max, v_speed, v_min, v_max, fmt.tprint(format), fmt.tprint(format_max));
}

@(wrapper="igDragInt")
wrapper_drag_int          :: proc(label : string, v : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool {
    return igDragInt(_make_label_string(label), v, v_speed, v_min, v_max, fmt.tprint(format));
}

@(wrapper="igDragInt2")
wrapper_drag_int2         :: proc(label : string, v : [2]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool {
    return igDragInt2(_make_label_string(label), v, v_speed, v_min, v_max, fmt.tprint(format));
}

@(wrapper="igDragInt3")
wrapper_drag_int3         :: proc(label : string, v : [3]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool {
    return igDragInt3(_make_label_string(label), v, v_speed, v_min, v_max, fmt.tprint(format));
}

@(wrapper="igDragInt4")
wrapper_drag_int4         :: proc(label : string, v : [4]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool {
    return igDragInt4(_make_label_string(label), v, v_speed, v_min, v_max, fmt.tprint(format));
}

@(wrapper="igDragIntRange2")
wrapper_drag_int_range2   :: proc(label : string, v_current_min : ^i32, v_current_max : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d", format_max : cstring = nil) -> bool {
    return igDragIntRange2(_make_label_string(label), v_current_min, v_current_max, v_speed, v_min, v_max, fmt.tprint(format), fmt.tprint(format_max));
}

@(wrapper="igDragScalar")
wrapper_drag_scalar       :: proc(label : string, data_type : Data_Type, p_data : rawptr, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool {
    return igDragScalar(_make_label_string(label), data_type, p_data, v_speed, p_min, p_max, fmt.tprint(format), power);
}

@(wrapper="igDragScalarN")
wrapper_drag_scalar_n     :: proc(label : string, data_type : Data_Type, p_data : rawptr, components : i32, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool {
    return igDragScalarN(_make_label_string(label), data_type, p_data, components, v_speed, p_min, p_max, fmt.tprint(format), power);
}
