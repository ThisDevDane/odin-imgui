package imgui;

when ODIN_DEBUG {
    foreign import cimgui "external/cimgui_debug.lib";
} else {
    foreign import "external/cimgui.lib";
}

color_hsv     :: inline proc(self : ^Color, h : f32, s : f32, v : f32, a : f32 = 1.0) -> Color do return ImColor_HSV(self, h, s, v, a);
color_set_hsv :: inline proc(self : ^Color, h : f32, s : f32, v : f32, a : f32 = 1.0) do ImColor_SetHSV(self, h, s, v, a);


draw_data_clear                :: inline proc(self : ^Draw_Data) do ImDrawData_Clear(self);
draw_data_de_index_all_buffers :: inline proc(self : ^Draw_Data) do ImDrawData_DeIndexAllBuffers(self);
draw_data_scale_clip_rects     :: inline proc(self : ^Draw_Data, fb_scale : Vec2) do ImDrawData_ScaleClipRects(self, fb_scale);


draw_list_splitter_clear               :: inline proc(self : ^Draw_List_Splitter) do ImDrawListSplitter_Clear(self);
draw_list_splitter_clear_free_memory   :: inline proc(self : ^Draw_List_Splitter) do ImDrawListSplitter_ClearFreeMemory(self);
draw_list_splitter_merge               :: inline proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List) do ImDrawListSplitter_Merge(self, draw_list);
draw_list_splitter_set_current_channel :: inline proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List, channel_idx : i32) do ImDrawListSplitter_SetCurrentChannel(self, draw_list, channel_idx);
draw_list_splitter_split               :: inline proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List, count : i32) do ImDrawListSplitter_Split(self, draw_list, count);


draw_list_add_bezier_curve             :: inline proc(self : ^Draw_List, pos0 : Vec2, cp0 : Vec2, cp1 : Vec2, pos1 : Vec2, col : u32, thickness : f32, num_segments : i32 = 0) do ImDrawList_AddBezierCurve(self, pos0, cp0, cp1, pos1, col, thickness, num_segments);
draw_list_add_callback                 :: inline proc(self : ^Draw_List, callback : Draw_Callback, callback_data : rawptr) do ImDrawList_AddCallback(self, callback, callback_data);
draw_list_add_circle                   :: inline proc(self : ^Draw_List, center : Vec2, radius : f32, col : u32, num_segments : i32 = 12, thickness : f32 = 1.0) do ImDrawList_AddCircle(self, center, radius, col, num_segments, thickness);
draw_list_add_circle_filled            :: inline proc(self : ^Draw_List, center : Vec2, radius : f32, col : u32, num_segments : i32 = 12) do ImDrawList_AddCircleFilled(self, center, radius, col, num_segments);
draw_list_add_convex_poly_filled       :: inline proc(self : ^Draw_List, points : ^Vec2, num_points : i32, col : u32) do ImDrawList_AddConvexPolyFilled(self, points, num_points, col);
draw_list_add_draw_cmd                 :: inline proc(self : ^Draw_List) do ImDrawList_AddDrawCmd(self);
draw_list_add_image                    :: inline proc(self : ^Draw_List, user_texture_id : Texture_ID, p_min : Vec2, p_max : Vec2, uv_min := Vec2{0,0}, uv_max := Vec2{1,1}, col : u32 = 0xffffffff) do ImDrawList_AddImage(self, user_texture_id, p_min, p_max, uv_min, uv_max, col);
draw_list_add_image_quad               :: inline proc(self : ^Draw_List, user_texture_id : Texture_ID, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, uv1 := Vec2{0,0}, uv2 := Vec2{1,0}, uv3 := Vec2{1,1}, uv4 := Vec2{0,1}, col : u32 = 0xffffffff) do ImDrawList_AddImageQuad(self, user_texture_id, p1, p2, p3, p4, uv1, uv2, uv3, uv4, col);
draw_list_add_image_rounded            :: inline proc(self : ^Draw_List, user_texture_id : Texture_ID, p_min : Vec2, p_max : Vec2, uv_min : Vec2, uv_max : Vec2, col : u32, rounding : f32, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) do ImDrawList_AddImageRounded(self, user_texture_id, p_min, p_max, uv_min, uv_max, col, rounding, rounding_corners);
draw_list_add_line                     :: inline proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, col : u32, thickness : f32 = 1.0) do ImDrawList_AddLine(self, p1, p2, col, thickness);
draw_list_add_polyline                 :: inline proc(self : ^Draw_List, points : ^Vec2, num_points : i32, col : u32, closed : bool, thickness : f32) do ImDrawList_AddPolyline(self, points, num_points, col, closed, thickness);
draw_list_add_quad                     :: inline proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, col : u32, thickness : f32 = 1.0) do ImDrawList_AddQuad(self, p1, p2, p3, p4, col, thickness);
draw_list_add_quad_filled              :: inline proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, col : u32) do ImDrawList_AddQuadFilled(self, p1, p2, p3, p4, col);
draw_list_add_rect                     :: inline proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col : u32, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All, thickness : f32 = 1.0) do ImDrawList_AddRect(self, p_min, p_max, col, rounding, rounding_corners, thickness);
draw_list_add_rect_filled              :: inline proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col : u32, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) do ImDrawList_AddRectFilled(self, p_min, p_max, col, rounding, rounding_corners);
draw_list_add_rect_filled_multi_color  :: inline proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32) do ImDrawList_AddRectFilledMultiColor(self, p_min, p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left);
draw_list_add_text                     :: inline proc(self : ^Draw_List, pos : Vec2, col : u32, text_begin : cstring, text_end : cstring = nil) do ImDrawList_AddText(self, pos, col, text_begin, text_end);
draw_list_add_text                     :: inline proc(self : ^Draw_List, font : ^Font, font_size : f32, pos : Vec2, col : u32, text_begin : cstring, text_end : cstring = nil, wrap_width : f32 = 0.0, cpu_fine_clip_rect : ^Vec4 = nil) do ImDrawList_AddTextFontPtr(self, font, font_size, pos, col, text_begin, text_end, wrap_width, cpu_fine_clip_rect);
draw_list_add_triangle                 :: inline proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, col : u32, thickness : f32 = 1.0) do ImDrawList_AddTriangle(self, p1, p2, p3, col, thickness);
draw_list_add_triangle_filled          :: inline proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, col : u32) do ImDrawList_AddTriangleFilled(self, p1, p2, p3, col);
draw_list_channels_merge               :: inline proc(self : ^Draw_List) do ImDrawList_ChannelsMerge(self);
draw_list_channels_set_current         :: inline proc(self : ^Draw_List, n : i32) do ImDrawList_ChannelsSetCurrent(self, n);
draw_list_channels_split               :: inline proc(self : ^Draw_List, count : i32) do ImDrawList_ChannelsSplit(self, count);
draw_list_clear                        :: inline proc(self : ^Draw_List) do ImDrawList_Clear(self);
draw_list_clear_free_memory            :: inline proc(self : ^Draw_List) do ImDrawList_ClearFreeMemory(self);
draw_list_clone_output                 :: inline proc(self : ^Draw_List) -> ^Draw_List do return ImDrawList_CloneOutput(self);
draw_list_get_clip_rect_max            :: inline proc(self : ^Draw_List) -> Vec2 do return ImDrawList_GetClipRectMax(self);
draw_list_get_clip_rect_min            :: inline proc(self : ^Draw_List) -> Vec2 do return ImDrawList_GetClipRectMin(self);
draw_list_path_arc_to                  :: inline proc(self : ^Draw_List, center : Vec2, radius : f32, a_min : f32, a_max : f32, num_segments : i32 = 10) do ImDrawList_PathArcTo(self, center, radius, a_min, a_max, num_segments);
draw_list_path_arc_to_fast             :: inline proc(self : ^Draw_List, center : Vec2, radius : f32, a_min_of_12 : i32, a_max_of_12 : i32) do ImDrawList_PathArcToFast(self, center, radius, a_min_of_12, a_max_of_12);
draw_list_path_bezier_curve_to         :: inline proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, num_segments : i32 = 0) do ImDrawList_PathBezierCurveTo(self, p1, p2, p3, num_segments);
draw_list_path_clear                   :: inline proc(self : ^Draw_List) do ImDrawList_PathClear(self);
draw_list_path_fill_convex             :: inline proc(self : ^Draw_List, col : u32) do ImDrawList_PathFillConvex(self, col);
draw_list_path_line_to                 :: inline proc(self : ^Draw_List, pos : Vec2) do ImDrawList_PathLineTo(self, pos);
draw_list_path_line_to_merge_duplicate :: inline proc(self : ^Draw_List, pos : Vec2) do ImDrawList_PathLineToMergeDuplicate(self, pos);
draw_list_path_rect                    :: inline proc(self : ^Draw_List, rect_min : Vec2, rect_max : Vec2, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) do ImDrawList_PathRect(self, rect_min, rect_max, rounding, rounding_corners);
draw_list_path_stroke                  :: inline proc(self : ^Draw_List, col : u32, closed : bool, thickness : f32 = 1.0) do ImDrawList_PathStroke(self, col, closed, thickness);
draw_list_pop_clip_rect                :: inline proc(self : ^Draw_List) do ImDrawList_PopClipRect(self);
draw_list_pop_texture_id               :: inline proc(self : ^Draw_List) do ImDrawList_PopTextureID(self);
draw_list_prim_quad_uv                 :: inline proc(self : ^Draw_List, a : Vec2, b : Vec2, c : Vec2, d : Vec2, uv_a : Vec2, uv_b : Vec2, uv_c : Vec2, uv_d : Vec2, col : u32) do ImDrawList_PrimQuadUV(self, a, b, c, d, uv_a, uv_b, uv_c, uv_d, col);
draw_list_prim_rect                    :: inline proc(self : ^Draw_List, a : Vec2, b : Vec2, col : u32) do ImDrawList_PrimRect(self, a, b, col);
draw_list_prim_rect_uv                 :: inline proc(self : ^Draw_List, a : Vec2, b : Vec2, uv_a : Vec2, uv_b : Vec2, col : u32) do ImDrawList_PrimRectUV(self, a, b, uv_a, uv_b, col);
draw_list_prim_reserve                 :: inline proc(self : ^Draw_List, idx_count : i32, vtx_count : i32) do ImDrawList_PrimReserve(self, idx_count, vtx_count);
draw_list_prim_vtx                     :: inline proc(self : ^Draw_List, pos : Vec2, uv : Vec2, col : u32) do ImDrawList_PrimVtx(self, pos, uv, col);
draw_list_prim_write_idx               :: inline proc(self : ^Draw_List, idx : Draw_Idx) do ImDrawList_PrimWriteIdx(self, idx);
draw_list_prim_write_vtx               :: inline proc(self : ^Draw_List, pos : Vec2, uv : Vec2, col : u32) do ImDrawList_PrimWriteVtx(self, pos, uv, col);
draw_list_push_clip_rect               :: inline proc(self : ^Draw_List, clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool = false) do ImDrawList_PushClipRect(self, clip_rect_min, clip_rect_max, intersect_with_current_clip_rect);
draw_list_push_clip_rect_full_screen   :: inline proc(self : ^Draw_List) do ImDrawList_PushClipRectFullScreen(self);
draw_list_push_texture_id              :: inline proc(self : ^Draw_List, texture_id : Texture_ID) do ImDrawList_PushTextureID(self, texture_id);
draw_list_update_clip_rect             :: inline proc(self : ^Draw_List) do ImDrawList_UpdateClipRect(self);
draw_list_update_texture_id            :: inline proc(self : ^Draw_List) do ImDrawList_UpdateTextureID(self);


font_atlas_custom_rect_is_packed :: inline proc(self : ^Font_Atlas_Custom_Rect) -> bool do return ImFontAtlasCustomRect_IsPacked(self);


