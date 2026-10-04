
(** val negb : bool -> bool **)

let negb = function
| true -> false
| false -> true

(** val fst : ('a1 * 'a2) -> 'a1 **)

let fst = function
| (x, _) -> x

(** val snd : ('a1 * 'a2) -> 'a2 **)

let snd = function
| (_, y) -> y

(** val length : 'a1 list -> int **)

let rec length = function
| [] -> 0
| _ :: l' -> Stdlib.Int.succ (length l')

(** val app : 'a1 list -> 'a1 list -> 'a1 list **)

let rec app l m =
  match l with
  | [] -> m
  | a :: l1 -> a :: (app l1 m)

(** val eqb : bool -> bool -> bool **)

let eqb b1 b2 =
  if b1 then b2 else if b2 then false else true

module Nat =
 struct
 end

(** val in_dec : ('a1 -> 'a1 -> bool) -> 'a1 -> 'a1 list -> bool **)

let rec in_dec h a = function
| [] -> false
| y :: l0 -> let s = h y a in if s then true else in_dec h a l0

(** val map : ('a1 -> 'a2) -> 'a1 list -> 'a2 list **)

let rec map f = function
| [] -> []
| a :: t -> (f a) :: (map f t)

(** val flat_map : ('a1 -> 'a2 list) -> 'a1 list -> 'a2 list **)

let rec flat_map f = function
| [] -> []
| x :: t -> app (f x) (flat_map f t)

(** val existsb : ('a1 -> bool) -> 'a1 list -> bool **)

let rec existsb f = function
| [] -> false
| a :: l0 -> (||) (f a) (existsb f l0)

(** val forallb : ('a1 -> bool) -> 'a1 list -> bool **)

let rec forallb f = function
| [] -> true
| a :: l0 -> (&&) (f a) (forallb f l0)

(** val filter : ('a1 -> bool) -> 'a1 list -> 'a1 list **)

let rec filter f = function
| [] -> []
| x :: l0 -> if f x then x :: (filter f l0) else filter f l0

(** val find : ('a1 -> bool) -> 'a1 list -> 'a1 option **)

let rec find f = function
| [] -> None
| x :: tl -> if f x then Some x else find f tl

(** val nodup : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list **)

let rec nodup decA = function
| [] -> []
| x :: xs -> if in_dec decA x xs then nodup decA xs else x :: (nodup decA xs)

type disposition =
| Justified of int
| OpenDefeater of int

type lineage = { lin_derived : (int * int list) list; lin_raw : int list;
                 lin_relevant : int list; lin_dA : int; lin_dB : int;
                 lin_ground : int; lin_dispositions : (int * disposition) list }

(** val lin_nodes : lineage -> int list **)

let lin_nodes g =
  app (map fst g.lin_derived) g.lin_raw

(** val lin_parents : lineage -> int -> int list **)

let lin_parents g n =
  match find (fun e -> (=) (fst e) n) g.lin_derived with
  | Some e -> snd e
  | None -> []

(** val mem : int -> int list -> bool **)

let mem x l =
  existsb ((=) x) l

(** val nodupb : int list -> bool **)

let rec nodupb = function
| [] -> true
| x :: t -> (&&) (negb (mem x t)) (nodupb t)

(** val step : lineage -> int list -> int list **)

let step g l =
  nodup (=) (app l (flat_map (lin_parents g) l))

(** val iter : lineage -> int -> int list -> int list **)

let rec iter g k l =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> l)
    (fun k' -> step g (iter g k' l))
    k

(** val seed : lineage -> int -> int list **)

let seed g n =
  nodup (=) (lin_parents g n)

(** val ancestors : lineage -> int -> int list **)

let ancestors g n =
  iter g (length (lin_nodes g)) (seed g n)

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

(** val declared_parents_b : lineage -> bool **)

let declared_parents_b g =
  forallb (fun e -> forallb (fun p -> mem p (lin_nodes g)) (snd e))
    g.lin_derived

(** val distinguished_b : lineage -> bool **)

let distinguished_b g =
  (&&)
    ((&&) (mem g.lin_dA (map fst g.lin_derived))
      (mem g.lin_dB (map fst g.lin_derived))) (mem g.lin_ground (lin_nodes g))

(** val relevant_b : lineage -> bool **)

let relevant_b g =
  forallb (fun n -> mem n g.lin_raw) g.lin_relevant

(** val cycle_at : lineage -> int option **)

let cycle_at g =
  find (fun n -> mem n (ancestors g n)) (lin_nodes g)

(** val wf_defect : lineage -> wfDefect option **)

let wf_defect g =
  if nodupb (lin_nodes g)
  then if declared_parents_b g
       then if distinguished_b g
            then if relevant_b g
                 then (match cycle_at g with
                       | Some n -> Some (Cycle n)
                       | None -> None)
                 else Some RelevantNotRaw
            else Some DistinguishedNotDerived
       else Some UndeclaredParent
  else Some DuplicateNode

(** val descends_a : lineage -> bool **)

let descends_a g =
  mem g.lin_dA (ancestors g g.lin_ground)

(** val descends_b : lineage -> bool **)

let descends_b g =
  mem g.lin_dB (ancestors g g.lin_ground)

(** val ground_eq_a : lineage -> bool **)

let ground_eq_a g =
  (=) g.lin_ground g.lin_dA

(** val ground_eq_b : lineage -> bool **)

let ground_eq_b g =
  (=) g.lin_ground g.lin_dB

(** val check_L1 : lineage -> bool **)

let check_L1 g =
  (&&)
    ((&&) ((&&) (negb (ground_eq_a g)) (negb (ground_eq_b g)))
      (negb (descends_a g))) (negb (descends_b g))

(** val disposed_b : lineage -> int -> bool **)

let disposed_b g n =
  existsb (fun e -> (=) (fst e) n) g.lin_dispositions

(** val undisclosed_pred : lineage -> int -> bool **)

let undisclosed_pred g n =
  (&&) ((&&) (mem n (ancestors g g.lin_dB)) (negb (mem n g.lin_raw)))
    (negb (disposed_b g n))

(** val undisclosed : lineage -> int option **)

let undisclosed g =
  find (undisclosed_pred g) (ancestors g g.lin_dA)

(** val source_pred : lineage -> int -> bool **)

let source_pred g n =
  (&&)
    ((&&)
      ((&&)
        ((&&) ((&&) (mem n g.lin_raw) (mem n g.lin_relevant))
          (negb (mem n (ancestors g g.lin_dA))))
        (negb (mem n (ancestors g g.lin_dB)))) (negb ((=) n g.lin_dA)))
    (negb ((=) n g.lin_dB))

(** val check_L3 : lineage -> bool **)

let check_L3 g =
  existsb (source_pred g) (g.lin_ground :: (ancestors g g.lin_ground))

(** val lineage_defect : lineage -> lineageDefect option **)

let lineage_defect g =
  match wf_defect g with
  | Some d -> Some (Malformed d)
  | None ->
    if ground_eq_a g
    then Some GroundEqualsA
    else if ground_eq_b g
         then Some GroundEqualsB
         else if descends_a g
              then Some DescentFromA
              else if descends_b g
                   then Some DescentFromB
                   else (match undisclosed g with
                         | Some n -> Some (UndisclosedShared n)
                         | None ->
                           if check_L3 g
                           then None
                           else Some NoIndependentSource)

(** val shared_ground : lineage -> int list **)

let shared_ground g =
  filter (fun n ->
    (&&) ((||) (mem n (ancestors g g.lin_dA)) (mem n (ancestors g g.lin_dB)))
      (negb (mem n g.lin_raw))) (ancestors g g.lin_ground)

(** val check_L4 : lineage -> int list -> bool **)

let check_L4 g ds =
  forallb (fun n -> mem n ds) (shared_ground g)

(** val qualified4 : lineage -> int list -> bool **)

let qualified4 g ds =
  match lineage_defect g with
  | Some _ -> false
  | None -> check_L4 g ds

type ('s, 'o) fibreResult =
| FibreEmpty
| FibreWitness of 's * 's
| FibreOpen
| FibreFactor of ('o * bool) list

(** val pairs : 'a1 list -> ('a1 * 'a1) list **)

let pairs rows =
  flat_map (fun x -> map (fun y -> (x, y)) rows) rows

(** val bad :
    ('a1 -> 'a2) -> ('a1 -> bool) -> ('a2 -> 'a2 -> bool) -> ('a1 * 'a1) ->
    bool **)

let bad obs phi eqb0 p =
  (&&) (eqb0 (obs (fst p)) (obs (snd p)))
    (negb (eqb (phi (fst p)) (phi (snd p))))

(** val counterexample :
    ('a1 -> 'a2) -> ('a1 -> bool) -> ('a2 -> 'a2 -> bool) -> 'a1 list ->
    ('a1 * 'a1) option **)

let counterexample obs phi eqb0 rows =
  find (bad obs phi eqb0) (pairs rows)

(** val fibre_check :
    ('a1 -> 'a2) -> ('a1 -> bool) -> ('a2 -> 'a2 -> bool) -> bool -> 'a1 list
    -> ('a1, 'a2) fibreResult **)

let fibre_check obs phi eqb0 complete rows = match rows with
| [] -> FibreEmpty
| _ :: _ ->
  (match counterexample obs phi eqb0 rows with
   | Some p -> let (x, y) = p in FibreWitness (x, y)
   | None ->
     if complete
     then FibreFactor (map (fun x -> ((obs x), (phi x))) rows)
     else FibreOpen)

(** val factor_eval :
    ('a1 -> 'a1 -> bool) -> ('a1 * bool) list -> 'a1 -> bool **)

let factor_eval eqb0 table o =
  existsb (fun p -> (&&) (eqb0 (fst p) o) (snd p)) table
