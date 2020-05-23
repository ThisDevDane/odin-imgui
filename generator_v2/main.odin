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

    output_enums(STRUCTS_AND_ENUM_JSON_PATH, "./output/enums.odin");
    output_structs(STRUCTS_AND_ENUM_JSON_PATH, "./output/structs.odin");
    output_foreign(DEFINITION_JSON_PATH, "./output/foreign.odin");
    output_header(DEFINITION_JSON_PATH, "./output/header.odin");
    //output_wrapper(DEFINITION_JSON_PATH);

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
    }
    
    { // SB output
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

    { // File output
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
    }
    
    { // SB Output
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
}

output_foreign :: proc(json_path: string, output_path: string) {
    log.info("Outputting foreign...");

    json_bytes, _ := os.read_entire_file(json_path);
    js, err := json.parse(json_bytes);
    defer json.destroy_value(js);

    obj := js.value.(json.Object);

    if err != json.Error.None {
        log.error("Could not parse json file for foreign functions", err);
        return;
    }

    sb := strings.make_builder();
    defer strings.destroy_builder(&sb);
    insert_package_header(&sb);

    Foreign_Func :: struct {
        link_name: string,
        params: [dynamic]Foreign_Func_Param,
        return_type: string,
    };

    Foreign_Func_Param :: struct {
        name: string,
        type: string,
    };

    functions : [dynamic]Foreign_Func;

    { // Gather
        for k, v in obj {
            overloads := v.value.(json.Array);
            for ov in overloads {
                f := Foreign_Func{};
                ov_obj := ov.value.(json.Object);


                f.link_name = get_value_string(ov_obj["ov_cimguiname"]);
                f.return_type = get_optional_string(ov_obj, "ret");

                for arg in ov_obj["argsT"].value.(json.Array) {
                    param := Foreign_Func_Param{};
                    arg_obj := arg.value.(json.Object);

                    param.name = get_value_string(arg_obj["name"]);
                    param.type = get_value_string(arg_obj["type"]);

                    append(&f.params, param);
                    
                }

                append(&functions, f);
            }
        }
    }

    { // SB Output
        output_foreign_import(&sb);

        fmt.sbprint(&sb, "@(default_calling_convention=\"c\")\n");
        fmt.sbprint(&sb, "foreign cimgui {\n");

        for f in functions {
            figure_out_group_and_break(&sb, f.link_name);

            fmt.sbprint(&sb, "\t");
            fmt.sbprintf(&sb, "{} :: proc(", f.link_name);

            for p, idx in f.params {
                fmt.sbprintf(&sb, "{}: {}", p.name, clean_type(p.type));
                if idx < len(f.params)-1 {
                    fmt.sbprint(&sb, ", ");
                }
            }
            fmt.sbprint(&sb, ") ");

            if f.return_type != "" && f.return_type != "void" {
                fmt.sbprintf(&sb, "-> {} ", clean_type(f.return_type));
            }

            fmt.sbprint(&sb, "---;\n");
        }
        
        fmt.sbprint(&sb, "}\n");
    }

    { // File output 
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting foreign functions! %v", err);                
            return;
        }

        os.write_string(handle, strings.to_string(sb));
    }

    figure_out_group_and_break :: proc(sb: ^strings.Builder, link_name: string) {
        @static prev_group := "";
        @static first_line := true;
        @static last_was_ig := false;

        group := strings.split(link_name, "_")[0];
        if prev_group != group {
            if first_line == false && last_was_ig == false{
                fmt.sbprint(sb, "\n");
            }    

            last_was_ig = strings.has_prefix(link_name, "ig");
            prev_group = group;
        } 
        first_line = false;
    }

    output_foreign_import :: proc(sb: ^strings.Builder) {
        fmt.sbprint(sb, "when ODIN_DEBUG {\n");
        fmt.sbprint(sb, "    foreign import cimgui \"external/cimgui_debug.lib\";\n");
        fmt.sbprint(sb, "} else {\n");
        fmt.sbprint(sb, "    foreign import cimgui \"external/cimgui.lib\";\n");
        fmt.sbprint(sb, "}\n\n");
    }
}

