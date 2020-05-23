package main;

import "core:strings";
import "core:log";
import "core:fmt";

insert_package_header :: proc(sb: ^strings.Builder) do fmt.sbprint(sb, "package imgui;\n\n");

remove_array_decleration :: proc(s : string, has_size := true) -> string {
    if has_size == false do return s;

    result := s;
    i := strings.index(s, "[");
    if i > 0 {
        result = result[:i];
    }

    return result;
}

clean_ptr :: proc(s : string) -> (result: string, ptr_count: int){
    result = s;
    i := strings.index(result, "*");
    if i > 0 {
        ptr_count = strings.count(result, "*");
        result = result[:i];
    }

    return;
}

clean_const :: proc(s : string) -> string {
    result := s;
    if strings.has_prefix(s, "const") {
        result = result[6:];
    }
    return result;
}

clean_imgui :: proc(s : string) -> string {
    if strings.has_prefix(s, "Im") == true && strings.has_prefix(s, "Image") == false {
        result := s[2:];
        if strings.has_prefix(result, "Gui") == true {
            result = result[3:];
        }
        return result;
    }

    return s;
}

to_snake_case :: proc(str: string, allocator := context.allocator) -> string {
    buf := strings.make_builder(allocator);

    last_chars: [2]rune;
    for char, offset in str {
        switch char {
        case 'A'..'Z':
            switch last_chars[1] {
            case 'a'..'z', '0'..'9':
                strings.write_rune(&buf, '_');
            case 'A'..'Z':
                strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
            }
        case 'a'..'z':
            switch last_chars[1] {
            case 'A'..'Z':
                switch last_chars[0] {
                case 'A'..'Z':
                    strings.write_rune(&buf, '_');
                }
                strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
            case '0'..'9':
                strings.write_rune(&buf, '_');
            }
            strings.write_rune(&buf, char);
        case '0'..'9':
            switch last_chars[1] {
            case 'A'..'Z':
                strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
                strings.write_rune(&buf, '_');
            case 'a'..'z':
                strings.write_rune(&buf, '_');
            }
            strings.write_rune(&buf, char);
        case '_':
            switch last_chars[1] {
            case 'A'..'Z':
                strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
            }
            strings.write_rune(&buf, char);
        case:
            log.info(str);
            unimplemented();
        }

        last_chars[0] = last_chars[1];
        last_chars[1] = char;
    }

    switch last_chars[1] {
    case 'A'..'Z':
        strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
    }

    return strings.to_string(buf);
}

to_ada_case :: proc(str: string, allocator := context.allocator) -> string {
    buf := strings.make_builder(allocator);
 
    last_chars: [2]rune;
    for char, offset in str {
        switch char {
        case 'A'..'Z':
            switch last_chars[1] {
            case 'a'..'z', '0'..'9':
                strings.write_rune(&buf, '_');
            case 'A'..'Z':
                switch last_chars[0] {
                case '_', '\x00':
                    strings.write_rune(&buf, last_chars[1]);
                case:
                    strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
                }
            }
        case 'a'..'z':
            switch last_chars[1] {
            case 'A'..'Z':
                switch last_chars[0] {
                case 'A'..'Z':
                    strings.write_rune(&buf, '_');
                    strings.write_rune(&buf, last_chars[1]);
                case:
                    strings.write_rune(&buf, last_chars[1]);
                }
                strings.write_rune(&buf, char);
            case '0'..'9':
                strings.write_rune(&buf, '_');
                strings.write_rune(&buf, char);
            case 'a'..'z':
                strings.write_rune(&buf, char);
            case '_', '\x00':
                strings.write_rune(&buf, char - ('a'-'A'));
            }
        case '0'..'9':
            switch last_chars[1] {
            case 'A'..'Z':
                strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
                strings.write_rune(&buf, '_');
            case 'a'..'z':
                strings.write_rune(&buf, '_');
            }
            strings.write_rune(&buf, char);
        case '_':
            switch last_chars[1] {
            case 'A'..'Z':
                strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
            }
            strings.write_rune(&buf, char);
        case:
            strings.write_rune(&buf, char);
        }
 
        last_chars[0] = last_chars[1];
        last_chars[1] = char;
    }
 
    switch last_chars[1] {
    case 'A'..'Z':
        strings.write_rune(&buf, last_chars[1] + ('a'-'A'));
    }
 
    return strings.to_string(buf);
}

to_screaming_snake_case :: proc(str: string, allocator := context.allocator) -> string {
    buf := strings.make_builder(allocator);
 
    last_chars: [2]rune;
    for char, offset in str {
        switch char {
        case 'A'..'Z':
            switch last_chars[1] {
            case 'a'..'z', '0'..'9':
                strings.write_rune(&buf, '_');
            case 'A'..'Z':
                strings.write_rune(&buf, last_chars[1]);
            }
        case 'a'..'z':
            switch last_chars[1] {
            case 'A'..'Z':
                switch last_chars[0] {
                case 'A'..'Z':
                    strings.write_rune(&buf, '_');
                    strings.write_rune(&buf, last_chars[1]);
                case:
                    strings.write_rune(&buf, last_chars[1]);
                }
                strings.write_rune(&buf, char - ('a'-'A'));
            case '0'..'9':
                strings.write_rune(&buf, '_');
                strings.write_rune(&buf, char - ('a'-'A'));
            case 'a'..'z':
                strings.write_rune(&buf, char - ('a'-'A'));
            case '_', '\x00':
                strings.write_rune(&buf, char - ('a'-'A'));
            }
        case '0'..'9':
            switch last_chars[1] {
            case 'A'..'Z':
                strings.write_rune(&buf, last_chars[1]);
                strings.write_rune(&buf, '_');
            case 'a'..'z':
                strings.write_rune(&buf, '_');
            }
            strings.write_rune(&buf, char);
        case '_':
            switch last_chars[1] {
            case 'A'..'Z':
                strings.write_rune(&buf, last_chars[1]);
            }
            strings.write_rune(&buf, char);
        case:
            unimplemented();
        }
 
        last_chars[0] = last_chars[1];
        last_chars[1] = char;
    }
 
    switch last_chars[1] {
    case 'A'..'Z':
        strings.write_rune(&buf, last_chars[1]);
    }
 
    return strings.to_string(buf);
}
