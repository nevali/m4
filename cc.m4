dnl Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
dnl
dnl Copyright (c) 2015 BBC.

dnl Copyright 2012-2013 Mo McRoberts.
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
m4_pattern_allow([^bt_user_])dnl
AC_DEFUN([BT_PROG_CC_WARN],[
AC_MSG_CHECKING([whether to enable compiler warnings])
if test x"$GCC" = x"yes" ; then
   AC_MSG_RESULT([yes, -W -Wall])
   AM_CPPFLAGS="$AM_CPPFLAGS -W -Wall"
else
   AC_MSG_RESULT([no])
fi
AC_SUBST([AM_CPPFLAGS])
])dnl
dnl
AC_DEFUN([BT_PROG_CC_DEBUG],[
m4_divert_text([INIT_PREPARE],[bt_user_CFLAGS="$CFLAGS"])dnl
AC_ARG_ENABLE([debug],[AS_HELP_STRING([--enable-debug],[whether to build with debugging enabled])],[debug=$enableval],[debug=no])
if test x"$debug" = x"yes" && test x"$bt_user_CFLAGS" = x"" ; then
	if test x"$CFLAGS" = x"-g -O2" ; then
		CFLAGS="-g -O0"
	elif test x"$CFLAGS" = x"-O2" ; then
		CFLAGS="-O0"
	fi
fi
])dnl

