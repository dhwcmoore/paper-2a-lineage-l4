# Copied Agreement, Paper 2A

The current manuscript is version 18. Version 17 is retained unchanged for comparison:

- [Version 18 PDF](Paper_2A_Copied_Agreement_v18.pdf)
- [Version 18 LaTeX source](Paper_2A_Copied_Agreement_v18.tex)
- [Revision notes](REVISIONS.md)

Version 18 adds shared raw input with an ignored independent source, an explicit
ground-evaluator justification obligation, the injective-tuple limit and a control
with actual-claim admissibility at both endpoints before grounding fails. Detailed
implementation history is relocated to the appendix without deleting its content.

The manuscript includes Coq reflection for L1–L4, proved finite fibre checks,
fixed-ground composition results and extracted OCaml decision cores. Runtime
wrappers remain tested rather than proved; no transport certificate is issued.
See [mechanisation scope and evidence](../paper2a-extension/MECHANISATION.md).

Build from the repository root with `make -C document`. Requires `latexmk`,
`pdflatex` and the LaTeX packages named in the source. The bibliography is
embedded in the source; no separate bibliography or journal class is required.
`make -C document clean` removes intermediate files and preserves the PDF.

Version 17 is retained unchanged for comparison; earlier calculus drafts remain
in Git history. The independently replayed current and pinned evidence is under
`../paper2a-extension/v18/`. To rebuild the historical version, use
`make -C document PAPER2A=Paper_2A_Copied_Agreement_v17`. No metric supplement
is included in this release.
The intended venue is Journal of Logic and Computation; this article source
has not been reformatted to a journal class. A persistent public artefact
identifier should be added after deposit and retrieval verification.
