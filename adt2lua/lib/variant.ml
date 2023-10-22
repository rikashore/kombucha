(*
I don't handle validating the actual type associated with
each case, this microbrew is only concerned with the actual
generation of ADTs to Lua itself.

In a real world scenario I'd imagine a type checker would
guarantee all uses are correct before going down to Lua.
*)

type constructor =
  | CConst of string
  | CData of string * string list

type t = {
  name: string;
  constructors: constructor list;
}
