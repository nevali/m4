dnl Copyright 2014 Mo McRoberts.
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
dnl Internal: _BT_CHECK_LIBXSLT([action-if-found],[action-if-not-found])
AC_DEFUN([_BT_CHECK_LIBXSLT],[
	AC_REQUIRE([AC_CANONICAL_HOST])dnl
	BT_CHECK_LIB([libxslt],,[libxslt],[
		AC_CHECK_PROG([LIBXSLT_CONFIG],[xslt-config],[xslt-config])
		if ! test x"$LIBXSLT_CONFIG" = x"" ; then
		   have_libxslt=yes
		   LIBXSLT_CPPFLAGS=`$LIBXSLT_CONFIG --cflags`
		   LIBXSLT_LIBS=`$LIBXSLT_CONFIG --libs`
		fi
	],,[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBXSLT([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_LIBXSLT],[
_BT_CHECK_LIBXSLT([$1],[$2])
])dnl
dnl
dnl - BT_REQUIRE_LIBXSLT([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBXSLT],[
_BT_CHECK_LIBXSLT([$1],[
	AC_MSG_ERROR([cannot locate libxslt])
])
])dnl
