HTMLOUT = \
  development/index.html   \
  development/map.html     \
  development/dieing.html   \
  development/actions.html \
  development/enemies.html

OUTFILES=$(patsubst %,output/%,$(HTMLOUT)) 

all: content

default.xsl: development/menu.xml

$(OUTFILES): output/%.html: %.xml Makefile default.xsl  development/menu.xml
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
	mkdir -p output/development/images/
	cp -v index.php output/
	cp -v development/default.css output/development/
	cp -v development/images/*.jpg output/development/images/
	cp -v development/images/*.png output/development/images/

upload: content
	rsync -rv -e ssh output/ grumbel@super-tux.sourceforge.net:/home/groups/s/su/super-tux/htdocs/

# EOF #
