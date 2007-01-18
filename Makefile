HTMLOUT = \
  index.html \
  authors.html \
  contact.html \
  screenshots.html

CPFLAGS=-pu

OUTFILES=$(patsubst %,output/%,$(HTMLOUT))

all: content

default.xsl: menu.xml

checkusername:
	@if [ "$(ST_USERNAME)" = "" ]; then \
		echo "Please call this script with the ST_USERNAME environment variable set"; \
		exit 1; \
	fi

$(OUTFILES): output/%.html: %.xml Makefile default.xsl
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
	    -o $@ default.xsl $<

content: directories $(OUTFILES)
	cp $(CPFLAGS) default.css output/
	cp $(CPFLAGS) robots.txt output/
	cp $(CPFLAGS) images/*.jpg output/images/
	cp $(CPFLAGS) images/*.png output/images/
#cp $(CPFLAGS) milestone2/images/*.jpg output/milestone2/images/
#	cp $(CPFLAGS) milestone2/images/*.png output/milestone2/images/
#	cp $(CPFLAGS) milestone2/images/*.gif output/milestone2/images/

directories:
	mkdir -p output
	mkdir -p output/images/

upload: checkusername content
	rsync -crv --chmod=Dg+rwxs,ug+rw,o-w -e ssh --exclude-from=rsync-excludes.txt output/ $(ST_USERNAME)@supertux.lethargik.org:/home/supertux/supertux.lethargik.org/

clean:
	rm -rf output/*

# EOF #
