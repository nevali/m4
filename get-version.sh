#! /bin/sh

## Copyright 2014 BBC.
##
## Copyright 2014 Mo McRoberts.
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

## To use this script, structure your AC_INIT as follows:
## AC_INIT([package-name],m4_esyscmd([/bin/sh m4/get-version.sh]),[bug-report],[tar-name],[url])

## Always use a .release file if present
if test -r .release ; then
	version="`head -1 .release`"
	if ! test x"$version" = x"" ; then
		printf "%s" "$version"
		exit 0
	fi
fi

## If we are autobuilding, use the supplied version
if ! test x"$GIT_BUILD_VERSION" = x"" ; then
	echo -n "$GIT_BUILD_VERSION"
	exit 0
fi

version=""
suffix=""
dirty=""
now=`date +%y%m%d`

if `git rev-parse --git-dir >/dev/null 2>&1` ; then
	HEAD=`git rev-parse HEAD 2>/dev/null | cut -c1-7`
	[ x"$HEAD" = x"HEAD" ] && HEAD=""
	if [ -z "$HEAD" ] ; then
		suffix="~$now"
	    dirty=".dirty"
	else
		tags="`git describe --tags --exact-match $HEAD 2>/dev/null`"
		vertag=""
		if [ -n "$tags" ] ; then
			for tag in $tags ; do
				case "$tag" in
					upstream/[0-9]*)
						vertag="`echo $tag | sed -e 's!^upstream/!!' -e 's!-.*$!!'`"
						;;
					debian/[0-9]*)
						vertag="`echo $tag | sed -e 's!^debian/!!' -e 's!-.*$!!'`"
						;;
					[0-9]*)
						vertag="`echo $tag | sed -e 's!-.*$!!'`"
						;;
					r[0-9]*)
						vertag="`echo $tag | sed -e 's!^r!!' -e 's!-.*$!!'`"
						;;
					v[0-9]*)
						vertag="`echo $tag | sed -e 's!^v!!' -e 's!-.*$!!'`"
						;;
				esac
			done
		fi
		git update-index --refresh -q >/dev/null
		dirty=`git diff-index --name-only HEAD 2>/dev/null`
		[ -n "$dirty" ] && dirty=".dirty"
		[ -n "$vertag" ] && version="$vertag"
		if [ -z "$vertag" ] || [ -n "$dirty" ] ; then
			suffix="~$now.$HEAD"
		fi
	fi
fi

[ -z "$version" ] && version="0.0"

printf "%s%s%s" "$version" "$suffix" "$dirty"
