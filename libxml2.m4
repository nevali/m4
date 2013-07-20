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
dnl Internal: _BT_CHECK_LIBXML2([action-if-found],[action-if-not-found])
AC_DEFUN([_BT_CHECK_LIBXML2],[
	AC_REQUIRE([AC_CANONICAL_HOST])dnl
	BT_CHECK_LIB([libxml2],,[libxml-2.0],[
		AC_CHECK_PROG([LIBXML2_CONFIG],[xml2-config],[xml2-config])
		if ! test x"$LIBXML2_CONFIG" = x"" ; then
		   have_libxml2=yes
		   LIBXML2_CPPFLAGS=`$LIBXML2_CONFIG --cflags`
		   LIBXML2_LIBS=`$LIBXML2_CONFIG --libs`
		fi
	],,[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBXML2([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_LIBXML2],[
_BT_CHECK_LIBXML2([$1],[$2])
])dnl
dnl
dnl - BT_REQUIRE_LIBXML2([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBXML2],[
_BT_CHECK_LIBXML2([$1],[
	AC_MSG_ERROR([cannot locate libxml2])
])
])dnl
