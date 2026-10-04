(** The actual two composition countermodels printed in Paper 2A. *)
From Coq Require Import List.
Import ListNotations.
From GTC.Debt Require Import Certificates LineageCheck LineageL4.
Definition paper_disclosure a b : Lineage :=
 {| lin_derived := [(3,[0]);(4,[3]);(5,[1]);(6,[3])];
    lin_raw := [0;1;2]; lin_relevant := [2]; lin_ground := 2;
    lin_dA := a; lin_dB := b; lin_dispositions := [] |}.
Example disclosure_local01 : qualified4 (paper_disclosure 4 5) [] = true.
Proof. vm_compute. reflexivity. Qed.
Example disclosure_local12 : qualified4 (paper_disclosure 5 6) [] = true.
Proof. vm_compute. reflexivity. Qed.
Example disclosure_outer_L2_failure : lineage_defect (paper_disclosure 4 6) = Some (UndisclosedShared 3).
Proof. vm_compute. reflexivity. Qed.
Definition paper_source a b : Lineage :=
 {| lin_derived := [(3,[1]);(4,[2]);(5,[0]);(6,[0;1])];
    lin_raw := [0;1;2]; lin_relevant := [0;1;2]; lin_ground := 6;
    lin_dA := a; lin_dB := b; lin_dispositions := [] |}.
Example source_local01 : qualified4 (paper_source 3 4) [] = true.
Proof. vm_compute. reflexivity. Qed.
Example source_local12 : qualified4 (paper_source 4 5) [] = true.
Proof. vm_compute. reflexivity. Qed.
Example source_outer_L3_failure : lineage_defect (paper_source 3 5) = Some NoIndependentSource.
Proof. vm_compute. reflexivity. Qed.
Definition laundering : Lineage :=
 {| lin_derived := [(2,[0]);(3,[2]);(4,[2]);(5,[2;1])];
    lin_raw := [0;1]; lin_relevant := [1]; lin_ground := 5;
    lin_dA := 3; lin_dB := 4; lin_dispositions := [(2,OpenDefeater 0)] |}.
Example laundering_only_L2 : qualified4 laundering [] = false.
Proof. vm_compute. reflexivity. Qed.
Example laundering_open_L4 : qualified4 laundering [2] = true.
Proof. vm_compute. reflexivity. Qed.
Print Assumptions source_outer_L3_failure.
Print Assumptions laundering_open_L4.
