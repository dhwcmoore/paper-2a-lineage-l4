# Paper 2A implementation and verification

The implementation supplies a declared-lineage graph audit, retained-value
fibre checker, tax-migration example, assurance-boundary controls and a
practitioner walkthrough. [Mechanisation scope](MECHANISATION.md) identifies
the Coq results and the tested runtime boundary.

The executable sources are under `../legacy/exactness-2026/`:

- `lineage_audit.ml` binds graph declarations to the extracted L1–L4 checker
  and reports qualifications, shared ancestry and open defeaters.
- `lineage_fibre.ml` binds retained values to the extracted fibre checker and
  reports a finite factor table or witness pair.
- `paper2a_verified_core.ml` and `.mli` contain the extracted decision functions.
- `jurisdiction.ml` supplies the synthetic tax-migration case.
- `boundary_controls.ml` exercises fourteen semantic assurance boundaries.
- `audit_walkthrough.ml` shows supplied data, diagnosis and repair.

From the repository root, follow the [build instructions](../README.md).
Coq 8.18.0 and OCaml 4.14.1 are required by the exactness Makefile.
The [verification record](verification-v20/README.md) reports results and binds
the current tree with a source/evidence manifest. The
[scaling experiment](../experiments/README.md) supplies raw measurements and
explicit limits on application evidence.

The supporting Grounded Transport repository is
[grounded-transport-calculus](https://github.com/dhwcmoore/grounded-transport-calculus),
with source revision `139791754787025ffaf3e37f78a869bbfa8d0ea5`.
The three baseline Coq sources are unchanged. The companion's L1–L3 regression
uses the fixed reference sources under `baseline/`; its results are distinct
from the Paper 2A graph and fibre tests. The six-node probe likewise checks its
own fixed handwritten source snapshot.

Component verification records retain their source revisions, execution dates
and manifests. They establish checks of those pinned inputs, and must be read
with the attribution in the current verification record. See
[release provenance](../release/README.md) for component pins and the permanent
archive, and [document instructions](../document/README.md) for editable sources.
