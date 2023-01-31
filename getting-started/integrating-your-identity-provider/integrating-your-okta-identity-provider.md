# Integrating your Okta identity provider

`substrate create-admin-account -quality`` `_`quality`_ will ask for several inputs, which this page will help you provide from your Okta identity provider.

1. Visit your Okta admin panel in a browser
2. Click the **hamburger menu**
3. Click **Applications** in the **Applications** section
4. Click **Create App Integration**
5. Select “OAuth - OpenID Connect”
6. Select “Web Application”
7. Click **Next**
8. Customize _App integration name_
9. Change the first/only item in _Sign-in redirect URIs_ to “https://_intranet-dns-domain-name_/login” (substituting your just-purchased or just-transferred Intranet DNS domain name)
10. Remove all _Sign-out redirect URIs_
11. Select “Limit access to selected groups” and select the groups that are authorized to use AWS (or choose another option; this can always be reconfigured)
12. Click **Save**
13. Paste the _Client ID_, _Client secret_, and _Okta domain_ in response to `substrate create-admin-account`'s prompts

Previous:\
[Integrating your identity provider to control access to AWS](../../integrating-your-identity-provider/)

Next:\
[Deleting unnecessary root access keys](../../deleting-unnecessary-root-access-keys/)
