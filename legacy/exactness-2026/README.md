# Paper 2A source: strengthened lineage and L4 checks

This directory is the runnable source of the Paper 2A code extension. See [extension README](../../paper2a-extension/README.md) for its provenance, verification scope and integration patch, and [verification report](../../paper2a-extension/Paper_2A_Lineage_L4_Verification.md) for the detailed results.

## Build

```bash
make check
coqchk Admissibility
coqchk -Q . Exactness Exactness.GroundedSeam Exactness.SeamExtraction
python3 mutation_check.py --json mutation_results.json
```

Required versions are Coq 8.18.0 and OCaml 4.14.1, as recorded in `VERSIONS` and enforced by the Makefile. The L1--L4 and retained-value fibre decision cores are extracted from Coq;
input validation and diagnostic wrappers remain handwritten. See
[mechanisation scope](../../paper2a-extension/MECHANISATION.md).
The finite checks run as ordinary OCaml programmes; the mutation harness uses Python 3.

## Lineage modules

`Lineage_audit.check` validates the declared graph before evaluating L1–L4. The two coordinate determinations must be derived nodes. The ground must be declared and may itself be raw. Its record includes separate coordinate-shared and ground-shared dispositions, claim and scope identifiers, and declared coverage gaps.

The assessed result locates coordinate-ground identity or descent; lists shared coordinate ancestry and undisclosed L2 nodes; lists the ground-only source set and its claim-relevant raw inputs; and lists ground-shared derived ancestry and undisclosed L4 nodes. Open defeaters satisfy structural disclosure and remain separately reported.

`Lineage_fibre.check` derives the shared-node tuple from that graph. It accepts retained rows labelled with the same claim, scope and ground identifiers. Each row supplies exactly one typed value for each required shared node and a Boolean ground value. The order in which a caller supplies the node-value pairs is immaterial. Boolean, machine-integer and text values have distinct constructors, so their encodings cannot collide merely because their printed forms coincide.

On the declared carrier the procedure returns a verified finite factor table or a pair with equal shared tuples and different ground values. Clean incomplete samples, missing retention and an empty carrier have separate outcomes. These checks concern declarations and retained values; they do not authenticate the identifiers or the capture process.

## Original and revised output

The historical outputs remain under `recorded-output/`. The original examples are compared directly with their historical output. The revised tax and lineage demonstration outputs are under `expected/`; `make check` compares each new execution with these files.

`BASELINE_README.md` preserves the original README as a historical document. In particular, its old `lineage-grounded` terminology and three-clause implementation account describe the input baseline, not these new modules.

`make clean` removes build products and fresh execution outputs. It retains the source, expected outputs and the verification records outside this directory.
