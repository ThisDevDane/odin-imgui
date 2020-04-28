package main;

import "core:encoding/json";

get_value_string :: proc(v: json.Value) -> string do return v.value.(json.String);