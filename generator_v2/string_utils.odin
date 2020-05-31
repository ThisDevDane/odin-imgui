package main;

import "core:strings";
import "core:fmt";
import "core:strconv";

insert_package_header :: proc(sb: ^strings.Builder) do fmt.sbprint(sb, "package imgui;\n\n");

right_pad :: proc(sb: ^strings.Builder, current: int, desired: int) {
    if desired-current <= 0 do return;
    for _ in 0..(desired-current)-1 do fmt.sbprint(sb, " ");
}

name_type_map := map[string]string {
    "GetClipboardTextFn"     = `proc "c"(user_data : rawptr) -> cstring`,
    "SetClipboardTextFn"     = `proc "c"(user_data : rawptr, text : cstring)`,
    "ImeSetInputScreenPosFn" = `proc "c"(x, y : i32)`,
};

struct_name_map := map[string]string {
    "ImGuiIO"     = "IO",
    "ImGuiWindow" = "ImWindow",
    "ImFont"      = "ImFont",
    "ImVec1"      = "Vec1",
    "ImVec2"      = "Vec2",
    "ImVec2ih"    = "Vec2_ih",
    "ImVec4"      = "Vec4",
};

type_map := map[string]string {
    "char"           = "i8",
    "signed char"    = "i8",
    "unsigned char"  = "u8",
    "unsigned short" = "u16",
    "short"          = "i16",
    "unsigned int"   = "u32",
    "int"            = "i32",
    "float"          = "f32",
    "double"         = "f64",
    "size_t"         = "uint",
    "bool"           = "bool",

    "float&" = "^f32",
    "ImU32" = "u32",
    "ImS8"  = "i8",
    "ImU8"  = "u8",
    "ImU64"  = "u64",

    "ImTextureID" = "Texture_ID",
    "ImGuiID"     = "ImID",
    "ImFont"      = "ImFont",
    "ImGuiWindow" = "ImWindow",

    "ImVec1"   = "Vec1",
    "ImVec2"   = "Vec2",
    "ImVec2ih" = "Vec2_ih",
    "ImVec4"   = "Vec4",

    "ImChunkStream_ImGuiWindowSettings" = "Im_Chunk_Stream(Window_Settings)",

    "ImPool_ImGuiTabBar" = "Im_Pool(Tab_Bar)",

    "ImVector_ImGuiSettingsHandler"  = "Im_Vector(Settings_Handler)",
    "ImVector_ImGuiWindowPtr"        = "Im_Vector(^ImWindow)",
    "ImVector_ImGuiColorMod"         = "Im_Vector(Color_Mod)",
    "ImVector_ImGuiStyleMod"         = "Im_Vector(Style_Mod)",
    "ImVector_ImGuiPopupData"        = "Im_Vector(Popup_Data)",
    "ImVector_ImGuiShrinkWidthItem"  = "Im_Vector(Shrink_Width_Item)",
    "ImVector_ImGuiID"               = "Im_Vector(ImID)",
    "ImVector_ImGuiPtrOrIndex"       = "Im_Vector(Ptr_Or_Index)",
    "ImVector_ImGuiColumnData"       = "Im_Vector(Column_Data)",
    "ImVector_ImGuiColumns"          = "Im_Vector(Columns)",
    "ImVector_ImGuiTabItem"          = "Im_Vector(Tab_Item)",
    "ImVector_ImGuiItemFlags"        = "Im_Vector(Item_Flags)",
    "ImVector_ImGuiGroupData"        = "Im_Vector(Group_Data)",
    "ImVector_ImDrawListPtr"         = "Im_Vector(^Draw_List)",
    "ImVector_ImTextureID"           = "Im_Vector(Texture_ID)",
    "ImVector_ImWchar"               = "Im_Vector(Wchar)",
    "ImVector_ImVec2"                = "Im_Vector(Vec2)",
    "ImVector_ImVec4"                = "Im_Vector(Vec4)",
    "ImVector_ImGuiTextRange"        = "Im_Vector(Text_Range)",
    "ImVector_ImGuiStoragePair"      = "Im_Vector(Storage_Pair)",
    "ImVector_ImFontConfig"          = "Im_Vector(Font_Config)",
    "ImVector_ImFontAtlasCustomRect" = "Im_Vector(Font_Atlas_Custom_Rect)",
    "ImVector_ImFontPtr"             = "Im_Vector(^ImFont)",
    "ImVector_ImFontGlyph"           = "Im_Vector(Font_Glyph)",
    "ImVector_ImDrawChannel"         = "Im_Vector(Draw_Channel)",
    "ImVector_ImDrawCmd"             = "Im_Vector(Draw_Cmd)",
    "ImVector_ImDrawIdx"             = "Im_Vector(Draw_Idx)",
    "ImVector_ImDrawVert"            = "Im_Vector(Draw_Vert)",
    "ImVector_ImU32"                 = "Im_Vector(u32)",
    "ImVector_float"                 = "Im_Vector(f32)",
    "ImVector_char"                  = "Im_Vector(u8)",
    "ImVector_unsigned_char"         = "Im_Vector(u8)",

    "ImGuiIO" = "IO",
};

