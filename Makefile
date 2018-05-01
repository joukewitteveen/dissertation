SOURCES := notation.tex introduction.tex

BUILDDIR = build

.PHONY: clean

main.pdf: main.tex front.tex illcdissertations.tex $(SOURCES) $(BUILDDIR)/main.bbl
	@ pdflatex -file-line-error -halt-on-error --output-directory=$(BUILDDIR) $< | grep ":[[:digit:]][[:digit:]]*:" || true
	@ mv build/$(<:.tex=.pdf) $@

illcdissertations.tex:
	curl -O https://www.illc.uva.nl/PhDProgramme/current-candidates/other/Latexhelp/ILLCDiss/illcdissertations.tex

$(BUILDDIR)/main.bbl: refs.bib
	@ mkdir -p $@
	@- biber --output-directory=$(BUILDDIR) main

clean:
	@- rm -vfr build/  # Hardcoded for safety reasons
	@- rm -vf main.pdf illcdissertations.tex
