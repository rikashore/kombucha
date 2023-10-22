let field_counter = ref 0

let incr_field () =
  incr field_counter;
  "_" ^ string_of_int !field_counter

let reset_field () = field_counter := 0
let spaces n = String.make n ' '

let has_constructor_data (variant : Variant.t) =
  List.filter
    (fun c ->
      match c with
      | Variant.CData _ -> true
      | Variant.CConst _ -> false)
    variant.constructors
  |> List.length |> ( <> ) 0

let generate_enum (variant : Variant.t) : string =
  let buf = Buffer.create 32 in
  Buffer.add_string buf "local enum = require('enum')\n\n";
  Printf.bprintf buf "%s = enum.enum {\n" variant.name;
  List.iter
    (fun c ->
      match c with
      | Variant.CData _ -> assert false
      | Variant.CConst name ->
          Buffer.add_string buf (spaces 4);
          Printf.bprintf buf "\"%s\",\n" name)
    variant.constructors;
  Buffer.add_string buf "}\n";
  Buffer.contents buf

let generate_tag_function (variant_name : string) (ctor : Variant.constructor) :
    Buffer.t =
  let go name params =
    let buf = Buffer.create 32 in
    Printf.bprintf buf "function %s.%s(" variant_name name;
    reset_field ();
    List.map (fun _ -> incr_field ()) params
    |> String.concat ", " |> Buffer.add_string buf;
    Buffer.add_string buf ")\n";
    Printf.bprintf buf "%sinstance = {\n" (spaces 4);
    Printf.bprintf buf "%stag = \"%s\",\n" (spaces 8) name;
    reset_field ();
    List.iter
      (fun _ ->
        let field_num = incr_field () in
        Printf.bprintf buf "%s%s = %s,\n" (spaces 8) field_num field_num)
      params;
    Printf.bprintf buf "%s}\n" (spaces 4);
    Printf.bprintf buf "%sreturn setmetatable(instance, meta)\n" (spaces 4);
    Buffer.add_string buf "end\n";
    buf
  in

  match ctor with
  | Variant.CConst name -> go name []
  | Variant.CData (name, params) -> go name params

let generate_tagged_union (variant : Variant.t) : string =
  let buf = Buffer.create 32 in
  Printf.bprintf buf "%s = {}\n" variant.name;
  Printf.bprintf buf "local meta = { __index = %s }\n" variant.name;
  List.map (generate_tag_function variant.name) variant.constructors
  |> List.iter (Buffer.add_buffer buf);
  Printf.bprintf buf "return %s\n" variant.name;
  Buffer.contents buf

let generate_adt (variant : Variant.t) =
  match has_constructor_data variant with
  | false -> generate_enum variant
  | true -> generate_tagged_union variant
