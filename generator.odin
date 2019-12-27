package main;

import "core:fmt";
import "core:reflect";
import "core:encoding/json";
import "core:strings";
import "core:os";
import "core:unicode/utf8";

main :: proc() {
    fmt.println("Generator for odin-imgui v0.1 by ThisDrunkDane (Mikkel Hjortshoej)");

   {
        data, _ := os.read_entire_file("test.json");
        value, err := json.parse(data);

        if err == json.Error.None {
            fmt.println("JSON parsed successfully!");
            obj := value.value.(json.Object);

            enums := obj["enums"].value.(json.Object);
            print_enums(enums);

            structs := obj["structs"].value.(json.Object);
            print_structs(structs);

        } else {
            fmt.eprintln("Error in json!", err);
        }
   }
   {
        data, _ := os.read_entire_file("test2.json");
        value, err := json.parse(data);

        if err == json.Error.None {
            fmt.println("JSON parsed successfully!");
            obj := value.value.(json.Object);

            fmt.println("@(default_calling_convention=\"c\")");
            fmt.println("foreign cimgui {");

            Foreign_Proc :: struct {
                link_name : string,
                name      : string,
                args      : [dynamic]string,
                ret_type  : string,
                var_args  : bool,
            };

            procs : [dynamic]Foreign_Proc;

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

            for def_key, def_val in obj {
                overloads := def_val.value.(json.Array);
                overload_count := count_overloads(overloads);

                overloads_label: for x in overloads {
                    res := Foreign_Proc{};
                    overload := x.value.(json.Object);

                    if _, has_nonUDT := overload["nonUDT"]; has_nonUDT do continue;
                    stname_v, has_stname := overload["stname"]; 
                    if has_stname {
                        stname := stname_v.value.(json.String);
                        if stname == "ImVector" do continue;
                    }

                    link_name := overload["cimguiname"].value.(json.String);
                    if v, ok := overload["ov_cimguiname"]; ok {
                        link_name = v.value.(json.String);
                    }
                    res.link_name = strings.clone(link_name);

                    args_arr := overload["argsT"].value.(json.Array);
                    for y in args_arr {
                        field := y.value.(json.Object);
                        c_type := field["type"].value.(json.String);
                        if c_type == "va_list" do continue overloads_label;
                        size, has_size := field["size"];
                        c_name := field["name"].value.(json.String);
                        if c_name == "..." {
                            res.var_args = true;
                            continue;
                        }

                        arg_name := remove_array_from_name(c_name, has_size);
                        if arg_name == "in" do arg_name = "in_";
                        b := strings.make_builder();
                        convert_type(&b, arg_name, c_type, false, 0);

                        if defaults_obj, ok := overload["defaults"].value.(json.Object); ok {
                            if v, has_default := defaults_obj[c_name]; has_default {
                                val := remove_c_namespace(v.value.(json.String));
                                if val == "((void*)0)" do val = "nil";
                                if utf8.rune_at_pos(val, 0) != '(' {
                                    val, _ = strings.replace_all(val, "(", "{");
                                    val, _ = strings.replace_all(val, ")", "}");
                                }
                                strings.write_string(&b, fmt.tprintf(" = %v", strings.trim_right(val, "f")));
                            }
                        }

                        append(&res.args, fmt.aprintf("%s : %s", arg_name, strings.to_string(b)));
                    }

                    set_proc_name :: proc(res : ^Foreign_Proc, overload : json.Object, overload_count : int, first_arg : ^json.Object, stname : ^json.String) {
                        if pre, has_predefind := proc_name_by_link_name[res.link_name]; has_predefind {
                            res.name = pre;
                            return;
                        }


                        proc_name, has_funcname := overload["funcname"].value.(json.String);
                        if has_funcname == false || overload_count > 1 {
                            proc_name = res.link_name;
                        }
                        
                        if first_arg != nil {
                            c_name := first_arg["name"].value.(json.String);
                            if c_name == "label" {
                                res.name = res.link_name;
                                return;
                            }
                        }

                        if res.var_args == true {
                            res.name = res.link_name;
                            return;
                        }

                        b := strings.make_builder();
                        proc_name = remove_c_namespace(proc_name);
                        if stname != nil {
                            if(len(stname^) > 0) {
                                type_name := remove_c_namespace(stname^);
                                strings.write_string(&b, type_name);
                                strings.write_rune(&b, '_');
                            }
                        }
                        if _, is_ctor := overload["constructor"]; is_ctor {
                            if first_arg != nil {
                                c_type := first_arg["type"].value.(json.String);
                                b2 := strings.make_builder();
                                convert_type(&b2, "", c_type, false, 0);
                                str := strings.to_string(b2);
                                if strings.has_prefix(str, "^") do str = str[1:];
                                proc_name = fmt.tprintf("%s_ctor", str);
                            } else {
                                proc_name = "ctor";
                            }
                        }
                        if _, is_ctor := overload["destructor"]; is_ctor do proc_name = "destroy";
                        strings.write_string(&b, proc_name);
                        res.name = strings.to_string(b);
                    }

                    set_proc_name(&res, 
                                  overload, 
                                  overload_count, len(args_arr) > 0 ? &args_arr[0].value.(json.Object) : nil, 
                                  has_stname ? &stname_v.value.(json.String) : nil);

                    ret, has_ret := overload["ret"].value.(json.String);
                    if has_ret == true && ret != "void" {
                        b := strings.make_builder();
                        convert_type(&b, "", ret, false, 0);
                        res.ret_type = strings.to_string(b);
                    }

                    append(&procs, res);
                } 
            }

            longest_link_name := min(int);
            for x in procs {
                longest_link_name = max(longest_link_name, len(x.link_name));
            }
            longest_proc_name := min(int);
            for x in procs {
                longest_proc_name = max(longest_proc_name, len(x.name));
            }

            for p in procs {
                fmt.printf("\t@(link_name = \"%s\") ", p.link_name);
                if len(p.link_name) <= longest_link_name {
                    for _ in len(p.link_name)..longest_link_name-1 {
                        fmt.printf(" ");
                    }
                }
                fmt.printf("%s ", p.name);
                if len(p.name) <= longest_proc_name {
                    for _ in len(p.name)..longest_proc_name-1 {
                        fmt.printf(" ");
                    }
                }

                fmt.printf(":: proc(");
                for a, i in p.args{
                    fmt.printf("%s", a);
                    if i < len(p.args)-1 {
                        fmt.printf(", ");
                    }
                }

                if(p.var_args) do fmt.printf(" /* VAR_ARGS */");

                fmt.printf(") ");
                if len(p.ret_type) > 0 {
                    fmt.printf("-> %s ", p.ret_type);
                }
                fmt.println("---;");
            }

            fmt.println("}");

        } else {
            fmt.eprintln("Error in json!", err);
        }
   }
}

