dnl Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
dnl
dnl Copyright 2015 BBC
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
dnl Internal: _BT_CHECK_LIBPQ([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBPQ],[
	m4_ifval([$4],[libpq_configured=yes])	
	BT_CHECK_LIB([libpq],[$3],[libpq],[
	],[
		LIBPQ_LOCAL_LIBS="${libpq_builddir}/libpq.la"
		LIBPQ_INSTALLED_LIBS="-L${libdir} -lpq"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBPQ([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBPQ],[
_BT_CHECK_LIBPQ([$1],[$2])
])dnl
dnl - BT_CHECK_LIBPQ_INCLUDED([action-if-found],[action-if-not-found],[subdir=libpq],[preconfigured])
AC_DEFUN([BT_CHECK_LIBPQ_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBPQ([$1],[$2],m4_ifval([$3],[$3],[libpq]),[$4])
])dnl
dnl - BT_REQUIRE_LIBPQ([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBPQ],[
_BT_CHECK_LIBPQ([$1],[
	AC_MSG_ERROR([cannot find required library libpq])
])
])dnl
dnl - BT_REQUIRE_LIBPQ_INCLUDED([action-if-found],[subdir=libpq],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBPQ_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBPQ([$1],[
	AC_MSG_ERROR([cannot find required library libpq])
],m4_ifval([$2],[$2],[libpq]),[$3])
])dnl
