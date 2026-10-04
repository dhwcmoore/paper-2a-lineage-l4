open Lineage_audit
open Lineage_fibre

let fail name = Printf.eprintf "FAIL: %s\n" name; exit 1
let require name b = if not b then fail name
let edge_count = ref 0
let edge name b = incr edge_count; require name b
let assessed (l : lineage) = match Lineage_audit.check l with
  | Assessed a -> a
  | MalformedLineage reason -> fail ("unexpected malformed graph: " ^ reason)
let malformed l = match Lineage_audit.check l with MalformedLineage _ -> true | Assessed _ -> false

let base : lineage = {
  claim_id = "claim"; scope_id = "scope";
  raw = ["a"; "h"]; claim_relevant = ["h"];
  derived = ["s", ["a"]; "A", ["s"]; "B", ["s"]; "g", ["h"]];
  d_a = "A"; d_b = "B"; ground = "g";
  dispositions = ["s", Justified "Coordinate sharing is disclosed."];
  ground_dispositions = []; coverage_gaps = [];
}

let launder = {base with derived =
  ["s", ["a"]; "A", ["s"]; "B", ["s"]; "g", ["s"; "h"]]}
let open_launder = {launder with ground_dispositions =
  ["s", Open_defeater "The common status may determine the ground."]}

let binding (l : lineage) rows complete : retention = {
  claim_id = l.claim_id; scope_id = l.scope_id;
  ground_node = l.ground; complete; rows
}
let row id values ground_value : row = {record_id=id; shared_values=values; ground_value}
let is_factors = function FactorsThroughShared _ -> true | _ -> false
let is_witness = function FactorisationWitness _ -> true | _ -> false
let is_no_witness = function NoWitnessFound -> true | _ -> false
let is_bad_retention = function MalformedRetention _ -> true | _ -> false

