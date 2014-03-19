#! /bin/sh

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

version=""
suffix=""
dirty=""
now=`date +%y%m%d`

if `git rev-parse --git-dir >/dev/null 2>&1` ; then
	HEAD=`git rev-parse HEAD 2>/dev/null | cut -c1-7`
	[ x"$HEAD" = x"HEAD" ] && HEAD=""
	if [ -z "$HEAD" ] ; then
		echo "No commits yet" >&2
	else
		tags="`git show-ref --head --dereference --tags | cut -f2 -d' '`"
		vertag=""
		if [ -n "$tags" ] ; then
			for tag in $tags ; do
				case "$tag" in
					refs/tags/upstream/[0-9]*)
						vertag="`echo $tag | sed -e 's!^refs/tags/upstream/!!' -e 's!-.*$!!'`"
						;;
					refs/tags/debian/[0-9]*)
						vertag="`echo $tag | sed -e 's!^refs/tags/debian/!!' -e 's!-.*$!!'`"
						;;
					refs/tags/[0-9]*)
						vertag="`echo $tag | sed -e 's!^refs/tags/!!' -e 's!-.*$!!'`"
						;;
					refs/tags/r[0-9]*)
						vertag="`echo $tag | sed -e 's!^refs/tags/r!!' -e 's!-.*$!!'`"
						;;
					refs/tags/v[0-9]*)
						vertag="`echo $tag | sed -e 's!^refs/tags/v!!' -e 's!-.*$!!'`"
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

[ -z "$version" ] && [ -r .release ] && version="`cat .release`"
[ -z "$version" ] && version="0.0"

printf "%s%s%s" "$version" "$suffix" "$dirty"
