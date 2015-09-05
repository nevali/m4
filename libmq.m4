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
dnl Internal: _BT_CHECK_LIBMQ([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBMQ],[
	m4_ifval([$4],[libmq_configured=yes])
	BT_CHECK_LIB([libmq],[$3],[libmq],[
		AC_CHECK_PROGS([LIBMQ_CONFIG],[libmq-config])
		if test -n "$LIBMQ_CONFIG" ; then
			LIBMQ_CPPFLAGS="`$LIBMQ_CONFIG --cflags`"
			LIBMQ_LIBS="`$LIBMQ_CONFIG --libs`"
			CPPFLAGS="$CPPFLAGS $LIBMQ_CPPFLAGS"
			LIBS="$LIBMQ_LIBS $LIBS"
			AC_CHECK_HEADER([libmq.h],[
				AC_CHECK_LIB([mq],[mq_create],[
					have_libmq=yes
				])
			])
		fi
	],[
		LIBMQ_LOCAL_LIBS="${libmq_builddir}/libmq.la"
		LIBMQ_INSTALLED_LIBS="-L${libdir} -lmq"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBMQ([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBMQ],[
_BT_CHECK_LIBMQ([$1],[$2])
])dnl
dnl - BT_CHECK_LIBMQ_INCLUDED([action-if-found],[action-if-not-found],[subdir=libmq],[preconfigured])
AC_DEFUN([BT_CHECK_LIBMQ_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBMQ([$1],[$2],m4_ifval([$3],[$3],[libmq]),[$4])
])dnl
dnl - BT_REQUIRE_LIBMQ([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBMQ],[
_BT_CHECK_LIBMQ([$1],[
	AC_MSG_ERROR([cannot find required library libmq])
])
])dnl
dnl - BT_REQUIRE_LIBMQ_INCLUDED([action-if-found],[subdir=libmq],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBMQ_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBMQ([$1],[
	AC_MSG_ERROR([cannot find required library libmq])
],m4_ifval([$2],[$2],[libmq]),[$3])
])dnl
