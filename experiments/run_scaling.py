#!/usr/bin/env python3
"""Reproduce synthetic wrapper timings; compilation/input generation are untimed."""
import argparse
import csv
import datetime
import json
import platform
import statistics
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ROOT / "legacy/exactness-2026"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "experiments/scaling-v20")
    parser.add_argument("--repetitions", type=int, default=5)
    args = parser.parse_args()
    if args.repetitions < 1:
        parser.error("repetitions must be positive")
    args.output.mkdir(parents=True, exist_ok=True)
    records, summaries = [], []
    with tempfile.TemporaryDirectory(prefix="paper2a-scaling-") as scratch:
        work = Path(scratch)
        modules = ["admissibility", "paper2a_verified_core", "verified_fibre",
                   "lineage_audit", "lineage_fibre", "scaling_benchmark"]
        for module in modules:
            for extension in ["mli", "ml"]:
                source = SOURCES / f"{module}.{extension}"
                if source.exists():
                    (work / source.name).write_bytes(source.read_bytes())
                    subprocess.run(["ocamlc", "-c", source.name], cwd=work, check=True)
        subprocess.run(["ocamlc", "-o", "benchmark", "unix.cma"] +
                       [f"{m}.cmo" for m in modules], cwd=work, check=True)
        for topology in ["fanout", "chain"]:
            for nodes in [8, 16, 32]:
                for rows in [32, 128, 512]:
                    for kind in ["constant", "injective", "early-witness"]:
                        command = ["/usr/bin/time", "-f", "%M", "-o", str(work / "rss"),
                                   str(work / "benchmark"), "--rows", str(rows),
                                   "--nodes", str(nodes), "--repetitions", str(args.repetitions),
                                   "--topology", topology, "--kind", kind]
                        result = subprocess.run(command, cwd=work, text=True,
                                                capture_output=True, check=True, timeout=300)
                        batch = list(csv.DictReader(result.stdout.splitlines()))
                        assert len(batch) == args.repetitions
                        peak_rss = int((work / "rss").read_text().strip())
                        for row in batch:
                            row["peak_process_rss_kib"] = peak_rss
                        records.extend(batch)
                        summary = {"topology": topology, "nodes": nodes, "rows": rows,
                                   "kind": kind, "peak_process_rss_kib": peak_rss}
                        for phase in ["graph", "fibre"]:
                            values = [float(r[f"{phase}_seconds"]) for r in batch]
                            for label, fn in [("median", statistics.median), ("min", min), ("max", max)]:
                                summary[f"{phase}_{label}_seconds"] = fn(values)
                        summaries.append(summary)
                        print(f"{topology:6} n={nodes:2} rows={rows:3} {kind:13} "
                              f"graph={summary['graph_median_seconds']:.4f}s "
                              f"fibre={summary['fibre_median_seconds']:.4f}s", flush=True)
                        # Persist completed configurations during a long run.
                        with (args.output / "raw.csv").open("w", newline="") as f:
                            writer = csv.DictWriter(f, fieldnames=list(records[0]))
                            writer.writeheader()
                            writer.writerows(records)
        cpu = next((line.split(":", 1)[1].strip()
                    for line in Path("/proc/cpuinfo").read_text().splitlines()
                    if line.startswith("model name")), "unknown")
        metadata = {"date_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
                    "platform": platform.platform(), "cpu": cpu,
                    "compiler": subprocess.check_output(["ocamlc", "-version"], text=True).strip(),
                    "runtime": "OCaml bytecode; public wrappers; serial jobs",
                    "repetitions": args.repetitions, "configurations": len(summaries),
                    "warmups_per_configuration": 1,
                    "timed": "graph wrapper alone; fibre wrapper including its own graph check",
                    "excluded": "compilation, input construction, warm-up, explicit pre-timing GC",
                    "memory": "Peak process RSS includes input construction, warm-up and all repetitions",
                    "limitations": "One host, synthetic complete inputs, no DB or I/O integration; no asymptotic or industrial performance claim",
                    "summary": summaries}
        (args.output / "results.json").write_text(json.dumps(metadata, indent=2) + "\n")


if __name__ == "__main__":
    main()
