(* A supplied two-record audit, including the action prompted by its witness. *)
open Lineage_audit

let lineage = {
  claim_id = "request-effect"; scope_id = "walkthrough-two-records";
  raw = ["a"; "h"]; claim_relevant = ["h"];
  derived = ["s", ["a"]; "d_A", ["s"]; "d_B", ["s"]; "g", ["s"; "h"]];
  d_a = "d_A"; d_b = "d_B"; ground = "g";
  dispositions = ["s", Justified "Coordinate status is disclosed."];
  ground_dispositions = ["s", Open_defeater "Ground may copy coordinate status."];
  coverage_gaps = [];
}

let retention ground_values = Lineage_fibre.{
  claim_id = lineage.claim_id; scope_id = lineage.scope_id;
  ground_node = lineage.ground; complete = true;
  rows = List.map (fun (record_id, ground_value) ->
    {record_id; shared_values = ["s", Boolean true]; ground_value}) ground_values;
}

let () =
  print_endline "carrier: r_ok / r_star; retained s=true / true";
  print_endline "lineage: a->s; s->d_A,d_B,g; h->g; relevant=h";
  (match check lineage with
   | Assessed a when a.lineage_qualified && a.open_ground_defeaters = ["s"] ->
       print_endline "graph: L1-L4 pass; ground defeater s remains open"
   | _ -> failwith "Unexpected walkthrough graph diagnostic");
  (match Lineage_fibre.check lineage (retention ["r_ok", true; "r_star", true]) with
   | Lineage_fibre.FactorsThroughShared [_] ->
       print_endline "proposed copied ground: factor image=1; no separation witness"
   | _ -> failwith "Unexpected copied-ground diagnostic");
  print_endline "repair: evaluate the retained h trace, not the common s status";
  (match Lineage_fibre.check lineage (retention ["r_ok", true; "r_star", false]) with
   | Lineage_fibre.FactorisationWitness (a,b)
       when a.record_id = "r_ok" && b.record_id = "r_star" ->
       print_endline "trace ground: witness r_ok / r_star; same s; ground=true / false"
   | _ -> failwith "Unexpected trace-ground diagnostic");
  print_endline "next: validate evaluator, source fidelity and coverage; no clearance issued"