let test_edges () =
  let a = assessed base in
  edge "separate ground qualifies" a.lineage_qualified;
  edge "separate ground has empty E" (a.shared_ground = []);
  edge "L3 includes the derived ground in G" (a.ground_only = ["g"; "h"]);
  let aa = assessed {base with ground="A"} in
  edge "identity with A fails L1" (not aa.l1);
  edge "identity with A is located" (List.mem "GroundEqualsA" aa.coordinate_copy_reasons);
  let ab = assessed {base with ground="B"} in
  edge "identity with B fails L1" (not ab.l1);
  edge "identity with B is located" (List.mem "GroundEqualsB" ab.coordinate_copy_reasons);
  let descend = assessed {base with derived=
    ["s",["a"]; "A",["s"]; "B",["s"]; "g",["A";"h"]]} in
  edge "coordinate descent fails L1" (not descend.l1 && descend.l3);
  edge "coordinate descent is located" (List.mem "GroundDescendsFromA" descend.coordinate_copy_reasons);
  let raw = assessed {base with ground="h"} in
  edge "directly raw ground qualifies" raw.lineage_qualified;
  edge "directly raw ground itself witnesses L3" (raw.relevant_raw=["h"] && raw.ground_only=["h"]);
  edge "unmarked raw ground fails L3" (not (assessed {base with ground="h"; claim_relevant=[]}).l3);
  edge "raw ground inherited by coordinates fails L3"
    (not (assessed {base with ground="a"; claim_relevant=["a"]}).l3);
  let copied = assessed launder in
  edge "laundering passes L1-L3" (copied.l1 && copied.l2 && copied.l3);
  edge "laundering exposes shared derived ground ancestry" (copied.shared_ground=["s"]);
  edge "L2 justification does not substitute for L4 disclosure" (not copied.l4 && not copied.lineage_qualified);
  edge "undisclosed L4 concern cannot be marked resolved" (not copied.declared_resolution_complete);
  let disclosed = assessed open_launder in
  edge "open L4 defeater satisfies disclosure" (disclosed.l4 && disclosed.lineage_qualified);
  edge "open L4 defeater is unresolved" (not disclosed.declared_resolution_complete && disclosed.open_ground_defeaters=["s"]);
  let open_l2 = assessed {base with dispositions=["s",Open_defeater "Shared coordinate dependence remains open."]} in
  edge "open L2 defeater satisfies disclosure" (open_l2.l2 && open_l2.lineage_qualified);
  edge "open L2 defeater remains unresolved" (not open_l2.declared_resolution_complete);
  let l2_missing = assessed {open_launder with dispositions=[]} in
  edge "L4 disclosure does not substitute for L2" (not l2_missing.l2 && l2_missing.l4);
  edge "undisclosed L2 concern cannot be marked resolved" (not l2_missing.declared_resolution_complete);
  let one_coordinate = assessed {base with dispositions=[]; derived=
    ["s",["a"]; "A",["s"]; "B",["a"]; "g",["s";"h"]]} in
  edge "L4 includes ancestry shared with only one coordinate"
    (one_coordinate.shared_coordinates=[] && one_coordinate.shared_ground=["s"] && not one_coordinate.l4);
  let shared_raw = assessed {base with derived=
    ["s",["a"]; "A",["s"]; "B",["s"]; "g",["a";"h"]]} in
  edge "L4 exempts shared raw inputs" (shared_raw.shared_ground=[] && shared_raw.l4);
  let gap = assessed {base with coverage_gaps=["unrecorded request"]} in
  edge "coverage gap does not alter structural qualification" gap.lineage_qualified;
  edge "coverage gap remains recorded" (not gap.declared_coverage_closed);
  edge "undeclared ground is malformed" (malformed {base with ground="missing"});
  edge "raw coordinate is malformed" (malformed {base with d_a="a"});
  edge "raw/derived overlap is malformed" (malformed {base with raw="g"::base.raw});
  edge "undeclared parent is malformed" (malformed {base with derived=("x",["absent"])::base.derived});
  let cycle = {base with derived=["s",["A"];"A",["s"];"B",["s"];"g",["h"]]} in
  edge "cycle is malformed" (malformed cycle);
  ignore (Lineage_audit.ancestors cycle "s");
  edge "invalid relevance marking is malformed" (malformed {base with claim_relevant=["s"]});
  edge "duplicate L2 disposition is malformed" (malformed {base with dispositions=base.dispositions@base.dispositions});
  edge "duplicate L4 disposition is malformed" (malformed {open_launder with ground_dispositions=open_launder.ground_dispositions@open_launder.ground_dispositions});
  edge "raw disposition node is malformed" (malformed {base with ground_dispositions=["h",Justified "bad"]});
  edge "empty justification is malformed" (malformed {base with dispositions=["s",Justified " "]});
  edge "empty defeater reason is malformed" (malformed {open_launder with ground_dispositions=["s",Open_defeater ""]});
  edge "empty claim binding is malformed" (malformed {base with claim_id=""});
  edge "empty scope binding is malformed" (malformed {base with scope_id=""});
  edge "empty coverage-gap description is malformed" (malformed {base with coverage_gaps=[" "]});
  let reordered = {base with raw=List.rev base.raw; derived=List.rev base.derived} in
  edge "graph declaration order is immaterial" (assessed reordered = assessed base);
  let rename n = "renamed_" ^ n in
  let renamed = {base with
    raw=List.map rename base.raw; claim_relevant=List.map rename base.claim_relevant;
    derived=List.map (fun (n,ps)->rename n,List.map rename ps) base.derived;
    d_a=rename base.d_a; d_b=rename base.d_b; ground=rename base.ground;
    dispositions=List.map (fun (n,d)->rename n,d) base.dispositions} in
  edge "node renaming preserves clause statuses"
    (let b=assessed renamed in (a.l1,a.l2,a.l3,a.l4)=(b.l1,b.l2,b.l3,b.l4));
  let same_values = [row "ok" ["s",Boolean true] true; row "star" ["s",Boolean true] true] in
  let different_ground = [row "ok" ["s",Boolean true] true; row "star" ["s",Boolean true] false] in
  let retained = binding open_launder same_values true in
  edge "copied-status values factor through shared values" (is_factors (Lineage_fibre.check open_launder retained));
  edge "trace distinguishes the same shared values" (is_witness (Lineage_fibre.check open_launder (binding open_launder different_ground true)));
  edge "clean incomplete carrier does not affirm factorisation" (is_no_witness (Lineage_fibre.check open_launder {retained with complete=false}));
  edge "incomplete carrier still permits a refuting witness" (is_witness (Lineage_fibre.check open_launder (binding open_launder different_ground false)));
  edge "fibre test does not close the open defeater" (not (assessed open_launder).declared_resolution_complete);
  edge "wrong claim retention is rejected" (is_bad_retention (Lineage_fibre.check open_launder {retained with claim_id="other"}));
  edge "wrong scope retention is rejected" (is_bad_retention (Lineage_fibre.check open_launder {retained with scope_id="other"}));
  edge "wrong ground retention is rejected" (is_bad_retention (Lineage_fibre.check open_launder {retained with ground_node="A"}));
  edge "duplicate record IDs are rejected" (is_bad_retention (Lineage_fibre.check open_launder {retained with rows=same_values@same_values}));
  edge "duplicate retained nodes are rejected" (is_bad_retention (Lineage_fibre.check open_launder (binding open_launder [row "ok" ["s",Boolean true;"s",Boolean false] true] true)));
  edge "unexpected retained node is rejected" (is_bad_retention (Lineage_fibre.check open_launder (binding open_launder [row "ok" ["s",Boolean true;"a",Boolean true] true] true)));
  edge "missing retained shared value stays unresolved"
    (match Lineage_fibre.check open_launder (binding open_launder [row "ok" [] true] true) with
     | MissingRetainedValues ("ok",["s"]) -> true | _ -> false);
  edge "empty carrier is reported"
    (match Lineage_fibre.check open_launder (binding open_launder [] true) with EmptyCarrier -> true | _ -> false);
  edge "empty record ID is rejected" (is_bad_retention (Lineage_fibre.check open_launder (binding open_launder [row "" ["s",Boolean true] true] true)));
  edge "malformed lineage prevents a fibre assessment" (is_bad_retention (Lineage_fibre.check cycle (binding cycle [] true)));
  edge "value constructors prevent text/integer collisions"
    (is_factors (Lineage_fibre.check open_launder (binding open_launder [row "x" ["s",Integer 1] true;row "y" ["s",Text "1"] false] true)));
  edge "empty shared tuple uses its actual constant observation"
    (is_witness (Lineage_fibre.check base (binding base [row "x" [] true;row "y" [] false] true)));
  edge "constant ground factors through an empty shared tuple"
    (is_factors (Lineage_fibre.check base (binding base [row "x" [] true;row "y" [] true] true)))

