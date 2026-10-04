(* Parents point against production: (child, parents) records parent -> child.
   This module checks a declared graph, not the truth of its production history. *)
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

let parents l n = match List.assoc_opt n l.derived with Some ps -> ps | None -> []

let rec duplicate = function
  | [] -> None
  | x :: rest -> if List.mem x rest then Some x else duplicate rest

let blank s = String.trim s = ""

let well_formed l =
  let names = List.map fst l.derived @ l.raw in
  let declared n = List.mem n names in
  let rec disclosures = function
    | [] -> None
    | (label, entries) :: rest ->
      (match duplicate (List.map fst entries) with
       | Some n -> Some (label ^ ": duplicate disposition for " ^ n)
       | None ->
         match List.find_opt (fun (n, _) -> not (List.mem_assoc n l.derived)) entries with
         | Some (n, _) -> Some (label ^ ": disposition node not derived: " ^ n)
         | None ->
           match List.find_opt (fun (_, d) -> match d with
             | Justified s | Open_defeater s -> blank s) entries with
           | Some (n, _) -> Some (label ^ ": empty disposition for " ^ n)
           | None -> disclosures rest) in
  if blank l.claim_id || blank l.scope_id then Some "empty claim or scope binding"
  else if List.exists blank names then Some "empty node name"
  else match duplicate names with
  | Some n -> Some ("duplicate node " ^ n)
  | None ->
    match List.find_opt (fun (_, ps) -> List.exists (fun p -> not (declared p)) ps) l.derived with
    | Some (n, _) -> Some ("undeclared parent of " ^ n)
    | None ->
      match List.find_opt (fun n -> not (List.mem_assoc n l.derived)) [l.d_a; l.d_b] with
      | Some n -> Some ("coordinate node not derived: " ^ n)
      | None -> if not (declared l.ground) then Some ("ground not declared: " ^ l.ground)
        else match List.find_opt (fun n -> not (List.mem n l.raw)) l.claim_relevant with
        | Some n -> Some ("claim-relevant input not raw: " ^ n)
        | None ->
          match disclosures [("L2", l.dispositions); ("L4", l.ground_dispositions)] with
          | Some _ as defect -> defect
          | None -> if List.exists blank l.coverage_gaps then Some "empty coverage-gap description"
            else
              let colour = Hashtbl.create 32 in
              let rec visit n = match Hashtbl.find_opt colour n with
                | Some `Grey -> Some n
                | Some `Black -> None
                | None ->
                  Hashtbl.replace colour n `Grey;
                  let defect = List.fold_left (fun acc p -> match acc with
                    | Some _ -> acc | None -> visit p) None (parents l n) in
                  Hashtbl.replace colour n `Black;
                  defect in
              match List.fold_left (fun acc n -> match acc with
                | Some _ -> acc | None -> visit n) None names with
              | Some n -> Some ("cycle through " ^ n)
              | None -> None

(* The visited set also makes this diagnostic helper terminate on cycles.
   [check] rejects cyclic records before using its ancestry sets. *)
let ancestors l n =
  let seen = Hashtbl.create 32 in
  let rec go = function
    | [] -> ()
    | x :: rest ->
      if Hashtbl.mem seen x then go rest
      else (Hashtbl.replace seen x (); go (parents l x @ rest)) in
  go (parents l n);
  List.sort compare (Hashtbl.fold (fun k () acc -> k :: acc) seen [])

let check l = match well_formed l with
  | Some reason -> MalformedLineage reason
  | None ->
    let a = ancestors l l.d_a and b = ancestors l l.d_b in
    let g = ancestors l l.ground in
    let coordinate_copy_reasons =
      List.filter_map (fun (present, reason) -> if present then Some reason else None)
        [l.ground = l.d_a, "GroundEqualsA";
         l.ground = l.d_b, "GroundEqualsB";
         List.mem l.d_a g, "GroundDescendsFromA";
         List.mem l.d_b g, "GroundDescendsFromB"] in
    let shared_coordinates = List.filter (fun n -> List.mem n b && not (List.mem n l.raw)) a in
    let undisclosed_coordinates = List.filter (fun n -> not (List.mem_assoc n l.dispositions)) shared_coordinates in
    let shared_ground = List.filter (fun n ->
      (List.mem n a || List.mem n b) && not (List.mem n l.raw)) g in
    let undisclosed_ground = List.filter (fun n -> not (List.mem_assoc n l.ground_dispositions)) shared_ground in
    let ground_only = List.filter (fun n ->
      not (List.mem n a || List.mem n b || n = l.d_a || n = l.d_b))
      (List.sort_uniq compare (l.ground :: g)) in
    let relevant_raw = List.filter (fun n -> List.mem n l.claim_relevant) ground_only in
    let open_nodes entries = List.filter_map (fun (n, d) -> match d with
      | Open_defeater _ -> Some n | Justified _ -> None) entries |> List.sort_uniq compare in
    let open_coordinate_defeaters = open_nodes l.dispositions in
    let open_ground_defeaters = open_nodes l.ground_dispositions in
    let l1 = coordinate_copy_reasons = [] and l2 = undisclosed_coordinates = [] in
    let l3 = relevant_raw <> [] and l4 = undisclosed_ground = [] in
    Assessed {
      l1; l2; l3; l4; coordinate_copy_reasons;
      shared_coordinates; undisclosed_coordinates; shared_ground; undisclosed_ground;
      ground_only; relevant_raw; open_coordinate_defeaters; open_ground_defeaters;
      lineage_qualified = l1 && l2 && l3 && l4;
      (* These report declarations only. A string marked Justified is not
         independently validated evidence and never issues a certificate. *)
      declared_resolution_complete = l2 && l4 && open_coordinate_defeaters = [] && open_ground_defeaters = [];
      declared_coverage_closed = l.coverage_gaps = [];
    }
