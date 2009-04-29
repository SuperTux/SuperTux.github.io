HTMLOUT = \
  index.html \
  authors.html \
  contact.html \
  download.html \
  screenshots.html

CPFLAGS=-pu

OUTFILES=$(patsubst %,build/%,$(HTMLOUT))

all: content menu.xml

default.xsl: menu.xml

checkusername:
	@if [ "$(ST_USERNAME)" = "" ]; then \
		echo "Please call this script with the ST_USERNAME environment variable set"; \
		exit 1; \
	fi

$(OUTFILES): build/%.html: %.xml Makefile default.xsl menu.xml
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
	cp $(CPFLAGS) default.css build/
	cp $(CPFLAGS) robots.txt build/
	cp $(CPFLAGS) images/*.jpg build/images/
	cp $(CPFLAGS) images/*.png build/images/
#cp $(CPFLAGS) milestone2/images/*.jpg build/milestone2/images/
#	cp $(CPFLAGS) milestone2/images/*.png build/milestone2/images/
#	cp $(CPFLAGS) milestone2/images/*.gif build/milestone2/images/

directories:
	mkdir -p build
	mkdir -p build/images/

upload: checkusername content
	rsync -crv --chmod=Dg+rwxs,ug+rw,o-w -e ssh --exclude-from=rsync-excludes.txt build/ $(ST_USERNAME)@supertux.lethargik.org:/home/supertux/supertux.lethargik.org/

clean:
	rm -rf build/*

# EOF #
