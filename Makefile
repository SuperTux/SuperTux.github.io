HTMLOUT = \
  news.html \
  welcome.html \
  download.html \
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
  milestone1/download.html  \
  milestone1/misc.html

OUTFILES=$(patsubst %,output/%,$(HTMLOUT)) 
USERNAME=`cat CVS/Root | sed "s/:[^:]*:\([^:@]*\)@[^:]*:.*/\1/"`
XALAN_VERSION_X=`xalan 2>&1 | head -n 1 | sed "s/\./ /g" | awk '{print $$3}'`
XALAN_VERSION_Y=`xalan 2>&1 | head -n 1 | sed "s/\./ /g" | awk '{print $$4}'`
XALAN_VERSION_Z=`xalan 2>&1 | head -n 1 | sed "s/\./ /g" | awk '{print $$5}'`

all: content

default.xsl: development/submenu.xml milestone1/submenu.xml submenu.xml menu.xml

$(OUTFILES): output/%.html: %.xml Makefile default.xsl
	@FILENAME=$<; \
	SECTION=`dirname $<`; \
	LASTCHANGE=`date -I`; \
        echo Filename: $$FILENAME ; \
        echo Section: $$SECTION ; \
        if [ "x$$SECTION" = "xsfnet" -o "x$$SECTION" = "x." ]; then BASEDIR=""; \
	else BASEDIR="../"; fi; \
	if [ $(XALAN_VERSION_X) -eq 1 -a $(XALAN_VERSION_Y) -ge 7 ]; then \
            XALAN_PARAM="-p"; \
            XALAN_IN=""; \
            XALAN_OUT="-o"; \
            XALAN_XSL=""; \
        else \
            XALAN_PARAM="-PARAM"; \
            XALAN_IN="-IN"; \
            XALAN_OUT="-OUT"; \
            XALAN_XSL="-XSL"; \
        fi; \
	xalan \
          $$XALAN_PARAM filename   "'$${FILENAME%%.xml}'" \
          $$XALAN_PARAM section    "'$${SECTION}'" \
          $$XALAN_PARAM lastchange "'$${LASTCHANGE}'" \
          $$XALAN_PARAM basedir    "'$${BASEDIR}'" \
          $$XALAN_OUT $@ \
          $$XALAN_IN $< \
          $$XALAN_XSL default.xsl

content: directories $(OUTFILES) development/default.css
	cp -v output/welcome.html output/index.html
	cp -v default.css output/
	cp -v images/*.jpg output/images/
	cp -v images/*.png output/images/
	cp -v milestone1/images/*.jpg output/milestone1/images/
	cp -v milestone1/images/*.png output/milestone1/images/
	cp -v milestone1/images/*.gif output/milestone1/images/
	#cp -v milestone2/images/*.jpg output/milestone2/images/
	#cp -v milestone2/images/*.png output/milestone2/images/
	#cp -v milestone2/images/*.gif output/milestone2/images/
	cp -v development/images/*.jpg output/development/images/
	cp -v development/images/*.png output/development/images/

directories:
	mkdir -p output
	mkdir -p output/development/
	mkdir -p output/milestone1/
	mkdir -p output/milestone2/
	mkdir -p output/images/
	mkdir -p output/development/images/
	mkdir -p output/milestone1/images/
	#mkdir -p output/milestone2/images/


upload: content
	rsync -rv -e ssh output/ $(USERNAME)@super-tux.sourceforge.net:/home/groups/s/su/super-tux/htdocs/

clean:
	rm -rf output/*

# EOF #
