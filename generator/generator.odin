package main;

import "core:fmt";
import "core:reflect";
import "core:encoding/json";
import "core:strings";
import "core:os";
import "core:unicode/utf8";
import "core:log";
import "core:strconv";
import "core:odin/ast"
import "core:odin/tokenizer"
import "core:odin/parser"

PRINT_STRUCTS_AND_ENUMS :: true;
PRINT_PROCEDURES :: true;
PRINT_FOREIGN_PROCEDURES :: true;

Foreign_Group :: struct {
    name : string,
    procs : [dynamic]Foreign_Proc,
    longest_link_name : int,
    longest_proc_name : int,
};

Foreign_Proc :: struct {
    link_name : string,
    name      : string,
    args      : [dynamic]string,
    arguments : [dynamic]Foreign_Proc_Argument,
    ret_type  : string,
    var_args  : bool,
};

Foreign_Proc_Argument :: struct {
    name             : string,
    type             : string,
    var_arg          : bool,
    default_value    : string,
    default_inferred : bool,
}

Proc_Wrapper :: struct {
    link_name    : string,
    name         : string, 
    //wrapper_body : string,
    fields       : []Foreign_Proc_Argument,
    ret_type     : string,
}

Enum_Defintion :: struct {
        name : string,
        fields : [dynamic]Enum_Field,
        longest_field_len : int,
    };
    
Enum_Field :: struct {
    name  : string,
    value : string,
};

Struct_Definiton :: struct {
    name : string,
    fields : [dynamic]Struct_Field,
    longest_field_len : int,
};

Struct_Field :: struct {
    name    : string,
    type    : string,
    is_base : bool
};

