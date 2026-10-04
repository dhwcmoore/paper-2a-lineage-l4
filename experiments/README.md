# Version 20 synthetic scaling experiment

Run `python3 experiments/run_scaling.py` from the root. It compiles the public
OCaml wrappers as bytecode in a temporary directory, generates bound complete
inputs and runs serial jobs. Requirements: OCaml 4.14.1, Python 3 and
`/usr/bin/time`. No database, network service or compiler optimisation is timed.

The full grid is 32/128/512 records × 8/16/32 total lineage nodes × two graph
profiles × three outcomes, giving 54 configurations. Each has one untimed
warm-up and five measured repetitions. Every graph result and expected factor
size or early-witness identity is checked inside the timed call. The supplied
graphs pass L1–L4 with an open ground concern; no clearance is inferred.

The shallow fan-out profile retains one shared ancestor; its other declared
derived nodes are outside the shared-status ancestry. The chain retains 3, 11
or 27 shared ancestors as node count increases. Thus graph size and carrier
size vary independently, but comparisons between the two profiles also vary
retained-tuple width and ancestry depth. They do not isolate graph depth alone.

Outcomes are a constant tuple with constant ground (one-entry factor), an
injective tuple (one factor entry per record), and a ground disagreement on the
first two records of a constant tuple (early witness).

`scaling-v20/raw.csv` contains all 270 repetitions. `results.json` records the
host, compiler, all medians/minima/maxima and peak process RSS. Graph timing
calls `Lineage_audit.check`; fibre timing calls the full `Lineage_fibre.check`,
including its repeated graph check, validation and presentation. Compilation,
input construction, warm-up and explicit pre-timing garbage collection are
excluded. Allocation-triggered collection during a call is included. Peak RSS
includes input construction, warm-up and every repetition in that process;
it is not an isolated allocation measurement. CPU affinity and frequency were
not fixed, and the host was not a dedicated benchmark machine.

To regenerate the publication table, prose and standalone figure from the
retained measurements, run `python3 experiments/render_scaling.py` (requires
Matplotlib). This reads measurements; it does not invent or rerun them.

The results expose current wrapper costs on one host. They do not establish
asymptotic complexity, industrial throughput, evidence-collection cost or
effectiveness on operational migrations. The independently checked graph/fibre
test counts concern correctness and are not throughput measurements.
