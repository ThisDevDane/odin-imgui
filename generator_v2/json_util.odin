package main;

import "core:encoding/json";

get_value_string :: proc(v: json.Value) -> string do return v.value.(json.String);

get_optional_string :: proc(obj: json.Object, key: string) -> string {
    v, ok := obj[key];
    return ok ? string(v.value.(json.String)) : "";
}

get_optional_int :: proc(obj: json.Object, key: string) -> int {
    v, ok := obj[key];
    return ok ? int(v.value.(json.Integer)) : 0;
}