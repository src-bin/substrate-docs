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
    <head>
        <link href="/css/2022-08-29.css" rel="stylesheet">
        <meta charset="utf-8">
        <meta content="summary" name="twitter:card">
        <meta content="A page from the Substrate manual" name="twitter:description">
        <meta content="https://src-bin.com/img/apple-touch-icon.png" name="twitter:image">
        <meta content="@src_bin" name="twitter:site">
        <meta content="Source &amp; Binary / Substrate manual / $(head -n"1" "$PATHNAME" | sed "s/^# //")" name="twitter:title">
        <meta content="width=device-width,initial-scale=1" name="viewport">
        <meta content="A page from the Substrate manual" property="og:description">
        <meta content="https://src-bin.com/img/apple-touch-icon.png" property="og:image">
        <meta content="Source &amp; Binary / Substrate manual / $(head -n"1" "$PATHNAME" | sed "s/^# //")" property="og:title">
        <meta content="website" property="og:type">
        <meta content="https://src-bin.com/substrate/manual/${DIRNAME#"./"}/" property="og:url">
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
        Markdown.pl --html4tags "$PATHNAME" |
        sed -E "s/'/\\&rsquo;/g; s/ ([^ >]+<\/[a-z]+>)$/\\&nbsp;\\1/"
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
done
