package main;

import "core:log"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json";
import "core:odin/ast"
import "core:odin/tokenizer"
import "core:odin/parser"

Wrapper_Map :: distinct map[string]union{string, Wrapper_Func};

Wrapper_Param :: struct {
    name: string,
    type: string,
};

Wrapper_Func :: struct {
    name: string,
    wrapper_for: string,
    params: [dynamic]Wrapper_Param,
    return_type: string,
    body: string,
};

output_wrappers :: proc(json_path: string, output_path: string) -> ^Wrapper_Map {
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

    groups : [dynamic]Foreign_Func_Group;
    predefined : map[string]Wrapper_Func;

    { // Gather
        gather_foreign_proc_groups(&groups, obj);

        predefined_file := ast.File {
            fullpath = "imgui_predefined.odin"
        };
        src, _ := os.read_entire_file(predefined_file.fullpath);
        predefined_file.src = src;

        err_log : parser.Error_Handler : proc(pos: tokenizer.Pos, msg: string, args: ..any) {
            log.errorf("%s(%d:%d): ", pos.file, pos.line, pos.column);
            log.errorf(msg, ..args);
        }

        warn_log : parser.Warning_Handler : proc(pos: tokenizer.Pos, msg: string, args: ..any) {
            log.warnf("%s(%d:%d): ", pos.file, pos.line, pos.column);
            log.warnf(msg, ..args);
        }

        p := parser.Parser {
            err  = err_log,
            warn = warn_log,
        };

        ok := parser.parse_file(&p, &predefined_file);
        if ok == false || p.error_count > 0 {
            log.error("FAILED TO PARSE 'predefined_imgui.odin'");
            os.exit(1);
        }

        for x in predefined_file.decls {
            if decl, ok := x.derived.(ast.Value_Decl); ok {
                if len(decl.attributes) < 1 do continue;

                decl_name := decl.names[0].derived.(ast.Ident).name;

                for attr in decl.attributes {
                    for x in attr.elems {
                        attr_name, attr_value := get_attr_elem(x); 

                        switch attr_name {
                            case "wrapper": {
                                if decl.values[0].derived.id != ast.Proc_Lit {
                                    log.errorf("%s cannot be a wrapper since it's not a procedure", decl_name);
                                    continue;
                                }
                                w, ok := make_wrapper_from_ast(decl, attr_value, src);
                                if ok == false do continue;

                                predefined[w.wrapper_for] = w;
                            }
                        }
                    }                
                }
            }
        }

        get_attr_elem :: proc(elem: ^ast.Expr) -> (name: string, value: string) {
            v := elem.derived.(ast.Field_Value);
            attr := v.field.derived.(ast.Ident);
            attr_value := v.value.derived.(ast.Basic_Lit);

            name = attr.name;
            value = strings.trim(attr_value.tok.text, "\"");
            return;
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
            if should_make_simple_wrapper(f) == false do return;
            wrapper_name := "";
            if pw, ok := predefined[f.link_name]; ok {
                wrapper_name = pw.name;
                fmt.sbprintf(sb, "// PREDEFINED FOR '{}'\n", f.link_name);
                fmt.sbprint(sb, pw.body);
                fmt.sbprint(sb, "\n\n");
                res[strings.clone(f.link_name)] = pw;
            } else {
                wrapper_name = fmt.aprintf("swr_{}", f.link_name);
                write_wrapper(sb, f, wrapper_name);
                res[strings.clone(f.link_name)] = wrapper_name;
            }
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
}

write_wrapper_param_list :: proc(sb: ^strings.Builder, w: Wrapper_Func) {
    for p, idx in w.params {
        fmt.sbprintf(sb, "{}: {}", p.name, p.type);
        if idx < len(w.params)-1 do fmt.sbprint(sb, ", ");
    }
}

output_wrapper_call :: proc(sb: ^strings.Builder, w: Wrapper_Func) {
    fmt.sbprintf(sb, "{}(", w.name);
    for p, idx in w.params {
        fmt.sbprint(sb, p.name);
        if idx < len(w.params)-1 do fmt.sbprint(sb, ", ");
    }
    fmt.sbprintf(sb, ")",);
}

@(private="file")
make_wrapper_from_ast :: proc(decl: ast.Value_Decl, wrapper_for: string, src: []u8) -> (Wrapper_Func, bool) {
    decl_name := decl.names[0].derived.(ast.Ident).name;
    proc_type := (decl.values[0].derived.(ast.Proc_Lit)).type;

    if proc_type.results != nil && len(proc_type.results.list) > 1 {
        log.errorf("Wrapper '%s' has more than one return value, not allowed", decl_name);
        return Wrapper_Func{}, false;
    }

    res := Wrapper_Func{};
    res.name = decl_name;
    res.wrapper_for = wrapper_for;

    if proc_type.results != nil {
        res.return_type = proc_type.results.list[0].type.derived.(ast.Ident).name;
    }

    if proc_type.params != nil {
        for p in proc_type.params.list {
            param := Wrapper_Param{};
            param.name = p.names[0].derived.(ast.Ident).name;
            switch d in p.type.derived {
                case ast.Ident:
                    param.type = d.name;    
                case ast.Array_Type:
                    param.type = fmt.aprintf("[%s]%s", d.len.derived.(ast.Basic_Lit).tok.text, d.elem.derived.(ast.Ident).name);
                case ast.Pointer_Type:
                    param.type = fmt.aprintf("^%s", d.elem.derived.(ast.Ident).name);
                case ast.Ellipsis:
                    param.type = fmt.aprintf("..{}", d.expr.derived.(ast.Ident).name);
                case :
                    log.errorf("Unexpected paramter type in wrapper '{}': %v, %#v", res.name, param.name, d);
            }
            append(&res.params, param);
        }
    }

    res.body = string(src[decl.pos.offset:decl.end.offset]);

    return res, true;
}

@(private="file")
write_wrapper :: proc(sb: ^strings.Builder, f: Foreign_Func, wrapper_name: string) {
    fmt.sbprintf(sb, "// AUTO_GENERATED for '{}'\n", f.link_name);
    fmt.sbprintf(sb, "{} :: proc(", wrapper_name);
    for p, idx in f.params {
        fmt.sbprintf(sb, "{}: ", p.name);
        type := clean_type(p.type);
        if type == "cstring" do type = "string";
        fmt.sbprint(sb, type);

        if idx < len(f.params)-1 do fmt.sbprint(sb, ", ");
    }
    fmt.sbprint(sb, ") ");
    if function_has_return(f) == true do fmt.sbprintf(sb, "-> {} ", clean_type(f.return_type));
    fmt.sbprint(sb, "{\n");

    var_map : map[string]string;

    for p, idx in f.params {
        if clean_type(p.type) != "cstring" do continue;

        var_name := fmt.tprintf("str{}", idx);
        var_map[p.name] = var_name;
        fmt.sbprintf(sb, "\t{} := fmt.tprintf(\"{{}}\\x00\", {});\n", var_name, p.name);
    }           

    fmt.sbprint(sb, "\t");
    if function_has_return(f) == true do fmt.sbprint(sb, "return ");
    

    fmt.sbprintf(sb, "{}(", f.link_name);
    for p, idx in f.params {
        if v, ok := var_map[p.name]; ok {
            fmt.sbprintf(sb, "cstring(&{}[0])", v);
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