font_atlas_add_custom_rect_font_glyph                  :: inline proc(self : ^Font_Atlas, font : ^Font, id : Wchar, width : i32, height : i32, advance_x : f32, offset := Vec2{0,0}) -> i32 do return ImFontAtlas_AddCustomRectFontGlyph(self, font, id, width, height, advance_x, offset);
font_atlas_add_custom_rect_regular                     :: inline proc(self : ^Font_Atlas, id : u32, width : i32, height : i32) -> i32 do return ImFontAtlas_AddCustomRectRegular(self, id, width, height);
font_atlas_add_font                                    :: inline proc(self : ^Font_Atlas, font_cfg : ^Font_Config) -> ^Font do return ImFontAtlas_AddFont(self, font_cfg);
font_atlas_add_font_default                            :: inline proc(self : ^Font_Atlas, font_cfg : ^Font_Config = nil) -> ^Font do return ImFontAtlas_AddFontDefault(self, font_cfg);
font_atlas_add_font_from_file_ttf                      :: inline proc(self : ^Font_Atlas, filename : cstring, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font do return ImFontAtlas_AddFontFromFileTTF(self, filename, size_pixels, font_cfg, glyph_ranges);
font_atlas_add_font_from_memory_compressed_base_85_ttf :: inline proc(self : ^Font_Atlas, compressed_font_data_base85 : cstring, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font do return ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(self, compressed_font_data_base85, size_pixels, font_cfg, glyph_ranges);
font_atlas_add_font_from_memory_compressed_ttf         :: inline proc(self : ^Font_Atlas, compressed_font_data : rawptr, compressed_font_size : i32, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font do return ImFontAtlas_AddFontFromMemoryCompressedTTF(self, compressed_font_data, compressed_font_size, size_pixels, font_cfg, glyph_ranges);
font_atlas_add_font_from_memory_ttf                    :: inline proc(self : ^Font_Atlas, font_data : rawptr, font_size : i32, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font do return ImFontAtlas_AddFontFromMemoryTTF(self, font_data, font_size, size_pixels, font_cfg, glyph_ranges);
font_atlas_build                                       :: inline proc(self : ^Font_Atlas) -> bool do return ImFontAtlas_Build(self);
font_atlas_calc_custom_rect_uv                         :: inline proc(self : ^Font_Atlas, rect : ^Font_Atlas_Custom_Rect, out_uv_min : ^Vec2, out_uv_max : ^Vec2) do ImFontAtlas_CalcCustomRectUV(self, rect, out_uv_min, out_uv_max);
font_atlas_clear                                       :: inline proc(self : ^Font_Atlas) do ImFontAtlas_Clear(self);
font_atlas_clear_fonts                                 :: inline proc(self : ^Font_Atlas) do ImFontAtlas_ClearFonts(self);
font_atlas_clear_input_data                            :: inline proc(self : ^Font_Atlas) do ImFontAtlas_ClearInputData(self);
font_atlas_clear_tex_data                              :: inline proc(self : ^Font_Atlas) do ImFontAtlas_ClearTexData(self);
font_atlas_get_custom_rect_by_index                    :: inline proc(self : ^Font_Atlas, index : i32) -> ^Font_Atlas_Custom_Rect do return ImFontAtlas_GetCustomRectByIndex(self, index);
font_atlas_get_glyph_ranges_chinese_full               :: inline proc(self : ^Font_Atlas) -> ^Wchar do return ImFontAtlas_GetGlyphRangesChineseFull(self);
font_atlas_get_glyph_ranges_chinese_simplified_common  :: inline proc(self : ^Font_Atlas) -> ^Wchar do return ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon(self);
font_atlas_get_glyph_ranges_cyrillic                   :: inline proc(self : ^Font_Atlas) -> ^Wchar do return ImFontAtlas_GetGlyphRangesCyrillic(self);
font_atlas_get_glyph_ranges_default                    :: inline proc(self : ^Font_Atlas) -> ^Wchar do return ImFontAtlas_GetGlyphRangesDefault(self);
font_atlas_get_glyph_ranges_japanese                   :: inline proc(self : ^Font_Atlas) -> ^Wchar do return ImFontAtlas_GetGlyphRangesJapanese(self);
font_atlas_get_glyph_ranges_korean                     :: inline proc(self : ^Font_Atlas) -> ^Wchar do return ImFontAtlas_GetGlyphRangesKorean(self);
font_atlas_get_glyph_ranges_thai                       :: inline proc(self : ^Font_Atlas) -> ^Wchar do return ImFontAtlas_GetGlyphRangesThai(self);
font_atlas_get_glyph_ranges_vietnamese                 :: inline proc(self : ^Font_Atlas) -> ^Wchar do return ImFontAtlas_GetGlyphRangesVietnamese(self);
font_atlas_get_mouse_cursor_tex_data                   :: inline proc(self : ^Font_Atlas, cursor : Mouse_Cursor, out_offset : ^Vec2, out_size : ^Vec2, out_uv_border : [2]Vec2, out_uv_fill : [2]Vec2) -> bool do return ImFontAtlas_GetMouseCursorTexData(self, cursor, out_offset, out_size, out_uv_border, out_uv_fill);
font_atlas_get_tex_data_as_alpha_8                     :: inline proc(self : ^Font_Atlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) do ImFontAtlas_GetTexDataAsAlpha8(self, out_pixels, out_width, out_height, out_bytes_per_pixel);
font_atlas_get_tex_data_as_rgba_32                     :: inline proc(self : ^Font_Atlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) do ImFontAtlas_GetTexDataAsRGBA32(self, out_pixels, out_width, out_height, out_bytes_per_pixel);
font_atlas_is_built                                    :: inline proc(self : ^Font_Atlas) -> bool do return ImFontAtlas_IsBuilt(self);
font_atlas_set_tex_id                                  :: inline proc(self : ^Font_Atlas, id : Texture_ID) do ImFontAtlas_SetTexID(self, id);


font_glyph_ranges_builder_add_char     :: inline proc(self : ^Font_Glyph_Ranges_Builder, c : Wchar) do ImFontGlyphRangesBuilder_AddChar(self, c);
font_glyph_ranges_builder_add_ranges   :: inline proc(self : ^Font_Glyph_Ranges_Builder, ranges : ^Wchar) do ImFontGlyphRangesBuilder_AddRanges(self, ranges);
font_glyph_ranges_builder_add_text     :: inline proc(self : ^Font_Glyph_Ranges_Builder, text : cstring, text_end : cstring = nil) do ImFontGlyphRangesBuilder_AddText(self, text, text_end);
font_glyph_ranges_builder_build_ranges :: inline proc(self : ^Font_Glyph_Ranges_Builder, out_ranges : ^Im_Vector(Wchar)) do ImFontGlyphRangesBuilder_BuildRanges(self, out_ranges);
font_glyph_ranges_builder_clear        :: inline proc(self : ^Font_Glyph_Ranges_Builder) do ImFontGlyphRangesBuilder_Clear(self);
font_glyph_ranges_builder_get_bit      :: inline proc(self : ^Font_Glyph_Ranges_Builder, n : i32) -> bool do return ImFontGlyphRangesBuilder_GetBit(self, n);
font_glyph_ranges_builder_set_bit      :: inline proc(self : ^Font_Glyph_Ranges_Builder, n : i32) do ImFontGlyphRangesBuilder_SetBit(self, n);


font_add_glyph                 :: inline proc(self : ^Font, c : Wchar, x0 : f32, y0 : f32, x1 : f32, y1 : f32, u0 : f32, v0 : f32, u1 : f32, v1 : f32, advance_x : f32) do ImFont_AddGlyph(self, c, x0, y0, x1, y1, u0, v0, u1, v1, advance_x);
font_add_remap_char            :: inline proc(self : ^Font, dst : Wchar, src : Wchar, overwrite_dst : bool = true) do ImFont_AddRemapChar(self, dst, src, overwrite_dst);
font_build_lookup_table        :: inline proc(self : ^Font) do ImFont_BuildLookupTable(self);
font_calc_text_size_a          :: inline proc(self : ^Font, size : f32, max_width : f32, wrap_width : f32, text_begin : cstring, text_end : cstring = nil, remaining : ^^i8 = nil) -> Vec2 do return ImFont_CalcTextSizeA(self, size, max_width, wrap_width, text_begin, text_end, remaining);
font_calc_word_wrap_position_a :: inline proc(self : ^Font, scale : f32, text : cstring, text_end : cstring, wrap_width : f32) -> cstring do return ImFont_CalcWordWrapPositionA(self, scale, text, text_end, wrap_width);
font_clear_output_data         :: inline proc(self : ^Font) do ImFont_ClearOutputData(self);
font_find_glyph                :: inline proc(self : ^Font, c : Wchar) -> ^Font_Glyph do return ImFont_FindGlyph(self, c);
font_find_glyph_no_fallback    :: inline proc(self : ^Font, c : Wchar) -> ^Font_Glyph do return ImFont_FindGlyphNoFallback(self, c);
font_get_char_advance          :: inline proc(self : ^Font, c : Wchar) -> f32 do return ImFont_GetCharAdvance(self, c);
font_get_debug_name            :: inline proc(self : ^Font) -> cstring do return ImFont_GetDebugName(self);
font_grow_index                :: inline proc(self : ^Font, new_size : i32) do ImFont_GrowIndex(self, new_size);
font_is_loaded                 :: inline proc(self : ^Font) -> bool do return ImFont_IsLoaded(self);
font_render_char               :: inline proc(self : ^Font, draw_list : ^Draw_List, size : f32, pos : Vec2, col : u32, c : Wchar) do ImFont_RenderChar(self, draw_list, size, pos, col, c);
font_render_text               :: inline proc(self : ^Font, draw_list : ^Draw_List, size : f32, pos : Vec2, col : u32, clip_rect : Vec4, text_begin : cstring, text_end : cstring, wrap_width : f32 = 0.0, cpu_fine_clip : bool = false) do ImFont_RenderText(self, draw_list, size, pos, col, clip_rect, text_begin, text_end, wrap_width, cpu_fine_clip);
font_set_fallback_char         :: inline proc(self : ^Font, c : Wchar) do ImFont_SetFallbackChar(self, c);


io_add_input_character        :: inline proc(self : ^io, c : u32) do ImGuiIO_AddInputCharacter(self, c);
io_add_input_characters_utf_8 :: inline proc(self : ^io, str : cstring) do ImGuiIO_AddInputCharactersUTF8(self, str);
io_clear_input_characters     :: inline proc(self : ^io) do ImGuiIO_ClearInputCharacters(self);


input_text_callback_data_delete_chars  :: inline proc(self : ^Input_Text_Callback_Data, pos : i32, bytes_count : i32) do ImGuiInputTextCallbackData_DeleteChars(self, pos, bytes_count);
input_text_callback_data_has_selection :: inline proc(self : ^Input_Text_Callback_Data) -> bool do return ImGuiInputTextCallbackData_HasSelection(self);
input_text_callback_data_insert_chars  :: inline proc(self : ^Input_Text_Callback_Data, pos : i32, text : cstring, text_end : cstring = nil) do ImGuiInputTextCallbackData_InsertChars(self, pos, text, text_end);


list_clipper_begin :: inline proc(self : ^List_Clipper, items_count : i32, items_height : f32 = -1.0) do ImGuiListClipper_Begin(self, items_count, items_height);
list_clipper_end   :: inline proc(self : ^List_Clipper) do ImGuiListClipper_End(self);
list_clipper_step  :: inline proc(self : ^List_Clipper) -> bool do return ImGuiListClipper_Step(self);


payload_clear        :: inline proc(self : ^Payload) do ImGuiPayload_Clear(self);
payload_is_data_type :: inline proc(self : ^Payload, type : cstring) -> bool do return ImGuiPayload_IsDataType(self, type);
payload_is_delivery  :: inline proc(self : ^Payload) -> bool do return ImGuiPayload_IsDelivery(self);
payload_is_preview   :: inline proc(self : ^Payload) -> bool do return ImGuiPayload_IsPreview(self);


storage_build_sort_by_key :: inline proc(self : ^Storage) do ImGuiStorage_BuildSortByKey(self);
storage_clear             :: inline proc(self : ^Storage) do ImGuiStorage_Clear(self);
storage_get_bool          :: inline proc(self : ^Storage, key : ID, default_val : bool = false) -> bool do return ImGuiStorage_GetBool(self, key, default_val);
storage_get_bool_ref      :: inline proc(self : ^Storage, key : ID, default_val : bool = false) -> ^bool do return ImGuiStorage_GetBoolRef(self, key, default_val);
storage_get_float         :: inline proc(self : ^Storage, key : ID, default_val : f32 = 0.0) -> f32 do return ImGuiStorage_GetFloat(self, key, default_val);
storage_get_float_ref     :: inline proc(self : ^Storage, key : ID, default_val : f32 = 0.0) -> ^f32 do return ImGuiStorage_GetFloatRef(self, key, default_val);
storage_get_int           :: inline proc(self : ^Storage, key : ID, default_val : i32 = 0) -> i32 do return ImGuiStorage_GetInt(self, key, default_val);
storage_get_int_ref       :: inline proc(self : ^Storage, key : ID, default_val : i32 = 0) -> ^i32 do return ImGuiStorage_GetIntRef(self, key, default_val);
storage_get_void_ptr      :: inline proc(self : ^Storage, key : ID) -> rawptr do return ImGuiStorage_GetVoidPtr(self, key);
storage_get_void_ptr_ref  :: inline proc(self : ^Storage, key : ID, default_val : rawptr = nil) -> ^^oid do return ImGuiStorage_GetVoidPtrRef(self, key, default_val);
storage_set_all_int       :: inline proc(self : ^Storage, val : i32) do ImGuiStorage_SetAllInt(self, val);
storage_set_bool          :: inline proc(self : ^Storage, key : ID, val : bool) do ImGuiStorage_SetBool(self, key, val);
storage_set_float         :: inline proc(self : ^Storage, key : ID, val : f32) do ImGuiStorage_SetFloat(self, key, val);
storage_set_int           :: inline proc(self : ^Storage, key : ID, val : i32) do ImGuiStorage_SetInt(self, key, val);
storage_set_void_ptr      :: inline proc(self : ^Storage, key : ID, val : rawptr) do ImGuiStorage_SetVoidPtr(self, key, val);


style_scale_all_sizes :: inline proc(self : ^Style, scale_factor : f32) do ImGuiStyle_ScaleAllSizes(self, scale_factor);


text_buffer_append  :: inline proc(self : ^Text_Buffer, str : cstring, str_end : cstring = nil) do ImGuiTextBuffer_append(self, str, str_end);
text_buffer_appendf :: inline proc(self : ^Text_Buffer, format : cstring, #c_vararg args : ..any) do ImGuiTextBuffer_appendf(self, format, args);
text_buffer_begin   :: inline proc(self : ^Text_Buffer) -> cstring do return ImGuiTextBuffer_begin(self);
text_buffer_c_str   :: inline proc(self : ^Text_Buffer) -> cstring do return ImGuiTextBuffer_c_str(self);
text_buffer_clear   :: inline proc(self : ^Text_Buffer) do ImGuiTextBuffer_clear(self);
text_buffer_empty   :: inline proc(self : ^Text_Buffer) -> bool do return ImGuiTextBuffer_empty(self);
text_buffer_end     :: inline proc(self : ^Text_Buffer) -> cstring do return ImGuiTextBuffer_end(self);
text_buffer_reserve :: inline proc(self : ^Text_Buffer, capacity : i32) do ImGuiTextBuffer_reserve(self, capacity);
text_buffer_size    :: inline proc(self : ^Text_Buffer) -> i32 do return ImGuiTextBuffer_size(self);


text_filter_build       :: inline proc(self : ^Text_Filter) do ImGuiTextFilter_Build(self);
text_filter_clear       :: inline proc(self : ^Text_Filter) do ImGuiTextFilter_Clear(self);
text_filter_draw        :: inline proc(self : ^Text_Filter, label := "Filter{inc,-exc}", width : f32 = 0.0) -> bool do return ImGuiTextFilter_Draw(self, label, width);
text_filter_is_active   :: inline proc(self : ^Text_Filter) -> bool do return ImGuiTextFilter_IsActive(self);
text_filter_pass_filter :: inline proc(self : ^Text_Filter, text : cstring, text_end : cstring = nil) -> bool do return ImGuiTextFilter_PassFilter(self, text, text_end);


text_range_empty :: inline proc(self : ^Text_Range) -> bool do return ImGuiTextRange_empty(self);
text_range_split :: inline proc(self : ^Text_Range, separator : i8, out : ^Im_Vector(Text_Range)) do ImGuiTextRange_split(self, separator, out);


accept_drag_drop_payload               :: inline proc(type : cstring, flags : Drag_Drop_Flags = 0) -> ^Payload do return igAcceptDragDropPayload(type, flags);
align_text_to_frame_padding            :: inline proc() do igAlignTextToFramePadding();
arrow_button                           :: inline proc(str_id : string, dir : Dir) -> bool do return ig_arrow_button(_make_label_string(str_id), dir);
begin                                  :: inline proc(name : string, p_open : ^bool = nil, flags : Window_Flags = 0) -> bool do return ig_begin(_make_label_string(name), p_open, flags);
begin_child                            :: inline proc(str_id : string, size := Vec2{0,0}, border : bool = false, flags : Window_Flags = 0) -> bool do return ig_begin_child(_make_label_string(str_id), size, border, flags);
begin_child                            :: inline proc(id : ID, size := Vec2{0,0}, border : bool = false, flags : Window_Flags = 0) -> bool do return igBeginChildID(id, size, border, flags);
begin_child_frame                      :: inline proc(id : ID, size : Vec2, flags : Window_Flags = 0) -> bool do return igBeginChildFrame(id, size, flags);
// WRAPPER UNDER HERE 
begin_combo                            :: inline proc(label : string, preview : string, flags : Combo_Flags = 0) -> bool do return wrapper_begin_combo(label, preview, flags);
begin_drag_drop_source                 :: inline proc(flags : Drag_Drop_Flags = 0) -> bool do return igBeginDragDropSource(flags);
begin_drag_drop_target                 :: inline proc() -> bool do return igBeginDragDropTarget();
begin_group                            :: inline proc() do igBeginGroup();
begin_main_menu_bar                    :: inline proc() -> bool do return igBeginMainMenuBar();
begin_menu                             :: inline proc(label : string, enabled : bool = true) -> bool do return ig_begin_menu(_make_label_string(label), enabled);
begin_menu_bar                         :: inline proc() -> bool do return igBeginMenuBar();
begin_popup                            :: inline proc(str_id : string, flags : Window_Flags = 0) -> bool do return ig_begin_popup(_make_label_string(str_id), flags);
begin_popup_context_item               :: inline proc(str_id : string, mouse_button : i32 = 1) -> bool do return ig_begin_popup_context_item(_make_label_string(str_id), mouse_button);
begin_popup_context_void               :: inline proc(str_id : string, mouse_button : i32 = 1) -> bool do return ig_begin_popup_context_void(_make_label_string(str_id), mouse_button);
begin_popup_context_window             :: inline proc(str_id : string, mouse_button : i32 = 1, also_over_items : bool = true) -> bool do return ig_begin_popup_context_window(_make_label_string(str_id), mouse_button, also_over_items);
begin_popup_modal                      :: inline proc(name : string, p_open : ^bool = nil, flags : Window_Flags = 0) -> bool do return ig_begin_popup_modal(_make_label_string(name), p_open, flags);
begin_tab_bar                          :: inline proc(str_id : string, flags : Tab_Bar_Flags = 0) -> bool do return ig_begin_tab_bar(_make_label_string(str_id), flags);
begin_tab_item                         :: inline proc(label : string, p_open : ^bool = nil, flags : Tab_Item_Flags = 0) -> bool do return ig_begin_tab_item(_make_label_string(label), p_open, flags);
begin_tooltip                          :: inline proc() do igBeginTooltip();
bullet                                 :: inline proc() do igBullet();
bullet_text                            :: inline proc(format : cstring, #c_vararg args : ..any) do igBulletText(format, args);
button                                 :: inline proc(label : string, size := Vec2{0,0}) -> bool do return ig_button(_make_label_string(label), size);
calc_item_width                        :: inline proc() -> f32 do return igCalcItemWidth();
calc_list_clipping                     :: inline proc(items_count : i32, items_height : f32, out_items_display_start : ^i32, out_items_display_end : ^i32) do igCalcListClipping(items_count, items_height, out_items_display_start, out_items_display_end);
calc_text_size                         :: inline proc(text : cstring, text_end : cstring = nil, hide_text_after_double_hash : bool = false, wrap_width : f32 = -1.0) -> Vec2 do return igCalcTextSize(text, text_end, hide_text_after_double_hash, wrap_width);
capture_keyboard_from_app              :: inline proc(want_capture_keyboard_value : bool = true) do igCaptureKeyboardFromApp(want_capture_keyboard_value);
capture_mouse_from_app                 :: inline proc(want_capture_mouse_value : bool = true) do igCaptureMouseFromApp(want_capture_mouse_value);
checkbox                               :: inline proc(label : string, v : ^bool) -> bool do return ig_checkbox(_make_label_string(label), v);
checkbox_flags                         :: inline proc(label : string, flags : ^u32, flags_value : u32) -> bool do return ig_checkbox_flags(_make_label_string(label), flags, flags_value);
close_current_popup                    :: inline proc() do igCloseCurrentPopup();
collapsing_header                      :: inline proc(label : string, flags : Tree_Node_Flags = 0) -> bool do return ig_collapsing_header(_make_label_string(label), flags);
collapsing_header_bool_ptr             :: inline proc(label : string, p_open : ^bool, flags : Tree_Node_Flags = 0) -> bool do return ig_collapsing_header_bool_ptr(_make_label_string(label), p_open, flags);
color_button                           :: inline proc(desc_id : cstring, col : Vec4, flags : Color_Edit_Flags = 0, size := Vec2{0,0}) -> bool do return igColorButton(desc_id, col, flags, size);
color_convert_float_4_to_u_32          :: inline proc(in_ : Vec4) -> u32 do return igColorConvertFloat4ToU32(in_);
color_convert_hs_vto_rgb               :: inline proc(h : f32, s : f32, v : f32, out_r : ^f32, out_g : ^f32, out_b : ^f32) do igColorConvertHSVtoRGB(h, s, v, out_r, out_g, out_b);
color_convert_rg_bto_hsv               :: inline proc(r : f32, g : f32, b : f32, out_h : ^f32, out_s : ^f32, out_v : ^f32) do igColorConvertRGBtoHSV(r, g, b, out_h, out_s, out_v);
color_convert_u_32_to_float_4          :: inline proc(in_ : u32) -> Vec4 do return igColorConvertU32ToFloat4(in_);
color_edit_3                           :: inline proc(label : string, col : [3]f32, flags : Color_Edit_Flags = 0) -> bool do return ig_color_edit_3(_make_label_string(label), col, flags);
color_edit_4                           :: inline proc(label : string, col : [4]f32, flags : Color_Edit_Flags = 0) -> bool do return ig_color_edit_4(_make_label_string(label), col, flags);
color_picker_3                         :: inline proc(label : string, col : [3]f32, flags : Color_Edit_Flags = 0) -> bool do return ig_color_picker_3(_make_label_string(label), col, flags);
color_picker_4                         :: inline proc(label : string, col : [4]f32, flags : Color_Edit_Flags = 0, ref_col : ^f32 = nil) -> bool do return ig_color_picker_4(_make_label_string(label), col, flags, ref_col);
columns                                :: inline proc(count : i32 = 1, id : cstring = nil, border : bool = true) do igColumns(count, id, border);
combo                                  :: inline proc(label : string, current_item : ^i32, items : ^cstring, items_count : i32, popup_max_height_in_items : i32 = -1) -> bool do return ig_combo(_make_label_string(label), current_item, items, items_count, popup_max_height_in_items);
// MISSING WRAPPER FOR: igComboStr
combo_fn_ptr                           :: inline proc(label : string, current_item : ^i32, items_getter : proc "c"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, popup_max_height_in_items : i32 = -1) -> bool do return ig_combo_fn_ptr(_make_label_string(label), current_item, items_getter, data, items_count, popup_max_height_in_items);
create_context                         :: inline proc(shared_font_atlas : ^Font_Atlas = nil) -> ^Context do return igCreateContext(shared_font_atlas);
debug_check_version_and_data_layout    :: inline proc(version_str : cstring, sz_io : uint, sz_style : uint, sz_vec2 : uint, sz_vec4 : uint, sz_drawvert : uint, sz_drawidx : uint) -> bool do return igDebugCheckVersionAndDataLayout(version_str, sz_io, sz_style, sz_vec2, sz_vec4, sz_drawvert, sz_drawidx);
destroy_context                        :: inline proc(ctx : ^Context = nil) do igDestroyContext(ctx);
// WRAPPER UNDER HERE 
drag_float                             :: inline proc(label : string, v : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : string = "%.3f", power : f32 = 1.0) -> bool do return wrapper_drag_float(label, v, v_speed, v_min, v_max, format, power);
// WRAPPER UNDER HERE 
drag_float2                            :: inline proc(label : string, v : [2]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : string = "%.3f", power : f32 = 1.0) -> bool do return wrapper_drag_float2(label, v, v_speed, v_min, v_max, format, power);
// WRAPPER UNDER HERE 
drag_float3                            :: inline proc(label : string, v : [3]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : string = "%.3f", power : f32 = 1.0) -> bool do return wrapper_drag_float3(label, v, v_speed, v_min, v_max, format, power);
// WRAPPER UNDER HERE 
drag_float4                            :: inline proc(label : string, v : [4]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : string = "%.3f", power : f32 = 1.0) -> bool do return wrapper_drag_float4(label, v, v_speed, v_min, v_max, format, power);
// WRAPPER UNDER HERE 
drag_float_range2                      :: inline proc(label : string, v_current_min : ^f32, v_current_max : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", format_max : cstring = nil, power : f32 = 1.0) -> bool do return wrapper_drag_float_range2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, power);
// WRAPPER UNDER HERE 
drag_int                               :: inline proc(label : string, v : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool do return wrapper_drag_int(label, v, v_speed, v_min, v_max, format);
// WRAPPER UNDER HERE 
drag_int2                              :: inline proc(label : string, v : [2]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool do return wrapper_drag_int2(label, v, v_speed, v_min, v_max, format);
// WRAPPER UNDER HERE 
drag_int3                              :: inline proc(label : string, v : [3]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool do return wrapper_drag_int3(label, v, v_speed, v_min, v_max, format);
// WRAPPER UNDER HERE 
drag_int4                              :: inline proc(label : string, v : [4]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool do return wrapper_drag_int4(label, v, v_speed, v_min, v_max, format);
// WRAPPER UNDER HERE 
drag_int_range2                        :: inline proc(label : string, v_current_min : ^i32, v_current_max : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d", format_max : cstring = nil) -> bool do return wrapper_drag_int_range2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max);
// WRAPPER UNDER HERE 
drag_scalar                            :: inline proc(label : string, data_type : Data_Type, p_data : rawptr, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool do return wrapper_drag_scalar(label, data_type, p_data, v_speed, p_min, p_max, format, power);
// WRAPPER UNDER HERE 
drag_scalar_n                          :: inline proc(label : string, data_type : Data_Type, p_data : rawptr, components : i32, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool do return wrapper_drag_scalar_n(label, data_type, p_data, components, v_speed, p_min, p_max, format, power);
dummy                                  :: inline proc(size : Vec2) do igDummy(size);
end                                    :: inline proc() do igEnd();
end_child                              :: inline proc() do igEndChild();
end_child_frame                        :: inline proc() do igEndChildFrame();
end_combo                              :: inline proc() do igEndCombo();
end_drag_drop_source                   :: inline proc() do igEndDragDropSource();
end_drag_drop_target                   :: inline proc() do igEndDragDropTarget();
end_frame                              :: inline proc() do igEndFrame();
end_group                              :: inline proc() do igEndGroup();
end_main_menu_bar                      :: inline proc() do igEndMainMenuBar();
end_menu                               :: inline proc() do igEndMenu();
end_menu_bar                           :: inline proc() do igEndMenuBar();
end_popup                              :: inline proc() do igEndPopup();
end_tab_bar                            :: inline proc() do igEndTabBar();
end_tab_item                           :: inline proc() do igEndTabItem();
end_tooltip                            :: inline proc() do igEndTooltip();
get_background_draw_list               :: inline proc() -> ^Draw_List do return igGetBackgroundDrawList();
get_clipboard_text                     :: inline proc() -> cstring do return igGetClipboardText();
get_color_u_32                         :: inline proc(idx : Col, alpha_mul : f32 = 1.0) -> u32 do return igGetColorU32(idx, alpha_mul);
get_color_u_32                         :: inline proc(col : Vec4) -> u32 do return igGetColorU32Vec4(col);
get_color_u_32                         :: inline proc(col : u32) -> u32 do return igGetColorU32U32(col);
get_column_index                       :: inline proc() -> i32 do return igGetColumnIndex();
get_column_offset                      :: inline proc(column_index : i32 = -1) -> f32 do return igGetColumnOffset(column_index);
get_column_width                       :: inline proc(column_index : i32 = -1) -> f32 do return igGetColumnWidth(column_index);
get_columns_count                      :: inline proc() -> i32 do return igGetColumnsCount();
get_content_region_avail               :: inline proc() -> Vec2 do return igGetContentRegionAvail();
get_content_region_max                 :: inline proc() -> Vec2 do return igGetContentRegionMax();
get_current_context                    :: inline proc() -> ^Context do return igGetCurrentContext();
get_cursor_pos                         :: inline proc() -> Vec2 do return igGetCursorPos();
get_cursor_pos_x                       :: inline proc() -> f32 do return igGetCursorPosX();
get_cursor_pos_y                       :: inline proc() -> f32 do return igGetCursorPosY();
get_cursor_screen_pos                  :: inline proc() -> Vec2 do return igGetCursorScreenPos();
get_cursor_start_pos                   :: inline proc() -> Vec2 do return igGetCursorStartPos();
get_drag_drop_payload                  :: inline proc() -> ^Payload do return igGetDragDropPayload();
get_draw_data                          :: inline proc() -> ^Draw_Data do return igGetDrawData();
get_draw_list_shared_data              :: inline proc() -> ^Draw_List_Shared_Data do return igGetDrawListSharedData();
get_font                               :: inline proc() -> ^Font do return igGetFont();
get_font_size                          :: inline proc() -> f32 do return igGetFontSize();
get_font_tex_uv_white_pixel            :: inline proc() -> Vec2 do return igGetFontTexUvWhitePixel();
get_foreground_draw_list               :: inline proc() -> ^Draw_List do return igGetForegroundDrawList();
get_frame_count                        :: inline proc() -> i32 do return igGetFrameCount();
get_frame_height                       :: inline proc() -> f32 do return igGetFrameHeight();
get_frame_height_with_spacing          :: inline proc() -> f32 do return igGetFrameHeightWithSpacing();
get_id_str                             :: inline proc(str_id : string) -> ID do return ig_get_id_str(_make_label_string(str_id));
get_id                                 :: inline proc(str_id_begin : cstring, str_id_end : cstring) -> ID do return igGetIDRange(str_id_begin, str_id_end);
get_id                                 :: inline proc(ptr_id : rawptr) -> ID do return igGetIDPtr(ptr_id);
get_io                                 :: inline proc() -> ^io do return igGetIO();
get_item_rect_max                      :: inline proc() -> Vec2 do return igGetItemRectMax();
get_item_rect_min                      :: inline proc() -> Vec2 do return igGetItemRectMin();
get_item_rect_size                     :: inline proc() -> Vec2 do return igGetItemRectSize();
get_key_index                          :: inline proc(imgui_key : Key) -> i32 do return igGetKeyIndex(imgui_key);
get_key_pressed_amount                 :: inline proc(key_index : i32, repeat_delay : f32, rate : f32) -> i32 do return igGetKeyPressedAmount(key_index, repeat_delay, rate);
get_mouse_cursor                       :: inline proc() -> Mouse_Cursor do return igGetMouseCursor();
get_mouse_drag_delta                   :: inline proc(button : i32 = 0, lock_threshold : f32 = -1.0) -> Vec2 do return igGetMouseDragDelta(button, lock_threshold);
get_mouse_pos                          :: inline proc() -> Vec2 do return igGetMousePos();
get_mouse_pos_on_opening_current_popup :: inline proc() -> Vec2 do return igGetMousePosOnOpeningCurrentPopup();
get_scroll_max_x                       :: inline proc() -> f32 do return igGetScrollMaxX();
get_scroll_max_y                       :: inline proc() -> f32 do return igGetScrollMaxY();
get_scroll_x                           :: inline proc() -> f32 do return igGetScrollX();
get_scroll_y                           :: inline proc() -> f32 do return igGetScrollY();
get_state_storage                      :: inline proc() -> ^Storage do return igGetStateStorage();
get_style                              :: inline proc() -> ^Style do return igGetStyle();
get_style_color_name                   :: inline proc(idx : Col) -> cstring do return igGetStyleColorName(idx);
get_style_color_vec_4                  :: inline proc(idx : Col) -> ^Vec4 do return igGetStyleColorVec4(idx);
get_text_line_height                   :: inline proc() -> f32 do return igGetTextLineHeight();
get_text_line_height_with_spacing      :: inline proc() -> f32 do return igGetTextLineHeightWithSpacing();
get_time                               :: inline proc() -> f64 do return igGetTime();
get_tree_node_to_label_spacing         :: inline proc() -> f32 do return igGetTreeNodeToLabelSpacing();
get_version                            :: inline proc() -> cstring do return igGetVersion();
get_window_content_region_max          :: inline proc() -> Vec2 do return igGetWindowContentRegionMax();
get_window_content_region_min          :: inline proc() -> Vec2 do return igGetWindowContentRegionMin();
get_window_content_region_width        :: inline proc() -> f32 do return igGetWindowContentRegionWidth();
get_window_draw_list                   :: inline proc() -> ^Draw_List do return igGetWindowDrawList();
get_window_height                      :: inline proc() -> f32 do return igGetWindowHeight();
get_window_pos                         :: inline proc() -> Vec2 do return igGetWindowPos();
get_window_size                        :: inline proc() -> Vec2 do return igGetWindowSize();
get_window_width                       :: inline proc() -> f32 do return igGetWindowWidth();
image                                  :: inline proc(user_texture_id : Texture_ID, size : Vec2, uv0 := Vec2{0,0}, uv1 := Vec2{1,1}, tint_col := Vec4{1,1,1,1}, border_col := Vec4{0,0,0,0}) do igImage(user_texture_id, size, uv0, uv1, tint_col, border_col);
image_button                           :: inline proc(user_texture_id : Texture_ID, size : Vec2, uv0 := Vec2{0,0}, uv1 := Vec2{1,1}, frame_padding : i32 = -1, bg_col := Vec4{0,0,0,0}, tint_col := Vec4{1,1,1,1}) -> bool do return igImageButton(user_texture_id, size, uv0, uv1, frame_padding, bg_col, tint_col);
indent                                 :: inline proc(indent_w : f32 = 0.0) do igIndent(indent_w);
// MISSING WRAPPER FOR: igInputDouble
// MISSING WRAPPER FOR: igInputFloat
// MISSING WRAPPER FOR: igInputFloat2
// MISSING WRAPPER FOR: igInputFloat3
// MISSING WRAPPER FOR: igInputFloat4
input_int                              :: inline proc(label : string, v : ^i32, step : i32 = 1, step_fast : i32 = 100, flags : Input_Text_Flags = 0) -> bool do return ig_input_int(_make_label_string(label), v, step, step_fast, flags);
input_int_2                            :: inline proc(label : string, v : [2]i32, flags : Input_Text_Flags = 0) -> bool do return ig_input_int_2(_make_label_string(label), v, flags);
input_int_3                            :: inline proc(label : string, v : [3]i32, flags : Input_Text_Flags = 0) -> bool do return ig_input_int_3(_make_label_string(label), v, flags);
input_int_4                            :: inline proc(label : string, v : [4]i32, flags : Input_Text_Flags = 0) -> bool do return ig_input_int_4(_make_label_string(label), v, flags);
// MISSING WRAPPER FOR: igInputScalar
// MISSING WRAPPER FOR: igInputScalarN
input_text                             :: inline proc(label : string, buf : ^i8, buf_size : uint, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool do return ig_input_text(_make_label_string(label), buf, buf_size, flags, callback, user_data);
input_text_multiline                   :: inline proc(label : string, buf : ^i8, buf_size : uint, size := Vec2{0,0}, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool do return ig_input_text_multiline(_make_label_string(label), buf, buf_size, size, flags, callback, user_data);
// MISSING WRAPPER FOR: igInputTextWithHint
invisible_button                       :: inline proc(str_id : string, size : Vec2) -> bool do return ig_invisible_button(_make_label_string(str_id), size);
is_any_item_active                     :: inline proc() -> bool do return igIsAnyItemActive();
is_any_item_focused                    :: inline proc() -> bool do return igIsAnyItemFocused();
is_any_item_hovered                    :: inline proc() -> bool do return igIsAnyItemHovered();
is_any_mouse_down                      :: inline proc() -> bool do return igIsAnyMouseDown();
is_item_activated                      :: inline proc() -> bool do return igIsItemActivated();
is_item_active                         :: inline proc() -> bool do return igIsItemActive();
is_item_clicked                        :: inline proc(mouse_button : i32 = 0) -> bool do return igIsItemClicked(mouse_button);
is_item_deactivated                    :: inline proc() -> bool do return igIsItemDeactivated();
is_item_deactivated_after_edit         :: inline proc() -> bool do return igIsItemDeactivatedAfterEdit();
is_item_edited                         :: inline proc() -> bool do return igIsItemEdited();
is_item_focused                        :: inline proc() -> bool do return igIsItemFocused();
is_item_hovered                        :: inline proc(flags : Hovered_Flags = 0) -> bool do return igIsItemHovered(flags);
is_item_toggled_open                   :: inline proc() -> bool do return igIsItemToggledOpen();
is_item_visible                        :: inline proc() -> bool do return igIsItemVisible();
is_key_down                            :: inline proc(user_key_index : i32) -> bool do return igIsKeyDown(user_key_index);
is_key_pressed                         :: inline proc(user_key_index : i32, repeat : bool = true) -> bool do return igIsKeyPressed(user_key_index, repeat);
is_key_released                        :: inline proc(user_key_index : i32) -> bool do return igIsKeyReleased(user_key_index);
is_mouse_clicked                       :: inline proc(button : i32, repeat : bool = false) -> bool do return igIsMouseClicked(button, repeat);
is_mouse_double_clicked                :: inline proc(button : i32) -> bool do return igIsMouseDoubleClicked(button);
is_mouse_down                          :: inline proc(button : i32) -> bool do return igIsMouseDown(button);
is_mouse_dragging                      :: inline proc(button : i32 = 0, lock_threshold : f32 = -1.0) -> bool do return igIsMouseDragging(button, lock_threshold);
is_mouse_hovering_rect                 :: inline proc(r_min : Vec2, r_max : Vec2, clip : bool = true) -> bool do return igIsMouseHoveringRect(r_min, r_max, clip);
is_mouse_pos_valid                     :: inline proc(mouse_pos : ^Vec2 = nil) -> bool do return igIsMousePosValid(mouse_pos);
is_mouse_released                      :: inline proc(button : i32) -> bool do return igIsMouseReleased(button);
is_popup_open                          :: inline proc(str_id : string) -> bool do return ig_is_popup_open(_make_label_string(str_id));
is_rect_visible                        :: inline proc(size : Vec2) -> bool do return igIsRectVisible(size);
is_rect_visible                        :: inline proc(rect_min : Vec2, rect_max : Vec2) -> bool do return igIsRectVisibleVec2(rect_min, rect_max);
is_window_appearing                    :: inline proc() -> bool do return igIsWindowAppearing();
is_window_collapsed                    :: inline proc() -> bool do return igIsWindowCollapsed();
is_window_focused                      :: inline proc(flags : Focused_Flags = 0) -> bool do return igIsWindowFocused(flags);
is_window_hovered                      :: inline proc(flags : Hovered_Flags = 0) -> bool do return igIsWindowHovered(flags);
// MISSING WRAPPER FOR: igLabelText
list_box_str_arr                       :: inline proc(label : string, current_item : ^i32, items : ^cstring, items_count : i32, height_in_items : i32 = -1) -> bool do return ig_list_box_str_arr(_make_label_string(label), current_item, items, items_count, height_in_items);
list_box_fn_ptr                        :: inline proc(label : string, current_item : ^i32, items_getter : proc "c"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, height_in_items : i32 = -1) -> bool do return ig_list_box_fn_ptr(_make_label_string(label), current_item, items_getter, data, items_count, height_in_items);
list_box_footer                        :: inline proc() do igListBoxFooter();
list_box_header_vec_2                  :: inline proc(label : string, size := Vec2{0,0}) -> bool do return ig_list_box_header_vec_2(_make_label_string(label), size);
list_box_header_int                    :: inline proc(label : string, items_count : i32, height_in_items : i32 = -1) -> bool do return ig_list_box_header_int(_make_label_string(label), items_count, height_in_items);
load_ini_settings_from_disk            :: inline proc(ini_filename : cstring) do igLoadIniSettingsFromDisk(ini_filename);
load_ini_settings_from_memory          :: inline proc(ini_data : cstring, ini_size : uint = 0) do igLoadIniSettingsFromMemory(ini_data, ini_size);
log_buttons                            :: inline proc() do igLogButtons();
log_finish                             :: inline proc() do igLogFinish();
log_text                               :: inline proc(format : cstring, #c_vararg args : ..any) do igLogText(format, args);
log_to_clipboard                       :: inline proc(auto_open_depth : i32 = -1) do igLogToClipboard(auto_open_depth);
log_to_file                            :: inline proc(auto_open_depth : i32 = -1, filename : cstring = nil) do igLogToFile(auto_open_depth, filename);
log_to_tty                             :: inline proc(auto_open_depth : i32 = -1) do igLogToTTY(auto_open_depth);
mem_alloc                              :: inline proc(size : uint) -> rawptr do return igMemAlloc(size);
mem_free                               :: inline proc(ptr : rawptr) do igMemFree(ptr);
// MISSING WRAPPER FOR: igMenuItemBool
// MISSING WRAPPER FOR: igMenuItemBoolPtr
new_frame                              :: inline proc() do igNewFrame();
new_line                               :: inline proc() do igNewLine();
next_column                            :: inline proc() do igNextColumn();
open_popup                             :: inline proc(str_id : string) do return ig_open_popup(_make_label_string(str_id));
open_popup_on_item_click               :: inline proc(str_id : string, mouse_button : i32 = 1) -> bool do return ig_open_popup_on_item_click(_make_label_string(str_id), mouse_button);
// MISSING WRAPPER FOR: igPlotHistogramFloatPtr
// MISSING WRAPPER FOR: igPlotHistogramFnPtr
// MISSING WRAPPER FOR: igPlotLines
// MISSING WRAPPER FOR: igPlotLinesFnPtr
pop_allow_keyboard_focus               :: inline proc() do igPopAllowKeyboardFocus();
pop_button_repeat                      :: inline proc() do igPopButtonRepeat();
pop_clip_rect                          :: inline proc() do igPopClipRect();
pop_font                               :: inline proc() do igPopFont();
pop_id                                 :: inline proc() do igPopID();
pop_item_width                         :: inline proc() do igPopItemWidth();
pop_style_color                        :: inline proc(count : i32 = 1) do igPopStyleColor(count);
pop_style_var                          :: inline proc(count : i32 = 1) do igPopStyleVar(count);
pop_text_wrap_pos                      :: inline proc() do igPopTextWrapPos();
progress_bar                           :: inline proc(fraction : f32, size_arg := Vec2{-1,0}, overlay : cstring = nil) do igProgressBar(fraction, size_arg, overlay);
push_allow_keyboard_focus              :: inline proc(allow_keyboard_focus : bool) do igPushAllowKeyboardFocus(allow_keyboard_focus);
push_button_repeat                     :: inline proc(repeat : bool) do igPushButtonRepeat(repeat);
push_clip_rect                         :: inline proc(clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) do igPushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect);
push_font                              :: inline proc(font : ^Font) do igPushFont(font);
push_id_str                            :: inline proc(str_id : string) do return ig_push_id_str(_make_label_string(str_id));
push_id                                :: inline proc(str_id_begin : cstring, str_id_end : cstring) do igPushIDRange(str_id_begin, str_id_end);
push_id                                :: inline proc(ptr_id : rawptr) do igPushIDPtr(ptr_id);
push_id                                :: inline proc(int_id : i32) do igPushIDInt(int_id);
push_item_width                        :: inline proc(item_width : f32) do igPushItemWidth(item_width);
push_style_color                       :: inline proc(idx : Col, col : u32) do igPushStyleColorU32(idx, col);
push_style_color                       :: inline proc(idx : Col, col : Vec4) do igPushStyleColor(idx, col);
push_style_var                         :: inline proc(idx : Style_Var, val : f32) do igPushStyleVarFloat(idx, val);
push_style_var                         :: inline proc(idx : Style_Var, val : Vec2) do igPushStyleVarVec2(idx, val);
push_text_wrap_pos                     :: inline proc(wrap_local_pos_x : f32 = 0.0) do igPushTextWrapPos(wrap_local_pos_x);
radio_button_bool                      :: inline proc(label : string, active : bool) -> bool do return ig_radio_button_bool(_make_label_string(label), active);
radio_button_int_ptr                   :: inline proc(label : string, v : ^i32, v_button : i32) -> bool do return ig_radio_button_int_ptr(_make_label_string(label), v, v_button);
render                                 :: inline proc() do igRender();
reset_mouse_drag_delta                 :: inline proc(button : i32 = 0) do igResetMouseDragDelta(button);
same_line                              :: inline proc(offset_from_start_x : f32 = 0.0, spacing : f32 = -1.0) do igSameLine(offset_from_start_x, spacing);
save_ini_settings_to_disk              :: inline proc(ini_filename : cstring) do igSaveIniSettingsToDisk(ini_filename);
save_ini_settings_to_memory            :: inline proc(out_ini_size : ^uint = nil) -> cstring do return igSaveIniSettingsToMemory(out_ini_size);
selectable                             :: inline proc(label : string, selected : bool = false, flags : Selectable_Flags = 0, size := Vec2{0,0}) -> bool do return ig_selectable(_make_label_string(label), selected, flags, size);
selectable_bool_ptr                    :: inline proc(label : string, p_selected : ^bool, flags : Selectable_Flags = 0, size := Vec2{0,0}) -> bool do return ig_selectable_bool_ptr(_make_label_string(label), p_selected, flags, size);
separator                              :: inline proc() do igSeparator();
set_allocator_functions                :: inline proc(alloc_func : proc "c"(sz : uint, user_date : rawptr) -> rawptr, free_func : proc "c"(ptr : rawptr, user_date : rawptr) -> rawptr, user_data : rawptr = nil) do igSetAllocatorFunctions(alloc_func, free_func, user_data);
set_clipboard_text                     :: inline proc(text : cstring) do igSetClipboardText(text);
set_color_edit_options                 :: inline proc(flags : Color_Edit_Flags) do igSetColorEditOptions(flags);
set_column_offset                      :: inline proc(column_index : i32, offset_x : f32) do igSetColumnOffset(column_index, offset_x);
set_column_width                       :: inline proc(column_index : i32, width : f32) do igSetColumnWidth(column_index, width);
set_current_context                    :: inline proc(ctx : ^Context) do igSetCurrentContext(ctx);
set_cursor_pos                         :: inline proc(local_pos : Vec2) do igSetCursorPos(local_pos);
set_cursor_pos_x                       :: inline proc(local_x : f32) do igSetCursorPosX(local_x);
set_cursor_pos_y                       :: inline proc(local_y : f32) do igSetCursorPosY(local_y);
set_cursor_screen_pos                  :: inline proc(pos : Vec2) do igSetCursorScreenPos(pos);
set_drag_drop_payload                  :: inline proc(type : cstring, data : rawptr, sz : uint, cond : Cond = 0) -> bool do return igSetDragDropPayload(type, data, sz, cond);
set_item_allow_overlap                 :: inline proc() do igSetItemAllowOverlap();
set_item_default_focus                 :: inline proc() do igSetItemDefaultFocus();
set_keyboard_focus_here                :: inline proc(offset : i32 = 0) do igSetKeyboardFocusHere(offset);
set_mouse_cursor                       :: inline proc(type : Mouse_Cursor) do igSetMouseCursor(type);
set_next_item_open                     :: inline proc(is_open : bool, cond : Cond = 0) do igSetNextItemOpen(is_open, cond);
set_next_item_width                    :: inline proc(item_width : f32) do igSetNextItemWidth(item_width);
set_next_window_bg_alpha               :: inline proc(alpha : f32) do igSetNextWindowBgAlpha(alpha);
set_next_window_collapsed              :: inline proc(collapsed : bool, cond : Cond = 0) do igSetNextWindowCollapsed(collapsed, cond);
set_next_window_content_size           :: inline proc(size : Vec2) do igSetNextWindowContentSize(size);
set_next_window_focus                  :: inline proc() do igSetNextWindowFocus();
set_next_window_pos                    :: inline proc(pos : Vec2, cond : Cond = 0, pivot := Vec2{0,0}) do igSetNextWindowPos(pos, cond, pivot);
set_next_window_size                   :: inline proc(size : Vec2, cond : Cond = 0) do igSetNextWindowSize(size, cond);
set_next_window_size_constraints       :: inline proc(size_min : Vec2, size_max : Vec2, custom_callback : Size_Callback = nil, custom_callback_data : rawptr = nil) do igSetNextWindowSizeConstraints(size_min, size_max, custom_callback, custom_callback_data);
set_scroll_from_pos_x                  :: inline proc(local_x : f32, center_x_ratio : f32 = 0.5) do igSetScrollFromPosX(local_x, center_x_ratio);
set_scroll_from_pos_y                  :: inline proc(local_y : f32, center_y_ratio : f32 = 0.5) do igSetScrollFromPosY(local_y, center_y_ratio);
set_scroll_here_x                      :: inline proc(center_x_ratio : f32 = 0.5) do igSetScrollHereX(center_x_ratio);
set_scroll_here_y                      :: inline proc(center_y_ratio : f32 = 0.5) do igSetScrollHereY(center_y_ratio);
set_scroll_x                           :: inline proc(scroll_x : f32) do igSetScrollX(scroll_x);
set_scroll_y                           :: inline proc(scroll_y : f32) do igSetScrollY(scroll_y);
set_state_storage                      :: inline proc(storage : ^Storage) do igSetStateStorage(storage);
set_tab_item_closed                    :: inline proc(tab_or_docked_window_label : cstring) do igSetTabItemClosed(tab_or_docked_window_label);
set_tooltip                            :: inline proc(format : cstring, #c_vararg args : ..any) do igSetTooltip(format, args);
set_window_collapsed                   :: inline proc(collapsed : bool, cond : Cond = 0) do igSetWindowCollapsedBool(collapsed, cond);
set_window_collapsed_str               :: inline proc(name : string, collapsed : bool, cond : Cond = 0) do return ig_set_window_collapsed_str(_make_label_string(name), collapsed, cond);
set_window_focus                       :: inline proc() do igSetWindowFocus();
set_window_focus_str                   :: inline proc(name : string) do return ig_set_window_focus_str(_make_label_string(name));
set_window_font_scale                  :: inline proc(scale : f32) do igSetWindowFontScale(scale);
set_window_pos                         :: inline proc(pos : Vec2, cond : Cond = 0) do igSetWindowPosVec2(pos, cond);
set_window_pos_str                     :: inline proc(name : string, pos : Vec2, cond : Cond = 0) do return ig_set_window_pos_str(_make_label_string(name), pos, cond);
set_window_size                        :: inline proc(size : Vec2, cond : Cond = 0) do igSetWindowSizeVec2(size, cond);
set_window_size_str                    :: inline proc(name : string, size : Vec2, cond : Cond = 0) do return ig_set_window_size_str(_make_label_string(name), size, cond);
show_about_window                      :: inline proc(p_open : ^bool = nil) do igShowAboutWindow(p_open);
show_demo_window                       :: inline proc(p_open : ^bool = nil) do igShowDemoWindow(p_open);
show_font_selector                     :: inline proc(label : string) do return ig_show_font_selector(_make_label_string(label));
show_metrics_window                    :: inline proc(p_open : ^bool = nil) do igShowMetricsWindow(p_open);
show_style_editor                      :: inline proc(ref : ^Style = nil) do igShowStyleEditor(ref);
show_style_selector                    :: inline proc(label : string) -> bool do return ig_show_style_selector(_make_label_string(label));
show_user_guide                        :: inline proc() do igShowUserGuide();
// MISSING WRAPPER FOR: igSliderAngle
// MISSING WRAPPER FOR: igSliderFloat
// MISSING WRAPPER FOR: igSliderFloat2
// MISSING WRAPPER FOR: igSliderFloat3
// MISSING WRAPPER FOR: igSliderFloat4
// MISSING WRAPPER FOR: igSliderInt
// MISSING WRAPPER FOR: igSliderInt2
// MISSING WRAPPER FOR: igSliderInt3
// MISSING WRAPPER FOR: igSliderInt4
// MISSING WRAPPER FOR: igSliderScalar
// MISSING WRAPPER FOR: igSliderScalarN
small_button                           :: inline proc(label : string) -> bool do return ig_small_button(_make_label_string(label));
spacing                                :: inline proc() do igSpacing();
style_colors_classic                   :: inline proc(dst : ^Style = nil) do igStyleColorsClassic(dst);
style_colors_dark                      :: inline proc(dst : ^Style = nil) do igStyleColorsDark(dst);
style_colors_light                     :: inline proc(dst : ^Style = nil) do igStyleColorsLight(dst);
text                                   :: inline proc(format : cstring, #c_vararg args : ..any) do igText(format, args);
text_colored                           :: inline proc(col : Vec4, format : cstring, #c_vararg args : ..any) do igTextColored(col, format, args);
text_disabled                          :: inline proc(format : cstring, #c_vararg args : ..any) do igTextDisabled(format, args);
text_unformatted                       :: inline proc(text : cstring, text_end : cstring = nil) do igTextUnformatted(text, text_end);
text_wrapped                           :: inline proc(format : cstring, #c_vararg args : ..any) do igTextWrapped(format, args);
tree_node_str                          :: inline proc(label : string) -> bool do return ig_tree_node_str(_make_label_string(label));
// MISSING WRAPPER FOR: igTreeNodeStrStr
tree_node                              :: inline proc(ptr_id : rawptr, format : cstring, #c_vararg args : ..any) -> bool do return igTreeNodePtr(ptr_id, format, args);
tree_node_ex_str                       :: inline proc(label : string, flags : Tree_Node_Flags = 0) -> bool do return ig_tree_node_ex_str(_make_label_string(label), flags);
// MISSING WRAPPER FOR: igTreeNodeExStrStr
tree_node_ex                           :: inline proc(ptr_id : rawptr, flags : Tree_Node_Flags, format : cstring, #c_vararg args : ..any) -> bool do return igTreeNodeExPtr(ptr_id, flags, format, args);
tree_pop                               :: inline proc() do igTreePop();
tree_push_str                          :: inline proc(str_id : string) do return ig_tree_push_str(_make_label_string(str_id));
tree_push                              :: inline proc(ptr_id : rawptr = nil) do igTreePushPtr(ptr_id);
unindent                               :: inline proc(indent_w : f32 = 0.0) do igUnindent(indent_w);
// MISSING WRAPPER FOR: igVSliderFloat
// MISSING WRAPPER FOR: igVSliderInt
// MISSING WRAPPER FOR: igVSliderScalar
value_bool                             :: inline proc(prefix : string, b : bool) do return ig_value_bool(_make_label_string(prefix), b);
value_int                              :: inline proc(prefix : string, v : i32) do return ig_value_int(_make_label_string(prefix), v);
value_uint                             :: inline proc(prefix : string, v : u32) do return ig_value_uint(_make_label_string(prefix), v);
// MISSING WRAPPER FOR: igValueFloat


@(default_calling_convention="c")
foreign cimgui {
	ImColor_HSV   :: proc(self : ^Color, h : f32, s : f32, v : f32, a : f32 = 1.0) -> Color ---;
	ImColor_SetHSV :: proc(self : ^Color, h : f32, s : f32, v : f32, a : f32 = 1.0) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImDrawData_Clear               :: proc(self : ^Draw_Data) ---;
	ImDrawData_DeIndexAllBuffers   :: proc(self : ^Draw_Data) ---;
	ImDrawData_ScaleClipRects      :: proc(self : ^Draw_Data, fb_scale : Vec2) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImDrawListSplitter_Clear               :: proc(self : ^Draw_List_Splitter) ---;
	ImDrawListSplitter_ClearFreeMemory     :: proc(self : ^Draw_List_Splitter) ---;
	ImDrawListSplitter_Merge               :: proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List) ---;
	ImDrawListSplitter_SetCurrentChannel   :: proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List, channel_idx : i32) ---;
	ImDrawListSplitter_Split               :: proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List, count : i32) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImDrawList_AddBezierCurve              :: proc(self : ^Draw_List, pos0 : Vec2, cp0 : Vec2, cp1 : Vec2, pos1 : Vec2, col : u32, thickness : f32, num_segments : i32 = 0) ---;
	ImDrawList_AddCallback                 :: proc(self : ^Draw_List, callback : Draw_Callback, callback_data : rawptr) ---;
	ImDrawList_AddCircle                   :: proc(self : ^Draw_List, center : Vec2, radius : f32, col : u32, num_segments : i32 = 12, thickness : f32 = 1.0) ---;
	ImDrawList_AddCircleFilled             :: proc(self : ^Draw_List, center : Vec2, radius : f32, col : u32, num_segments : i32 = 12) ---;
	ImDrawList_AddConvexPolyFilled         :: proc(self : ^Draw_List, points : ^Vec2, num_points : i32, col : u32) ---;
	ImDrawList_AddDrawCmd                  :: proc(self : ^Draw_List) ---;
	ImDrawList_AddImage                    :: proc(self : ^Draw_List, user_texture_id : Texture_ID, p_min : Vec2, p_max : Vec2, uv_min := Vec2{0,0}, uv_max := Vec2{1,1}, col : u32 = 0xffffffff) ---;
	ImDrawList_AddImageQuad                :: proc(self : ^Draw_List, user_texture_id : Texture_ID, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, uv1 := Vec2{0,0}, uv2 := Vec2{1,0}, uv3 := Vec2{1,1}, uv4 := Vec2{0,1}, col : u32 = 0xffffffff) ---;
	ImDrawList_AddImageRounded             :: proc(self : ^Draw_List, user_texture_id : Texture_ID, p_min : Vec2, p_max : Vec2, uv_min : Vec2, uv_max : Vec2, col : u32, rounding : f32, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) ---;
	ImDrawList_AddLine                     :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, col : u32, thickness : f32 = 1.0) ---;
	ImDrawList_AddPolyline                 :: proc(self : ^Draw_List, points : ^Vec2, num_points : i32, col : u32, closed : bool, thickness : f32) ---;
	ImDrawList_AddQuad                     :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, col : u32, thickness : f32 = 1.0) ---;
	ImDrawList_AddQuadFilled               :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, col : u32) ---;
	ImDrawList_AddRect                     :: proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col : u32, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All, thickness : f32 = 1.0) ---;
	ImDrawList_AddRectFilled               :: proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col : u32, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) ---;
	ImDrawList_AddRectFilledMultiColor     :: proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32) ---;
	ImDrawList_AddText                     :: proc(self : ^Draw_List, pos : Vec2, col : u32, text_begin : cstring, text_end : cstring = nil) ---;
	ImDrawList_AddTextFontPtr              :: proc(self : ^Draw_List, font : ^Font, font_size : f32, pos : Vec2, col : u32, text_begin : cstring, text_end : cstring = nil, wrap_width : f32 = 0.0, cpu_fine_clip_rect : ^Vec4 = nil) ---;
	ImDrawList_AddTriangle                 :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, col : u32, thickness : f32 = 1.0) ---;
	ImDrawList_AddTriangleFilled           :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, col : u32) ---;
	ImDrawList_ChannelsMerge               :: proc(self : ^Draw_List) ---;
	ImDrawList_ChannelsSetCurrent          :: proc(self : ^Draw_List, n : i32) ---;
	ImDrawList_ChannelsSplit               :: proc(self : ^Draw_List, count : i32) ---;
	ImDrawList_Clear                       :: proc(self : ^Draw_List) ---;
	ImDrawList_ClearFreeMemory             :: proc(self : ^Draw_List) ---;
	ImDrawList_CloneOutput                 :: proc(self : ^Draw_List) -> ^Draw_List ---;
	ImDrawList_GetClipRectMax              :: proc(self : ^Draw_List) -> Vec2 ---;
	ImDrawList_GetClipRectMin              :: proc(self : ^Draw_List) -> Vec2 ---;
	ImDrawList_PathArcTo                   :: proc(self : ^Draw_List, center : Vec2, radius : f32, a_min : f32, a_max : f32, num_segments : i32 = 10) ---;
	ImDrawList_PathArcToFast               :: proc(self : ^Draw_List, center : Vec2, radius : f32, a_min_of_12 : i32, a_max_of_12 : i32) ---;
	ImDrawList_PathBezierCurveTo           :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, num_segments : i32 = 0) ---;
	ImDrawList_PathClear                   :: proc(self : ^Draw_List) ---;
	ImDrawList_PathFillConvex              :: proc(self : ^Draw_List, col : u32) ---;
	ImDrawList_PathLineTo                  :: proc(self : ^Draw_List, pos : Vec2) ---;
	ImDrawList_PathLineToMergeDuplicate    :: proc(self : ^Draw_List, pos : Vec2) ---;
	ImDrawList_PathRect                    :: proc(self : ^Draw_List, rect_min : Vec2, rect_max : Vec2, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) ---;
	ImDrawList_PathStroke                  :: proc(self : ^Draw_List, col : u32, closed : bool, thickness : f32 = 1.0) ---;
	ImDrawList_PopClipRect                 :: proc(self : ^Draw_List) ---;
	ImDrawList_PopTextureID                :: proc(self : ^Draw_List) ---;
	ImDrawList_PrimQuadUV                  :: proc(self : ^Draw_List, a : Vec2, b : Vec2, c : Vec2, d : Vec2, uv_a : Vec2, uv_b : Vec2, uv_c : Vec2, uv_d : Vec2, col : u32) ---;
	ImDrawList_PrimRect                    :: proc(self : ^Draw_List, a : Vec2, b : Vec2, col : u32) ---;
	ImDrawList_PrimRectUV                  :: proc(self : ^Draw_List, a : Vec2, b : Vec2, uv_a : Vec2, uv_b : Vec2, col : u32) ---;
	ImDrawList_PrimReserve                 :: proc(self : ^Draw_List, idx_count : i32, vtx_count : i32) ---;
	ImDrawList_PrimVtx                     :: proc(self : ^Draw_List, pos : Vec2, uv : Vec2, col : u32) ---;
	ImDrawList_PrimWriteIdx                :: proc(self : ^Draw_List, idx : Draw_Idx) ---;
	ImDrawList_PrimWriteVtx                :: proc(self : ^Draw_List, pos : Vec2, uv : Vec2, col : u32) ---;
	ImDrawList_PushClipRect                :: proc(self : ^Draw_List, clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool = false) ---;
	ImDrawList_PushClipRectFullScreen      :: proc(self : ^Draw_List) ---;
	ImDrawList_PushTextureID               :: proc(self : ^Draw_List, texture_id : Texture_ID) ---;
	ImDrawList_UpdateClipRect              :: proc(self : ^Draw_List) ---;
	ImDrawList_UpdateTextureID             :: proc(self : ^Draw_List) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImFontAtlasCustomRect_IsPacked   :: proc(self : ^Font_Atlas_Custom_Rect) -> bool ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImFontAtlas_AddCustomRectFontGlyph                     :: proc(self : ^Font_Atlas, font : ^Font, id : Wchar, width : i32, height : i32, advance_x : f32, offset := Vec2{0,0}) -> i32 ---;
	ImFontAtlas_AddCustomRectRegular                       :: proc(self : ^Font_Atlas, id : u32, width : i32, height : i32) -> i32 ---;
	ImFontAtlas_AddFont                                    :: proc(self : ^Font_Atlas, font_cfg : ^Font_Config) -> ^Font ---;
	ImFontAtlas_AddFontDefault                             :: proc(self : ^Font_Atlas, font_cfg : ^Font_Config = nil) -> ^Font ---;
	ImFontAtlas_AddFontFromFileTTF                         :: proc(self : ^Font_Atlas, filename : cstring, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
	ImFontAtlas_AddFontFromMemoryCompressedBase85TTF       :: proc(self : ^Font_Atlas, compressed_font_data_base85 : cstring, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
	ImFontAtlas_AddFontFromMemoryCompressedTTF             :: proc(self : ^Font_Atlas, compressed_font_data : rawptr, compressed_font_size : i32, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
	ImFontAtlas_AddFontFromMemoryTTF                       :: proc(self : ^Font_Atlas, font_data : rawptr, font_size : i32, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
	ImFontAtlas_Build                                      :: proc(self : ^Font_Atlas) -> bool ---;
	ImFontAtlas_CalcCustomRectUV                           :: proc(self : ^Font_Atlas, rect : ^Font_Atlas_Custom_Rect, out_uv_min : ^Vec2, out_uv_max : ^Vec2) ---;
	ImFontAtlas_Clear                                      :: proc(self : ^Font_Atlas) ---;
	ImFontAtlas_ClearFonts                                 :: proc(self : ^Font_Atlas) ---;
	ImFontAtlas_ClearInputData                             :: proc(self : ^Font_Atlas) ---;
	ImFontAtlas_ClearTexData                               :: proc(self : ^Font_Atlas) ---;
	ImFontAtlas_GetCustomRectByIndex                       :: proc(self : ^Font_Atlas, index : i32) -> ^Font_Atlas_Custom_Rect ---;
	ImFontAtlas_GetGlyphRangesChineseFull                  :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon      :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	ImFontAtlas_GetGlyphRangesCyrillic                     :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	ImFontAtlas_GetGlyphRangesDefault                      :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	ImFontAtlas_GetGlyphRangesJapanese                     :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	ImFontAtlas_GetGlyphRangesKorean                       :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	ImFontAtlas_GetGlyphRangesThai                         :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	ImFontAtlas_GetGlyphRangesVietnamese                   :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	ImFontAtlas_GetMouseCursorTexData                      :: proc(self : ^Font_Atlas, cursor : Mouse_Cursor, out_offset : ^Vec2, out_size : ^Vec2, out_uv_border : [2]Vec2, out_uv_fill : [2]Vec2) -> bool ---;
	ImFontAtlas_GetTexDataAsAlpha8                         :: proc(self : ^Font_Atlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) ---;
	ImFontAtlas_GetTexDataAsRGBA32                         :: proc(self : ^Font_Atlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) ---;
	ImFontAtlas_IsBuilt                                    :: proc(self : ^Font_Atlas) -> bool ---;
	ImFontAtlas_SetTexID                                   :: proc(self : ^Font_Atlas, id : Texture_ID) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImFontGlyphRangesBuilder_AddChar       :: proc(self : ^Font_Glyph_Ranges_Builder, c : Wchar) ---;
	ImFontGlyphRangesBuilder_AddRanges     :: proc(self : ^Font_Glyph_Ranges_Builder, ranges : ^Wchar) ---;
	ImFontGlyphRangesBuilder_AddText       :: proc(self : ^Font_Glyph_Ranges_Builder, text : cstring, text_end : cstring = nil) ---;
	ImFontGlyphRangesBuilder_BuildRanges   :: proc(self : ^Font_Glyph_Ranges_Builder, out_ranges : ^Im_Vector(Wchar)) ---;
	ImFontGlyphRangesBuilder_Clear         :: proc(self : ^Font_Glyph_Ranges_Builder) ---;
	ImFontGlyphRangesBuilder_GetBit        :: proc(self : ^Font_Glyph_Ranges_Builder, n : i32) -> bool ---;
	ImFontGlyphRangesBuilder_SetBit        :: proc(self : ^Font_Glyph_Ranges_Builder, n : i32) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImFont_AddGlyph                :: proc(self : ^Font, c : Wchar, x0 : f32, y0 : f32, x1 : f32, y1 : f32, u0 : f32, v0 : f32, u1 : f32, v1 : f32, advance_x : f32) ---;
	ImFont_AddRemapChar            :: proc(self : ^Font, dst : Wchar, src : Wchar, overwrite_dst : bool = true) ---;
	ImFont_BuildLookupTable        :: proc(self : ^Font) ---;
	ImFont_CalcTextSizeA           :: proc(self : ^Font, size : f32, max_width : f32, wrap_width : f32, text_begin : cstring, text_end : cstring = nil, remaining : ^^i8 = nil) -> Vec2 ---;
	ImFont_CalcWordWrapPositionA   :: proc(self : ^Font, scale : f32, text : cstring, text_end : cstring, wrap_width : f32) -> cstring ---;
	ImFont_ClearOutputData         :: proc(self : ^Font) ---;
	ImFont_FindGlyph               :: proc(self : ^Font, c : Wchar) -> ^Font_Glyph ---;
	ImFont_FindGlyphNoFallback     :: proc(self : ^Font, c : Wchar) -> ^Font_Glyph ---;
	ImFont_GetCharAdvance          :: proc(self : ^Font, c : Wchar) -> f32 ---;
	ImFont_GetDebugName            :: proc(self : ^Font) -> cstring ---;
	ImFont_GrowIndex               :: proc(self : ^Font, new_size : i32) ---;
	ImFont_IsLoaded                :: proc(self : ^Font) -> bool ---;
	ImFont_RenderChar              :: proc(self : ^Font, draw_list : ^Draw_List, size : f32, pos : Vec2, col : u32, c : Wchar) ---;
	ImFont_RenderText              :: proc(self : ^Font, draw_list : ^Draw_List, size : f32, pos : Vec2, col : u32, clip_rect : Vec4, text_begin : cstring, text_end : cstring, wrap_width : f32 = 0.0, cpu_fine_clip : bool = false) ---;
	ImFont_SetFallbackChar         :: proc(self : ^Font, c : Wchar) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiIO_AddInputCharacter     :: proc(self : ^io, c : u32) ---;
	ImGuiIO_AddInputCharactersUTF8 :: proc(self : ^io, str : cstring) ---;
	ImGuiIO_ClearInputCharacters  :: proc(self : ^io) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiInputTextCallbackData_DeleteChars :: proc(self : ^Input_Text_Callback_Data, pos : i32, bytes_count : i32) ---;
	ImGuiInputTextCallbackData_HasSelection :: proc(self : ^Input_Text_Callback_Data) -> bool ---;
	ImGuiInputTextCallbackData_InsertChars :: proc(self : ^Input_Text_Callback_Data, pos : i32, text : cstring, text_end : cstring = nil) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiListClipper_Begin :: proc(self : ^List_Clipper, items_count : i32, items_height : f32 = -1.0) ---;
	ImGuiListClipper_End :: proc(self : ^List_Clipper) ---;
	ImGuiListClipper_Step :: proc(self : ^List_Clipper) -> bool ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiPayload_Clear   :: proc(self : ^Payload) ---;
	ImGuiPayload_IsDataType :: proc(self : ^Payload, type : cstring) -> bool ---;
	ImGuiPayload_IsDelivery :: proc(self : ^Payload) -> bool ---;
	ImGuiPayload_IsPreview :: proc(self : ^Payload) -> bool ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiStorage_BuildSortByKey :: proc(self : ^Storage) ---;
	ImGuiStorage_Clear        :: proc(self : ^Storage) ---;
	ImGuiStorage_GetBool      :: proc(self : ^Storage, key : ID, default_val : bool = false) -> bool ---;
	ImGuiStorage_GetBoolRef   :: proc(self : ^Storage, key : ID, default_val : bool = false) -> ^bool ---;
	ImGuiStorage_GetFloat     :: proc(self : ^Storage, key : ID, default_val : f32 = 0.0) -> f32 ---;
	ImGuiStorage_GetFloatRef  :: proc(self : ^Storage, key : ID, default_val : f32 = 0.0) -> ^f32 ---;
	ImGuiStorage_GetInt       :: proc(self : ^Storage, key : ID, default_val : i32 = 0) -> i32 ---;
	ImGuiStorage_GetIntRef    :: proc(self : ^Storage, key : ID, default_val : i32 = 0) -> ^i32 ---;
	ImGuiStorage_GetVoidPtr   :: proc(self : ^Storage, key : ID) -> rawptr ---;
	ImGuiStorage_GetVoidPtrRef :: proc(self : ^Storage, key : ID, default_val : rawptr = nil) -> ^^oid ---;
	ImGuiStorage_SetAllInt    :: proc(self : ^Storage, val : i32) ---;
	ImGuiStorage_SetBool      :: proc(self : ^Storage, key : ID, val : bool) ---;
	ImGuiStorage_SetFloat     :: proc(self : ^Storage, key : ID, val : f32) ---;
	ImGuiStorage_SetInt       :: proc(self : ^Storage, key : ID, val : i32) ---;
	ImGuiStorage_SetVoidPtr   :: proc(self : ^Storage, key : ID, val : rawptr) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiStyle_ScaleAllSizes :: proc(self : ^Style, scale_factor : f32) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiTextBuffer_append :: proc(self : ^Text_Buffer, str : cstring, str_end : cstring = nil) ---;
	ImGuiTextBuffer_appendf :: proc(self : ^Text_Buffer, format : cstring, #c_vararg args : ..any) ---;
	ImGuiTextBuffer_begin :: proc(self : ^Text_Buffer) -> cstring ---;
	ImGuiTextBuffer_c_str :: proc(self : ^Text_Buffer) -> cstring ---;
	ImGuiTextBuffer_clear :: proc(self : ^Text_Buffer) ---;
	ImGuiTextBuffer_empty :: proc(self : ^Text_Buffer) -> bool ---;
	ImGuiTextBuffer_end :: proc(self : ^Text_Buffer) -> cstring ---;
	ImGuiTextBuffer_reserve :: proc(self : ^Text_Buffer, capacity : i32) ---;
	ImGuiTextBuffer_size :: proc(self : ^Text_Buffer) -> i32 ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiTextFilter_Build   :: proc(self : ^Text_Filter) ---;
	ImGuiTextFilter_Clear   :: proc(self : ^Text_Filter) ---;
	ImGuiTextFilter_Draw    :: proc(self : ^Text_Filter, label := "Filter{inc,-exc}", width : f32 = 0.0) -> bool ---;
	ImGuiTextFilter_IsActive :: proc(self : ^Text_Filter) -> bool ---;
	ImGuiTextFilter_PassFilter :: proc(self : ^Text_Filter, text : cstring, text_end : cstring = nil) -> bool ---;
}

@(default_calling_convention="c")
foreign cimgui {
	ImGuiTextRange_empty :: proc(self : ^Text_Range) -> bool ---;
	ImGuiTextRange_split :: proc(self : ^Text_Range, separator : i8, out : ^Im_Vector(Text_Range)) ---;
}

@(default_calling_convention="c")
foreign cimgui {
	igAcceptDragDropPayload                :: proc(type : cstring, flags : Drag_Drop_Flags = 0) -> ^Payload ---;
	igAlignTextToFramePadding              :: proc() ---;
	igArrowButton                          :: proc(str_id : cstring, dir : Dir) -> bool ---;
	igBegin                                :: proc(name : cstring, p_open : ^bool = nil, flags : Window_Flags = 0) -> bool ---;
	igBeginChild                           :: proc(str_id : cstring, size := Vec2{0,0}, border : bool = false, flags : Window_Flags = 0) -> bool ---;
	igBeginChildID                         :: proc(id : ID, size := Vec2{0,0}, border : bool = false, flags : Window_Flags = 0) -> bool ---;
	igBeginChildFrame                      :: proc(id : ID, size : Vec2, flags : Window_Flags = 0) -> bool ---;
	igBeginCombo                           :: proc(label : cstring, preview_value : cstring, flags : Combo_Flags = 0) -> bool ---;
	igBeginDragDropSource                  :: proc(flags : Drag_Drop_Flags = 0) -> bool ---;
	igBeginDragDropTarget                  :: proc() -> bool ---;
	igBeginGroup                           :: proc() ---;
	igBeginMainMenuBar                     :: proc() -> bool ---;
	igBeginMenu                            :: proc(label : cstring, enabled : bool = true) -> bool ---;
	igBeginMenuBar                         :: proc() -> bool ---;
	igBeginPopup                           :: proc(str_id : cstring, flags : Window_Flags = 0) -> bool ---;
	igBeginPopupContextItem                :: proc(str_id : cstring = nil, mouse_button : i32 = 1) -> bool ---;
	igBeginPopupContextVoid                :: proc(str_id : cstring = nil, mouse_button : i32 = 1) -> bool ---;
	igBeginPopupContextWindow              :: proc(str_id : cstring = nil, mouse_button : i32 = 1, also_over_items : bool = true) -> bool ---;
	igBeginPopupModal                      :: proc(name : cstring, p_open : ^bool = nil, flags : Window_Flags = 0) -> bool ---;
	igBeginTabBar                          :: proc(str_id : cstring, flags : Tab_Bar_Flags = 0) -> bool ---;
	igBeginTabItem                         :: proc(label : cstring, p_open : ^bool = nil, flags : Tab_Item_Flags = 0) -> bool ---;
	igBeginTooltip                         :: proc() ---;
	igBullet                               :: proc() ---;
	igBulletText                           :: proc(format : cstring, #c_vararg args : ..any) ---;
	igButton                               :: proc(label : cstring, size := Vec2{0,0}) -> bool ---;
	igCalcItemWidth                        :: proc() -> f32 ---;
	igCalcListClipping                     :: proc(items_count : i32, items_height : f32, out_items_display_start : ^i32, out_items_display_end : ^i32) ---;
	igCalcTextSize                         :: proc(text : cstring, text_end : cstring = nil, hide_text_after_double_hash : bool = false, wrap_width : f32 = -1.0) -> Vec2 ---;
	igCaptureKeyboardFromApp               :: proc(want_capture_keyboard_value : bool = true) ---;
	igCaptureMouseFromApp                  :: proc(want_capture_mouse_value : bool = true) ---;
	igCheckbox                             :: proc(label : cstring, v : ^bool) -> bool ---;
	igCheckboxFlags                        :: proc(label : cstring, flags : ^u32, flags_value : u32) -> bool ---;
	igCloseCurrentPopup                    :: proc() ---;
	igCollapsingHeader                     :: proc(label : cstring, flags : Tree_Node_Flags = 0) -> bool ---;
	igCollapsingHeaderBoolPtr              :: proc(label : cstring, p_open : ^bool, flags : Tree_Node_Flags = 0) -> bool ---;
	igColorButton                          :: proc(desc_id : cstring, col : Vec4, flags : Color_Edit_Flags = 0, size := Vec2{0,0}) -> bool ---;
	igColorConvertFloat4ToU32              :: proc(in_ : Vec4) -> u32 ---;
	igColorConvertHSVtoRGB                 :: proc(h : f32, s : f32, v : f32, out_r : ^f32, out_g : ^f32, out_b : ^f32) ---;
	igColorConvertRGBtoHSV                 :: proc(r : f32, g : f32, b : f32, out_h : ^f32, out_s : ^f32, out_v : ^f32) ---;
	igColorConvertU32ToFloat4              :: proc(in_ : u32) -> Vec4 ---;
	igColorEdit3                           :: proc(label : cstring, col : [3]f32, flags : Color_Edit_Flags = 0) -> bool ---;
	igColorEdit4                           :: proc(label : cstring, col : [4]f32, flags : Color_Edit_Flags = 0) -> bool ---;
	igColorPicker3                         :: proc(label : cstring, col : [3]f32, flags : Color_Edit_Flags = 0) -> bool ---;
	igColorPicker4                         :: proc(label : cstring, col : [4]f32, flags : Color_Edit_Flags = 0, ref_col : ^f32 = nil) -> bool ---;
	igColumns                              :: proc(count : i32 = 1, id : cstring = nil, border : bool = true) ---;
	igCombo                                :: proc(label : cstring, current_item : ^i32, items : ^cstring, items_count : i32, popup_max_height_in_items : i32 = -1) -> bool ---;
	igComboStr                             :: proc(label : cstring, current_item : ^i32, items_separated_by_zeros : cstring, popup_max_height_in_items : i32 = -1) -> bool ---;
	igComboFnPtr                           :: proc(label : cstring, current_item : ^i32, items_getter : proc "c"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, popup_max_height_in_items : i32 = -1) -> bool ---;
	igCreateContext                        :: proc(shared_font_atlas : ^Font_Atlas = nil) -> ^Context ---;
	igDebugCheckVersionAndDataLayout       :: proc(version_str : cstring, sz_io : uint, sz_style : uint, sz_vec2 : uint, sz_vec4 : uint, sz_drawvert : uint, sz_drawidx : uint) -> bool ---;
	igDestroyContext                       :: proc(ctx : ^Context = nil) ---;
	igDragFloat                            :: proc(label : cstring, v : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igDragFloat2                           :: proc(label : cstring, v : [2]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igDragFloat3                           :: proc(label : cstring, v : [3]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igDragFloat4                           :: proc(label : cstring, v : [4]f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igDragFloatRange2                      :: proc(label : cstring, v_current_min : ^f32, v_current_max : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", format_max : cstring = nil, power : f32 = 1.0) -> bool ---;
	igDragInt                              :: proc(label : cstring, v : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool ---;
	igDragInt2                             :: proc(label : cstring, v : [2]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool ---;
	igDragInt3                             :: proc(label : cstring, v : [3]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool ---;
	igDragInt4                             :: proc(label : cstring, v : [4]i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool ---;
	igDragIntRange2                        :: proc(label : cstring, v_current_min : ^i32, v_current_max : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d", format_max : cstring = nil) -> bool ---;
	igDragScalar                           :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	igDragScalarN                          :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, components : i32, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	igDummy                                :: proc(size : Vec2) ---;
	igEnd                                  :: proc() ---;
	igEndChild                             :: proc() ---;
	igEndChildFrame                        :: proc() ---;
	igEndCombo                             :: proc() ---;
	igEndDragDropSource                    :: proc() ---;
	igEndDragDropTarget                    :: proc() ---;
	igEndFrame                             :: proc() ---;
	igEndGroup                             :: proc() ---;
	igEndMainMenuBar                       :: proc() ---;
	igEndMenu                              :: proc() ---;
	igEndMenuBar                           :: proc() ---;
	igEndPopup                             :: proc() ---;
	igEndTabBar                            :: proc() ---;
	igEndTabItem                           :: proc() ---;
	igEndTooltip                           :: proc() ---;
	igGetBackgroundDrawList                :: proc() -> ^Draw_List ---;
	igGetClipboardText                     :: proc() -> cstring ---;
	igGetColorU32                          :: proc(idx : Col, alpha_mul : f32 = 1.0) -> u32 ---;
	igGetColorU32Vec4                      :: proc(col : Vec4) -> u32 ---;
	igGetColorU32U32                       :: proc(col : u32) -> u32 ---;
	igGetColumnIndex                       :: proc() -> i32 ---;
	igGetColumnOffset                      :: proc(column_index : i32 = -1) -> f32 ---;
	igGetColumnWidth                       :: proc(column_index : i32 = -1) -> f32 ---;
	igGetColumnsCount                      :: proc() -> i32 ---;
	igGetContentRegionAvail                :: proc() -> Vec2 ---;
	igGetContentRegionMax                  :: proc() -> Vec2 ---;
	igGetCurrentContext                    :: proc() -> ^Context ---;
	igGetCursorPos                         :: proc() -> Vec2 ---;
	igGetCursorPosX                        :: proc() -> f32 ---;
	igGetCursorPosY                        :: proc() -> f32 ---;
	igGetCursorScreenPos                   :: proc() -> Vec2 ---;
	igGetCursorStartPos                    :: proc() -> Vec2 ---;
	igGetDragDropPayload                   :: proc() -> ^Payload ---;
	igGetDrawData                          :: proc() -> ^Draw_Data ---;
	igGetDrawListSharedData                :: proc() -> ^Draw_List_Shared_Data ---;
	igGetFont                              :: proc() -> ^Font ---;
	igGetFontSize                          :: proc() -> f32 ---;
	igGetFontTexUvWhitePixel               :: proc() -> Vec2 ---;
	igGetForegroundDrawList                :: proc() -> ^Draw_List ---;
	igGetFrameCount                        :: proc() -> i32 ---;
	igGetFrameHeight                       :: proc() -> f32 ---;
	igGetFrameHeightWithSpacing            :: proc() -> f32 ---;
	igGetIDStr                             :: proc(str_id : cstring) -> ID ---;
	igGetIDRange                           :: proc(str_id_begin : cstring, str_id_end : cstring) -> ID ---;
	igGetIDPtr                             :: proc(ptr_id : rawptr) -> ID ---;
	igGetIO                                :: proc() -> ^io ---;
	igGetItemRectMax                       :: proc() -> Vec2 ---;
	igGetItemRectMin                       :: proc() -> Vec2 ---;
	igGetItemRectSize                      :: proc() -> Vec2 ---;
	igGetKeyIndex                          :: proc(imgui_key : Key) -> i32 ---;
	igGetKeyPressedAmount                  :: proc(key_index : i32, repeat_delay : f32, rate : f32) -> i32 ---;
	igGetMouseCursor                       :: proc() -> Mouse_Cursor ---;
	igGetMouseDragDelta                    :: proc(button : i32 = 0, lock_threshold : f32 = -1.0) -> Vec2 ---;
	igGetMousePos                          :: proc() -> Vec2 ---;
	igGetMousePosOnOpeningCurrentPopup     :: proc() -> Vec2 ---;
	igGetScrollMaxX                        :: proc() -> f32 ---;
	igGetScrollMaxY                        :: proc() -> f32 ---;
	igGetScrollX                           :: proc() -> f32 ---;
	igGetScrollY                           :: proc() -> f32 ---;
	igGetStateStorage                      :: proc() -> ^Storage ---;
	igGetStyle                             :: proc() -> ^Style ---;
	igGetStyleColorName                    :: proc(idx : Col) -> cstring ---;
	igGetStyleColorVec4                    :: proc(idx : Col) -> ^Vec4 ---;
	igGetTextLineHeight                    :: proc() -> f32 ---;
	igGetTextLineHeightWithSpacing         :: proc() -> f32 ---;
	igGetTime                              :: proc() -> f64 ---;
	igGetTreeNodeToLabelSpacing            :: proc() -> f32 ---;
	igGetVersion                           :: proc() -> cstring ---;
	igGetWindowContentRegionMax            :: proc() -> Vec2 ---;
	igGetWindowContentRegionMin            :: proc() -> Vec2 ---;
	igGetWindowContentRegionWidth          :: proc() -> f32 ---;
	igGetWindowDrawList                    :: proc() -> ^Draw_List ---;
	igGetWindowHeight                      :: proc() -> f32 ---;
	igGetWindowPos                         :: proc() -> Vec2 ---;
	igGetWindowSize                        :: proc() -> Vec2 ---;
	igGetWindowWidth                       :: proc() -> f32 ---;
	igImage                                :: proc(user_texture_id : Texture_ID, size : Vec2, uv0 := Vec2{0,0}, uv1 := Vec2{1,1}, tint_col := Vec4{1,1,1,1}, border_col := Vec4{0,0,0,0}) ---;
	igImageButton                          :: proc(user_texture_id : Texture_ID, size : Vec2, uv0 := Vec2{0,0}, uv1 := Vec2{1,1}, frame_padding : i32 = -1, bg_col := Vec4{0,0,0,0}, tint_col := Vec4{1,1,1,1}) -> bool ---;
	igIndent                               :: proc(indent_w : f32 = 0.0) ---;
	igInputDouble                          :: proc(label : cstring, v : ^f64, step : f64 = 0.0, step_fast : f64 = 0.0, format : cstring = "%.6f", flags : Input_Text_Flags = 0) -> bool ---;
	igInputFloat                           :: proc(label : cstring, v : ^f32, step : f32 = 0.0, step_fast : f32 = 0.0, format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool ---;
	igInputFloat2                          :: proc(label : cstring, v : [2]f32, format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool ---;
	igInputFloat3                          :: proc(label : cstring, v : [3]f32, format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool ---;
	igInputFloat4                          :: proc(label : cstring, v : [4]f32, format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool ---;
	igInputInt                             :: proc(label : cstring, v : ^i32, step : i32 = 1, step_fast : i32 = 100, flags : Input_Text_Flags = 0) -> bool ---;
	igInputInt2                            :: proc(label : cstring, v : [2]i32, flags : Input_Text_Flags = 0) -> bool ---;
	igInputInt3                            :: proc(label : cstring, v : [3]i32, flags : Input_Text_Flags = 0) -> bool ---;
	igInputInt4                            :: proc(label : cstring, v : [4]i32, flags : Input_Text_Flags = 0) -> bool ---;
	igInputScalar                          :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, p_step : rawptr = nil, p_step_fast : rawptr = nil, format : cstring = nil, flags : Input_Text_Flags = 0) -> bool ---;
	igInputScalarN                         :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, components : i32, p_step : rawptr = nil, p_step_fast : rawptr = nil, format : cstring = nil, flags : Input_Text_Flags = 0) -> bool ---;
	igInputText                            :: proc(label : cstring, buf : ^i8, buf_size : uint, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool ---;
	igInputTextMultiline                   :: proc(label : cstring, buf : ^i8, buf_size : uint, size := Vec2{0,0}, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool ---;
	igInputTextWithHint                    :: proc(label : cstring, hint : cstring, buf : ^i8, buf_size : uint, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool ---;
	igInvisibleButton                      :: proc(str_id : cstring, size : Vec2) -> bool ---;
	igIsAnyItemActive                      :: proc() -> bool ---;
	igIsAnyItemFocused                     :: proc() -> bool ---;
	igIsAnyItemHovered                     :: proc() -> bool ---;
	igIsAnyMouseDown                       :: proc() -> bool ---;
	igIsItemActivated                      :: proc() -> bool ---;
	igIsItemActive                         :: proc() -> bool ---;
	igIsItemClicked                        :: proc(mouse_button : i32 = 0) -> bool ---;
	igIsItemDeactivated                    :: proc() -> bool ---;
	igIsItemDeactivatedAfterEdit           :: proc() -> bool ---;
	igIsItemEdited                         :: proc() -> bool ---;
	igIsItemFocused                        :: proc() -> bool ---;
	igIsItemHovered                        :: proc(flags : Hovered_Flags = 0) -> bool ---;
	igIsItemToggledOpen                    :: proc() -> bool ---;
	igIsItemVisible                        :: proc() -> bool ---;
	igIsKeyDown                            :: proc(user_key_index : i32) -> bool ---;
	igIsKeyPressed                         :: proc(user_key_index : i32, repeat : bool = true) -> bool ---;
	igIsKeyReleased                        :: proc(user_key_index : i32) -> bool ---;
	igIsMouseClicked                       :: proc(button : i32, repeat : bool = false) -> bool ---;
	igIsMouseDoubleClicked                 :: proc(button : i32) -> bool ---;
	igIsMouseDown                          :: proc(button : i32) -> bool ---;
	igIsMouseDragging                      :: proc(button : i32 = 0, lock_threshold : f32 = -1.0) -> bool ---;
	igIsMouseHoveringRect                  :: proc(r_min : Vec2, r_max : Vec2, clip : bool = true) -> bool ---;
	igIsMousePosValid                      :: proc(mouse_pos : ^Vec2 = nil) -> bool ---;
	igIsMouseReleased                      :: proc(button : i32) -> bool ---;
	igIsPopupOpen                          :: proc(str_id : cstring) -> bool ---;
	igIsRectVisible                        :: proc(size : Vec2) -> bool ---;
	igIsRectVisibleVec2                    :: proc(rect_min : Vec2, rect_max : Vec2) -> bool ---;
	igIsWindowAppearing                    :: proc() -> bool ---;
	igIsWindowCollapsed                    :: proc() -> bool ---;
	igIsWindowFocused                      :: proc(flags : Focused_Flags = 0) -> bool ---;
	igIsWindowHovered                      :: proc(flags : Hovered_Flags = 0) -> bool ---;
	igLabelText                            :: proc(label : cstring, format : cstring, #c_vararg args : ..any) ---;
	igListBoxStr_arr                       :: proc(label : cstring, current_item : ^i32, items : ^cstring, items_count : i32, height_in_items : i32 = -1) -> bool ---;
	igListBoxFnPtr                         :: proc(label : cstring, current_item : ^i32, items_getter : proc "c"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, height_in_items : i32 = -1) -> bool ---;
	igListBoxFooter                        :: proc() ---;
	igListBoxHeaderVec2                    :: proc(label : cstring, size := Vec2{0,0}) -> bool ---;
	igListBoxHeaderInt                     :: proc(label : cstring, items_count : i32, height_in_items : i32 = -1) -> bool ---;
	igLoadIniSettingsFromDisk              :: proc(ini_filename : cstring) ---;
	igLoadIniSettingsFromMemory            :: proc(ini_data : cstring, ini_size : uint = 0) ---;
	igLogButtons                           :: proc() ---;
	igLogFinish                            :: proc() ---;
	igLogText                              :: proc(format : cstring, #c_vararg args : ..any) ---;
	igLogToClipboard                       :: proc(auto_open_depth : i32 = -1) ---;
	igLogToFile                            :: proc(auto_open_depth : i32 = -1, filename : cstring = nil) ---;
	igLogToTTY                             :: proc(auto_open_depth : i32 = -1) ---;
	igMemAlloc                             :: proc(size : uint) -> rawptr ---;
	igMemFree                              :: proc(ptr : rawptr) ---;
	igMenuItemBool                         :: proc(label : cstring, shortcut : cstring = nil, selected : bool = false, enabled : bool = true) -> bool ---;
	igMenuItemBoolPtr                      :: proc(label : cstring, shortcut : cstring, p_selected : ^bool, enabled : bool = true) -> bool ---;
	igNewFrame                             :: proc() ---;
	igNewLine                              :: proc() ---;
	igNextColumn                           :: proc() ---;
	igOpenPopup                            :: proc(str_id : cstring) ---;
	igOpenPopupOnItemClick                 :: proc(str_id : cstring = nil, mouse_button : i32 = 1) -> bool ---;
	igPlotHistogramFloatPtr                :: proc(label : cstring, values : ^f32, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}, stride := size_of(f32)) ---;
	igPlotHistogramFnPtr                   :: proc(label : cstring, values_getter : proc "c"(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}) ---;
	igPlotLines                            :: proc(label : cstring, values : ^f32, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}, stride := size_of(f32)) ---;
	igPlotLinesFnPtr                       :: proc(label : cstring, values_getter : proc "c"(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}) ---;
	igPopAllowKeyboardFocus                :: proc() ---;
	igPopButtonRepeat                      :: proc() ---;
	igPopClipRect                          :: proc() ---;
	igPopFont                              :: proc() ---;
	igPopID                                :: proc() ---;
	igPopItemWidth                         :: proc() ---;
	igPopStyleColor                        :: proc(count : i32 = 1) ---;
	igPopStyleVar                          :: proc(count : i32 = 1) ---;
	igPopTextWrapPos                       :: proc() ---;
	igProgressBar                          :: proc(fraction : f32, size_arg := Vec2{-1,0}, overlay : cstring = nil) ---;
	igPushAllowKeyboardFocus               :: proc(allow_keyboard_focus : bool) ---;
	igPushButtonRepeat                     :: proc(repeat : bool) ---;
	igPushClipRect                         :: proc(clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) ---;
	igPushFont                             :: proc(font : ^Font) ---;
	igPushIDStr                            :: proc(str_id : cstring) ---;
	igPushIDRange                          :: proc(str_id_begin : cstring, str_id_end : cstring) ---;
	igPushIDPtr                            :: proc(ptr_id : rawptr) ---;
	igPushIDInt                            :: proc(int_id : i32) ---;
	igPushItemWidth                        :: proc(item_width : f32) ---;
	igPushStyleColorU32                    :: proc(idx : Col, col : u32) ---;
	igPushStyleColor                       :: proc(idx : Col, col : Vec4) ---;
	igPushStyleVarFloat                    :: proc(idx : Style_Var, val : f32) ---;
	igPushStyleVarVec2                     :: proc(idx : Style_Var, val : Vec2) ---;
	igPushTextWrapPos                      :: proc(wrap_local_pos_x : f32 = 0.0) ---;
	igRadioButtonBool                      :: proc(label : cstring, active : bool) -> bool ---;
	igRadioButtonIntPtr                    :: proc(label : cstring, v : ^i32, v_button : i32) -> bool ---;
	igRender                               :: proc() ---;
	igResetMouseDragDelta                  :: proc(button : i32 = 0) ---;
	igSameLine                             :: proc(offset_from_start_x : f32 = 0.0, spacing : f32 = -1.0) ---;
	igSaveIniSettingsToDisk                :: proc(ini_filename : cstring) ---;
	igSaveIniSettingsToMemory              :: proc(out_ini_size : ^uint = nil) -> cstring ---;
	igSelectable                           :: proc(label : cstring, selected : bool = false, flags : Selectable_Flags = 0, size := Vec2{0,0}) -> bool ---;
	igSelectableBoolPtr                    :: proc(label : cstring, p_selected : ^bool, flags : Selectable_Flags = 0, size := Vec2{0,0}) -> bool ---;
	igSeparator                            :: proc() ---;
	igSetAllocatorFunctions                :: proc(alloc_func : proc "c"(sz : uint, user_date : rawptr) -> rawptr, free_func : proc "c"(ptr : rawptr, user_date : rawptr) -> rawptr, user_data : rawptr = nil) ---;
	igSetClipboardText                     :: proc(text : cstring) ---;
	igSetColorEditOptions                  :: proc(flags : Color_Edit_Flags) ---;
	igSetColumnOffset                      :: proc(column_index : i32, offset_x : f32) ---;
	igSetColumnWidth                       :: proc(column_index : i32, width : f32) ---;
	igSetCurrentContext                    :: proc(ctx : ^Context) ---;
	igSetCursorPos                         :: proc(local_pos : Vec2) ---;
	igSetCursorPosX                        :: proc(local_x : f32) ---;
	igSetCursorPosY                        :: proc(local_y : f32) ---;
	igSetCursorScreenPos                   :: proc(pos : Vec2) ---;
	igSetDragDropPayload                   :: proc(type : cstring, data : rawptr, sz : uint, cond : Cond = 0) -> bool ---;
	igSetItemAllowOverlap                  :: proc() ---;
	igSetItemDefaultFocus                  :: proc() ---;
	igSetKeyboardFocusHere                 :: proc(offset : i32 = 0) ---;
	igSetMouseCursor                       :: proc(type : Mouse_Cursor) ---;
	igSetNextItemOpen                      :: proc(is_open : bool, cond : Cond = 0) ---;
	igSetNextItemWidth                     :: proc(item_width : f32) ---;
	igSetNextWindowBgAlpha                 :: proc(alpha : f32) ---;
	igSetNextWindowCollapsed               :: proc(collapsed : bool, cond : Cond = 0) ---;
	igSetNextWindowContentSize             :: proc(size : Vec2) ---;
	igSetNextWindowFocus                   :: proc() ---;
	igSetNextWindowPos                     :: proc(pos : Vec2, cond : Cond = 0, pivot := Vec2{0,0}) ---;
	igSetNextWindowSize                    :: proc(size : Vec2, cond : Cond = 0) ---;
	igSetNextWindowSizeConstraints         :: proc(size_min : Vec2, size_max : Vec2, custom_callback : Size_Callback = nil, custom_callback_data : rawptr = nil) ---;
	igSetScrollFromPosX                    :: proc(local_x : f32, center_x_ratio : f32 = 0.5) ---;
	igSetScrollFromPosY                    :: proc(local_y : f32, center_y_ratio : f32 = 0.5) ---;
	igSetScrollHereX                       :: proc(center_x_ratio : f32 = 0.5) ---;
	igSetScrollHereY                       :: proc(center_y_ratio : f32 = 0.5) ---;
	igSetScrollX                           :: proc(scroll_x : f32) ---;
	igSetScrollY                           :: proc(scroll_y : f32) ---;
	igSetStateStorage                      :: proc(storage : ^Storage) ---;
	igSetTabItemClosed                     :: proc(tab_or_docked_window_label : cstring) ---;
	igSetTooltip                           :: proc(format : cstring, #c_vararg args : ..any) ---;
	igSetWindowCollapsedBool               :: proc(collapsed : bool, cond : Cond = 0) ---;
	igSetWindowCollapsedStr                :: proc(name : cstring, collapsed : bool, cond : Cond = 0) ---;
	igSetWindowFocus                       :: proc() ---;
	igSetWindowFocusStr                    :: proc(name : cstring) ---;
	igSetWindowFontScale                   :: proc(scale : f32) ---;
	igSetWindowPosVec2                     :: proc(pos : Vec2, cond : Cond = 0) ---;
	igSetWindowPosStr                      :: proc(name : cstring, pos : Vec2, cond : Cond = 0) ---;
	igSetWindowSizeVec2                    :: proc(size : Vec2, cond : Cond = 0) ---;
	igSetWindowSizeStr                     :: proc(name : cstring, size : Vec2, cond : Cond = 0) ---;
	igShowAboutWindow                      :: proc(p_open : ^bool = nil) ---;
	igShowDemoWindow                       :: proc(p_open : ^bool = nil) ---;
	igShowFontSelector                     :: proc(label : cstring) ---;
	igShowMetricsWindow                    :: proc(p_open : ^bool = nil) ---;
	igShowStyleEditor                      :: proc(ref : ^Style = nil) ---;
	igShowStyleSelector                    :: proc(label : cstring) -> bool ---;
	igShowUserGuide                        :: proc() ---;
	igSliderAngle                          :: proc(label : cstring, v_rad : ^f32, v_degrees_min : f32 = -360.0, v_degrees_max : f32 = +360.0, format : cstring = "%.0f deg") -> bool ---;
	igSliderFloat                          :: proc(label : cstring, v : ^f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igSliderFloat2                         :: proc(label : cstring, v : [2]f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igSliderFloat3                         :: proc(label : cstring, v : [3]f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igSliderFloat4                         :: proc(label : cstring, v : [4]f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igSliderInt                            :: proc(label : cstring, v : ^i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	igSliderInt2                           :: proc(label : cstring, v : [2]i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	igSliderInt3                           :: proc(label : cstring, v : [3]i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	igSliderInt4                           :: proc(label : cstring, v : [4]i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	igSliderScalar                         :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	igSliderScalarN                        :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, components : i32, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	igSmallButton                          :: proc(label : cstring) -> bool ---;
	igSpacing                              :: proc() ---;
	igStyleColorsClassic                   :: proc(dst : ^Style = nil) ---;
	igStyleColorsDark                      :: proc(dst : ^Style = nil) ---;
	igStyleColorsLight                     :: proc(dst : ^Style = nil) ---;
	igText                                 :: proc(format : cstring, #c_vararg args : ..any) ---;
	igTextColored                          :: proc(col : Vec4, format : cstring, #c_vararg args : ..any) ---;
	igTextDisabled                         :: proc(format : cstring, #c_vararg args : ..any) ---;
	igTextUnformatted                      :: proc(text : cstring, text_end : cstring = nil) ---;
	igTextWrapped                          :: proc(format : cstring, #c_vararg args : ..any) ---;
	igTreeNodeStr                          :: proc(label : cstring) -> bool ---;
	igTreeNodeStrStr                       :: proc(str_id : cstring, format : cstring, #c_vararg args : ..any) -> bool ---;
	igTreeNodePtr                          :: proc(ptr_id : rawptr, format : cstring, #c_vararg args : ..any) -> bool ---;
	igTreeNodeExStr                        :: proc(label : cstring, flags : Tree_Node_Flags = 0) -> bool ---;
	igTreeNodeExStrStr                     :: proc(str_id : cstring, flags : Tree_Node_Flags, format : cstring, #c_vararg args : ..any) -> bool ---;
	igTreeNodeExPtr                        :: proc(ptr_id : rawptr, flags : Tree_Node_Flags, format : cstring, #c_vararg args : ..any) -> bool ---;
	igTreePop                              :: proc() ---;
	igTreePushStr                          :: proc(str_id : cstring) ---;
	igTreePushPtr                          :: proc(ptr_id : rawptr = nil) ---;
	igUnindent                             :: proc(indent_w : f32 = 0.0) ---;
	igVSliderFloat                         :: proc(label : cstring, size : Vec2, v : ^f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	igVSliderInt                           :: proc(label : cstring, size : Vec2, v : ^i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	igVSliderScalar                        :: proc(label : cstring, size : Vec2, data_type : Data_Type, p_data : rawptr, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	igValueBool                            :: proc(prefix : cstring, b : bool) ---;
	igValueInt                             :: proc(prefix : cstring, v : i32) ---;
	igValueUint                            :: proc(prefix : cstring, v : u32) ---;
	igValueFloat                           :: proc(prefix : cstring, v : f32, float_format : cstring = nil) ---;
}

