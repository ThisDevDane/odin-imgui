package imgui;

import "core:fmt";
import "core:strings";
import "core:mem";



// AUTO_GENERATED for 'ImDrawList_AddText_Vec2'
swr_ImDrawList_AddText_Vec2 :: proc(self: ^Draw_List, pos: Vec2, col: u32, text_begin: string, text_end: string) {
	str3 := strings.clone_to_cstring(text_begin, context.temp_allocator);
	str4 := strings.clone_to_cstring(text_end, context.temp_allocator);
	ImDrawList_AddText_Vec2(self, pos, col, str3, str4);
}

// AUTO_GENERATED for 'ImDrawList_AddText_FontPtr'
swr_ImDrawList_AddText_FontPtr :: proc(self: ^Draw_List, font: ^ImFont, font_size: f32, pos: Vec2, col: u32, text_begin: string, text_end: string, wrap_width: f32, cpu_fine_clip_rect: ^Vec4) {
	str5 := strings.clone_to_cstring(text_begin, context.temp_allocator);
	str6 := strings.clone_to_cstring(text_end, context.temp_allocator);
	ImDrawList_AddText_FontPtr(self, font, font_size, pos, col, str5, str6, wrap_width, cpu_fine_clip_rect);
}



// AUTO_GENERATED for 'ImFontAtlas_AddFontFromFileTTF'
swr_ImFontAtlas_AddFontFromFileTTF :: proc(self: ^Font_Atlas, filename: string, size_pixels: f32, font_cfg: ^Font_Config, glyph_ranges: ^Wchar) -> ^ImFont {
	str1 := strings.clone_to_cstring(filename, context.temp_allocator);
	return ImFontAtlas_AddFontFromFileTTF(self, str1, size_pixels, font_cfg, glyph_ranges);
}

// AUTO_GENERATED for 'ImFontAtlas_AddFontFromMemoryCompressedBase85TTF'
swr_ImFontAtlas_AddFontFromMemoryCompressedBase85TTF :: proc(self: ^Font_Atlas, compressed_font_data_base85: string, size_pixels: f32, font_cfg: ^Font_Config, glyph_ranges: ^Wchar) -> ^ImFont {
	str1 := strings.clone_to_cstring(compressed_font_data_base85, context.temp_allocator);
	return ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(self, str1, size_pixels, font_cfg, glyph_ranges);
}


// AUTO_GENERATED for 'ImFontGlyphRangesBuilder_AddText'
swr_ImFontGlyphRangesBuilder_AddText :: proc(self: ^Font_Glyph_Ranges_Builder, text: string, text_end: string) {
	str1 := strings.clone_to_cstring(text, context.temp_allocator);
	str2 := strings.clone_to_cstring(text_end, context.temp_allocator);
	ImFontGlyphRangesBuilder_AddText(self, str1, str2);
}


// AUTO_GENERATED for 'ImFont_CalcTextSizeA'
swr_ImFont_CalcTextSizeA :: proc(pOut: ^Vec2, self: ^ImFont, size: f32, max_width: f32, wrap_width: f32, text_begin: string, text_end: string, remaining: ^cstring) {
	str5 := strings.clone_to_cstring(text_begin, context.temp_allocator);
	str6 := strings.clone_to_cstring(text_end, context.temp_allocator);
	ImFont_CalcTextSizeA(pOut, self, size, max_width, wrap_width, str5, str6, remaining);
}

// AUTO_GENERATED for 'ImFont_CalcWordWrapPositionA'
swr_ImFont_CalcWordWrapPositionA :: proc(self: ^ImFont, scale: f32, text: string, text_end: string, wrap_width: f32) -> cstring {
	str2 := strings.clone_to_cstring(text, context.temp_allocator);
	str3 := strings.clone_to_cstring(text_end, context.temp_allocator);
	return ImFont_CalcWordWrapPositionA(self, scale, str2, str3, wrap_width);
}

// AUTO_GENERATED for 'ImFont_RenderText'
swr_ImFont_RenderText :: proc(self: ^ImFont, draw_list: ^Draw_List, size: f32, pos: Vec2, col: u32, clip_rect: Vec4, text_begin: string, text_end: string, wrap_width: f32, cpu_fine_clip: bool) {
	str6 := strings.clone_to_cstring(text_begin, context.temp_allocator);
	str7 := strings.clone_to_cstring(text_end, context.temp_allocator);
	ImFont_RenderText(self, draw_list, size, pos, col, clip_rect, str6, str7, wrap_width, cpu_fine_clip);
}


// AUTO_GENERATED for 'ImGuiIO_AddInputCharactersUTF8'
swr_ImGuiIO_AddInputCharactersUTF8 :: proc(self: ^IO, str: string) {
	str1 := strings.clone_to_cstring(str, context.temp_allocator);
	ImGuiIO_AddInputCharactersUTF8(self, str1);
}


// AUTO_GENERATED for 'ImGuiInputTextCallbackData_InsertChars'
swr_ImGuiInputTextCallbackData_InsertChars :: proc(self: ^Input_Text_Callback_Data, pos: i32, text: string, text_end: string) {
	str2 := strings.clone_to_cstring(text, context.temp_allocator);
	str3 := strings.clone_to_cstring(text_end, context.temp_allocator);
	ImGuiInputTextCallbackData_InsertChars(self, pos, str2, str3);
}



