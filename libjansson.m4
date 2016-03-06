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
dnl Internal: _BT_CHECK_LIBJANSSON([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBJANSSON],[
	m4_ifval([$4],[libjansson_configured=yes])
	BT_CHECK_LIB([libjansson],[$3],[jansson],[
		AC_CHECK_HEADER([jansson.h],[
			AC_CHECK_LIB([jansson],[json_object],[
				have_libjansson=yes
			])
		])
	],[
		LIBJANSSON_LOCAL_LIBS="${libjansson_builddir}/libjansson.la"
		LIBJANSSON_INSTALLED_LIBS="-L${libdir} -ljansson"
	],[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBJANSSON([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBJANSSON],[
_BT_CHECK_LIBJANSSON([$1],[$2])
])dnl
dnl - BT_CHECK_LIBJANSSON_INCLUDED([action-if-found],[action-if-not-found],[subdir=jansson],[preconfigured])
AC_DEFUN([BT_CHECK_LIBJANSSON_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBJANSSON([$1],[$2],m4_ifval([$3],[$3],[jansson]),[$4])
])dnl
dnl - BT_REQUIRE_LIBJANSSON([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBJANSSON],[
_BT_CHECK_LIBJANSSON([$1],[
	AC_MSG_ERROR([cannot find required library libjansson])
])
])dnl
dnl - BT_REQUIRE_LIBJANSSON_INCLUDED([action-if-found],[subdir=jansson],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBJANSSON_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBJANSSON([$1],[
	AC_MSG_ERROR([cannot find required library libjansson])
],m4_ifval([$2],[$2],[jansson]),[$3])
])dnl
