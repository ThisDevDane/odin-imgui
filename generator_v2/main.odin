package main;

import "core:log"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json";

DEFINITION_JSON_PATH       :: "./cimgui/generator/output/definitions.json";
STRUCTS_AND_ENUM_JSON_PATH :: "./cimgui/generator/output/structs_and_enums.json";

main :: proc() {
    logger_opts := log.Options {
        .Level,
        .Line,
        .Procedure,
    };
    context.logger = log.create_console_logger(opt = logger_opts);

    output_enums(STRUCTS_AND_ENUM_JSON_PATH, "./output/enums.odin");
    output_structs(STRUCTS_AND_ENUM_JSON_PATH, "./output/structs.odin");
    output_foreign(DEFINITION_JSON_PATH);
    output_header(DEFINITION_JSON_PATH);
}

output_enums :: proc(json_path: string, output_path: string) {
    log.info("Outputting enums...");
    json_bytes, _ := os.read_entire_file(json_path);
    js, err := json.parse(json_bytes);
    defer json.destroy_value(js);

    if err != json.Error.None {
        log.error("Could not parse json file for enums", err);
        return;
    }

    sb := strings.make_builder();
    defer strings.destroy_builder(&sb);
    insert_package_header(&sb);

    Enum_Defintion :: struct {
        name:   string,
        fields: [dynamic]Enum_Field,
    };

    Enum_Field :: struct {
        name:  string,
        value: union{string, int, []string}
    };

    definitions : [dynamic]Enum_Defintion;
    // Gather
    {
        obj := js.value.(json.Object);
        for k, v in obj["enums"].value.(json.Object) {
            def := Enum_Defintion{};

            def.name = k;

            for x in v.value.(json.Array) {
                field := x.value.(json.Object);
                res := Enum_Field{};
                res.name = get_value_string(field["name"]);

                #partial switch v in field["value"].value {
                    case json.Integer: {
                        res.value = int(v);
                    }
                    case json.String: {
                        if strings.index_any(v, "|") > 0 {
                            res.value = strings.split(v, "|");
                        } else {
                            res.value = v;
                        }
                    }
                    case: {
                        log.errorf("Unexpected enum field value: %v", v);
                    }
                }


                append(&def.fields, res);
            }

            append(&definitions, def);
        }
    }
    // Ouptut
    {
        clean_enum_key :: proc(key: string) -> string {
            key := key;
            key = strings.trim_space(key);
            key = clean_imgui(key);
            key = strings.trim(key, "_");
            key = to_ada_case(key);
            return key;
        }

        clean_field_key :: proc(key: string, enum_name: string) -> string {
            key := key;
            key = strings.trim_space(key);
            key = key[len(enum_name):];
            key = strings.trim(key, "_");
            key = to_ada_case(key);
            return key;
        }

        for def in definitions {
            fmt.sbprint(&sb, clean_enum_key(def.name));
            fmt.sbprint(&sb, " :: enum i32 {");
            fmt.sbprint(&sb, '\n');

            for f in def.fields {
                fmt.sbprint(&sb, '\t');
                fmt.sbprint(&sb, clean_field_key(f.name, def.name));

                if(f.value != nil) {
                    fmt.sbprint(&sb, " = ");
                    
                    switch v in f.value {
                        case int: {
                            fmt.sbprintf(&sb, "%d", v);
                        }

                        case string: {
                            fmt.sbprint(&sb, v);
                        }

                        case []string: {
                            for x, i in v {
                                fmt.sbprint(&sb, clean_field_key(x, def.name));
                                if i == len(v)-1 do break;
                                fmt.sbprint(&sb, " | ");
                            }
                        }
                    }
                }
                fmt.sbprint(&sb, ',');
                fmt.sbprint(&sb, '\n');
            }


            fmt.sbprint(&sb, '}');

            fmt.sbprint(&sb, '\n');
            fmt.sbprint(&sb, '\n');
        }
    }

    {
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting enums! %v", err);                
            return;
        }

        os.write_string(handle, strings.to_string(sb));
    }
}

name_type_map := map[string]string {
    "GetClipboardTextFn" = `proc "c"(user_data : rawptr) -> cstring`,
    "SetClipboardTextFn" = `proc "c"(user_data : rawptr, text : cstring)`,
    "ImeSetInputScreenPosFn" = `proc "c"(x, y : i32)`,
};

struct_name_map := map[string]string {
    "ImGuiIO" = "IO",
    "ImVec2" = "Vec2",
    "ImVec4" = "Vec4",
};