// AUTO_GENERATED for 'ImGuiPayload_IsDataType'
swr_ImGuiPayload_IsDataType :: proc(self: ^Payload, type: string) -> bool {
	str1 := strings.clone_to_cstring(type, context.temp_allocator);
	return ImGuiPayload_IsDataType(self, str1);
}




// AUTO_GENERATED for 'ImGuiTextBuffer_append'
swr_ImGuiTextBuffer_append :: proc(self: ^Text_Buffer, str: string, str_end: string) {
	str1 := strings.clone_to_cstring(str, context.temp_allocator);
	str2 := strings.clone_to_cstring(str_end, context.temp_allocator);
	ImGuiTextBuffer_append(self, str1, str2);
}

// AUTO_GENERATED for 'ImGuiTextBuffer_appendf'
swr_ImGuiTextBuffer_appendf :: proc(self: ^Text_Buffer, fmt_: string, args: ..any) {
	str1 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	ImGuiTextBuffer_appendf(self, str1, args);
}


// AUTO_GENERATED for 'ImGuiTextFilter_Draw'
swr_ImGuiTextFilter_Draw :: proc(self: ^Text_Filter, label: string, width: f32) -> bool {
	str1 := strings.clone_to_cstring(label, context.temp_allocator);
	return ImGuiTextFilter_Draw(self, str1, width);
}

// AUTO_GENERATED for 'ImGuiTextFilter_PassFilter'
swr_ImGuiTextFilter_PassFilter :: proc(self: ^Text_Filter, text: string, text_end: string) -> bool {
	str1 := strings.clone_to_cstring(text, context.temp_allocator);
	str2 := strings.clone_to_cstring(text_end, context.temp_allocator);
	return ImGuiTextFilter_PassFilter(self, str1, str2);
}




// AUTO_GENERATED for 'igAcceptDragDropPayload'
swr_igAcceptDragDropPayload :: proc(type: string, flags: Drag_Drop_Flags) -> ^Payload {
	str0 := strings.clone_to_cstring(type, context.temp_allocator);
	return igAcceptDragDropPayload(str0, flags);
}

// AUTO_GENERATED for 'igArrowButton'
swr_igArrowButton :: proc(str_id: string, dir: Dir) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igArrowButton(str0, dir);
}

// AUTO_GENERATED for 'igBegin'
swr_igBegin :: proc(name: string, p_open: ^bool, flags: Window_Flags) -> bool {
	str0 := strings.clone_to_cstring(name, context.temp_allocator);
	return igBegin(str0, p_open, flags);
}

// AUTO_GENERATED for 'igBeginChild_Str'
swr_igBeginChild_Str :: proc(str_id: string, size: Vec2, border: bool, flags: Window_Flags) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igBeginChild_Str(str0, size, border, flags);
}

// AUTO_GENERATED for 'igBeginCombo'
swr_igBeginCombo :: proc(label: string, preview_value: string, flags: Combo_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str1 := strings.clone_to_cstring(preview_value, context.temp_allocator);
	return igBeginCombo(str0, str1, flags);
}

// AUTO_GENERATED for 'igBeginListBox'
swr_igBeginListBox :: proc(label: string, size: Vec2) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igBeginListBox(str0, size);
}

// AUTO_GENERATED for 'igBeginMenu'
swr_igBeginMenu :: proc(label: string, enabled: bool) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igBeginMenu(str0, enabled);
}

// AUTO_GENERATED for 'igBeginPopup'
swr_igBeginPopup :: proc(str_id: string, flags: Window_Flags) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igBeginPopup(str0, flags);
}

// AUTO_GENERATED for 'igBeginPopupContextItem'
swr_igBeginPopupContextItem :: proc(str_id: string, popup_flags: Popup_Flags) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igBeginPopupContextItem(str0, popup_flags);
}

// AUTO_GENERATED for 'igBeginPopupContextVoid'
swr_igBeginPopupContextVoid :: proc(str_id: string, popup_flags: Popup_Flags) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igBeginPopupContextVoid(str0, popup_flags);
}

// AUTO_GENERATED for 'igBeginPopupContextWindow'
swr_igBeginPopupContextWindow :: proc(str_id: string, popup_flags: Popup_Flags) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igBeginPopupContextWindow(str0, popup_flags);
}

// AUTO_GENERATED for 'igBeginPopupModal'
swr_igBeginPopupModal :: proc(name: string, p_open: ^bool, flags: Window_Flags) -> bool {
	str0 := strings.clone_to_cstring(name, context.temp_allocator);
	return igBeginPopupModal(str0, p_open, flags);
}

// AUTO_GENERATED for 'igBeginTabBar'
swr_igBeginTabBar :: proc(str_id: string, flags: Tab_Bar_Flags) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igBeginTabBar(str0, flags);
}

// AUTO_GENERATED for 'igBeginTabItem'
swr_igBeginTabItem :: proc(label: string, p_open: ^bool, flags: Tab_Item_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igBeginTabItem(str0, p_open, flags);
}

// AUTO_GENERATED for 'igBeginTable'
swr_igBeginTable :: proc(str_id: string, column: i32, flags: Table_Flags, outer_size: Vec2, inner_width: f32) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igBeginTable(str0, column, flags, outer_size, inner_width);
}

// AUTO_GENERATED for 'igBulletText'
swr_igBulletText :: proc(fmt_: string, args: ..any) {
	str0 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	igBulletText(str0, args);
}