clean_type :: proc(type: string) -> string {
    type := type;
    type = clean_const(type);
    t, count := clean_ptr(type);
    size := 0;
    t, size = remove_array_decleration(t);

    is_mapped := false;

    if n, ok := type_map[t]; ok {
        if count == 0 && size == 0 {
            return n;
        } else {
            t = n;
            is_mapped = true;
        }
    }

    //NOTE(Hoej, 2020-05-23): This might convert things to a cstring that actually is a ^i8
    if t == "i8" && count >= 1 {
        t = "cstring";
        count -= 1;
        is_mapped = true;
    }

    if t == "void" && count >= 1 {
        t = "rawptr";
        count -= 1;
        is_mapped = true;
    }

    if is_mapped == false {
        t = clean_imgui(t);
        t = strings.to_ada_case(t);
    }

    if size > 0 {
        sb := strings.make_builder();
        defer strings.destroy_builder(&sb);
        fmt.sbprintf(&sb, "[{}]{}", size, t);
        t = strings.to_string(sb);
    }

    if count > 0 {
        sb := strings.make_builder();
        defer strings.destroy_builder(&sb);
        for _ in 0..count-1 {
            fmt.sbprint(&sb, '^');
        }
        fmt.sbprint(&sb, t);

        return strings.clone(strings.to_string(sb));
    } else {
        return t;            
    }
}

remove_array_decleration :: proc(s : string, has_size := true) -> (string, int) {
    if has_size == false do return s, 0;

    result := s;
    number := 0;

    i := strings.index(s, "[");
    if i > 0 {
        result = result[:i];
    }

    i2 := strings.index(s, "]");
    if i > -1 && i2 > -1 {
        number_str := s[i+1:i2];
        number = strconv.atoi(number_str);
    }

    return result, number;
}

clean_ptr :: proc(s : string) -> (result: string, ptr_count: int){
    result = s;
    i := strings.index(result, "*");
    if i > 0 {
        ptr_count = strings.count(result, "*");
        result = result[:i];
    }

    return;
}

clean_const :: proc(s : string) -> string {
    result := s;
    if strings.has_prefix(s, "const") {
        result = result[6:];
    }
    return result;
}

clean_imgui :: proc(s : string) -> string {
    if strings.has_prefix(s, "Im") == true && strings.has_prefix(s, "Image") == false {
        result := s[2:];
        if strings.has_prefix(result, "Gui") == true {
            result = result[3:];
        }
        return result;
    }

    return s;
}

clean_ig :: proc(s : string) -> string {
    if strings.has_prefix(s, "ig") == true {
        result := s[2:];
        return result;
    }

    return s;
}
