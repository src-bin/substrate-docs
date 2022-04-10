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
        <!--<link href="https://src-bin.com/" rel="canonical">-->
        <link href="/css/2022-03-03.css" rel="stylesheet">
        <meta property="og:description" content="A page from the Substrate manual">
        <meta property="og:image" content="https://src-bin.com/img/apple-touch-icon.png">
        <meta property="og:title" content="Source &amp; Binary / Substrate manual / $(head -n"1" "$PATHNAME" | sed "s/^# //")">
        <meta property="og:type" content="website">
        <meta property="og:url" content="https://src-bin.com/substrate/manual/${DIRNAME#"./"}/">
        <meta name="twitter:card" content="summary">
        <meta name="twitter:description" content="A page from the Substrate manual">
        <meta name="twitter:image" content="https://src-bin.com/img/apple-touch-icon.png">
        <meta name="twitter:site" content="@src_bin">
        <meta name="twitter:title" content="Source &amp; Binary / Substrate manual / $(head -n"1" "$PATHNAME" | sed "s/^# //")">
        <title>Source &amp; Binary / $(head -n"1" "$PATHNAME" | sed "s/^# //")</title>
    </head>
    <body>
        <header>
            <h1><a href="/">Source <span class="fancy">&amp;</span> Binary</a></h1>
            <p><a href="mailto:hello@src-bin.com">hello@src-bin.com</a></p>
            <aside>Purveyors&nbsp;of&nbsp;secure,&nbsp;reliable,&nbsp;and&nbsp;compliant&nbsp;cloud&nbsp;infrastructure&nbsp;since&nbsp;2020</aside>
            <nav>
                <ul>
                    <li><a href="/">Benefits</a></li>
                    <li><a href="/substrate/">Features</a></li>
                    <li><a href="/substrate/manual/">Documentation</a></li>
                    <li><a href="/substrate/pricing/">Pricing</a></li>
                    <!--<li><a href="/compliance/">Compliance Workshop</a></li>-->
                </ul>
            </nav>
        </header>

        <section>
EOF
        echo
        Markdown.pl --html4tags "$PATHNAME"
        echo
        cat <<EOF
        </section>

        <footer>
            <p class="fine-print">&copy; 2020-2022 &mdash; Source <span class="fancy">&amp;</span> Binary&nbsp;LLC</p>
        </footer>
    </body>
</html>
EOF
    } >"$DIRNAME/index.html"
    until diff "$DIRNAME/.index.html" "$DIRNAME/index.html" >"/dev/null"
    do
        cp "$DIRNAME/index.html" "$DIRNAME/.index.html"
        sed -z "s/<pre>\(.*\)'\(.*\)<\\/pre>/<pre>\1\&apos;\2<\/pre>/g" <"$DIRNAME/.index.html" >"$DIRNAME/index.html"
    done
    rm -f "$DIRNAME/.index.html"
    sed -i "s/'/\&rsquo;/g" "$DIRNAME/index.html"
done
