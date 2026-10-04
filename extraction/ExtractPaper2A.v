From Coq Require Import Extraction ExtrOcamlBasic ExtrOcamlNatInt.
From GTC.Debt Require Import Certificates LineageCheck LineageL4 FiniteFibreCheck.
Extraction Language OCaml.
Extraction "paper2a_verified_core.ml" qualified4 check_L4 shared_ground
 check_L1 check_L3 undisclosed wf_defect fibre_check factor_eval.
