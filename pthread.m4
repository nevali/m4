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
AC_DEFUN([BT_REQUIRE_PTHREAD],[
	PTHREAD_LIBS=""
	PTHREAD_LOCAL_LIBS=""
	PTHREAD_INSTALLED_LIBS=""
	AC_CHECK_LIB([pthread],[pthread_key_create],,[
		PTHREAD_LIBS="-lpthread"
		AC_CHECK_FUNC([pthread_key_create],,[
			AC_MSG_ERROR([cannot locate the library providing POSIX threads])
		])
	])
	AC_CHECK_HEADER([pthread.h],,[cannot locate the header providing POSIX threads])
	have_pthread=yes
	AC_SUBST([have_pthread])
	AC_SUBST([PTHREAD_LIBS])
	AC_SUBST([PTHREAD_LOCAL_LIBS])
	AC_SUBST([PTHREAD_INSTALLED_LIBS])
	AC_DEFINE_UNQUOTED([WITH_PTHREAD],[1],[Define if POSIX threads headers and libraries are available])
])
