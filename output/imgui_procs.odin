package imgui;

when ODIN_DEBUG {
    foreign import cimgui "external/cimgui_debug.lib";
} else {
    foreign import "external/cimgui.lib";
}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImColor_HSV")    color_hsv     :: proc(self : ^Color, h : f32, s : f32, v : f32, a : f32 = 1.0) -> Color ---;
	@(link_name = "ImColor_SetHSV") color_set_hsv :: proc(self : ^Color, h : f32, s : f32, v : f32, a : f32 = 1.0) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImDrawData_Clear")             draw_data_clear                :: proc(self : ^Draw_Data) ---;
	@(link_name = "ImDrawData_DeIndexAllBuffers") draw_data_de_index_all_buffers :: proc(self : ^Draw_Data) ---;
	@(link_name = "ImDrawData_ScaleClipRects")    draw_data_scale_clip_rects     :: proc(self : ^Draw_Data, fb_scale : Vec2) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImDrawListSplitter_Clear")             draw_list_splitter_clear               :: proc(self : ^Draw_List_Splitter) ---;
	@(link_name = "ImDrawListSplitter_ClearFreeMemory")   draw_list_splitter_clear_free_memory   :: proc(self : ^Draw_List_Splitter) ---;
	@(link_name = "ImDrawListSplitter_Merge")             draw_list_splitter_merge               :: proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List) ---;
	@(link_name = "ImDrawListSplitter_SetCurrentChannel") draw_list_splitter_set_current_channel :: proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List, channel_idx : i32) ---;
	@(link_name = "ImDrawListSplitter_Split")             draw_list_splitter_split               :: proc(self : ^Draw_List_Splitter, draw_list : ^Draw_List, count : i32) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImDrawList_AddBezierCurve")           draw_list_add_bezier_curve             :: proc(self : ^Draw_List, pos0 : Vec2, cp0 : Vec2, cp1 : Vec2, pos1 : Vec2, col : u32, thickness : f32, num_segments : i32 = 0) ---;
	@(link_name = "ImDrawList_AddCallback")              draw_list_add_callback                 :: proc(self : ^Draw_List, callback : Draw_Callback, callback_data : rawptr) ---;
	@(link_name = "ImDrawList_AddCircle")                draw_list_add_circle                   :: proc(self : ^Draw_List, center : Vec2, radius : f32, col : u32, num_segments : i32 = 12, thickness : f32 = 1.0) ---;
	@(link_name = "ImDrawList_AddCircleFilled")          draw_list_add_circle_filled            :: proc(self : ^Draw_List, center : Vec2, radius : f32, col : u32, num_segments : i32 = 12) ---;
	@(link_name = "ImDrawList_AddConvexPolyFilled")      draw_list_add_convex_poly_filled       :: proc(self : ^Draw_List, points : ^Vec2, num_points : i32, col : u32) ---;
	@(link_name = "ImDrawList_AddDrawCmd")               draw_list_add_draw_cmd                 :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_AddImage")                 draw_list_add_image                    :: proc(self : ^Draw_List, user_texture_id : Texture_ID, p_min : Vec2, p_max : Vec2, uv_min := Vec2{0,0}, uv_max := Vec2{1,1}, col : u32 = 0xffffffff) ---;
	@(link_name = "ImDrawList_AddImageQuad")             draw_list_add_image_quad               :: proc(self : ^Draw_List, user_texture_id : Texture_ID, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, uv1 := Vec2{0,0}, uv2 := Vec2{1,0}, uv3 := Vec2{1,1}, uv4 := Vec2{0,1}, col : u32 = 0xffffffff) ---;
	@(link_name = "ImDrawList_AddImageRounded")          draw_list_add_image_rounded            :: proc(self : ^Draw_List, user_texture_id : Texture_ID, p_min : Vec2, p_max : Vec2, uv_min : Vec2, uv_max : Vec2, col : u32, rounding : f32, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) ---;
	@(link_name = "ImDrawList_AddLine")                  draw_list_add_line                     :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, col : u32, thickness : f32 = 1.0) ---;
	@(link_name = "ImDrawList_AddPolyline")              draw_list_add_polyline                 :: proc(self : ^Draw_List, points : ^Vec2, num_points : i32, col : u32, closed : bool, thickness : f32) ---;
	@(link_name = "ImDrawList_AddQuad")                  draw_list_add_quad                     :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, col : u32, thickness : f32 = 1.0) ---;
	@(link_name = "ImDrawList_AddQuadFilled")            draw_list_add_quad_filled              :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, p4 : Vec2, col : u32) ---;
	@(link_name = "ImDrawList_AddRect")                  draw_list_add_rect                     :: proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col : u32, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All, thickness : f32 = 1.0) ---;
	@(link_name = "ImDrawList_AddRectFilled")            draw_list_add_rect_filled              :: proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col : u32, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) ---;
	@(link_name = "ImDrawList_AddRectFilledMultiColor")  draw_list_add_rect_filled_multi_color  :: proc(self : ^Draw_List, p_min : Vec2, p_max : Vec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32) ---;
	@(link_name = "ImDrawList_AddText")                  draw_list_add_text                     :: proc(self : ^Draw_List, pos : Vec2, col : u32, text_begin : cstring, text_end : cstring = nil) ---;
	@(link_name = "ImDrawList_AddTextFontPtr")           draw_list_add_text                     :: proc(self : ^Draw_List, font : ^Font, font_size : f32, pos : Vec2, col : u32, text_begin : cstring, text_end : cstring = nil, wrap_width : f32 = 0.0, cpu_fine_clip_rect : ^Vec4 = nil) ---;
	@(link_name = "ImDrawList_AddTriangle")              draw_list_add_triangle                 :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, col : u32, thickness : f32 = 1.0) ---;
	@(link_name = "ImDrawList_AddTriangleFilled")        draw_list_add_triangle_filled          :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, col : u32) ---;
	@(link_name = "ImDrawList_ChannelsMerge")            draw_list_channels_merge               :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_ChannelsSetCurrent")       draw_list_channels_set_current         :: proc(self : ^Draw_List, n : i32) ---;
	@(link_name = "ImDrawList_ChannelsSplit")            draw_list_channels_split               :: proc(self : ^Draw_List, count : i32) ---;
	@(link_name = "ImDrawList_Clear")                    draw_list_clear                        :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_ClearFreeMemory")          draw_list_clear_free_memory            :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_CloneOutput")              draw_list_clone_output                 :: proc(self : ^Draw_List) -> ^Draw_List ---;
	@(link_name = "ImDrawList_GetClipRectMax")           draw_list_get_clip_rect_max            :: proc(self : ^Draw_List) -> Vec2 ---;
	@(link_name = "ImDrawList_GetClipRectMin")           draw_list_get_clip_rect_min            :: proc(self : ^Draw_List) -> Vec2 ---;
	@(link_name = "ImDrawList_PathArcTo")                draw_list_path_arc_to                  :: proc(self : ^Draw_List, center : Vec2, radius : f32, a_min : f32, a_max : f32, num_segments : i32 = 10) ---;
	@(link_name = "ImDrawList_PathArcToFast")            draw_list_path_arc_to_fast             :: proc(self : ^Draw_List, center : Vec2, radius : f32, a_min_of_12 : i32, a_max_of_12 : i32) ---;
	@(link_name = "ImDrawList_PathBezierCurveTo")        draw_list_path_bezier_curve_to         :: proc(self : ^Draw_List, p1 : Vec2, p2 : Vec2, p3 : Vec2, num_segments : i32 = 0) ---;
	@(link_name = "ImDrawList_PathClear")                draw_list_path_clear                   :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_PathFillConvex")           draw_list_path_fill_convex             :: proc(self : ^Draw_List, col : u32) ---;
	@(link_name = "ImDrawList_PathLineTo")               draw_list_path_line_to                 :: proc(self : ^Draw_List, pos : Vec2) ---;
	@(link_name = "ImDrawList_PathLineToMergeDuplicate") draw_list_path_line_to_merge_duplicate :: proc(self : ^Draw_List, pos : Vec2) ---;
	@(link_name = "ImDrawList_PathRect")                 draw_list_path_rect                    :: proc(self : ^Draw_List, rect_min : Vec2, rect_max : Vec2, rounding : f32 = 0.0, rounding_corners : Draw_Corner_Flags = DrawCornerFlags_All) ---;
	@(link_name = "ImDrawList_PathStroke")               draw_list_path_stroke                  :: proc(self : ^Draw_List, col : u32, closed : bool, thickness : f32 = 1.0) ---;
	@(link_name = "ImDrawList_PopClipRect")              draw_list_pop_clip_rect                :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_PopTextureID")             draw_list_pop_texture_id               :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_PrimQuadUV")               draw_list_prim_quad_uv                 :: proc(self : ^Draw_List, a : Vec2, b : Vec2, c : Vec2, d : Vec2, uv_a : Vec2, uv_b : Vec2, uv_c : Vec2, uv_d : Vec2, col : u32) ---;
	@(link_name = "ImDrawList_PrimRect")                 draw_list_prim_rect                    :: proc(self : ^Draw_List, a : Vec2, b : Vec2, col : u32) ---;
	@(link_name = "ImDrawList_PrimRectUV")               draw_list_prim_rect_uv                 :: proc(self : ^Draw_List, a : Vec2, b : Vec2, uv_a : Vec2, uv_b : Vec2, col : u32) ---;
	@(link_name = "ImDrawList_PrimReserve")              draw_list_prim_reserve                 :: proc(self : ^Draw_List, idx_count : i32, vtx_count : i32) ---;
	@(link_name = "ImDrawList_PrimVtx")                  draw_list_prim_vtx                     :: proc(self : ^Draw_List, pos : Vec2, uv : Vec2, col : u32) ---;
	@(link_name = "ImDrawList_PrimWriteIdx")             draw_list_prim_write_idx               :: proc(self : ^Draw_List, idx : Draw_Idx) ---;
	@(link_name = "ImDrawList_PrimWriteVtx")             draw_list_prim_write_vtx               :: proc(self : ^Draw_List, pos : Vec2, uv : Vec2, col : u32) ---;
	@(link_name = "ImDrawList_PushClipRect")             draw_list_push_clip_rect               :: proc(self : ^Draw_List, clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool = false) ---;
	@(link_name = "ImDrawList_PushClipRectFullScreen")   draw_list_push_clip_rect_full_screen   :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_PushTextureID")            draw_list_push_texture_id              :: proc(self : ^Draw_List, texture_id : Texture_ID) ---;
	@(link_name = "ImDrawList_UpdateClipRect")           draw_list_update_clip_rect             :: proc(self : ^Draw_List) ---;
	@(link_name = "ImDrawList_UpdateTextureID")          draw_list_update_texture_id            :: proc(self : ^Draw_List) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImFontAtlasCustomRect_IsPacked") font_atlas_custom_rect_is_packed :: proc(self : ^Font_Atlas_Custom_Rect) -> bool ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImFontAtlas_AddCustomRectFontGlyph")                font_atlas_add_custom_rect_font_glyph                  :: proc(self : ^Font_Atlas, font : ^Font, id : Wchar, width : i32, height : i32, advance_x : f32, offset := Vec2{0,0}) -> i32 ---;
	@(link_name = "ImFontAtlas_AddCustomRectRegular")                  font_atlas_add_custom_rect_regular                     :: proc(self : ^Font_Atlas, id : u32, width : i32, height : i32) -> i32 ---;
	@(link_name = "ImFontAtlas_AddFont")                               font_atlas_add_font                                    :: proc(self : ^Font_Atlas, font_cfg : ^Font_Config) -> ^Font ---;
	@(link_name = "ImFontAtlas_AddFontDefault")                        font_atlas_add_font_default                            :: proc(self : ^Font_Atlas, font_cfg : ^Font_Config = nil) -> ^Font ---;
	@(link_name = "ImFontAtlas_AddFontFromFileTTF")                    font_atlas_add_font_from_file_ttf                      :: proc(self : ^Font_Atlas, filename : cstring, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
	@(link_name = "ImFontAtlas_AddFontFromMemoryCompressedBase85TTF")  font_atlas_add_font_from_memory_compressed_base_85_ttf :: proc(self : ^Font_Atlas, compressed_font_data_base85 : cstring, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
	@(link_name = "ImFontAtlas_AddFontFromMemoryCompressedTTF")        font_atlas_add_font_from_memory_compressed_ttf         :: proc(self : ^Font_Atlas, compressed_font_data : rawptr, compressed_font_size : i32, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
	@(link_name = "ImFontAtlas_AddFontFromMemoryTTF")                  font_atlas_add_font_from_memory_ttf                    :: proc(self : ^Font_Atlas, font_data : rawptr, font_size : i32, size_pixels : f32, font_cfg : ^Font_Config = nil, glyph_ranges : ^Wchar = nil) -> ^Font ---;
	@(link_name = "ImFontAtlas_Build")                                 font_atlas_build                                       :: proc(self : ^Font_Atlas) -> bool ---;
	@(link_name = "ImFontAtlas_CalcCustomRectUV")                      font_atlas_calc_custom_rect_uv                         :: proc(self : ^Font_Atlas, rect : ^Font_Atlas_Custom_Rect, out_uv_min : ^Vec2, out_uv_max : ^Vec2) ---;
	@(link_name = "ImFontAtlas_Clear")                                 font_atlas_clear                                       :: proc(self : ^Font_Atlas) ---;
	@(link_name = "ImFontAtlas_ClearFonts")                            font_atlas_clear_fonts                                 :: proc(self : ^Font_Atlas) ---;
	@(link_name = "ImFontAtlas_ClearInputData")                        font_atlas_clear_input_data                            :: proc(self : ^Font_Atlas) ---;
	@(link_name = "ImFontAtlas_ClearTexData")                          font_atlas_clear_tex_data                              :: proc(self : ^Font_Atlas) ---;
	@(link_name = "ImFontAtlas_GetCustomRectByIndex")                  font_atlas_get_custom_rect_by_index                    :: proc(self : ^Font_Atlas, index : i32) -> ^Font_Atlas_Custom_Rect ---;
	@(link_name = "ImFontAtlas_GetGlyphRangesChineseFull")             font_atlas_get_glyph_ranges_chinese_full               :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	@(link_name = "ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon") font_atlas_get_glyph_ranges_chinese_simplified_common  :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	@(link_name = "ImFontAtlas_GetGlyphRangesCyrillic")                font_atlas_get_glyph_ranges_cyrillic                   :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	@(link_name = "ImFontAtlas_GetGlyphRangesDefault")                 font_atlas_get_glyph_ranges_default                    :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	@(link_name = "ImFontAtlas_GetGlyphRangesJapanese")                font_atlas_get_glyph_ranges_japanese                   :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	@(link_name = "ImFontAtlas_GetGlyphRangesKorean")                  font_atlas_get_glyph_ranges_korean                     :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	@(link_name = "ImFontAtlas_GetGlyphRangesThai")                    font_atlas_get_glyph_ranges_thai                       :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	@(link_name = "ImFontAtlas_GetGlyphRangesVietnamese")              font_atlas_get_glyph_ranges_vietnamese                 :: proc(self : ^Font_Atlas) -> ^Wchar ---;
	@(link_name = "ImFontAtlas_GetMouseCursorTexData")                 font_atlas_get_mouse_cursor_tex_data                   :: proc(self : ^Font_Atlas, cursor : Mouse_Cursor, out_offset : ^Vec2, out_size : ^Vec2, out_uv_border : Vec_2[2], out_uv_fill : Vec_2[2]) -> bool ---;
	@(link_name = "ImFontAtlas_GetTexDataAsAlpha8")                    font_atlas_get_tex_data_as_alpha_8                     :: proc(self : ^Font_Atlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) ---;
	@(link_name = "ImFontAtlas_GetTexDataAsRGBA32")                    font_atlas_get_tex_data_as_rgba_32                     :: proc(self : ^Font_Atlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32 = nil) ---;
	@(link_name = "ImFontAtlas_IsBuilt")                               font_atlas_is_built                                    :: proc(self : ^Font_Atlas) -> bool ---;
	@(link_name = "ImFontAtlas_SetTexID")                              font_atlas_set_tex_id                                  :: proc(self : ^Font_Atlas, id : Texture_ID) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImFontGlyphRangesBuilder_AddChar")     font_glyph_ranges_builder_add_char     :: proc(self : ^Font_Glyph_Ranges_Builder, c : Wchar) ---;
	@(link_name = "ImFontGlyphRangesBuilder_AddRanges")   font_glyph_ranges_builder_add_ranges   :: proc(self : ^Font_Glyph_Ranges_Builder, ranges : ^Wchar) ---;
	@(link_name = "ImFontGlyphRangesBuilder_AddText")     font_glyph_ranges_builder_add_text     :: proc(self : ^Font_Glyph_Ranges_Builder, text : cstring, text_end : cstring = nil) ---;
	@(link_name = "ImFontGlyphRangesBuilder_BuildRanges") font_glyph_ranges_builder_build_ranges :: proc(self : ^Font_Glyph_Ranges_Builder, out_ranges : ^Im_Vector(Wchar)) ---;
	@(link_name = "ImFontGlyphRangesBuilder_Clear")       font_glyph_ranges_builder_clear        :: proc(self : ^Font_Glyph_Ranges_Builder) ---;
	@(link_name = "ImFontGlyphRangesBuilder_GetBit")      font_glyph_ranges_builder_get_bit      :: proc(self : ^Font_Glyph_Ranges_Builder, n : i32) -> bool ---;
	@(link_name = "ImFontGlyphRangesBuilder_SetBit")      font_glyph_ranges_builder_set_bit      :: proc(self : ^Font_Glyph_Ranges_Builder, n : i32) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImFont_AddGlyph")              font_add_glyph                 :: proc(self : ^Font, c : Wchar, x0 : f32, y0 : f32, x1 : f32, y1 : f32, u0 : f32, v0 : f32, u1 : f32, v1 : f32, advance_x : f32) ---;
	@(link_name = "ImFont_AddRemapChar")          font_add_remap_char            :: proc(self : ^Font, dst : Wchar, src : Wchar, overwrite_dst : bool = true) ---;
	@(link_name = "ImFont_BuildLookupTable")      font_build_lookup_table        :: proc(self : ^Font) ---;
	@(link_name = "ImFont_CalcTextSizeA")         font_calc_text_size_a          :: proc(self : ^Font, size : f32, max_width : f32, wrap_width : f32, text_begin : cstring, text_end : cstring = nil, remaining : ^^i8 = nil) -> Vec2 ---;
	@(link_name = "ImFont_CalcWordWrapPositionA") font_calc_word_wrap_position_a :: proc(self : ^Font, scale : f32, text : cstring, text_end : cstring, wrap_width : f32) -> cstring ---;
	@(link_name = "ImFont_ClearOutputData")       font_clear_output_data         :: proc(self : ^Font) ---;
	@(link_name = "ImFont_FindGlyph")             font_find_glyph                :: proc(self : ^Font, c : Wchar) -> ^Font_Glyph ---;
	@(link_name = "ImFont_FindGlyphNoFallback")   font_find_glyph_no_fallback    :: proc(self : ^Font, c : Wchar) -> ^Font_Glyph ---;
	@(link_name = "ImFont_GetCharAdvance")        font_get_char_advance          :: proc(self : ^Font, c : Wchar) -> f32 ---;
	@(link_name = "ImFont_GetDebugName")          font_get_debug_name            :: proc(self : ^Font) -> cstring ---;
	@(link_name = "ImFont_GrowIndex")             font_grow_index                :: proc(self : ^Font, new_size : i32) ---;
	@(link_name = "ImFont_IsLoaded")              font_is_loaded                 :: proc(self : ^Font) -> bool ---;
	@(link_name = "ImFont_RenderChar")            font_render_char               :: proc(self : ^Font, draw_list : ^Draw_List, size : f32, pos : Vec2, col : u32, c : Wchar) ---;
	@(link_name = "ImFont_RenderText")            font_render_text               :: proc(self : ^Font, draw_list : ^Draw_List, size : f32, pos : Vec2, col : u32, clip_rect : Vec4, text_begin : cstring, text_end : cstring, wrap_width : f32 = 0.0, cpu_fine_clip : bool = false) ---;
	@(link_name = "ImFont_SetFallbackChar")       font_set_fallback_char         :: proc(self : ^Font, c : Wchar) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiIO_AddInputCharacter")      io_add_input_character        :: proc(self : ^io, c : u32) ---;
	@(link_name = "ImGuiIO_AddInputCharactersUTF8") io_add_input_characters_utf_8 :: proc(self : ^io, str : cstring) ---;
	@(link_name = "ImGuiIO_ClearInputCharacters")   io_clear_input_characters     :: proc(self : ^io) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiInputTextCallbackData_DeleteChars")  input_text_callback_data_delete_chars  :: proc(self : ^Input_Text_Callback_Data, pos : i32, bytes_count : i32) ---;
	@(link_name = "ImGuiInputTextCallbackData_HasSelection") input_text_callback_data_has_selection :: proc(self : ^Input_Text_Callback_Data) -> bool ---;
	@(link_name = "ImGuiInputTextCallbackData_InsertChars")  input_text_callback_data_insert_chars  :: proc(self : ^Input_Text_Callback_Data, pos : i32, text : cstring, text_end : cstring = nil) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiListClipper_Begin") list_clipper_begin :: proc(self : ^List_Clipper, items_count : i32, items_height : f32 = -1.0) ---;
	@(link_name = "ImGuiListClipper_End")   list_clipper_end   :: proc(self : ^List_Clipper) ---;
	@(link_name = "ImGuiListClipper_Step")  list_clipper_step  :: proc(self : ^List_Clipper) -> bool ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiPayload_Clear")      payload_clear        :: proc(self : ^Payload) ---;
	@(link_name = "ImGuiPayload_IsDataType") payload_is_data_type :: proc(self : ^Payload, type : cstring) -> bool ---;
	@(link_name = "ImGuiPayload_IsDelivery") payload_is_delivery  :: proc(self : ^Payload) -> bool ---;
	@(link_name = "ImGuiPayload_IsPreview")  payload_is_preview   :: proc(self : ^Payload) -> bool ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiStorage_BuildSortByKey") storage_build_sort_by_key :: proc(self : ^Storage) ---;
	@(link_name = "ImGuiStorage_Clear")          storage_clear             :: proc(self : ^Storage) ---;
	@(link_name = "ImGuiStorage_GetBool")        storage_get_bool          :: proc(self : ^Storage, key : ID, default_val : bool = false) -> bool ---;
	@(link_name = "ImGuiStorage_GetBoolRef")     storage_get_bool_ref      :: proc(self : ^Storage, key : ID, default_val : bool = false) -> ^bool ---;
	@(link_name = "ImGuiStorage_GetFloat")       storage_get_float         :: proc(self : ^Storage, key : ID, default_val : f32 = 0.0) -> f32 ---;
	@(link_name = "ImGuiStorage_GetFloatRef")    storage_get_float_ref     :: proc(self : ^Storage, key : ID, default_val : f32 = 0.0) -> ^f32 ---;
	@(link_name = "ImGuiStorage_GetInt")         storage_get_int           :: proc(self : ^Storage, key : ID, default_val : i32 = 0) -> i32 ---;
	@(link_name = "ImGuiStorage_GetIntRef")      storage_get_int_ref       :: proc(self : ^Storage, key : ID, default_val : i32 = 0) -> ^i32 ---;
	@(link_name = "ImGuiStorage_GetVoidPtr")     storage_get_void_ptr      :: proc(self : ^Storage, key : ID) -> rawptr ---;
	@(link_name = "ImGuiStorage_GetVoidPtrRef")  storage_get_void_ptr_ref  :: proc(self : ^Storage, key : ID, default_val : rawptr = nil) -> ^^oid ---;
	@(link_name = "ImGuiStorage_SetAllInt")      storage_set_all_int       :: proc(self : ^Storage, val : i32) ---;
	@(link_name = "ImGuiStorage_SetBool")        storage_set_bool          :: proc(self : ^Storage, key : ID, val : bool) ---;
	@(link_name = "ImGuiStorage_SetFloat")       storage_set_float         :: proc(self : ^Storage, key : ID, val : f32) ---;
	@(link_name = "ImGuiStorage_SetInt")         storage_set_int           :: proc(self : ^Storage, key : ID, val : i32) ---;
	@(link_name = "ImGuiStorage_SetVoidPtr")     storage_set_void_ptr      :: proc(self : ^Storage, key : ID, val : rawptr) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiStyle_ScaleAllSizes") style_scale_all_sizes :: proc(self : ^Style, scale_factor : f32) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiTextBuffer_append")  text_buffer_append  :: proc(self : ^Text_Buffer, str : cstring, str_end : cstring = nil) ---;
	@(link_name = "ImGuiTextBuffer_appendf") text_buffer_appendf :: proc(self : ^Text_Buffer, fmt : cstring, #c_vararg args : ..any) ---;
	@(link_name = "ImGuiTextBuffer_begin")   text_buffer_begin   :: proc(self : ^Text_Buffer) -> cstring ---;
	@(link_name = "ImGuiTextBuffer_c_str")   text_buffer_c_str   :: proc(self : ^Text_Buffer) -> cstring ---;
	@(link_name = "ImGuiTextBuffer_clear")   text_buffer_clear   :: proc(self : ^Text_Buffer) ---;
	@(link_name = "ImGuiTextBuffer_empty")   text_buffer_empty   :: proc(self : ^Text_Buffer) -> bool ---;
	@(link_name = "ImGuiTextBuffer_end")     text_buffer_end     :: proc(self : ^Text_Buffer) -> cstring ---;
	@(link_name = "ImGuiTextBuffer_reserve") text_buffer_reserve :: proc(self : ^Text_Buffer, capacity : i32) ---;
	@(link_name = "ImGuiTextBuffer_size")    text_buffer_size    :: proc(self : ^Text_Buffer) -> i32 ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiTextFilter_Build")      text_filter_build       :: proc(self : ^Text_Filter) ---;
	@(link_name = "ImGuiTextFilter_Clear")      text_filter_clear       :: proc(self : ^Text_Filter) ---;
	@(link_name = "ImGuiTextFilter_Draw")       text_filter_draw        :: proc(self : ^Text_Filter, label := "Filter{inc,-exc}", width : f32 = 0.0) -> bool ---;
	@(link_name = "ImGuiTextFilter_IsActive")   text_filter_is_active   :: proc(self : ^Text_Filter) -> bool ---;
	@(link_name = "ImGuiTextFilter_PassFilter") text_filter_pass_filter :: proc(self : ^Text_Filter, text : cstring, text_end : cstring = nil) -> bool ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "ImGuiTextRange_empty") text_range_empty :: proc(self : ^Text_Range) -> bool ---;
	@(link_name = "ImGuiTextRange_split") text_range_split :: proc(self : ^Text_Range, separator : i8, out : ^Im_Vector(Text_Range)) ---;


}

@(default_calling_convention="c")
foreign cimgui {
	@(link_name = "igAcceptDragDropPayload")            accept_drag_drop_payload               :: proc(type : cstring, flags : Drag_Drop_Flags = 0) -> ^Payload ---;
	@(link_name = "igAlignTextToFramePadding")          align_text_to_frame_padding            :: proc() ---;
	                                                   	arrow_button                           :: proc(str_id : string, dir : Dir) -> bool do return ig_arrow_button(_make_label_string(str_id), dir);
	                                                   	begin                                  :: proc(name : string, p_open : ^bool = nil, flags : Window_Flags = 0) -> bool do return ig_begin(_make_label_string(name), p_open, flags);
	                                                   	begin_child                            :: proc(str_id : string, size := Vec2{0,0}, border : bool = false, flags : Window_Flags = 0) -> bool do return ig_begin_child(_make_label_string(str_id), size, border, flags);
	@(link_name = "igBeginChildID")                     begin_child                            :: proc(id : ID, size := Vec2{0,0}, border : bool = false, flags : Window_Flags = 0) -> bool ---;
	@(link_name = "igBeginChildFrame")                  begin_child_frame                      :: proc(id : ID, size : Vec2, flags : Window_Flags = 0) -> bool ---;
	                                                   	begin_combo                            :: proc(label : string, preview_value : cstring, flags : Combo_Flags = 0) -> bool do return ig_begin_combo(_make_label_string(label), preview_value, flags);
	@(link_name = "igBeginDragDropSource")              begin_drag_drop_source                 :: proc(flags : Drag_Drop_Flags = 0) -> bool ---;
	@(link_name = "igBeginDragDropTarget")              begin_drag_drop_target                 :: proc() -> bool ---;
	@(link_name = "igBeginGroup")                       begin_group                            :: proc() ---;
	@(link_name = "igBeginMainMenuBar")                 begin_main_menu_bar                    :: proc() -> bool ---;
	                                                   	begin_menu                             :: proc(label : string, enabled : bool = true) -> bool do return ig_begin_menu(_make_label_string(label), enabled);
	@(link_name = "igBeginMenuBar")                     begin_menu_bar                         :: proc() -> bool ---;
	                                                   	begin_popup                            :: proc(str_id : string, flags : Window_Flags = 0) -> bool do return ig_begin_popup(_make_label_string(str_id), flags);
	                                                   	begin_popup_context_item               :: proc(str_id : string, mouse_button : i32 = 1) -> bool do return ig_begin_popup_context_item(_make_label_string(str_id), mouse_button);
	                                                   	begin_popup_context_void               :: proc(str_id : string, mouse_button : i32 = 1) -> bool do return ig_begin_popup_context_void(_make_label_string(str_id), mouse_button);
	                                                   	begin_popup_context_window             :: proc(str_id : string, mouse_button : i32 = 1, also_over_items : bool = true) -> bool do return ig_begin_popup_context_window(_make_label_string(str_id), mouse_button, also_over_items);
	                                                   	begin_popup_modal                      :: proc(name : string, p_open : ^bool = nil, flags : Window_Flags = 0) -> bool do return ig_begin_popup_modal(_make_label_string(name), p_open, flags);
	                                                   	begin_tab_bar                          :: proc(str_id : string, flags : Tab_Bar_Flags = 0) -> bool do return ig_begin_tab_bar(_make_label_string(str_id), flags);
	                                                   	begin_tab_item                         :: proc(label : string, p_open : ^bool = nil, flags : Tab_Item_Flags = 0) -> bool do return ig_begin_tab_item(_make_label_string(label), p_open, flags);
	@(link_name = "igBeginTooltip")                     begin_tooltip                          :: proc() ---;
	@(link_name = "igBullet")                           bullet                                 :: proc() ---;
	@(link_name = "igBulletText")                       bullet_text                            :: proc(fmt : cstring, #c_vararg args : ..any) ---;
	                                                   	button                                 :: proc(label : string, size := Vec2{0,0}) -> bool do return ig_button(_make_label_string(label), size);
	@(link_name = "igCalcItemWidth")                    calc_item_width                        :: proc() -> f32 ---;
	@(link_name = "igCalcListClipping")                 calc_list_clipping                     :: proc(items_count : i32, items_height : f32, out_items_display_start : ^i32, out_items_display_end : ^i32) ---;
	@(link_name = "igCalcTextSize")                     calc_text_size                         :: proc(text : cstring, text_end : cstring = nil, hide_text_after_double_hash : bool = false, wrap_width : f32 = -1.0) -> Vec2 ---;
	@(link_name = "igCaptureKeyboardFromApp")           capture_keyboard_from_app              :: proc(want_capture_keyboard_value : bool = true) ---;
	@(link_name = "igCaptureMouseFromApp")              capture_mouse_from_app                 :: proc(want_capture_mouse_value : bool = true) ---;
	                                                   	checkbox                               :: proc(label : string, v : ^bool) -> bool do return ig_checkbox(_make_label_string(label), v);
	                                                   	checkbox_flags                         :: proc(label : string, flags : ^u32, flags_value : u32) -> bool do return ig_checkbox_flags(_make_label_string(label), flags, flags_value);
	@(link_name = "igCloseCurrentPopup")                close_current_popup                    :: proc() ---;
	                                                   	collapsing_header                      :: proc(label : string, flags : Tree_Node_Flags = 0) -> bool do return ig_collapsing_header(_make_label_string(label), flags);
	                                                   	collapsing_header_bool_ptr             :: proc(label : string, p_open : ^bool, flags : Tree_Node_Flags = 0) -> bool do return ig_collapsing_header_bool_ptr(_make_label_string(label), p_open, flags);
	@(link_name = "igColorButton")                      color_button                           :: proc(desc_id : cstring, col : Vec4, flags : Color_Edit_Flags = 0, size := Vec2{0,0}) -> bool ---;
	@(link_name = "igColorConvertFloat4ToU32")          color_convert_float_4_to_u_32          :: proc(in : Vec4) -> u32 ---;
	@(link_name = "igColorConvertHSVtoRGB")             color_convert_hs_vto_rgb               :: proc(h : f32, s : f32, v : f32, out_r : ^f32, out_g : ^f32, out_b : ^f32) ---;
	@(link_name = "igColorConvertRGBtoHSV")             color_convert_rg_bto_hsv               :: proc(r : f32, g : f32, b : f32, out_h : ^f32, out_s : ^f32, out_v : ^f32) ---;
	@(link_name = "igColorConvertU32ToFloat4")          color_convert_u_32_to_float_4          :: proc(in : u32) -> Vec4 ---;
	                                                   	color_edit_3                           :: proc(label : string, col : Float[3], flags : Color_Edit_Flags = 0) -> bool do return ig_color_edit_3(_make_label_string(label), col, flags);
	                                                   	color_edit_4                           :: proc(label : string, col : Float[4], flags : Color_Edit_Flags = 0) -> bool do return ig_color_edit_4(_make_label_string(label), col, flags);
	                                                   	color_picker_3                         :: proc(label : string, col : Float[3], flags : Color_Edit_Flags = 0) -> bool do return ig_color_picker_3(_make_label_string(label), col, flags);
	                                                   	color_picker_4                         :: proc(label : string, col : Float[4], flags : Color_Edit_Flags = 0, ref_col : ^f32 = nil) -> bool do return ig_color_picker_4(_make_label_string(label), col, flags, ref_col);
	@(link_name = "igColumns")                          columns                                :: proc(count : i32 = 1, id : cstring = nil, border : bool = true) ---;
	                                                   	combo                                  :: proc(label : string, current_item : ^i32, items : i8, items_count : i32, popup_max_height_in_items : i32 = -1) -> bool do return ig_combo(_make_label_string(label), current_item, items, items_count, popup_max_height_in_items);
	                                                   	combo_str                              :: proc(label : string, current_item : ^i32, items_separated_by_zeros : cstring, popup_max_height_in_items : i32 = -1) -> bool do return ig_combo_str(_make_label_string(label), current_item, items_separated_by_zeros, popup_max_height_in_items);
	                                                   	combo_fn_ptr                           :: proc(label : string, current_item : ^i32, items_getter : proc "c"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, popup_max_height_in_items : i32 = -1) -> bool do return ig_combo_fn_ptr(_make_label_string(label), current_item, items_getter, data, items_count, popup_max_height_in_items);
	@(link_name = "igCreateContext")                    create_context                         :: proc(shared_font_atlas : ^Font_Atlas = nil) -> ^Context ---;
	@(link_name = "igDebugCheckVersionAndDataLayout")   debug_check_version_and_data_layout    :: proc(version_str : cstring, sz_io : uint, sz_style : uint, sz_vec2 : uint, sz_vec4 : uint, sz_drawvert : uint, sz_drawidx : uint) -> bool ---;
	@(link_name = "igDestroyContext")                   destroy_context                        :: proc(ctx : ^Context = nil) ---;
	                                                   	drag_float                             :: proc(label : string, v : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_drag_float(_make_label_string(label), v, v_speed, v_min, v_max, format, power);
	                                                   	drag_float_2                           :: proc(label : string, v : Float[2], v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_drag_float_2(_make_label_string(label), v, v_speed, v_min, v_max, format, power);
	                                                   	drag_float_3                           :: proc(label : string, v : Float[3], v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_drag_float_3(_make_label_string(label), v, v_speed, v_min, v_max, format, power);
	                                                   	drag_float_4                           :: proc(label : string, v : Float[4], v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_drag_float_4(_make_label_string(label), v, v_speed, v_min, v_max, format, power);
	                                                   	drag_float_range_2                     :: proc(label : string, v_current_min : ^f32, v_current_max : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", format_max : cstring = nil, power : f32 = 1.0) -> bool do return ig_drag_float_range_2(_make_label_string(label), v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, power);
	                                                   	drag_int                               :: proc(label : string, v : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool do return ig_drag_int(_make_label_string(label), v, v_speed, v_min, v_max, format);
	                                                   	drag_int_2                             :: proc(label : string, v : Int[2], v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool do return ig_drag_int_2(_make_label_string(label), v, v_speed, v_min, v_max, format);
	                                                   	drag_int_3                             :: proc(label : string, v : Int[3], v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool do return ig_drag_int_3(_make_label_string(label), v, v_speed, v_min, v_max, format);
	                                                   	drag_int_4                             :: proc(label : string, v : Int[4], v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool do return ig_drag_int_4(_make_label_string(label), v, v_speed, v_min, v_max, format);
	                                                   	drag_int_range_2                       :: proc(label : string, v_current_min : ^i32, v_current_max : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d", format_max : cstring = nil) -> bool do return ig_drag_int_range_2(_make_label_string(label), v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max);
	                                                   	drag_scalar                            :: proc(label : string, data_type : Data_Type, p_data : rawptr, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool do return ig_drag_scalar(_make_label_string(label), data_type, p_data, v_speed, p_min, p_max, format, power);
	                                                   	drag_scalar_n                          :: proc(label : string, data_type : Data_Type, p_data : rawptr, components : i32, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool do return ig_drag_scalar_n(_make_label_string(label), data_type, p_data, components, v_speed, p_min, p_max, format, power);
	@(link_name = "igDummy")                            dummy                                  :: proc(size : Vec2) ---;
	@(link_name = "igEnd")                              end                                    :: proc() ---;
	@(link_name = "igEndChild")                         end_child                              :: proc() ---;
	@(link_name = "igEndChildFrame")                    end_child_frame                        :: proc() ---;
	@(link_name = "igEndCombo")                         end_combo                              :: proc() ---;
	@(link_name = "igEndDragDropSource")                end_drag_drop_source                   :: proc() ---;
	@(link_name = "igEndDragDropTarget")                end_drag_drop_target                   :: proc() ---;
	@(link_name = "igEndFrame")                         end_frame                              :: proc() ---;
	@(link_name = "igEndGroup")                         end_group                              :: proc() ---;
	@(link_name = "igEndMainMenuBar")                   end_main_menu_bar                      :: proc() ---;
	@(link_name = "igEndMenu")                          end_menu                               :: proc() ---;
	@(link_name = "igEndMenuBar")                       end_menu_bar                           :: proc() ---;
	@(link_name = "igEndPopup")                         end_popup                              :: proc() ---;
	@(link_name = "igEndTabBar")                        end_tab_bar                            :: proc() ---;
	@(link_name = "igEndTabItem")                       end_tab_item                           :: proc() ---;
	@(link_name = "igEndTooltip")                       end_tooltip                            :: proc() ---;
	@(link_name = "igGetBackgroundDrawList")            get_background_draw_list               :: proc() -> ^Draw_List ---;
	@(link_name = "igGetClipboardText")                 get_clipboard_text                     :: proc() -> cstring ---;
	@(link_name = "igGetColorU32")                      get_color_u_32                         :: proc(idx : Col, alpha_mul : f32 = 1.0) -> u32 ---;
	@(link_name = "igGetColorU32Vec4")                  get_color_u_32                         :: proc(col : Vec4) -> u32 ---;
	@(link_name = "igGetColorU32U32")                   get_color_u_32                         :: proc(col : u32) -> u32 ---;
	@(link_name = "igGetColumnIndex")                   get_column_index                       :: proc() -> i32 ---;
	@(link_name = "igGetColumnOffset")                  get_column_offset                      :: proc(column_index : i32 = -1) -> f32 ---;
	@(link_name = "igGetColumnWidth")                   get_column_width                       :: proc(column_index : i32 = -1) -> f32 ---;
	@(link_name = "igGetColumnsCount")                  get_columns_count                      :: proc() -> i32 ---;
	@(link_name = "igGetContentRegionAvail")            get_content_region_avail               :: proc() -> Vec2 ---;
	@(link_name = "igGetContentRegionMax")              get_content_region_max                 :: proc() -> Vec2 ---;
	@(link_name = "igGetCurrentContext")                get_current_context                    :: proc() -> ^Context ---;
	@(link_name = "igGetCursorPos")                     get_cursor_pos                         :: proc() -> Vec2 ---;
	@(link_name = "igGetCursorPosX")                    get_cursor_pos_x                       :: proc() -> f32 ---;
	@(link_name = "igGetCursorPosY")                    get_cursor_pos_y                       :: proc() -> f32 ---;
	@(link_name = "igGetCursorScreenPos")               get_cursor_screen_pos                  :: proc() -> Vec2 ---;
	@(link_name = "igGetCursorStartPos")                get_cursor_start_pos                   :: proc() -> Vec2 ---;
	@(link_name = "igGetDragDropPayload")               get_drag_drop_payload                  :: proc() -> ^Payload ---;
	@(link_name = "igGetDrawData")                      get_draw_data                          :: proc() -> ^Draw_Data ---;
	@(link_name = "igGetDrawListSharedData")            get_draw_list_shared_data              :: proc() -> ^Draw_List_Shared_Data ---;
	@(link_name = "igGetFont")                          get_font                               :: proc() -> ^Font ---;
	@(link_name = "igGetFontSize")                      get_font_size                          :: proc() -> f32 ---;
	@(link_name = "igGetFontTexUvWhitePixel")           get_font_tex_uv_white_pixel            :: proc() -> Vec2 ---;
	@(link_name = "igGetForegroundDrawList")            get_foreground_draw_list               :: proc() -> ^Draw_List ---;
	@(link_name = "igGetFrameCount")                    get_frame_count                        :: proc() -> i32 ---;
	@(link_name = "igGetFrameHeight")                   get_frame_height                       :: proc() -> f32 ---;
	@(link_name = "igGetFrameHeightWithSpacing")        get_frame_height_with_spacing          :: proc() -> f32 ---;
	                                                   	get_id_str                             :: proc(str_id : string) -> ID do return ig_get_id_str(_make_label_string(str_id));
	@(link_name = "igGetIDRange")                       get_id                                 :: proc(str_id_begin : cstring, str_id_end : cstring) -> ID ---;
	@(link_name = "igGetIDPtr")                         get_id                                 :: proc(ptr_id : rawptr) -> ID ---;
	@(link_name = "igGetIO")                            get_io                                 :: proc() -> ^io ---;
	@(link_name = "igGetItemRectMax")                   get_item_rect_max                      :: proc() -> Vec2 ---;
	@(link_name = "igGetItemRectMin")                   get_item_rect_min                      :: proc() -> Vec2 ---;
	@(link_name = "igGetItemRectSize")                  get_item_rect_size                     :: proc() -> Vec2 ---;
	@(link_name = "igGetKeyIndex")                      get_key_index                          :: proc(imgui_key : Key) -> i32 ---;
	@(link_name = "igGetKeyPressedAmount")              get_key_pressed_amount                 :: proc(key_index : i32, repeat_delay : f32, rate : f32) -> i32 ---;
	@(link_name = "igGetMouseCursor")                   get_mouse_cursor                       :: proc() -> Mouse_Cursor ---;
	@(link_name = "igGetMouseDragDelta")                get_mouse_drag_delta                   :: proc(button : i32 = 0, lock_threshold : f32 = -1.0) -> Vec2 ---;
	@(link_name = "igGetMousePos")                      get_mouse_pos                          :: proc() -> Vec2 ---;
	@(link_name = "igGetMousePosOnOpeningCurrentPopup") get_mouse_pos_on_opening_current_popup :: proc() -> Vec2 ---;
	@(link_name = "igGetScrollMaxX")                    get_scroll_max_x                       :: proc() -> f32 ---;
	@(link_name = "igGetScrollMaxY")                    get_scroll_max_y                       :: proc() -> f32 ---;
	@(link_name = "igGetScrollX")                       get_scroll_x                           :: proc() -> f32 ---;
	@(link_name = "igGetScrollY")                       get_scroll_y                           :: proc() -> f32 ---;
	@(link_name = "igGetStateStorage")                  get_state_storage                      :: proc() -> ^Storage ---;
	@(link_name = "igGetStyle")                         get_style                              :: proc() -> ^Style ---;
	@(link_name = "igGetStyleColorName")                get_style_color_name                   :: proc(idx : Col) -> cstring ---;
	@(link_name = "igGetStyleColorVec4")                get_style_color_vec_4                  :: proc(idx : Col) -> ^Vec4 ---;
	@(link_name = "igGetTextLineHeight")                get_text_line_height                   :: proc() -> f32 ---;
	@(link_name = "igGetTextLineHeightWithSpacing")     get_text_line_height_with_spacing      :: proc() -> f32 ---;
	@(link_name = "igGetTime")                          get_time                               :: proc() -> f64 ---;
	@(link_name = "igGetTreeNodeToLabelSpacing")        get_tree_node_to_label_spacing         :: proc() -> f32 ---;
	@(link_name = "igGetVersion")                       get_version                            :: proc() -> cstring ---;
	@(link_name = "igGetWindowContentRegionMax")        get_window_content_region_max          :: proc() -> Vec2 ---;
	@(link_name = "igGetWindowContentRegionMin")        get_window_content_region_min          :: proc() -> Vec2 ---;
	@(link_name = "igGetWindowContentRegionWidth")      get_window_content_region_width        :: proc() -> f32 ---;
	@(link_name = "igGetWindowDrawList")                get_window_draw_list                   :: proc() -> ^Draw_List ---;
	@(link_name = "igGetWindowHeight")                  get_window_height                      :: proc() -> f32 ---;
	@(link_name = "igGetWindowPos")                     get_window_pos                         :: proc() -> Vec2 ---;
	@(link_name = "igGetWindowSize")                    get_window_size                        :: proc() -> Vec2 ---;
	@(link_name = "igGetWindowWidth")                   get_window_width                       :: proc() -> f32 ---;
	@(link_name = "igImage")                            image                                  :: proc(user_texture_id : Texture_ID, size : Vec2, uv0 := Vec2{0,0}, uv1 := Vec2{1,1}, tint_col := Vec4{1,1,1,1}, border_col := Vec4{0,0,0,0}) ---;
	@(link_name = "igImageButton")                      image_button                           :: proc(user_texture_id : Texture_ID, size : Vec2, uv0 := Vec2{0,0}, uv1 := Vec2{1,1}, frame_padding : i32 = -1, bg_col := Vec4{0,0,0,0}, tint_col := Vec4{1,1,1,1}) -> bool ---;
	@(link_name = "igIndent")                           indent                                 :: proc(indent_w : f32 = 0.0) ---;
	                                                   	input_double                           :: proc(label : string, v : ^f64, step : f64 = 0.0, step_fast : f64 = 0.0, format : cstring = "%.6f", flags : Input_Text_Flags = 0) -> bool do return ig_input_double(_make_label_string(label), v, step, step_fast, format, flags);
	                                                   	input_float                            :: proc(label : string, v : ^f32, step : f32 = 0.0, step_fast : f32 = 0.0, format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool do return ig_input_float(_make_label_string(label), v, step, step_fast, format, flags);
	                                                   	input_float_2                          :: proc(label : string, v : Float[2], format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool do return ig_input_float_2(_make_label_string(label), v, format, flags);
	                                                   	input_float_3                          :: proc(label : string, v : Float[3], format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool do return ig_input_float_3(_make_label_string(label), v, format, flags);
	                                                   	input_float_4                          :: proc(label : string, v : Float[4], format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool do return ig_input_float_4(_make_label_string(label), v, format, flags);
	                                                   	input_int                              :: proc(label : string, v : ^i32, step : i32 = 1, step_fast : i32 = 100, flags : Input_Text_Flags = 0) -> bool do return ig_input_int(_make_label_string(label), v, step, step_fast, flags);
	                                                   	input_int_2                            :: proc(label : string, v : Int[2], flags : Input_Text_Flags = 0) -> bool do return ig_input_int_2(_make_label_string(label), v, flags);
	                                                   	input_int_3                            :: proc(label : string, v : Int[3], flags : Input_Text_Flags = 0) -> bool do return ig_input_int_3(_make_label_string(label), v, flags);
	                                                   	input_int_4                            :: proc(label : string, v : Int[4], flags : Input_Text_Flags = 0) -> bool do return ig_input_int_4(_make_label_string(label), v, flags);
	                                                   	input_scalar                           :: proc(label : string, data_type : Data_Type, p_data : rawptr, p_step : rawptr = nil, p_step_fast : rawptr = nil, format : cstring = nil, flags : Input_Text_Flags = 0) -> bool do return ig_input_scalar(_make_label_string(label), data_type, p_data, p_step, p_step_fast, format, flags);
	                                                   	input_scalar_n                         :: proc(label : string, data_type : Data_Type, p_data : rawptr, components : i32, p_step : rawptr = nil, p_step_fast : rawptr = nil, format : cstring = nil, flags : Input_Text_Flags = 0) -> bool do return ig_input_scalar_n(_make_label_string(label), data_type, p_data, components, p_step, p_step_fast, format, flags);
	                                                   	input_text                             :: proc(label : string, buf : ^i8, buf_size : uint, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool do return ig_input_text(_make_label_string(label), buf, buf_size, flags, callback, user_data);
	                                                   	input_text_multiline                   :: proc(label : string, buf : ^i8, buf_size : uint, size := Vec2{0,0}, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool do return ig_input_text_multiline(_make_label_string(label), buf, buf_size, size, flags, callback, user_data);
	                                                   	input_text_with_hint                   :: proc(label : string, hint : cstring, buf : ^i8, buf_size : uint, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool do return ig_input_text_with_hint(_make_label_string(label), hint, buf, buf_size, flags, callback, user_data);
	                                                   	invisible_button                       :: proc(str_id : string, size : Vec2) -> bool do return ig_invisible_button(_make_label_string(str_id), size);
	@(link_name = "igIsAnyItemActive")                  is_any_item_active                     :: proc() -> bool ---;
	@(link_name = "igIsAnyItemFocused")                 is_any_item_focused                    :: proc() -> bool ---;
	@(link_name = "igIsAnyItemHovered")                 is_any_item_hovered                    :: proc() -> bool ---;
	@(link_name = "igIsAnyMouseDown")                   is_any_mouse_down                      :: proc() -> bool ---;
	@(link_name = "igIsItemActivated")                  is_item_activated                      :: proc() -> bool ---;
	@(link_name = "igIsItemActive")                     is_item_active                         :: proc() -> bool ---;
	@(link_name = "igIsItemClicked")                    is_item_clicked                        :: proc(mouse_button : i32 = 0) -> bool ---;
	@(link_name = "igIsItemDeactivated")                is_item_deactivated                    :: proc() -> bool ---;
	@(link_name = "igIsItemDeactivatedAfterEdit")       is_item_deactivated_after_edit         :: proc() -> bool ---;
	@(link_name = "igIsItemEdited")                     is_item_edited                         :: proc() -> bool ---;
	@(link_name = "igIsItemFocused")                    is_item_focused                        :: proc() -> bool ---;
	@(link_name = "igIsItemHovered")                    is_item_hovered                        :: proc(flags : Hovered_Flags = 0) -> bool ---;
	@(link_name = "igIsItemToggledOpen")                is_item_toggled_open                   :: proc() -> bool ---;
	@(link_name = "igIsItemVisible")                    is_item_visible                        :: proc() -> bool ---;
	@(link_name = "igIsKeyDown")                        is_key_down                            :: proc(user_key_index : i32) -> bool ---;
	@(link_name = "igIsKeyPressed")                     is_key_pressed                         :: proc(user_key_index : i32, repeat : bool = true) -> bool ---;
	@(link_name = "igIsKeyReleased")                    is_key_released                        :: proc(user_key_index : i32) -> bool ---;
	@(link_name = "igIsMouseClicked")                   is_mouse_clicked                       :: proc(button : i32, repeat : bool = false) -> bool ---;
	@(link_name = "igIsMouseDoubleClicked")             is_mouse_double_clicked                :: proc(button : i32) -> bool ---;
	@(link_name = "igIsMouseDown")                      is_mouse_down                          :: proc(button : i32) -> bool ---;
	@(link_name = "igIsMouseDragging")                  is_mouse_dragging                      :: proc(button : i32 = 0, lock_threshold : f32 = -1.0) -> bool ---;
	@(link_name = "igIsMouseHoveringRect")              is_mouse_hovering_rect                 :: proc(r_min : Vec2, r_max : Vec2, clip : bool = true) -> bool ---;
	@(link_name = "igIsMousePosValid")                  is_mouse_pos_valid                     :: proc(mouse_pos : ^Vec2 = nil) -> bool ---;
	@(link_name = "igIsMouseReleased")                  is_mouse_released                      :: proc(button : i32) -> bool ---;
	                                                   	is_popup_open                          :: proc(str_id : string) -> bool do return ig_is_popup_open(_make_label_string(str_id));
	@(link_name = "igIsRectVisible")                    is_rect_visible                        :: proc(size : Vec2) -> bool ---;
	@(link_name = "igIsRectVisibleVec2")                is_rect_visible                        :: proc(rect_min : Vec2, rect_max : Vec2) -> bool ---;
	@(link_name = "igIsWindowAppearing")                is_window_appearing                    :: proc() -> bool ---;
	@(link_name = "igIsWindowCollapsed")                is_window_collapsed                    :: proc() -> bool ---;
	@(link_name = "igIsWindowFocused")                  is_window_focused                      :: proc(flags : Focused_Flags = 0) -> bool ---;
	@(link_name = "igIsWindowHovered")                  is_window_hovered                      :: proc(flags : Hovered_Flags = 0) -> bool ---;
	                                                   	label_text                             :: proc(label : string, fmt : cstring, #c_vararg args : ..any) do return ig_label_text(_make_label_string(label), fmt, args);
	                                                   	list_box_str_arr                       :: proc(label : string, current_item : ^i32, items : i8, items_count : i32, height_in_items : i32 = -1) -> bool do return ig_list_box_str_arr(_make_label_string(label), current_item, items, items_count, height_in_items);
	                                                   	list_box_fn_ptr                        :: proc(label : string, current_item : ^i32, items_getter : proc "c"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, height_in_items : i32 = -1) -> bool do return ig_list_box_fn_ptr(_make_label_string(label), current_item, items_getter, data, items_count, height_in_items);
	@(link_name = "igListBoxFooter")                    list_box_footer                        :: proc() ---;
	                                                   	list_box_header_vec_2                  :: proc(label : string, size := Vec2{0,0}) -> bool do return ig_list_box_header_vec_2(_make_label_string(label), size);
	                                                   	list_box_header_int                    :: proc(label : string, items_count : i32, height_in_items : i32 = -1) -> bool do return ig_list_box_header_int(_make_label_string(label), items_count, height_in_items);
	@(link_name = "igLoadIniSettingsFromDisk")          load_ini_settings_from_disk            :: proc(ini_filename : cstring) ---;
	@(link_name = "igLoadIniSettingsFromMemory")        load_ini_settings_from_memory          :: proc(ini_data : cstring, ini_size : uint = 0) ---;
	@(link_name = "igLogButtons")                       log_buttons                            :: proc() ---;
	@(link_name = "igLogFinish")                        log_finish                             :: proc() ---;
	@(link_name = "igLogText")                          log_text                               :: proc(fmt : cstring, #c_vararg args : ..any) ---;
	@(link_name = "igLogToClipboard")                   log_to_clipboard                       :: proc(auto_open_depth : i32 = -1) ---;
	@(link_name = "igLogToFile")                        log_to_file                            :: proc(auto_open_depth : i32 = -1, filename : cstring = nil) ---;
	@(link_name = "igLogToTTY")                         log_to_tty                             :: proc(auto_open_depth : i32 = -1) ---;
	@(link_name = "igMemAlloc")                         mem_alloc                              :: proc(size : uint) -> rawptr ---;
	@(link_name = "igMemFree")                          mem_free                               :: proc(ptr : rawptr) ---;
	                                                   	menu_item_bool                         :: proc(label : string, shortcut : cstring = nil, selected : bool = false, enabled : bool = true) -> bool do return ig_menu_item_bool(_make_label_string(label), shortcut, selected, enabled);
	                                                   	menu_item_bool_ptr                     :: proc(label : string, shortcut : cstring, p_selected : ^bool, enabled : bool = true) -> bool do return ig_menu_item_bool_ptr(_make_label_string(label), shortcut, p_selected, enabled);
	@(link_name = "igNewFrame")                         new_frame                              :: proc() ---;
	@(link_name = "igNewLine")                          new_line                               :: proc() ---;
	@(link_name = "igNextColumn")                       next_column                            :: proc() ---;
	                                                   	open_popup                             :: proc(str_id : string) do return ig_open_popup(_make_label_string(str_id));
	                                                   	open_popup_on_item_click               :: proc(str_id : string, mouse_button : i32 = 1) -> bool do return ig_open_popup_on_item_click(_make_label_string(str_id), mouse_button);
	                                                   	plot_histogram_float_ptr               :: proc(label : string, values : ^f32, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}, stride := size_of(f32)) do return ig_plot_histogram_float_ptr(_make_label_string(label), values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride);
	                                                   	plot_histogram_fn_ptr                  :: proc(label : string, values_getter : proc "c"(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}) do return ig_plot_histogram_fn_ptr(_make_label_string(label), values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size);
	                                                   	plot_lines                             :: proc(label : string, values : ^f32, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}, stride := size_of(f32)) do return ig_plot_lines(_make_label_string(label), values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride);
	                                                   	plot_lines_fn_ptr                      :: proc(label : string, values_getter : proc "c"(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}) do return ig_plot_lines_fn_ptr(_make_label_string(label), values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size);
	@(link_name = "igPopAllowKeyboardFocus")            pop_allow_keyboard_focus               :: proc() ---;
	@(link_name = "igPopButtonRepeat")                  pop_button_repeat                      :: proc() ---;
	@(link_name = "igPopClipRect")                      pop_clip_rect                          :: proc() ---;
	@(link_name = "igPopFont")                          pop_font                               :: proc() ---;
	@(link_name = "igPopID")                            pop_id                                 :: proc() ---;
	@(link_name = "igPopItemWidth")                     pop_item_width                         :: proc() ---;
	@(link_name = "igPopStyleColor")                    pop_style_color                        :: proc(count : i32 = 1) ---;
	@(link_name = "igPopStyleVar")                      pop_style_var                          :: proc(count : i32 = 1) ---;
	@(link_name = "igPopTextWrapPos")                   pop_text_wrap_pos                      :: proc() ---;
	@(link_name = "igProgressBar")                      progress_bar                           :: proc(fraction : f32, size_arg := Vec2{-1,0}, overlay : cstring = nil) ---;
	@(link_name = "igPushAllowKeyboardFocus")           push_allow_keyboard_focus              :: proc(allow_keyboard_focus : bool) ---;
	@(link_name = "igPushButtonRepeat")                 push_button_repeat                     :: proc(repeat : bool) ---;
	@(link_name = "igPushClipRect")                     push_clip_rect                         :: proc(clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) ---;
	@(link_name = "igPushFont")                         push_font                              :: proc(font : ^Font) ---;
	                                                   	push_id_str                            :: proc(str_id : string) do return ig_push_id_str(_make_label_string(str_id));
	@(link_name = "igPushIDRange")                      push_id                                :: proc(str_id_begin : cstring, str_id_end : cstring) ---;
	@(link_name = "igPushIDPtr")                        push_id                                :: proc(ptr_id : rawptr) ---;
	@(link_name = "igPushIDInt")                        push_id                                :: proc(int_id : i32) ---;
	@(link_name = "igPushItemWidth")                    push_item_width                        :: proc(item_width : f32) ---;
	@(link_name = "igPushStyleColorU32")                push_style_color                       :: proc(idx : Col, col : u32) ---;
	@(link_name = "igPushStyleColor")                   push_style_color                       :: proc(idx : Col, col : Vec4) ---;
	@(link_name = "igPushStyleVarFloat")                push_style_var                         :: proc(idx : Style_Var, val : f32) ---;
	@(link_name = "igPushStyleVarVec2")                 push_style_var                         :: proc(idx : Style_Var, val : Vec2) ---;
	@(link_name = "igPushTextWrapPos")                  push_text_wrap_pos                     :: proc(wrap_local_pos_x : f32 = 0.0) ---;
	                                                   	radio_button_bool                      :: proc(label : string, active : bool) -> bool do return ig_radio_button_bool(_make_label_string(label), active);
	                                                   	radio_button_int_ptr                   :: proc(label : string, v : ^i32, v_button : i32) -> bool do return ig_radio_button_int_ptr(_make_label_string(label), v, v_button);
	@(link_name = "igRender")                           render                                 :: proc() ---;
	@(link_name = "igResetMouseDragDelta")              reset_mouse_drag_delta                 :: proc(button : i32 = 0) ---;
	@(link_name = "igSameLine")                         same_line                              :: proc(offset_from_start_x : f32 = 0.0, spacing : f32 = -1.0) ---;
	@(link_name = "igSaveIniSettingsToDisk")            save_ini_settings_to_disk              :: proc(ini_filename : cstring) ---;
	@(link_name = "igSaveIniSettingsToMemory")          save_ini_settings_to_memory            :: proc(out_ini_size : ^uint = nil) -> cstring ---;
	                                                   	selectable                             :: proc(label : string, selected : bool = false, flags : Selectable_Flags = 0, size := Vec2{0,0}) -> bool do return ig_selectable(_make_label_string(label), selected, flags, size);
	                                                   	selectable_bool_ptr                    :: proc(label : string, p_selected : ^bool, flags : Selectable_Flags = 0, size := Vec2{0,0}) -> bool do return ig_selectable_bool_ptr(_make_label_string(label), p_selected, flags, size);
	@(link_name = "igSeparator")                        separator                              :: proc() ---;
	@(link_name = "igSetAllocatorFunctions")            set_allocator_functions                :: proc(alloc_func : proc "c"(sz : uint, user_date : rawptr) -> rawptr, free_func : proc "c"(ptr : rawptr, user_date : rawptr) -> rawptr, user_data : rawptr = nil) ---;
	@(link_name = "igSetClipboardText")                 set_clipboard_text                     :: proc(text : cstring) ---;
	@(link_name = "igSetColorEditOptions")              set_color_edit_options                 :: proc(flags : Color_Edit_Flags) ---;
	@(link_name = "igSetColumnOffset")                  set_column_offset                      :: proc(column_index : i32, offset_x : f32) ---;
	@(link_name = "igSetColumnWidth")                   set_column_width                       :: proc(column_index : i32, width : f32) ---;
	@(link_name = "igSetCurrentContext")                set_current_context                    :: proc(ctx : ^Context) ---;
	@(link_name = "igSetCursorPos")                     set_cursor_pos                         :: proc(local_pos : Vec2) ---;
	@(link_name = "igSetCursorPosX")                    set_cursor_pos_x                       :: proc(local_x : f32) ---;
	@(link_name = "igSetCursorPosY")                    set_cursor_pos_y                       :: proc(local_y : f32) ---;
	@(link_name = "igSetCursorScreenPos")               set_cursor_screen_pos                  :: proc(pos : Vec2) ---;
	@(link_name = "igSetDragDropPayload")               set_drag_drop_payload                  :: proc(type : cstring, data : rawptr, sz : uint, cond : Cond = 0) -> bool ---;
	@(link_name = "igSetItemAllowOverlap")              set_item_allow_overlap                 :: proc() ---;
	@(link_name = "igSetItemDefaultFocus")              set_item_default_focus                 :: proc() ---;
	@(link_name = "igSetKeyboardFocusHere")             set_keyboard_focus_here                :: proc(offset : i32 = 0) ---;
	@(link_name = "igSetMouseCursor")                   set_mouse_cursor                       :: proc(type : Mouse_Cursor) ---;
	@(link_name = "igSetNextItemOpen")                  set_next_item_open                     :: proc(is_open : bool, cond : Cond = 0) ---;
	@(link_name = "igSetNextItemWidth")                 set_next_item_width                    :: proc(item_width : f32) ---;
	@(link_name = "igSetNextWindowBgAlpha")             set_next_window_bg_alpha               :: proc(alpha : f32) ---;
	@(link_name = "igSetNextWindowCollapsed")           set_next_window_collapsed              :: proc(collapsed : bool, cond : Cond = 0) ---;
	@(link_name = "igSetNextWindowContentSize")         set_next_window_content_size           :: proc(size : Vec2) ---;
	@(link_name = "igSetNextWindowFocus")               set_next_window_focus                  :: proc() ---;
	@(link_name = "igSetNextWindowPos")                 set_next_window_pos                    :: proc(pos : Vec2, cond : Cond = 0, pivot := Vec2{0,0}) ---;
	@(link_name = "igSetNextWindowSize")                set_next_window_size                   :: proc(size : Vec2, cond : Cond = 0) ---;
	@(link_name = "igSetNextWindowSizeConstraints")     set_next_window_size_constraints       :: proc(size_min : Vec2, size_max : Vec2, custom_callback : Size_Callback = nil, custom_callback_data : rawptr = nil) ---;
	@(link_name = "igSetScrollFromPosX")                set_scroll_from_pos_x                  :: proc(local_x : f32, center_x_ratio : f32 = 0.5) ---;
	@(link_name = "igSetScrollFromPosY")                set_scroll_from_pos_y                  :: proc(local_y : f32, center_y_ratio : f32 = 0.5) ---;
	@(link_name = "igSetScrollHereX")                   set_scroll_here_x                      :: proc(center_x_ratio : f32 = 0.5) ---;
	@(link_name = "igSetScrollHereY")                   set_scroll_here_y                      :: proc(center_y_ratio : f32 = 0.5) ---;
	@(link_name = "igSetScrollX")                       set_scroll_x                           :: proc(scroll_x : f32) ---;
	@(link_name = "igSetScrollY")                       set_scroll_y                           :: proc(scroll_y : f32) ---;
	@(link_name = "igSetStateStorage")                  set_state_storage                      :: proc(storage : ^Storage) ---;
	@(link_name = "igSetTabItemClosed")                 set_tab_item_closed                    :: proc(tab_or_docked_window_label : cstring) ---;
	@(link_name = "igSetTooltip")                       set_tooltip                            :: proc(fmt : cstring, #c_vararg args : ..any) ---;
	@(link_name = "igSetWindowCollapsedBool")           set_window_collapsed                   :: proc(collapsed : bool, cond : Cond = 0) ---;
	                                                   	set_window_collapsed_str               :: proc(name : string, collapsed : bool, cond : Cond = 0) do return ig_set_window_collapsed_str(_make_label_string(name), collapsed, cond);
	@(link_name = "igSetWindowFocus")                   set_window_focus                       :: proc() ---;
	                                                   	set_window_focus_str                   :: proc(name : string) do return ig_set_window_focus_str(_make_label_string(name));
	@(link_name = "igSetWindowFontScale")               set_window_font_scale                  :: proc(scale : f32) ---;
	@(link_name = "igSetWindowPosVec2")                 set_window_pos                         :: proc(pos : Vec2, cond : Cond = 0) ---;
	                                                   	set_window_pos_str                     :: proc(name : string, pos : Vec2, cond : Cond = 0) do return ig_set_window_pos_str(_make_label_string(name), pos, cond);
	@(link_name = "igSetWindowSizeVec2")                set_window_size                        :: proc(size : Vec2, cond : Cond = 0) ---;
	                                                   	set_window_size_str                    :: proc(name : string, size : Vec2, cond : Cond = 0) do return ig_set_window_size_str(_make_label_string(name), size, cond);
	@(link_name = "igShowAboutWindow")                  show_about_window                      :: proc(p_open : ^bool = nil) ---;
	@(link_name = "igShowDemoWindow")                   show_demo_window                       :: proc(p_open : ^bool = nil) ---;
	                                                   	show_font_selector                     :: proc(label : string) do return ig_show_font_selector(_make_label_string(label));
	@(link_name = "igShowMetricsWindow")                show_metrics_window                    :: proc(p_open : ^bool = nil) ---;
	@(link_name = "igShowStyleEditor")                  show_style_editor                      :: proc(ref : ^Style = nil) ---;
	                                                   	show_style_selector                    :: proc(label : string) -> bool do return ig_show_style_selector(_make_label_string(label));
	@(link_name = "igShowUserGuide")                    show_user_guide                        :: proc() ---;
	                                                   	slider_angle                           :: proc(label : string, v_rad : ^f32, v_degrees_min : f32 = -360.0, v_degrees_max : f32 = +360.0, format : cstring = "%.0f deg") -> bool do return ig_slider_angle(_make_label_string(label), v_rad, v_degrees_min, v_degrees_max, format);
	                                                   	slider_float                           :: proc(label : string, v : ^f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_slider_float(_make_label_string(label), v, v_min, v_max, format, power);
	                                                   	slider_float_2                         :: proc(label : string, v : Float[2], v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_slider_float_2(_make_label_string(label), v, v_min, v_max, format, power);
	                                                   	slider_float_3                         :: proc(label : string, v : Float[3], v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_slider_float_3(_make_label_string(label), v, v_min, v_max, format, power);
	                                                   	slider_float_4                         :: proc(label : string, v : Float[4], v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_slider_float_4(_make_label_string(label), v, v_min, v_max, format, power);
	                                                   	slider_int                             :: proc(label : string, v : ^i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool do return ig_slider_int(_make_label_string(label), v, v_min, v_max, format);
	                                                   	slider_int_2                           :: proc(label : string, v : Int[2], v_min : i32, v_max : i32, format : cstring = "%d") -> bool do return ig_slider_int_2(_make_label_string(label), v, v_min, v_max, format);
	                                                   	slider_int_3                           :: proc(label : string, v : Int[3], v_min : i32, v_max : i32, format : cstring = "%d") -> bool do return ig_slider_int_3(_make_label_string(label), v, v_min, v_max, format);
	                                                   	slider_int_4                           :: proc(label : string, v : Int[4], v_min : i32, v_max : i32, format : cstring = "%d") -> bool do return ig_slider_int_4(_make_label_string(label), v, v_min, v_max, format);
	                                                   	slider_scalar                          :: proc(label : string, data_type : Data_Type, p_data : rawptr, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool do return ig_slider_scalar(_make_label_string(label), data_type, p_data, p_min, p_max, format, power);
	                                                   	slider_scalar_n                        :: proc(label : string, data_type : Data_Type, p_data : rawptr, components : i32, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool do return ig_slider_scalar_n(_make_label_string(label), data_type, p_data, components, p_min, p_max, format, power);
	                                                   	small_button                           :: proc(label : string) -> bool do return ig_small_button(_make_label_string(label));
	@(link_name = "igSpacing")                          spacing                                :: proc() ---;
	@(link_name = "igStyleColorsClassic")               style_colors_classic                   :: proc(dst : ^Style = nil) ---;
	@(link_name = "igStyleColorsDark")                  style_colors_dark                      :: proc(dst : ^Style = nil) ---;
	@(link_name = "igStyleColorsLight")                 style_colors_light                     :: proc(dst : ^Style = nil) ---;
	@(link_name = "igText")                             text                                   :: proc(fmt : cstring, #c_vararg args : ..any) ---;
	@(link_name = "igTextColored")                      text_colored                           :: proc(col : Vec4, fmt : cstring, #c_vararg args : ..any) ---;
	@(link_name = "igTextDisabled")                     text_disabled                          :: proc(fmt : cstring, #c_vararg args : ..any) ---;
	@(link_name = "igTextUnformatted")                  text_unformatted                       :: proc(text : cstring, text_end : cstring = nil) ---;
	@(link_name = "igTextWrapped")                      text_wrapped                           :: proc(fmt : cstring, #c_vararg args : ..any) ---;
	                                                   	tree_node_str                          :: proc(label : string) -> bool do return ig_tree_node_str(_make_label_string(label));
	                                                   	tree_node_str_str                      :: proc(str_id : string, fmt : cstring, #c_vararg args : ..any) -> bool do return ig_tree_node_str_str(_make_label_string(str_id), fmt, args);
	@(link_name = "igTreeNodePtr")                      tree_node                              :: proc(ptr_id : rawptr, fmt : cstring, #c_vararg args : ..any) -> bool ---;
	                                                   	tree_node_ex_str                       :: proc(label : string, flags : Tree_Node_Flags = 0) -> bool do return ig_tree_node_ex_str(_make_label_string(label), flags);
	                                                   	tree_node_ex_str_str                   :: proc(str_id : string, flags : Tree_Node_Flags, fmt : cstring, #c_vararg args : ..any) -> bool do return ig_tree_node_ex_str_str(_make_label_string(str_id), flags, fmt, args);
	@(link_name = "igTreeNodeExPtr")                    tree_node_ex                           :: proc(ptr_id : rawptr, flags : Tree_Node_Flags, fmt : cstring, #c_vararg args : ..any) -> bool ---;
	@(link_name = "igTreePop")                          tree_pop                               :: proc() ---;
	                                                   	tree_push_str                          :: proc(str_id : string) do return ig_tree_push_str(_make_label_string(str_id));
	@(link_name = "igTreePushPtr")                      tree_push                              :: proc(ptr_id : rawptr = nil) ---;
	@(link_name = "igUnindent")                         unindent                               :: proc(indent_w : f32 = 0.0) ---;
	                                                   	v_slider_float                         :: proc(label : string, size : Vec2, v : ^f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool do return ig_v_slider_float(_make_label_string(label), size, v, v_min, v_max, format, power);
	                                                   	v_slider_int                           :: proc(label : string, size : Vec2, v : ^i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool do return ig_v_slider_int(_make_label_string(label), size, v, v_min, v_max, format);
	                                                   	v_slider_scalar                        :: proc(label : string, size : Vec2, data_type : Data_Type, p_data : rawptr, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool do return ig_v_slider_scalar(_make_label_string(label), size, data_type, p_data, p_min, p_max, format, power);
	                                                   	value_bool                             :: proc(prefix : string, b : bool) do return ig_value_bool(_make_label_string(prefix), b);
	                                                   	value_int                              :: proc(prefix : string, v : i32) do return ig_value_int(_make_label_string(prefix), v);
	                                                   	value_uint                             :: proc(prefix : string, v : u32) do return ig_value_uint(_make_label_string(prefix), v);
	                                                   	value_float                            :: proc(prefix : string, v : f32, float_format : cstring = nil) do return ig_value_float(_make_label_string(prefix), v, float_format);


	@(link_name = "igArrowButton")                      ig_arrow_button                        :: proc(str_id : cstring, dir : Dir) -> bool ---;
	@(link_name = "igBegin")                            ig_begin                               :: proc(name : cstring, p_open : ^bool = nil, flags : Window_Flags = 0) -> bool ---;
	@(link_name = "igBeginChild")                       ig_begin_child                         :: proc(str_id : cstring, size := Vec2{0,0}, border : bool = false, flags : Window_Flags = 0) -> bool ---;
	@(link_name = "igBeginCombo")                       ig_begin_combo                         :: proc(label : cstring, preview_value : cstring, flags : Combo_Flags = 0) -> bool ---;
	@(link_name = "igBeginMenu")                        ig_begin_menu                          :: proc(label : cstring, enabled : bool = true) -> bool ---;
	@(link_name = "igBeginPopup")                       ig_begin_popup                         :: proc(str_id : cstring, flags : Window_Flags = 0) -> bool ---;
	@(link_name = "igBeginPopupContextItem")            ig_begin_popup_context_item            :: proc(str_id : cstring = nil, mouse_button : i32 = 1) -> bool ---;
	@(link_name = "igBeginPopupContextVoid")            ig_begin_popup_context_void            :: proc(str_id : cstring = nil, mouse_button : i32 = 1) -> bool ---;
	@(link_name = "igBeginPopupContextWindow")          ig_begin_popup_context_window          :: proc(str_id : cstring = nil, mouse_button : i32 = 1, also_over_items : bool = true) -> bool ---;
	@(link_name = "igBeginPopupModal")                  ig_begin_popup_modal                   :: proc(name : cstring, p_open : ^bool = nil, flags : Window_Flags = 0) -> bool ---;
	@(link_name = "igBeginTabBar")                      ig_begin_tab_bar                       :: proc(str_id : cstring, flags : Tab_Bar_Flags = 0) -> bool ---;
	@(link_name = "igBeginTabItem")                     ig_begin_tab_item                      :: proc(label : cstring, p_open : ^bool = nil, flags : Tab_Item_Flags = 0) -> bool ---;
	@(link_name = "igButton")                           ig_button                              :: proc(label : cstring, size := Vec2{0,0}) -> bool ---;
	@(link_name = "igCheckbox")                         ig_checkbox                            :: proc(label : cstring, v : ^bool) -> bool ---;
	@(link_name = "igCheckboxFlags")                    ig_checkbox_flags                      :: proc(label : cstring, flags : ^u32, flags_value : u32) -> bool ---;
	@(link_name = "igCollapsingHeader")                 ig_collapsing_header                   :: proc(label : cstring, flags : Tree_Node_Flags = 0) -> bool ---;
	@(link_name = "igCollapsingHeaderBoolPtr")          ig_collapsing_header_bool_ptr          :: proc(label : cstring, p_open : ^bool, flags : Tree_Node_Flags = 0) -> bool ---;
	@(link_name = "igColorEdit3")                       ig_color_edit_3                        :: proc(label : cstring, col : Float[3], flags : Color_Edit_Flags = 0) -> bool ---;
	@(link_name = "igColorEdit4")                       ig_color_edit_4                        :: proc(label : cstring, col : Float[4], flags : Color_Edit_Flags = 0) -> bool ---;
	@(link_name = "igColorPicker3")                     ig_color_picker_3                      :: proc(label : cstring, col : Float[3], flags : Color_Edit_Flags = 0) -> bool ---;
	@(link_name = "igColorPicker4")                     ig_color_picker_4                      :: proc(label : cstring, col : Float[4], flags : Color_Edit_Flags = 0, ref_col : ^f32 = nil) -> bool ---;
	@(link_name = "igCombo")                            ig_combo                               :: proc(label : cstring, current_item : ^i32, items : i8, items_count : i32, popup_max_height_in_items : i32 = -1) -> bool ---;
	@(link_name = "igComboStr")                         ig_combo_str                           :: proc(label : cstring, current_item : ^i32, items_separated_by_zeros : cstring, popup_max_height_in_items : i32 = -1) -> bool ---;
	@(link_name = "igComboFnPtr")                       ig_combo_fn_ptr                        :: proc(label : cstring, current_item : ^i32, items_getter : proc "c"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, popup_max_height_in_items : i32 = -1) -> bool ---;
	@(link_name = "igDragFloat")                        ig_drag_float                          :: proc(label : cstring, v : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igDragFloat2")                       ig_drag_float_2                        :: proc(label : cstring, v : Float[2], v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igDragFloat3")                       ig_drag_float_3                        :: proc(label : cstring, v : Float[3], v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igDragFloat4")                       ig_drag_float_4                        :: proc(label : cstring, v : Float[4], v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igDragFloatRange2")                  ig_drag_float_range_2                  :: proc(label : cstring, v_current_min : ^f32, v_current_max : ^f32, v_speed : f32 = 1.0, v_min : f32 = 0.0, v_max : f32 = 0.0, format : cstring = "%.3f", format_max : cstring = nil, power : f32 = 1.0) -> bool ---;
	@(link_name = "igDragInt")                          ig_drag_int                            :: proc(label : cstring, v : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool ---;
	@(link_name = "igDragInt2")                         ig_drag_int_2                          :: proc(label : cstring, v : Int[2], v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool ---;
	@(link_name = "igDragInt3")                         ig_drag_int_3                          :: proc(label : cstring, v : Int[3], v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool ---;
	@(link_name = "igDragInt4")                         ig_drag_int_4                          :: proc(label : cstring, v : Int[4], v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d") -> bool ---;
	@(link_name = "igDragIntRange2")                    ig_drag_int_range_2                    :: proc(label : cstring, v_current_min : ^i32, v_current_max : ^i32, v_speed : f32 = 1.0, v_min : i32 = 0, v_max : i32 = 0, format : cstring = "%d", format_max : cstring = nil) -> bool ---;
	@(link_name = "igDragScalar")                       ig_drag_scalar                         :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	@(link_name = "igDragScalarN")                      ig_drag_scalar_n                       :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, components : i32, v_speed : f32, p_min : rawptr = nil, p_max : rawptr = nil, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	@(link_name = "igGetIDStr")                         ig_get_id_str                          :: proc(str_id : cstring) -> ID ---;
	@(link_name = "igInputDouble")                      ig_input_double                        :: proc(label : cstring, v : ^f64, step : f64 = 0.0, step_fast : f64 = 0.0, format : cstring = "%.6f", flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputFloat")                       ig_input_float                         :: proc(label : cstring, v : ^f32, step : f32 = 0.0, step_fast : f32 = 0.0, format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputFloat2")                      ig_input_float_2                       :: proc(label : cstring, v : Float[2], format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputFloat3")                      ig_input_float_3                       :: proc(label : cstring, v : Float[3], format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputFloat4")                      ig_input_float_4                       :: proc(label : cstring, v : Float[4], format : cstring = "%.3f", flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputInt")                         ig_input_int                           :: proc(label : cstring, v : ^i32, step : i32 = 1, step_fast : i32 = 100, flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputInt2")                        ig_input_int_2                         :: proc(label : cstring, v : Int[2], flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputInt3")                        ig_input_int_3                         :: proc(label : cstring, v : Int[3], flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputInt4")                        ig_input_int_4                         :: proc(label : cstring, v : Int[4], flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputScalar")                      ig_input_scalar                        :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, p_step : rawptr = nil, p_step_fast : rawptr = nil, format : cstring = nil, flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputScalarN")                     ig_input_scalar_n                      :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, components : i32, p_step : rawptr = nil, p_step_fast : rawptr = nil, format : cstring = nil, flags : Input_Text_Flags = 0) -> bool ---;
	@(link_name = "igInputText")                        ig_input_text                          :: proc(label : cstring, buf : ^i8, buf_size : uint, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool ---;
	@(link_name = "igInputTextMultiline")               ig_input_text_multiline                :: proc(label : cstring, buf : ^i8, buf_size : uint, size := Vec2{0,0}, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool ---;
	@(link_name = "igInputTextWithHint")                ig_input_text_with_hint                :: proc(label : cstring, hint : cstring, buf : ^i8, buf_size : uint, flags : Input_Text_Flags = 0, callback : Input_Text_Callback = nil, user_data : rawptr = nil) -> bool ---;
	@(link_name = "igInvisibleButton")                  ig_invisible_button                    :: proc(str_id : cstring, size : Vec2) -> bool ---;
	@(link_name = "igIsPopupOpen")                      ig_is_popup_open                       :: proc(str_id : cstring) -> bool ---;
	@(link_name = "igLabelText")                        ig_label_text                          :: proc(label : cstring, fmt : cstring, #c_vararg args : ..any) ---;
	@(link_name = "igListBoxStr_arr")                   ig_list_box_str_arr                    :: proc(label : cstring, current_item : ^i32, items : i8, items_count : i32, height_in_items : i32 = -1) -> bool ---;
	@(link_name = "igListBoxFnPtr")                     ig_list_box_fn_ptr                     :: proc(label : cstring, current_item : ^i32, items_getter : proc "c"(data : rawptr, idx : i32, out_text : ^^u8) -> bool, data : rawptr, items_count : i32, height_in_items : i32 = -1) -> bool ---;
	@(link_name = "igListBoxHeaderVec2")                ig_list_box_header_vec_2               :: proc(label : cstring, size := Vec2{0,0}) -> bool ---;
	@(link_name = "igListBoxHeaderInt")                 ig_list_box_header_int                 :: proc(label : cstring, items_count : i32, height_in_items : i32 = -1) -> bool ---;
	@(link_name = "igMenuItemBool")                     ig_menu_item_bool                      :: proc(label : cstring, shortcut : cstring = nil, selected : bool = false, enabled : bool = true) -> bool ---;
	@(link_name = "igMenuItemBoolPtr")                  ig_menu_item_bool_ptr                  :: proc(label : cstring, shortcut : cstring, p_selected : ^bool, enabled : bool = true) -> bool ---;
	@(link_name = "igOpenPopup")                        ig_open_popup                          :: proc(str_id : cstring) ---;
	@(link_name = "igOpenPopupOnItemClick")             ig_open_popup_on_item_click            :: proc(str_id : cstring = nil, mouse_button : i32 = 1) -> bool ---;
	@(link_name = "igPlotHistogramFloatPtr")            ig_plot_histogram_float_ptr            :: proc(label : cstring, values : ^f32, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}, stride := size_of(f32)) ---;
	@(link_name = "igPlotHistogramFnPtr")               ig_plot_histogram_fn_ptr               :: proc(label : cstring, values_getter : proc "c"(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}) ---;
	@(link_name = "igPlotLines")                        ig_plot_lines                          :: proc(label : cstring, values : ^f32, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}, stride := size_of(f32)) ---;
	@(link_name = "igPlotLinesFnPtr")                   ig_plot_lines_fn_ptr                   :: proc(label : cstring, values_getter : proc "c"(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32 = 0, overlay_text : cstring = nil, scale_min := max(f32), scale_max := max(f32), graph_size := Vec2{0,0}) ---;
	@(link_name = "igPushIDStr")                        ig_push_id_str                         :: proc(str_id : cstring) ---;
	@(link_name = "igRadioButtonBool")                  ig_radio_button_bool                   :: proc(label : cstring, active : bool) -> bool ---;
	@(link_name = "igRadioButtonIntPtr")                ig_radio_button_int_ptr                :: proc(label : cstring, v : ^i32, v_button : i32) -> bool ---;
	@(link_name = "igSelectable")                       ig_selectable                          :: proc(label : cstring, selected : bool = false, flags : Selectable_Flags = 0, size := Vec2{0,0}) -> bool ---;
	@(link_name = "igSelectableBoolPtr")                ig_selectable_bool_ptr                 :: proc(label : cstring, p_selected : ^bool, flags : Selectable_Flags = 0, size := Vec2{0,0}) -> bool ---;
	@(link_name = "igSetWindowCollapsedStr")            ig_set_window_collapsed_str            :: proc(name : cstring, collapsed : bool, cond : Cond = 0) ---;
	@(link_name = "igSetWindowFocusStr")                ig_set_window_focus_str                :: proc(name : cstring) ---;
	@(link_name = "igSetWindowPosStr")                  ig_set_window_pos_str                  :: proc(name : cstring, pos : Vec2, cond : Cond = 0) ---;
	@(link_name = "igSetWindowSizeStr")                 ig_set_window_size_str                 :: proc(name : cstring, size : Vec2, cond : Cond = 0) ---;
	@(link_name = "igShowFontSelector")                 ig_show_font_selector                  :: proc(label : cstring) ---;
	@(link_name = "igShowStyleSelector")                ig_show_style_selector                 :: proc(label : cstring) -> bool ---;
	@(link_name = "igSliderAngle")                      ig_slider_angle                        :: proc(label : cstring, v_rad : ^f32, v_degrees_min : f32 = -360.0, v_degrees_max : f32 = +360.0, format : cstring = "%.0f deg") -> bool ---;
	@(link_name = "igSliderFloat")                      ig_slider_float                        :: proc(label : cstring, v : ^f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igSliderFloat2")                     ig_slider_float_2                      :: proc(label : cstring, v : Float[2], v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igSliderFloat3")                     ig_slider_float_3                      :: proc(label : cstring, v : Float[3], v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igSliderFloat4")                     ig_slider_float_4                      :: proc(label : cstring, v : Float[4], v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igSliderInt")                        ig_slider_int                          :: proc(label : cstring, v : ^i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	@(link_name = "igSliderInt2")                       ig_slider_int_2                        :: proc(label : cstring, v : Int[2], v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	@(link_name = "igSliderInt3")                       ig_slider_int_3                        :: proc(label : cstring, v : Int[3], v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	@(link_name = "igSliderInt4")                       ig_slider_int_4                        :: proc(label : cstring, v : Int[4], v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	@(link_name = "igSliderScalar")                     ig_slider_scalar                       :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	@(link_name = "igSliderScalarN")                    ig_slider_scalar_n                     :: proc(label : cstring, data_type : Data_Type, p_data : rawptr, components : i32, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	@(link_name = "igSmallButton")                      ig_small_button                        :: proc(label : cstring) -> bool ---;
	@(link_name = "igTreeNodeStr")                      ig_tree_node_str                       :: proc(label : cstring) -> bool ---;
	@(link_name = "igTreeNodeStrStr")                   ig_tree_node_str_str                   :: proc(str_id : cstring, fmt : cstring, #c_vararg args : ..any) -> bool ---;
	@(link_name = "igTreeNodeExStr")                    ig_tree_node_ex_str                    :: proc(label : cstring, flags : Tree_Node_Flags = 0) -> bool ---;
	@(link_name = "igTreeNodeExStrStr")                 ig_tree_node_ex_str_str                :: proc(str_id : cstring, flags : Tree_Node_Flags, fmt : cstring, #c_vararg args : ..any) -> bool ---;
	@(link_name = "igTreePushStr")                      ig_tree_push_str                       :: proc(str_id : cstring) ---;
	@(link_name = "igVSliderFloat")                     ig_v_slider_float                      :: proc(label : cstring, size : Vec2, v : ^f32, v_min : f32, v_max : f32, format : cstring = "%.3f", power : f32 = 1.0) -> bool ---;
	@(link_name = "igVSliderInt")                       ig_v_slider_int                        :: proc(label : cstring, size : Vec2, v : ^i32, v_min : i32, v_max : i32, format : cstring = "%d") -> bool ---;
	@(link_name = "igVSliderScalar")                    ig_v_slider_scalar                     :: proc(label : cstring, size : Vec2, data_type : Data_Type, p_data : rawptr, p_min : rawptr, p_max : rawptr, format : cstring = nil, power : f32 = 1.0) -> bool ---;
	@(link_name = "igValueBool")                        ig_value_bool                          :: proc(prefix : cstring, b : bool) ---;
	@(link_name = "igValueInt")                         ig_value_int                           :: proc(prefix : cstring, v : i32) ---;
	@(link_name = "igValueUint")                        ig_value_uint                          :: proc(prefix : cstring, v : u32) ---;
	@(link_name = "igValueFloat")                       ig_value_float                         :: proc(prefix : cstring, v : f32, float_format : cstring = nil) ---;
}

