# Paper 2A revisions

## Version 17 — 4 October 2026

Source: `Paper_2A_Copied_Agreement_v17.tex`; PDF: `Paper_2A_Copied_Agreement_v17.pdf`.
Older manuscript versions have been removed from the public-facing tree.

- Added constructive Coq reflection for L1--L4 qualification and shared ground ancestry.
- Proved finite fibre witness/factor soundness, absence-of-witness equivalence, incomplete-carrier non-certification and global correctness under complete enumeration.
- Mechanised L1/L4 composition, strict separation, exact L2 coverage and L3 source-survival conditions, and the paper's printed finite countermodels.
- Integrated extracted decision cores into the runtime audit and retained-value fibre workflow. Input encoding, validation, diagnostics and factor-table presentation remain tested wrappers.
- Added a separately attributed six-mutant generated-core study; preserved historical handwritten evidence and the frozen six-node probe.

Validation: the Dune and runtime Make builds pass; all 26 selected new identifiers are closed under the global context; kernel checks and byte-identical regeneration pass. Independent test counts remain 61 edge checks, 368,640 graph comparisons and 9,360 fibre comparisons. The 18 wrapper/diagnostic mutants and six generated-core mutants are detected. The PDF builds to 46 pages without final LaTeX warnings. See `../paper2a-extension/MECHANISATION.md` and `../paper2a-extension/mechanisation/` for scope and records.
