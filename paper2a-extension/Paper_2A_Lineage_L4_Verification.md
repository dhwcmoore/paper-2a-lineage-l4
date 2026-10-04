# Paper 2A lineage and L4 extension: verification record

3 October 2026, Edmonton.

## Completed work

The historical tax audit now implements the manuscript's strengthened L1 and L3 definitions. A reusable module additionally checks L4 ground-ancestry disclosure. A second module runs the finite fibre test for retained shared-ancestry values and returns either a factor table or an explicit witness pair. The revised tax programme uses the new graph audit. A separate executable reproduces the manuscript's laundering pattern and distinguishes copied-status values from a retained trace valuation.

The implementation is handwritten OCaml. Its tests, mutation results and the kernel checks of the unchanged Coq core are distinct verification claims. No new L4 theorem has been mechanised or extracted.

## Identified input

| Item | Identifier |
| --- | --- |
| Repository | `dhwcmoore/grounded-transport-calculus` |
| Directory | `legacy/exactness-2026` |
| Exported commit | `51284d028e9f4fb9e75f3fbba69a538b7fde311b` |
| Supplied archive | `Paper_2A_Verified_Baseline_51284d0.zip` |
| Archive SHA-256 | `938c3bc7d28ecea7d1fb4717b0c140bb331c658085526c1830fa4e701cb396f6` |
| Manuscript specification | `Paper_2A_Copied_Agreement_v15.tex` |

All 24 payload entries covered by the input archive's manifest were verified before implementation. The supplied commit record and four original build/kernel transcripts are retained under `verification/baseline/`. Their original manifests are historical records of the input snapshot. The new package has its own complete manifest.

## Implemented specification

| Condition or procedure | Implemented behaviour | Boundary |
| --- | --- | --- |
| Well-formedness | Unique declared node names; declared parents; derived coordinate nodes; a declared raw or derived ground; raw relevance marks; acyclicity; valid, non-duplicated disposition records; nonempty claim and scope identifiers. | Validates the supplied record, not the completeness or truth of the production history. |
| L1 | Rejects `g = d_A`, `g = d_B`, and descent from either coordinate; locates each applicable reason. | Reported equality is not production-path independence. |
| L2 | Computes shared non-raw coordinate ancestry and requires a separate disposition for every member. | An open defeater satisfies disclosure and remains unresolved. |
| L3 | Includes the ground itself with its strict ancestors before excluding both coordinate ancestries and both coordinates; requires a claim-relevant raw member. | Relevance is supplied, and presence in ancestry does not establish substantive use. |
| L4 | Computes the ground's strict ancestry shared with either coordinate, excludes raw inputs and requires ground-specific dispositions for every member. | An L2 justification cannot substitute for an L4 disposition. |
| Structural qualification | Conjunction of L1, L2, L3 and L4. | Does not record lineage clearance or authorise transport. |
| Declared resolution status | Requires both disclosure conditions and no open defeater in either supplied disposition list. | Does not validate the evidence in a justification string. |
| Declared coverage status | Reports whether the supplied gap list is empty. | Does not infer actual coverage from the graph. |
| Retention binding | Requires matching claim, scope and ground identifiers. | Identifiers are supplied and unauthenticated. |
| Retention validation | Unique nonempty carrier identifiers; unique required shared-node values; no missing or unexpected tuple members. | Does not validate source capture or discover omitted carrier records. |
| Fibre test | Applies the unchanged finite factor-table procedure to the canonical shared-node tuple and Boolean ground value; validates positive factor tables. | Positive results depend on the caller's completeness declaration. |
| Partial and empty data | A clean incomplete carrier returns `NoWitnessFound`; a witnessed mixed fibre remains a refutation; missing retention and empty carriers receive separate outcomes. | None of these outcomes silently closes a concern. |

The fibre module computes the tuple members from the audited graph rather than accepting a caller-chosen subset. Typed Boolean, machine-integer and text values prevent cross-type encoding collisions. The ground in this executable remains Boolean, matching the manuscript's exact case; the general nonempty-codomain mathematical formulation is not implemented as a general value-valued ground checker.

## Fresh verification results

| Check | Result |
| --- | --- |
| Original version gate | PASS: Coq 8.18.0 and OCaml 4.14.1. |
| `make check` | PASS, exit 0. |
| Named `Print Assumptions` output | Ten reports of `Closed under the global context`. |
| `coqchk Admissibility` | PASS, exit 0; `Modules were successfully checked`. |
| `coqchk -Q . Exactness Exactness.GroundedSeam Exactness.SeamExtraction` | PASS, exit 0; `Modules were successfully checked`. |
| Original OCaml examples | PASS: byte-for-byte equality with the historical recorded output. |
| Tax static and seam output | PASS: all output before the lineage section matches the verified baseline byte for byte. |
| Revised tax lineage outcomes | PASS: all five graph/disposition outcomes checked. |
| Existing sealed-interface checks | PASS, including rejection of ordinary direct construction and stage mismatch. |
| Retained unsafe-cast demonstration | Runs as declared; the original OCaml escape-hatch limitation remains. |
| Edge and malformed-input checks | 61 PASS. |
| Independent graph-reference comparisons | 368,640 PASS. |
| Independent fibre-reference comparisons | 9,360 PASS. |
| Mutation checks | 18 of 18 compiling mutants detected by named test failures. |
| Patch integration | Checked against a temporary repository containing the supplied baseline; every patched source file compared with this package. |

