HTMLOUT=development/index.html

$(patsubst %,output/%,$(HTMLOUT)): output/%.html: %.xml Makefile
	FILENAME=$<; \
	LASTCHANGE=`date -I`; \
	echo $${FILENAME%%.xml}; \
	xalan \
          -PARAM filename   "'$${FILENAME%%.xml}'" \
          -PARAM lastchange "'$${LASTCHANGE}'" \
          -IN $< \
          -OUT $@ \
          -XSL default.xsl

content:
	mkdir -p output
	mkdir -p output/development/
	mkdir -p output/development/images/
	cp -v index.php output/
	cp -v development/default.css output/development/
	cp -v development/images/*.jpg output/development/images/

upload: content
	rsync -rv -e ssh output/ grumbel@super-tux.sourceforge.net:/home/groups/s/su/super-tux/htdocs/

# EOF #
