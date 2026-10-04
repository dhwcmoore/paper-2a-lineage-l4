# Current main article and complete technical supplement.
PAPER2A = Paper_2A_Copied_Agreement_v20
SUPPLEMENT = $(PAPER2A)_supplement

.PHONY: all clean
all: $(PAPER2A).pdf $(SUPPLEMENT).pdf

$(PAPER2A).pdf $(SUPPLEMENT).pdf: %.pdf: %.tex $(PAPER2A).bib svjour3.cls svglov3.clo spbasic.bst scaling_v20_table.tex scaling_v20_result.tex scaling_v20.pdf
	latexmk -pdf -interaction=nonstopmode -halt-on-error $<

clean:
	latexmk -c $(PAPER2A).tex $(SUPPLEMENT).tex
