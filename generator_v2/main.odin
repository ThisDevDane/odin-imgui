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

    log.info("Generating odin source...");
    
    predefined_entities := process_predefined("./generator_v2/predefined/imgui_predefined.odin");
    output_predefined_copies("./output/copies.odin", predefined_entities);

    output_enums(STRUCTS_AND_ENUM_JSON_PATH, "./output/enums.odin");
    output_structs(STRUCTS_AND_ENUM_JSON_PATH, "./output/structs.odin", predefined_entities);
    output_foreign(DEFINITION_JSON_PATH, "./output/foreign.odin", predefined_entities);
    wrapper_map := output_wrappers(DEFINITION_JSON_PATH, "./output/wrapper.odin", predefined_entities);
    output_header(DEFINITION_JSON_PATH, "./output/header.odin", wrapper_map);

    log.info("Done generating!!!");
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
        longest_field_name: int,
    };

    Enum_Field :: struct {
        name:  string,
        value: union{string, int, []string}
    };

    definitions : [dynamic]Enum_Defintion;
    
    { // Gather
        obj := js.value.(json.Object);
        blacklist : map[string]bool;
        for k, v in obj["locations"].value.(json.Object) {
            location := get_value_string(v);
            if location == "internal" do blacklist[k] = true;
        }

        for k, v in obj["enums"].value.(json.Object) {
            def := Enum_Defintion{};

            if _, ok := blacklist[k]; ok do continue;

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

        for def in &definitions {
            for f in def.fields {
                key := clean_field_key(f.name, def.name);
                def.longest_field_name = max(def.longest_field_name, len(key));
            }
        }
    }
    
    { // SB output
        for def in definitions {
            fmt.sbprint(&sb, clean_enum_key(def.name));
            fmt.sbprint(&sb, " :: enum i32 {");
            fmt.sbprint(&sb, '\n');

            for f in def.fields {
                fmt.sbprint(&sb, '\t');
                key := clean_field_key(f.name, def.name);
                fmt.sbprint(&sb, key);
                right_pad(&sb, len(key), def.longest_field_name);

                if(f.value != nil) {
                    fmt.sbprint(&sb, " = ");
                    
                    switch v in f.value {
                        case int: {
                            fmt.sbprintf(&sb, "%d", v);
                        }

                        case string: {
                            t := v;
                            if strings.index(t, "_") > 0 do t = clean_field_key(t, def.name);
                            fmt.sbprint(&sb, t);
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

    { // File output
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting enums! %v", err);                
            return;
        }

        os.write_string(handle, strings.to_string(sb));
    }

    clean_enum_key :: proc(key: string) -> string {
        key := key;
        key = strings.trim_space(key);
        key = clean_imgui(key);
        key = strings.trim(key, "_");
        key = strings.to_ada_case(key);
        return key;
    }

    clean_field_key :: proc(key: string, enum_name: string) -> string {
        key := key;
        key = strings.trim_space(key);
        key = key[len(enum_name):];
        key = strings.trim(key, "_");
        key = strings.to_pascal_case(key);
        return key;
    }
}

output_structs :: proc(json_path: string, output_path: string, predefined_entites: []Predefined_Entity) {
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
        longest_field_name: int,
    };

    Struct_Field :: struct {
        name: string,
        type: string,
        size: int,
    };

    definitions : [dynamic]Struct_Definition;
    overwrites : map[string]Struct_Overwrite;

    
    { // Gather
        obj := js.value.(json.Object);
        blacklist : map[string]bool;
        for k, v in obj["locations"].value.(json.Object) {
            location := get_value_string(v);
            if location == "internal" do blacklist[k] = true;
        }

        for k, v in obj["structs"].value.(json.Object) {
            def := Struct_Definition{};

            if _, ok := blacklist[k]; ok do continue;

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

        for def in &definitions {
            for f in def.fields {
                key := clean_field_key(f.name, f.size);
                def.longest_field_name = max(def.longest_field_name, len(key));
            }
        }

        for e in predefined_entites {
            #partial switch so in e {
                case Struct_Overwrite: {
                    overwrites[so.for_struct] = so;
                }
            }
        }
    }
    
    { // SB Output
        for def in definitions {
            if so, ok := overwrites[def.name]; ok {
                fmt.sbprint(&sb, so.text);
            } else {
                fmt.sbprintf(&sb, "//%s \n", def.name);
                fmt.sbprintf(&sb, "%s :: struct ", clean_struct_key(def.name));
                fmt.sbprint(&sb, '{');
                fmt.sbprint(&sb, '\n');

                for f in def.fields {
                    key := clean_field_key(f.name, f.size);
                    fmt.sbprintf(&sb, "\t%s: ", key);
                    right_pad(&sb, len(key), def.longest_field_name);

                    if(f.size > 0) {
                        fmt.sbprintf(&sb, "[%d]", f.size);                    
                    }

                    if v, ok := name_type_map[f.name]; ok {
                        fmt.sbprint(&sb, v);
                    } else {        
                        fmt.sbprint(&sb, clean_type(f.type));
                    }

                    fmt.sbprint(&sb, ",\n");
                }

                fmt.sbprint(&sb, '}');
                
            }
            fmt.sbprint(&sb, "\n\n");
        }
    }

    { // File output
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting structs! %v", err);                
            return;
        }

        os.write_string(handle, strings.to_string(sb));
    }

    clean_struct_key :: proc(key: string) -> string {
        key := key;
        if n, ok := struct_name_map[key]; ok {
            return n;
        }
        key = clean_imgui(key);
        key = strings.to_ada_case(key);
        return key;
    }

    clean_field_key :: proc(key: string, size: int) -> string { 
        key := key;
        key, _ = remove_array_decleration(key, size > 0);
        key = strings.to_snake_case(key);
        return key;
    }
}
