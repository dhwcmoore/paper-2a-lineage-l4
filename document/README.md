# Copied Agreement — Paper 2A

The current manuscript is version 20:

- [Version 20 PDF](Paper_2A_Copied_Agreement_v20.pdf)
- [Version 20 LaTeX source](Paper_2A_Copied_Agreement_v20.tex)
- [Bibliography](Paper_2A_Copied_Agreement_v20.bib)
- [Complete technical supplement](Paper_2A_Copied_Agreement_v20_supplement.pdf)
- [Supplement source](Paper_2A_Copied_Agreement_v20_supplement.tex)
- [Source and reviewer packages](../release/README.md)
- [Revision notes](REVISIONS.md)

Version 20 uses the Springer SVJour3 double-column class for STTT, with numeric
square-bracket citations and a numbered bibliography. The main article has
28 pages; STTT's typical range is 10–20 pages, not a stated absolute cap. The
50-page complete supplement retains detailed proofs and verification tables.
Declarations record the author's no-funding/no-conflict statements and substantive
LLM assistance, especially LaTeX preparation. The corresponding email is
`dhwcmoore@gmail.com`. Its verification appendix
points to the [current manifest](../paper2a-extension/verification-v20/README.md).
Superseded manuscripts have been removed from the current tree. The
[version 18 test replay](../paper2a-extension/verification-v18/README.md) remains
as historical evidence. The release preserves the upstream version 18 proof/runtime additions and
includes a fresh merged-release verification;
see [mechanisation scope](../paper2a-extension/MECHANISATION.md).

Build with `make -C document`. Requires `latexmk`, `pdflatex`, `bibtex` and the
LaTeX packages named in the source. The Makefile tracks the separate bibliography
bundled `svjour3.cls`, `svglov3.clo` and `spbasic.bst`, and the measured scaling
figure and generated table/prose inputs. `make -C document` builds both PDFs.
`make -C document clean` removes intermediates and preserves the PDF.

The class and option files are unchanged Springer template files retrieved from
[the SVJour3 template mirror](https://github.com/DanySK/Template-LaTeX-Springer-svjour3).
The bibliography style is unchanged from
[the Springer template mirror](https://github.com/jflournoy/springer_latex_template/blob/main/spbasic.bst).
Their exact hashes are included in the current manifest.

The supporting version 20 artefact is archived under
`swh:1:rev:bea91080c022e4891731aa7a7bf60369269b25c7`;
[archive and release details](../release/README.md) explain its relationship to
the final manuscript and pinned components.
