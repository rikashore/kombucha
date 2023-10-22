open Adt2lua

let main () =
  let write_adt name generated =
    let cwd = Sys.getcwd () in
    let path = cwd ^ "/test/" ^ name ^ ".lua" in
    let out = open_out path in
    Printf.fprintf out "%s" generated;
    close_out out
  in

  let enums : Variant.t list =
    [
      {
        name = "option";
        constructors = [ CData ("some", [ "t" ]); CConst "none" ];
      };
      {
        name = "either";
        constructors = [ CData ("left", [ "t1" ]); CData ("right", [ "t2" ]) ];
      };
      {
        name = "foo";
        constructors = [ CConst "foo"; CConst "bar"; CConst "baz" ];
      };
    ]
  in
  List.map (fun (v : Variant.t) -> (v.name, Generate.generate_adt v)) enums
  |> List.iter (fun (n, g) -> write_adt n g)

let () = main ()
