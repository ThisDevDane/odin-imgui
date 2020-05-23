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

    // output_enums(STRUCTS_AND_ENUM_JSON_PATH, "./output/enums.odin");
    // output_structs(STRUCTS_AND_ENUM_JSON_PATH, "./output/structs.odin");
    // output_foreign(DEFINITION_JSON_PATH, "./output/foreign.odin");
    wrapper_map := output_wrappers(DEFINITION_JSON_PATH, "./output/wrapper.odin");
    output_header(DEFINITION_JSON_PATH, "./output/header.odin", wrapper_map);

    log.info("Done generating!!!");
}

output_wrappers :: proc(json_path: string, output_path: string) -> ^map[string]string {
    log.info("Outputting wrappers...");
    res := new(map[string]string);

    json_bytes, _ := os.read_entire_file(json_path);
    js, err := json.parse(json_bytes);
    defer json.destroy_value(js);

    obj := js.value.(json.Object);

    if err != json.Error.None {
        log.error("Could not parse json file for foreign functions", err);
        return nil;
    }

    sb := strings.make_builder();
    defer strings.destroy_builder(&sb);
    insert_package_header(&sb);

    groups : [dynamic]Foreign_Func_Group;

    { // Gather
        gather_foreign_proc_groups(&groups, obj);
    }

    { // SB Output
        for g in groups {
            for f in g.functions {
                if should_make_simple_wrapper(f) == false do continue;

                wrapper_name := fmt.aprintf("swr_{}", f.link_name);
                res[strings.clone(f.link_name)] = wrapper_name;
                //log.debugf("var_map[\"{}\"] = \"{}\"", f.link_name, wrapper_name);

                fmt.sbprintf(&sb, "{} :: proc(", wrapper_name);
                for p, idx in f.params {
                    fmt.sbprintf(&sb, "{}: ", p.name);
                    type := clean_type(p.type);
                    if type == "cstring" do type = "string";
                    fmt.sbprint(&sb, type);

                    if idx < len(f.params)-1 do fmt.sbprint(&sb, ", ");
                }
                fmt.sbprint(&sb, ") ");
                if function_has_return(f) == true do fmt.sbprintf(&sb, "-> {} ", clean_type(f.return_type));
                fmt.sbprint(&sb, "{\n");

                var_map : map[string]string;

                for p, idx in f.params {
                    if clean_type(p.type) != "cstring" do continue;

                    var_name := fmt.tprintf("str{}", idx);
                    var_map[p.name] = var_name;
                    fmt.sbprintf(&sb, "\t{} := fmt.tprintf(\"{{}}\\x00\", {});\n", var_name, p.name);
                }           

                fmt.sbprint(&sb, "\t");
                if function_has_return(f) == true do fmt.sbprint(&sb, "return ");
                

                fmt.sbprintf(&sb, "{}(", f.link_name);
                for p, idx in f.params {
                    if v, ok := var_map[p.name]; ok {
                        fmt.sbprintf(&sb, "cstring(&{}[0])", v);
                    } else {
                        fmt.sbprint(&sb, p.name);
                    }
                    if idx < len(f.params)-1 do fmt.sbprint(&sb, ", ");
                }
                fmt.sbprint(&sb, ");");
                fmt.sbprint(&sb, "\n");
                fmt.sbprint(&sb, "}\n\n");
            }

            fmt.sbprint(&sb, "\n");
        }
    }

    { // File output 
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting foreign functions! %v", err);                
            return nil;
        }

        os.write_string(handle, strings.to_string(sb));
    }

    return res;

    should_make_simple_wrapper :: proc(f: Foreign_Func) -> bool {
        if len(f.params) == 0 do return false;

        has_cstring := false;
        for p in f.params {
            if clean_type(p.type) == "cstring" {
                has_cstring = true;
                break;
            }
        }

        return has_cstring == true;
    }
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
        longest_field_name: int,
    };

    Struct_Field :: struct {
        name: string,
        type: string,
        size: int,
    };

    definitions : [dynamic]Struct_Definition;

    
    { // Gather
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

        for def in &definitions {
            for f in def.fields {
                key := clean_field_key(f.name, f.size);
                def.longest_field_name = max(def.longest_field_name, len(key));
            }
        }
    }
    
    { // SB Output
        for def in definitions {
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
        key = to_ada_case(key);
        return key;
    }

    clean_field_key :: proc(key: string, size: int) -> string { 
        key := key;
        key, _ = remove_array_decleration(key, size > 0);
        //key = to_ada_case(key);
        return key;
    }
}
