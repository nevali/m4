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
dnl - BT_CHECK_LIB($1=name,[$2=local-subdir],[$3=pkg-config modules],[$4=local-test-code],[$5=use-local-code],[$6=action-if-found],[$7=action-if-not-found])
dnl
dnl test-code is a detection routine; it should set
dnl   have_name        => yes|no
dnl   NAME_CPPFLAGS    => Any CPPFLAGS specific to the library
dnl   NAME_LDFLAGS     => Any LDFLAGS specific to the library
dnl   NAME_LIBS        => The -lxxx linker flags needed to link the library
dnl   NAME_LOCAL_LIBS  => Any in-tree libtool libraries needed to link
dnl
dnl action-if-found defaults to adding the above variables to AM_CPPFLAGS,
dnl AM_LDFLAGS, LIBS and LOCAL_LIBS respectively.
dnl
dnl action-if-not-found defaults to nothing
dnl
dnl If local-subdir is specified, AC_CONFIG_SUBDIRS() will be invoked on
dnl the specified directory after use-local-code, unless foo_configured
dnl is not empty.
dnl
m4_pattern_forbid([^BT_])dnl
m4_pattern_forbid([^bt_])dnl
m4_pattern_forbid([^_BT_])dnl
AC_DEFUN([BT_CHECK_LIB],[
AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl

dnl Save these variables, they shouldn't be overwritten
old_CPPFLAGS="$CPPFLAGS"
old_LDFLAGS="$LDFLAGS"
old_LIBS="$LIBS"

dnl Use bt_lprefix and bt_uprefix as shell variable prefixes
m4_ifdef([bt_lprefix], [m4_undefine([bt_lprefix])])dnl
m4_define([bt_lprefix], AS_TR_SH([$1]))dnl
m4_ifdef([bt_uprefix], [m4_undefine([bt_uprefix])])dnl
m4_define([bt_uprefix], AS_TR_CPP([$1]))dnl

dnl Define bt_l_xxx macros to be the names of shell variables that we use
m4_ifdef([bt_l_have], [m4_undefine([bt_l_have])])dnl
m4_ifdef([bt_l_srcdir], [m4_undefine([bt_l_srcdir])])dnl
m4_ifdef([bt_l_builddir], [m4_undefine([bt_l_builddir])])dnl
m4_ifdef([bt_l_abs_srcdir], [m4_undefine([bt_l_abs_srcdir])])dnl
m4_ifdef([bt_l_abs_builddir], [m4_undefine([bt_l_abs_builddir])])dnl
m4_ifdef([bt_l_with], [m4_undefine([bt_l_with])])dnl
m4_ifdef([bt_l_local], [m4_undefine([bt_l_local])])dnl
m4_ifdef([bt_l_configured], [m4_undefine([bt_l_configured])])dnl
m4_ifdef([bt_l_included], [m4_undefine([bt_l_included])])dnl
m4_ifdef([bt_l_cppflags], [m4_undefine([bt_l_cppflags])])dnl
m4_ifdef([bt_l_ldflags], [m4_undefine([bt_l_ldflags])])dnl
m4_ifdef([bt_l_libs], [m4_undefine([bt_l_libs])])dnl
m4_ifdef([bt_l_local_libs], [m4_undefine([bt_l_local_libs])])dnl
m4_ifdef([bt_l_installed_libs], [m4_undefine([bt_l_installed_libs])])dnl
dnl
m4_define([bt_l_have],[m4_join(,[have_],bt_lprefix)])dnl
m4_define([bt_l_srcdir],[m4_join(,bt_lprefix,[_srcdir])])dnl
m4_define([bt_l_builddir],[m4_join(,bt_lprefix,[_builddir])])dnl
m4_define([bt_l_abs_srcdir],[m4_join(,bt_uprefix,[_SRCDIR])])dnl
m4_define([bt_l_abs_builddir],[m4_join(,bt_uprefix,[_BUILDDIR])])dnl
m4_define([bt_l_local],[m4_join(,[local_],bt_lprefix)])dnl
m4_define([bt_l_with],[m4_join(,[with_],bt_lprefix)])dnl
m4_define([bt_l_configured],[m4_join(,bt_lprefix,[_configured])])dnl
m4_define([bt_l_included],[m4_join(,[with_included_],bt_lprefix)])dnl
m4_define([bt_l_cppflags],[m4_join(,bt_uprefix,[_CPPFLAGS])])dnl
m4_define([bt_l_ldflags],[m4_join(,bt_uprefix,[_LDFLAGS])])dnl
m4_define([bt_l_libs],[m4_join(,bt_uprefix,[_LIBS])])dnl
m4_define([bt_l_local_libs],[m4_join(,bt_uprefix,[_LOCAL_LIBS])])dnl
m4_define([bt_l_installed_libs],[m4_join(,bt_uprefix,[_INSTALLED_LIBS])])dnl

dnl Set $with_foo according to --with-foo, defaulting to 'auto'
AC_ARG_WITH([$1],[AS_HELP_STRING([--with-$1=PATH],[Specify installation prefix of $1])],[AS_VAR_SET(bt_l_with,["$withval"])],[AS_VAR_SET(bt_l_with,[auto])])

dnl If we, or a parent configure script, previously configured this
dnl dependency in-tree, use the existing values

dnl If $foo_abs_srcdir is set but $foo_srcdir is not, a parent
dnl script previously configured the package. Perform this only if $5
dnl (use-local-code) is set
m4_ifval([$5],[
if test x"$bt_l_srcdir" = x"" ; then
	if ! test x"$bt_l_abs_srcdir" = x"" ; then
		if test x"$bt_l_abs_builddir" = x"" ; then
			AS_VAR_SET(bt_l_abs_builddir,[$bt_l_abs_srcdir])
			export bt_l_abs_builddir
		fi
		AS_VAR_SET(bt_l_configured,[yes])
		AS_VAR_SET(bt_l_srcdir,[$bt_l_abs_srcdir])
		AS_VAR_SET(bt_l_builddir,[$bt_l_abs_builddir])
	fi
fi
])

if ! test x"$bt_l_srcdir" = x"" ; then
	if test x"$bt_l_have" = x"" ; then
		AS_VAR_SET(bt_l_with,[no])
		AS_VAR_SET(bt_l_local,[yes])
	fi
fi

dnl have_foo will be set to yes or no depending upon whether the package
dnl could be located.
if test x"$bt_l_have" = x"" ; then
	AS_VAR_SET(bt_l_have,[no])
fi

dnl local_foo is set to yes or not depending upon whether we're using
dnl an included copy of the package, or referencing an installed
dnl version.
if test x"$bt_l_local" = x"" ; then
	AS_VAR_SET(bt_l_local,[no])
fi

dnl If a subdir ($2) was specified, look for a bundled tree relative to $srcdir
m4_ifval([$2],[
	if test "$bt_l_local" = "no" && test -r "$srcdir/$2/configure" ; then
		AS_VAR_SET(bt_l_local,[auto])
	fi
	AC_ARG_WITH([included_$1],
		[AS_HELP_STRING([--without-included-$1],[Don't use a bundled version of $1 if present])],
		[
			dnl If --with-included-foo was specified explicitly, skip the external tests by
			dnl forcing with_foo to be no
			if test x"$withval" = x"yes" ; then
				if ! test x"$bt_l_local" = x"no" ; then						
					AS_VAR_SET(bt_l_with,[no])
				fi
			fi
		],
		[
			dnl If --with-included-foo was not specified, $with_included_foo is set
			dnl to whatever $local_foo is ('auto' if srcdir/subdir/configure
			dnl was found, no otherwise)
			AS_VAR_SET(bt_l_included,$bt_l_local)
		])
],[AS_VAR_SET(bt_l_included,$bt_l_local)])
if test x"$bt_l_local" = x"no" ; then
	AS_VAR_SET(bt_l_included,[no])
fi

dnl Set $with_included_foo, $FOO_CPPFLAGS and $FOO_LDFLAGS based upon
dnl the value of $with_foo
case "$bt_l_with" in
	yes)
		AS_VAR_SET(bt_l_included,[no])
		;;
	no|auto)
		;;
	*)
		AS_VAR_SET(bt_l_included,[no])
		AS_VAR_SET(bt_l_cppflags,["-I$]bt_l_with[/include"])
		AS_VAR_SET(bt_l_ldflags,["-L$]bt_l_with[/lib"])
		;;
esac

dnl Temporarily set $CPPFLAGS and $LDFLAGS to allow tests to proceed
AS_VAR_SET([CPPFLAGS],["$CPPFLAGS $]bt_l_cppflags")
AS_VAR_SET([LDFLAGS],["$LDFLAGS $]bt_l_ldflags")

if ! test x"$bt_l_included" = x"yes" ; then
	if ! test x"$bt_l_with" = x"no" ; then

		dnl Use pkg-config if a pkg-config package name
		dnl was specified
		m4_ifval([$3],[
			AC_MSG_CHECKING([for $3 with pkg-config])
			AS_VAR_SET(bt_l_cppflags)
			AS_VAR_SET(bt_l_libs)
			unset pkg_cv_pkg_cppflags
			unset pkg_cv_pkg_libs
			unset pkg_modversion
			_PKG_CONFIG(pkg_cppflags, [cflags], [$3])
			AS_VAR_SET(bt_l_cppflags, $pkg_cv_[]pkg_cppflags)

			_PKG_CONFIG(pkg_libs, [libs], [$3])
			AS_VAR_SET(bt_l_libs, $pkg_cv_[]pkg_libs)
			AS_VAR_SET(bt_l_installed_libs, $pkg_cv_[]pkg_libs)

			_PKG_CONFIG([pkg_modversion], [modversion], [$3])
			AS_VAR_SET(pkg_modversion, $pkg_cv_[]pkg_modversion)

			if test -n "$pkg_failed" ; then
				AC_MSG_RESULT([no])
			else
				AC_MSG_RESULT([yes ($pkg_modversion)])
				AS_VAR_SET(bt_l_have,[yes])
			fi
		])
		
		dnl If the pkg-config test didn't run or failed and specific
		dnl test code was provided, attempt to use that
		if test x"$bt_l_have" = x"no" ; then
			m4_ifval([$4],[$4])
			if test x"$bt_l_installed_libs" = x"" ; then
				AS_VAR_SET(bt_l_installed_libs,$bt_l_libs)
			fi
		fi
	fi
fi

dnl If the tests resulted in $have_foo being set to yes, we're not going
dnl to be using any bundled copy (if we're definitely using a bundled
dnl copy, the tests resulting in $have_foo being set to yes would never
dnl be executed).
if test x"$bt_l_have" = x"yes" ; then
	bt_l_included=no
fi

dnl If $with_included_foo is not no, invoke the 'use local' code.
if ! test x"$bt_l_included" = x"no" ; then
	if test x"$bt_l_srcdir" = x"" ; then
		AS_VAR_SET(bt_l_srcdir,["\${top_srcdir}/$2"])
		AS_VAR_SET(bt_l_builddir,["\${top_builddir}/$2"])
	fi
	AS_VAR_SET(bt_l_have,[yes])
	dnl Set default FOO_CPPFLAGS and FOO_LDFLAGS
	AS_VAR_SET(bt_l_cppflags,["-I$]bt_l_srcdir[ -I$]bt_l_builddir["])
	AS_VAR_SET(bt_l_ldflags,["-L$]bt_l_srcdir[ -L$]bt_l_builddir["])
	m4_ifval([$5],[$5])
	m4_ifval([$2],[
		if test x"$bt_l_configured" = x"" ; then
			AC_CONFIG_SUBDIRS([$2])
		fi
	])
	AS_VAR_SET(bt_l_configured,[yes])
	if test x"$bt_l_abs_srcdir" = x"" ; then
		top_builddir="."
		top_srcdir="$srcdir"
		AS_VAR_SET(bt_l_abs_srcdir,[`eval echo $bt_l_srcdir`])
		AS_VAR_SET(bt_l_abs_srcdir,[`cd $bt_l_abs_srcdir && pwd`])
		export bt_l_abs_srcdir
		AS_VAR_SET(bt_l_abs_builddir,[`eval echo $bt_l_builddir`])
		AS_VAR_SET(bt_l_abs_builddir,[`cd $bt_l_abs_builddir && pwd`])
		export bt_l_abs_builddir
		unset top_builddir
		unset top_srcdir
	fi
fi

dnl Restore important variables
CPPFLAGS="$old_CPPFLAGS"
LDFLAGS="$old_LDFLAGS"
LIBS="$old_LIBS"

dnl Substitute the public variables
AC_SUBST(bt_l_have)
AC_SUBST(bt_l_cppflags)
AC_SUBST(bt_l_ldflags)
AC_SUBST(bt_l_libs)
AC_SUBST(bt_l_local_libs)
AC_SUBST(bt_l_installed_libs)

dnl If the end result was that $have_foo is yes, define a macro indicating
dnl as much and execute action-if-found (or use the default implementation)
if test x"$bt_l_have" = x"yes" ; then
	AC_DEFINE_UNQUOTED(m4_join(,[WITH_],bt_uprefix),[1],[Define if $1 is available])
	m4_ifval([$6],[$6],[
		AS_VAR_SET([AM_CPPFLAGS],["$AM_CPPFLAGS $]bt_l_cppflags")
		AC_SUBST([AM_CPPFLAGS])
		AS_VAR_SET([AM_LDFLAGS],["$AM_LDFLAGS $]bt_l_ldflags")
		AC_SUBST([AM_LDFLAGS])
		AS_VAR_SET([LIBS],"$bt_l_libs[ $LIBS"])
		AC_SUBST([LIBS])
		AS_VAR_SET([LOCAL_LIBS],"$bt_l_local_libs[ $LOCAL_LIBS"])
		AC_SUBST([LOCAL_LIBS])
	])
else
	dnl Otherwise, execute the action-if-not-found
	m4_ifval([$7],[$7],[true])
fi
])dnl
