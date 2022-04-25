# Integrating your Google identity provider

<code>substrate create-admin-account -quality <em>quality</em></code> will ask for several inputs, which this page will help you provide from your Google identity provider.

These steps must be completed by a Google Super Admin. Be mindful, too, of which Google account you're using if you're signed into more than one in the same browser profile. Google has a habit of switching accounts when you least expect it.

## Create a custom schema for assigning IAM roles to Google users

1. Visit <https://admin.google.com/ac/customschema> in a browser (or visit <https://admin.google.com>, click **Users**, click **More**, and click **Manage custom attributes**)
2. Click **ADD CUSTOM ATTRIBUTE**
3. Enter &ldquo;AWS&rdquo; for _Category_
4. Under _Custom fields_, enter &ldquo;RoleName&rdquo; for _Name_, select &ldquo;Text&rdquo; for _Info type_, select &ldquo;Visible to user and admin&rdquo; for _Visibility_, select &ldquo;Single Value&rdquo; for _No. of values_
6. Click **ADD**

## Create and configure an OAuth OIDC client

1. Visit <https://console.developers.google.com/> in a browser
2. Click **CREATE PROJECT**
3. Name the project and, optionally, put it in an organization (but don't worry if you can't put it in an organization, because everything still works without one)
4. Click **CREATE**
5. Click **OAuth consent screen**
6. Select &ldquo;Internal&rdquo;
7. Click **CREATE**
8. Enter &ldquo;Intranet&rdquo; for _Application name_
9. Enter your Intranet DNS domain name in _Authorized domains_
10. Click **SAVE AND CONTINUE**
11. Click **Credentials** in the left column
12. Click **CREATE CREDENTIALS** and then **OAuth client ID** in the expanded menu
13. Select &ldquo;Web application&rdquo; for _Application type_
14. Enter a _Name_, if desired
15. Click **ADD URI** in the _Authorized redirect URIs_ section
16. Enter &ldquo;<https://example.com/login>&rdquo; (substituting your Intranet DNS domain name)
17. Click **CREATE**
18. Use the credentials to respond to `substrate create-admin-account`'s prompts
19. Visit <https://console.cloud.google.com/apis/library/admin.googleapis.com> in a browser
20. Confirm the project you created a moment ago is selected (its name will be listed next to &ldquo;Google Cloud Platform&rdquo; in the header)
21. Click **ENABLE**

## Authorize users to use AWS

1. Visit <https://admin.google.com/ac/users> in a browser (or visit <https://admin.google.com> and click **Users**)
2. For every user authorized to use AWS:
    1. Click the user's name
    2. Click **User information**
    3. In the _AWS_ section, click **Add RoleName** and paste the name (not the ARN) of the IAM role they should assume in your admin account (&ldquo;Administrator&rdquo; for yourself as you're getting started; if for others it's not &ldquo;Administrator&rdquo; or &ldquo;Auditor&rdquo;, ensure you've followed [adding non-Administrator roles for humans](../../adding-non-administrator-roles-for-humans/) first)
    4. Click **SAVE**

## References

- <https://cloud.google.com/identity-platform/docs/web/oidc>
- <https://developers.google.com/identity/protocols/oauth2/openid-connect>

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../integrating-your-identity-provider/">Integrating your identity provider to control access to AWS</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../deleting-unnecessary-root-access-keys/">Deleting unnecessary root access keys</a></p>
    </section>
</section>