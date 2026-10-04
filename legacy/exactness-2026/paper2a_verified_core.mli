
val negb : bool -> bool

val fst : ('a1 * 'a2) -> 'a1

val snd : ('a1 * 'a2) -> 'a2

val length : 'a1 list -> int

val app : 'a1 list -> 'a1 list -> 'a1 list

val eqb : bool -> bool -> bool

module Nat :
 sig
 end

val in_dec : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> bool

val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list

val flat_map : ('a1 -> 'a2 list) -> 'a1 list -> 'a2 list

val existsb : ('a1 -> bool) -> 'a1 list -> bool

val forallb : ('a1 -> bool) -> 'a1 list -> bool

val filter : ('a1 -> bool) -> 'a1 list -> 'a1 list

val find : ('a1 -> bool) -> 'a1 list -> 'a1 option

val nodup : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list

type disposition =
| Justified of int
| OpenDefeater of int

type lineage = { lin_derived : (int * int list) list; lin_raw : int list;
                 lin_relevant : int list; lin_dA : int; lin_dB : int;
                 lin_ground : int; lin_dispositions : (int * disposition) list }

val lin_nodes : lineage -> int list

val lin_parents : lineage -> int -> int list

val mem : int -> int list -> bool

val nodupb : int list -> bool

val step : lineage -> int list -> int list

val iter : lineage -> int -> int list -> int list

val seed : lineage -> int -> int list

val ancestors : lineage -> int -> int list

type wfDefect =
| DuplicateNode
| UndeclaredParent
| DistinguishedNotDerived
| RelevantNotRaw
| Cycle of int

type lineageDefect =
| Malformed of wfDefect
| GroundEqualsA
| GroundEqualsB
| DescentFromA
| DescentFromB
| UndisclosedShared of int
| NoIndependentSource

val declared_parents_b : lineage -> bool

val distinguished_b : lineage -> bool

val relevant_b : lineage -> bool

val cycle_at : lineage -> int option

val wf_defect : lineage -> wfDefect option

val descends_a : lineage -> bool

val descends_b : lineage -> bool

val ground_eq_a : lineage -> bool

val ground_eq_b : lineage -> bool

val check_L1 : lineage -> bool

val disposed_b : lineage -> int -> bool

val undisclosed_pred : lineage -> int -> bool

val undisclosed : lineage -> int option

val source_pred : lineage -> int -> bool

val check_L3 : lineage -> bool

val lineage_defect : lineage -> lineageDefect option

val shared_ground : lineage -> int list

val check_L4 : lineage -> int list -> bool

val qualified4 : lineage -> int list -> bool

type ('s, 'o) fibreResult =
| FibreEmpty
| FibreWitness of 's * 's
| FibreOpen
| FibreFactor of ('o * bool) list

val pairs : 'a1 list -> ('a1 * 'a1) list

val bad :
  ('a1 -> 'a2) -> ('a1 -> bool) -> ('a2 -> 'a2 -> bool) -> ('a1 * 'a1) -> bool

val counterexample :
  ('a1 -> 'a2) -> ('a1 -> bool) -> ('a2 -> 'a2 -> bool) -> 'a1 list ->
  ('a1 * 'a1) option

val fibre_check :
  ('a1 -> 'a2) -> ('a1 -> bool) -> ('a2 -> 'a2 -> bool) -> bool -> 'a1 list
  -> ('a1, 'a2) fibreResult

val factor_eval : ('a1 -> 'a1 -> bool) -> ('a1 * bool) list -> 'a1 -> bool
