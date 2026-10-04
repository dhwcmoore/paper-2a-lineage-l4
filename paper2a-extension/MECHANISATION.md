# Paper 2A mechanisation

The current decision core extends the historical handwritten implementation.
The preserved standalone and integration logs describe that earlier implementation;
they are not relabelled as checks of the new core.

## Proofs

- `theories/Debt/LineageL4.v`: `shared_ground_spec` reflects shared derived ground ancestry under declared parents; `check_L4_reflect` reflects disclosure; `qualified4_reflect` unconditionally reflects well-formedness and L1–L4. Qualification has no clearance or certificate-issuance implication. `L4_composes` and `strict_separation_composes` fix one graph, ground and disposition list.
- `theories/Debt/FiniteFibreCheck.v`: witness soundness and exhaustive absence-of-witness equivalence; factor evaluation reproduces every enumerated row; incomplete carriers never yield a factor; a global factor requires a genuinely complete enumeration. These proofs assume observational equality reflects actual equality. Empty carriers have a separate result. Version 18 adds `injective_observation_no_witness` and `injective_complete_factor`: an injective carrier observation admits no witness, and its complete nonempty check returns a factor for every valuation.
- `theories/Debt/LineageComposition.v`: L1 composition, the exact middle-ancestry condition for L2 coverage, the two L3 witness-survival equivalences, and a common source sufficient for all three coordinate pairs.
- `examples/Paper2ALineage.v`: the exact raw-ground L2 and derived-ground L3 countermodels printed in Paper 2A, plus the six-node laundering pattern with undisclosed/open L4 dispositions and nine version 18 examples for shared raw input, an ignored independent source and actual-claim endpoint admissibility followed by grounding failure.

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

Version 18 explicitly requires ground-evaluator/source-use justification for
clearance and issuance. This remains an assurance judgement; neither a graph
pass, a factor result nor a justification string decides it. The handwritten
`boundary_controls.ml` supplies fourteen separately counted semantic controls.

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
coqc -R _build/default/legacy/exactness-2026 Exactness \
  -R _build/default/theories GTC -R _build/default/examples GTCExamples \
  paper2a-extension/v18/Assumptions.v
make -C legacy/exactness-2026 check
python3 legacy/exactness-2026/mutation_check.py
python3 legacy/exactness-2026/mutation_verified_core.py
```

The 18-mutant suite targets the wrapper and diagnostics. The new six-mutant suite
targets the generated code separately. Compiler errors are invalid mutants rather
than detections. The frozen six-node probe still tests its pinned handwritten
snapshot; it is not a test of the extracted replacement.

## Recorded outcome

The current independent replay records are under [v18/](v18/README.md).
All 37 selected theorem/example identifiers are closed under the global
context, comprising the original 26 and eleven additions. The named kernel check and extraction comparison pass, as do the
61/368,640/9,360 runtime tests, 18 wrapper/diagnostic mutants and six
generated-core mutants, with fourteen additional semantic boundary checks.
The extracted decision core is unchanged from version 17. Historical version 17
records remain under [mechanisation/](mechanisation/README.md), pinned at
`945c68e08f2d267d9a8a06ec77784a3ecc47afd9`. Its manifest is checked on that
snapshot, not on the changed version 18 tree. The root document build selects
version 18, retaining version 17 unchanged for comparison.
