HTMLOUT = \
  index.html \
  \
  development/index.html   \
  development/map.html     \
  development/dieing.html  \
  development/actions.html \
  development/enemies.html \
  \
  milestone1/index.html    \
  milestone1/levels.html   \
  milestone1/gameplay.html  \
  milestone1/tilesets.html  \
  milestone1/enemies.html   \
  milestone1/download.html  \
  milestone1/misc.html

OUTFILES=$(patsubst %,output/%,$(HTMLOUT)) 

all: content

default.xsl: development/submenu.xml milestone1/submenu.xml submenu.xml

$(OUTFILES): output/%.html: %.xml Makefile default.xsl
	@FILENAME=$<; \
	SECTION=`dirname $<`; \
	LASTCHANGE=`date -I`; \
	xalan \
          -PARAM filename   "'$${FILENAME%%.xml}'" \
          -PARAM section    "'$${SECTION}'" \
          -PARAM lastchange "'$${LASTCHANGE}'" \
          -IN $< \
          -OUT $@ \
          -XSL default.xsl

content: $(OUTFILES) development/default.css
	mkdir -p output
	mkdir -p output/development/
	mkdir -p output/milestone1/
	mkdir -p output/development/images/
	mkdir -p output/milestone1/images/
	cp -v index.php output/
	cp -v default.css output/
	cp -v default.css output/development/
	cp -v default.css output/milestone1/
	cp -v milestone1/images/*.jpg output/milestone1/images/
	cp -v milestone1/images/*.png output/milestone1/images/
	cp -v development/images/*.jpg output/development/images/
	cp -v development/images/*.png output/development/images/

upload: content
	rsync -rv -e ssh output/ grumbel@super-tux.sourceforge.net:/home/groups/s/su/super-tux/htdocs/

# EOF #
