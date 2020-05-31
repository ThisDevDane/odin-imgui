package imgui;

//ImBitVector 
Bit_Vector :: struct {
	storage: Im_Vector(u32),
}

//ImColor 
Color :: struct {
	value: Vec4,
}

//ImDrawChannel 
Draw_Channel :: struct {
	_cmd_buffer: Im_Vector(Draw_Cmd),
	_idx_buffer: Im_Vector(Draw_Idx),
}

//ImDrawCmd 
Draw_Cmd :: struct {
	elem_count:         u32,
	clip_rect:          Vec4,
	texture_id:         Texture_ID,
	vtx_offset:         u32,
	idx_offset:         u32,
	user_callback:      Draw_Callback,
	user_callback_data: rawptr,
}

//ImDrawData 
Draw_Data :: struct {
	valid:             bool,
	cmd_lists:         ^^Draw_List,
	cmd_lists_count:   i32,
	total_idx_count:   i32,
	total_vtx_count:   i32,
	display_pos:       Vec2,
	display_size:      Vec2,
	framebuffer_scale: Vec2,
}

//ImDrawDataBuilder 
Draw_Data_Builder :: struct {
	layers: [2]Im_Vector(^Draw_List),
}

//ImDrawList 
Draw_List :: struct {
	cmd_buffer:          Im_Vector(Draw_Cmd),
	idx_buffer:          Im_Vector(Draw_Idx),
	vtx_buffer:          Im_Vector(Draw_Vert),
	flags:               Draw_List_Flags,
	_data:               ^Draw_List_Shared_Data,
	_owner_name:         cstring,
	_vtx_current_offset: u32,
	_vtx_current_idx:    u32,
	_vtx_write_ptr:      ^Draw_Vert,
	_idx_write_ptr:      ^Draw_Idx,
	_clip_rect_stack:    Im_Vector(Vec4),
	_texture_id_stack:   Im_Vector(Texture_ID),
	_path:               Im_Vector(Vec2),
	_splitter:           Draw_List_Splitter,
}

//ImDrawListSharedData 
Draw_List_Shared_Data :: struct {
	tex_uv_white_pixel:       Vec2,
	font:                     ^ImFont,
	font_size:                f32,
	curve_tessellation_tol:   f32,
	circle_segment_max_error: f32,
	clip_rect_fullscreen:     Vec4,
	initial_flags:            Draw_List_Flags,
	arc_fast_vtx:             [12]Vec2,
	circle_segment_counts:    [64]u8,
}

//ImDrawListSplitter 
Draw_List_Splitter :: struct {
	_current:  i32,
	_count:    i32,
	_channels: Im_Vector(Draw_Channel),
}

//ImDrawVert 
Draw_Vert :: struct {
	pos: Vec2,
	uv:  Vec2,
	col: u32,
}

//ImFont 
ImFont :: struct {
	index_advance_x:       Im_Vector(f32),
	fallback_advance_x:    f32,
	font_size:             f32,
	index_lookup:          Im_Vector(Wchar),
	glyphs:                Im_Vector(Font_Glyph),
	fallback_glyph:        ^Font_Glyph,
	display_offset:        Vec2,
	container_atlas:       ^Font_Atlas,
	config_data:           ^Font_Config,
	config_data_count:     i16,
	fallback_char:         Wchar,
	ellipsis_char:         Wchar,
	dirty_lookup_tables:   bool,
	scale:                 f32,
	ascent:                f32,
	descent:               f32,
	metrics_total_surface: i32,
	used4k_pages_map:      [2]u8,
}

//ImFontAtlas 
Font_Atlas :: struct {
	locked:             bool,
	flags:              Font_Atlas_Flags,
	tex_id:             Texture_ID,
	tex_desired_width:  i32,
	tex_glyph_padding:  i32,
	tex_pixels_alpha8:  ^u8,
	tex_pixels_rgba32:  ^u32,
	tex_width:          i32,
	tex_height:         i32,
	tex_uv_scale:       Vec2,
	tex_uv_white_pixel: Vec2,
	fonts:              Im_Vector(^ImFont),
	custom_rects:       Im_Vector(Font_Atlas_Custom_Rect),
	config_data:        Im_Vector(Font_Config),
	custom_rect_ids:    [1]i32,
}

