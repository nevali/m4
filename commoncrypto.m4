dnl Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
dnl
dnl Copyright 2014 BBC
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
dnl BT_CHECK_COMMONCRYPTO([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_COMMONCRYPTO],[
	have_commoncrypto=no
	AC_CHECK_HEADER([CommonCrypto/CommonDigest.h],[
	AC_CHECK_FUNC([CC_SHA256_Init],[
		have_commoncrypto=yes
		AC_DEFINE_UNQUOTED([WITH_COMMONCRYPTO],[1],[Define if Apple's CommonCrypto API is available])
		$1
		])
	])
	if test x"$have_commoncrypto" = x"no" ; then
		m4_ifvaln([$2],[$2],[true])
	fi
])

dnl BT_REQUIRE_COMMONCRYPTO([action-if-found])
AC_DEFUN([BT_REQUIRE_COMMONCRYPTO],[
	BT_CHECK_COMMONCRYPTO([$1],[
		AC_MSG_ERROR([cannot find required Apple CommonCrypto API])
	])
])
