open Lineage_audit

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

let rec duplicate = function
  | [] -> None
  | x :: rest -> if List.mem x rest then Some x else duplicate rest

let check (l : lineage) (r : retention) =
  match Lineage_audit.check l with
  | MalformedLineage reason -> MalformedRetention ("lineage: " ^ reason)
  | Assessed assessment ->
    if r.claim_id <> l.claim_id || r.scope_id <> l.scope_id || r.ground_node <> l.ground then
      MalformedRetention "retention does not match the declared claim, scope and ground"
    else match duplicate (List.map (fun row -> row.record_id) r.rows) with
    | Some id -> MalformedRetention ("duplicate carrier record " ^ id)
    | None ->
      let shared = assessment.shared_ground in
      let rec validate = function
        | [] -> None
        | row :: rest ->
          if String.trim row.record_id = "" then Some (MalformedRetention "empty carrier record identifier")
          else match duplicate (List.map fst row.shared_values) with
          | Some n -> Some (MalformedRetention ("duplicate retained node " ^ n ^ " at " ^ row.record_id))
          | None ->
            match List.find_opt (fun (n, _) -> not (List.mem n shared)) row.shared_values with
            | Some (n, _) -> Some (MalformedRetention ("unexpected retained node " ^ n ^ " at " ^ row.record_id))
            | None ->
              let missing = List.filter (fun n -> not (List.mem_assoc n row.shared_values)) shared in
              if missing <> [] then Some (MissingRetainedValues (row.record_id, missing))
              else validate rest in
      match validate r.rows with
      | Some defect -> defect
      | None -> if r.rows = [] then EmptyCarrier
        else
          let module F = Admissibility.Admissibility_check (struct
            type state = row
            type obs = value list
            let m row = List.map (fun n -> List.assoc n row.shared_values) shared
            let phi row = row.ground_value
            let obs_equal = ( = )
          end) in
          match F.check ~complete:r.complete r.rows with
          | F.MalformedCertificate reason -> MalformedRetention reason
          | F.Inadmissible (a, b) -> FactorisationWitness (a, b)
          | F.Admissible table -> FactorsThroughShared table
          | F.NoWitnessFound -> NoWitnessFound
