SuperTux Webpage Source
=======================

The SuperTux webpage is generated from a set of `.xml` pages. To
transform the `.xml` files to `.html` type:

    make

The tool `xsltproc` is required. The output will be written to the
`build/` directory.

The actual webpage itself is stored in:

* https://github.com/SuperTux/SuperTux.github.io

and just a straight copy of the `build/` directory.
