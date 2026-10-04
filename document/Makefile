# Build the current Paper 2A manuscript; requires latexmk and pdflatex.
PAPER2A = Paper_2A_Copied_Agreement_v18

.PHONY: all clean
all: $(PAPER2A).pdf

$(PAPER2A).pdf: $(PAPER2A).tex
	latexmk -pdf -interaction=nonstopmode -halt-on-error $(PAPER2A).tex

clean:
	latexmk -c $(PAPER2A).tex
