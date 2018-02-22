---
title: "Shell Test Blocks"
date: 2018-02-21T14:40:48-03:00
draft: false
---

`[` is defined by the POSIX standard and thus it's supported by all POSIX
shells. On the other hand, although `[[` is more powerful it only works with
bash, zsh and ksh.

>
> Initially `[` was implemented as a command (`/usr/bin/[`). Because of
> that, the expression needs to be surrounded by spaces: `[ expr ]`
> and `[[ expr ]]`.
>

Differences
-----------

Feature                   | `[ ... ]` old style      | `[[ ... ]]` new style    | Comments
--------------------------|--------------------------|--------------------------|--------------------------
Variable expansion        | `"$v"`                   | `$v`                     | New style will not split the variable if it contains spaces.
String comparison         | `=`                      | `=` or `==`              |
                          | `!=`                     | `!=`                     |
                          | `\>` and `\<`            | `>` and `<`              |
Integer comparison        | `-ge`, `-le`, `-eq`      | `-gt`, `-lt`, `-eq`      | No differences.
                          | `-gt`, `-lt`, `-ne`      | `-gt`, `-lt`, `-eq`      |
Logical operators         | Deprecated by POSIX      | `&&` and \|\|            | See below.
Grouping                  | Deprecated by POSIX      | `(` and `)`              | See below.
Glob matching             | Not available            | `[[ $v == *.txt ]]`      |
Regex matching            | Not available            | `[[ $v =~ .*\.txt ]]`    |


POSIX deprecates `-a`, `-o`, `\(` and `\)`. So instead of using:

```sh
if [ -f file1 -a \( "$var1" -eq 0 -i "$var2" -eq 0 \) ]; then
	echo true
fi
```

It's necessary to use:

```sh
if [ -f file1 ] && { [ "$var1" -eq 0 ] || [ "$var2" -eq 0 ]; }; then
	echo true
fi
```

While that could be written in the following way with `[[`:

```sh
if [[ -f file 1 && ( $var1 -eq 0 || $var2 -eq 0 ) ]]; then
	echo true
fi
```

>
> Besides the differences above, `[` might also lack the following operators
> depending on the implementation: `-e`, `-nt` (newer than), `-ot` (older than),
> `-ef` (exact same file) and `!` (not).
>

Arithmetic Expansion
--------------------

`(( ... ))` and `$(( ... ))` can be used for integer comparison and arithmetic
operations.

Examples:

```sh
# POSIX sh
i=$((j + 3))
lvcreate -L "$((24 * 1024))" -n lv99 vg99
q=$((29 / 6)) r=$((29 % 6))
if test "$((a%4))" = 0; then echo "true"; fi

# Bash
((a=$a+7))         # Add 7 to a
((a = a + 7))      # Add 7 to a.  Identical to the previous command.
((a += 7))         # Add 7 to a.  Identical to the previous command.

if ((a > 5)); then echo "a is more than 5"; fi

true; echo "$?"       # Writes 0, because a successful command returns 0.
((10 > 6)); echo "$?" # Also 0.  An arithmetic command returns 0 for true.
echo "$((10 > 6))"    # Writes 1.  An arithmetic expression evaluates to 1 for true.

for ((i=0, j=0; i<100; i++, j+=5)); do echo "$i"; done
```

>
> Unlike `[` and `[[`, expressions do not need to be surrounded by spaces with
> `$((expr))` and `((expr))`.
>

References
----------

1. http://mywiki.wooledge.org/BashFAQ/031
2. http://mywiki.wooledge.org/ArithmeticExpression

