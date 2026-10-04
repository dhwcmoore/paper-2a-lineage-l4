#!/usr/bin/env python3
"""Rebuild single-fault variants and require the independent suite to reject them.

A compiler error is an invalid mutant, not a successful detection. Each accepted
mutation must compile and then fail a named test. The unchanged source must pass.
"""
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import tempfile
from pathlib import Path

MUTANTS = [
    ("M01", "omit ground/A inequality", "lineage_audit.ml",
     'l.ground = l.d_a, "GroundEqualsA"', 'false, "GroundEqualsA"'),
    ("M02", "omit ground/B inequality", "lineage_audit.ml",
     'l.ground = l.d_b, "GroundEqualsB"', 'false, "GroundEqualsB"'),
    ("M03", "exclude the ground itself from L3", "lineage_audit.ml",
     '(List.sort_uniq compare (l.ground :: g))', '(List.sort_uniq compare g)'),
    ("M04", "again require a derived ground", "lineage_audit.ml",
     'if not (declared l.ground) then', 'if not (List.mem_assoc l.ground l.derived) then'),
    ("M05", "L4 requires sharing with both coordinates", "lineage_audit.ml",
     '(List.mem n a || List.mem n b) && not (List.mem n l.raw)) g',
     '(List.mem n a && List.mem n b) && not (List.mem n l.raw)) g'),
    ("M06", "L4 wrongly includes shared raw nodes", "lineage_audit.ml",
     '(List.mem n a || List.mem n b) && not (List.mem n l.raw)) g',
     '(List.mem n a || List.mem n b)) g'),
    ("M07", "omit L4 from structural qualification", "lineage_audit.ml",
     'lineage_qualified = l1 && l2 && l3 && l4;',
     'lineage_qualified = l1 && l2 && l3;'),
    ("M08", "confuse open L4 disclosure with failed disclosure", "lineage_audit.ml",
     'l4 = undisclosed_ground = [] in',
     'l4 = undisclosed_ground = [] && open_ground_defeaters = [] in'),
    ("M09", "treat an open ground defeater as resolved", "lineage_audit.ml",
     'declared_resolution_complete = l2 && l4 && open_coordinate_defeaters = [] && open_ground_defeaters = [];',
     'declared_resolution_complete = l2 && l4 && open_coordinate_defeaters = [];'),
    ("M10", "substitute L2 dispositions for L4", "lineage_audit.ml",
     'let undisclosed_ground = List.filter (fun n -> not (List.mem_assoc n l.ground_dispositions)) shared_ground in',
     'let undisclosed_ground = List.filter (fun n -> not (List.mem_assoc n l.dispositions)) shared_ground in'),
    ("M11", "affirm factorisation on an incomplete carrier", "lineage_fibre.ml",
     'F.check ~complete:r.complete r.rows', 'F.check ~complete:true r.rows'),
    ("M12", "discard a refuting fibre witness", "lineage_fibre.ml",
     'F.Inadmissible (a, b) -> FactorisationWitness (a, b)',
     'F.Inadmissible (_a, _b) -> NoWitnessFound'),
    ("M13", "use caller tuple order instead of node identity", "lineage_fibre.ml",
     'let m row = List.map (fun n -> List.assoc n row.shared_values) shared',
     'let m row = List.map snd row.shared_values'),
    ("M14", "ignore ground identifier binding", "lineage_fibre.ml",
     'r.ground_node <> l.ground', 'false'),
    ("M15", "affirm an empty carrier", "lineage_fibre.ml",
     'if r.rows = [] then EmptyCarrier', 'if r.rows = [] then FactorsThroughShared []'),
    ("M16", "mark undisclosed dependencies as resolved", "lineage_audit.ml",
     'declared_resolution_complete = l2 && l4 && open_coordinate_defeaters = [] && open_ground_defeaters = [];',
     'declared_resolution_complete = open_coordinate_defeaters = [] && open_ground_defeaters = [];'),
    ("M17", "ignore scope identifier binding", "lineage_fibre.ml",
     'r.scope_id <> l.scope_id', 'false'),
    ("M18", "close an outstanding coverage gap", "lineage_audit.ml",
     'declared_coverage_closed = l.coverage_gaps = [];',
     'declared_coverage_closed = true;'),
]

FILES = ["paper2a_verified_core.mli", "paper2a_verified_core.ml", "admissibility.ml", "verified_fibre.ml", "lineage_audit.mli", "lineage_audit.ml",
         "lineage_fibre.mli", "lineage_fibre.ml", "test_lineage.ml"]


def run_suite(source: Path, compiler: str, change=None):
    with tempfile.TemporaryDirectory(prefix="paper2a_mutation_") as scratch:
        cwd = Path(scratch)
        for name in FILES:
            shutil.copyfile(source / name, cwd / name)
        if change:
            _, _, name, before, after = change
            p = cwd / name
            text = p.read_text()
            if text.count(before) != 1:
                return {"status": "INVALID", "error": "mutation target is not unique"}
            p.write_text(text.replace(before, after, 1))
        commands = [[compiler, "-c", name] for name in FILES[:-1]]
        commands.append([compiler, "-o", "test_lineage", "admissibility.cmo", "paper2a_verified_core.cmo", "verified_fibre.cmo",
                         "lineage_audit.cmo", "lineage_fibre.cmo", "test_lineage.ml"])
        for command in commands:
            built = subprocess.run(command, cwd=cwd, capture_output=True, text=True, timeout=60)
            if built.returncode:
                return {"status": "INVALID", "compile_exit": built.returncode,
                        "stdout": built.stdout, "stderr": built.stderr}
        tested = subprocess.run([str(cwd / "test_lineage")], cwd=cwd,
                                capture_output=True, text=True, timeout=60)
        rejected = tested.returncode != 0 and "FAIL:" in tested.stderr
        return {"status": "DETECTED" if rejected else "PASSED" if tested.returncode == 0 else "ERROR",
                "test_exit": tested.returncode, "stdout": tested.stdout, "stderr": tested.stderr}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ocamlc", default="ocamlc")
    parser.add_argument("--json", type=Path, default=Path(__file__).resolve().parent / "mutation_results.json")
    args = parser.parse_args()
    compiler = shutil.which(args.ocamlc)
    if compiler is None:
        parser.error("OCaml compiler not found")
    source = Path(__file__).resolve().parent
    report = {"baseline": run_suite(source, compiler), "mutants": []}
    if report["baseline"]["status"] != "PASSED":
        args.json.write_text(json.dumps(report, indent=2) + "\n")
        print("Unchanged suite did not pass.", flush=True)
        return 1
    print("Unchanged independent suite: PASS", flush=True)
    for mutant in MUTANTS:
        outcome = run_suite(source, compiler, mutant)
        outcome.update(id=mutant[0], fault=mutant[1])
        report["mutants"].append(outcome)
        print(f'{mutant[0]} {outcome["status"]}: {mutant[1]}', flush=True)
    detected = sum(m["status"] == "DETECTED" for m in report["mutants"])
    report.update(detected=detected, total=len(MUTANTS))
    args.json.write_text(json.dumps(report, indent=2) + "\n")
    print(f"Mutation result: {detected}/{len(MUTANTS)} detected", flush=True)
    return 0 if detected == len(MUTANTS) else 1


if __name__ == "__main__":
    raise SystemExit(main())
