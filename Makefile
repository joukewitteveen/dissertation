.PHONY: clean

main.pdf: main.tex front.tex illcdissertations.tex
	@ mkdir -p build
	@ pdflatex -file-line-error -halt-on-error --output-directory=build $< | grep ":[[:digit:]][[:digit:]]*:" || true
	@ mv build/$(<:.tex=.pdf) $@

illcdissertations.tex:
	curl -O https://www.illc.uva.nl/PhDProgramme/current-candidates/other/Latexhelp/ILLCDiss/illcdissertations.tex

clean:
	@- rm -vfr build/
	@- rm -vf main.pdf illcdissertations.tex