//ImFontAtlasCustomRect 
Font_Atlas_Custom_Rect :: struct {
	id:              u32,
	width:           u16,
	height:          u16,
	x:               u16,
	y:               u16,
	glyph_advance_x: f32,
	glyph_offset:    Vec2,
	font:            ^ImFont,
}

//ImFontConfig 
Font_Config :: struct {
	font_data:                rawptr,
	font_data_size:           i32,
	font_data_owned_by_atlas: bool,
	font_no:                  i32,
	size_pixels:              f32,
	oversample_h:             i32,
	oversample_v:             i32,
	pixel_snap_h:             bool,
	glyph_extra_spacing:      Vec2,
	glyph_offset:             Vec2,
	glyph_ranges:             ^Wchar,
	glyph_min_advance_x:      f32,
	glyph_max_advance_x:      f32,
	merge_mode:               bool,
	rasterizer_flags:         u32,
	rasterizer_multiply:      f32,
	ellipsis_char:            Wchar,
	name:                     [40]i8,
	dst_font:                 ^ImFont,
}

//ImFontGlyph 
Font_Glyph :: struct {
	codepoint: u32,
	visible:   u32,
	advance_x: f32,
	x0:        f32,
	y0:        f32,
	x1:        f32,
	y1:        f32,
	u0:        f32,
	v0:        f32,
	u1:        f32,
	v1:        f32,
}

//ImFontGlyphRangesBuilder 
Font_Glyph_Ranges_Builder :: struct {
	used_chars: Im_Vector(u32),
}

//ImGuiColorMod 
Color_Mod :: struct {
	col:          Col,
	backup_value: Vec4,
}

//ImGuiColumnData 
Column_Data :: struct {
	offset_norm:               f32,
	offset_norm_before_resize: f32,
	flags:                     Columns_Flags,
	clip_rect:                 Rect,
}

//ImGuiColumns 
Columns :: struct {
	id:                    ImID,
	flags:                 Columns_Flags,
	is_first_frame:        bool,
	is_being_resized:      bool,
	current:               i32,
	count:                 i32,
	off_min_x:             f32,
	off_max_x:             f32,
	line_min_y:            f32,
	line_max_y:            f32,
	host_cursor_pos_y:     f32,
	host_cursor_max_pos_x: f32,
	host_clip_rect:        Rect,
	host_work_rect:        Rect,
	columns:               Im_Vector(Column_Data),
	splitter:              Draw_List_Splitter,
}

