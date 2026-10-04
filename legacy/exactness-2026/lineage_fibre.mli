(* Exact comparison of retained values on the declared finite carrier.
   Its factor table and witness are extensional findings, not causal evidence. *)
type value = Boolean of bool | Integer of int | Text of string
type row = { record_id : string; shared_values : (string * value) list; ground_value : bool }
type retention = {
  claim_id : string;
  scope_id : string;
  ground_node : string;
  complete : bool;
  rows : row list;
}
type verdict =
  | MalformedRetention of string
  | MissingRetainedValues of string * string list
  | EmptyCarrier
  | NoWitnessFound
  | FactorsThroughShared of (value list * bool) list
  | FactorisationWitness of row * row

val check : Lineage_audit.lineage -> retention -> verdict