convert_type :: proc(b : ^strings.Builder, field_name : string, c_type : string, has_size : bool, size : i64) {
    type := "UNKNOWN";
    skip_ptr := false;

    switch c_type {
        case "void*", "const void*" : {
            type = "rawptr";
            skip_ptr = true;
        }
        case "const char*" : {
            type = "cstring";
            skip_ptr = true;
        }
        case: {
            if pre, ok := predefined_type_for_structs_by_name[field_name]; ok {
                type = pre;
                break;
            }
            
            type = remove_c_namespace(remove_const_and_ptr(c_type));

            if pre, ok := predefined_type_for_structs_by_type[type]; ok {
                type = pre;
                break;
            }
        }
    }

    if has_size do strings.write_string(b, fmt.tprintf("[%d]", size));
    if skip_ptr == false && strings.has_suffix(c_type, "*") {
        for i := 0; i < strings.count(c_type, "*"); i += 1 {
            strings.write_rune(b, '^');
        }
    }
    if skip_ptr == false && strings.has_suffix(c_type, "&") {
            strings.write_rune(b, '^');
    }
    strings.write_string(b, type);
}

print_structs :: proc(structs : json.Object) {

    Struct_Field :: struct {
        name : string,
        type : string,
    };

    for k, v in structs {
        _, is_predefined := structs_predefined[k];
        if is_predefined == true do continue;
        struct_name := remove_c_namespace(k[:len(k)]);
        fmt.printf("%s :: struct {\n", struct_name);
        arr := v.value.(json.Array);
        fields : [dynamic]Struct_Field;
        for x in arr {
            field := x.value.(json.Object);
            size_v, has_size := field["size"];
            size := has_size ? size_v.value.(json.Integer) : 0;
            field_name := remove_array_from_name(field["name"].value.(json.String), has_size);
            c_type := field["type"].value.(json.String);

            b := strings.make_builder();
            convert_type(&b, field_name, c_type, has_size, size);
            append(&fields, Struct_Field{ strings.clone(field_name), strings.to_string(b) });
        }

        longest_field_len := min(int);
        for x in fields {
            longest_field_len = max(longest_field_len, len(x.name));
        }

        for x in fields {
            fmt.printf("\t%s", x.name);
            if len(x.name) <= longest_field_len {
                for _ in len(x.name)..longest_field_len {
                    fmt.printf(" ");
                }
            }
            fmt.printf(": %s,\n", x.type);
        }

        fmt.println("};\n");
    }
}

