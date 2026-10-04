# Version 18 replay — 4 October 2026

This record verifies the current manuscript and repository, separately from the
historical version 17 record in `../mechanisation/`. The lineage and finite-fibre
decision cores are unchanged from commit
`945c68e08f2d267d9a8a06ec77784a3ecc47afd9`. Version 18 adds
`examples/Paper2AControls.v` and manuscript clarifications. The current manifest
binds the replay to the listed sources and PDF; it does not assert a new public
commit or archive deposit.

All commands completed with exit status zero. `results.json` records toolchain,
counts and scope. Full transcripts are retained; the verbose exactness kernel
transcript is losslessly compressed. Successful silent kernel checks produce
empty logs, so their exit status is recorded separately.

| Check | Reproduced result |
|---|---|
| Dune build and version-gated exactness Make check | Pass |
| Exactness and current-module kernel checks | Pass |
| Fresh extraction versus retained OCaml | Byte-identical |
| Selected core assumptions | 26 closed under the global context |
| Additional review-control assumptions | 9 closed under the global context |
| Edge / graph / fibre checks | 61 / 368,640 / 9,360 pass |
| Wrapper / generated-core compiling mutants | 18/18 / 6/6 detected |
| Frozen supplementary probe | 262,144 assessments; zero mismatches |
| Companion regression | 5 fixed; 1,921 random overlap; 3,300 shallow; 1,800 deep; 6 edges |
| Companion exclusions | 1,079 of 3,000 random cases outside historical overlap |
| Companion mutation union | 17/17 detected |
| Version 18 PDF | 44 pages; no final LaTeX warnings |

The review controls prove the specified countermodels and injectivity boundary.
They do not increase the executable test counts or establish source fidelity,
evaluator adequacy, causal independence or lineage clearance. Runtime encoding,
validation, diagnostics and presentation remain tested wrappers. See
[MECHANISATION.md](../MECHANISATION.md) for the precise boundary.

Reproduction commands for the builds, kernel checks, runtime tests, mutation
suites and supplementary checks are in the [root README](../../README.md).
To reproduce the selected assumption audit after a clean Dune build:

```sh
cp paper2a-extension/verification-v18/Assumptions.v /tmp/Paper2AV18Assumptions.v
coqc -R _build/default/legacy/exactness-2026 Exactness \
  -R _build/default/theories GTC -R _build/default/examples GTCExamples \
  /tmp/Paper2AV18Assumptions.v
```

The build logs include the initial project build and the subsequent build of the
review controls. No new audit of every historical companion theorem is claimed.
The current named kernel check includes the controls and its dependency closure.

From the repository root, check the recorded hashes with:

```sh
sha256sum -c paper2a-extension/verification-v18/SHA256SUMS
```

Older manuscript files remain in Git history. To verify the complete historical
version 17 manifest, use its checkout at `12aac41`, rather than the version 18 tree.

Superseded manuscript files have since been removed from the current tree.
This historical manifest retains their original hashes and is not the checksum
command for the current repository; use the
[version 19 manifest](../verification-v19/README.md) for the current files.
