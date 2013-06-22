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
dnl Internal: _BT_CHECK_OPENSSL([action-if-found],[action-if-not-found])
AC_DEFUN([_BT_CHECK_OPENSSL],[
AC_REQUIRE([AC_CANONICAL_HOST])dnl
BT_CHECK_LIB([openssl],,[openssl],[

AC_CHECK_HEADER([openssl/opensslconf.h],[
  old_LIBS="$LIBS"
  AC_CHECK_LIB([crypto],[X509_new],[
    AC_CHECK_LIB([ssl],[ssl_ok],[
	   have_openssl=yes
	   OPENSSL_LIBS="-lssl -lcrypto"
	])
  ])
  libs="$old_LIBS"
])

],,[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_OPENSSL([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_OPENSSL],[
_BT_CHECK_OPENSSL([$1],[$2])
])dnl
dnl
dnl - BT_REQUIRE_OPENSSL([action-if-found])
AC_DEFUN([BT_REQUIRE_OPENSSL],[
_BT_CHECK_OPENSSL([$1],[
	AC_MSG_ERROR([cannot locate OpenSSL])
])
])dnl