type_map := map[string]string {

    "char"           = "i8",
    "unsigned char"  = "u8",
    "unsigned char*" = "^u8",
    "unsigned short" = "u16",
    "short"          = "i16",
    "unsigned int"   = "u32",
    "unsigned int*"  = "^u32",
    "int"            = "i32",
    "float"          = "f32",
    "double"         = "f64",
    "size_t"         = "uint",
    "bool"           = "bool",
    "void*"          = "rawptr",

    "ImU32" = "u32",

    "char*" = "cstring",

    // "ImTextureID" = "Texture_ID",
    // "ImGuiID" = "ID",

    "ImVec2" = "Vec2",
    "ImVec4" = "Vec4",

    "ImVector_ImTextureID" = "Im_Vector(Texture_ID)",
    "ImVector_ImWchar" = "Im_Vector(Wchar)",
    "ImVector_ImVec2" = "Im_Vector(Vec2)",
    "ImVector_ImVec4" = "Im_Vector(Vec4)",
    
    "ImVector_ImGuiTextRange" = "Im_Vector(Text_Range)",
    "ImVector_ImGuiStoragePair" = "Im_Vector(Storage_Pair)",
    
    "ImVector_ImFontConfig" = "Im_Vector(Font_Config)",
    "ImVector_ImFontAtlasCustomRect" = "Im_Vector(Font_Atlas_Custom_Rect)",
    "ImVector_ImFontPtr" = "Im_Vector(^Font)",
    "ImVector_ImFontGlyph" = "Im_Vector(Font_Glyph)",
    
    "ImVector_ImDrawChannel" = "Im_Vector(Draw_Channel)",
    "ImVector_ImDrawCmd" = "Im_Vector(Draw_Cmd)",
    "ImVector_ImDrawIdx" = "Im_Vector(Draw_Idx)",
    "ImVector_ImDrawVert" = "Im_Vector(Draw_Vert)",

    "ImVector_ImU32" = "Im_Vector(u32)",
    "ImVector_float" = "Im_Vector(f32)",
    "ImVector_char" = "Im_Vector(u8)",
};

output_structs :: proc(json_path: string, output_path: string) {
    log.info("Outputting structs...");

    json_bytes, _ := os.read_entire_file(json_path);
    js, err := json.parse(json_bytes);
    defer json.destroy_value(js);

    if err != json.Error.None {
        log.error("Could not parse json file for structs", err);
        return;
    }

    sb := strings.make_builder();
    defer strings.destroy_builder(&sb);
    insert_package_header(&sb);

    Struct_Definition :: struct {
        name:   string,
        fields: [dynamic]Struct_Field,
    };

    Struct_Field :: struct {
        name: string,
        type: string,
        size: int,
    };

    definitions : [dynamic]Struct_Definition;

    // Gather
    {
        obj := js.value.(json.Object);
        for k, v in obj["structs"].value.(json.Object) {
            def := Struct_Definition{};
            def.name = k;

            for x in v.value.(json.Array) {
                field := x.value.(json.Object);
                res := Struct_Field{};

                res.size = get_optional_int(field, "size");
                res.name = get_value_string(field["name"]);
                res.type = get_value_string(field["type"]);

                append(&def.fields, res);
            }

            append(&definitions, def);
        }
    }
    // Output
    {
        clean_struct_key :: proc(key: string) -> string {
            key := key;
            if n, ok := struct_name_map[key]; ok {
                return n;
            }
            key = clean_imgui(key);
            key = to_ada_case(key);
            return key;
        }

        clean_field_key :: proc(key: string, size: int) -> string { 
            key := key;
            key = remove_array_decleration(key, size > 0);
            //key = to_ada_case(key);
            return key;
        }

        clean_type :: proc(type: string) -> string {
            type := type;
            type = clean_const(type);

            if n, ok := type_map[type]; ok {
                return n;
            }

            type = clean_imgui(type);
            type = to_ada_case(type);

            t, count := clean_ptr(type);
            if count > 0 {
                sb := strings.make_builder();
                for _ in 0..count-1 {
                    fmt.sbprint(&sb, '^');
                }
                fmt.sbprint(&sb, t);

                return strings.to_string(sb);
            } else {
                return type;            
            }

        }

        for def in definitions {
            fmt.sbprintf(&sb, "%s :: struct ", clean_struct_key(def.name));
            fmt.sbprint(&sb, '{');
            fmt.sbprint(&sb, '\n');

            for f in def.fields {
                fmt.sbprintf(&sb, "\t%s: ", clean_field_key(f.name, f.size));

                if(f.size > 0) {
                    fmt.sbprintf(&sb, "[%d]", f.size);                    
                }

                if v, ok := name_type_map[f.name]; ok {
                    fmt.sbprint(&sb, v);
                } else {        
                    fmt.sbprint(&sb, clean_type(f.type));
                    // fmt.sbprint(&sb, "----");
                    // fmt.sbprint(&sb, f.type);
                }

                fmt.sbprint(&sb, ",\n");
            }

            fmt.sbprint(&sb, '}');
            
            fmt.sbprint(&sb, "\n\n");
        }
    }

    log.debug("OUTPUT:\n", strings.to_string(sb));
    {
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting structs! %v", err);                
            return;
        }

        os.write_string(handle, strings.to_string(sb));
    }
}
output_header :: proc(json_path: string) {}
output_foreign :: proc(json_path: string) {}

insert_package_header :: proc(sb: ^strings.Builder) do fmt.sbprint(sb, "package imgui;\n\n");
