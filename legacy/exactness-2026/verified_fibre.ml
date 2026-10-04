(* The caller must provide actual equality; Lineage_fibre supplies structural
   equality on typed value tuples. String/retention validation stays outside
   the extracted decision core. Duplicate table keys are presentation only. *)
module Admissibility_check (O : Admissibility.OBSERVATION) = struct
  type verdict =
    | MalformedCertificate of string
    | Inadmissible of O.state * O.state
    | Admissible of (O.obs * bool) list
    | NoWitnessFound
  let check ~complete rows =
    match Paper2a_verified_core.fibre_check O.m O.phi O.obs_equal complete rows with
    | Paper2a_verified_core.FibreEmpty -> NoWitnessFound
    | Paper2a_verified_core.FibreWitness (a,b) -> Inadmissible (a,b)
    | Paper2a_verified_core.FibreOpen -> NoWitnessFound
    | Paper2a_verified_core.FibreFactor table ->
        Admissible (List.sort_uniq compare table)
end
