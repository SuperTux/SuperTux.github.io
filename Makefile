HTMLOUT = \
  news.html \
  welcome.html \
  authors.html \
  contact.html \
  screenshots.html \
  \
  development/index.html   \
  development/map.html     \
  development/dieing.html  \
  development/actions.html \
  development/enemies.html \
  \
  milestone2/index.html    \
  \
  milestone1/index.html    \
  milestone1/levels.html   \
  milestone1/music.html   \
  milestone1/gameplay.html  \
  milestone1/tilesets.html  \
  milestone1/enemies.html   \
  milestone1/misc.html

CPFLAGS=-pu

OUTFILES=$(patsubst %,output/%,$(HTMLOUT)) 

all: content

default.xsl: development/submenu.xml milestone1/submenu.xml submenu.xml menu.xml

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

content: directories $(OUTFILES) development/default.css
	cp $(CPFLAGS) output/welcome.html output/index.html
	cp $(CPFLAGS) default.css output/
	cp $(CPFLAGS) images/*.jpg output/images/
	cp $(CPFLAGS) images/*.png output/images/
	cp $(CPFLAGS) milestone1/images/*.jpg output/milestone1/images/
	cp $(CPFLAGS) milestone1/images/*.png output/milestone1/images/
	cp $(CPFLAGS) milestone1/images/*.gif output/milestone1/images/
#cp $(CPFLAGS) milestone2/images/*.jpg output/milestone2/images/
#	cp $(CPFLAGS) milestone2/images/*.png output/milestone2/images/
#	cp $(CPFLAGS) milestone2/images/*.gif output/milestone2/images/
	cp $(CPFLAGS) development/images/*.jpg output/development/images/
	cp $(CPFLAGS) development/images/*.png output/development/images/

directories:
	mkdir -p output
	mkdir -p output/development/
	mkdir -p output/milestone1/
	mkdir -p output/milestone2/
	mkdir -p output/images/
	mkdir -p output/development/images/
	mkdir -p output/milestone1/images/
	mkdir -p output/milestone2/images/

upload: checkusername content
	rsync -rv -e ssh --exclude wiki/ output/ $(ST_USERNAME)@supertux.lethargik.org:/home/supertux/supertux.lethargik.org/

clean:
	rm -rf output/*

# EOF #
