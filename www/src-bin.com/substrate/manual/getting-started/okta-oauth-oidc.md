# Okta OAuth OIDC setup

1. Visit your Okta admin panel in a browser
2. Click **Applications**
3. Click **Add Application**
4. Click **Web**
5. Click **Next**
6. Customize _Name_
7. Remove all _Base URIs_
8. Change the first/only item in _Login redirect URIs_ to &ldquo;[https://example.com/login](https://example.com/login)&rdquo; (substituting your intranet DNS domain name)
9. Remove all _Logout redirect URIs_
10. Click **Done**
11. Paste the _Client ID_, _Client secret_, and _Okta hostname_ in response to `substrate-create-admin-account`'s prompts