//ImGuiContext 
Context :: struct {
	initialized:                                     bool,
	font_atlas_owned_by_context:                     bool,
	io:                                              IO,
	style:                                           Style,
	font:                                            ^ImFont,
	font_size:                                       f32,
	font_base_size:                                  f32,
	draw_list_shared_data:                           Draw_List_Shared_Data,
	time:                                            f64,
	frame_count:                                     i32,
	frame_count_ended:                               i32,
	frame_count_rendered:                            i32,
	within_frame_scope:                              bool,
	within_frame_scope_with_implicit_window:         bool,
	within_end_child:                                bool,
	windows:                                         Im_Vector(^ImWindow),
	windows_focus_order:                             Im_Vector(^ImWindow),
	windows_temp_sort_buffer:                        Im_Vector(^ImWindow),
	current_window_stack:                            Im_Vector(^ImWindow),
	windows_by_id:                                   Storage,
	windows_active_count:                            i32,
	current_window:                                  ^ImWindow,
	hovered_window:                                  ^ImWindow,
	hovered_root_window:                             ^ImWindow,
	moving_window:                                   ^ImWindow,
	wheeling_window:                                 ^ImWindow,
	wheeling_window_ref_mouse_pos:                   Vec2,
	wheeling_window_timer:                           f32,
	hovered_id:                                      ImID,
	hovered_id_allow_overlap:                        bool,
	hovered_id_previous_frame:                       ImID,
	hovered_id_timer:                                f32,
	hovered_id_not_active_timer:                     f32,
	active_id:                                       ImID,
	active_id_is_alive:                              ImID,
	active_id_timer:                                 f32,
	active_id_is_just_activated:                     bool,
	active_id_allow_overlap:                         bool,
	active_id_has_been_pressed_before:               bool,
	active_id_has_been_edited_before:                bool,
	active_id_has_been_edited_this_frame:            bool,
	active_id_using_nav_dir_mask:                    u32,
	active_id_using_nav_input_mask:                  u32,
	active_id_using_key_input_mask:                  u64,
	active_id_click_offset:                          Vec2,
	active_id_window:                                ^ImWindow,
	active_id_source:                                Input_Source,
	active_id_mouse_button:                          i32,
	active_id_previous_frame:                        ImID,
	active_id_previous_frame_is_alive:               bool,
	active_id_previous_frame_has_been_edited_before: bool,
	active_id_previous_frame_window:                 ^ImWindow,
	last_active_id:                                  ImID,
	last_active_id_timer:                            f32,
	next_window_data:                                Next_Window_Data,
	next_item_data:                                  Next_Item_Data,
	color_modifiers:                                 Im_Vector(Color_Mod),
	style_modifiers:                                 Im_Vector(Style_Mod),
	font_stack:                                      Im_Vector(^ImFont),
	open_popup_stack:                                Im_Vector(Popup_Data),
	begin_popup_stack:                               Im_Vector(Popup_Data),
	nav_window:                                      ^ImWindow,
	nav_id:                                          ImID,
	nav_focus_scope_id:                              ImID,
	nav_activate_id:                                 ImID,
	nav_activate_down_id:                            ImID,
	nav_activate_pressed_id:                         ImID,
	nav_input_id:                                    ImID,
	nav_just_tabbed_id:                              ImID,
	nav_just_moved_to_id:                            ImID,
	nav_just_moved_to_focus_scope_id:                ImID,
	nav_just_moved_to_key_mods:                      Key_Mod_Flags,
	nav_next_activate_id:                            ImID,
	nav_input_source:                                Input_Source,
	nav_scoring_rect:                                Rect,
	nav_scoring_count:                               i32,
	nav_layer:                                       Nav_Layer,
	nav_id_tab_counter:                              i32,
	nav_id_is_alive:                                 bool,
	nav_mouse_pos_dirty:                             bool,
	nav_disable_highlight:                           bool,
	nav_disable_mouse_hover:                         bool,
	nav_any_request:                                 bool,
	nav_init_request:                                bool,
	nav_init_request_from_move:                      bool,
	nav_init_result_id:                              ImID,
	nav_init_result_rect_rel:                        Rect,
	nav_move_from_clamped_ref_rect:                  bool,
	nav_move_request:                                bool,
	nav_move_request_flags:                          Nav_Move_Flags,
	nav_move_request_forward:                        Nav_Forward,
	nav_move_request_key_mods:                       Key_Mod_Flags,
	nav_move_dir:                                    Dir,
	nav_move_dir_last:                               Dir,
	nav_move_clip_dir:                               Dir,
	nav_move_result_local:                           Nav_Move_Result,
	nav_move_result_local_visible_set:               Nav_Move_Result,
	nav_move_result_other:                           Nav_Move_Result,
	nav_windowing_target:                            ^ImWindow,
	nav_windowing_target_anim:                       ^ImWindow,
	nav_windowing_list:                              ^ImWindow,
	nav_windowing_timer:                             f32,
	nav_windowing_highlight_alpha:                   f32,
	nav_windowing_toggle_layer:                      bool,
	focus_request_curr_window:                       ^ImWindow,
	focus_request_next_window:                       ^ImWindow,
	focus_request_curr_counter_regular:              i32,
	focus_request_curr_counter_tab_stop:             i32,
	focus_request_next_counter_regular:              i32,
	focus_request_next_counter_tab_stop:             i32,
	focus_tab_pressed:                               bool,
	draw_data:                                       Draw_Data,
	draw_data_builder:                               Draw_Data_Builder,
	dim_bg_ratio:                                    f32,
	background_draw_list:                            Draw_List,
	foreground_draw_list:                            Draw_List,
	mouse_cursor:                                    Mouse_Cursor,
	drag_drop_active:                                bool,
	drag_drop_within_source:                         bool,
	drag_drop_within_target:                         bool,
	drag_drop_source_flags:                          Drag_Drop_Flags,
	drag_drop_source_frame_count:                    i32,
	drag_drop_mouse_button:                          i32,
	drag_drop_payload:                               Payload,
	drag_drop_target_rect:                           Rect,
	drag_drop_target_id:                             ImID,
	drag_drop_accept_flags:                          Drag_Drop_Flags,
	drag_drop_accept_id_curr_rect_surface:           f32,
	drag_drop_accept_id_curr:                        ImID,
	drag_drop_accept_id_prev:                        ImID,
	drag_drop_accept_frame_count:                    i32,
	drag_drop_payload_buf_heap:                      Im_Vector(u8),
	drag_drop_payload_buf_local:                     [16]u8,
	current_tab_bar:                                 ^Tab_Bar,
	tab_bars:                                        Im_Pool(Tab_Bar),
	current_tab_bar_stack:                           Im_Vector(Ptr_Or_Index),
	shrink_width_buffer:                             Im_Vector(Shrink_Width_Item),
	last_valid_mouse_pos:                            Vec2,
	input_text_state:                                Input_Text_State,
	input_text_password_font:                        ImFont,
	temp_input_id:                                   ImID,
	color_edit_options:                              Color_Edit_Flags,
	color_edit_last_hue:                             f32,
	color_edit_last_sat:                             f32,
	color_edit_last_color:                           [3]f32,
	color_picker_ref:                                Vec4,
	drag_current_accum_dirty:                        bool,
	drag_current_accum:                              f32,
	drag_speed_default_ratio:                        f32,
	scrollbar_click_delta_to_grab_center:            f32,
	tooltip_override_count:                          i32,
	clipboard_handler_data:                          Im_Vector(u8),
	menus_id_submitted_this_frame:                   Im_Vector(ImID),
	platform_ime_pos:                                Vec2,
	platform_ime_last_pos:                           Vec2,
	settings_loaded:                                 bool,
	settings_dirty_timer:                            f32,
	settings_ini_data:                               Text_Buffer,
	settings_handlers:                               Im_Vector(Settings_Handler),
	settings_windows:                                Im_Chunk_Stream(Window_Settings),
	log_enabled:                                     bool,
	log_type:                                        Log_Type,
	log_file:                                        File_Handle,
	log_buffer:                                      Text_Buffer,
	log_line_pos_y:                                  f32,
	log_line_first_item:                             bool,
	log_depth_ref:                                   i32,
	log_depth_to_expand:                             i32,
	log_depth_to_expand_default:                     i32,
	debug_item_picker_active:                        bool,
	debug_item_picker_break_id:                      ImID,
	framerate_sec_per_frame:                         [120]f32,
	framerate_sec_per_frame_idx:                     i32,
	framerate_sec_per_frame_accum:                   f32,
	want_capture_mouse_next_frame:                   i32,
	want_capture_keyboard_next_frame:                i32,
	want_text_input_next_frame:                      i32,
	temp_buffer:                                     [3073]i8,
}