// AUTO_GENERATED for 'igButton'
swr_igButton :: proc(label: string, size: Vec2) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igButton(str0, size);
}

// AUTO_GENERATED for 'igCalcTextSize'
swr_igCalcTextSize :: proc(pOut: ^Vec2, text: string, text_end: string, hide_text_after_double_hash: bool, wrap_width: f32) {
	str1 := strings.clone_to_cstring(text, context.temp_allocator);
	str2 := strings.clone_to_cstring(text_end, context.temp_allocator);
	igCalcTextSize(pOut, str1, str2, hide_text_after_double_hash, wrap_width);
}

// AUTO_GENERATED for 'igCheckbox'
swr_igCheckbox :: proc(label: string, v: ^bool) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igCheckbox(str0, v);
}

// AUTO_GENERATED for 'igCheckboxFlags_IntPtr'
swr_igCheckboxFlags_IntPtr :: proc(label: string, flags: ^i32, flags_value: i32) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igCheckboxFlags_IntPtr(str0, flags, flags_value);
}

// AUTO_GENERATED for 'igCheckboxFlags_UintPtr'
swr_igCheckboxFlags_UintPtr :: proc(label: string, flags: ^u32, flags_value: u32) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igCheckboxFlags_UintPtr(str0, flags, flags_value);
}

// AUTO_GENERATED for 'igCollapsingHeader_TreeNodeFlags'
swr_igCollapsingHeader_TreeNodeFlags :: proc(label: string, flags: Tree_Node_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igCollapsingHeader_TreeNodeFlags(str0, flags);
}

// AUTO_GENERATED for 'igCollapsingHeader_BoolPtr'
swr_igCollapsingHeader_BoolPtr :: proc(label: string, p_visible: ^bool, flags: Tree_Node_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igCollapsingHeader_BoolPtr(str0, p_visible, flags);
}

// AUTO_GENERATED for 'igColorButton'
swr_igColorButton :: proc(desc_id: string, col: Vec4, flags: Color_Edit_Flags, size: Vec2) -> bool {
	str0 := strings.clone_to_cstring(desc_id, context.temp_allocator);
	return igColorButton(str0, col, flags, size);
}

// AUTO_GENERATED for 'igColorEdit3'
swr_igColorEdit3 :: proc(label: string, col: [^]f32, flags: Color_Edit_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igColorEdit3(str0, col, flags);
}

// AUTO_GENERATED for 'igColorEdit4'
swr_igColorEdit4 :: proc(label: string, col: [^]f32, flags: Color_Edit_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igColorEdit4(str0, col, flags);
}

// AUTO_GENERATED for 'igColorPicker3'
swr_igColorPicker3 :: proc(label: string, col: [^]f32, flags: Color_Edit_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igColorPicker3(str0, col, flags);
}

// AUTO_GENERATED for 'igColorPicker4'
swr_igColorPicker4 :: proc(label: string, col: [^]f32, flags: Color_Edit_Flags, ref_col: ^f32) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igColorPicker4(str0, col, flags, ref_col);
}

// AUTO_GENERATED for 'igColumns'
swr_igColumns :: proc(count: i32, id: string, border: bool) {
	str1 := strings.clone_to_cstring(id, context.temp_allocator);
	igColumns(count, str1, border);
}

// PREDEFINED FOR 'igCombo_Str_arr'
wrapper_combo_str_arr :: proc(label: string, current_item: ^i32, items: []string, popup_max_height_in_items := i32(0)) -> bool {
    l := strings.clone_to_cstring(label, context.temp_allocator);

    data := make([]cstring, len(items), context.temp_allocator);
    for item, idx in items {
        data[idx] = strings.clone_to_cstring(item, context.temp_allocator);
    }

    return igCombo_Str_arr(l, current_item, &data[0], i32(len(items)), popup_max_height_in_items);
}

// AUTO_GENERATED for 'igCombo_Str'
swr_igCombo_Str :: proc(label: string, current_item: ^i32, items_separated_by_zeros: string, popup_max_height_in_items: i32) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str2 := strings.clone_to_cstring(items_separated_by_zeros, context.temp_allocator);
	return igCombo_Str(str0, current_item, str2, popup_max_height_in_items);
}

// PREDEFINED FOR 'igCombo_FnBoolPtr'
wrapper_combo_fn_bool_ptr :: proc(label: string, current_item: ^i32, items_getter: Items_Getter_Proc, data: rawptr, items_count: i32, popup_max_height_in_items := i32(0)) -> bool {
    l := strings.clone_to_cstring(label, context.temp_allocator);
    return igCombo_FnBoolPtr(l, current_item, items_getter, data, items_count, popup_max_height_in_items);
}

// AUTO_GENERATED for 'igDebugCheckVersionAndDataLayout'
swr_igDebugCheckVersionAndDataLayout :: proc(version_str: string, sz_io: uint, sz_style: uint, sz_vec2: uint, sz_vec4: uint, sz_drawvert: uint, sz_drawidx: uint) -> bool {
	str0 := strings.clone_to_cstring(version_str, context.temp_allocator);
	return igDebugCheckVersionAndDataLayout(str0, sz_io, sz_style, sz_vec2, sz_vec4, sz_drawvert, sz_drawidx);
}

