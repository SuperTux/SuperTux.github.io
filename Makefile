HTMLOUT = \
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
  milestone1/index.html    \
  milestone1/levels.html   \
  milestone1/music.html   \
  milestone1/gameplay.html  \
  milestone1/tilesets.html  \
  milestone1/enemies.html   \
  milestone1/download.html  \
  milestone1/misc.html

OUTFILES=$(patsubst %,output/%,$(HTMLOUT)) 

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
	xalan \
          -PARAM filename   "'$${FILENAME%%.xml}'" \
          -PARAM section    "'$${SECTION}'" \
          -PARAM lastchange "'$${LASTCHANGE}'" \
          -PARAM basedir    "'$${BASEDIR}'" \
          -IN $< \
          -OUT $@ \
          -XSL default.xsl

content: $(OUTFILES) development/default.css
	mkdir -p output
	mkdir -p output/development/
	mkdir -p output/milestone1/
	mkdir -p output/development/images/
	mkdir -p output/milestone1/images/
	cp -v output/welcome.html output/index.html
	cp -v default.css output/
	cp -v default.css output/development/
	cp -v default.css output/milestone1/
	cp -v images/*.jpg output/images/
	cp -v images/*.png output/images/
	cp -v milestone1/images/*.jpg output/milestone1/images/
	cp -v milestone1/images/*.png output/milestone1/images/
	cp -v milestone1/images/*.gif output/milestone1/images/
	cp -v development/images/*.jpg output/development/images/
	cp -v development/images/*.png output/development/images/

upload: content
	rsync -rv -e ssh output/ grumbel@super-tux.sourceforge.net:/home/groups/s/su/super-tux/htdocs/

# EOF #