//ImGuiDataTypeInfo 
Data_Type_Info :: struct {
	size:      uint,
	print_fmt: cstring,
	scan_fmt:  cstring,
}

//ImGuiGroupData 
Group_Data :: struct {
	backup_cursor_pos:                        Vec2,
	backup_cursor_max_pos:                    Vec2,
	backup_indent:                            Vec1,
	backup_group_offset:                      Vec1,
	backup_curr_line_size:                    Vec2,
	backup_curr_line_text_base_offset:        f32,
	backup_active_id_is_alive:                ImID,
	backup_active_id_previous_frame_is_alive: bool,
	emit_item:                                bool,
}

//ImGuiIO 
IO :: struct {
	config_flags:                            Config_Flags,
	backend_flags:                           Backend_Flags,
	display_size:                            Vec2,
	delta_time:                              f32,
	ini_saving_rate:                         f32,
	ini_filename:                            cstring,
	log_filename:                            cstring,
	mouse_double_click_time:                 f32,
	mouse_double_click_max_dist:             f32,
	mouse_drag_threshold:                    f32,
	key_map:                                 [22]i32,
	key_repeat_delay:                        f32,
	key_repeat_rate:                         f32,
	user_data:                               rawptr,
	fonts:                                   ^Font_Atlas,
	font_global_scale:                       f32,
	font_allow_user_scaling:                 bool,
	font_default:                            ^ImFont,
	display_framebuffer_scale:               Vec2,
	mouse_draw_cursor:                       bool,
	config_mac_osx_behaviors:                bool,
	config_input_text_cursor_blink:          bool,
	config_windows_resize_from_edges:        bool,
	config_windows_move_from_title_bar_only: bool,
	config_windows_memory_compact_timer:     f32,
	backend_platform_name:                   cstring,
	backend_renderer_name:                   cstring,
	backend_platform_user_data:              rawptr,
	backend_renderer_user_data:              rawptr,
	backend_language_user_data:              rawptr,
	get_clipboard_text_fn:                   proc "c"(user_data : rawptr) -> cstring,
	set_clipboard_text_fn:                   proc "c"(user_data : rawptr, text : cstring),
	clipboard_user_data:                     rawptr,
	ime_set_input_screen_pos_fn:             proc "c"(x, y : i32),
	ime_window_handle:                       rawptr,
	render_draw_lists_fn_unused:             rawptr,
	mouse_pos:                               Vec2,
	mouse_down:                              [5]bool,
	mouse_wheel:                             f32,
	mouse_wheel_h:                           f32,
	key_ctrl:                                bool,
	key_shift:                               bool,
	key_alt:                                 bool,
	key_super:                               bool,
	keys_down:                               [512]bool,
	nav_inputs:                              [21]f32,
	want_capture_mouse:                      bool,
	want_capture_keyboard:                   bool,
	want_text_input:                         bool,
	want_set_mouse_pos:                      bool,
	want_save_ini_settings:                  bool,
	nav_active:                              bool,
	nav_visible:                             bool,
	framerate:                               f32,
	metrics_render_vertices:                 i32,
	metrics_render_indices:                  i32,
	metrics_render_windows:                  i32,
	metrics_active_windows:                  i32,
	metrics_active_allocations:              i32,
	mouse_delta:                             Vec2,
	key_mods:                                Key_Mod_Flags,
	mouse_pos_prev:                          Vec2,
	mouse_clicked_pos:                       [5]Vec2,
	mouse_clicked_time:                      [5]f64,
	mouse_clicked:                           [5]bool,
	mouse_double_clicked:                    [5]bool,
	mouse_released:                          [5]bool,
	mouse_down_owned:                        [5]bool,
	mouse_down_was_double_click:             [5]bool,
	mouse_down_duration:                     [5]f32,
	mouse_down_duration_prev:                [5]f32,
	mouse_drag_max_distance_abs:             [5]Vec2,
	mouse_drag_max_distance_sqr:             [5]f32,
	keys_down_duration:                      [512]f32,
	keys_down_duration_prev:                 [512]f32,
	nav_inputs_down_duration:                [21]f32,
	nav_inputs_down_duration_prev:           [21]f32,
	input_queue_surrogate:                   Wchar16,
	input_queue_characters:                  Im_Vector(Wchar),
}

