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
AC_DEFUN([_BT_CHECK_LIBEDIT],[
have_libedit=no
local_libedit=no
test -d "$srcdir/libedit" && local_libedit=auto
AC_ARG_WITH([included_libedit],[AS_HELP_STRING([--with-included-libedit],[build and install the included libedit (default=auto)])],,[with_included_libedit=$local_libedit])

if test x"$with_included_libedit" = x"no" || test x"$with_included_libedit" = x"auto" ; then
	AC_CHECK_LIB([edit],[el_init],[with_included_libedit=no ; have_libedit=yes ; LIBEDIT_LIBS="-ledit"])
fi

if test x"$with_included_libedit" = x"yes" || test x"$with_included_libedit" = x"auto" ; then
	AC_CONFIG_SUBDIRS([libedit])
	have_libedit=yes
	AM_CPPFLAGS="$AM_CPPFLAGS -I\${top_builddir}/libedit/src -I\${top_srcdir}/libedit/src"
	LIBEDIT_LIBS="\${top_builddir}/libedit/src/libedit.la"
	LIBEDIT_SUBDIRS="libedit"
	AC_SUBST([AM_CPPFLAGS])
fi
AC_SUBST([have_libedit])
AC_SUBST([LIBEDIT_LIBS])
AC_SUBST([LIBEDIT_SUBDIRS])
if test x"$have_libedit" = x"yes" ; then
	AC_DEFINE_UNQUOTED([HAVE_LIBEDIT],[1],[Define if libedit is available])
fi
])dnl
dnl
AC_DEFUN([BT_CHECK_LIBEDIT],[
AC_REQUIRE([_BT_CHECK_LIBEDIT])dnl
])dnl
dnl
AC_DEFUN([BT_REQUIRE_LIBEDIT],[
AC_REQUIRE([_BT_CHECK_LIBEDIT])dnl
if test x"$have_libedit" = x"no" ; then
	AC_MSG_ERROR([cannot find required library libedit])
fi
])dnl