output_header :: proc(json_path: string, output_path: string) {
    log.info("Outputting headers...");

    json_bytes, _ := os.read_entire_file(json_path);
    js, err := json.parse(json_bytes);
    defer json.destroy_value(js);

    obj := js.value.(json.Object);

    if err != json.Error.None {
        log.error("Could not parse json file for foreign functions", err);
        return;
    }

    sb := strings.make_builder();
    defer strings.destroy_builder(&sb);
    insert_package_header(&sb);

    Foreign_Func_Group :: struct {
        functions: [dynamic]Foreign_Func,
        longest_func_name: int,
        longest_param_return_list: int,
    };

    Foreign_Func :: struct {
        link_name: string,
        params: [dynamic]Foreign_Func_Param,
        return_type: string,
    };

    Foreign_Func_Param :: struct {
        name: string,
        type: string,
    };

    groups : [dynamic]Foreign_Func_Group;
    { // Gather
        current_group := Foreign_Func_Group{};
        for k, v in obj {
            overloads := v.value.(json.Array);
            
            for ov in overloads {
                f := Foreign_Func{};
                ov_obj := ov.value.(json.Object);

                f.link_name = get_value_string(ov_obj["ov_cimguiname"]);
                if figure_out_if_new_group(f.link_name) {
                    append(&groups, current_group);
                    current_group = Foreign_Func_Group{};
                }

                f.return_type = get_optional_string(ov_obj, "ret");

                for arg in ov_obj["argsT"].value.(json.Array) {
                    param := Foreign_Func_Param{};
                    arg_obj := arg.value.(json.Object);

                    param.name = get_value_string(arg_obj["name"]);
                    param.type = get_value_string(arg_obj["type"]);

                    append(&f.params, param);
                }

                append(&current_group.functions, f);
            }
        }

        append(&groups, current_group);

        for g in &groups {
            for f in g.functions {
                g.longest_func_name = max(g.longest_func_name, len(clean_name(f.link_name)));

                sbu := strings.make_builder();
                defer strings.destroy_builder(&sbu);
                output_param_list(&sbu, f);

                prl_len := len(strings.to_string(sbu));

                if function_has_return(f) == true {
                    sbr := strings.make_builder();
                    defer strings.destroy_builder(&sbr);
                    fmt.sbprintf(&sbr, "-> {} ", clean_type(f.return_type));
                    prl_len += len(strings.to_string(sbr));
                }

                g.longest_param_return_list = max(g.longest_param_return_list, prl_len);
            }
        }
    }

    { // SB Output
        for g in groups {
            for f, idx in g.functions {
                name := clean_name(f.link_name);
                //fmt.sbprintf(&sb, "{} {} {}\n", g.longest_param_list, len(name), g.longest_func_name - len(name));

                fmt.sbprintf(&sb, "{} ", name);
                right_pad(&sb, len(name), g.longest_func_name);

                fmt.sbprintf(&sb, ":: proc(");

                sbu := strings.make_builder();
                defer strings.destroy_builder(&sbu);
                output_param_list(&sbu, f);
                param_list := strings.to_string(sbu);
                fmt.sbprint(&sb, param_list);
                fmt.sbprint(&sb, ") ");

                return_length := 0;

                if function_has_return(f) == true {
                    sbr := strings.make_builder();
                    defer strings.destroy_builder(&sbr);
                    fmt.sbprintf(&sbr, "-> {} ", clean_type(f.return_type));
                    return_str := strings.to_string(sbr);
                    return_length = len(return_str);
                    fmt.sbprint(&sb, return_str);
                }

                right_pad(&sb, len(param_list)+return_length, g.longest_param_return_list);
                fmt.sbprint(&sb, "do ");

                if function_has_return(f) == true do fmt.sbprint(&sb, "return ");

                fmt.sbprintf(&sb, "{}();", f.link_name);
                fmt.sbprint(&sb, "\n");
                // fmt.sbprintf(&sb, "lpl: {} lr: {} pl:{} r:{}\n", g.longest_param_list, g.longest_return, len(param_list), return_length);
                // fmt.sbprintf(&sb, "{}-{}={}\n", g.longest_param_list+g.longest_return, len(param_list)+return_length, g.longest_param_list+g.longest_return-len(param_list)+return_length);
            }

            fmt.sbprint(&sb, "\n");
        }
    }

    { // File output 
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting foreign functions! %v", err);                
            return;
        }

        os.write_string(handle, strings.to_string(sb));
    }

    output_param_list :: proc(sb: ^strings.Builder, f: Foreign_Func) {
        for p, idx in f.params {
            fmt.sbprintf(sb, "{}: {}", p.name, clean_type(p.type));
            if idx < len(f.params)-1 {
                fmt.sbprint(sb, ", ");
            }
        }
    }

    clean_name :: proc(key: string) -> string {
        key := key;
        key = clean_imgui(key);
        key = clean_ig(key);
        key = to_snake_case(key);
        return key;
    }

    function_has_return :: proc(f: Foreign_Func) -> bool {
        return f.return_type != "" && f.return_type != "void";
    }

    figure_out_if_new_group :: proc(link_name: string) -> bool {
        @static prev_group := "";
        @static first_line := true;
        @static last_was_ig := false;

        res := false;

        group := strings.split(link_name, "_")[0];
        if prev_group != group {
            if first_line == false && last_was_ig == false {
                res = true;
            }    

            last_was_ig = strings.has_prefix(link_name, "ig");
            prev_group = group;
        } 
        first_line = false;

        return res;
    }

    output_foreign_import :: proc(sb: ^strings.Builder) {
        fmt.sbprint(sb, "when ODIN_DEBUG {\n");
        fmt.sbprint(sb, "    foreign import cimgui \"external/cimgui_debug.lib\";\n");
        fmt.sbprint(sb, "} else {\n");
        fmt.sbprint(sb, "    foreign import cimgui \"external/cimgui.lib\";\n");
        fmt.sbprint(sb, "}\n\n");
    }
}
