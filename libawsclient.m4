dnl Copyright 2015 BBC.
dnl
dnl Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
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
dnl Internal: _BT_CHECK_LIBAWSCLIENT([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBAWSCLIENT],[
	m4_ifval([$4],[libawsclient_configured=yes])
	BT_CHECK_LIB([libawsclient],[$3],[libawsclient],[
		AC_CHECK_PROGS([LIBAWSCLIENT_CONFIG],[libawsclient-config])
		if test -n "$LIBAWSCLIENT_CONFIG" ; then
			LIBAWSCLIENT_CPPFLAGS="`$LIBAWSCLIENT_CONFIG --cflags`"
			LIBAWSCLIENT_LIBS="`$LIBAWSCLIENT_CONFIG --libs`"
			CPPFLAGS="$CPPFLAGS $LIBAWSCLIENT_CPPFLAGS"
			LIBS="$LIBAWSCLIENT_LIBS $LIBS"
			AC_CHECK_HEADER([libawsclient.h],[
				AC_CHECK_LIB([awsclient],[aws_s3_create],[
					have_libawsclient=yes
				])
			])
		fi
	],[
		LIBAWSCLIENT_LOCAL_LIBS="${libawsclient_builddir}/libawsclient.la"
		LIBAWSCLIENT_INSTALLED_LIBS="-L${libdir} -lcluster"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBAWSCLIENT([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBAWSCLIENT],[
_BT_CHECK_LIBAWSCLIENT([$1],[$2])
])dnl
dnl - BT_CHECK_LIBAWSCLIENT_INCLUDED([action-if-found],[action-if-not-found],[subdir=libawsclient],[preconfigured])
AC_DEFUN([BT_CHECK_LIBAWSCLIENT_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBAWSCLIENT([$1],[$2],m4_ifval([$3],[$3],[libawsclient]),[$4])
])dnl
dnl - BT_REQUIRE_LIBAWSCLIENT([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBAWSCLIENT],[
_BT_CHECK_LIBAWSCLIENT([$1],[
	AC_MSG_ERROR([cannot find required library libawsclient])
])
])dnl
dnl - BT_REQUIRE_LIBAWSCLIENT_INCLUDED([action-if-found],[subdir=libawsclient],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBAWSCLIENT_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBAWSCLIENT([$1],[
	AC_MSG_ERROR([cannot find required library libawsclient])
],m4_ifval([$2],[$2],[libawsclient]),[$3])
])dnl
