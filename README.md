# Copied Agreement

**Lineage-Grounded Audits of Claim Preservation in Data Migration — Paper 2A**

[Read the paper (PDF)](document/Paper_2A_Copied_Agreement_v20.pdf)
· [Archived paper and artefact (DOI)](https://doi.org/10.5281/zenodo.23143172)
· [LaTeX source](document/Paper_2A_Copied_Agreement_v20.tex)
· [Complete technical supplement](document/Paper_2A_Copied_Agreement_v20_supplement.pdf)
· [Mechanisation scope](paper2a-extension/MECHANISATION.md)
· [Current manifest](paper2a-extension/verification-v20/README.md)

This repository contains the paper, Coq proofs, executable OCaml audit and
reproduction evidence. The audit separates whether an observation determines a
claim, whether migrated records agree, and whether that agreement is supported
by a ground whose declared production path can be independently assessed.
Agreement between endpoints can preserve a shared error.

The audit includes four lineage conditions (L1–L4), a shared-ancestry laundering
countermodel, a retained-value fibre test and fixed-ground composition results.
It includes a raw shared-input countermodel, the injective-tuple limitation and
a claim-specific endpoint control. Clearance requires a scoped justification
that the ground evaluator is adequate; authentic inputs alone do not supply it.
In the synthetic tax-migration example, endpoint comparison finds 48 disagreements
among 1,728 records. Comparison with delivery evidence finds 74 grounding
witnesses, including 26 records where both endpoints agree and both are wrong.
These are finite synthetic results, not estimates of production failure rates.

## What is proved and tested

Coq proves:

- Unconditional reflection between the L1–L4 qualification checker and its
  declared-graph specification.
- Soundness of finite fibre witnesses and factor tables; incomplete samples
  cannot yield a positive factor, and global correctness requires complete enumeration.
- Fixed-ground L1/L4 composition, the exact L2 coverage and L3 source-survival
  conditions, and the paper's finite composition countermodels.

The lineage and retained-value fibre decision cores are extracted to OCaml.
String encoding, retention binding and validation, diagnostic reporting and
factor-table presentation remain handwritten wrappers checked by tests.
The original generic handwritten factor checker remains in the tax/static examples.

| Verification | Recorded result |
|---|---|
| Coq modules and dependency closure | Kernel checks pass |
| Selected theorem/example identifiers | 46 closed under the global context |
| Executable semantic boundary controls | 14 pass |
| Generated OCaml core | Matches fresh extraction byte for byte |
| Edge and malformed-input checks | 61 pass |
| Independent graph-reference comparisons | 368,640 pass |
| Independent fibre-reference comparisons | 9,360 pass |
| Wrapper/diagnostic mutation suite | 18/18 compiling mutants detected |
| Generated-core mutation suite | 6/6 compiling mutants detected |

Structural disclosure can pass while a defeater remains open. These checks do
not authenticate source records, establish actual coverage or causal independence,
resolve declared defeaters, or issue a transport certificate. See the
[precise proof and runtime boundary](paper2a-extension/MECHANISATION.md).

The opening example presents the 48-versus-74 comparison beside the recurring
counterexample. An executable walkthrough, measured synthetic scaling and a
complete technical supplement support application and reproduction. The 28-page main article uses double-column
layout and numbered citations; the supplement retains all detailed proofs.
[Release packages and archival status](release/README.md) describe the editable
source package and complete reviewer bundle.

## Requirements

- Coq **8.18.0** and OCaml **4.14.1**, enforced by the exactness Makefile.
- Dune **3.8 or later** for the Coq project build.
- Python 3 and Make for executable verification.
- `latexmk`, `pdflatex` and `bibtex` with the packages named in the manuscript for its PDF.
- OCaml Findlib with the `unix` package for the optional companion regression.

## Reproduce the paper's checks

Run from the repository root. Build the Coq project before the Make checks:
Make writes Coq products into the source tree that otherwise conflict with Dune.

```sh
# Build the proofs and check the generated decision core.
make -C legacy/exactness-2026 clean
dune build --root .
bash extraction/verify_paper2a_extraction.sh

# Kernel-check the modules and their dependency closure.
coqchk -silent -R _build/default/legacy/exactness-2026 Exactness \
  -R _build/default/theories GTC -R _build/default/examples GTCExamples \
  GTC.Debt.LineageL4 GTC.Debt.FiniteFibreCheck \
  GTC.Debt.LineageComposition GTCExamples.Paper2ALineage GTCExamples.Paper2AControls

# Run examples, interface checks and independent-reference tests.
make -C legacy/exactness-2026 check
(cd legacy/exactness-2026 && coqchk Admissibility && \
 coqchk -Q . Exactness Exactness.GroundedSeam Exactness.SeamExtraction)

# Run the two separate mutation studies.
python3 legacy/exactness-2026/mutation_check.py
python3 legacy/exactness-2026/mutation_verified_core.py
```

A successful `coqchk -silent` run produces no output. Mutation reports are written
to ignored JSON files under `legacy/exactness-2026`. Run
`make -C legacy/exactness-2026 clean` before a subsequent Dune build.
To check the recorded source and evidence hashes from the root:

```sh
sha256sum -c paper2a-extension/verification-v20/SHA256SUMS
```

Build the current manuscript with `make -C document`.
[Document instructions](document/README.md) explain dependencies and cleanup.
## Apply the audit and reproduce scaling

The two-record walkthrough supplies a bound claim, graph and retained values,
then shows the diagnosis and trace-evaluation repair:

```sh
make -C legacy/exactness-2026 walkthrough
python3 experiments/run_scaling.py
```

The experiment runs 54 configurations with five measured calls each. It requires
OCaml, `/usr/bin/time` and Python; plots optionally require Matplotlib.
[Experiment scope and raw measurements](experiments/README.md) distinguish
synthetic wrapper costs from industrial throughput and integration cost.

## Supplementary checks

The [six-node L4 probe](paper2a-extension/Paper_2A_L4_Six_Node_Probe/README.md)
reproduces 262,144 assessments with zero reference mismatches. It tests its
fixed handwritten snapshot, separately from the extracted replacement and the
counts above:

```sh
bash paper2a-extension/Paper_2A_L4_Six_Node_Probe/run.sh
```

The Grounded Transport companion retains its own reflected L1–L3 checker,
regression against a fixed reference audit, and 17-mutant study. These are
separate verification claims. After a clean Dune build:

```sh
WORK=$(mktemp -d)
extraction/run_lineage_regression.sh "$WORK"
python3 extraction/mutation_matrix.py "$WORK"
```

See [extraction documentation](extraction/README.md) for library selection and
legacy-overlap restrictions. [STATUS.md](STATUS.md) records the companion's
verification scope and links to the evidence.

## Repository map

| Path | Content |
|---|---|
| `document/` | Main article, complete supplement, sources and build instructions |
| `theories/Debt/LineageL4.v` | L4 and L1–L4 reflection; fixed-ground L4 composition |
| `theories/Debt/FiniteFibreCheck.v` | Proved finite fibre decision procedure |
| `theories/Debt/LineageComposition.v` | Exact composition and ancestry conditions |
| `examples/Paper2ALineage.v` | Paper 2A's finite lineage countermodels |
| `examples/Paper2AControls.v` | Raw-source, injectivity and actual-claim review controls |
| `legacy/exactness-2026/` | Original Coq supplement, tax case, runtime wrappers and generated decision core |
| `extraction/` | Extraction, regeneration checks and companion regression |
| `paper2a-extension/verification-v20/` | Current checks, walkthrough, scaling evidence and manifest |
| `paper2a-extension/` | Verification records, reference implementations and provenance |
| `theories/`, `examples/` | Supporting Grounded Transport calculus and demonstrations |
| `paper/`, `milestones/` | Supporting theorem ledger, notation and kernel specifications |

## Provenance and release

This repository is an independent copy of
[grounded-transport-calculus](https://github.com/dhwcmoore/grounded-transport-calculus),
starting at `139791754787025ffaf3e37f78a869bbfa8d0ea5`, with the Paper 2A extension
and mechanisation added. The three baseline Coq sources are unchanged.
[Implementation and provenance](paper2a-extension/README.md) describe the
proofs, runtime wrappers, companion checks and reference implementations.

The manuscript is prepared for the International Journal on Software Tools for
Technology Transfer (STTT). The decision-core source is pinned at
[artefact commit `945c68e`](https://github.com/dhwcmoore/paper-2a-lineage-l4/tree/945c68e08f2d267d9a8a06ec77784a3ecc47afd9).
The paper, supplement and supporting artefact are archived on
[Zenodo (DOI: 10.5281/zenodo.23143172)](https://doi.org/10.5281/zenodo.23143172), pinned to commit
`0619413077a4cb85fcc67819ec776ce414085d29`.
The supporting source snapshot is also permanently archived as
[`swh:1:rev:bea91080c022e4891731aa7a7bf60369269b25c7`](https://archive.softwareheritage.org/swh:1:rev:bea91080c022e4891731aa7a7bf60369269b25c7/).
Its full archive visit and public file retrieval were verified.
[Release provenance](release/README.md) identifies the archived source and
explains how the current manifest binds the final manuscript and packages.
