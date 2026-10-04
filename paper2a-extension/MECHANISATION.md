# Paper 2A mechanisation

Coq proves the declared-graph and finite-carrier results below. Runtime adapters
and diagnostic presentation are checked separately by executable tests.

## Proofs

- `theories/Debt/LineageL4.v`: `shared_ground_spec` reflects shared derived ground ancestry under declared parents; `check_L4_reflect` reflects disclosure; `qualified4_reflect` unconditionally reflects well-formedness and L1–L4. Qualification has no clearance or certificate-issuance implication. `L4_composes` and `strict_separation_composes` fix one graph, ground and disposition list.
- `theories/Debt/FiniteFibreCheck.v`: witness soundness and exhaustive absence-of-witness equivalence; factor evaluation reproduces every enumerated row; incomplete carriers never yield a factor; a global factor requires a genuinely complete enumeration. These proofs assume observational equality reflects actual equality. Empty carriers have a separate result.
- `theories/Debt/LineageComposition.v`: L1 composition, the exact middle-ancestry condition for L2 coverage, the two L3 witness-survival equivalences, and a common source sufficient for all three coordinate pairs.
- `examples/Paper2ALineage.v`: the exact raw-ground L2 and derived-ground L3 countermodels printed in Paper 2A, plus the six-node laundering pattern with undisclosed and open L4 dispositions.

- `examples/Paper2AControls.v`: raw shared inputs with an ignored relevant source, actual-claim admissibility with implementation/grounding failure, and injectivity precluding fibre witnesses. These are assurance-boundary controls, not evaluator-adequacy proofs.

The listed modules contain no axioms or admissions. They do not import the isolated classical factorisation file.

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
causal independence, evaluator adequacy, custody or resolution of a defeater. Extraction, the OCaml
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
  GTC.Debt.LineageComposition GTCExamples.Paper2ALineage GTCExamples.Paper2AControls
make -C legacy/exactness-2026 check
python3 legacy/exactness-2026/mutation_check.py
python3 legacy/exactness-2026/mutation_verified_core.py
```

The 18-mutant suite targets the wrapper and diagnostics. The six-mutant suite
targets the generated code separately. Compiler errors are invalid mutants rather
than detections. The frozen six-node probe still tests its pinned handwritten
snapshot; it is not a test of the extracted replacement.

## Recorded outcome

All 46 selected theorem/example identifiers are closed under the global context.
Kernel checks and byte-identical extraction checks pass. Executable results are
61 edge checks, 368,640 graph comparisons, 9,360 fibre comparisons and fourteen
semantic boundary checks. The wrapper/diagnostic suite detects 18/18 compiling
mutants; the generated-core suite detects 6/6.

The [verification record](verification-v20/README.md) distinguishes the Make,
walkthrough and scaling executions from the component kernel, assumption and
mutation evidence. The current manifest binds the sources and these records.
The decision-core revision is `945c68e08f2d267d9a8a06ec77784a3ecc47afd9`;
proof/runtime controls are pinned at `1e9de34b63281d019502f746f57ede348b62ca5e`.
The verified component assembly is `a44557a06d1043d7a8d908fc7b32d891cbddc848`.

The typed-input practitioner walkthrough, measured scaling and complete technical
supplement are documented in the [release instructions](../release/README.md).