//ImGuiInputTextCallbackData 
Input_Text_Callback_Data :: struct {
	event_flag:      Input_Text_Flags,
	flags:           Input_Text_Flags,
	user_data:       rawptr,
	event_char:      Wchar,
	event_key:       Key,
	buf:             cstring,
	buf_text_len:    i32,
	buf_size:        i32,
	buf_dirty:       bool,
	cursor_pos:      i32,
	selection_start: i32,
	selection_end:   i32,
}

//ImGuiInputTextState 
Input_Text_State :: struct {
	id:                      ImID,
	cur_len_w:               i32,
	cur_len_a:               i32,
	text_w:                  Im_Vector(Wchar),
	text_a:                  Im_Vector(u8),
	initial_text_a:          Im_Vector(u8),
	text_a_is_valid:         bool,
	buf_capacity_a:          i32,
	scroll_x:                f32,
	stb:                     STB_Textedit_State,
	cursor_anim:             f32,
	cursor_follow:           bool,
	selected_all_mouse_lock: bool,
	user_flags:              Input_Text_Flags,
	user_callback:           Input_Text_Callback,
	user_callback_data:      rawptr,
}

//ImGuiItemHoveredDataBackup 
Item_Hovered_Data_Backup :: struct {
	last_item_id:           ImID,
	last_item_status_flags: Item_Status_Flags,
	last_item_rect:         Rect,
	last_item_display_rect: Rect,
}