(* An independent reference: close an adjacency matrix with Floyd-Warshall,
   then evaluate the displayed set formulae directly. It does not call the
   audit's ancestor or well-formedness functions. All 512 labelled DAGs have
   two raw nodes followed by three derived nodes. Every coordinate pair,
   ground, raw-relevance marking and L2/L4 disclosure combination is tested. *)
let test_graphs () =
  let names = [|"r0";"r1";"n0";"n1";"n2"|] in
  let count = ref 0 in
  for mask = 0 to 511 do
    let reach = Array.make_matrix 5 5 false in
    let bit = ref 0 in
    let derived = ref [] in
    for i = 2 to 4 do
      let ps = ref [] in
      for j = 0 to i-1 do
        if mask land (1 lsl !bit) <> 0 then (reach.(i).(j)<-true; ps:=names.(j)::!ps);
        incr bit
      done;
      derived := (names.(i), List.rev !ps)::!derived
    done;
    for k=0 to 4 do for i=0 to 4 do for j=0 to 4 do
      reach.(i).(j) <- reach.(i).(j) || (reach.(i).(k) && reach.(k).(j))
    done done done;
    let as_set p = List.init 5 Fun.id |> List.filter p |> List.map (Array.get names) |> List.sort compare in
    for ia=2 to 4 do for ib=2 to 4 do for ig=0 to 4 do
      let shared_a = as_set (fun n -> n>=2 && reach.(ia).(n) && reach.(ib).(n)) in
      let shared_g = as_set (fun n -> n>=2 && reach.(ig).(n) && (reach.(ia).(n)||reach.(ib).(n))) in
      let g_only = as_set (fun n -> (reach.(ig).(n)||n=ig) && not (reach.(ia).(n)||reach.(ib).(n)||n=ia||n=ib)) in
      for relmask=0 to 3 do for disclosure=0 to 3 do
        let relevant = List.init 2 Fun.id |> List.filter (fun n -> relmask land (1 lsl n)<>0) |> List.map (Array.get names) in
        let all_disclosed = List.init 3 (fun n -> names.(n+2),Justified "Declared test dependency.") in
        let l = {base with raw=["r0";"r1"];derived=List.rev !derived;claim_relevant=relevant;
          d_a=names.(ia);d_b=names.(ib);ground=names.(ig);
          dispositions=(if disclosure land 1<>0 then all_disclosed else []);
          ground_dispositions=(if disclosure land 2<>0 then all_disclosed else [])} in
        let a = assessed l in
        let l1 = ig<>ia && ig<>ib && not reach.(ig).(ia) && not reach.(ig).(ib) in
        let l2 = shared_a=[] || disclosure land 1<>0 in
        let l3 = List.exists (fun n -> List.mem n relevant) g_only in
        let l4 = shared_g=[] || disclosure land 2<>0 in
        require "exhaustive graph clause reference" ((a.l1,a.l2,a.l3,a.l4)=(l1,l2,l3,l4));
        require "exhaustive graph sets reference"
          (a.shared_coordinates=shared_a && a.shared_ground=shared_g && a.ground_only=g_only);
        require "exhaustive structural qualification" (a.lineage_qualified=(l1&&l2&&l3&&l4));
        incr count
      done done
    done done done
  done;
  !count

