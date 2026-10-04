# Version 20 verification — 4 October 2026

Version 20 revises presentation and adds a supplied two-record walkthrough and
synthetic scaling experiment. The proved sources, extracted decision cores and
existing decision wrappers match the version 19 release at
`a44557a06d1043d7a8d908fc7b32d891cbddc848`. Their kernel, selected-assumption and
18/6 mutation evidence is retained in `../verification-v19/`; this record does
not relabel those executions as fresh version 20 kernel or mutation runs.

The exactness Make checks were freshly run, reproducing 61 edge checks,
368,640 graph comparisons, 9,360 fibre comparisons, 14 semantic boundary
checks and the new walkthrough's expected diagnostics. The walkthrough adds no
new formal guarantee or clearance verdict. Every one of the 54 scaling
configurations has five measured repetitions, with graph/fibre verdict and
factor-size/witness validation. All 270 raw records agree with their reported
medians. Data, methodology, host details and measurement limits are in
`../../experiments/scaling-v20/` and `../../experiments/README.md`.

Both PDFs compile with numeric square-bracket citations, a numbered
bibliography, author declarations, corresponding email and substantive LLM
assistance disclosure. The main article is 28 double-column pages; the complete
technical supplement is 50 single-column pages. The main exceeds STTT's usual
10–20-page range, which is not presented as an absolute limit. The final passes
have no unresolved references/citations or overfull boxes; the standard
`mathptmx` bold-math-font warning remains.

The full supplement preserves the proof development and verification tables;
shared-ancestry laundering and ignored-raw-source counterexamples remain in the
main article. The release source ZIP includes both editable documents, their
bibliography, required styles, measured figure and input files, and both PDFs.
The complete reviewer bundle adds the implementation and all evidence. See
[release instructions and archival status](../../release/README.md).

From the repository root:

```sh
make -C document
make -C legacy/exactness-2026 walkthrough
python3 experiments/run_scaling.py
sha256sum -c paper2a-extension/verification-v20/SHA256SUMS
python3 release/build_packages.py
(cd release/artifacts && sha256sum -c SHA256SUMS)
```

The editable source ZIP was extracted into a separate directory and rebuilt
with `make -B`; both documents compile using only its supplied inputs.
`source-package-rebuild.txt` retains that check.

The repository manifest excludes itself and generated release packages to avoid
circular hashes. Package checksums are retained separately. Historical manifests
are historical snapshot records, rather than the current checksum command.

The supporting version 20 artefact is archived as
`swh:1:rev:bea91080c022e4891731aa7a7bf60369269b25c7`. The full visit and
byte-checked public retrieval are recorded under `archive/`. The final
archive-citation update is bound by the current manifest; see the release
provenance for its relationship to the archived revision.