//ImGuiListClipper 
List_Clipper :: struct {
	display_start: i32,
	display_end:   i32,
	items_count:   i32,
	step_no:       i32,
	items_height:  f32,
	start_pos_y:   f32,
}

//ImGuiMenuColumns 
Menu_Columns :: struct {
	spacing:     f32,
	width:       f32,
	next_width:  f32,
	pos:         [3]f32,
	next_widths: [3]f32,
}

//ImGuiNavMoveResult 
Nav_Move_Result :: struct {
	window:         ^ImWindow,
	id:             ImID,
	focus_scope_id: ImID,
	dist_box:       f32,
	dist_center:    f32,
	dist_axial:     f32,
	rect_rel:       Rect,
}

//ImGuiNextItemData 
Next_Item_Data :: struct {
	flags:          Next_Item_Data_Flags,
	width:          f32,
	focus_scope_id: ImID,
	open_cond:      Cond,
	open_val:       bool,
}

//ImGuiNextWindowData 
Next_Window_Data :: struct {
	flags:                   Next_Window_Data_Flags,
	pos_cond:                Cond,
	size_cond:               Cond,
	collapsed_cond:          Cond,
	pos_val:                 Vec2,
	pos_pivot_val:           Vec2,
	size_val:                Vec2,
	content_size_val:        Vec2,
	collapsed_val:           bool,
	size_constraint_rect:    Rect,
	size_callback:           Size_Callback,
	size_callback_user_data: rawptr,
	bg_alpha_val:            f32,
	menu_bar_offset_min_val: Vec2,
}

//ImGuiOnceUponAFrame 
Once_Upon_A_Frame :: struct {
	ref_frame: i32,
}

//ImGuiPayload 
Payload :: struct {
	data:             rawptr,
	data_size:        i32,
	source_id:        ImID,
	source_parent_id: ImID,
	data_frame_count: i32,
	data_type:        [33]i8,
	preview:          bool,
	delivery:         bool,
}

//ImGuiPopupData 
Popup_Data :: struct {
	popup_id:         ImID,
	window:           ^ImWindow,
	source_window:    ^ImWindow,
	open_frame_count: i32,
	open_parent_id:   ImID,
	open_popup_pos:   Vec2,
	open_mouse_pos:   Vec2,
}

//ImGuiPtrOrIndex 
Ptr_Or_Index :: struct {
	ptr:   rawptr,
	index: i32,
}

Settings_Handler :: struct {
    type_name:    cstring,
    type_hash:    ImID,
    read_open_fn: proc(ctx: ^Context, handler: ^Settings_Handler, name: cstring) -> rawptr,
    read_line_fn: proc(ctx: ^Context, handler: ^Settings_Handler, entry: rawptr, line: cstring),
    write_all_fn: proc(ctx: ^Context, handler: ^Settings_Handler, out_buf: ^Text_Buffer),
    user_data:    rawptr,
}

//ImGuiShrinkWidthItem 
Shrink_Width_Item :: struct {
	index: i32,
	width: f32,
}

//ImGuiSizeCallbackData 
Size_Callback_Data :: struct {
	user_data:    rawptr,
	pos:          Vec2,
	current_size: Vec2,
	desired_size: Vec2,
}

//ImGuiStorage 
Storage :: struct {
	data: Im_Vector(Storage_Pair),
}

Storage_Pair :: struct {
    key: ImID,
    using _: struct #raw_union { 
        val_i: i32, 
        val_f: f32, 
        val_p: rawptr, 
    }
}

