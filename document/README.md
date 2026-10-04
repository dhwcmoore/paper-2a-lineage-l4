# Copied Agreement — Paper 2A

This directory contains the current manuscript only:

- [Version 17 PDF](Paper_2A_Copied_Agreement_v17.pdf)
- [Version 17 LaTeX source](Paper_2A_Copied_Agreement_v17.tex)
- [Revision notes](REVISIONS.md)

The manuscript includes Coq reflection for L1–L4, proved finite fibre checks,
fixed-ground composition results and extracted OCaml decision cores. Runtime
wrappers remain tested rather than proved; no transport certificate is issued.
See [mechanisation scope and evidence](../paper2a-extension/MECHANISATION.md).

Build from the repository root with `make -C document`. Requires `latexmk`,
`pdflatex` and the LaTeX packages named in the source. The bibliography is
embedded in the source; no separate bibliography or journal class is required.
`make -C document clean` removes intermediate files and preserves the PDF.

Older manuscript versions and the historical calculus manuscript have been
removed from the current tree. Historical tracked content remains in Git history.
The intended venue is Journal of Logic and Computation; this article source
has not been reformatted to a journal class. A persistent public artefact
identifier should be added after deposit and retrieval verification.