The matching toolchain packages were extracted into a local toolchain in this workspace. The compiler wrapper supplied `-use-runtime` solely to select the relocated bytecode interpreter. The compiler and proof assistant reported the required versions; the Makefile version gate was retained. The new source does not require that wrapper on a machine with the required versions installed normally.

### Independent graph reference

The test suite enumerates all 512 acyclic dependency graphs in a fixed ordered universe containing two raw and three derived nodes. For each graph it varies both derived coordinate roles, all five ground choices, all four raw-relevance markings, and all four full/empty L2/L4 disclosure combinations. These give 368,640 assessments.

The reference closes an adjacency matrix by Floyd–Warshall and evaluates the manuscript's set formulae directly. It does not use the implementation's ancestor traversal or graph-validation functions. It compares all four clause values, the shared-coordinate set, the shared-ground set, the ground-only set and their conjunction. The enumeration is exhaustive for that finite test universe; it is not a theorem about all possible graphs.

### Independent fibre reference

The suite enumerates all assignments of two-bit observations and Boolean ground values on carriers of one to four records. Each assignment is tested under both complete and incomplete declarations, giving 9,360 comparisons. The reference checks pairs directly for equal observations and differing ground values.

Every returned witness is checked against the supplied carrier and the pairwise criterion. Every positive factor table must have exactly the observed image and reproduce every retained ground value. Rows deliberately alternate the order of their node-value pairs, testing that node identity determines tuple order.

### Mutations

All 18 mutants compiled. Each was rejected by a named check. Compiler failures were excluded from the detection criterion.

| Mutant | Fault detected |
| --- | --- |
| M01 | Omit the ground/A inequality. |
| M02 | Omit the ground/B inequality. |
| M03 | Exclude the ground itself from L3. |
| M04 | Require the ground to be derived again. |
| M05 | Use intersection instead of union for coordinate ancestry in L4. |
| M06 | Include shared raw nodes in L4. |
| M07 | Omit L4 from structural qualification. |
| M08 | Treat an open L4 defeater as failed disclosure. |
| M09 | Treat an open ground defeater as resolved. |
| M10 | Substitute L2 dispositions for L4 dispositions. |
| M11 | Affirm factorisation on an incomplete carrier. |
| M12 | Discard a refuting fibre witness. |
| M13 | Use caller tuple order instead of node identity. |
| M14 | Ignore the ground identifier. |
| M15 | Affirm an empty carrier. |
| M16 | Mark undisclosed dependencies as resolved. |
| M17 | Ignore the scope identifier. |
| M18 | Close an outstanding coverage gap. |

The mutation record belongs to this new extension. It is not the companion calculus's earlier 17-mutant record and must not be attributed to that artefact.

## Case results

| Case | Result |
| --- | --- |
| Live tax rows | L1–L4 pass; no shared derived ancestry between the ground and either coordinate. |
| Backfill tax rows | L1–L4 pass; the shared coordinate zone remains an open L2 defeater, so declared resolution is incomplete. |
| Backfill with zone undisclosed | L2 fails; structural qualification fails. |
| Tax ground copied from the old flag | L1 and L3 fail; L4 additionally exposes the undisclosed shared zone. |
| Cyclic tax graph | Rejected as malformed before assessment. |
| Ground identical to either coordinate | L1 fails with its located identity reason. |
| Direct raw claim-relevant ground | Accepted structurally when outside both coordinate ancestries. |
| Laundering graph with only L2 disclosure | L1–L3 pass and L4 fails. |
| Laundering graph with an open L4 disposition | L1–L4 pass; the ground concern remains open. |
| Copied status on both request records | Factors through the retained shared status value. |
| Trace ground with the same shared status on both records | Returns the `r_ok`/`r_star` pair, with different ground values. |
| Clean incomplete request sample | Returns `NoWitnessFound`. |
| Incomplete sample containing that trace pair | Still returns a refuting witness. |

The tax counts are preserved: 864 states; 720 old-surface fibres with 28 mixed; 360 new-surface fibres with none mixed; 1,728 seam records; 48 endpoint disagreements and 74 grounding witnesses before repair, including 26 agreeing-but-ungrounded records; and 72 seam and grounding witnesses after repair, with no agreeing-but-ungrounded records.

## Scope for the manuscript

Version 15 remains an accurate account of the earlier pinned baseline. It has not been silently edited to describe this extension. A later revision can now distinguish the older baseline from this new executable extension and update the following passages:

1. The introduction and scope can state that the Paper 2A extension implements strengthened L1/L3 handling, L4 disclosure and the Boolean finite fibre test in handwritten OCaml.
2. The tax-audit subsection can replace its three historical implementation limits with the new behaviour, retaining the older baseline's provenance as an earlier snapshot.
3. The case tables can record the new L4 results and the laundering demonstrations. The original tax counts remain unchanged.
4. The limitations and verification appendix can replace “L4 not implemented” with the exact new executable scope and these separately attributed test results.
5. The L4 and laundering propositions remain paper proofs. Executable checks do not make them mechanised theorems. The composition results and metric supplement remain outside this extension.
6. The ten closed-assumption reports and three core modules checked by the kernel remain evidence about the unchanged Coq development. They must not be presented as a reflection proof of the new handwritten lineage modules.
7. Structural qualification, declared resolution status, recorded lineage clearance and transport-certificate issuance must remain distinct. No new clearance or transport-certificate authority has been implemented here.

No remote repository update, public deposit or journal submission was performed in this task. The delivered source and patch are ready for inspection and local integration.
