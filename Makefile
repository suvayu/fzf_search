.PHONY:	all

all:	help.1

%.1:	%.md
	pandoc -s -f markdown -t man $< > $@
