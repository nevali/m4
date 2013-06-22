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
dnl Internal: _BT_CHECK_LIBCURL([action-if-found],[action-if-not-found])
AC_DEFUN([_BT_CHECK_LIBCURL],[
AC_REQUIRE([AC_CANONICAL_HOST])dnl
BT_CHECK_LIB([libcurl],,,[
AC_CHECK_PROG([CURL_CONFIG],[curl-config],[curl-config])
if test x"$CURL_CONFIG" = x"" ; then
   AC_CHECK_HEADER([curl/curl.h],[
      AC_CHECK_LIB([curl],[curl_easy_perform],[
	    have_libcurl=yes
		LIBCURL_LIBS="-lcurl"
	  ])
   ])
else
   have_libcurl=yes
   LIBCURL_CPPFLAGS=`$CURL_CONFIG --cflags`
   LIBCURL_LIBS=`$CURL_CONFIG --libs`
fi
],,[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBCURL([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_LIBCURL],[
_BT_CHECK_LIBCURL([$1],[$2])
])dnl
dnl
dnl - BT_REQUIRE_LIBCURL([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBCURL],[
_BT_CHECK_LIBCURL([$1],[
	AC_MSG_ERROR([cannot locate libcurl; check that the curl-config utility can be found])
])
])dnl
