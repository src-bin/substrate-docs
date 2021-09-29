# Google OAuth OIDC setup

Be mindful of which GSuite account you're using throughout this process if you're signed into more than one in the same browser profile. Google has a habit of switching accounts when you least expect it.

1. Visit [https://console.developers.google.com/](https://console.developers.google.com/) in a browser
2. Click **CREATE PROJECT**
3. Name the project and, optionally, put it in an organization (but don't worry if you can't put it in an organization, because everything still works without one)
4. Click **CREATE**
5. Click **OAuth consent screen**
6. Select &ldquo;Internal&rdquo;
7. Click **CREATE**
8. Enter &ldquo;Intranet&rdquo; for _Application name_
9. Enter your intranet DNS domain name in _Authorized domains_
10. Click **Save**
11. Click **Credentials** in the left column
12. Click **CREATE CREDENTIALS** and then **OAuth client ID** in the expanded menu
13. Select &ldquo;Web application&rdquo; for _Application type_
14. Enter a _Name_, if desired
15. Click **ADD URI** in the _Authorized redirect URIs_ section
16. Enter &ldquo;[https://example.com/login](https://example.com/login)&rdquo; (substituting your intranet DNS domain name)
17. Click **CREATE**
18. Use the credentials to respond to `substrate-create-admin-account`'s prompts

## References

- [https://cloud.google.com/identity-platform/docs/web/oidc](https://cloud.google.com/identity-platform/docs/web/oidc)
- [https://developers.google.com/identity/protocols/oauth2/openid-connect](https://developers.google.com/identity/protocols/oauth2/openid-connect)
