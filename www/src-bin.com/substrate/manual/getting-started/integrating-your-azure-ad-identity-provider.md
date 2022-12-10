# Integrating your Azure AD identity provider

<code>substrate create-admin-account -quality <em>quality</em></code> will ask for several inputs, which this page will help you provide from your Azure AD identity provider.

These steps must be completed by an Azure administrator with the Application Administrator, Attribute Assignment Administrator, and Attribute Definition Administrator roles in an organization subscribed to Azure AD Premium 1 or Azure AD Premium 2.

## Create a custom security attribute for assigning IAM roles to Azure AD users

1. Visit <https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/CustomAttributesCatalog> in a browser (or visit the Azure portal, click **Azure Active Directory**, and click **Custom security attributes (Preview)**)
2. Click **Add attribute set**
3. Enter &ldquo;AWS&rdquo; for _Attribute set name_
4. Click **Add**
5. Click **AWS**
6. Click **Add attribute**
7. Enter &ldquo;RoleName&rdquo; for _Attribute name_
8. Click **Save**

## Create and configure an OAuth OIDC client

TODO YOU LEFT OFF HERE

1. Visit <https://portal.azure.com/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/RegisteredApps> in a browser (or visit the Azure portal, click **Azure Active Directory**, and click **App registrations**)
2. Click **New registration**
3. Enter a name for the application
4. Select &ldquo;Accounts in this organizational directory only (Default Directory only - Single tenant)&rdquo;
5. Select &ldquo;Web&rdquo; as the platform
6. Enter &ldquo;https://<em>intranet-dns-domain-name</em>/login&rdquo; (substituting your just-purchased or just-transferred Intranet DNS domain name) next to the platform selector in the text input with _e.g. https://example.com/auth_ as its placeholder
7. Click **Register**
8. Use the _Application (client) ID_ to respond to `substrate create-admin-account`'s prompt
9. Click **Add a certificate or secret**
10. Click **New client secret**
11. Enter a description
12. Specify an expiration date however you see fit and set yourself a reminder to rotate the client secret before that date arrives
13. Click **Add**
14. Use the _Value_ to respond to `substrate create-admin-account`'s prompt (being wary that this value will never be shown again; if you need to copy it again, you'll need to create a new client secret)

## Authorize users to use AWS

1. Visit <https://portal.azure.com/#view/Microsoft_AAD_UsersAndTenants/UserManagementMenuBlade/~/AllUsers> in a browser (or visit the Azure portal, click **Azure Active Directory**, and click **Users**)
2. For every user authorized to use AWS:
    1. Click the user's name
    2. Click **Custom security attributes (preview)**
    3. Click **Add assignment**
    4. Select &ldquo;AWS&rdquo; in the _Attribute set_ column
    5. Select &ldquo;RoleName&rdquo; in the _Attribute name_ column
    6. Enter the name (not the ARN) of the IAM role they should assume in your admin account (&ldquo;Administrator&rdquo; for yourself as you're getting started; if for others it's not &ldquo;Administrator&rdquo; or &ldquo;Auditor&rdquo;, ensure you've followed [adding non-Administrator roles for humans](../../adding-non-administrator-roles-for-humans/) first)
    7. Click **Save**

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../integrating-your-identity-provider/">Integrating your identity provider to control access to AWS</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../deleting-unnecessary-root-access-keys/">Deleting unnecessary root access keys</a></p>
    </section>
</section>
