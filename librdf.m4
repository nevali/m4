dnl Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
dnl
dnl Copyright 2015 BBC
dnl
dnl Copyright 2013 Mo McRoberts.
dnl
dnl  Licensed under the Apache License, Version 2.0 (the "License");
dnl  you may not use this file except in compliance with the License.
dnl  You may obtain a copy of the License at
dnl
dnl      http://www.apache.org/licenses/LICENSE-2.0
dnl
dnl  Unless required by applicable law or agreed to in writing, software
dnl  distributed under the License is distributed on an "AS IS" BASIS,
dnl  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
dnl  See the License for the specific language governing permissions and
dnl  limitations under the License.
dnl
m4_pattern_forbid([^BT_])dnl
m4_pattern_forbid([^_BT_])dnl
dnl Internal: _BT_CHECK_LIBRDF([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBRDF],[
	m4_ifval([$4],[librdf_configured=yes])
	BT_CHECK_LIBRAPTOR2
	if test x"$have_libraptor2" = x"yes" ; then
		BT_CHECK_LIB([librdf],[$3],[redland],[
			AC_CHECK_PROGS([REDLAND_CONFIG],[redland-config])
			if test -n "$REDLAND_CONFIG" ; then
				LIBRDF_CPPFLAGS="`$REDLAND_CONFIG --cflags`"
				LIBRDF_LIBS="`$REDLAND_CONFIG --libs`"
				CPPFLAGS="$CPPFLAGS $LIBRDF_CPPFLAGS"
				LIBS="$LIBRDF_LIBS $LIBS"
				AC_CHECK_HEADER([librdf.h],[
					AC_CHECK_LIB([rdf],[librdf_model_add],[
						have_librdf=yes
					])
				])
			fi
		],,[$1],[$2])
	else
		m4_ifval([$2],[$2],true)
	fi
])dnl
dnl
dnl - BT_CHECK_LIBRDF([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBRDF],[
_BT_CHECK_LIBRDF([$1],[$2])
])dnl
dnl - BT_CHECK_LIBRDF_INCLUDED([action-if-found],[action-if-not-found],[subdir=librdf],[preconfigured])
AC_DEFUN([BT_CHECK_LIBRDF_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBRDF([$1],[$2],m4_ifval([$3],[$3],[librdf]),[$4])
])dnl
dnl - BT_REQUIRE_LIBRDF([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBRDF],[
_BT_CHECK_LIBRDF([$1],[
	AC_MSG_ERROR([cannot find required library librdf])
])
])dnl
dnl - BT_REQUIRE_LIBRDF_INCLUDED([action-if-found],[subdir=librdf],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBRDF_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBRDF([$1],[
	AC_MSG_ERROR([cannot find required library librdf])
],m4_ifval([$2],[$2],[librdf]),[$3])
])dnl
