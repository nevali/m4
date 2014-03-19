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
dnl Internal: _BT_CHECK_LIBSPARQLCLIENT([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBSPARQLCLIENT],[
	m4_ifval([$4],[libsparqlclient_configured=yes])
	BT_CHECK_LIB([libsparqlclient],[$3],[libsparqlclient],[
		AC_CHECK_PROGS([LIBSPARQLCLIENT_CONFIG],[libsparqlclient-config])
		if test -n "$LIBSPARQLCLIENT_CONFIG" ; then
			LIBSPARQLCLIENT_CPPFLAGS="`$LIBSPARQLCLIENT_CONFIG --cflags`"
			LIBSPARQLCLIENT_LIBS="`$LIBSPARQLCLIENT_CONFIG --libs`"
			CPPFLAGS="$CPPFLAGS $LIBSPARQLCLIENT_CPPFLAGS"
			LIBS="$LIBSPARQLCLIENT_LIBS $LIBS"
			AC_CHECK_HEADER([libsparqlclient.h],[
				AC_CHECK_LIB([sparqlclient],[sparql_create],[
					have_libsparqlclient=yes
				])
			])
		fi
	],[
		LIBSPARQLCLIENT_LOCAL_LIBS="${libsparqlclient_builddir}/libsparqlclient.la"
		LIBSPARQLCLIENT_INSTALLED_LIBS="-L${libdir} -lsparqlclient"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBSPARQLCLIENT([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBSPARQLCLIENT],[
_BT_CHECK_LIBSPARQLCLIENT([$1],[$2])
])dnl
dnl - BT_CHECK_LIBSPARQLCLIENT_INCLUDED([action-if-found],[action-if-not-found],[subdir=libsparqlclient],[preconfigured])
AC_DEFUN([BT_CHECK_LIBSPARQLCLIENT_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBSPARQLCLIENT([$1],[$2],m4_ifval([$3],[$3],[libsparqlclient]),[$4])
])dnl
dnl - BT_REQUIRE_LIBSPARQLCLIENT([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBSPARQLCLIENT],[
_BT_CHECK_LIBSPARQLCLIENT([$1],[
	AC_MSG_ERROR([cannot find required library libsparqlclient])
])
])dnl
dnl - BT_REQUIRE_LIBSPARQLCLIENT_INCLUDED([action-if-found],[subdir=libsparqlclient],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBSPARQLCLIENT_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBSPARQLCLIENT([$1],[
	AC_MSG_ERROR([cannot find required library libsparqlclient])
],m4_ifval([$2],[$2],[libsparqlclient]),[$3])
])dnl
