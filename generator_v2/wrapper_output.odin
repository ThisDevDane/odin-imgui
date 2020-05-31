package main;

import "core:log"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json";

Wrapper_Map :: distinct map[string]union{string, Wrapper_Func};

output_wrappers :: proc(json_path: string, output_path: string, predefined_entites: []Predefined_Entity) -> ^Wrapper_Map {
    log.info("Outputting wrappers...");
    res := new(Wrapper_Map);

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
    fmt.sbprint(&sb, "import \"core:fmt\";\n");
    fmt.sbprint(&sb, "import \"core:strings\";\n");
    fmt.sbprint(&sb, "import \"core:mem\";\n");

    groups : [dynamic]Foreign_Func_Group;
    predefined : map[string]Wrapper_Func;

    { // Gather
        gather_foreign_proc_groups(&groups, obj);

        for x in predefined_entites {
            #partial switch y in x {
                case Wrapper_Func: {
                    predefined[y.wrapper_for] = y;
                }
            }
        }
    }

    { // SB Output
        for g in groups {
            for x in g.functions {
                switch f in x {
                    case Foreign_Overload_Group:
                        for y in f.functions {
                            output(&sb, y, predefined, res);
                        }
                    case Foreign_Func:
                        output(&sb, f, predefined, res);
                }
            }

            fmt.sbprint(&sb, "\n");
        }

        output :: proc(sb: ^strings.Builder, f: Foreign_Func, predefined: map[string]Wrapper_Func, res: ^Wrapper_Map) {
            wrapper_name := "";
            if pw, ok := predefined[f.link_name]; ok {
                wrapper_name = pw.name;
                fmt.sbprintf(sb, "// PREDEFINED FOR '{}'\n", f.link_name);
                fmt.sbprint(sb, pw.body);
                fmt.sbprint(sb, "\n\n");
                res[strings.clone(f.link_name)] = pw;
            } else {
                if should_make_simple_wrapper(f) == false do return;
                wrapper_name = fmt.aprintf("swr_{}", f.link_name);
                write_wrapper(sb, f, wrapper_name);
                res[strings.clone(f.link_name)] = wrapper_name;
            }
        }
    }

    { // File output 
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting wrappers! %v", err);                
            return nil;
        }

        os.write_string(handle, strings.to_string(sb));
    }

    return res;
}

write_wrapper_param_list :: proc(sb: ^strings.Builder, w: Wrapper_Func) {
    for p, idx in w.params {
        if p.default_value != "" {
            if p.default_value != "nil" {
                fmt.sbprintf(sb, "{} := {}({})", p.name, p.type, p.default_value);
            } else {
                fmt.sbprintf(sb, "{} : {} = {}", p.name, p.type, p.default_value);
            }
        } else {
            fmt.sbprintf(sb, "{}: {}", p.name, p.type);   
        }
        if idx < len(w.params)-1 do fmt.sbprint(sb, ", ");
    }
}

output_wrapper_call :: proc(sb: ^strings.Builder, w: Wrapper_Func) {
    fmt.sbprintf(sb, "{}(", w.name);
    for p, idx in w.params {
        if strings.has_prefix(p.type, "..") do fmt.sbprint(sb, "..");
        fmt.sbprint(sb, p.name);
        if idx < len(w.params)-1 do fmt.sbprint(sb, ", ");
    }
    fmt.sbprintf(sb, ")");
}

@(private="file")
write_wrapper :: proc(sb: ^strings.Builder, f: Foreign_Func, wrapper_name: string) {
    fmt.sbprintf(sb, "// AUTO_GENERATED for '{}'\n", f.link_name);
    fmt.sbprintf(sb, "{} :: proc(", wrapper_name);
    for p, idx in f.params {
        fmt.sbprintf(sb, "{}: ", p.name);
        type := clean_type(p.type);
        if type == "cstring" do type = "string";
        if type == "..." do type = "..any";
        fmt.sbprint(sb, type);

        if idx < len(f.params)-1 do fmt.sbprint(sb, ", ");
    }
    fmt.sbprint(sb, ") ");
    if t, ok := function_has_return(f); ok == true do fmt.sbprintf(sb, "-> {} ", clean_type(t));
    fmt.sbprint(sb, "{\n");

    var_map : map[string]string;

    for p, idx in f.params {
        if clean_type(p.type) != "cstring" do continue;

        var_name := fmt.tprintf("str{}", idx);
        var_map[p.name] = var_name;
        fmt.sbprintf(sb, "\t{} := strings.clone_to_cstring({}, context.temp_allocator);\n", var_name, p.name);
    }           

    fmt.sbprint(sb, "\t");
    if _, ok := function_has_return(f); ok == true do fmt.sbprint(sb, "return ");
    

    fmt.sbprintf(sb, "{}(", f.link_name);
    for p, idx in f.params {
        if v, ok := var_map[p.name]; ok {
            fmt.sbprint(sb, v);
        } else {
            fmt.sbprint(sb, p.name);
        }
        if idx < len(f.params)-1 do fmt.sbprint(sb, ", ");
    }
    fmt.sbprint(sb, ");");
    fmt.sbprint(sb, "\n");
    fmt.sbprint(sb, "}\n\n");
}

@(private="file")
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