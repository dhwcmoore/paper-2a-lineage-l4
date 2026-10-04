(* Handwritten finite audit of Paper 2A's declared lineage graph.
   A structural result is neither lineage clearance nor a transport certificate. *)

type disposition = Justified of string | Open_defeater of string

type lineage = {
  claim_id : string;
  scope_id : string;
  derived : (string * string list) list;
  raw : string list;
  claim_relevant : string list;
  d_a : string;
  d_b : string;
  ground : string;
  dispositions : (string * disposition) list;
  ground_dispositions : (string * disposition) list;
  coverage_gaps : string list;
}

type assessment = {
  l1 : bool; l2 : bool; l3 : bool; l4 : bool;
  coordinate_copy_reasons : string list;
  shared_coordinates : string list;
  undisclosed_coordinates : string list;
  shared_ground : string list;
  undisclosed_ground : string list;
  ground_only : string list;
  relevant_raw : string list;
  open_coordinate_defeaters : string list;
  open_ground_defeaters : string list;
  lineage_qualified : bool;
  declared_resolution_complete : bool;
  declared_coverage_closed : bool;
}

type verdict = MalformedLineage of string | Assessed of assessment

val well_formed : lineage -> string option
val ancestors : lineage -> string -> string list
val check : lineage -> verdict