remove_array_from_name :: proc(s : string, has_size : bool) -> string {
    if has_size == false do return s;

    result := s;
    i := strings.index(s, "[");
    if i > 0 {
        result = result[:i];
    }

    return result;
}

remove_const_and_ptr :: proc(s : string) -> string {
    result := s;
    if strings.has_prefix(s, "const") {
        result = result[6:];
    }

    i := strings.index(result, "*");
    if i > 0 {
        result = result[:i];
    }

    if strings.has_suffix(s, "&") {
        result = result[:len(result)-1];
    }

    return result;
}

print_enums :: proc(enums : json.Object) {
    Enum_Field :: struct {
        name  : string,
        value : string,
    };

    for k, v in enums {
        arr := v.value.(json.Array);
        fmt.printf("%s :: enum i32 {\n", remove_c_namespace(k[:len(k)-1]));
        fields : [dynamic]Enum_Field;
        for x in arr {
            field := x.value.(json.Object);
            parts := strings.split(field["name"].value.(json.String), "_");
            res := Enum_Field{};
            part := len(parts[1]) != 0 ? parts[1] : parts[2];
            res.name = strings.clone(part);

            if v, ok := field["value"].value.(json.Integer); ok {
                res.value = fmt.aprintf("%d", v);
            } else {
                 c_value := field["value"].value.(json.String);

                if strings.index_any(c_value, "|") > 0 {
                    parts := strings.split(c_value, "|");
                    b := strings.make_builder();
                    for x, i in parts {
                        part := strings.trim_space(x);
                        non_ns := remove_c_namespace(part);
                        strings.write_string(&b, strings.split(non_ns, "_")[1]);
                        if i < len(parts)-1 {
                            strings.write_string(&b, " | ");
                        }
                    }
                    res.value = strings.to_string(b);
                } else {
                    parts := strings.split(remove_c_namespace(c_value), "_");
                    i := len(parts) > 1 ? 1 : 0;
                    res.value = strings.clone(parts[i]);
                }
            }
           
            append(&fields, res);
        }

        longest_field_len := min(int);
        for x in fields {
            longest_field_len = max(longest_field_len, len(x.name));
        }

        for x in fields {
            fmt.printf("\t%s", x.name);
            if len(x.name) <= longest_field_len {
                for _ in len(x.name)..longest_field_len {
                    fmt.printf(" ");
                }
            }
            fmt.printf("= %s,\n", x.value);
        }

        fmt.println("}\n");
    }
}

remove_c_namespace :: proc(s : string) -> string {
    if strings.has_prefix(s, "Im") == true && strings.has_prefix(s, "Image") == false {
        result := s[2:];
        if strings.has_prefix(result, "Gui") == true {
            result = result[3:];
        }
        return result;
    }

    return s;
}