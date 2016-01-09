HTMLOUT = \
  index.html \
  contact.html \
  download.html \
  screenshots.html

CPFLAGS=-pu

OUTFILES=$(patsubst %,build/%,$(HTMLOUT))

all: content

$(OUTFILES): build/%.html: %.xml Makefile tux.xslt bits/*.xml
#	@FILENAME=$<;
#	SECTION=`dirname $<`;
#	LASTCHANGE=`date -I`;
#	echo Filename: $$FILENAME ;
#	echo Section: $$SECTION ;
#        if [ "x$$SECTION" = "xsfnet" -o "x$$SECTION" = "x." ]; then BASEDIR="";# 	else BASEDIR="../"; fi;
	@if [ "`dirname $<`" != "." ]; then BASEDIR="../"; else BASEDIR=""; fi; \
	echo Creating $@; \
	xsltproc \
	    --stringparam filename "$@" \
	    --stringparam lastchange `ls -la --time-style=long-iso $< | awk '{print $$6}'` \
	    --stringparam section `dirname $<` \
	    --stringparam basedir "$$BASEDIR" \
	    -o $@ tux.xslt $<

content: directories $(OUTFILES)
	cp $(CPFLAGS) default.css build/
	cp $(CPFLAGS) robots.txt build/
	cp $(CPFLAGS) images/*.jpg build/images/
	cp $(CPFLAGS) images/*.png build/images/
	cp $(CPFLAGS) images/small/*.png build/images/small/
	cp $(CPFLAGS) images/0_4_0/small/*.png build/images/small/
#cp $(CPFLAGS) milestone2/images/*.jpg build/milestone2/images/
#	cp $(CPFLAGS) milestone2/images/*.png build/milestone2/images/
#	cp $(CPFLAGS) milestone2/images/*.gif build/milestone2/images/

directories:
	mkdir -p build
	mkdir -p build/images/
	mkdir -p build/images/small/

upload: all
	@if [ -d ../SuperTux.github.io ]; then \
	    rsync -rtlvP build/ ../SuperTux.github.io/; \
	    cd ../SuperTux.github.io/; \
	    git add .; \
	    git commit -m "Website updates $$(date -I)"; \
	    git push; \
	fi

.PHONY: all upload directories

# EOF #
