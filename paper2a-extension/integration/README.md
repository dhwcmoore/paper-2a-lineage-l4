# Verification in the complete repository copy

Checks run on 4 October 2026 UTC, using Coq 8.18.0, OCaml 4.14.1 and Dune 3.14.0.
The copied `main` started at
`139791754787025ffaf3e37f78a869bbfa8d0ea5`. `history-copy.json` records the
matching six branch refs, one tag and 19 commits reachable from the imported main.

| Check | Result | Record |
| --- | --- | --- |
| Complete companion Dune build | PASS, exit 0 | `dune-build.txt.gz` |
| Version-gated exactness Makefile, recorded output and interface checks | PASS, exit 0 | `make-check.txt` |
| New graph and fibre tests | 61 edge checks, 368,640 graph comparisons and 9,360 fibre comparisons pass | `lineage-tests.txt` |
| Original admissibility kernel check | PASS, exit 0 | `coqchk-admissibility.txt.gz` |
| Grounded seam and seam extraction kernel checks | PASS, exit 0 | `coqchk-seam.txt.gz` |
| Companion `LineageNonComposition` and its dependency closure | PASS, exit 0 | `coqchk-companion.txt.gz` |
| Companion extracted checker regression against the frozen historical audit | PASS, exit 0; 5/5 case records, 1,921/1,921 overlap records and 6/6 v6 cases | `companion-regression.txt` |
| Companion extracted checker mutation union | 17/17 detected | `companion-mutation.txt` |
| New handwritten extension mutation suite | 18/18 compiling mutants detected | `extension-mutation.txt`, `extension-mutation-results.json` |

`results.json` records the exit status of each command. The companion regression
also passes all 17 stratified populations of 300 records. The random comparison
retains the original legacy-overlap restriction: 1,079 of the 3,000 records are
outside that overlap and are skipped. The two mutation studies check different
implementations and are not combined into one verification claim.

The inherited extraction harness now reads the byte-identical historical
`admissibility.ml` and `jurisdiction.ml` from `../baseline/`. This preserves the
companion regression's original three-clause record type and printed verdict.
The new four-clause implementation is checked by its own independent tests.
No Coq source file was changed. The companion kernel check covers the named
module and its dependencies; this run does not claim a new whole-project
assumption audit or new L4 proof.

The official toolchain packages were extracted into a private workspace prefix.
A compiler wrapper passed `-use-runtime` to select the relocated OCaml runtime;
`OCAMLFIND_COMMANDS` selected that same wrapper for the inherited regression.
Neither the source version gate nor any test criterion was relaxed. These
environment adjustments are unnecessary with the required versions installed
normally. Build logs retain the workspace command paths as run.

Large kernel logs are stored as lossless gzip files. For example:

```sh
gzip -dc paper2a-extension/integration/coqchk-companion.txt.gz
```

`compressed-logs.json` in the parent directory records the original and compressed
SHA-256 values. `SHA256SUMS` in this directory covers the integration records.
