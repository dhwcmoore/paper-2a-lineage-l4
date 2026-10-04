# Historical version 17 mechanisation verification — 4 October 2026

This directory records the new Coq proof and extracted-core integration checks,
separately from the original handwritten extension's standalone and integration
records. `../MECHANISATION.md` gives the exact scope and reproduction commands.

`Assumptions.v` selects 26 theorem/example identifiers; `assumptions.txt` has
26 closed-under-global-context reports. The new modules and their dependencies
pass the named `coqchk -silent` invocation. Silence is normal on a successful
kernel run; its exit status is recorded in `results.json`.

`make-check.txt` records the fresh version-gated runtime checks: 61 edge checks,
368,640 graph-reference comparisons, 9,360 fibre-reference comparisons and
expected-output/interface checks. `extraction.txt` records byte-identical
regeneration. The two mutation studies have separate logs and JSON reports;
compilation errors do not count as detections. `dune-build.txt.gz` (lossless gzip) is an incremental
build record, not a new audit of every historical manuscript identifier.

`SHA256SUMS` binds these records and the new proof, extraction, wrapper and
manuscript sources to the local working tree. The baseline parent revision is
`30b1cdefc1c5d18d55e1c829fe1545f65920b688`; the mechanised source and original verification records are committed at
`945c68e08f2d267d9a8a06ec77784a3ecc47afd9`. The subsequent manuscript update cites
that artefact revision and refreshes the local source/evidence manifest. These checks establish properties of declared data, not authentic
source capture, actual coverage, causal independence or certificate clearance.

This record is preserved as historical evidence. Its manuscript hashes refer to
version 17, now retained in Git history; verify the complete historical manifest
at commit `12aac41`. For the current manuscript and replay, use
[verification-v18](../verification-v18/README.md).
