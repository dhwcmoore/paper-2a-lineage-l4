# Version 18 verification records

Proof and executable source pin: [`1e9de34b63281d019502f746f57ede348b62ca5e`](https://github.com/dhwcmoore/paper-2a-lineage-l4/tree/1e9de34b63281d019502f746f57ede348b62ca5e).
The manuscript and release-manifest update follows this source revision.

Independent replay on 4 October 2026, using Coq 8.18.0, OCaml 4.14.1,
Dune 3.14.0 and Findlib 1.9.6. The current manuscript is
[version 18](../../document/Paper_2A_Copied_Agreement_v18.pdf).
[Verification and change report](VERIFICATION_AND_CHANGES.md) explains the results
and their limits. [results.json](results.json) records the reconciled counts.

| Directory | Source checked |
|---|---|
| `baseline/` | Grounded Transport commit `51284d028e9f4fb9e75f3fbba69a538b7fde311b` |
| `v17/` | Paper 2A commit `945c68e08f2d267d9a8a06ec77784a3ecc47afd9` |
| `companion/` | Grounded Transport commit `e1e14a23a59906af0b14c556054133501a9b3612` |
| `v18/` | Version 18 source identified by the source/evidence manifest |

Each directory contains command records, exit codes and captured output.
Large kernel-check logs are gzip-compressed; use `gzip -dc FILE.txt.gz` to read
them. Silent successful kernel checks contain only the command header.
The companion also has an explicit check of all 36 named nonclassical modules;
the isolated classical factorisation audit records its two declared axioms.

The original counts reproduce: 61 edge checks, 368,640 graph comparisons,
9,360 fibre comparisons, 18/18 wrapper mutants and 6/6 generated-core mutants.
Version 18 adds 14 separately counted boundary checks and increases the selected
closed assumption reports from 26 to 37. The tax counts, extracted decision core
and three baseline Coq sources are unchanged. The frozen six-node probe and
companion regression/mutation studies retain their separate attribution.

`environment-attempts/` preserves initial failed attempts caused by the
relocated toolchain's library paths. These are excluded from the successful
replay counts. After correcting those paths, every recorded replay command
passed. No repository change was needed to correct the environment.

[Assumptions.v](Assumptions.v) selects the current 37 identifiers.
[manuscript-relocations.json](manuscript-relocations.json) records the five
historical blocks moved intact to the appendix. PDF and documentation checks
are recorded in [release-checks.json](release-checks.json).

From the repository root:

```sh
sha256sum -c paper2a-extension/v18/SHA256SUMS
```

The manifest excludes itself and binds the current sources, manuscript and
records. Rebuild instructions are in the [root README](../../README.md#reproduce-the-papers-checks).
The historical version 17 manifest is verified against its pinned snapshot;
it is not a manifest for this changed tree. No metric supplement or new archive
identifier is included in this release.
