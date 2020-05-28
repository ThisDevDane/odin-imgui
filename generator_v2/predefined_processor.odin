package main;

import "core:log"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:odin/ast"
import "core:odin/tokenizer"
import "core:odin/parser"

Predefined_Entity :: union {
    Output_Copy,
    Foreign_Overwrite,
    Wrapper_Func,
    Struct_Overwrite
}

Struct_Overwrite :: struct {
    for_struct: string,
    text: string,
}

Output_Copy :: struct {
    text: string,
}

Foreign_Overwrite :: struct {
    for_foreign: string,
    name: string,
    body: string,
}

Wrapper_Param :: struct {
    name: string,
    type: string,
    default_value: string,
};

Wrapper_Func :: struct {
    name: string,
    wrapper_for: string,
    params: [dynamic]Wrapper_Param,
    return_type: string,
    body: string,
};

output_predefined_copies :: proc(output_path: string, predefined_entities: []Predefined_Entity) {
    log.info("Outputting predefined copies...");

    sb := strings.make_builder();
    defer strings.destroy_builder(&sb);
    insert_package_header(&sb);

    { // SB Output
        for e in predefined_entities {
            #partial switch oc in e {
                case Output_Copy: {
                    fmt.sbprint(&sb, oc.text);
                    fmt.sbprint(&sb, "\n\n");
                }
            }
        }
    }

    { // File output 
        handle, err := os.open(output_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC);
            
        if err != os.ERROR_NONE {
            log.errorf("Couldn't create/open file for outputting predefined copies! %v", err);                
        }

        os.write_string(handle, strings.to_string(sb));
    }
} 

process_predefined :: proc(odin_file_path: string) -> []Predefined_Entity {
    log.info("Processing predfined declerations...");

    res : [dynamic]Predefined_Entity;

    predefined_file := ast.File {
        fullpath = odin_file_path
    };
    src, _ := os.read_entire_file(predefined_file.fullpath);
    predefined_file.src = src;
    defer delete(src);

    err_log : parser.Error_Handler : proc(pos: tokenizer.Pos, msg: string, args: ..any) {
        log.errorf("%s(%d:%d): \n", pos.file, pos.line, pos.column);
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
        log.errorf("FAILED TO PARSE '{}'", odin_file_path);
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
                        case "struct_overwrite": {
                            so := Struct_Overwrite{};
                            so.for_struct = strings.clone(attr_value);
                            so.text = strings.clone(string(src[decl.pos.offset:decl.end.offset]));
                            append(&res, so);
                        }

                        case "output_copy": {
                            oc := Output_Copy{};
                            oc.text = strings.clone(string(src[decl.pos.offset:decl.end.offset]));
                            append(&res, oc);
                        }

                        case "wrapper": {
                            switch v in decl.values[0].derived {
                                case ast.Proc_Lit: {
                                    w, ok := make_wrapper_from_ast(decl, attr_value, src);
                                    if ok == false do continue;

                                    append(&res, w);
                                }
                                case: {
                                    log.errorf("'%s' cannot be a wrapper since it's not a procedure", decl_name);
                                    continue;    
                                }
                            }
                        }

                        case "foreign_overwrite": {
                            switch v in decl.values[0].derived {
                                case ast.Proc_Lit: {
                                    fo := Foreign_Overwrite{};
                                    fo.for_foreign = strings.clone(attr_value);
                                    fo.name = strings.clone(decl_name);
                                    fo.body = strings.clone(string(src[v.pos.offset:v.end.offset]));
                                    append(&res, fo);
                                }
                                case: {
                                    log.errorf("'%s' cannot be a foreign overwrite since it's not a procedure", decl_name);
                                    continue;    
                                }
                            }
                        }

                        case:
                            log.warnf("Not handling '{}' attribute!", attr_name);
                    }
                }                
            }
        }
    }

    return res[:];
}

@(private="file")
make_wrapper_from_ast :: proc(decl: ast.Value_Decl, wrapper_for: string, src: []u8) -> (Wrapper_Func, bool) {
    decl_name := decl.names[0].derived.(ast.Ident).name;
    proc_type := (decl.values[0].derived.(ast.Proc_Lit)).type;

    res := Wrapper_Func{};
    res.name = strings.clone(decl_name);
    res.wrapper_for = strings.clone(wrapper_for);

    if proc_type.results != nil {
        res.return_type = proc_type.results.list[0].type.derived.(ast.Ident).name;
    }

    if proc_type.params != nil {
        parse_params_from_ast(&res, proc_type, src);
    }

    res.body = strings.clone(string(src[decl.pos.offset:decl.end.offset]));

    if proc_type.results != nil {
        if len(proc_type.results.list) > 1 {
            log.errorf("Wrapper '%s' has more than one return value, not allowed", decl_name);
            return Wrapper_Func{}, false;
        }

        for r in proc_type.results.list {
            res.return_type = strings.clone(r.type.derived.(ast.Ident).name);
        }
    }

    return res, true;
}

@(private="file")
parse_params_from_ast :: proc(func: ^Wrapper_Func, proc_type: ^ast.Proc_Type, src: []u8) {
    for p in proc_type.params.list {
        param := Wrapper_Param{};
        param.name = strings.clone(p.names[0].derived.(ast.Ident).name);
        if p.default_value != nil {
            switch e in p.default_value.derived {
                case ast.Call_Expr:
                    param.type = strings.clone(e.expr.derived.(ast.Ident).name);
                    param.default_value = strings.clone(e.args[0].derived.(ast.Basic_Lit).tok.text);
                case ast.Ident:
                    param.default_value = strings.clone(e.name);
                case:
                    log.errorf("Unexpected default value! {}", e);
            }
        }
        if p.type != nil {
            switch d in p.type.derived {
                case ast.Ident:
                    param.type = strings.clone(d.name);
                case ast.Array_Type:
                    if d.len == nil {
                        param.type = fmt.aprintf("[]%s", d.elem.derived.(ast.Ident).name);
                    } else {
                        param.type = fmt.aprintf("[%s]%s", d.len.derived.(ast.Basic_Lit).tok.text, d.elem.derived.(ast.Ident).name);
                    }
                case ast.Pointer_Type:
                    param.type = fmt.aprintf("^%s", d.elem.derived.(ast.Ident).name);
                case ast.Ellipsis:
                    param.type = fmt.aprintf("..{}", d.expr.derived.(ast.Ident).name);
                case :
                    log.errorf("Unexpected paramter type in wrapper '{}': %v, %#v", func.name, param.name, d);
            }
        }
        append(&func.params, param);
    }
}

@(private="file")
get_attr_elem :: proc(elem: ^ast.Expr) -> (name: string, value: string) {
    switch x in elem.derived {
        case ast.Field_Value: {
            attr := x.field.derived.(ast.Ident);
            attr_value := x.value.derived.(ast.Basic_Lit);

            name = attr.name;
            value = strings.trim(attr_value.tok.text, "\"");
        }

        case ast.Ident: {
            name = x.name;
        }
    }
    
    return;
}