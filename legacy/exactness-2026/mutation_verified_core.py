#!/usr/bin/env python3
"""Mutate generated decision code, independently of wrapper/diagnostic mutants."""
import json
from pathlib import Path
from mutation_check import run_suite
import shutil

MUTANTS = [
 ("V01", "require both coordinates for L4", "paper2a_verified_core.ml",
  '(||) (mem n (ancestors g g.lin_dA)) (mem n (ancestors g g.lin_dB))',
  '(&&) (mem n (ancestors g g.lin_dA)) (mem n (ancestors g g.lin_dB))'),
 ("V02", "ignore L4 in qualification", "paper2a_verified_core.ml",
  '| None -> check_L4 g ds', '| None -> true'),
 ("V03", "invert fibre disagreement", "paper2a_verified_core.ml",
  '(negb (eqb (phi (fst p)) (phi (snd p))))', '(eqb (phi (fst p)) (phi (snd p)))'),
 ("V04", "ignore completeness", "paper2a_verified_core.ml",
  'if complete\n', 'if true\n'),
 ("V05", "drop fibre witnesses", "paper2a_verified_core.ml",
  'FibreWitness (x, y)', 'FibreOpen'),
 ("V06", "invert factor values", "paper2a_verified_core.ml",
  '((obs x), (phi x))', '((obs x), (negb (phi x)))'),
]

def main():
 source = Path(__file__).resolve().parent
 compiler = shutil.which('ocamlc')
 if compiler is None:
  raise SystemExit('OCaml compiler not found')
 baseline = run_suite(source, compiler)
 if baseline['status'] != 'PASSED':
  print(json.dumps(baseline)); return 1
 report = {'baseline': baseline, 'mutants': []}
 for mutant in MUTANTS:
  result = run_suite(source, compiler, mutant)
  result.update(id=mutant[0], fault=mutant[1]); report['mutants'].append(result)
  print(mutant[0], result['status'], mutant[1], flush=True)
 (source/'verified_mutation_results.json').write_text(json.dumps(report,indent=2)+'\n')
 return 0 if all(m['status']=='DETECTED' for m in report['mutants']) else 1

if __name__ == '__main__':
 raise SystemExit(main())
