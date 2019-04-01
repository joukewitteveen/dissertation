SHELL = /bin/bash
# Source files are retrieved automatically
BASE_URL ?= http://r0k.us/graphics/kodak/kodak/
# The file names of the PNG files must not contain whitespace
PNGS ?= $(shell echo kodim{01..24}.png)
# The suffix must represent a format supported by convert
EXT ?= jpg
# Brace expansion of ranges is available in Bash 4 and newer
Q ?= $(shell echo {5..100..5})

# Bash supports arithmetic expansion
sizes: $(Q:=/)
	printf '' > sizes
	$(foreach q,$^,printf '%s\t%s\n' >> sizes\
	  $(q:/=)\
	  $$(( n=$(words $(PNGS)),\
	    ( (n / 2) $(shell stat --format='+ %s'\
	      $(addprefix $(q),$(addsuffix .$(EXT),$(basename $(PNGS))))) )\
	    / n\
	  ))\
	;)

$(PNGS):
	curl -O $(BASE_URL)$@

%/: $(PNGS)
	mkdir $@
	$(foreach png,$^,convert $(png) -quality $* $@$(basename $(png)).$(EXT);)

.PHONY: clean
clean:
	@ rm -frv -- sizes $(PNGS) $(Q)
