dnl Copyright 2012 Mo McRoberts.
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
AC_DEFUN([_BT_DEFINE_PATH],[
btv_dir=`eval echo $$2`
AC_DEFINE_UNQUOTED([$1],["$btv_dir"],[$3])
[$1]="$btv_dir"
AC_SUBST([$1])
])dnl
dnl
AC_DEFUN([_BT_SAVE_PATHS],[
btv_old_prefix="$prefix"
btv_old_exec_prefix="$exec_prefix"
if test x"$prefix" = x"NONE" ; then
   prefix="$ac_default_prefix"
fi
if test x"$exec_prefix" = x"NONE" ; then
   exec_prefix="$prefix"
fi
])dnl
dnl
AC_DEFUN([_BT_RESTORE_PATHS],[
prefix="$btv_old_prefix"
exec_prefix="$btv_old_exec_prefix"
])dnl
dnl
dnl - BT_DEFINE_PATH([define],[varname],[description])
AC_DEFUN([BT_DEFINE_PATH],[
_BT_SAVE_PATHS
_BT_DEFINE_PATH([$1],[$2],[$3])
_BT_RESTORE_PATHS
])dnl
AC_DEFUN([BT_DEFINE_PREFIX],[
_BT_SAVE_PATHS
_BT_DEFINE_PATH([PREFIX],[prefix],[Installation prefix])
_BT_DEFINE_PATH([EXEC_PREFIX], [exec_prefix], [Platform-specific installation prefix])
_BT_DEFINE_PATH([SYSCONFDIR], [sysconfdir], [System-wide configuration path])
_BT_DEFINE_PATH([LIBDIR], [libdir], [Library installation path])
_BT_DEFINE_PATH([INCLUDEDIR], [includedir], [C headers installation path])
_BT_DEFINE_PATH([LOCALSTATEDIR], [localstatedir], [Local state path])
_BT_DEFINE_PATH([DATAROOTDIR], [datarootdir], [Shared resources path])
_BT_DEFINE_PATH([BINDIR], [bindir], [Binaries installation path])
_BT_DEFINE_PATH([SBINDIR], [sbindir], [System binaries installation path])
_BT_RESTORE_PATHS
])dnl
