open Lineage_audit

(* Fixed topological order: two raw nodes followed by s, A, B and g.
   All 2^14 possible parent subsets in this order are enumerated.
   The reference closes an adjacency matrix, independently of the audit's
   ancestry traversal, and applies the manuscript's set formulae. *)
let names = [|"r0"; "r1"; "s"; "A"; "B"; "g"|]
let fail mask rel disp message =
  Printf.eprintf "FAIL: graph=%d relevance=%d disclosure=%d: %s\n" mask rel disp message;
  exit 1
let require mask rel disp message p = if not p then fail mask rel disp message
let cases = ref 0
let passes123 = ref 0
let passes1234 = ref 0
let canonical123 = ref 0
let canonical_l4_fail = ref 0
let l4_adds_unique_graphs = ref 0
let first_laundering_mask = ref None

let () =
  for mask = 0 to (1 lsl 14) - 1 do
    let reach = Array.make_matrix 6 6 false in
    let bit = ref 0 and derived = ref [] in
    for i = 2 to 5 do
      let ps = ref [] in
      for j = 0 to i - 1 do
        if mask land (1 lsl !bit) <> 0 then
          (reach.(i).(j) <- true; ps := names.(j) :: !ps);
        incr bit
      done;
      derived := (names.(i), List.rev !ps) :: !derived
    done;
    assert (!bit = 14);
    for k = 0 to 5 do for i = 0 to 5 do for j = 0 to 5 do
      reach.(i).(j) <- reach.(i).(j) || (reach.(i).(k) && reach.(k).(j))
    done done done;
    let as_set p = List.init 6 Fun.id |> List.filter p
      |> List.map (Array.get names) |> List.sort compare in
    let d = as_set (fun n -> n >= 2 && reach.(3).(n) && reach.(4).(n)) in
    let e = as_set (fun n -> n >= 2 && reach.(5).(n) && (reach.(3).(n) || reach.(4).(n))) in
    let g = as_set (fun n -> (reach.(5).(n) || n = 5)
      && not (reach.(3).(n) || reach.(4).(n) || n = 3 || n = 4)) in
    let contributed = ref false in
    for rel = 0 to 3 do for disp = 0 to 3 do
      let relevant = List.init 2 Fun.id |> List.filter (fun n -> rel land (1 lsl n) <> 0)
        |> List.map (Array.get names) in
      let all = List.init 4 (fun n -> names.(n + 2), Justified "Declared dependency.") in
      let l = {
        claim_id = "six-node-probe"; scope_id = "fixed-roles-ordered-dags";
        raw = ["r0"; "r1"]; derived = List.rev !derived; claim_relevant = relevant;
        d_a = "A"; d_b = "B"; ground = "g";
        dispositions = (if disp land 1 <> 0 then all else []);
        ground_dispositions = (if disp land 2 <> 0 then all else []);
        coverage_gaps = [];
      } in
      let a = match check l with
        | Assessed a -> a | MalformedLineage reason -> fail mask rel disp reason in
      let l1 = not reach.(5).(3) && not reach.(5).(4) in
      let l2 = d = [] || disp land 1 <> 0 in
      let l3 = List.exists (fun n -> List.mem n relevant) g in
      let l4 = e = [] || disp land 2 <> 0 in
      require mask rel disp "clause mismatch" ((a.l1,a.l2,a.l3,a.l4) = (l1,l2,l3,l4));
      require mask rel disp "set mismatch" (a.shared_coordinates = d && a.shared_ground = e && a.ground_only = g);
      require mask rel disp "qualification mismatch" (a.lineage_qualified = (l1 && l2 && l3 && l4));
      incr cases;
      if l1 && l2 && l3 then begin
        incr passes123;
        if l4 then incr passes1234 else contributed := true;
        if rel = 2 && disp = 1 then begin
          incr canonical123;
          if not l4 then begin
            incr canonical_l4_fail;
            if !first_laundering_mask = None then first_laundering_mask := Some mask
          end
        end
      end
    done done;
    if !contributed then incr l4_adds_unique_graphs
  done;
  Printf.printf
    "{\"graphs\":16384,\"assessments\":%d,\"reference_mismatches\":0,\"pass_L1_L2_L3\":%d,\"pass_L1_L2_L3_L4\":%d,\"pass_123_fail_4_assessments\":%d,\"pass_123_fail_4_unique_graphs\":%d,\"fixed_relevance_r1_and_L2_disclosed_graphs_pass_123\":%d,\"fixed_relevance_r1_and_L2_disclosed_graphs_pass_123_fail_4\":%d,\"first_laundering_graph_mask\":%d}\n"
    !cases !passes123 !passes1234 (!passes123 - !passes1234)
    !l4_adds_unique_graphs !canonical123 !canonical_l4_fail
    (Option.value ~default:(-1) !first_laundering_mask)
