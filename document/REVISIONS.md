# Paper 2A revisions

## Version 19 — 4 October 2026

Uploaded STTT manuscript with separate bibliography and Springer SVJour3 layout.
Updated the verification appendix to point to `verification-v19/SHA256SUMS`,
while attributing the unchanged build/test results to the retained version 18
replay. Rebuilt the PDF, updated the current manuscript links and build target,
and checked the new repository manifest. The publishing merge preserves the
upstream version 18 proof/runtime additions, removes superseded manuscripts,
and records fresh release checks (14 semantic controls and 46 selected
assumption reports).

## Version 18 — 4 October 2026

Source: `Paper_2A_Copied_Agreement_v18.tex`; PDF: `Paper_2A_Copied_Agreement_v18.pdf`.

- Added the raw shared-input countermodel and a scoped evaluator-adequacy obligation to lineage clearance.
- Explained why injective retained tuples cannot discriminate ground dependence and why narrowing the tuple changes the tested observation.
- Added an actual-claim endpoint control separating admissibility from implementation correctness and grounding.
- Reserved strict separation for empty shared derived ancestry; L4 is ancestry disclosure.
- Consolidated the verification appendix around the current decision core, clarified the claim/proof table, and corrected independence and pairing language.
- Added nine Coq review-control identifiers without changing the extracted decision core or executable test populations.

Validation: Dune, exactness Make, kernel checks and byte-identical extraction pass. All 26 selected core identifiers and nine review-control identifiers are closed under the global context. Runtime counts remain 61 edge checks, 368,640 graph comparisons and 9,360 fibre comparisons; all 18 wrapper and six generated-core mutants are detected. Supplementary probe and companion checks also reproduce. The PDF builds to 44 pages without final LaTeX warnings. Fresh logs and hashes are in `../paper2a-extension/verification-v18/`.

## Version 17 — 4 October 2026

Source: `Paper_2A_Copied_Agreement_v17.tex`; PDF: `Paper_2A_Copied_Agreement_v17.pdf`.
Older manuscript versions have been removed from the public-facing tree.

- Added constructive Coq reflection for L1--L4 qualification and shared ground ancestry.
- Proved finite fibre witness/factor soundness, absence-of-witness equivalence, incomplete-carrier non-certification and global correctness under complete enumeration.
- Mechanised L1/L4 composition, strict separation, exact L2 coverage and L3 source-survival conditions, and the paper's printed finite countermodels.
- Integrated extracted decision cores into the runtime audit and retained-value fibre workflow. Input encoding, validation, diagnostics and factor-table presentation remain tested wrappers.
- Added a separately attributed six-mutant generated-core study; preserved historical handwritten evidence and the frozen six-node probe.

Validation: the Dune and runtime Make builds pass; all 26 selected new identifiers are closed under the global context; kernel checks and byte-identical regeneration pass. Independent test counts remain 61 edge checks, 368,640 graph comparisons and 9,360 fibre comparisons. The 18 wrapper/diagnostic mutants and six generated-core mutants are detected. The PDF builds to 46 pages without final LaTeX warnings. See `../paper2a-extension/MECHANISATION.md` and `../paper2a-extension/mechanisation/` for scope and records.
