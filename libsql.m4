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
dnl Internal: _BT_CHECK_LIBSQL([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBSQL],[
	m4_ifval([$4],[libsql_configured=yes])	
	BT_CHECK_LIB([libsql],[$3],[libsql],[
		AC_CHECK_PROGS([LIBSQL_CONFIG],[libsql-config])
		if test -n "$LIBSQL_CONFIG" ; then
			LIBSQL_CPPFLAGS="`$LIBSQL_CONFIG --cflags`"
			LIBSQL_LIBS="`$LIBSQL_CONFIG --libs`"
			CPPFLAGS="$CPPFLAGS $LIBSQL_CPPFLAGS"
			LIBS="$LIBSQL_LIBS $LIBS"
			AC_CHECK_HEADER([libsql.h],[
				AC_CHECK_LIB([sql],[sql_connect],[
					have_libsql=yes
				])
			])
		fi
	],[
		LIBSQL_LOCAL_LIBS="${libsql_builddir}/libsql.la"
		LIBSQL_INSTALLED_LIBS="-L${libdir} -lsql"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBSQL([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBSQL],[
_BT_CHECK_LIBSQL([$1],[$2])
])dnl
dnl - BT_CHECK_LIBSQL_INCLUDED([action-if-found],[action-if-not-found],[subdir=libsql],[preconfigured])
AC_DEFUN([BT_CHECK_LIBSQL_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBSQL([$1],[$2],m4_ifval([$3],[$3],[libsql]),[$4])
])dnl
dnl - BT_REQUIRE_LIBSQL([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBSQL],[
_BT_CHECK_LIBSQL([$1],[
	AC_MSG_ERROR([cannot find required library libsql])
])
])dnl
dnl - BT_REQUIRE_LIBSQL_INCLUDED([action-if-found],[subdir=libsql],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBSQL_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBSQL([$1],[
	AC_MSG_ERROR([cannot find required library libsql])
],m4_ifval([$2],[$2],[libsql]),[$3])
])dnl
