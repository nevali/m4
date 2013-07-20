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
dnl Internal: _BT_CHECK_LIBURI([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBURI],[
	m4_ifval([$4],[libcontainer_configured=yes])
	BT_CHECK_LIB([liburi],[$3],[liburi],[
		AC_CHECK_PROGS([LIBURI_CONFIG],[liburi-config])
		if test -n "$LIBURI_CONFIG" ; then
			LIBURI_CPPFLAGS="`$LIBURI_CONFIG --cflags`"
			LIBURI_LIBS="`$LIBURI_CONFIG --libs`"
			CPPFLAGS="$CPPFLAGS $LIBURI_CPPFLAGS"
			LIBS="$LIBURI_LIBS $LIBS"
			AC_CHECK_HEADER([liburi.h],[
				AC_CHECK_LIB([uri],[uri_create_str],[
					have_liburi=yes
				])
			])
		fi
	],[
		LIBURI_LOCAL_LIBS="${liburi_builddir}/liburi.la"
		LIBURI_INSTALLED_LIBS="-L${libdir} -luri"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBURI([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBURI],[
_BT_CHECK_LIBURI([$1],[$2])
])dnl
dnl - BT_CHECK_LIBURI_INCLUDED([action-if-found],[action-if-not-found],[subdir=liburi],[preconfigured])
AC_DEFUN([BT_CHECK_LIBURI_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBURI([$1],[$2],m4_ifval([$3],[$3],[liburi]),[$4])
])dnl
dnl - BT_REQUIRE_LIBURI([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBURI],[
_BT_CHECK_LIBURI([$1],[
	AC_MSG_ERROR([cannot find required library liburi])
])
])dnl
dnl - BT_REQUIRE_LIBURI_INCLUDED([action-if-found],[subdir=liburi],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBURI_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBURI([$1],[
	AC_MSG_ERROR([cannot find required library liburi])
],m4_ifval([$2],[$2],[liburi]),[$3])
])dnl
