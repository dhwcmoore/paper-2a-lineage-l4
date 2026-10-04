# Paper 2A version 18: verification and changes

Proof and executable sources: [`1e9de34b63281d019502f746f57ede348b62ca5e`](https://github.com/dhwcmoore/paper-2a-lineage-l4/tree/1e9de34b63281d019502f746f57ede348b62ca5e). The final manuscript and release-manifest metadata follows this source revision.

All reported build and test counts checked in this replay reproduce. Version 18
adds the recommended semantic qualifications and countermodels. Version 17 is
preserved unchanged.

## Builds and proof checks

The original exactness baseline (`51284d`), version 17 mechanisation (`945c68e`)
and Grounded Transport companion (`e1e14a2`) were checked in separate checkouts.
The version 18 tree was then checked with the same version-gated toolchain:
Coq 8.18.0, OCaml 4.14.1, Dune 3.14.0 and Findlib 1.9.6.

The baseline Make build, extension Dune and Make builds, kernel checks and fresh
extraction checks pass. All 26 version 17 selected identifiers are closed under
the global context; all 37 current selected identifiers are closed, including
the eleven additions. No new axiom or admission was introduced. The companion's
123 selected identifiers are closed and all 36 named nonclassical modules pass
kernel checking. Its separately isolated classical factorisation retains its
two declared classical axioms.

| Check | Reproduced result |
|---|---:|
| Edge and malformed-input checks | 61/61 |
| Independent graph-reference comparisons | 368,640/368,640 |
| Independent fibre-reference comparisons | 9,360/9,360 |
| Wrapper/diagnostic mutants, all compiling | 18/18 detected |
| Generated-core mutants, all compiling | 6/6 detected |
| New version 18 semantic boundary controls | 14/14 |
| Frozen six-node graphs | 16,384 |
| Frozen six-node assessments | 262,144; zero mismatches |
| Six-node L1-L3 passing assessments | 4,724 |
| Six-node L1-L4 passing assessments | 4,157 |
| L1-L3 passing, L4 failing assessments | 567, over 186 graphs |
| Companion fixed comparisons | 5/5 |
| Companion random comparisons within legacy overlap | 1,921/1,921; 1,079 skipped |
| Companion shallow stratified comparisons | 3,300/3,300 |
| Companion deep stratified comparisons | 1,800/1,800 |
| Companion edge checks | 6/6 |
| Companion mutants detected by the union of suites | 17/17 |

The tax carrier remains 1,728 records: 48 seam witnesses, 74 grounding witnesses,
26 agreeing but ungrounded records and 72 witnesses after the recorded repair.
The baseline Coq sources and extracted decision core are unchanged. Counts from
the frozen handwritten probe, companion and current extracted extension are
reported separately.

## Changes implemented

1. Added a five-node shared-raw-input countermodel. L1-L4, empty shared derived
   ancestry and the grounding equations all pass while the proposed evaluator
   ignores its independent source and disagrees with the claim at one record.
2. Added `GroundEvaluatorJustified` to clearance and certificate issuance. This
   requires a justified claim evaluator and claim-bearing use of independent
   evidence. It is an external assurance obligation, not a checker flag.
3. Distinguished structural disclosure under L4 from strict separation, which
   requires empty shared derived ancestry.
4. Stated the injective retained-tuple limit: every Boolean valuation factors
   through an injective complete observation, so no fibre witness can separate
   it. Added two constructive lemmas for this limit.
5. Strengthened the two-record endpoint control so the actual claim is
   admissible at both endpoints. The constant outputs still agree and grounding
   still fails at the second record. Added nine finite Coq examples and fourteen
   separately counted executable controls.
6. Moved five implementation-history blocks into an appendix while retaining
   their content and attribution. Corrected independence wording, the refinement
   claim and the verification-map caption.
7. Updated the default manuscript build, repository overview, mechanisation
   record, status, revision history and reproduction instructions for version 18.
   Made the absence of the previously mentioned metric supplement explicit.

These additions leave graph qualification conditional on declared lineage.
Source fidelity, coverage, evaluator justification and actual independence remain
assurance obligations. The executable controls issue no transport certificate.

## Evidence and release checks

The suite directories contain command logs and JSON exit-code records.
`results.json` contains the reconciled counts; `SHA256SUMS` binds the current
source and evidence. The original version 17 manifest was checked at its pinned
snapshot. Environment-only failures from the relocated toolchain are preserved
separately from the successful runs.

The version 18 PDF is compiled with `latexmk` and checked for unresolved
references, citations and overflow. Every page is rendered for visual review;
the new countermodel, clearance/issuance definitions, endpoint control and
verification appendix receive detailed checks. `release-checks.json` records
the final page count, build diagnostics, source preservation and documentation
link checks.

No metric supplement is present in either the checked tree or its recorded
history. No new archive DOI or publication status is claimed.
