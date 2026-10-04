# Version 19 manifest — 4 October 2026

This directory binds the current repository to the uploaded version 19 manuscript
with its updated verification appendix, separate bibliography and rebuilt PDF.
`SHA256SUMS` includes the current source and documentation files, bundled Springer
template dependencies, PDF and retained verification evidence. The manifest
excludes itself to avoid a circular hash.

The proof and runtime results remain those of the
[version 18 replay](../verification-v18/README.md). No new test-suite execution is
claimed by this manifest refresh. All 84 selected proof, runtime, expected-output
and build inputs match the version 18 manifest; their paths and verified hashes
are recorded in `unchanged-replay-inputs.json`. The decision cores remain pinned
at `945c68e08f2d267d9a8a06ec77784a3ecc47afd9`.

The edited version 19 manuscript was rebuilt with `make -C document` and BibTeX:
47 pages, no unresolved references or citations, and no overfull boxes. The
standard `mathptmx` warning about unavailable bold math fonts is retained in the
final-pass log. `document-build.txt`, `latex-final-pass.txt` and `results.json`
record the manuscript check and template provenance.

From the repository root:

```sh
sha256sum -c paper2a-extension/verification-v19/SHA256SUMS
```

The appendix names this manifest and command. A later source, documentation or
PDF change requires regenerating the manifest. The version 18 manifest is
preserved as a historical snapshot; it is not the checksum command for the
current tree; superseded manuscript files listed in it have been removed.
The current manifest verifies the retained records' bytes without
relabeling their test execution as a version 19 replay.
