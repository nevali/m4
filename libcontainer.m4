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
dnl Internal: _BT_CHECK_LIBCONTAINER([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBCONTAINER],[
	m4_ifval([$4],[libcontainer_configured=yes])
	dnl libcontainer incorporates liburi and jsondata
	m4_ifval([$3],[
		BT_CHECK_LIBURI_INCLUDED(,,[$3/liburi])
		BT_CHECK_LIBJSONDATA_INCLUDED(,,[$3/jsondata])
	],[
		BT_CHECK_LIBURI
		BT_CHECK_LIBJSONDATA
	])
	if test x"$have_liburi" = x"yes" && test x"$have_libjsondata" = x"yes" ; then
		BT_CHECK_LIB([libcontainer],[$3],[libcontainer],,[
			LIBCONTAINER_CPPFLAGS="$LIBCONTAINER_CPPFLAGS $LIBURI_CPPFLAGS $LIBJSONDATA_CPPFLAGS"
			LIBCONTAINER_LDFLAGS="$LIBCONTAINER_LDFLAGS $LIBURI_LDFLAGS $LIBJSONDATA_LDFLAGS"
			LIBCONTAINER_LOCAL_LIBS="${libcontainer_builddir}/libcontainer.la $LIBURI_LOCAL_LIBS $LIBJSONDATA_LOCAL_LIBS"
			LIBCONTAINER_INSTALLED_LIBS="-L${libdir} -lcontainer $LIBURI_INSTALLED_LIBS $LIBJSONDATA_INSTALLED_LIBS"
		],[$1],[$2])
	else
		m4_ifval([$2],[$2],true)
	fi
])dnl
dnl
dnl - BT_CHECK_LIBCONTAINER([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBCONTAINER],[
	_BT_CHECK_LIBCONTAINER([$1],[$2])
])dnl
dnl - BT_CHECK_LIBCONTAINER_INCLUDED([action-if-found],[action-if-not-found],[subdir=libcontainer],[preconfigured])
AC_DEFUN([BT_CHECK_LIBCONTAINER_INCLUDED],[
	AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
	_BT_CHECK_LIBCONTAINER([$1],[$2],m4_ifval([$3],[$3],[libcontainer]),[$4])
])dnl
dnl - BT_REQUIRE_LIBCONTAINER([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBCONTAINER],[
	_BT_CHECK_LIBCONTAINER([$1],[
		AC_MSG_ERROR([cannot find required library libcontainer])
	])
])dnl
dnl - BT_REQUIRE_LIBCONTAINER_INCLUDED([action-if-found],[subdir=libcontainer],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBCONTAINER_INCLUDED],[
	AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
	_BT_CHECK_LIBCONTAINER([$1],[
		AC_MSG_ERROR([cannot find required library libcontainer])
	],m4_ifval([$2],[$2],[libcontainer]),[$3])
])dnl
