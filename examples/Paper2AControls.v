(** Version 18 review controls. These preserve, rather than strengthen,
    the assurance boundary of graph qualification and finite factorisation. *)
From Coq Require Import List Bool.
Import ListNotations.
From Exactness Require Import Admissibility.
From GTC.Debt Require Import Certificates LineageCheck LineageL4 FiniteFibreCheck.

Definition raw_shared_control : Lineage :=
 {| lin_derived := [(2,[0]);(3,[0]);(4,[0;1])];
    lin_raw := [0;1]; lin_relevant := [1];
    lin_dA := 2; lin_dB := 3; lin_ground := 4;
    lin_dispositions := [] |}.
Example raw_inputs_qualified : qualified4 raw_shared_control [] = true.
Proof. vm_compute. reflexivity. Qed.
Example raw_inputs_strictly_separated : shared_ground raw_shared_control = [].
Proof. vm_compute. reflexivity. Qed.
Definition actual_claim (r : bool) : bool := r.
Definition copied_answer (_ : bool) : bool := true.
Definition raw_coordinate_A (a h : bool) : bool := a.
Definition raw_coordinate_B (a h : bool) : bool := a.
Definition raw_ground (a h : bool) : bool := a.
Example raw_inputs_ignored_source :
 (forall a h, raw_coordinate_A a h = raw_ground a h /\
              raw_coordinate_B a h = raw_ground a h) /\
 raw_ground true false <> false.
Proof. split; [intros; split; reflexivity|discriminate]. Qed.
Theorem claim_identity_admissible :
 Admissible (fun r : bool => r) actual_claim.
Proof. exists actual_claim. reflexivity. Qed.
Example claim_control_outputs_agree :
 forall r, copied_answer r = copied_answer r.
Proof. reflexivity. Qed.
Example claim_control_grounding_failure :
 Admissible (fun r : bool => r) actual_claim /\
 Admissible (fun r : bool => r) actual_claim /\
 copied_answer false <> actual_claim false.
Proof. repeat split; try apply claim_identity_admissible; discriminate. Qed.

Theorem injective_fibre_constant {S O : Type} (obs : S -> O) (phi : S -> bool) :
 (forall x y, obs x = obs y -> x = y) -> FibreConstant obs phi.
Proof. intros HI x y E. apply HI in E. subst; reflexivity. Qed.
Theorem injective_no_witness {S O : Type} (obs : S -> O) (phi : S -> bool)
 (eqb : O -> O -> bool) (rows : list S) :
 (forall x y, eqb x y = true <-> x = y) ->
 (forall x y, obs x = obs y -> x = y) ->
 counterexample obs phi eqb rows = None.
Proof.
 intros HE HI. apply (proj2 (counterexample_none obs phi eqb HE rows)).
 intros x y _ _ E. apply HI in E; subst; reflexivity.
Qed.
Example injective_opposite_ground_factors :
 fibre_check (fun r : bool => r) negb Bool.eqb true [true;false] =
 FibreFactor [(true,false);(false,true)].
Proof. vm_compute. reflexivity. Qed.
