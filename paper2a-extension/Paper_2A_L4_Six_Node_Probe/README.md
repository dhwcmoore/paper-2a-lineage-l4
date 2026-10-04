# Paper 2A: six-node L4 reference probe

This is a supplementary investigation of the handwritten lineage audit at
`dhwcmoore/paper-2a-lineage-l4`, commit
`30b1cdefc1c5d18d55e1c829fe1545f65920b688`.
It is separate from the published 61-edge, 368,640-graph and 9,360-fibre test
figures. The repository and manuscript were not modified by this probe.

## Reason for the probe

The published exhaustive graph-reference test uses two raw and three derived
nodes. The paper's laundering countermodel needs four distinct derived nodes:
the shared status, the two coordinate determinations and the ground. The
published named edge tests already exercise that countermodel. This probe adds
an independent graph-reference comparison in a universe large enough to contain
its shared-ancestry pattern, including sharing with only one coordinate.

## Enumerated universe

There are two raw nodes `r0,r1` and four derived nodes `s,A,B,g`, in that fixed
topological order. Coordinates are fixed as `A,B` and the ground as `g`.
Every derived node can have any subset of its preceding nodes as parents.
The 2+3+4+5 possible edges give 16,384 ordered DAGs. Each graph is assessed with
all four raw-relevance markings and all four full/empty combinations of the
separate L2 and L4 disposition lists, giving 262,144 assessments.

The reference uses Floyd-Warshall closure of a Boolean adjacency matrix and
then the manuscript's displayed set formulae. It does not call the audit's
ancestor traversal or well-formedness helper. It compares all four clauses,
the shared-coordinate and shared-ground sets, the ground-only set and structural
qualification. Generated graphs are well formed by construction. This run does
not repeat the malformed-input and retention tests of the published suite.

## Results

| Outcome | Count |
| --- | ---: |
| Ordered graphs, with fixed coordinate and ground roles | 16,384 |
| Graph/relevance/disclosure assessments | 262,144 |
| Implementation/reference mismatches | 0 |
| Assessments passing L1-L3 | 4,724 |
| Assessments passing L1-L4 | 4,157 |
| Assessments passing L1-L3 but failing L4 | 567 |
| Distinct graphs admitting at least one such configuration | 186 |

The 567 assessments vary relevance and disclosure as well as graph structure;
they are not 567 distinct graphs. With relevance fixed to `{r1}`, L2 fully
disclosed and L4 undisclosed, 352 graphs pass L1-L3 and 96 of those fail L4.
The JSON result retains both counts.

These are bounded synthetic comparison results. A failed L4 here locates
missing disclosure of shared derived ground ancestry; it does not establish
that a ground was actually copied, that a source is inaccurate, or that such
failures have this frequency in real migrations. Passing all four clauses is
structural qualification, not lineage clearance or transport certification.
The OCaml implementation is handwritten. This probe proves no general Coq
reflection theorem, causal-independence claim or new L4 composition theorem.

## Reproduction

The recorded run used OCaml 4.14.1. No Coq installation is needed for this
particular probe. Extract the archive, enter its folder and run:

```bash
bash run.sh
```

`run.sh` compiles the included source and compares the new JSON output with
`results.json`. `OCAMLC` can select an explicit compiler executable.
`PROVENANCE.json` identifies the repository revision and source hashes;
`SHA256SUMS` covers every retained input and result file.
