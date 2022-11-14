<!-- source: https://docs.rs/regex/latest/regex/index.html#syntax -->
# Syntax
The syntax supported in this crate is documented below.
Note that the regular expression parser and abstract syntax are exposed in
a separate crate, [`regex-syntax`](https://docs.rs/regex-syntax).
## Matching one character
<pre class="rust">
.             any character except new line (includes new line with s flag)
\d            digit (\p{Nd})
\D            not digit
\pN           One-letter name Unicode character class
\p{Greek}     Unicode character class (general category or script)
\PN           Negated one-letter name Unicode character class
\P{Greek}     negated Unicode character class (general category or script)
</pre>
### Character classes
<pre class="rust">
[xyz]         A character class matching either x, y or z (union).
[^xyz]        A character class matching any character except x, y and z.
[a-z]         A character class matching any character in range a-z.
[[:alpha:]]   ASCII character class ([A-Za-z])
[[:^alpha:]]  Negated ASCII character class ([^A-Za-z])
[x[^xyz]]     Nested/grouping character class (matching any character except y and z)
[a-y&&xyz]    Intersection (matching x or y)
[0-9&&[^4]]   Subtraction using intersection and negation (matching 0-9 except 4)
[0-9--4]      Direct subtraction (matching 0-9 except 4)
[a-g~~b-h]    Symmetric difference (matching `a` and `h` only)
[\[\]]        Escaping in character classes (matching [ or ])
</pre>
Any named character class may appear inside a bracketed `[...]` character
class. For example, `[\p{Greek}[:digit:]]` matches any Greek or ASCII
digit. `[\p{Greek}&&\pL]` matches Greek letters.
Precedence in character classes, from most binding to least:
1. Ranges: `a-cd` == `[a-c]d`
2. Union: `ab&&bc` == `[ab]&&[bc]`
3. Intersection: `^a-z&&b` == `^[a-z&&b]`
4. Negation
## Composites
<pre class="rust">
xy    concatenation (x followed by y)
x|y   alternation (x or y, prefer x)
</pre>
## Repetitions
<pre class="rust">
x*        zero or more of x (greedy)
x+        one or more of x (greedy)
x?        zero or one of x (greedy)
x*?       zero or more of x (ungreedy/lazy)
x+?       one or more of x (ungreedy/lazy)
x??       zero or one of x (ungreedy/lazy)
x{n,m}    at least n x and at most m x (greedy)
x{n,}     at least n x (greedy)
x{n}      exactly n x
x{n,m}?   at least n x and at most m x (ungreedy/lazy)
x{n,}?    at least n x (ungreedy/lazy)
x{n}?     exactly n x
</pre>
## Empty matches
<pre class="rust">
^     the beginning of text (or start-of-line with multi-line mode)
$     the end of text (or end-of-line with multi-line mode)
\A    only the beginning of text (even with multi-line mode enabled)
\z    only the end of text (even with multi-line mode enabled)
\b    a Unicode word boundary (\w on one side and \W, \A, or \z on other)
\B    not a Unicode word boundary
</pre>
The empty regex is valid and matches the empty string. For example, the empty
regex matches `abc` at positions `0`, `1`, `2` and `3`.
## Grouping and flags
<pre class="rust">
(exp)          numbered capture group (indexed by opening parenthesis)
(?P&lt;name&gt;exp)  named (also numbered) capture group (allowed chars: [_0-9a-zA-Z.\[\]])
(?:exp)        non-capturing group
(?flags)       set flags within current group
(?flags:exp)   set flags for exp (non-capturing)
</pre>
Flags are each a single character. For example, `(?x)` sets the flag `x`
and `(?-x)` clears the flag `x`. Multiple flags can be set or cleared at
the same time: `(?xy)` sets both the `x` and `y` flags and `(?x-y)` sets
the `x` flag and clears the `y` flag.
All flags are by default disabled unless stated otherwise. They are:
<pre class="rust">
i     case-insensitive: letters match both upper and lower case
m     multi-line mode: ^ and $ match begin/end of line
s     allow . to match \n
U     swap the meaning of x* and x*?
u     Unicode support (enabled by default)
x     ignore whitespace and allow line comments (starting with `#`)
</pre>
Flags can be toggled within a pattern. Here's an example that matches
case-insensitively for the first part but case-sensitively for the second part:
```rust
# use regex::Regex;
# fn main() {
let re = Regex::new(r"(?i)a+(?-i)b+").unwrap();
let cap = re.captures("AaAaAbbBBBb").unwrap();
assert_eq!(&cap[0], "AaAaAbb");
# }
```
Notice that the `a+` matches either `a` or `A`, but the `b+` only matches
`b`.
Multi-line mode means `^` and `$` no longer match just at the beginning/end of
the input, but at the beginning/end of lines:
```
# use regex::Regex;
let re = Regex::new(r"(?m)^line \d+").unwrap();
let m = re.find("line one\nline 2\n").unwrap();
assert_eq!(m.as_str(), "line 2");
```
Note that `^` matches after new lines, even at the end of input:
```
# use regex::Regex;
let re = Regex::new(r"(?m)^").unwrap();
let m = re.find_iter("test\n").last().unwrap();
assert_eq!((m.start(), m.end()), (5, 5));
```
Here is an example that uses an ASCII word boundary instead of a Unicode
word boundary:
```rust
# use regex::Regex;
# fn main() {
let re = Regex::new(r"(?-u:\b).+(?-u:\b)").unwrap();
let cap = re.captures("$$abc$$").unwrap();
assert_eq!(&cap[0], "abc");
# }
```
## Escape sequences
<pre class="rust">
\*          literal *, works for any punctuation character: \.+*?()|[]{}^$
\a          bell (\x07)
\f          form feed (\x0C)
\t          horizontal tab
\n          new line
\r          carriage return
\v          vertical tab (\x0B)
\123        octal character code (up to three digits) (when enabled)
\x7F        hex character code (exactly two digits)
\x{10FFFF}  any hex character code corresponding to a Unicode code point
\u007F      hex character code (exactly four digits)
\u{7F}      any hex character code corresponding to a Unicode code point
\U0000007F  hex character code (exactly eight digits)
\U{7F}      any hex character code corresponding to a Unicode code point
</pre>
## Perl character classes (Unicode friendly)
These classes are based on the definitions provided in
[UTS#18](https://www.unicode.org/reports/tr18/#Compatibility_Properties):
<pre class="rust">
\d     digit (\p{Nd})
\D     not digit
\s     whitespace (\p{White_Space})
\S     not whitespace
\w     word character (\p{Alphabetic} + \p{M} + \d + \p{Pc} + \p{Join_Control})
\W     not word character
</pre>
## ASCII character classes
<pre class="rust">
[[:alnum:]]    alphanumeric ([0-9A-Za-z])
[[:alpha:]]    alphabetic ([A-Za-z])
[[:ascii:]]    ASCII ([\x00-\x7F])
[[:blank:]]    blank ([\t ])
[[:cntrl:]]    control ([\x00-\x1F\x7F])
[[:digit:]]    digits ([0-9])
[[:graph:]]    graphical ([!-~])
[[:lower:]]    lower case ([a-z])
[[:print:]]    printable ([ -~])
[[:punct:]]    punctuation ([!-/:-@\[-`{-~])
[[:space:]]    whitespace ([\t\n\v\f\r ])
[[:upper:]]    upper case ([A-Z])
[[:word:]]     word characters ([0-9A-Za-z_])
[[:xdigit:]]   hex digit ([0-9A-Fa-f])
</pre>