//ImGuiStyle 
Style :: struct {
	alpha:                       f32,
	window_padding:              Vec2,
	window_rounding:             f32,
	window_border_size:          f32,
	window_min_size:             Vec2,
	window_title_align:          Vec2,
	window_menu_button_position: Dir,
	child_rounding:              f32,
	child_border_size:           f32,
	popup_rounding:              f32,
	popup_border_size:           f32,
	frame_padding:               Vec2,
	frame_rounding:              f32,
	frame_border_size:           f32,
	item_spacing:                Vec2,
	item_inner_spacing:          Vec2,
	touch_extra_padding:         Vec2,
	indent_spacing:              f32,
	columns_min_spacing:         f32,
	scrollbar_size:              f32,
	scrollbar_rounding:          f32,
	grab_min_size:               f32,
	grab_rounding:               f32,
	tab_rounding:                f32,
	tab_border_size:             f32,
	color_button_position:       Dir,
	button_text_align:           Vec2,
	selectable_text_align:       Vec2,
	display_window_padding:      Vec2,
	display_safe_area_padding:   Vec2,
	mouse_cursor_scale:          f32,
	anti_aliased_lines:          bool,
	anti_aliased_fill:           bool,
	curve_tessellation_tol:      f32,
	circle_segment_max_error:    f32,
	colors:                      [48]Vec4,
}

Style_Mod :: struct {
    var_idx: Style_Var,
    using _: struct #raw_union {
        backup_int: [2]i32,
        backup_float: [2]f32,
    }
}

//ImGuiTabBar 
Tab_Bar :: struct {
	tabs:                                Im_Vector(Tab_Item),
	id:                                  ImID,
	selected_tab_id:                     ImID,
	next_selected_tab_id:                ImID,
	visible_tab_id:                      ImID,
	curr_frame_visible:                  i32,
	prev_frame_visible:                  i32,
	bar_rect:                            Rect,
	last_tab_content_height:             f32,
	offset_max:                          f32,
	offset_max_ideal:                    f32,
	offset_next_tab:                     f32,
	scrolling_anim:                      f32,
	scrolling_target:                    f32,
	scrolling_target_dist_to_visibility: f32,
	scrolling_speed:                     f32,
	flags:                               Tab_Bar_Flags,
	reorder_request_tab_id:              ImID,
	reorder_request_dir:                 i8,
	want_layout:                         bool,
	visible_tab_was_submitted:           bool,
	last_tab_item_idx:                   i16,
	frame_padding:                       Vec2,
	tabs_names:                          Text_Buffer,
}

//ImGuiTabItem 
Tab_Item :: struct {
	id:                  ImID,
	flags:               Tab_Item_Flags,
	last_frame_visible:  i32,
	last_frame_selected: i32,
	name_offset:         i32,
	offset:              f32,
	width:               f32,
	content_width:       f32,
}

//ImGuiTextBuffer 
Text_Buffer :: struct {
	buf: Im_Vector(u8),
}

//ImGuiTextFilter 
Text_Filter :: struct {
	input_buf:  [256]i8,
	filters:    Im_Vector(Text_Range),
	count_grep: i32,
}

//ImGuiTextRange 
Text_Range :: struct {
	b: cstring,
	e: cstring,
}

