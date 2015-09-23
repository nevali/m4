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
dnl Internal: _BT_CHECK_LIBRAPTOR2([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBRAPTOR2],[
	m4_ifval([$4],[libraptor2_configured=yes])
	BT_CHECK_LIB([libraptor2],[$3],[raptor2],[
		AC_CHECK_HEADER([libraptor2.h],[
			AC_CHECK_LIB([rdf],[libraptor2_model_add],[
				have_libraptor2=yes
			])
		])
	],,[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBRAPTOR2([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBRAPTOR2],[
_BT_CHECK_LIBRAPTOR2([$1],[$2])
])dnl
dnl - BT_CHECK_LIBRAPTOR2_INCLUDED([action-if-found],[action-if-not-found],[subdir=libraptor2],[preconfigured])
AC_DEFUN([BT_CHECK_LIBRAPTOR2_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBRAPTOR2([$1],[$2],m4_ifval([$3],[$3],[libraptor2]),[$4])
])dnl
dnl - BT_REQUIRE_LIBRAPTOR2([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBRAPTOR2],[
_BT_CHECK_LIBRAPTOR2([$1],[
	AC_MSG_ERROR([cannot find required library libraptor2])
])
])dnl
dnl - BT_REQUIRE_LIBRAPTOR2_INCLUDED([action-if-found],[subdir=libraptor2],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBRAPTOR2_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBRAPTOR2([$1],[
	AC_MSG_ERROR([cannot find required library libraptor2])
],m4_ifval([$2],[$2],[libraptor2]),[$3])
])dnl
