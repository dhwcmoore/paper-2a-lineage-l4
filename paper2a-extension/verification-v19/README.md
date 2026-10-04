# Version 19 merged-release verification — 4 October 2026

This directory binds the current repository to the version 19 manuscript,
updated verification appendix, separate bibliography and rebuilt PDF.
`SHA256SUMS` includes the current sources, documentation, bundled Springer
files, PDF and retained evidence. It excludes itself to avoid a circular hash.

The release integrates GitHub revision `43946e7`, preserving the version 18
proof/runtime additions pinned at `1e9de34b63281d019502f746f57ede348b62ca5e`.
Their independent evidence remains under [v18/](../v18/README.md). The unchanged
extracted decision core is pinned at `945c68e08f2d267d9a8a06ec77784a3ecc47afd9`.
The earlier local [version 18 replay](../verification-v18/README.md) is also
retained with its original attribution. Superseded manuscript files have been
removed from the current tree; historical manifests are checked on their
historical snapshots, not on this release.

After integrating the remote changes, the release was rebuilt and checked:

| Check | Result |
|---|---|
| Dune and exactness Make | Pass |
| Current-module kernel checks | Pass |
| Extraction regeneration | Byte-identical |
| Selected assumptions | 46 closed under the global context: 26 original, 11 upstream, 9 additional controls |
| Edge / graph / fibre checks | 61 / 368,640 / 9,360 pass |
| Additional executable semantic controls | 14 pass |
| Wrapper / generated-core compiling mutants | 18/18 / 6/6 detected |
| Version 19 PDF | 47 pages; no unresolved references, citations or overfull boxes |

`Assumptions.v`, `release-*.txt`, mutation JSON reports and `results.json` retain
the current checks. `document-build.txt` and `latex-final-pass.txt` describe the
rebuilt release manuscript. The standard `mathptmx` warning about unavailable
bold math fonts is retained. Earlier probe and companion counts retain their
historical attribution; those supplementary suites were not rerun for the merge.

`unchanged-replay-inputs.json` identifies the 81 inputs still matching the earlier
local version 18 manifest. Three changed inputs and two added runtime-control
files are verified against the upstream pinned source in
`upstream-source-inputs.json`; the combined release is checked by the fresh
build, kernel, assumptions, runtime and mutation commands.

Build and test commands are in the [root README](../../README.md). After a clean
Dune build, reproduce the selected assumption audit with:

```sh
cp paper2a-extension/verification-v19/Assumptions.v /tmp/Paper2AReleaseAssumptions.v
coqc -R _build/default/legacy/exactness-2026 Exactness \
  -R _build/default/theories GTC -R _build/default/examples GTCExamples \
  /tmp/Paper2AReleaseAssumptions.v
```

From the repository root, check all current hashes with:

```sh
sha256sum -c paper2a-extension/verification-v19/SHA256SUMS
```

The appendix names this manifest and command. A later source, documentation or
PDF change requires regenerating the manifest. The proofs concern declared
models; source fidelity, evaluator adequacy and clearance remain external
obligations. No transport certificate is issued.
