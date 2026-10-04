# Frozen historical audit for the companion regression

`admissibility.ml` and `jurisdiction.ml` are byte-for-byte copies of the historical
exactness audit at source commit
`51284d028e9f4fb9e75f3fbba69a538b7fde311b`, from
`dhwcmoore/grounded-transport-calculus:legacy/exactness-2026`.
`SHA256SUMS` records their hashes.

The inherited `extraction/run_lineage_regression.sh` compiles these copies with
the companion's separately extracted Coq lineage checker. Its comparison uses
the documented legacy overlap and preserves the historical record and output
format. This audit implements the old three-clause specification. It is a
regression reference, not the new Paper 2A L4 implementation.

The new handwritten graph and fibre checks remain in
`../../legacy/exactness-2026/lineage_audit.ml` and `lineage_fibre.ml`, where the
Makefile runs their independent tests. The companion's Coq predicate is unchanged.