main :: proc() {
    logger_opts := log.Options {
        .Level,
        .Short_File_Path,
        .Line,
        .Procedure,
    };
    context.logger = log.create_console_logger(opt = logger_opts);

    {
        log.info("Parsing predefined_imgui.odin...");
        context.logger = log.create_console_logger(opt = logger_opts, ident = "Odin parser");
        err_log : parser.Error_Handler : proc(pos: tokenizer.Pos, msg: string, args: ..any) {
            log.errorf("%s(%d:%d): ", pos.file, pos.line, pos.column);
            log.errorf(msg, ..args);
        }

        warn_log : parser.Warning_Handler : proc(pos: tokenizer.Pos, msg: string, args: ..any) {
            log.warnf("%s(%d:%d): ", pos.file, pos.line, pos.column);
            log.warnf(msg, ..args);
        }


        predefined_file := ast.File {
            fullpath = "imgui_predefined.odin"
        };
        src, _ := os.read_entire_file(predefined_file.fullpath);
        predefined_file.src = src;

        p := parser.Parser {
            err  = err_log,
            warn = warn_log,
        };

        ok := parser.parse_file(&p, &predefined_file);
        if ok == false || p.error_count > 0 {
            log.error("FAILED TO PARSE 'predefined_imgui.odin'");
            os.exit(1);
        }

        check_and_gather_predefined(predefined_file);
    }
    
    when PRINT_STRUCTS_AND_ENUMS == true {{
        data, _ := os.read_entire_file("./cimgui/generator/output/structs_and_enums.json");
        value, err := json.parse(data);

        log.info("Generating structs & enums...");
        if err == json.Error.None {
            fHandle, fErr := os.open("./output/imgui_structs_enums.odin", os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
            if fErr != os.ERROR_NONE {
                log.error("Couldn't create/open file for output! %v", fErr);                
                os.exit(1);
            }

            fmt.fprintf(fHandle, "package imgui;\n\n");

            obj := value.value.(json.Object);

            enums := obj["enums"].value.(json.Object);
            output_enums(fHandle, enums);

            structs := obj["structs"].value.(json.Object);
            output_structs(fHandle, structs);

        } else {
            log.error("Error in json! %v", err);
            os.exit(1);
        }
    }}

    when PRINT_PROCEDURES == true {{
        data, _ := os.read_entire_file("./cimgui/generator/output/definitions.json");
        value, err := json.parse(data);

        log.info("Generating procs...");

        if err == json.Error.None {
            fHandle, fErr := os.open("./output/imgui_procs.odin", os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            if fErr != os.ERROR_NONE {
                log.error("Couldn't create/open file for output! %v", fErr);
                os.exit(1);
            }
            fmt.fprintf(fHandle, "package imgui;\n\n");

            fmt.fprint(fHandle, "when ODIN_DEBUG {\n");
            fmt.fprint(fHandle, "    foreign import cimgui \"external/cimgui_debug.lib\";\n");
            fmt.fprint(fHandle, "} else {\n");
            fmt.fprint(fHandle, "    foreign import \"external/cimgui.lib\";\n");
            fmt.fprint(fHandle, "}\n\n");

            obj := value.value.(json.Object);

            groups := gather_procedures_v2(obj);

            for v in groups {
                for p in v.procs {
                    if strings.has_prefix(p.name, "ig") {

                        wrapper, ok := wrappers[p.link_name];
                        if ok == false {
                            sb := strings.make_builder();
                            if try_generate_simple_wrapper(&sb, p, v.longest_proc_name) == false {
                                log.warn("WRAPPER MISSING: ", p.link_name);
                                fmt.fprintf(fHandle, "// MISSING WRAPPER FOR: %s\n", p.link_name);
                            } else {
                                fmt.fprint(fHandle, strings.to_string(sb));
                            }
                            strings.reset_builder(&sb);
                        } else {
                            fmt.fprintf(fHandle, "// WRAPPER UNDER HERE \n");
                            print_wrapper_call(fHandle, wrapper, v.longest_proc_name);
                            fmt.fprint(fHandle, "\n");
                        }
                        continue;
                    }
                    
                    print_proc(fHandle, p, v.longest_proc_name);
                    print_proxy_call(fHandle, p);
                    fmt.fprintln(fHandle);
                }

                fmt.fprintf(fHandle, "\n\n");
            }

            when PRINT_FOREIGN_PROCEDURES {
                for v in groups {
                    fmt.fprintln(fHandle, "@(default_calling_convention=\"c\")");
                    fmt.fprintln(fHandle, "foreign cimgui {");

                    for p in v.procs {
                        print_foreign_proc(fHandle, p, v.longest_link_name, v.longest_proc_name);
                    }
                    fmt.fprintln(fHandle, "}\n");
                }
            }

        } else {
            log.error("Error in json! %v", err);
            os.exit(1);
        }
    }}
    {
        text_bytes, _ := os.read_entire_file("imgui_predefined.odin");
        os.write_entire_file("./output/imgui_predefined.odin", text_bytes);
    }
}

check_and_gather_predefined :: proc(predefined_file : ast.File) {
    for x in predefined_file.decls {
        if v, ok := x.derived.(ast.Value_Decl); ok {
            if len(v.attributes) < 1 do continue;

            name := v.names[0].derived.(ast.Ident).name;

            for attr in v.attributes {
                for x in attr.elems {
                    f := x.derived.(ast.Field_Value);
                    ident := f.field.derived.(ast.Ident);
                    value := f.value.derived.(ast.Basic_Lit);

                    switch ident.name {
                        case "wrapper": {
                            wrapper, ok := do_wrapper(v, value, name);
                            if ok == false do continue;

                            wrappers[wrapper.link_name] = wrapper;
                        }

                        case "predefined": {
                            if v.values[0].derived.id != ast.Proc_Type {
                                log.errorf("%s cannot be a wrapper since it's not a procedure type", name);
                                continue;
                            }
                        }

                        case "type": {
                            if v.values[0].derived.id != ast.Struct_Type {
                                log.errorf("%s cannot be a wrapper since it's not a procedure", name);
                                continue;
                            }
                        }
                    }
                }                
            }
        }
    }

    do_wrapper :: proc(v : ast.Value_Decl, value : ast.Basic_Lit, name : string) -> (Proc_Wrapper, bool) {
        if v.values[0].derived.id != ast.Proc_Lit {
            log.errorf("%s cannot be a wrapper since it's not a procedure", name);
            return Proc_Wrapper{}, false;
        }

        proc_type := (v.values[0].derived.(ast.Proc_Lit)).type;

        if proc_type.results != nil && len(proc_type.results.list) > 1 {
            log.errorf("Wrapper '%s' has more than one return value, not allowed", name);
            return Proc_Wrapper{}, false;
        }

        return_type := "";
        if proc_type.results != nil {
            return_type = proc_type.results.list[0].type.derived.(ast.Ident).name;
        }

        arguments : [dynamic]Foreign_Proc_Argument;

        if proc_type.params != nil {
            for p in proc_type.params.list {
                r := Foreign_Proc_Argument{};
                r.name = p.names[0].derived.(ast.Ident).name;
                switch d in p.type.derived {
                    case ast.Ident:
                        r.type = d.name;    
                    case ast.Array_Type:
                        r.type = fmt.aprintf("[%s]%s", d.len.derived.(ast.Basic_Lit).tok.text, d.elem.derived.(ast.Ident).name);
                    case ast.Pointer_Type:
                        r.type = fmt.aprintf("^%s", d.elem.derived.(ast.Ident).name);
                    case :
                        log.errorf("Unexpected paramter type in wrapper %v", p.type.derived);
                }
                
                if p.default_value != nil {
                    switch d in p.default_value.derived {
                        case ast.Basic_Lit:
                            r.default_value = d.tok.text;
                        case ast.Ident:
                            r.default_value = d.name;
                        case :
                            log.errorf("Unexpected default value type in wrapper", p.default_value.derived);
                    }
                    
                }

                append(&arguments, r);
            }
        }

        wrapper := Proc_Wrapper {
            link_name = strings.trim(value.tok.text, "\""),
            name = name,
            ret_type = return_type,
            fields = arguments[:],
            //wrapper_body = string(src[v.pos.offset:v.end.offset])
        };

        return wrapper, true;
    }

}

gather_procedures_v2 :: proc(obj : json.Object) -> []Foreign_Group {
    groups : map[string]^Foreign_Group;

    count_overloads :: proc(overloads: json.Array) -> int {
        res := 0;
        for x in overloads {
            overload := x.value.(json.Object);
            if _, has_nonUDT := overload["nonUDT"]; has_nonUDT == false {
                res += 1;
            }
        }
        return res;
    }

    add_to_group :: proc(groups : ^map[string]^Foreign_Group, group_name : string, fproc : Foreign_Proc) {
        if group, ok := groups[group_name]; ok {
            group.longest_link_name = max(group.longest_link_name, len(fproc.link_name));
            group.longest_proc_name = max(group.longest_proc_name, len(fproc.name));

            append(&group.procs, fproc);                
        } else {
            group := new(Foreign_Group);
            group.name = group_name;
            group.longest_link_name = len(fproc.link_name);
            group.longest_proc_name = len(fproc.name);

            append(&group.procs, fproc);
            groups[group_name] = group;
        }
    }

    for def_key, def_val in obj {
        overloads := def_val.value.(json.Array);
        overload_count := count_overloads(overloads); // TODO(Hoej): Setup overload groups for this

        overloads_label: for x in overloads {
            res := Foreign_Proc{};
            overload := x.value.(json.Object);

            if should_overload_be_skipped(overload) do continue;

            res.link_name = get_overload_link_name(overload);
            //log.debugf("Gathering %s", res.link_name);

            arguments := overload["argsT"].value.(json.Array);
            for a in arguments {
                argument := a.value.(json.Object);
                defaults, has_defaults := overload["defaults"].value.(json.Object);
                if arg, skip := get_overload_argument(argument, has_defaults ? &defaults : nil); skip == false {
                    append(&res.arguments, arg);
                }
            }

            res.name = get_overload_name(overload, 
                                         res.link_name, 
                                         len(res.arguments) > 0 ? &res.arguments[0] : nil);

            res.ret_type = get_overload_return_type(overload);

            group_name := clean_imgui_namespacing(overload["stname"].value.(json.String));
            add_to_group(&groups, group_name, res);
        }
    }

    result := make([]Foreign_Group, len(groups));
    idx := 0;
    for _, v in groups {
        result[idx] = v^;
        idx += 1;
    }

    return result;
}

get_overload_return_type :: proc(overload : json.Object) -> string {
    ret, has_ret := overload["ret"].value.(json.String);
    if has_ret == true && ret != "void" {
        b := strings.make_builder();
        is_base := convert_type(&b, "", ret, 0);
        if is_base do return strings.to_string(b);
        else do return to_ada_case(strings.to_string(b));
    }

    return "";
}

get_overload_name :: proc(overload : json.Object, link_name : string, first_arg : ^Foreign_Proc_Argument) -> string {
    if pre, has_predefind := proc_name_by_link_name[link_name]; has_predefind {
        return pre;
    }

    proc_name, has_funcname := overload["funcname"].value.(json.String);
    if has_funcname == false {
        return to_snake_case(link_name);
    }

    if first_arg != nil && (first_arg.name == "label" || 
                            first_arg.name == "str_id" || 
                            first_arg.name == "prefix" || 
                            first_arg.name == "name") {
        return to_snake_case(link_name);
    }

    sb := strings.make_builder();
    proc_name = clean_imgui_namespacing(proc_name);

    if stname_v, has_stname := overload["stname"]; has_stname {
        stname := stname_v.value.(json.String);
        if(len(stname) > 0) {
            type_name := clean_imgui_namespacing(stname);
            strings.write_string(&sb, type_name);
            strings.write_rune(&sb, '_');
        }
    }
    
    strings.write_string(&sb, proc_name);
    return to_snake_case(strings.to_string(sb));
}

get_overload_argument :: proc(argument : json.Object, defaults : ^json.Object) -> (Foreign_Proc_Argument, bool) {
    original_type := argument["type"].value.(json.String);
    if original_type == "va_list" do return Foreign_Proc_Argument{}, true;

    arg := Foreign_Proc_Argument{};

    arg.name = get_out_overload_argument_name(argument);
    if arg.name == "..." {
        arg.name = "args";
        arg.var_arg = true;
        arg.type = "any";
        return arg, false;
    }

    sb := strings.make_builder();
    is_base_type := convert_type(&sb, arg.name, original_type, -1);
    if is_base_type {
        arg.type = strings.clone(strings.to_string(sb));
    } else {
        arg.type = to_ada_case(strings.clone(strings.to_string(sb)));
    }

    strings.reset_builder(&sb);
    _, inferred := get_overload_arugment_default(&sb, argument["name"].value.(json.String), defaults);
    arg.default_value = strings.clone(strings.to_string(sb));
    arg.default_inferred = inferred;

    return arg, false;
}

get_overload_arugment_default :: proc(b : ^strings.Builder, c_name : string, defaults : ^json.Object) -> (found: bool, inferred : bool) {
    if defaults == nil do return;

    inferred = false;
    found = false;

    default_v, name_has_default := defaults[c_name];
    if name_has_default == false do return; 

    found = true;
    
    c_val := default_v.value.(json.String);
    val := "ERROR";
    
    if pre, has_predefind := predefined_defaults_by_value[c_val]; has_predefind {
        val = pre;
    } else if c_val == "FLT_MAX" {
        val = "max(f32)";
        inferred = true;
    } else if c_val == "sizeof(float)" {
        val = "size_of(f32)";
        inferred = true;
    } else if c_val == "((void*)0)" {
        val = "nil";
    } else {
        val = clean_imgui_namespacing(c_val);
    
        if utf8.rune_at_pos(val, 0) != '(' {
            replaced_left, replaced_right : bool;
            val, replaced_left = strings.replace_all(val, "(", "{");
            val, replaced_right = strings.replace_all(val, ")", "}");
            inferred = replaced_left || replaced_right;
        }

        if strings.has_suffix(val, "f") do val = strings.trim_right(val, "f");
    }
    
    strings.write_string(b, val);
    return;
}

get_out_overload_argument_name :: proc(argument : json.Object) -> string {
    name := argument["name"].value.(json.String);

    if name == "..." do return name;

    size, has_size := argument["size"];
    if has_size {
        name = clean_array_brackets(name);
    }

    switch name {
        case "in":  name = "in_";
        case "fmt": name = "format";
    }

    return name;
}

get_overload_link_name :: proc(overload : json.Object) -> string {
    link_name := overload["cimguiname"].value.(json.String);
    if v, ok := overload["ov_cimguiname"]; ok {
        link_name = v.value.(json.String);
    }
    return link_name;
}

should_overload_be_skipped :: proc(overload : json.Object) -> bool {
    if _, has_nonUDT := overload["nonUDT"]; has_nonUDT do return true;

    stname_v, has_stname := overload["stname"]; 
    if has_stname {
        stname := stname_v.value.(json.String);
        if stname == "ImVector" do return true;
    }

    if _, is_ctor := overload["constructor"]; is_ctor do return true;
    if _, is_ctor := overload["destructor"]; is_ctor do return true;

    arguments := overload["argsT"].value.(json.Array);
    for a in arguments {
        argument := a.value.(json.Object);
        type := argument["type"].value.(json.String);
        if type == "va_list" do return true;
    }

    return false;
}

gather_procedures :: proc(obj : json.Object) -> []Foreign_Group {
    groups : map[string]^Foreign_Group;

    count_overloads :: proc(overloads: json.Array) -> int {
        res := 0;
        for x in overloads {
            overload := x.value.(json.Object);
            if _, has_nonUDT := overload["nonUDT"]; has_nonUDT == false {
                res += 1;
            }
        }
        return res;
    }

    figure_out_default_val :: proc(b : ^strings.Builder, c_name : string, overload : json.Object) -> (found: bool, inferred : bool) {
        inferred = false;
        found = false;

        obj, has_defaults := overload["defaults"].value.(json.Object);
        if has_defaults == false do return;

        default_v, name_has_default := obj[c_name];
        if name_has_default == false do return; 

        found = true;
        
        c_val := default_v.value.(json.String);
        val := "ERROR";
        
        if pre, has_predefind := predefined_defaults_by_value[c_val]; has_predefind {
            val = pre;
        } else if c_val == "FLT_MAX" {
            val = "max(f32)";
            inferred = true;
        } else if c_val == "sizeof(float)" {
            val = "size_of(f32)";
            inferred = true;
        } else if c_val == "((void*)0)" {
            val = "nil";
        } else {
            val = clean_imgui_namespacing(c_val);
        
            if utf8.rune_at_pos(val, 0) != '(' {
                replaced_left, replaced_right : bool;
                val, replaced_left = strings.replace_all(val, "(", "{");
                val, replaced_right = strings.replace_all(val, ")", "}");
                inferred = replaced_left || replaced_right;
            }

            if strings.has_suffix(val, "f") do val = strings.trim_right(val, "f");
        }
        
        strings.write_string(b, val);
        return;
    }

    set_ctor_name :: proc(first_arg : ^json.Object) -> string {
        if first_arg != nil {
            c_type := first_arg["type"].value.(json.String);
            b2 := strings.make_builder();
            convert_type(&b2, "", c_type, 0);
            str := strings.to_string(b2);
            if strings.has_prefix(str, "^") do str = str[1:];
            return fmt.tprintf("%s_ctor", str);
        } else {
            return "ctor";
        }
    }

    set_proc_name :: proc(res : ^Foreign_Proc, 
                                  overload : json.Object, 
                                  overload_count : int, 
                                  first_arg : ^json.Object) {
        if pre, has_predefind := proc_name_by_link_name[res.link_name]; has_predefind {
            res.name = pre;
            return;
        }


        proc_name, has_funcname := overload["funcname"].value.(json.String);
        if has_funcname == false || overload_count > 1 {
            proc_name = to_snake_case(res.link_name);
        }
        
        if first_arg != nil {
            c_name := first_arg["name"].value.(json.String);
            if c_name == "label" {
                res.name = to_snake_case(res.link_name);
                return;
            }
        }

        if res.var_args == true {
            res.name = to_snake_case(res.link_name);
            return;
        }

        b := strings.make_builder();
        proc_name = clean_imgui_namespacing(proc_name);

        if stname_v, has_stname := overload["stname"]; has_stname {
            stname := stname_v.value.(json.String);
            if(len(stname) > 0) {
                type_name := clean_imgui_namespacing(stname);
                strings.write_string(&b, type_name);
                strings.write_rune(&b, '_');
            }
        }

        // if _, is_ctor := overload["constructor"]; is_ctor do proc_name = set_ctor_name(first_arg);
        // if _, is_dtor := overload["destructor"];  is_dtor do proc_name = "destroy";
        
        strings.write_string(&b, proc_name);
        res.name = to_snake_case(strings.to_string(b));
    }

    get_link_name :: proc(overload : json.Object) -> string {
        link_name := overload["cimguiname"].value.(json.String);
        if v, ok := overload["ov_cimguiname"]; ok {
            link_name = v.value.(json.String);
        }
        return link_name;
    }

    for def_key, def_val in obj {
        overloads := def_val.value.(json.Array);
        overload_count := count_overloads(overloads);

        overloads_label: for x in overloads {
            res := Foreign_Proc{};
            overload := x.value.(json.Object);

            if should_overload_be_skipped(overload) do continue;

            res.link_name = strings.clone(get_link_name(overload));

            args_arr := overload["argsT"].value.(json.Array);
            for y in args_arr {
                field := y.value.(json.Object);
                
                c_type := field["type"].value.(json.String);
                if c_type == "va_list" do continue overloads_label;
                
                c_name := field["name"].value.(json.String);
                if c_name == "..." {
                    res.var_args = true;
                    append(&res.args, "#c_vararg args : ..any");
                    continue;
                }

                size, has_size := field["size"];
                arg_name := clean_array_brackets(c_name, has_size);

                switch arg_name {
                    case "in":  arg_name = "in_";
                    case "fmt": arg_name = "format";
                }

                b_type := strings.make_builder();
                b_default := strings.make_builder();
                is_base := convert_type(&b_type, arg_name, c_type, 0);
                inferred, default_found := figure_out_default_val(&b_default, c_name, overload);

                if default_found == false {
                    if is_base do append(&res.args, fmt.aprintf("%s : %s", arg_name, strings.to_string(b_type)));
                    else do append(&res.args, fmt.aprintf("%s : %s", arg_name, to_ada_case(strings.to_string(b_type))));
                } else if inferred == true {
                    append(&res.args, fmt.aprintf("%s := %s", arg_name, strings.to_string(b_default)));
                } else {
                    append(&res.args, fmt.aprintf("%s : %s = %s", 
                                                  arg_name, strings.to_string(b_type), 
                                                  strings.to_string(b_default)));
                }
            }

            set_proc_name(&res, 
                          overload, 
                          overload_count, 
                          len(args_arr) > 0 ? &args_arr[0].value.(json.Object) : nil);

            ret, has_ret := overload["ret"].value.(json.String);
            if has_ret == true && ret != "void" {
                b := strings.make_builder();
                is_base := convert_type(&b, "", ret, 0);
                if is_base do res.ret_type = strings.to_string(b);
                else do res.ret_type = to_ada_case(strings.to_string(b));
            }

            group_name := clean_imgui_namespacing(overload["stname"].value.(json.String));
            if group, ok := groups[group_name]; ok {
                group.longest_link_name = max(group.longest_link_name, len(res.link_name));
                group.longest_proc_name = max(group.longest_proc_name, len(res.name));

                append(&group.procs, res);                
            } else {
                group := new(Foreign_Group);
                group.name = group_name;
                group.longest_link_name = len(res.link_name);
                group.longest_proc_name = len(res.name);

                append(&group.procs, res);
                groups[group_name] = group;
            }
        }
    }

    result := make([]Foreign_Group, len(groups));

    idx := 0;
    for _, v in groups {
        result[idx] = v^;
        idx += 1;
    }

    return result;
}

try_generate_simple_wrapper :: proc(sb : ^strings.Builder, p : Foreign_Proc, longest_proc_name : int) -> bool {
    if len(p.arguments) <= 0 do return false;

    count_cstring :: proc(arguments : []Foreign_Proc_Argument) -> int {
        i := 0;
        for arg in arguments {
            if arg.type == "cstring" {
                i += 1;
            }
        }

        return i;
    }

    if count_cstring(p.arguments[:]) > 1 {
        return false;
    }

    first_arg := p.arguments[0];

    if first_arg.type != "cstring" do return false;

    fmt.sbprintf(sb, "%s :: inline proc(", right_pad(p.name[3:], longest_proc_name - len(p.name[3:])));

    fmt.sbprintf(sb, "%s : string", first_arg.name);
    if len(p.arguments) > 1 do fmt.sbprint(sb, ", ");

    print_procedure_arguments(sb, p.arguments[1:]);
    fmt.sbprint(sb, ")");
    if len(p.ret_type) > 0 do fmt.sbprintf(sb, " -> %s", p.ret_type);
    fmt.sbprint(sb, " do ");

    fmt.sbprintf(sb, "return %s(", p.name);
    fmt.sbprintf(sb, "_make_label_string(%s)", first_arg.name);
    if len(p.arguments) > 1 {
        fmt.sbprint(sb, ", ");
    }
    print_call_arguments(sb, p.arguments[1:]);

    fmt.sbprint(sb, ");\n");
    return true;
}

print_call_arguments :: proc(sb : ^strings.Builder, arguments : []Foreign_Proc_Argument) {
    if len(arguments) > 0 {
        for arg, idx in arguments {
            fmt.sbprint(sb, arg.name);
            if idx < len(arguments)-1 {
                fmt.sbprintf(sb, ", ");
            }
        }
    }
}

print_foreign_proc :: proc(fHandle : os.Handle, p : Foreign_Proc, longest_link_name : int, longest_proc_name : int) {
    //fmt.fprintf(fHandle, "\t@(link_name = \"%s\") ", p.link_name);
    // if len(p.link_name) <= longest_link_name {
    //     for _ in len(p.link_name)..longest_link_name-1 do fmt.fprintf(fHandle, " ");
    // }

    fmt.fprintf(fHandle, "\t%s ", right_pad(p.link_name, longest_proc_name - len(p.link_name)));

    fmt.fprintf(fHandle, ":: proc(");
    sb := strings.make_builder();
    print_procedure_arguments(&sb, p.arguments[:]);
    fmt.fprint(fHandle, strings.to_string(sb));
    fmt.fprintf(fHandle, ") ");
    if len(p.ret_type) > 0 {
        fmt.fprintf(fHandle, "-> %s ", p.ret_type);
    }
    fmt.fprintln(fHandle, "---;");
}

print_wrapper_call :: proc(fHandle : os.Handle, p : Proc_Wrapper, longest_proc_name : int) {
    pname := strings.trim_left(p.name, "wrapper_");
    fmt.fprintf(fHandle, "%s ", right_pad(pname, longest_proc_name - len(pname)));

    fmt.fprintf(fHandle, ":: inline proc(");
    sb := strings.make_builder();
    print_procedure_arguments(&sb, p.fields[:]);
    fmt.fprint(fHandle, strings.to_string(sb));
    fmt.fprintf(fHandle, ") ");
    if len(p.ret_type) > 0 {
        fmt.fprintf(fHandle, "-> %s ", p.ret_type);
    }

    fmt.fprintf(fHandle, "do ");

    if len(p.ret_type) > 0 {
        fmt.fprintf(fHandle, "return ");
    }

    fmt.fprint(fHandle, p.name);
    strings.reset_builder(&sb);
    print_call_arguments(&sb, p.fields[:]);
    fmt.fprintf(fHandle, "(%s);", strings.to_string(sb));
}

print_proc :: proc(fHandle : os.Handle, p : Foreign_Proc, longest_proc_name : int) {
    fmt.fprintf(fHandle, "%s ", right_pad(p.name, longest_proc_name - len(p.name)));

    fmt.fprintf(fHandle, ":: inline proc(");
    sb := strings.make_builder();
    print_procedure_arguments(&sb, p.arguments[:]);
    fmt.fprint(fHandle, strings.to_string(sb));
    fmt.fprintf(fHandle, ") ");
    if len(p.ret_type) > 0 {
        fmt.fprintf(fHandle, "-> %s ", p.ret_type);
    }
}

print_proxy_call :: proc(fHandle : os.Handle, p : Foreign_Proc) {
    fmt.fprintf(fHandle, "do ");

    if len(p.ret_type) > 0 {
        fmt.fprintf(fHandle, "return ");
    }

    fmt.fprintf(fHandle, p.link_name);
    sb := strings.make_builder();
    print_call_arguments(&sb, p.arguments[:]);
    fmt.fprintf(fHandle, "(%s);", strings.to_string(sb));
}

print_procedure_arguments :: proc(sb : ^strings.Builder, arguments : []Foreign_Proc_Argument) {
    for a, i in arguments {
        if a.var_arg == false {
            fmt.sbprintf(sb, "%s", a.name);
            if a.default_inferred == false do fmt.sbprintf(sb, " : %s", a.type);

            if len(a.default_value) > 0 {
                if a.default_inferred {
                    fmt.sbprintf(sb, " := %s", a.default_value);
                } else {
                    fmt.sbprintf(sb, " = %s", a.default_value);
                }
            }

            if i < len(arguments)-1 {
                fmt.sbprintf(sb, ", ");
            }
        } else {
            fmt.sbprintf(sb, "#c_vararg %s : ..%s", a.name, a.type);
        }
    }
}

convert_type :: proc(b : ^strings.Builder, field_name : string, c_type : string, size : i64) -> bool {
    type := "ERROR!";
    skip_ptr := false;
    add_ptr := false;
    base := false;
    size := size;
    c_type := c_type;

    if size == -1 {
        start := strings.index(c_type, "[");
        if start != -1 {
            end := strings.index(c_type, "]");
            txt := c_type[start+1:end];
            if(len(txt) > 0) {
                size = i64(strconv.atoi(txt));
                c_type = c_type[:start];
            }
        } else {
            size = 0;
        }
    }

    switch c_type {
        case "void*", "const void*" : {
            type = "rawptr";
            skip_ptr = true;
            base = true;
        }
        case "const char*" : {
            type = "cstring";
            skip_ptr = true;
            base = true;
        }
        case "const char* const[]" : {
            type = "cstring";
            add_ptr = true;
            base = true;
        }
        case: {
            if pre, ok := predefined_type_by_name[field_name]; ok {
                type = pre;
                base = true;
                break;
            }

            if pre, ok := predefined_base_type_by_type[clean_const_ref_ptr(c_type)]; ok {
                type = pre;
                base = true;
                break;
            }
            

            if pre, ok := predefined_type_by_type[clean_const_ref_ptr(c_type)]; ok {
                type = pre;
                base = true;
                break;
            }

            if(field_name == "v") {
                log.debug(c_type);    
                log.debug(size);    
            }

            type = clean_imgui_namespacing(clean_const_ref_ptr(c_type));
        }
    }

    if size > 0 do fmt.sbprintf(b, "[%d]", size);
    if skip_ptr == false {
        if strings.has_suffix(c_type, "*") {
            for _ in 0..strings.count(c_type, "*")-1 {
                strings.write_rune(b, '^');
            }
        }
        
        if strings.has_suffix(c_type, "&") {
            strings.write_rune(b, '^');
        }
    }

    if add_ptr == true {
        strings.write_rune(b, '^');
    }

    strings.write_string(b, type);

    return base;
}

output_structs :: proc(fHandle : os.Handle, structs : json.Object) {
    definitions : [dynamic]Struct_Definiton;

    get_arg_size :: proc(arg : json.Object) -> i64 {
        v, ok := arg["size"];
        return ok ? v.value.(json.Integer) : 0;
    }

    get_arg_name :: proc(arg : json.Object, has_size : bool) -> string {
        return clean_array_brackets(arg["name"].value.(json.String), has_size);
    }

    get_arg_type :: proc(b : ^strings.Builder, arg_name : string, arg : json.Object, size : i64) -> bool {
        c_type := arg["type"].value.(json.String);
        return convert_type(b, arg_name, c_type, size);
    }

    for k, v in structs {
        _, is_predefined := structs_predefined[k];
        if is_predefined == true do continue;

        def := Struct_Definiton{};
        def.name = clean_imgui_namespacing(k[:len(k)]);

        for x in v.value.(json.Array) {
            b := strings.make_builder();
            arg := x.value.(json.Object);

            size := get_arg_size(arg);
            arg_name := get_arg_name(arg, size > 0);
            is_base := get_arg_type(&b, arg_name, arg, size);
            
            append(&def.fields, Struct_Field{ strings.clone(arg_name), strings.to_string(b), is_base});
        }

        def.longest_field_len = min(int);
        for x in def.fields {
            def.longest_field_len = max(def.longest_field_len, len(x.name));
        }

        append(&definitions, def);
    }

    for def in definitions {
        fmt.fprintf(fHandle, "%s :: struct {\n", to_ada_case(def.name));

        for f in def.fields {
            fmt.fprintf(fHandle, "\t%s ", right_pad(f.name, def.longest_field_len - len(f.name)));
            if f.is_base do fmt.fprintf(fHandle, ": %s,\n", f.type);
            else do fmt.fprintf(fHandle, ": %s,\n", to_ada_case(f.type));
        }

        fmt.fprintln(fHandle, "};\n");
    }
}

output_enums :: proc(fHandle : os.Handle, enums : json.Object) {
    definitions : [dynamic]Enum_Defintion;

    for key, v in enums {
        def := Enum_Defintion{};
        arr := v.value.(json.Array);

        def.name = clean_imgui_namespacing(key[:len(key)-1]);

        clean_field_val :: proc(name : string) -> string {
            cleaned := strings.trim_space(name);
            cleaned = clean_imgui_namespacing(cleaned);
            parts := strings.split(cleaned, "_");
            return len(parts) > 1 ? parts[1] : cleaned;
        }

        get_field_name :: proc(field : json.Object) -> string {
            parts := strings.split(field["name"].value.(json.String), "_");
            part := len(parts[1]) != 0 ? parts[1] : parts[2];
            return part;
        }

        for x in arr {
            res := Enum_Field{};
            field := x.value.(json.Object);
            res.name = strings.clone(get_field_name(field));

            #partial switch v in field["value"].value {
                case json.Integer: {
                    res.value = fmt.aprintf("%d", v);
                }

                case json.String: {
                    c_value := field["value"].value.(json.String);

                    if strings.index_any(c_value, "|") > 0 {
                        parts := strings.split(c_value, "|");
                        b := strings.make_builder();
                        for x, i in parts {
                            strings.write_string(&b, clean_field_val(x));
                            if i < len(parts)-1 {
                                strings.write_string(&b, " | ");
                            }
                        }
                        res.value = strings.to_string(b);
                    } else {
                        res.value = strings.clone(clean_field_val(c_value));
                    }
                }
            }
           
            append(&def.fields, res);
        }

        def.longest_field_len = min(int);
        for x in def.fields {
            def.longest_field_len = max(def.longest_field_len, len(x.name));
        }

        append(&definitions, def);
    }

    for def in definitions {
        fmt.fprintf(fHandle, "%s :: enum i32 {\n", to_ada_case(def.name));
            for x in def.fields {
            fmt.fprintf(fHandle, "\t%s ", right_pad(x.name, def.longest_field_len - len(x.name)));
            fmt.fprintf(fHandle, "= %s,\n", x.value);
        }

        fmt.fprintln(fHandle, "}\n");
    }
}
