package main;

import "core:log"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json";

Foreign_Func_Group :: struct {
    functions: [dynamic]union{Foreign_Overload_Group, Foreign_Func},
    longest_func_name: int,
    longest_param_return_list: int,
};

Foreign_Overload_Group :: struct {
    name: string,
    functions: [dynamic]Foreign_Func,
}

Foreign_Func :: struct {
    link_name: string,
    params: [dynamic]Foreign_Func_Param,
    return_type: string,
};

Foreign_Func_Param :: struct {
    name: string,
    type: string,
};

output_foreign :: proc(json_path: string, output_path: string, predefined_entites: []Predefined_Entity) {
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
    overwrites : map[string]Foreign_Overwrite;

    { // Gather
        gather_foreign_proc_groups(&groups, obj);

        for e in predefined_entites {
            #partial switch fo in e {
                case Foreign_Overwrite: {
                    overwrites[fo.for_foreign] = fo;
                }
            }
        }

        for g in &groups {
            for x in g.functions {
                switch f in x {
                    case Foreign_Overload_Group:
                        for y in f.functions {
                            g.longest_func_name = max(g.longest_func_name, len(y.link_name));    
                        }
                    case Foreign_Func:
                        g.longest_func_name = max(g.longest_func_name, len(f.link_name));
                }
            }
        }
    }

    { // SB Output
        output_foreign_import(&sb);

        fmt.sbprint(&sb, "@(default_calling_convention=\"c\")\n");
        fmt.sbprint(&sb, "foreign cimgui {\n");

        output_functions :: proc(sb: ^strings.Builder, f: Foreign_Func, g: Foreign_Func_Group) {
            fmt.sbprintf(sb, "\t{}", f.link_name);
            right_pad(sb, len(f.link_name), g.longest_func_name);
            fmt.sbprint(sb, " :: proc(");
            output_param_list(sb, f);
            fmt.sbprint(sb, ") ");

            if function_has_return(f) == true {
                fmt.sbprintf(sb, "-> {} ", clean_type(f.return_type));
            }

            fmt.sbprint(sb, "---;\n");
        }

        output_overwrite :: proc(sb: ^strings.Builder, fo: Foreign_Overwrite, g: Foreign_Func_Group) {
            fmt.sbprintf(sb, "\t{}", fo.name);
            right_pad(sb, len(fo.name), g.longest_func_name);
            fmt.sbprintf(sb, " :: {}\n", fo.body);
        }

        for g in groups {
            for x in g.functions {
                switch f in x {
                    case Foreign_Overload_Group:
                        for y in f.functions {
                            if fo, ok := overwrites[y.link_name]; ok {
                                output_overwrite(&sb, fo, g);
                            } else {
                                output_functions(&sb, y, g);
                            }
                        }
                    case Foreign_Func:
                        if fo, ok := overwrites[f.link_name]; ok {
                            output_overwrite(&sb, fo, g);
                        } else {
                            output_functions(&sb, f, g);
                        }
                }
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
        fmt.sbprint(sb, "\tforeign import cimgui \"external/cimgui_debug.lib\";\n");
        fmt.sbprint(sb, "} else {\n");
        fmt.sbprint(sb, "\tforeign import cimgui \"external/cimgui.lib\";\n");
        fmt.sbprint(sb, "}\n\n");
    }
}

output_header :: proc(json_path: string, output_path: string, wrapper_map: ^Wrapper_Map) {
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

        calculate_longest :: proc(g: ^Foreign_Func_Group, f: Foreign_Func) {
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

        for g in &groups {
            for x in g.functions {
                switch f in x {
                    case Foreign_Overload_Group:
                        for y in f.functions do calculate_longest(&g, y);
                    case Foreign_Func:
                        calculate_longest(&g, f);
                }
            }
        }
    }

    { // SB Output
        write_header :: proc(sb: ^strings.Builder, wrapper_map: ^Wrapper_Map, g: Foreign_Func_Group, f: Foreign_Func) {
            name := clean_func_name(f.link_name);

            fmt.sbprintf(sb, "{} ", name);
            right_pad(sb, len(name), g.longest_func_name);

            fmt.sbprintf(sb, ":: inline proc(");

            sbu := strings.make_builder();
            defer strings.destroy_builder(&sbu);
            if v, ok := wrapper_map[f.link_name]; ok {
                switch w in v {
                    case Wrapper_Func: {
                        write_wrapper_param_list(&sbu, w);
                    }
                    case string: {
                        output_param_list(&sbu, f, true);
                    }
                }
            } else {
                output_param_list(&sbu, f, true);
            }
            
            param_list := strings.to_string(sbu);
            fmt.sbprint(sb, param_list);
            fmt.sbprint(sb, ") ");

            return_length := 0;

            if function_has_return(f) == true {
                sbr := strings.make_builder();
                defer strings.destroy_builder(&sbr);
                fmt.sbprintf(&sbr, "-> {} ", clean_type(f.return_type));
                return_str := strings.to_string(sbr);
                return_length = len(return_str);
                fmt.sbprint(sb, return_str);
            }

            right_pad(sb, len(param_list)+return_length, g.longest_param_return_list);
            fmt.sbprint(sb, "do ");

            if function_has_return(f) == true do fmt.sbprint(sb, "return ");

            if v, ok := wrapper_map[f.link_name]; ok {
                switch w in v {
                    case Wrapper_Func: {
                        output_wrapper_call(sb, w);
                    }
                    case string: {
                        fmt.sbprintf(sb, "{}(", w);
                        output_call_list(sb, f);
                        fmt.sbprint(sb, ");");
                    }
                }
            } else {
                fmt.sbprintf(sb, "{}(", f.link_name);
                output_call_list(sb, f);
                fmt.sbprint(sb, ");");
            }
            fmt.sbprint(sb, "\n");
        }

        for g in groups {
            for x in g.functions {
                switch f in x {
                    case Foreign_Overload_Group:{
                        fmt.sbprint(&sb, "\n");
                        fmt.sbprintf(&sb, "{} :: proc{{\n", clean_func_name(f.name));
                        for y in f.functions {
                            name := clean_func_name(y.link_name);
                            fmt.sbprintf(&sb, "\t{}\n", name);
                        }
                        fmt.sbprint(&sb, "}\n");

                        for y in f.functions do write_header(&sb, wrapper_map, g, y);
                        fmt.sbprint(&sb, "\n");
                    }
                    case Foreign_Func:
                        write_header(&sb, wrapper_map, g, f);
                }
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

@(private="file")
count_cimgui_overloads :: proc(arr: json.Array) -> int {
    count := 0;
    for x in arr {
        if is_nonUDT(x.value.(json.Object)) do continue;
        count += 1;
    }

    return count;
}

gather_foreign_proc_groups :: proc(groups : ^[dynamic]Foreign_Func_Group, obj: json.Object) {
    reset_group_info();
    current_group := Foreign_Func_Group{};
    for _, v in obj {
        overloads := v.value.(json.Array);
        ov_count := count_cimgui_overloads(overloads);

        ov_group := Foreign_Overload_Group{};

        for ov, idx in overloads {
            ov_obj := ov.value.(json.Object);
            if is_nonUDT(ov_obj)    do continue;
            if is_vector(ov_obj)    do continue;
            if is_ctor_dtor(ov_obj) do continue;

            f, ok := convert_json_to_foreign_func(ov_obj);
            if ok == false do continue;

            if figure_out_if_new_group(f.link_name) {
                append(groups, current_group);
                current_group = Foreign_Func_Group{};
            }

            if ov_count > 1 {
                ov_group.name = get_value_string(ov_obj["funcname"]);
                append(&ov_group.functions, f);
            } else {
                append(&current_group.functions, f);
            }
        }

        if ov_count > 1 && len(ov_group.functions) > 0 {
            append(&current_group.functions, ov_group);
        }
    }

    append(groups, current_group);
}

@(private="file")
is_ctor_dtor :: proc(obj: json.Object) -> bool {
    ctor := get_optional_bool(obj, "constructor");
    dtor := get_optional_bool(obj, "destructor");
    return ctor == true || dtor == true;
}

@(private="file")
is_vector :: proc(obj: json.Object) -> bool {
    str := get_value_string(obj["stname"]);
    return str == "ImVector";
}

@(private="file")
is_nonUDT :: proc(obj: json.Object) -> bool {
    _, ok := obj["nonUDT"];
    return ok == true;
}

@(private="file")
convert_json_to_foreign_func :: proc(ov_obj: json.Object) -> (Foreign_Func, bool) {
    f := Foreign_Func{};

    f.link_name = get_value_string(ov_obj["ov_cimguiname"]);
    f.return_type = get_optional_string(ov_obj, "ret");

    for arg in ov_obj["argsT"].value.(json.Array) {
        param := Foreign_Func_Param{};
        arg_obj := arg.value.(json.Object);

        param.name = get_value_string(arg_obj["name"]);
        param.type = get_value_string(arg_obj["type"]);

        if param.type == "..." do param.name = "args";
        if param.type == "va_list" do return Foreign_Func{}, false;

        if param.name == "fmt" do param.name = "fmt_";
        if param.name == "in" do param.name = "in_";

        append(&f.params, param);
        
    }

    return f, true;
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
    key = strings.to_snake_case(key);
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

output_param_list :: proc(sb: ^strings.Builder, f: Foreign_Func, convert_cstring := false) {
    for p, idx in f.params {
        type := clean_type(p.type);
        if convert_cstring == true && type == "cstring" do type = "string";

        if type == "..." {
            type = "..any";
            fmt.sbprint(sb, "#c_vararg ");
        }

        fmt.sbprintf(sb, "{}: {}", p.name, type);
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
