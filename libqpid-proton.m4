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
dnl Internal: _BT_CHECK_LIBQPID_PROTON([action-if-found],[action-if-not-found])
AC_DEFUN([_BT_CHECK_LIBQPID_PROTON],[
	AC_REQUIRE([AC_CANONICAL_HOST])dnl
	BT_CHECK_LIB([libqpid_proton],,[libqpid-proton],[

        AC_CHECK_LIB([qpid-proton],[pn_connect],[
            AC_CHECK_HEADER([proton/message.h],[
				 LIBQPID_PROTON_LIBS="-lqpid-proton"
                 have_libqpid_proton=yes
            ])
        ])

    ],,[$1],[$2])
])dnl
dnl
dnl - BT_CHECK_LIBQPID_PROTON([action-if-found],[action-if-not-found])
AC_DEFUN([BT_CHECK_LIBQPID_PROTON],[
_BT_CHECK_LIBQPID_PROTON([$1],[$2])
])dnl
dnl
dnl - BT_REQUIRE_LIBQPID_PROTON([action-if-found])
AC_DEFUN([BT_REQUIRE_LIBQPID_PROTON],[
_BT_CHECK_LIBQPID_PROTON([$1],[
	AC_MSG_ERROR([cannot locate libqpid-proton])
])
])dnl
