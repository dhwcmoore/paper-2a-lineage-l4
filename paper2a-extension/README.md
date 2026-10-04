# Paper 2A extension in the copied repository

The separately named `paper-2a-lineage-l4` repository contains the complete
source of `grounded-transport-calculus` at starting main commit
`139791754787025ffaf3e37f78a869bbfa8d0ea5`, together with the tested Paper 2A
extension. The source repository has not been modified by this task.

The extension was prepared from the exactness snapshot exported at
`51284d028e9f4fb9e75f3fbba69a538b7fde311b`. Its source patch applied cleanly to
the copied main revision, and all 30 resulting exactness source files matched
the previously tested standalone package before integration verification.

## Build and check

From the repository root:

```bash
make -C legacy/exactness-2026 check
(cd legacy/exactness-2026 && coqchk Admissibility && \
 coqchk -Q . Exactness Exactness.GroundedSeam Exactness.SeamExtraction)
python3 legacy/exactness-2026/mutation_check.py --json legacy/exactness-2026/mutation_results.json
make -C legacy/exactness-2026 clean
dune build --root .
```

Run the kernel checks before `clean`: it removes the source-tree build products
that otherwise conflict with Dune rules. Expected outputs and verification
records are retained.

The supplementary [six-node L4 probe](Paper_2A_L4_Six_Node_Probe/README.md)
includes its own frozen inputs, results and reproduction command. Its counts
are separate from the extension suite.

The exactness Makefile retains its Coq 8.18.0 and OCaml 4.14.1 version gate.
The inherited project requires Dune 3.8 or later. The companion's original
verification and extraction commands remain in the repository root README.

The companion extraction regression uses the original handwritten three-clause
audit, frozen byte for byte under `baseline/`. This preserves its original record
format and output expectations. It does not compare the companion's L1–L3 checker
with the new L4 implementation. The new implementation has its own independent
reference tests and mutation checks under `legacy/exactness-2026`.

## Verification records

`Paper_2A_Lineage_L4_Verification.md` preserves the full standalone extension
verification account. `verification/` holds its build, kernel, independent-test,
mutation, regression and patch records. The original baseline records remain
separately labelled in `verification/baseline/`.

`integration/` holds the additional checks performed after applying the
extension to this complete repository copy. These records supplement the
standalone results rather than changing their attribution.

Large kernel transcripts under both evidence directories use lossless `.txt.gz`
files; `gzip -dc FILE.txt.gz` restores their complete text. The preserved standalone
report refers to the corresponding original `.txt` names. `compressed-logs.json`
records the original and compressed hashes. The integration checks pass the full
Dune build, the exactness Makefile, the kernel checks, the historical companion
regression and its 17-mutant union, and the new extension's 18-mutant suite.

## Historical implementation scope

The following scope describes the original handwritten extension. The current
[mechanised replacement](MECHANISATION.md) proves and extracts the L1--L4 and
retained-value fibre decision cores, while retaining tested input and diagnostic
wrappers. Historical verification logs retain their original attribution.

The new code is under `legacy/exactness-2026`:

- `lineage_audit.ml` and `.mli` implement graph validation, strengthened L1/L3,
  separate L2/L4 disclosure, structural qualification and declared open-defeater
  and coverage status.
- `lineage_fibre.ml` and `.mli` compute the shared-node tuple from the declared
  graph, validate retained values and subject identifiers, and return a finite
  factor table or a refuting pair.
- `jurisdiction.ml` uses the new graph audit without changing the original
  static and seam calculations.
- `lineage_examples.ml`, `test_lineage.ml` and `mutation_check.py` provide the
  executable laundering example, independent reference comparisons and
  single-fault mutations.

The original Coq proofs and the separately extracted companion lineage checker
are retained. The latter still implements its own L1–L3 predicate. The new L4
checks are handwritten OCaml, not a Coq-reflected or extracted implementation.
No graph declaration, justification string or finite-value check establishes
source fidelity, authenticates custody, records lineage clearance or issues a
transport certificate.

The current
[Paper 2A version 19](../document/Paper_2A_Copied_Agreement_v19.tex) incorporates
the extension scope and evidence. Superseded manuscripts have been removed; the original verification records
are retained as historical evidence.

Current version 18 replay, review controls and source hashes are recorded in
[verification-v18](verification-v18/README.md). The original mechanisation record
is historical and retains its original manuscript hashes.

The [version 19 manifest](verification-v19/README.md) binds the current manuscript
and repository to the retained evidence and fresh merged-release checks.
The upstream proof/runtime additions and their independent evidence remain
under [v18](v18/README.md).