//ImGuiWindow 
ImWindow :: struct {
	name:                                cstring,
	id:                                  ImID,
	flags:                               Window_Flags,
	pos:                                 Vec2,
	size:                                Vec2,
	size_full:                           Vec2,
	content_size:                        Vec2,
	content_size_explicit:               Vec2,
	window_padding:                      Vec2,
	window_rounding:                     f32,
	window_border_size:                  f32,
	name_buf_len:                        i32,
	move_id:                             ImID,
	child_id:                            ImID,
	scroll:                              Vec2,
	scroll_max:                          Vec2,
	scroll_target:                       Vec2,
	scroll_target_center_ratio:          Vec2,
	scrollbar_sizes:                     Vec2,
	scrollbar_x:                         bool,
	scrollbar_y:                         bool,
	active:                              bool,
	was_active:                          bool,
	write_accessed:                      bool,
	collapsed:                           bool,
	want_collapse_toggle:                bool,
	skip_items:                          bool,
	appearing:                           bool,
	hidden:                              bool,
	is_fallback_window:                  bool,
	has_close_button:                    bool,
	resize_border_held:                  i8,
	begin_count:                         i16,
	begin_order_within_parent:           i16,
	begin_order_within_context:          i16,
	popup_id:                            ImID,
	auto_fit_frames_x:                   i8,
	auto_fit_frames_y:                   i8,
	auto_fit_child_axises:               i8,
	auto_fit_only_grows:                 bool,
	auto_pos_last_direction:             Dir,
	hidden_frames_can_skip_items:        i32,
	hidden_frames_cannot_skip_items:     i32,
	set_window_pos_allow_flags:          Cond,
	set_window_size_allow_flags:         Cond,
	set_window_collapsed_allow_flags:    Cond,
	set_window_pos_val:                  Vec2,
	set_window_pos_pivot:                Vec2,
	id_stack:                            Im_Vector(ImID),
	dc:                                  Window_Temp_Data,
	outer_rect_clipped:                  Rect,
	inner_rect:                          Rect,
	inner_clip_rect:                     Rect,
	work_rect:                           Rect,
	clip_rect:                           Rect,
	content_region_rect:                 Rect,
	last_frame_active:                   i32,
	last_time_active:                    f32,
	item_width_default:                  f32,
	state_storage:                       Storage,
	columns_storage:                     Im_Vector(Columns),
	font_window_scale:                   f32,
	settings_offset:                     i32,
	draw_list:                           ^Draw_List,
	draw_list_inst:                      Draw_List,
	parent_window:                       ^ImWindow,
	root_window:                         ^ImWindow,
	root_window_for_title_bar_highlight: ^ImWindow,
	root_window_for_nav:                 ^ImWindow,
	nav_last_child_nav_window:           ^ImWindow,
	nav_last_ids:                        [2]ImID,
	nav_rect_rel:                        [2]Rect,
	memory_compacted:                    bool,
	memory_draw_list_idx_capacity:       i32,
	memory_draw_list_vtx_capacity:       i32,
}

//ImGuiWindowSettings 
Window_Settings :: struct {
	id:        ImID,
	pos:       Vec2_ih,
	size:      Vec2_ih,
	collapsed: bool,
}

//ImGuiWindowTempData 
Window_Temp_Data :: struct {
	cursor_pos:                      Vec2,
	cursor_pos_prev_line:            Vec2,
	cursor_start_pos:                Vec2,
	cursor_max_pos:                  Vec2,
	curr_line_size:                  Vec2,
	prev_line_size:                  Vec2,
	curr_line_text_base_offset:      f32,
	prev_line_text_base_offset:      f32,
	indent:                          Vec1,
	columns_offset:                  Vec1,
	group_offset:                    Vec1,
	last_item_id:                    ImID,
	last_item_status_flags:          Item_Status_Flags,
	last_item_rect:                  Rect,
	last_item_display_rect:          Rect,
	nav_layer_current:               Nav_Layer,
	nav_layer_current_mask:          i32,
	nav_layer_active_mask:           i32,
	nav_layer_active_mask_next:      i32,
	nav_focus_scope_id_current:      ImID,
	nav_hide_highlight_one_frame:    bool,
	nav_has_scroll:                  bool,
	menu_bar_appending:              bool,
	menu_bar_offset:                 Vec2,
	menu_columns:                    Menu_Columns,
	tree_depth:                      i32,
	tree_jump_to_parent_on_pop_mask: u32,
	child_windows:                   Im_Vector(^ImWindow),
	state_storage:                   ^Storage,
	current_columns:                 ^Columns,
	layout_type:                     Layout_Type,
	parent_layout_type:              Layout_Type,
	focus_counter_regular:           i32,
	focus_counter_tab_stop:          i32,
	item_flags:                      Item_Flags,
	item_width:                      f32,
	text_wrap_pos:                   f32,
	item_flags_stack:                Im_Vector(Item_Flags),
	item_width_stack:                Im_Vector(f32),
	text_wrap_pos_stack:             Im_Vector(f32),
	group_stack:                     Im_Vector(Group_Data),
	stack_sizes_backup:              [6]i16,
}

//ImRect 
Rect :: struct {
	min: Vec2,
	max: Vec2,
}

//ImVec1 
Vec1 :: struct {
	x: f32,
}

//ImVec2 
Vec2 :: struct {
	x: f32,
	y: f32,
}

//ImVec2ih 
Vec2_ih :: struct {
	x: i16,
	y: i16,
}

//ImVec4 
Vec4 :: struct {
	x: f32,
	y: f32,
	z: f32,
	w: f32,
}

