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
    output_structs();
    output_header();
    output_foreign();
}

output_enums :: proc(json_path: string, output_path: string) {
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
            key = clean_imgui_namespacing(key);
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
            strings.write_string(&sb, clean_enum_key(def.name));
            strings.write_string(&sb, " :: enum i32 {");
            strings.write_rune(&sb, '\n');

            for f in def.fields {
                strings.write_rune(&sb, '\t');
                strings.write_string(&sb, clean_field_key(f.name, def.name));

                if(f.value != nil) {
                    strings.write_string(&sb, " = ");
                    
                    switch v in f.value {
                        case int: {
                            strings.write_string(&sb, fmt.tprintf("%d", v));
                        }

                        case string: {
                            strings.write_string(&sb, v);
                        }

                        case []string: {
                            for x, i in v {
                                strings.write_string(&sb, clean_field_key(x, def.name));
                                if i == len(v)-1 do break;
                                strings.write_string(&sb, " | ");
                            }
                        }
                        
                    }
                }
                strings.write_rune(&sb, ',');
                strings.write_rune(&sb, '\n');
            }


            strings.write_rune(&sb, '}');

            strings.write_rune(&sb, '\n');
            strings.write_rune(&sb, '\n');
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

output_structs :: proc() {}
output_header :: proc() {}
output_foreign :: proc() {}

insert_package_header :: proc(sb: ^strings.Builder) do strings.write_string(sb, "package imgui;\n\n");
