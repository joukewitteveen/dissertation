BUILDDIR = build

getsource = $(shell sed -n 's/^[^%]*\\$(1){\([[:graph:]]\+\)}.*/\1$(3)/p' $(2))

INCLUDES := main.tex $(call getsource,include,main.tex,.tex)
main.pdf: $(INCLUDES) $(call getsource,input,$(INCLUDES),.tex) \
          $(addprefix $(BUILDDIR)/,main.bbl main.ind $(INCLUDES:.tex=.aux.sum))
	@ ! lualatex --file-line-error --halt-on-error --output-directory=$(BUILDDIR) $< | grep ":[[:digit:]][[:digit:]]*:"
	@ mv build/$(<:.tex=.pdf) $@
	@ echo $@ was rebuilt

illcdissertations.tex:
	curl -O https://www.illc.uva.nl/PhDProgramme/current-candidates/other/Latexhelp/ILLCDiss/$@

$(BUILDDIR)/main.bbl: refs.bib $(BUILDDIR)/main.bcf.sum
	@- biber --output-directory=$(BUILDDIR) $(basename $(notdir $@))

$(BUILDDIR)/main.ind: $(BUILDDIR)/main.idx.sum
	@- makeindex $(basename $@)

.PHONY: clean
clean:
	@- rm -vfr build/  # Hardcoded for safety reasons
	@- rm -vf main.pdf illcdissertations.tex

# Requiring FILE.sum triggers a rebuild when the contents of FILE change.
# The second expansion enables the wildcard, so that FILE need not exist.
.SECONDEXPANSION:
%.sum: file = $(wildcard $(@:.sum=))
%.sum: $$(file)
	@ mkdir -vp $(dir $@)
	@- $(if $(subst $(file <$@),,$(shell cksum $* 2>&1)),cksum $* > $@ 2>&1)
