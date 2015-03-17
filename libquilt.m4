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
dnl Internal: _BT_CHECK_LIBQUILT([action-if-exists],[action-if-not-exists],[subdir],[preconfigured])
AC_DEFUN([_BT_CHECK_LIBQUILT],[
	m4_ifval([$4],[libquilt_configured=yes])
	BT_CHECK_LIB([libquilt],[$3],[libquilt],[
		AC_CHECK_PROGS([LIBQUILT_CONFIG],[libquilt-config])
		if test -n "$LIBQUILT_CONFIG" ; then
			LIBQUILT_CPPFLAGS="`$LIBQUILT_CONFIG --cflags`"
			LIBQUILT_LIBS="`$LIBQUILT_CONFIG --libs`"
			CPPFLAGS="$CPPFLAGS $LIBQUILT_CPPFLAGS"
			LIBS="$LIBQUILT_LIBS $LIBS"
			AC_CHECK_HEADER([libquilt.h],[
				AC_CHECK_LIB([quilt],[quilt_logf],[
					have_libquilt=yes
				])
			])
		fi
	],[
		LIBQUILT_LOCAL_LIBS="${libquilt_builddir}/libquilt.la"
		LIBQUILT_INSTALLED_LIBS="-L${libdir} -lquilt"
	],[
		AC_MSG_CHECKING([where Quilt modules should be installed])
		if test x"$pkg_modversion" = x"" ; then
			quiltmoduledir='${libdir}/quilt'
		else
			_PKG_CONFIG([moduledir],[variable=moduledir],[libquilt])
			AS_VAR_SET([quiltmoduledir],$pkg_cv_[]moduledir)
			if test x"$twinemoduledir" = x"" ; then
				AC_MSG_ERROR([libtwine.pc does not define moduledir])
			fi
		fi
		AC_SUBST([quiltmoduledir])
		AC_MSG_RESULT([$quiltmoduledir])
		$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBQUILT([action-if-found],[action-if-not-found])
dnl Default action is to update AM_CPPFLAGS, AM_LDFLAGS, LIBS and LOCAL_LIBS
dnl as required, and do nothing if not found
AC_DEFUN([BT_CHECK_LIBQUILT],[
_BT_CHECK_LIBQUILT([$1],[$2])
])dnl
dnl - BT_CHECK_LIBQUILT_INCLUDED([action-if-found],[action-if-not-found],[subdir=libquilt],[preconfigured])
AC_DEFUN([BT_CHECK_LIBQUILT_INCLUDED],[
AS_LITERAL_IF([$3],,[AC_DIAGNOSE([syntax],[$0: subdir must be a literal])])dnl
_BT_CHECK_LIBQUILT([$1],[$2],m4_ifval([$3],[$3],[libquilt]),[$4])
])dnl
dnl - BT_REQUIRE_LIBQUILT([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBQUILT],[
_BT_CHECK_LIBQUILT([$1],[
	AC_MSG_ERROR([cannot find required library libquilt])
])
])dnl
dnl - BT_REQUIRE_LIBQUILT_INCLUDED([action-if-found],[subdir=libquilt],[preconfigured])
AC_DEFUN([BT_REQUIRE_LIBQUILT_INCLUDED],[
AS_LITERAL_IF([$2],,[AC_DIAGNOSE([syntax],[$0: subdir passed must be a literal])])dnl
_BT_CHECK_LIBQUILT([$1],[
	AC_MSG_ERROR([cannot find required library libquilt])
],m4_ifval([$2],[$2],[LIBTWINE]),[$3])
])dnl
