# Paper 2A revisions

## Version 18, 4 October 2026

Source: `Paper_2A_Copied_Agreement_v18.tex`; PDF: `Paper_2A_Copied_Agreement_v18.pdf`.
Version 17 is retained unchanged for comparison.

- Added the shared-raw-input countermodel: L1-L4, strict derived-ancestry separation and both grounding equations can pass while the evaluator ignores its independent source.
- Required ground-evaluator and source-use justification for clearance and issuance. This remains an assurance obligation, not a checker flag.
- Reserved separation terminology for empty shared derived ancestry; L4 establishes disclosure.
- Added the injective retained-tuple limit and two constructive Coq lemmas.
- Strengthened the endpoint non-implication and control to establish admissibility for the actual claim at both endpoints.
- Added nine finite Coq examples and fourteen separately counted executable boundary checks, with stable expected output.
- Relocated five implementation-history blocks to the appendix without deleting their content.
- Corrected dependence/independence wording, the operational-refinement claim and the multi-artefact verification-map caption.
- Corrected availability claims for a metric supplement absent from this release.
- Replayed the pinned baseline, version 17 extension and companion; verified the current additions and reconciled documentation with the evidence.

Validation: current Dune/Make builds, kernel checks and byte-identical extraction
pass. All 37 selected identifiers are closed under the global context. The original
61/368,640/9,360 tests and 18/6 mutation detections reproduce, alongside 14/14 new
boundary checks. The six-node probe and companion's pinned counts reproduce.
Full records are under `../paper2a-extension/v18/`; PDF validation is recorded there.

## Version 17, 4 October 2026

Source: `Paper_2A_Copied_Agreement_v17.tex`; PDF: `Paper_2A_Copied_Agreement_v17.pdf`.
Older manuscript versions have been removed from the public-facing tree.

- Added constructive Coq reflection for L1--L4 qualification and shared ground ancestry.
- Proved finite fibre witness/factor soundness, absence-of-witness equivalence, incomplete-carrier non-certification and global correctness under complete enumeration.
- Mechanised L1/L4 composition, strict separation, exact L2 coverage and L3 source-survival conditions, and the paper's printed finite countermodels.
- Integrated extracted decision cores into the runtime audit and retained-value fibre workflow. Input encoding, validation, diagnostics and factor-table presentation remain tested wrappers.
- Added a separately attributed six-mutant generated-core study; preserved historical handwritten evidence and the frozen six-node probe.

Validation: the Dune and runtime Make builds pass; all 26 selected new identifiers are closed under the global context; kernel checks and byte-identical regeneration pass. Independent test counts remain 61 edge checks, 368,640 graph comparisons and 9,360 fibre comparisons. The 18 wrapper/diagnostic mutants and six generated-core mutants are detected. The PDF builds to 46 pages without final LaTeX warnings. See `../paper2a-extension/MECHANISATION.md` and `../paper2a-extension/mechanisation/` for scope and records.
