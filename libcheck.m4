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
dnl Internal: _BT_CHECK_LIBCHECK([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBCHECK],[
	m4_ifval([$4],[libheck_configured=yes])	
	BT_CHECK_LIB([libcheck],[$3],[check_pic],[
		AC_CHECK_LIB([check],[srunner_create],[
			AC_CHECK_HEADER([check.h],[
				have_libcheck=yes
				LIBCHECK_LIBS="-lcheck_pic"
			])
		])
	],[
		LIBCHECK_LOCAL_LIBS="${libcheck_builddir}/libcheck_pic.a"
		LIBCHECK_INSTALLED_LIBS="-L${libdir} -lcheck"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBCHECK([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBCHECK],[
_BT_CHECK_LIBCHECK([$1],[$2])
])dnl
dnl - BT_CHECK_LIBCHECK_INCLUDED([action-if-found],[action-if-not-found],[subdir=check],[preconfigured])
AC_DEFUN([BT_CHECK_LIBCHECK_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBCHECK([$1],[$2],m4_ifval([$3],[$3],[check]),[$4])
])dnl
dnl - BT_REQUIRE_LIBCHECK([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBCHECK],[
_BT_CHECK_LIBCHECK([$1],[
	AC_MSG_ERROR([cannot find required library libcheck])
])
])dnl
dnl - BT_REQUIRE_LIBCHECK_INCLUDED([action-if-found],[subdir=check],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBCHECK_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBCHECK([$1],[
	AC_MSG_ERROR([cannot find required library libchec])
],m4_ifval([$2],[$2],[check]),[$3])
])dnl
