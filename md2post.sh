#!/bin/bash

get_date() {
	local file="$1"
	[ ! -r "$file" ] && return
	local time=
	for fmt in W Y; do
		local ret=$(stat -c "%$fmt" "$file")
		if [ "$ret" != '0' ]; then
			time="$ret"
			break
		fi
	done
	[ -z "$time" ] && return
	date -d "@$time" '+%Y-%m-%dT%H:%M:%S%:z'
}

get_title() {
	local file="$1"
	[ ! -r "$file" ] && return
	sed -r -n -e '/^\s*$/!{p;q}' "$file"
}

input="$1"
if [ ! -r "$input" ]; then
	echo "Cannot access \"$input\"." >&2
	exit 1
fi

dir="./content/posts"
if [ ! -d "$dir" ]; then
	echo "Posts directory doesn't exist: $dir." >&2
	exit 2
fi

output="$dir/$(basename "$input")"
cat > "$output" << EOF
---
title: $(get_title "$input")
date: $(get_date "$input")
---

$(cat "$input")
EOF

echo "Post written: $output"
