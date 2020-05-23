package main;

import "core:log"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json";

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

    groups : [dynamic]Foreign_Func_Group;

    { // Gather
        gather_foreign_proc_groups(&groups, obj);

        for g in &groups {
            for f in g.functions {
                g.longest_func_name = max(g.longest_func_name, len(f.link_name));
            }
        }
    }

    { // SB Output
        output_foreign_import(&sb);

        fmt.sbprint(&sb, "@(default_calling_convention=\"c\")\n");
        fmt.sbprint(&sb, "foreign cimgui {\n");

        for g in groups {
            for f in g.functions {
                fmt.sbprint(&sb, "\t");
                fmt.sbprintf(&sb, "{}", f.link_name);
                right_pad(&sb, len(f.link_name), g.longest_func_name);
                fmt.sbprint(&sb, " :: proc(");
                output_param_list(&sb, f);
                fmt.sbprint(&sb, ") ");

                if function_has_return(f) == true {
                    fmt.sbprintf(&sb, "-> {} ", clean_type(f.return_type));
                }

                fmt.sbprint(&sb, "---;\n");
            }

            fmt.sbprint(&sb, "\n");
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

    output_foreign_import :: proc(sb: ^strings.Builder) {
        fmt.sbprint(sb, "when ODIN_DEBUG {\n");
        fmt.sbprint(sb, "    foreign import cimgui \"external/cimgui_debug.lib\";\n");
        fmt.sbprint(sb, "} else {\n");
        fmt.sbprint(sb, "    foreign import cimgui \"external/cimgui.lib\";\n");
        fmt.sbprint(sb, "}\n\n");
    }
}

output_header :: proc(json_path: string, output_path: string, wrapper_map: ^map[string]string) {
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

    groups : [dynamic]Foreign_Func_Group;

    { // Gather
        gather_foreign_proc_groups(&groups, obj);

        for g in &groups {
            for f in g.functions {
                g.longest_func_name = max(g.longest_func_name, len(clean_func_name(f.link_name)));

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
            for f, _ in g.functions {
                name := clean_func_name(f.link_name);

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

                if v, ok := wrapper_map[f.link_name]; ok {
                    fmt.sbprintf(&sb, "{}(", v);
                    output_call_list(&sb, f);
                    fmt.sbprint(&sb, ");");
                } else {
                    fmt.sbprintf(&sb, "{}(", f.link_name);
                    output_call_list(&sb, f);
                    fmt.sbprint(&sb, ");");
                }
                fmt.sbprint(&sb, "\n");
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
}

gather_foreign_proc_groups :: proc(groups : ^[dynamic]Foreign_Func_Group, obj: json.Object) {
    reset_group_info();
    current_group := Foreign_Func_Group{};
    for _, v in obj {
        overloads := v.value.(json.Array);
        ov_loop: for ov in overloads {
            f := Foreign_Func{};
            ov_obj := ov.value.(json.Object);

            f.link_name = get_value_string(ov_obj["ov_cimguiname"]);
            if figure_out_if_new_group(f.link_name) {
                append(groups, current_group);
                current_group = Foreign_Func_Group{};
            }
            
            f.return_type = get_optional_string(ov_obj, "ret");

            for arg in ov_obj["argsT"].value.(json.Array) {
                param := Foreign_Func_Param{};
                arg_obj := arg.value.(json.Object);

                param.name = get_value_string(arg_obj["name"]);
                param.type = get_value_string(arg_obj["type"]);

                if param.type == "..." do continue ov_loop;
                if param.type == "va_list" do continue ov_loop;

                append(&f.params, param);
                
            }

            append(&current_group.functions, f);
        }
    }

    append(groups, current_group);
}

@(private="file") prev_group := "";
@(private="file") first_line := true;
@(private="file") last_was_ig := false;

output_foreign_call :: proc(sb: ^strings.Builder, f: Foreign_Func) {
    fmt.sbprintf(sb, "{}(", f.link_name);
    output_call_list(sb, f);
    fmt.sbprint(sb, ")");
}

output_call_list :: proc(sb: ^strings.Builder, f: Foreign_Func) {
    for p, idx in f.params {
        fmt.sbprint(sb, p.name);
        if idx < len(f.params)-1 do fmt.sbprint(sb, ", ");
    }
}

@(private="file")
clean_func_name :: proc(key: string) -> string {
    key := key;
    key = clean_imgui(key);
    key = clean_ig(key);
    key = to_snake_case(key);
    return key;
}

@(private="file")
reset_group_info :: proc() {
    prev_group  = "";
    first_line  = true;
    last_was_ig = false;
}

function_has_return :: proc(f: Foreign_Func) -> bool {
    return f.return_type != "" && f.return_type != "void";
}

output_param_list :: proc(sb: ^strings.Builder, f: Foreign_Func) {
    for p, idx in f.params {
        fmt.sbprintf(sb, "{}: {}", p.name, clean_type(p.type));
        if idx < len(f.params)-1 do fmt.sbprint(sb, ", ");
    }
}

@(private="file")
figure_out_if_new_group :: proc(link_name: string) -> bool {
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
