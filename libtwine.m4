dnl Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
dnl
dnl Copyright 2014 BBC
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
dnl Internal: _BT_CHECK_LIBTWINE([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBTWINE],[
	m4_ifval([$4],[libtwine_configured=yes])
	BT_CHECK_LIB([libtwine],[$3],[libtwine],[
		AC_CHECK_PROGS([LIBTWINE_CONFIG],[libtwine-config])
		if test -n "$LIBTWINE_CONFIG" ; then
			LIBTWINE_CPPFLAGS="`$LIBTWINE_CONFIG --cflags`"
			LIBTWINE_LIBS="`$LIBTWINE_CONFIG --libs`"
			CPPFLAGS="$CPPFLAGS $LIBTWINE_CPPFLAGS"
			LIBS="$LIBTWINE_LIBS $LIBS"
			AC_CHECK_HEADER([libtwine.h],[
				AC_CHECK_LIB([twine],[twine_logf],[
					have_libtwine=yes
				])
			])
		fi
	],[
		LIBTWINE_LOCAL_LIBS="${libtwine_builddir}/libtwine.la"
		LIBTWINE_INSTALLED_LIBS="-L${libdir} -ltwine"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBTWINE([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBTWINE],[
_BT_CHECK_LIBTWINE([$1],[$2])
])dnl
dnl - BT_CHECK_LIBTWINE_INCLUDED([action-if-found],[action-if-not-found],[subdir=LIBTWINE],[preconfigured])
AC_DEFUN([BT_CHECK_LIBTWINE_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBTWINE([$1],[$2],m4_ifval([$3],[$3],[LIBTWINE]),[$4])
])dnl
dnl - BT_REQUIRE_LIBTWINE([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBTWINE],[
_BT_CHECK_LIBTWINE([$1],[
	AC_MSG_ERROR([cannot find required library libtwine])
])
])dnl
dnl - BT_REQUIRE_LIBTWINE_INCLUDED([action-if-found],[subdir=LIBTWINE],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBTWINE_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBTWINE([$1],[
	AC_MSG_ERROR([cannot find required library libtwine])
],m4_ifval([$2],[$2],[LIBTWINE]),[$3])
])dnl
