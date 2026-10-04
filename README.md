# Paper 2A Lineage and L4 Extension

This repository is an independent copy of
[`dhwcmoore/grounded-transport-calculus`](https://github.com/dhwcmoore/grounded-transport-calculus),
with the strengthened Paper 2A lineage audit and executable L4 disclosure and
fibre checks added to `legacy/exactness-2026`. It retains the copied Git history
and the companion calculus. Its starting `main` revision is
`139791754787025ffaf3e37f78a869bbfa8d0ea5`.

The extension's handwritten OCaml modules pass 61 edge checks, 368,640
independent graph-reference comparisons, 9,360 independent fibre-reference
comparisons and detection of all 18 compiling mutants. The baseline's three
Coq source files are unchanged. These test results concern the new executable
checks; they are distinct from the kernel-checked results of the Coq development.
Open L2/L4 defeaters remain open, and this extension issues no transport certificate.

From the repository root, run the Paper 2A checks with:

```sh
make -C legacy/exactness-2026 check
(cd legacy/exactness-2026 && coqchk Admissibility && \
 coqchk -Q . Exactness Exactness.GroundedSeam Exactness.SeamExtraction)
python3 legacy/exactness-2026/mutation_check.py
```

Coq 8.18.0 and OCaml 4.14.1 are required for that version-gated check.
See [`paper2a-extension/README.md`](paper2a-extension/README.md) for provenance,
integration verification and the exact implementation scope.

## Copied companion: Grounded Transport

### Grounded Transport: Proof-Relevant Rewriting for Processual Ontologies

> Substitutability is not always exhausted by extensional equality. In
> lineage-sensitive systems, substitution requires an exhibited process
> connecting the terms, and contexts must preserve that processual warrant.

A small Rocq/Coq kernel extracted from an already verified special case
(grounded seams), together with the obstruction to observational substitution
and a classification of transport failure ("warrant debt").

## Build

Requires Coq/Rocq (developed against Coq 8.18).

```sh
coq_makefile -f _CoqProject -o Makefile.coq && make -f Makefile.coq
# or
dune build --root .
```

## Verification

From the repository root, after `dune build --root .`:

```sh
# kernel check of a module and everything it depends on
coqchk -R _build/default/legacy/exactness-2026 Exactness \
       -R _build/default/theories GTC \
       -R _build/default/examples GTCExamples \
       GTCExamples.LineageNonComposition

# extracted lineage checker against the frozen historical handwritten audit
WORK=$(mktemp -d)
extraction/run_lineage_regression.sh "$WORK"

# mutation study of the extracted checker, on the same work directory
python3 extraction/mutation_matrix.py "$WORK"
```

The regression script can be run from any directory. It reads the compiled
libraries from `_build/default` when a Dune build exists and from the source
tree otherwise (a `coq_makefile` build); set `GTC_LIBROOT` to choose
explicitly. `STATUS.md` records the current results. The pinned formal revision is
`e1e14a23a59906af0b14c556054133501a9b3612`; PR 4 is merged. A single
`coqchk` invocation on `LineageNonComposition` checks that module and its
dependency closure, not all 36 non-classical project modules. The complete
36-module pass and 123-identifier assumption audit are recorded separately.

## Layout

| Path | Content |
|---|---|
| `theories/Core` | `GTransport` structure, identity, composition, erased relation, erasure soundness |
| `theories/Contexts` | `GroundedProper`, composition, contextual preservation |
| `theories/Obstructions` | fibre factorisation, lineage obstruction, ungrounded agreement |
| `theories/Debt` | four warrant debts (with a proved lineage checker, `LineageCheck.v`): abstract skeleton (decidable classifier) and the located, evidence-bearing layer (certificates, `RPath` witnesses, `TransportAssessment` = Certified / Refuted / Open) |
| `theories/Instances` | compatibility layer: the *original* grounded seam, `SeamEvolution` and admissibility as instances (`Original*.v`); `ExtensionalSeam.v` is the weaker pairwise-only layer |
| `examples/` | the original copied counterexample, seam transport, maintenance failure, different warrants, evolution coverage, certificate reissue, lineage certificates, the checked lineage audit, and lineage non-composition |
| `paper/` | outline, theorem ledger, notation |
| `legacy/exactness-2026/` | the original Coq supplement, unchanged and built as library `Exactness`; its handwritten tax audit is extended with strengthened L1/L3, L4 disclosure and finite fibre checks |
| `extraction/` | extraction of the assessments and of the proved lineage checker; differential regression against the frozen historical audit and a mutation study |
| `paper2a-extension/` | extension provenance, frozen historical audit, standalone evidence and integration checks |
| `document/` | the manuscript (LMCS class) |
| `milestones/` | frozen, checksummed snapshots of earlier states |

See `STATUS.md` for what is proved, what is recovered from the legacy supplement, and what is open.

## Manuscript and reviewer release

The bundled LMCS manuscript records an earlier layout; the current intended
submission venue is the Journal of Logic and Computation. No arXiv upload is
needed to reproduce the artefact. A Git commit fixes the source revision;
a reviewer archive still needs a published persistent identifier. Do not cite
a DOI until the archive has been deposited and its public retrieval checked.
