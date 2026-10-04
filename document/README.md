# Copied Agreement — Paper 2A

The manuscript and supporting material:

- [Paper PDF](Paper_2A_Copied_Agreement_v20.pdf)
- [LaTeX source](Paper_2A_Copied_Agreement_v20.tex)
- [Archived paper and artefact (DOI)](https://doi.org/10.5281/zenodo.23143172)
- [Bibliography](Paper_2A_Copied_Agreement_v20.bib)
- [Complete technical supplement](Paper_2A_Copied_Agreement_v20_supplement.pdf)
- [Supplement source](Paper_2A_Copied_Agreement_v20_supplement.tex)
- [Source and reviewer packages](../release/README.md)

The manuscript uses the Springer SVJour3 double-column class for STTT, with numeric
square-bracket citations and a numbered bibliography. The main article has
28 pages; STTT's typical range is 10–20 pages, not a stated absolute cap. The
50-page complete supplement retains detailed proofs and verification tables.
Declarations record the author's no-funding/no-conflict statements and substantive
LLM assistance, especially LaTeX preparation. The corresponding email is
`dhwcmoore@gmail.com`. Its verification appendix
points to the [current manifest](../paper2a-extension/verification-v20/README.md).
See [mechanisation scope](../paper2a-extension/MECHANISATION.md) for the
proof and runtime assurance boundary.

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

The supporting artefact is archived under
`swh:1:rev:bea91080c022e4891731aa7a7bf60369269b25c7`;
[archive and release details](../release/README.md) explain its relationship to
the final manuscript and pinned components.
