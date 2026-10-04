# Paper 2A mechanisation

The current decision core extends the historical handwritten implementation.
The preserved standalone and integration logs describe that earlier implementation;
they are not relabelled as checks of the new core.

## Proofs

- `theories/Debt/LineageL4.v`: `shared_ground_spec` reflects shared derived ground ancestry under declared parents; `check_L4_reflect` reflects disclosure; `qualified4_reflect` unconditionally reflects well-formedness and L1–L4. Qualification has no clearance or certificate-issuance implication. `L4_composes` and `strict_separation_composes` fix one graph, ground and disposition list.
- `theories/Debt/FiniteFibreCheck.v`: witness soundness and exhaustive absence-of-witness equivalence; factor evaluation reproduces every enumerated row; incomplete carriers never yield a factor; a global factor requires a genuinely complete enumeration. These proofs assume observational equality reflects actual equality. Empty carriers have a separate result.
- `theories/Debt/LineageComposition.v`: L1 composition, the exact middle-ancestry condition for L2 coverage, the two L3 witness-survival equivalences, and a common source sufficient for all three coordinate pairs.
- `examples/Paper2ALineage.v`: the exact raw-ground L2 and derived-ground L3 countermodels printed in Paper 2A, plus the six-node laundering pattern with undisclosed and open L4 dispositions.

No new axiom or admission is introduced. The new modules do not import the isolated classical factorisation file.

## Runtime connection and boundary

`extraction/ExtractPaper2A.v` generates `paper2a_verified_core.ml` and `.mli`.
The generated files are checked in so that the exactness Make checks still run
without first rebuilding the companion. After a clean Dune build,
`bash extraction/verify_paper2a_extraction.sh` re-extracts in scratch and requires
byte-for-byte agreement. `--update` explicitly regenerates the files.

The OCaml graph adapter assigns each declared string node a distinct nonnegative
integer. The decision flags and shared-ground tuple come from the extracted core;
handwritten diagnostics must agree or execution fails. The adapter and diagnostic
agreement check are tested rather than proved. Blank identifiers, text notes,
disposition-key validation, claim/scope binding and retention validation remain
handwritten. The finite wrapper uses actual structural equality on the typed tuples;
it deduplicates the proved raw factor table for display. That presentation step is
covered by independent tests, not a Coq theorem about the wrapper.

The original handwritten generic `admissibility.ml` remains for the tax and static
examples. Only the retained-value lineage fibre decision core is replaced here.
The kernel proofs concern the declared data, not source fidelity, actual coverage,
causal independence, custody or resolution of a defeater. Extraction, the OCaml
compiler/runtime, injective encoding and machine-integer bounds remain trusted.
No transport certificate or lineage-clearance judgement is issued.

## Reproduction

From the root, with Coq 8.18.0 and OCaml 4.14.1:

```sh
make -C legacy/exactness-2026 clean
dune build --root .
bash extraction/verify_paper2a_extraction.sh
coqchk -silent -R _build/default/legacy/exactness-2026 Exactness \
  -R _build/default/theories GTC -R _build/default/examples GTCExamples \
  GTC.Debt.LineageL4 GTC.Debt.FiniteFibreCheck \
  GTC.Debt.LineageComposition GTCExamples.Paper2ALineage
make -C legacy/exactness-2026 check
python3 legacy/exactness-2026/mutation_check.py
python3 legacy/exactness-2026/mutation_verified_core.py
```

The 18-mutant suite targets the wrapper and diagnostics. The new six-mutant suite
targets the generated code separately. Compiler errors are invalid mutants rather
than detections. The frozen six-node probe still tests its pinned handwritten
snapshot; it is not a test of the extracted replacement.

## Recorded outcome

The local build and verification records are under [mechanisation/](mechanisation/README.md).
The 26 selected new theorem/example identifiers are closed under the global
context. The named kernel check and extraction comparison pass, as do the
61/368,640/9,360 runtime tests, 18 wrapper/diagnostic mutants and six
generated-core mutants. Version 17 records this scope; older manuscript versions are removed from
the current tree. No new public release revision has been assigned.
