COQC ?= coqc
OCAMLC ?= ocamlc

.PHONY: check check-versions coq ocaml interface lineage-build lineage-tests clean

check: check-versions coq ocaml interface lineage-tests

check-versions:
	@$(COQC) --version | grep -q "version 8.18.0" || \
	  (echo "Coq 8.18.0 required" >&2; exit 1)
	@test "$$($(OCAMLC) -version)" = "4.14.1" || \
	  (echo "OCaml 4.14.1 required" >&2; exit 1)

coq:
	$(COQC) Admissibility.v
	$(COQC) -Q . Exactness GroundedSeam.v
	$(COQC) -Q . Exactness SeamExtraction.v

lineage-build:
	$(OCAMLC) -c paper2a_verified_core.mli
	$(OCAMLC) -c paper2a_verified_core.ml
	$(OCAMLC) -c admissibility.ml
	$(OCAMLC) -c verified_fibre.ml
	$(OCAMLC) -c lineage_audit.mli
	$(OCAMLC) -c lineage_audit.ml
	$(OCAMLC) -c lineage_fibre.mli
	$(OCAMLC) -c lineage_fibre.ml

ocaml: lineage-build
	$(OCAMLC) -o examples admissibility.ml examples.ml
	./examples > examples_output.current.txt
	cmp recorded-output/examples_output.txt examples_output.current.txt
	$(OCAMLC) -o jurisdiction admissibility.cmo paper2a_verified_core.cmo verified_fibre.cmo lineage_audit.cmo jurisdiction.ml
	./jurisdiction > jurisdiction_output.current.txt
	cmp expected/jurisdiction_output.txt jurisdiction_output.current.txt

lineage-tests: lineage-build
	$(OCAMLC) -o test_lineage admissibility.cmo paper2a_verified_core.cmo verified_fibre.cmo lineage_audit.cmo lineage_fibre.cmo test_lineage.ml
	./test_lineage > lineage_tests.current.txt
	cat lineage_tests.current.txt
	$(OCAMLC) -o lineage_examples admissibility.cmo paper2a_verified_core.cmo verified_fibre.cmo lineage_audit.cmo lineage_fibre.cmo lineage_examples.ml
	./lineage_examples > lineage_examples.current.txt
	cmp expected/lineage_examples_output.txt lineage_examples.current.txt

interface: coq
	$(OCAMLC) -c seam_checks.mli
	$(OCAMLC) -c seam_checks.ml
	$(OCAMLC) -c certified_temporal_seam.mli
	$(OCAMLC) -c certified_temporal_seam.ml
	$(OCAMLC) -o interface_ok seam_checks.cmo certified_temporal_seam.cmo interface_ok.ml
	./interface_ok > interface_ok.current.txt
	grep -q "non-commuting evolution rejected at element 0" interface_ok.current.txt
	grep -q "grounded candidate certified" interface_ok.current.txt
	grep -q "rejected at request 1" interface_ok.current.txt
	@if $(OCAMLC) -c interface_direct_forge.ml > direct_forge.log 2>&1; then \
	  echo "direct construction unexpectedly compiled" >&2; exit 1; \
	else echo "direct construction rejected"; fi
	@if $(OCAMLC) -c interface_stage_mismatch.ml > stage_mismatch.log 2>&1; then \
	  echo "stage mismatch unexpectedly compiled" >&2; exit 1; \
	else echo "stage mismatch rejected"; fi
	$(OCAMLC) -o interface_unsafe_cast seam_checks.cmo certified_temporal_seam.cmo interface_unsafe_cast.ml
	./interface_unsafe_cast | grep -q "unsafe cast compiled"

clean:
	rm -f *.aux *.cmi *.cmo *.cmx *.o *.vo *.vos *.vok *.glob \
	  examples jurisdiction interface_ok interface_unsafe_cast test_lineage lineage_examples \
	  examples_output.current.txt jurisdiction_output.current.txt interface_ok.current.txt \
	  lineage_tests.current.txt lineage_examples.current.txt \
	  direct_forge.log stage_mismatch.log seam_checks.ml seam_checks.mli .*.aux .lia.cache
