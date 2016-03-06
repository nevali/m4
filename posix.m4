dnl Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
dnl
dnl Copyright 2015 BBC
dnl
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
dnl - BT_ENABLE_POSIX([version=200809L])
AC_DEFUN([BT_ENABLE_POSIX],[
AC_DEFINE_UNQUOTED([_POSIX_C_SOURCE],m4_ifval([$1],[$1],[200809L]),[This application requires POSIX facilities])
])
dnl - BT_ENABLE_XSI([version=600])
AC_DEFUN([BT_ENABLE_XSI],[
AC_DEFINE_UNQUOTED([_XOPEN_SOURCE],m4_ifval([$1],[$1],[600]),[This application requires the X/Open System Interfaces POSIX extension])
])
dnl - BT_ENABLE_POSIX_FULL([version=200809L])
AC_DEFUN([BT_ENABLE_POSIX_FULL],[
BT_ENABLE_XSI
AC_DEFINE_UNQUOTED([_POSIX_C_SOURCE],m4_ifval([$1],[$1],[200809L]),[This application requires POSIX facilities])
AC_DEFINE_UNQUOTED([_BSD_SOURCE],[1],[This application uses BSD extensions])
AC_DEFINE_UNQUOTED([_DARWIN_C_SOURCE],[1],[On Darwin, extended prototypes must be available])
])
