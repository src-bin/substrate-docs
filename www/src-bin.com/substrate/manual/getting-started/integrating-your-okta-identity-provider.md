# Integrating your Okta identity provider

<code>substrate create-admin-account -quality <em>quality</em></code> will ask for several inputs, which this page will help you provide from your Okta identity provider.

1. Visit your Okta admin panel in a browser
2. Click the **hamburger menu**
3. Click **Applications** in the **Applications** section
4. Click **Create App Integration**
5. Select &ldquo;OAuth - OpenID Connect&rdquo;
6. Select &ldquo;Web Application&rdquo;
7. Click **Next**
8. Customize _App integration name_
8. Change the first/only item in _Sign-in redirect URIs_ to &ldquo;<https://example.com/login>&rdquo; (substituting your Intranet DNS domain name)
9. Remove all _Sign-out redirect URIs_
9. Select &ldquo;Limit access to selected groups&rdquo; and select the groups that are authorized to use AWS (or choose another option; this can always be reconfigured)
10. Click **Save**
11. Paste the _Client ID_, _Client secret_, and _Okta domain_ in response to `substrate create-admin-account`'s prompts

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../integrating-your-identity-provider/">Integrating your identity provider to control access to AWS</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../deleting-unnecessary-root-access-keys/">Deleting unnecessary root access keys</a></p>
    </section>
</section>
