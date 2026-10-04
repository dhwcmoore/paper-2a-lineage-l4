(** Paper 2A's L4 disclosure, separately from clearance and issuance.
    Note identifiers and disposition content remain declared external evidence. *)
From Coq Require Import List Bool Arith.
Import ListNotations.
From GTC.Debt Require Import Certificates LineageCheck.

Definition SharedGround (g : Lineage) (ground a b n : nat) : Prop :=
  Ancestor g ground n /\ (Ancestor g a n \/ Ancestor g b n) /\ ~ In n (lin_raw g).
Definition L4_at (g : Lineage) (ds : list nat) (ground a b : nat) : Prop :=
  forall n, SharedGround g ground a b n -> In n ds.
Definition L4 (g : Lineage) (ds : list nat) : Prop :=
  L4_at g ds (lin_ground g) (lin_dA g) (lin_dB g).
Definition shared_ground (g : Lineage) : list nat :=
  filter (fun n => (mem n (ancestors g (lin_dA g)) ||
                    mem n (ancestors g (lin_dB g))) && negb (mem n (lin_raw g)))
         (ancestors g (lin_ground g)).
Definition check_L4 (g : Lineage) (ds : list nat) : bool :=
  forallb (fun n => mem n ds) (shared_ground g).
Definition qualified4 (g : Lineage) (ds : list nat) : bool :=
  match lineage_defect g with Some _ => false | None => check_L4 g ds end.
Definition Qualified4 (g : Lineage) (ds : list nat) : Prop := LineagePasses g /\ L4 g ds.

Lemma mem_false n xs : mem n xs = false <-> ~ In n xs.
Proof.
 split; intros H.
 - intro Hin. apply mem_iff in Hin. congruence.
 - destruct (mem n xs) eqn:E; [exfalso; apply H, mem_iff; exact E|reflexivity].
Qed.
Lemma shared_ground_spec g (HD : DeclParents g) n :
 In n (shared_ground g) <-> SharedGround g (lin_ground g) (lin_dA g) (lin_dB g) n.
Proof.
 unfold shared_ground, SharedGround. rewrite filter_In, andb_true_iff,
   orb_true_iff, negb_true_iff, mem_false.
 rewrite (ancestors_iff g HD), !mem_iff, !(ancestors_iff g HD).
 tauto.
Qed.
Theorem check_L4_reflect g ds (HD : DeclParents g) : check_L4 g ds = true <-> L4 g ds.
Proof.
 unfold check_L4, L4, L4_at. rewrite forallb_forall.
 split; intros H n Hn.
 - apply mem_iff, H. apply (proj2 (shared_ground_spec g HD n)); exact Hn.
 - apply mem_iff, H. apply (proj1 (shared_ground_spec g HD n)); exact Hn.
Qed.
Theorem qualified4_reflect g ds : qualified4 g ds = true <-> Qualified4 g ds.
Proof.
 unfold qualified4, Qualified4. destruct (lineage_defect g) eqn:E.
 - split; [discriminate|intros [Hp _]; apply lineage_defect_none_iff in Hp; congruence].
 - pose proof (proj1 (lineage_defect_none_iff g) E) as Hp.
   assert (HD : DeclParents g).
   { apply decl_parents_of_entries. exact (proj1 (proj2 (proj1 Hp))). }
   rewrite (check_L4_reflect g ds HD). tauto.
Qed.
Theorem L4_composes g ds ground a b c :
 L4_at g ds ground a b -> L4_at g ds ground b c -> L4_at g ds ground a c.
Proof. unfold L4_at, SharedGround. firstorder. Qed.
Theorem strict_separation_composes g ground a b c :
 (forall n, ~ SharedGround g ground a b n) ->
 (forall n, ~ SharedGround g ground b c n) ->
 forall n, ~ SharedGround g ground a c n.
Proof. unfold SharedGround. firstorder. Qed.

Print Assumptions qualified4_reflect.
Print Assumptions L4_composes.
