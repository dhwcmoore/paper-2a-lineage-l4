(** Exact ancestry conditions of Paper 2A, over a fixed declared graph. *)
From Coq Require Import List.
From GTC.Debt Require Import Certificates LineageL4.
Definition D_at (g : Lineage) (a b n : nat) : Prop :=
 Ancestor g a n /\ Ancestor g b n /\ ~ In n (lin_raw g).
Definition G_at (g : Lineage) (ground a b n : nat) : Prop :=
 (Ancestor g ground n \/ n = ground) /\
 ~ Ancestor g a n /\ n <> a /\ ~ Ancestor g b n /\ n <> b.
Definition L1_pair (g : Lineage) (ground a b : nat) :=
 ground <> a /\ ground <> b /\ ~ Ancestor g ground a /\ ~ Ancestor g ground b.
Theorem L1_pair_composes g ground a b c :
 L1_pair g ground a b -> L1_pair g ground b c -> L1_pair g ground a c.
Proof. unfold L1_pair; tauto. Qed.
Theorem shared_ancestry_coverage_iff g a b c :
 (forall n, D_at g a c n -> D_at g a b n \/ D_at g b c n) <->
 (forall n, D_at g a c n -> Ancestor g b n).
Proof. unfold D_at; firstorder. Qed.
Theorem L2_outer_from_coverage g ds a b c :
 (forall n, D_at g a b n -> In n ds) ->
 (forall n, D_at g b c n -> In n ds) ->
 (forall n, D_at g a c n -> Ancestor g b n) ->
 forall n, D_at g a c n -> In n ds.
Proof. unfold D_at; firstorder. Qed.
Theorem source_survives_left_iff g ground a b c n :
 G_at g ground a b n ->
 (G_at g ground a c n <-> ~ Ancestor g c n /\ n <> c).
Proof. unfold G_at; tauto. Qed.
Theorem source_survives_right_iff g ground a b c n :
 G_at g ground b c n ->
 (G_at g ground a c n <-> ~ Ancestor g a n /\ n <> a).
Proof. unfold G_at; tauto. Qed.
Theorem common_source_all_pairs g ground a b c n :
 In n (lin_raw g) -> In n (lin_relevant g) ->
 (Ancestor g ground n \/ n = ground) ->
 ~ Ancestor g a n -> n <> a -> ~ Ancestor g b n -> n <> b ->
 ~ Ancestor g c n -> n <> c ->
 G_at g ground a b n /\ G_at g ground b c n /\ G_at g ground a c n.
Proof. unfold G_at; tauto. Qed.
Print Assumptions shared_ancestry_coverage_iff.
Print Assumptions source_survives_left_iff.

Definition L3_pair g ground a b : Prop :=
 exists n, In n (lin_raw g) /\ In n (lin_relevant g) /\ G_at g ground a b n.
Theorem common_source_L3_all_pairs g ground a b c n :
 In n (lin_raw g) -> In n (lin_relevant g) ->
 (Ancestor g ground n \/ n = ground) ->
 ~ Ancestor g a n -> n <> a -> ~ Ancestor g b n -> n <> b ->
 ~ Ancestor g c n -> n <> c ->
 L3_pair g ground a b /\ L3_pair g ground b c /\ L3_pair g ground a c.
Proof.
 intros Hr Hrel Hg Ha Hna Hb Hnb Hc Hnc.
 pose proof (common_source_all_pairs g ground a b c n Hr Hrel Hg Ha Hna Hb Hnb Hc Hnc) as [Hab [Hbc Hac]].
 repeat split; exists n; auto.
Qed.
