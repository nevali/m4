This is a library of m4 macros which may be useful in autoconf projects.

A Makefile.am if included, so that this tree can be dropped into a project
as a submodule.

Be sure to add the following to your top-level `Makefile.am`:

	ACLOCAL_AMFLAGS = -I m4

And add the following to your top-level `configure.ac`:
	
	AC_CONFIG_MACRO_DIR([m4])

The license terms for each `.m4` file are included within the files
themselves.

All macros are prefixed with `BT_` (standing for "buildtools", the project
which preceded this one).

The included macros are:

* `BT_PROG_CC_WARN`: Enable the `-W -Wall` C compiler flags if using GCC.
* `BT_DEFINE_PREFIX`: Define `PREFIX`, `EXEC_PREFIX`, `LIBDIR` and `INCLUDEDIR` so that they're available at build-time.
* `BT_ENABLE_DOCS`: Enable building HTML and manpages from DocBook-XML.
* `BT_ENABLE_NLS`: Check for NLS support.
* `BT_CHECK_MYSQL`: Check for MySQL client libraries.
* `BT_CHECK_LIBUUID`: Check for the library containing `uuid_compare()`.
* `BT_CHECK_LIBEDIT`: Check for the library containing `libedit`, which may be included in the source tree.
* `BT_CHECK_LIBURI`: Build an in-tree copy of `liburi`.
