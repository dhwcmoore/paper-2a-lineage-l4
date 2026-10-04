#!/bin/sh
# After a clean Dune build, regenerate in scratch and compare checked-in core.
# --update explicitly refreshes the generated OCaml; default is read-only check.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
LIBROOT=${GTC_LIBROOT:-"$ROOT/_build/default"}
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT HUP INT TERM
cp "$ROOT/extraction/ExtractPaper2A.v" "$WORK/"
(cd "$WORK" && coqc -R "$LIBROOT/legacy/exactness-2026" Exactness \
 -R "$LIBROOT/theories" GTC ExtractPaper2A.v)
for extension in ml mli; do
 if [ "${1:-}" = --update ]; then
  cp "$WORK/paper2a_verified_core.$extension" "$ROOT/legacy/exactness-2026/"
 else
  cmp "$WORK/paper2a_verified_core.$extension" "$ROOT/legacy/exactness-2026/paper2a_verified_core.$extension"
 fi
done
printf '%s\n' 'Paper 2A extraction matches the generated OCaml core.'
