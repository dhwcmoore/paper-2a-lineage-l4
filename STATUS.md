# Verification status

The [paper and complete supplement](document/README.md), executable audit and
Coq proof sources are supplied with reproduction instructions in the
[root README](README.md).

Coq proves L1–L4 reflection, finite fibre witness/factor results and fixed-ground
composition results. All 46 selected theorem/example identifiers are closed
under the global context. The generated decision cores match extraction byte
for byte. See [mechanisation scope](paper2a-extension/MECHANISATION.md).

Recorded executable checks pass: 61 edge checks, 368,640 graph comparisons,
9,360 fibre comparisons, fourteen semantic boundary controls and the audit
walkthrough. Mutation studies detect 18/18 wrapper/diagnostic mutants and
6/6 generated-core mutants. The scaling experiment records 54 configurations
with five measured repetitions each.

The [verification record](paper2a-extension/verification-v20/README.md) attributes
executions to their source snapshots and supplies the current checksum command.
The [release documentation](release/README.md) describes source packages,
component revisions and the permanent Software Heritage archive.

The Grounded Transport companion has a separate reflected L1–L3 checker and
17-mutant regression study. Its comparison domain and trust boundary are in
[extraction documentation](extraction/README.md). The
[six-node probe](paper2a-extension/Paper_2A_L4_Six_Node_Probe/README.md) tests its
fixed handwritten implementation separately.

Graph qualification and finite-carrier results do not establish source fidelity,
actual coverage, causal independence or evaluator adequacy. Clearance and
transport-certificate authorisation require external justification.
