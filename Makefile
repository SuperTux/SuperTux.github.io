HTMLOUT = \
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
  milestone1/download.html

OUTFILES=$(patsubst %,output/%,$(HTMLOUT)) 

all: content

default.xsl: development/menu.xml milestone1/menu.xml

$(OUTFILES): output/%.html: %.xml Makefile default.xsl  milestone1/menu.xml
	FILENAME=$<; \
	LASTCHANGE=`date -I`; \
	echo $${FILENAME%%.xml}; \
	xalan \
          -PARAM filename   "'$${FILENAME%%.xml}'" \
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
	cp -v development/default.css output/development/
	cp -v development/default.css output/milestone1/
	cp -v development/images/*.jpg output/milestone1/images/
	cp -v development/images/*.png output/milestone1/images/
	cp -v development/images/*.jpg output/development/images/
	cp -v development/images/*.png output/development/images/

upload: content
	rsync -rv -e ssh output/milestone1 grumbel@super-tux.sourceforge.net:/home/groups/s/su/super-tux/htdocs/

# EOF #
