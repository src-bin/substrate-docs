#!/bin/sh

set -e -x

OS=$(uname -s)
# brew install findutils and gnu-sed to make this work on macOS arm64
if [ $OS = 'Darwin' ]; then
    HOMEBREW=/opt/homebrew
    PATH=$HOMEBREW/opt/findutils/libexec/gnubin:$HOMEBREW/opt/gnu-sed/libexec/gnubin:$PATH
fi

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
                    <li><a href="/substrate/">Substrate</a></li>
                    <li><a href="/substrate/manual/">Documentation</a></li>
                    <li><a href="/substrate/pricing/">Pricing</a></li>
                    <!--<li><a href="/compliance/">Compliance Workshop</a></li>-->
                </ul>
            </nav>
        </header>

        <section>
EOF
        echo
        perl -e "require \"$(which Markdown.pl)\"; srand(47); \$m = Text::Markdown->new(empty_element_suffix => \"\>\"); print \$m->markdown(join(\"\", <>));" <"$PATHNAME" |
        sed -E "s/'/\\&rsquo;/g; s/ ([^ >]+<\/[a-z]+>)$/\\&nbsp;\\1/"
        echo
        cat <<EOF
        </section>

        <footer>
            <p class="fine-print">&copy; 2020-2023 &mdash; Source <span class="fancy">&amp;</span> Binary&nbsp;LLC</p>
        </footer>
        <script async src="https://www.googletagmanager.com/gtag/js?id=G-T1M8F1RWMC"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', 'G-T1M8F1RWMC');
        </script>
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
