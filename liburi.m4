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
AC_DEFUN([_BT_CHECK_LIBURI],[
have_liburi=yes
AC_CONFIG_SUBDIRS([liburi])
AM_CPPFLAGS="$AM_CPPFLAGS -I\${top_builddir}/liburi -I\${top_srcdir}/liburi"
LOCAL_LIBS="$LOCAL_LIBS \${top_builddir}/liburi/liburi.la"
LIBURI_SUBDIRS="liburi"
AC_SUBST([have_liburi])
AC_SUBST([AM_CPPFLAGS])
AC_SUBST([LOCAL_LIBS])
AC_SUBST([LIBURI_SUBDIRS])
if test x"$have_liburi" = x"yes" ; then
	AC_DEFINE_UNQUOTED([WITH_LIBURI],[1],[Define if liburi is available])
fi
])dnl
dnl
AC_DEFUN([BT_CHECK_LIBURI],[
AC_REQUIRE([_BT_CHECK_LIBURI])dnl
])dnl
dnl
AC_DEFUN([BT_REQUIRE_LIBURI],[
AC_REQUIRE([_BT_CHECK_LIBURI])dnl
if test x"$have_liburi" = x"no" ; then
	AC_MSG_ERROR([cannot find required library liburi])
fi
])dnl
