open Lineage_audit

let base = {
  claim_id = "request-effect"; scope_id = "requests-ok-and-star";
  raw = ["a"; "h"]; claim_relevant = ["h"];
  derived = ["s", ["a"]; "d_A", ["s"]; "d_B", ["s"]; "g", ["h"]];
  d_a = "d_A"; d_b = "d_B"; ground = "g";
  dispositions = ["s", Justified "The common coordinate status is disclosed."];
  ground_dispositions = []; coverage_gaps = [];
}

let laundering = { base with
  derived = ["s", ["a"]; "d_A", ["s"]; "d_B", ["s"]; "g", ["s"; "h"]]
}

let disclosed = { laundering with
  ground_dispositions = ["s", Open_defeater "The ground may ignore the trace and reproduce the common status."]
}

let show_lineage label l = match check l with
  | MalformedLineage s -> Printf.printf "%s: MalformedLineage %s\n" label s
  | Assessed a ->
    Printf.printf "%s: L1=%b L2=%b L3=%b L4=%b qualified=%b open-coordinate=[%s] open-ground=[%s] coverage-gaps=%d\n"
      label a.l1 a.l2 a.l3 a.l4 a.lineage_qualified
      (String.concat "," a.open_coordinate_defeaters)
      (String.concat "," a.open_ground_defeaters) (List.length l.coverage_gaps)

let retention ~complete (l : lineage) values = Lineage_fibre.{
  claim_id = l.claim_id; scope_id = l.scope_id; ground_node = l.ground; complete;
  rows = List.map (fun (record_id, ground_value) ->
    {record_id; shared_values = ["s", Boolean true]; ground_value}) values
}

let show_fibre label l r = match Lineage_fibre.check l r with
  | FactorsThroughShared table ->
    Printf.printf "%s: factors through retained shared values; image=%d; no causal conclusion\n" label (List.length table)
  | FactorisationWitness (a, b) ->
    Printf.printf "%s: witness %s / %s; same shared values, ground=%b / %b; no causal conclusion\n"
      label a.record_id b.record_id a.ground_value b.ground_value
  | NoWitnessFound -> Printf.printf "%s: NoWitnessFound on incomplete carrier\n" label
  | EmptyCarrier -> Printf.printf "%s: EmptyCarrier\n" label
  | MissingRetainedValues (id, nodes) ->
    Printf.printf "%s: missing retained values at %s: %s\n" label id (String.concat "," nodes)
  | MalformedRetention s -> Printf.printf "%s: MalformedRetention %s\n" label s

let () =
  show_lineage "ground equals A" {base with ground = "d_A"};
  show_lineage "ground equals B" {base with ground = "d_B"};
  show_lineage "direct raw ground" {base with ground = "h"};
  show_lineage "laundering, undisclosed" laundering;
  show_lineage "laundering, disclosed open" disclosed;
  show_lineage "coverage gap retained" {base with coverage_gaps = ["one declared request has no lineage record"]};
  show_fibre "copied status" disclosed (retention ~complete:true disclosed ["r_ok", true; "r_star", true]);
  show_fibre "trace valuation" disclosed (retention ~complete:true disclosed ["r_ok", true; "r_star", false]);
  show_fibre "copied status, sample" disclosed (retention ~complete:false disclosed ["r_ok", true; "r_star", true]);
  show_fibre "trace witness, sample" disclosed (retention ~complete:false disclosed ["r_ok", true; "r_star", false]);
  print_endline "No lineage-clearance judgement or transport certificate is issued."
