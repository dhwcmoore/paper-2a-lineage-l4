# Copied Agreement — Paper 2A

The current manuscript is version 19:

- [Version 19 PDF](Paper_2A_Copied_Agreement_v19.pdf)
- [Version 19 LaTeX source](Paper_2A_Copied_Agreement_v19.tex)
- [Bibliography](Paper_2A_Copied_Agreement_v19.bib)
- [Revision notes](REVISIONS.md)

Version 19 uses the Springer SVJour3 class for STTT. Its verification appendix
points to the [current manifest](../paper2a-extension/verification-v19/README.md).
Superseded manuscripts have been removed from the current tree. The
[version 18 test replay](../paper2a-extension/verification-v18/README.md) remains
as historical evidence. The release preserves the upstream version 18 proof/runtime additions and
includes a fresh merged-release verification;
see [mechanisation scope](../paper2a-extension/MECHANISATION.md).

Build with `make -C document`. Requires `latexmk`, `pdflatex`, `bibtex` and the
LaTeX packages named in the source. The Makefile tracks the separate bibliography
and bundled `svjour3.cls`, `svglov3.clo` and `spbasic.bst` dependencies.
`make -C document clean` removes intermediates and preserves the PDF.

The class and option files are unchanged Springer template files retrieved from
[the SVJour3 template mirror](https://github.com/DanySK/Template-LaTeX-Springer-svjour3).
The bibliography style is unchanged from
[the Springer template mirror](https://github.com/jflournoy/springer_latex_template/blob/main/spbasic.bst).
Their exact hashes are included in the current manifest.

A persistent public artefact identifier remains to be assigned after deposit
and retrieval verification.
