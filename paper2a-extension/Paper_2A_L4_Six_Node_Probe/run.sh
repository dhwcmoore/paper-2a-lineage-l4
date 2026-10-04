#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
probe_compiler="${OCAMLC:-ocamlc}"
"$probe_compiler" -c lineage_audit.mli
"$probe_compiler" -c lineage_audit.ml
"$probe_compiler" -o probe lineage_audit.cmo probe.ml
./probe > results.current.json
cmp results.json results.current.json
cat results.current.json
