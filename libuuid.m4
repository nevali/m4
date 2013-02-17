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
AC_DEFUN([_BT_CHECK_LIBUUID],[
have_libuuid=yes
## On Darwin, and possibly other platforms, libuuid's functions are built
## into libc.
AC_CHECK_FUNC([uuid_compare],,[
	AC_CHECK_LIB([uuid],[uuid_compare],,[have_libuuid=no])
	])
])
AC_SUBST([have_libuuid])
if test x"$have_libuuid" = x"yes" ; then
	AC_DEFINE_UNQUOTED([WITH_LIBUUID],[1],[Define if libuuid is available])
fi

dnl
AC_DEFUN([BT_CHECK_LIBUUID],[
AC_REQUIRE([_BT_CHECK_LIBUUID])dnl
])dnl
dnl
AC_DEFUN([BT_REQUIRE_LIBUUID],[
AC_REQUIRE([_BT_CHECK_LIBUUID])dnl
if test x"$have_libuuid" = x"no" ; then
	AC_MSG_ERROR([cannot find required library libuuid])
fi
])dnl
