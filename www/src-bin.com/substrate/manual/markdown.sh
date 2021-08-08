#!/bin/sh

set -e -x

find -name "*.md" |
while read PATHNAME
do
    DIRNAME="$(dirname "$PATHNAME")/$(basename "$PATHNAME" ".md")"
    mkdir -p "$DIRNAME"
    {
        cat <<EOF
<!doctype HTML>
<html lang="en">
<meta charset="utf-8">
<head>
<link href="/css/2019-11-01.css" rel="stylesheet">
<title>Source &amp; Binary / $(head -n"1" "$PATHNAME" | sed "s/^# //")</title>
</head>
<body>
<header><h1><a href="/">Source <span class="fancy">&amp;</span> Binary</a></h1></header>
EOF
        echo
        Markdown.pl --html4tags "$PATHNAME" | sed "s/'/\&rsquo;/g"
        echo
        cat <<EOF
<footer>
<ul>
<li><a href="/services/">Services</a>: <small>infrastructure, architecture, compliance</small></li>
<li><a href="/substrate/">Substrate</a>, <small>my suite of AWS management tools</small></li>
</ul>
<p>Copyright &copy; 2020-2021 &mdash; Source <span class="fancy">&amp;</span> Binary LLC</p>
</footer>
</body>
</html>
EOF
    } >"$DIRNAME/index.html"
done
