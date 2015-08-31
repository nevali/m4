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
dnl Internal: _BT_CHECK_LIBCLUSTER([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBCLUSTER],[
	m4_ifval([$4],[libcluster_configured=yes])
	BT_CHECK_LIB([libcluster],[$3],[libcluster],[
		AC_CHECK_PROGS([LIBCLUSTER_CONFIG],[libcluster-config])
		if test -n "$LIBCLUSTER_CONFIG" ; then
			LIBCLUSTER_CPPFLAGS="`$LIBCLUSTER_CONFIG --cflags`"
			LIBCLUSTER_LIBS="`$LIBCLUSTER_CONFIG --libs`"
			CPPFLAGS="$CPPFLAGS $LIBCLUSTER_CPPFLAGS"
			LIBS="$LIBCLUSTER_LIBS $LIBS"
			AC_CHECK_HEADER([libcluster.h],[
				AC_CHECK_LIB([cluster],[cluster_create],[
					have_libcluster=yes
				])
			])
		fi
	],[
		LIBCLUSTER_LOCAL_LIBS="${libcluster_builddir}/libcluster.la"
		LIBCLUSTER_INSTALLED_LIBS="-L${libdir} -lcluster"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBCLUSTER([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBCLUSTER],[
_BT_CHECK_LIBCLUSTER([$1],[$2])
])dnl
dnl - BT_CHECK_LIBCLUSTER_INCLUDED([action-if-found],[action-if-not-found],[subdir=libcluster],[preconfigured])
AC_DEFUN([BT_CHECK_LIBCLUSTER_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBCLUSTER([$1],[$2],m4_ifval([$3],[$3],[libcluster]),[$4])
])dnl
dnl - BT_REQUIRE_LIBCLUSTER([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBCLUSTER],[
_BT_CHECK_LIBCLUSTER([$1],[
	AC_MSG_ERROR([cannot find required library libcluster])
])
])dnl
dnl - BT_REQUIRE_LIBCLUSTER_INCLUDED([action-if-found],[subdir=libcluster],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBCLUSTER_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBCLUSTER([$1],[
	AC_MSG_ERROR([cannot find required library libcluster])
],m4_ifval([$2],[$2],[libcluster]),[$3])
])dnl