// AUTO_GENERATED for 'igDragFloat'
swr_igDragFloat :: proc(label: string, v: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragFloat(str0, v, v_speed, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igDragFloat2'
swr_igDragFloat2 :: proc(label: string, v: [^]f32, v_speed: f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragFloat2(str0, v, v_speed, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igDragFloat3'
swr_igDragFloat3 :: proc(label: string, v: [^]f32, v_speed: f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragFloat3(str0, v, v_speed, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igDragFloat4'
swr_igDragFloat4 :: proc(label: string, v: [^]f32, v_speed: f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragFloat4(str0, v, v_speed, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igDragFloatRange2'
swr_igDragFloatRange2 :: proc(label: string, v_current_min: ^f32, v_current_max: ^f32, v_speed: f32, v_min: f32, v_max: f32, format: string, format_max: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str6 := strings.clone_to_cstring(format, context.temp_allocator);
	str7 := strings.clone_to_cstring(format_max, context.temp_allocator);
	return igDragFloatRange2(str0, v_current_min, v_current_max, v_speed, v_min, v_max, str6, str7, flags);
}

// AUTO_GENERATED for 'igDragInt'
swr_igDragInt :: proc(label: string, v: ^i32, v_speed: f32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragInt(str0, v, v_speed, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igDragInt2'
swr_igDragInt2 :: proc(label: string, v: [^]i32, v_speed: f32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragInt2(str0, v, v_speed, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igDragInt3'
swr_igDragInt3 :: proc(label: string, v: [^]i32, v_speed: f32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragInt3(str0, v, v_speed, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igDragInt4'
swr_igDragInt4 :: proc(label: string, v: [^]i32, v_speed: f32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragInt4(str0, v, v_speed, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igDragIntRange2'
swr_igDragIntRange2 :: proc(label: string, v_current_min: ^i32, v_current_max: ^i32, v_speed: f32, v_min: i32, v_max: i32, format: string, format_max: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str6 := strings.clone_to_cstring(format, context.temp_allocator);
	str7 := strings.clone_to_cstring(format_max, context.temp_allocator);
	return igDragIntRange2(str0, v_current_min, v_current_max, v_speed, v_min, v_max, str6, str7, flags);
}

// AUTO_GENERATED for 'igDragScalar'
swr_igDragScalar :: proc(label: string, data_type: Data_Type, p_data: rawptr, v_speed: f32, p_min: rawptr, p_max: rawptr, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str6 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragScalar(str0, data_type, p_data, v_speed, p_min, p_max, str6, flags);
}

// AUTO_GENERATED for 'igDragScalarN'
swr_igDragScalarN :: proc(label: string, data_type: Data_Type, p_data: rawptr, components: i32, v_speed: f32, p_min: rawptr, p_max: rawptr, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str7 := strings.clone_to_cstring(format, context.temp_allocator);
	return igDragScalarN(str0, data_type, p_data, components, v_speed, p_min, p_max, str7, flags);
}

// AUTO_GENERATED for 'igGetID_Str'
swr_igGetID_Str :: proc(str_id: string) -> ImID {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igGetID_Str(str0);
}

// AUTO_GENERATED for 'igGetID_StrStr'
swr_igGetID_StrStr :: proc(str_id_begin: string, str_id_end: string) -> ImID {
	str0 := strings.clone_to_cstring(str_id_begin, context.temp_allocator);
	str1 := strings.clone_to_cstring(str_id_end, context.temp_allocator);
	return igGetID_StrStr(str0, str1);
}

// PREDEFINED FOR 'igGetWindowPos'
wrapper_get_window_pos :: proc() -> Vec2 {
    res := Vec2{};
    igGetWindowPos(&res);
    return res;
}

// PREDEFINED FOR 'igGetWindowSize'
wrapper_get_window_size :: proc() -> Vec2 {
    res := Vec2{};
    igGetWindowSize(&res);
    return res;
}

// AUTO_GENERATED for 'igInputDouble'
swr_igInputDouble :: proc(label: string, v: ^f64, step: f64, step_fast: f64, format: string, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igInputDouble(str0, v, step, step_fast, str4, flags);
}

// AUTO_GENERATED for 'igInputFloat'
swr_igInputFloat :: proc(label: string, v: ^f32, step: f32, step_fast: f32, format: string, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igInputFloat(str0, v, step, step_fast, str4, flags);
}

// AUTO_GENERATED for 'igInputFloat2'
swr_igInputFloat2 :: proc(label: string, v: [^]f32, format: string, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str2 := strings.clone_to_cstring(format, context.temp_allocator);
	return igInputFloat2(str0, v, str2, flags);
}

// AUTO_GENERATED for 'igInputFloat3'
swr_igInputFloat3 :: proc(label: string, v: [^]f32, format: string, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str2 := strings.clone_to_cstring(format, context.temp_allocator);
	return igInputFloat3(str0, v, str2, flags);
}

// AUTO_GENERATED for 'igInputFloat4'
swr_igInputFloat4 :: proc(label: string, v: [^]f32, format: string, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str2 := strings.clone_to_cstring(format, context.temp_allocator);
	return igInputFloat4(str0, v, str2, flags);
}

// AUTO_GENERATED for 'igInputInt'
swr_igInputInt :: proc(label: string, v: ^i32, step: i32, step_fast: i32, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igInputInt(str0, v, step, step_fast, flags);
}

// AUTO_GENERATED for 'igInputInt2'
swr_igInputInt2 :: proc(label: string, v: [^]i32, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igInputInt2(str0, v, flags);
}

// AUTO_GENERATED for 'igInputInt3'
swr_igInputInt3 :: proc(label: string, v: [^]i32, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igInputInt3(str0, v, flags);
}

// AUTO_GENERATED for 'igInputInt4'
swr_igInputInt4 :: proc(label: string, v: [^]i32, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igInputInt4(str0, v, flags);
}

// AUTO_GENERATED for 'igInputScalar'
swr_igInputScalar :: proc(label: string, data_type: Data_Type, p_data: rawptr, p_step: rawptr, p_step_fast: rawptr, format: string, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igInputScalar(str0, data_type, p_data, p_step, p_step_fast, str5, flags);
}

// AUTO_GENERATED for 'igInputScalarN'
swr_igInputScalarN :: proc(label: string, data_type: Data_Type, p_data: rawptr, components: i32, p_step: rawptr, p_step_fast: rawptr, format: string, flags: Input_Text_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str6 := strings.clone_to_cstring(format, context.temp_allocator);
	return igInputScalarN(str0, data_type, p_data, components, p_step, p_step_fast, str6, flags);
}

// PREDEFINED FOR 'igInputText'
wrapper_input_text :: #force_inline proc(label: string, buf: []u8, flags := Input_Text_Flags(0), callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool {
    l := strings.clone_to_cstring(label, context.temp_allocator);
    return igInputText(l, cstring(&buf[0]), uint(len(buf)), flags, callback, user_data);
}

// AUTO_GENERATED for 'igInputTextMultiline'
swr_igInputTextMultiline :: proc(label: string, buf: []u8, buf_size: uint, size: Vec2, flags: Input_Text_Flags, callback: Input_Text_Callback, user_data: rawptr) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	//str1 := strings.clone_to_cstring(buf, context.temp_allocator);
	return igInputTextMultiline(str0, cstring(&buf[0]), buf_size, size, flags, callback, user_data);
}

// AUTO_GENERATED for 'igInputTextWithHint'
swr_igInputTextWithHint :: proc(label: string, hint: string, buf: string, buf_size: uint, flags: Input_Text_Flags, callback: Input_Text_Callback, user_data: rawptr) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str1 := strings.clone_to_cstring(hint, context.temp_allocator);
	str2 := strings.clone_to_cstring(buf, context.temp_allocator);
	return igInputTextWithHint(str0, str1, str2, buf_size, flags, callback, user_data);
}

// AUTO_GENERATED for 'igInvisibleButton'
swr_igInvisibleButton :: proc(str_id: string, size: Vec2, flags: Button_Flags) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igInvisibleButton(str0, size, flags);
}

// AUTO_GENERATED for 'igIsPopupOpen_Str'
swr_igIsPopupOpen_Str :: proc(str_id: string, flags: Popup_Flags) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	return igIsPopupOpen_Str(str0, flags);
}

// AUTO_GENERATED for 'igLabelText'
swr_igLabelText :: proc(label: string, fmt_: string, args: ..any) {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str1 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	igLabelText(str0, str1, args);
}

// AUTO_GENERATED for 'igListBox_Str_arr'
swr_igListBox_Str_arr :: proc(label: string, current_item: ^i32, items: string, items_count: i32, height_in_items: i32) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str2 := strings.clone_to_cstring(items, context.temp_allocator);
	return igListBox_Str_arr(str0, current_item, str2, items_count, height_in_items);
}

// PREDEFINED FOR 'igListBox_FnBoolPtr'
wrapper_list_box_fn_bool_ptr :: proc(label: string, current_item: ^i32, items_getter: Items_Getter_Proc, data: rawptr, items_count: i32, height_in_items := i32(0))-> bool {
    l := strings.clone_to_cstring(label, context.temp_allocator);
    return igListBox_FnBoolPtr(l, current_item, items_getter, data, items_count, height_in_items);
}

// AUTO_GENERATED for 'igLoadIniSettingsFromDisk'
swr_igLoadIniSettingsFromDisk :: proc(ini_filename: string) {
	str0 := strings.clone_to_cstring(ini_filename, context.temp_allocator);
	igLoadIniSettingsFromDisk(str0);
}

// AUTO_GENERATED for 'igLoadIniSettingsFromMemory'
swr_igLoadIniSettingsFromMemory :: proc(ini_data: string, ini_size: uint) {
	str0 := strings.clone_to_cstring(ini_data, context.temp_allocator);
	igLoadIniSettingsFromMemory(str0, ini_size);
}

// AUTO_GENERATED for 'igLogText'
swr_igLogText :: proc(fmt_: string, args: ..any) {
	str0 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	igLogText(str0, args);
}

// AUTO_GENERATED for 'igLogToFile'
swr_igLogToFile :: proc(auto_open_depth: i32, filename: string) {
	str1 := strings.clone_to_cstring(filename, context.temp_allocator);
	igLogToFile(auto_open_depth, str1);
}

// AUTO_GENERATED for 'igMenuItem_Bool'
swr_igMenuItem_Bool :: proc(label: string, shortcut: string, selected: bool, enabled: bool) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str1 := strings.clone_to_cstring(shortcut, context.temp_allocator);
	return igMenuItem_Bool(str0, str1, selected, enabled);
}

// AUTO_GENERATED for 'igMenuItem_BoolPtr'
swr_igMenuItem_BoolPtr :: proc(label: string, shortcut: string, p_selected: ^bool, enabled: bool) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str1 := strings.clone_to_cstring(shortcut, context.temp_allocator);
	return igMenuItem_BoolPtr(str0, str1, p_selected, enabled);
}

// AUTO_GENERATED for 'igOpenPopup'
swr_igOpenPopup :: proc(str_id: string, popup_flags: Popup_Flags) {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	igOpenPopup(str0, popup_flags);
}

// AUTO_GENERATED for 'igOpenPopupOnItemClick'
swr_igOpenPopupOnItemClick :: proc(str_id: string, popup_flags: Popup_Flags) {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	igOpenPopupOnItemClick(str0, popup_flags);
}

// AUTO_GENERATED for 'igPlotHistogram_FloatPtr'
swr_igPlotHistogram_FloatPtr :: proc(label: string, values: ^f32, values_count: i32, values_offset: i32, overlay_text: string, scale_min: f32, scale_max: f32, graph_size: Vec2, stride: i32) {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(overlay_text, context.temp_allocator);
	igPlotHistogram_FloatPtr(str0, values, values_count, values_offset, str4, scale_min, scale_max, graph_size, stride);
}

// PREDEFINED FOR 'igPlotHistogram_FnFloatPtr'
wrapper_plot_histogram_fn_float_ptr :: proc(label: string,
                                      values_getter: Value_Getter_Proc,
                                      data: rawptr,
                                      values_count: i32,
                                      values_offset: i32,
                                      overlay_text: string,
                                      scale_min: f32,
                                      scale_max: f32,
                                      graph_size: Vec2) {
    l := strings.clone_to_cstring(label, context.temp_allocator);
    overlay := strings.clone_to_cstring(overlay_text, context.temp_allocator);
    igPlotHistogram_FnFloatPtr(l, values_getter, data, values_count, values_offset, overlay, scale_min, scale_max, graph_size);
}

// AUTO_GENERATED for 'igPlotLines_FloatPtr'
swr_igPlotLines_FloatPtr :: proc(label: string, values: ^f32, values_count: i32, values_offset: i32, overlay_text: string, scale_min: f32, scale_max: f32, graph_size: Vec2, stride: i32) {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(overlay_text, context.temp_allocator);
	igPlotLines_FloatPtr(str0, values, values_count, values_offset, str4, scale_min, scale_max, graph_size, stride);
}

// PREDEFINED FOR 'igPlotLines_FnFloatPtr'
wrapper_plot_lines_fn_float_ptr :: proc(label: string, 
                                  values_getter: Value_Getter_Proc, 
                                  data: rawptr, 
                                  values_count: i32, 
                                  values_offset: i32, 
                                  overlay_text: string, 
                                  scale_min: f32, 
                                  scale_max: f32, 
                                  graph_size: Vec2) {
    l := strings.clone_to_cstring(label, context.temp_allocator);
    overlay := strings.clone_to_cstring(overlay_text, context.temp_allocator);
    igPlotLines_FnFloatPtr(l, values_getter, data, values_count, values_offset, overlay, scale_min, scale_max, graph_size);
}

// AUTO_GENERATED for 'igProgressBar'
swr_igProgressBar :: proc(fraction: f32, size_arg: Vec2, overlay: string) {
	str2 := strings.clone_to_cstring(overlay, context.temp_allocator);
	igProgressBar(fraction, size_arg, str2);
}

// AUTO_GENERATED for 'igPushID_Str'
swr_igPushID_Str :: proc(str_id: string) {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	igPushID_Str(str0);
}

// AUTO_GENERATED for 'igPushID_StrStr'
swr_igPushID_StrStr :: proc(str_id_begin: string, str_id_end: string) {
	str0 := strings.clone_to_cstring(str_id_begin, context.temp_allocator);
	str1 := strings.clone_to_cstring(str_id_end, context.temp_allocator);
	igPushID_StrStr(str0, str1);
}

// AUTO_GENERATED for 'igRadioButton_Bool'
swr_igRadioButton_Bool :: proc(label: string, active: bool) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igRadioButton_Bool(str0, active);
}

// AUTO_GENERATED for 'igRadioButton_IntPtr'
swr_igRadioButton_IntPtr :: proc(label: string, v: ^i32, v_button: i32) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igRadioButton_IntPtr(str0, v, v_button);
}

// AUTO_GENERATED for 'igSaveIniSettingsToDisk'
swr_igSaveIniSettingsToDisk :: proc(ini_filename: string) {
	str0 := strings.clone_to_cstring(ini_filename, context.temp_allocator);
	igSaveIniSettingsToDisk(str0);
}

// AUTO_GENERATED for 'igSelectable_Bool'
swr_igSelectable_Bool :: proc(label: string, selected: bool, flags: Selectable_Flags, size: Vec2) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igSelectable_Bool(str0, selected, flags, size);
}

// AUTO_GENERATED for 'igSelectable_BoolPtr'
swr_igSelectable_BoolPtr :: proc(label: string, p_selected: ^bool, flags: Selectable_Flags, size: Vec2) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igSelectable_BoolPtr(str0, p_selected, flags, size);
}

// PREDEFINED FOR 'igSetAllocatorFunctions'
wrapper_set_allocator_functions :: #force_inline proc(alloc_func: Alloc_Func, free_func: Free_Func) {
    igSetAllocatorFunctions(alloc_func, free_func);
}

// AUTO_GENERATED for 'igSetClipboardText'
swr_igSetClipboardText :: proc(text: string) {
	str0 := strings.clone_to_cstring(text, context.temp_allocator);
	igSetClipboardText(str0);
}

// AUTO_GENERATED for 'igSetDragDropPayload'
swr_igSetDragDropPayload :: proc(type: string, data: rawptr, sz: uint, cond: Cond) -> bool {
	str0 := strings.clone_to_cstring(type, context.temp_allocator);
	return igSetDragDropPayload(str0, data, sz, cond);
}

// AUTO_GENERATED for 'igSetTabItemClosed'
swr_igSetTabItemClosed :: proc(tab_or_docked_window_label: string) {
	str0 := strings.clone_to_cstring(tab_or_docked_window_label, context.temp_allocator);
	igSetTabItemClosed(str0);
}

// AUTO_GENERATED for 'igSetTooltip'
swr_igSetTooltip :: proc(fmt_: string, args: ..any) {
	str0 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	igSetTooltip(str0, args);
}

// AUTO_GENERATED for 'igSetWindowCollapsed_Str'
swr_igSetWindowCollapsed_Str :: proc(name: string, collapsed: bool, cond: Cond) {
	str0 := strings.clone_to_cstring(name, context.temp_allocator);
	igSetWindowCollapsed_Str(str0, collapsed, cond);
}

// AUTO_GENERATED for 'igSetWindowFocus_Str'
swr_igSetWindowFocus_Str :: proc(name: string) {
	str0 := strings.clone_to_cstring(name, context.temp_allocator);
	igSetWindowFocus_Str(str0);
}

// AUTO_GENERATED for 'igSetWindowPos_Str'
swr_igSetWindowPos_Str :: proc(name: string, pos: Vec2, cond: Cond) {
	str0 := strings.clone_to_cstring(name, context.temp_allocator);
	igSetWindowPos_Str(str0, pos, cond);
}

// AUTO_GENERATED for 'igSetWindowSize_Str'
swr_igSetWindowSize_Str :: proc(name: string, size: Vec2, cond: Cond) {
	str0 := strings.clone_to_cstring(name, context.temp_allocator);
	igSetWindowSize_Str(str0, size, cond);
}

// AUTO_GENERATED for 'igShowFontSelector'
swr_igShowFontSelector :: proc(label: string) {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	igShowFontSelector(str0);
}

// AUTO_GENERATED for 'igShowStyleSelector'
swr_igShowStyleSelector :: proc(label: string) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igShowStyleSelector(str0);
}

// AUTO_GENERATED for 'igSliderAngle'
swr_igSliderAngle :: proc(label: string, v_rad: ^f32, v_degrees_min: f32, v_degrees_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderAngle(str0, v_rad, v_degrees_min, v_degrees_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderFloat'
swr_igSliderFloat :: proc(label: string, v: ^f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderFloat(str0, v, v_min, v_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderFloat2'
swr_igSliderFloat2 :: proc(label: string, v: [^]f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderFloat2(str0, v, v_min, v_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderFloat3'
swr_igSliderFloat3 :: proc(label: string, v: [^]f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderFloat3(str0, v, v_min, v_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderFloat4'
swr_igSliderFloat4 :: proc(label: string, v: [^]f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderFloat4(str0, v, v_min, v_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderInt'
swr_igSliderInt :: proc(label: string, v: ^i32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderInt(str0, v, v_min, v_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderInt2'
swr_igSliderInt2 :: proc(label: string, v: [^]i32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderInt2(str0, v, v_min, v_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderInt3'
swr_igSliderInt3 :: proc(label: string, v: [^]i32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderInt3(str0, v, v_min, v_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderInt4'
swr_igSliderInt4 :: proc(label: string, v: [^]i32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str4 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderInt4(str0, v, v_min, v_max, str4, flags);
}

// AUTO_GENERATED for 'igSliderScalar'
swr_igSliderScalar :: proc(label: string, data_type: Data_Type, p_data: rawptr, p_min: rawptr, p_max: rawptr, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderScalar(str0, data_type, p_data, p_min, p_max, str5, flags);
}

// AUTO_GENERATED for 'igSliderScalarN'
swr_igSliderScalarN :: proc(label: string, data_type: Data_Type, p_data: rawptr, components: i32, p_min: rawptr, p_max: rawptr, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str6 := strings.clone_to_cstring(format, context.temp_allocator);
	return igSliderScalarN(str0, data_type, p_data, components, p_min, p_max, str6, flags);
}

// AUTO_GENERATED for 'igSmallButton'
swr_igSmallButton :: proc(label: string) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igSmallButton(str0);
}

// AUTO_GENERATED for 'igTabItemButton'
swr_igTabItemButton :: proc(label: string, flags: Tab_Item_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igTabItemButton(str0, flags);
}

// AUTO_GENERATED for 'igTableHeader'
swr_igTableHeader :: proc(label: string) {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	igTableHeader(str0);
}

// AUTO_GENERATED for 'igTableSetupColumn'
swr_igTableSetupColumn :: proc(label: string, flags: Table_Column_Flags, init_width_or_weight: f32, user_id: ImID) {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	igTableSetupColumn(str0, flags, init_width_or_weight, user_id);
}

// PREDEFINED FOR 'igText'
wrapper_text :: proc(fmt_: string, args: ..any) {
    fmt_str := fmt.tprintf("{}\x00", fmt_);
    str := transmute([]byte)fmt.tprintf(fmt_str, ..args);
    igTextUnformatted(cstring(&str[0]), cstring(&str[len(str)-1]));
}

// PREDEFINED FOR 'igTextColored'
wrapper_text_colored :: proc(col: Vec4, fmt_: string, args: ..any) {
    fmt_str := fmt.tprintf("{}\x00", fmt_);
    str := transmute([]byte)fmt.tprintf(fmt_str, ..args);
    igTextColored(col, cstring(&str[0]), nil);
}

// PREDEFINED FOR 'igTextDisabled'
wrapper_text_disabled :: proc(fmt_: string, args: ..any) {
    fmt_str := fmt.tprintf("{}\x00", fmt_);
    str := transmute([]byte)fmt.tprintf(fmt_str, ..args);
    igTextDisabled(cstring(&str[0]), nil);
}

// PREDEFINED FOR 'igTextUnformatted'
wrapper_unformatted_text :: proc(text: string) {
    t := strings.clone_to_cstring(text, context.temp_allocator);
    ptr := transmute(^u8)t;
    end_ptr := mem.ptr_offset(ptr, len(t));
    igTextUnformatted(cstring(ptr), cstring(end_ptr));
}

// PREDEFINED FOR 'igTextWrapped'
wrapper_text_wrapped :: proc(fmt_: string, args: ..any) {
    fmt_str := fmt.tprintf("{}\x00", fmt_);
    str := transmute([]byte)fmt.tprintf(fmt_str, ..args);
    igTextWrapped(cstring(&str[0]), nil);
}

// AUTO_GENERATED for 'igTreeNode_Str'
swr_igTreeNode_Str :: proc(label: string) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igTreeNode_Str(str0);
}

// AUTO_GENERATED for 'igTreeNode_StrStr'
swr_igTreeNode_StrStr :: proc(str_id: string, fmt_: string, args: ..any) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	str1 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	return igTreeNode_StrStr(str0, str1, args);
}

// AUTO_GENERATED for 'igTreeNode_Ptr'
swr_igTreeNode_Ptr :: proc(ptr_id: rawptr, fmt_: string, args: ..any) -> bool {
	str1 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	return igTreeNode_Ptr(ptr_id, str1, args);
}

// AUTO_GENERATED for 'igTreeNodeEx_Str'
swr_igTreeNodeEx_Str :: proc(label: string, flags: Tree_Node_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	return igTreeNodeEx_Str(str0, flags);
}

// AUTO_GENERATED for 'igTreeNodeEx_StrStr'
swr_igTreeNodeEx_StrStr :: proc(str_id: string, flags: Tree_Node_Flags, fmt_: string, args: ..any) -> bool {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	str2 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	return igTreeNodeEx_StrStr(str0, flags, str2, args);
}

// AUTO_GENERATED for 'igTreeNodeEx_Ptr'
swr_igTreeNodeEx_Ptr :: proc(ptr_id: rawptr, flags: Tree_Node_Flags, fmt_: string, args: ..any) -> bool {
	str2 := strings.clone_to_cstring(fmt_, context.temp_allocator);
	return igTreeNodeEx_Ptr(ptr_id, flags, str2, args);
}

// AUTO_GENERATED for 'igTreePush_Str'
swr_igTreePush_Str :: proc(str_id: string) {
	str0 := strings.clone_to_cstring(str_id, context.temp_allocator);
	igTreePush_Str(str0);
}

// AUTO_GENERATED for 'igVSliderFloat'
swr_igVSliderFloat :: proc(label: string, size: Vec2, v: ^f32, v_min: f32, v_max: f32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igVSliderFloat(str0, size, v, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igVSliderInt'
swr_igVSliderInt :: proc(label: string, size: Vec2, v: ^i32, v_min: i32, v_max: i32, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str5 := strings.clone_to_cstring(format, context.temp_allocator);
	return igVSliderInt(str0, size, v, v_min, v_max, str5, flags);
}

// AUTO_GENERATED for 'igVSliderScalar'
swr_igVSliderScalar :: proc(label: string, size: Vec2, data_type: Data_Type, p_data: rawptr, p_min: rawptr, p_max: rawptr, format: string, flags: Slider_Flags) -> bool {
	str0 := strings.clone_to_cstring(label, context.temp_allocator);
	str6 := strings.clone_to_cstring(format, context.temp_allocator);
	return igVSliderScalar(str0, size, data_type, p_data, p_min, p_max, str6, flags);
}

// AUTO_GENERATED for 'igValue_Bool'
swr_igValue_Bool :: proc(prefix: string, b: bool) {
	str0 := strings.clone_to_cstring(prefix, context.temp_allocator);
	igValue_Bool(str0, b);
}

// AUTO_GENERATED for 'igValue_Int'
swr_igValue_Int :: proc(prefix: string, v: i32) {
	str0 := strings.clone_to_cstring(prefix, context.temp_allocator);
	igValue_Int(str0, v);
}

// AUTO_GENERATED for 'igValue_Uint'
swr_igValue_Uint :: proc(prefix: string, v: u32) {
	str0 := strings.clone_to_cstring(prefix, context.temp_allocator);
	igValue_Uint(str0, v);
}

// AUTO_GENERATED for 'igValue_Float'
swr_igValue_Float :: proc(prefix: string, v: f32, float_format: string) {
	str0 := strings.clone_to_cstring(prefix, context.temp_allocator);
	str2 := strings.clone_to_cstring(float_format, context.temp_allocator);
	igValue_Float(str0, v, str2);
}


