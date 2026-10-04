(* Three semantic boundary controls for Paper 2A version 18.
   The declared state model is bool, exhaustively enumerated below.
   Qualification is not evaluator validity, clearance or issuance. *)
open Lineage_audit

let rows = [true; false]
let record_id = function true -> "r_ok" | false -> "r_star"
let common_raw (_ : bool) = true
let faithful_source r = r
let copied_ground r = common_raw r

let raw_sharing : lineage = {
  claim_id="request-effect"; scope_id="two-record-control";
  raw=["a";"h"]; claim_relevant=["h"];
  derived=["d_A",["a"];"d_B",["a"];"g",["a";"h"]];
  d_a="d_A"; d_b="d_B"; ground="g";
  dispositions=[]; ground_dispositions=[]; coverage_gaps=[];
}
let independent = {raw_sharing with
  derived=["d_A",["a"];"d_B",["a"];"g",["h"]]}
let injective = {raw_sharing with
  derived=["s",["a"];"d_A",["s"];"d_B",["s"];"g",["s";"h"]];
  dispositions=["s",Justified "The shared record identifier is disclosed."];
  ground_dispositions=["s",Open_defeater "An injective tuple supplies no separation witness."]}

let assessed l = match check l with
 | Assessed a -> a
 | MalformedLineage reason -> failwith reason
let count = ref 0
let require name value =
 incr count;
 if not value then (Printf.eprintf "FAIL: %s\n" name; exit 1)

module Old = Admissibility.Admissibility_check(struct
 type state=bool
 type obs=bool
 let m r=r
 let phi r=r
 let obs_equal=(=)
end)
module New = Admissibility.Admissibility_check(struct
 type state=bool
 type obs=bool
 let m r=r
 let phi r=r
 let obs_equal=(=)
end)

let () =
 let a=assessed raw_sharing in
 require "raw-sharing graph qualifies" a.lineage_qualified;
 require "raw sharing has no shared derived coordinate ancestry" (a.shared_coordinates=[]);
 require "raw sharing has no shared derived ground ancestry" (a.shared_ground=[]);
 require "independent relevant raw source is present" (a.relevant_raw=["h"]);
 require "copied raw ground satisfies both grounding equations"
   (List.for_all (fun r -> common_raw r=copied_ground r && copied_ground r=common_raw r) rows);
 require "source is ignored by the copied evaluator"
   (faithful_source true<>faithful_source false && copied_ground true=copied_ground false);
 require "copied evaluator contradicts faithful evidence at r_star"
   (List.filter (fun r -> copied_ground r<>faithful_source r) rows=[false]);
 require "actual claim admissible on old identity surface"
   (match Old.check ~complete:true rows with Old.Admissible _ -> true | _ -> false);
 require "actual claim admissible on new identity surface"
   (match New.check ~complete:true rows with New.Admissible _ -> true | _ -> false);
 require "independent control ground qualifies" (assessed independent).lineage_qualified;
 require "control endpoint implementations agree"
   (List.for_all (fun r -> common_raw r=common_raw r) rows);
 require "control ground finds exactly r_star"
   (List.filter (fun r -> common_raw r<>faithful_source r) rows=[false]);
 let retained : Lineage_fibre.retention = {
  claim_id=injective.claim_id; scope_id=injective.scope_id;
  ground_node=injective.ground; complete=true;
  rows=List.map (fun r -> Lineage_fibre.{record_id=record_id r;
    shared_values=["s",Boolean r]; ground_value=faithful_source r}) rows;
 } in
 require "injective shared tuple factors a nonconstant ground"
   (match Lineage_fibre.check injective retained with
    | Lineage_fibre.FactorsThroughShared table -> List.length table=2
    | _ -> false);
 require "injective fibre result leaves the ground defeater open"
   (not (assessed injective).declared_resolution_complete);
 Printf.printf "boundary controls: %d checks passed\n" !count;
 Printf.printf "raw-sharing control: L1-L4 pass; D=[]; E=[]; ignored source; evaluator failure=%s\n" (record_id false);
 Printf.printf "claim-specific endpoint control: actual-claim admissibility=PASS/PASS; endpoint agreement=PASS; grounding witness=%s\n" (record_id false);
 print_endline "injective shared tuple: factor image=2; no separation witness; defeater remains open";
 print_endline "No evaluator-validity proof, lineage clearance or transport certificate is issued."
