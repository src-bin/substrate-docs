# Okta OAuth OIDC setup

1. Visit your Okta admin panel in a browser
2. Click the **hamburger menu**
3. Click **Applications** in the **Applications** section
4. Click **Create App Integration**
5. Select &ldquo;OAuth - OpenID Connect&rdquo;
6. Select &ldquo;Web Application&rdquo;
7. Click **Next**
8. Customize _App integration name_
8. Change the first/only item in _Sign-in redirect URIs_ to &ldquo;[https://example.com/login](https://example.com/login)&rdquo; (substituting your intranet DNS domain name)
9. Remove all _Sign-out redirect URIs_
9. Select &ldquo;Limit access to selected groups&rdquo; and select the groups that are authorized to use AWS (or choose another option; this can always be reconfigured)
10. Click **Save**
11. Paste the _Client ID_, _Client secret_, and _Okta domain_ in response to `substrate-create-admin-account`'s prompts