(* Independently enumerate all two-bit observations and Boolean ground
   values on carriers of one to four records. Compare with the direct
   pairwise definition and validate each returned factor or witness. *)
let test_fibres () =
  let l = {base with derived=["s",["a"];"t",["a"];"A",["s";"t"];"B",["s";"t"];"g",["s";"t";"h"]];
    dispositions=["s",Justified "test";"t",Justified "test"];
    ground_dispositions=["s",Open_defeater "test";"t",Open_defeater "test"]} in
  let count = ref 0 in
  for n=1 to 4 do
    for mask=0 to (1 lsl (3*n))-1 do
      let observations = Array.init n (fun i -> (mask lsr (3*i)) land 3) in
      let truths = Array.init n (fun i -> mask land (1 lsl (3*i+2)) <> 0) in
      let rows = List.init n (fun i ->
        let values = ["s",Boolean (observations.(i) land 1<>0);"t",Boolean (observations.(i) land 2<>0)] in
        row (string_of_int i) (if i mod 2=0 then values else List.rev values) truths.(i)) in
      let mixed = ref false in
      for i=0 to n-1 do for j=i+1 to n-1 do
        if observations.(i)=observations.(j) && truths.(i)<>truths.(j) then mixed:=true
      done done;
      List.iter (fun complete ->
        let result = Lineage_fibre.check l (binding l rows complete) in
        (match result with
         | FactorisationWitness (a,b) ->
           require "exhaustive fibre witness expected" !mixed;
           let i=int_of_string a.record_id and j=int_of_string b.record_id in
           require "returned fibre witness bound to carrier"
             (List.mem a rows && List.mem b rows && observations.(i)=observations.(j) && truths.(i)<>truths.(j));
         | FactorsThroughShared table ->
           require "exhaustive fibre positive requires complete unmixed carrier" (complete && not !mixed);
           let expected_image = Array.to_list observations |> List.sort_uniq compare |> List.length in
           require "factor table has exactly the observed image" (List.length table=expected_image);
           List.iter (fun row ->
             let key=[List.assoc "s" row.shared_values;List.assoc "t" row.shared_values] in
             require "returned factor reproduces every retained value" (List.assoc_opt key table=Some row.ground_value)) rows
         | NoWitnessFound -> require "exhaustive incomplete clean carrier" (not complete && not !mixed)
         | _ -> fail "unexpected exhaustive fibre verdict");
        require "mixed fibres cannot return clean verdict" (not !mixed || is_witness result);
        incr count
      ) [false;true]
    done
  done;
  !count

let () =
  test_edges ();
  let graphs = test_graphs () in
  let fibres = test_fibres () in
  Printf.printf "Edge and malformed-input checks: %d PASS\n" !edge_count;
  Printf.printf "Independent graph-reference comparisons: %d PASS\n" graphs;
  Printf.printf "Independent fibre-reference comparisons: %d PASS\n" fibres;
  print_endline "All lineage extension checks passed."
