(* Timing the public wrappers. Synthetic inputs, not an operational workload. *)
open Lineage_audit

let graph total topology =
  if total < 6 then invalid_arg "At least six graph nodes required";
  let internal = List.init (total - 5) (fun i -> "s" ^ string_of_int i) in
  let derived = List.mapi (fun i n ->
    n, [if topology = "chain" && i > 0 then List.nth internal (i-1) else "a"]) internal in
  let last = List.hd (List.rev internal) in
  let shared = if topology = "chain" then internal else [last] in
  {claim_id="scaling"; scope_id="synthetic-complete";
   raw=["a";"h"]; claim_relevant=["h"];
   derived=derived @ ["d_A",[last]; "d_B",[last]; "g",[last;"h"]];
   d_a="d_A"; d_b="d_B"; ground="g";
   dispositions=List.map (fun n -> n, Justified "Synthetic disclosure") shared;
   ground_dispositions=List.map (fun n -> n, Open_defeater "Synthetic shared ancestry") shared;
   coverage_gaps=[]}

let retention l count kind =
  let shared = match check l with
    | Assessed a when a.lineage_qualified -> a.shared_ground
    | _ -> failwith "Invalid benchmark graph" in
  Lineage_fibre.{claim_id=l.claim_id; scope_id=l.scope_id; ground_node=l.ground;
    complete=true; rows=List.init count (fun i ->
      {record_id=string_of_int i;
       shared_values=List.map (fun n -> n,
         if kind="injective" then Integer i else Boolean true) shared;
       ground_value=(kind<>"early-witness" || i<>1)})}

let timed f =
  Gc.full_major ();
  let start=Unix.gettimeofday () in
  f ();
  Unix.gettimeofday () -. start

let () =
  let rows=ref 32 and nodes=ref 8 and repetitions=ref 5
  and topology=ref "fanout" and kind=ref "constant" in
  Arg.parse ["--rows",Arg.Set_int rows,"Carrier records";
    "--nodes",Arg.Set_int nodes,"Total raw and derived nodes";
    "--repetitions",Arg.Set_int repetitions,"Measured repetitions";
    "--topology",Arg.Set_string topology,"chain or fanout";
    "--kind",Arg.Set_string kind,"constant, injective or early-witness"]
    (fun _ -> invalid_arg "Unexpected argument") "scaling_benchmark";
  if !rows<2 || !repetitions<1 ||
     not (List.mem !topology ["chain";"fanout"]) ||
     not (List.mem !kind ["constant";"injective";"early-witness"]) then
    invalid_arg "Invalid benchmark arguments";
  let l=graph !nodes !topology in
  let r=retention l !rows !kind in
  let graph_check () = match check l with
    | Assessed a when a.lineage_qualified -> ()
    | _ -> failwith "Wrong graph verdict" in
  let fibre_check () = match Lineage_fibre.check l r with
    | Lineage_fibre.FactorsThroughShared table
        when (!kind="constant" && List.length table=1) ||
             (!kind="injective" && List.length table= !rows) -> ()
    | Lineage_fibre.FactorisationWitness (a,b)
        when !kind="early-witness" && a.record_id="0" && b.record_id="1" -> ()
    | _ -> failwith "Wrong fibre verdict" in
  graph_check (); fibre_check (); (* Untimed warm-up and verdict validation. *)
  print_endline "topology,kind,nodes,rows,repetition,graph_seconds,fibre_seconds";
  for repetition=1 to !repetitions do
    let graph_seconds=timed graph_check in
    let fibre_seconds=timed fibre_check in
    Printf.printf "%s,%s,%d,%d,%d,%.9f,%.9f\n%!"
      !topology !kind !nodes !rows repetition graph_seconds fibre_seconds
  done
