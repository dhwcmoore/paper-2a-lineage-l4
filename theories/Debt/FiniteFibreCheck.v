(** Extractable finite checker. Completeness is a caller declaration;
    positive correctness is on the enumerated carrier, with a separate
    theorem for genuinely complete enumeration. *)
From Coq Require Import List Bool.
Import ListNotations.

Inductive FibreResult (S O : Type) :=
| FibreEmpty : FibreResult S O
| FibreWitness : S -> S -> FibreResult S O
| FibreOpen : FibreResult S O
| FibreFactor : list (O * bool) -> FibreResult S O.
Arguments FibreEmpty {S O}.
Arguments FibreWitness {S O} _ _.
Arguments FibreOpen {S O}.
Arguments FibreFactor {S O} _.

Section Checker.
Context {S O : Type} (obs : S -> O) (phi : S -> bool) (eqb : O -> O -> bool).
Definition pairs (rows : list S) := flat_map (fun x => map (fun y => (x,y)) rows) rows.
Definition bad (p : S * S) := eqb (obs (fst p)) (obs (snd p)) &&
                              negb (Bool.eqb (phi (fst p)) (phi (snd p))).
Definition counterexample rows := find bad (pairs rows).
Definition fibre_check (complete : bool) (rows : list S) : FibreResult S O :=
 match rows with [] => FibreEmpty | _ =>
 match counterexample rows with
 | Some (x,y) => FibreWitness x y
 | None => if complete then FibreFactor (map (fun x => (obs x, phi x)) rows) else FibreOpen
 end end.
Definition factor_eval (table : list (O * bool)) (o : O) : bool :=
 existsb (fun p => eqb (fst p) o && snd p) table.
Hypothesis eqb_spec : forall x y, eqb x y = true <-> x = y.

Lemma pairs_spec rows x y : In (x,y) (pairs rows) <-> In x rows /\ In y rows.
Proof.
 unfold pairs. rewrite in_flat_map. split.
 - intros (z & Hz & Hin). apply in_map_iff in Hin as (w & E & Hw).
   inversion E; subst; auto.
 - intros [Hx Hy]. exists x. split; [exact Hx|apply in_map; exact Hy].
Qed.
Lemma bad_spec x y : bad (x,y) = true <-> obs x = obs y /\ phi x <> phi y.
Proof.
 unfold bad; cbn. rewrite andb_true_iff, eqb_spec, negb_true_iff.
 destruct (phi x), (phi y); cbn; intuition discriminate.
Qed.
Theorem counterexample_sound rows x y : counterexample rows = Some (x,y) ->
 In x rows /\ In y rows /\ obs x = obs y /\ phi x <> phi y.
Proof.
 intro H. apply find_some in H as [Hin Hb]. apply pairs_spec in Hin.
 apply bad_spec in Hb. tauto.
Qed.
Theorem counterexample_none rows : counterexample rows = None <->
 forall x y, In x rows -> In y rows -> obs x = obs y -> phi x = phi y.
Proof.
 split.
 - intros H x y Hx Hy E.
   pose proof (find_none _ _ H (x,y) (proj2 (pairs_spec rows x y) (conj Hx Hy))) as Hb.
   destruct (phi x) eqn:Ex, (phi y) eqn:Ey; try reflexivity;
   assert (bad (x,y) = true) by (apply bad_spec; split; [exact E|congruence]); congruence.
 - intros H. destruct (counterexample rows) as [[x y]|] eqn:E; [|reflexivity].
   apply counterexample_sound in E as [Hx [Hy [He Hne]]]. exfalso. apply Hne, H; assumption.
Qed.
(* An injective retained tuple cannot expose extensional dependence:
   every valuation is constant on its singleton fibres. This is a limit
   of the diagnostic, not evidence of production-path independence. *)
Theorem injective_observation_no_witness rows :
 (forall x y, In x rows -> In y rows -> obs x = obs y -> x = y) ->
 counterexample rows = None.
Proof.
 intro HI. apply (proj2 (counterexample_none rows)).
 intros x y Hx Hy E. rewrite (HI x y Hx Hy E). reflexivity.
Qed.
Theorem injective_complete_factor rows :
 rows <> [] ->
 (forall x y, In x rows -> In y rows -> obs x = obs y -> x = y) ->
 fibre_check true rows = FibreFactor (map (fun x => (obs x, phi x)) rows).
Proof.
 intros Hrows HI. unfold fibre_check.
 destruct rows as [|x xs]; [contradiction|].
 rewrite (injective_observation_no_witness (x::xs) HI). reflexivity.
Qed.
Theorem factor_table_sound rows : counterexample rows = None ->
 forall x, In x rows -> factor_eval (map (fun y => (obs y,phi y)) rows) (obs x) = phi x.
Proof.
 intros H x Hx. unfold factor_eval. destruct (phi x) eqn:Ex.
 - apply existsb_exists. exists (obs x,phi x). split.
   + apply in_map_iff. exists x. split; [reflexivity|exact Hx].
   + cbn. rewrite (proj2 (eqb_spec _ _) eq_refl), Ex. reflexivity.
 - apply not_true_iff_false. intro Hex. apply existsb_exists in Hex as (p & Hp & Hb).
   apply in_map_iff in Hp as (y & <- & Hy). cbn in Hb.
   apply andb_true_iff in Hb as [He Ey]. apply eqb_spec in He.
   pose proof (proj1 (counterexample_none rows) H y x Hy Hx He) as E.
   congruence.
Qed.
Theorem fibre_witness_sound complete rows x y : fibre_check complete rows = FibreWitness x y ->
 In x rows /\ In y rows /\ obs x = obs y /\ phi x <> phi y.
Proof.
 unfold fibre_check. destruct rows as [|r rs]; [discriminate|].
 destruct (counterexample (r::rs)) as [[a b]|] eqn:E.
 - intro H; inversion H; subst. apply counterexample_sound; exact E.
 - destruct complete; discriminate.
Qed.
Theorem fibre_factor_sound complete rows table : fibre_check complete rows = FibreFactor table ->
 complete = true /\ rows <> [] /\ forall x, In x rows -> factor_eval table (obs x) = phi x.
Proof.
 unfold fibre_check. destruct rows as [|r rs]; [discriminate|].
 destruct (counterexample (r::rs)) as [[a b]|] eqn:E; [discriminate|].
 destruct complete; [|discriminate]. intro H; inversion H; subst.
 split; [reflexivity|]. split; [discriminate|]. apply factor_table_sound; exact E.
Qed.
Theorem incomplete_never_factor rows table : fibre_check false rows <> FibreFactor table.
Proof.
 unfold fibre_check. destruct rows; [discriminate|].
 destruct (counterexample (s::rows)) as [[a b]|]; discriminate.
Qed.
Theorem complete_factor_global rows table :
 (forall x, In x rows) -> fibre_check true rows = FibreFactor table ->
 forall x, factor_eval table (obs x) = phi x.
Proof. intros HC H x. exact (proj2 (proj2 (fibre_factor_sound true rows table H)) x (HC x)). Qed.
End Checker.
Print Assumptions fibre_factor_sound.
Print Assumptions fibre_witness_sound.
