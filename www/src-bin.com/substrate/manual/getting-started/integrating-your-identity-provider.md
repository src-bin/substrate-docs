# Integrating your identity provider

TODO review and incorporate the Google/Okta files more nicely

### Sign up for Google Workspace or Okta

You'll need an identity provider to broker access to the AWS Console and to Intranet tools (some of which Substrate brings but others which you may eventually develop yourself). Substrate supports [Google Workspace](https://workspace.google.com) and [Okta](https://www.okta.com). Which one should you choose?

Your organization probably already uses Google to host your mail and calendars. Why not use it to broker access to the AWS Console and your Intranet? It's perfectly capable. You'll find, however, that Okta's strength is in scale. In Google Workspace, each user that's granted access to the AWS Console must have a specific and very long string attached to a custom attribute in their account. Okta's integration with AWS IAM roles is much better when you're managing even dozens of users.

Feel free to try them both. Whichever you choose, take comfort in knowing your decision isn't permanent. You can switch an admin account from one to the other by re-running the command in the next section and answering the prompts differently.

### `substrate-create-admin-account -quality="default"`

As is the custom, you'll be prompted for input, this time concerning your identity provider and the Intranet this command constructs. After the account is created, this program will create and configure the Intranet hosted in AWS API Gateway and Lambda.

You'll be prompted to buy or transfer a DNS domain name or delegate a DNS zone from elsewhere into this new account. If you're at a loss for inspiration, consider using your company's name with the `.company` or `.tools` TLD.  Note well: The domain must end up owned by or delegated to the admin account being created by this step. **Be sure to respond to the emails sent by Route 53 (which Google often flags as suspicious) to avoid your domain being suspended in a few days.**

We'll use [example.com](http://example.com) as a placeholder for this domain throughout the rest of this guide. With that domain in hand, this program configures API Gateway and Lambda to serve authenticated and authorized web pages that serve up short-lived administrative AWS credentials, on-demand EC2 instances, and access to the AWS Console. You'll be prompted for OAuth OIDC credentials from your identity provider, which can be created as follows:

- [Google OAuth OIDC setup](/substrate/manual/getting-started/google-oauth-oidc/)
- [Okta OAuth OIDC setup](/substrate/manual/getting-started/okta-oauth-oidc/)

When this program exits, you should commit `substrate.*`, `root-modules/admin/default`, and `modules` to version control. It is safe to re-run this program at any time. It is also safe to have multiple admin accounts of various qualities.

### Accessing the AWS Console

Visit the `/accounts` page of your new Intranet (at a URL like <https://example.com/accounts> but on the domain you just purchased) or provide the `-console` option to `substrate-assume-role`.

### Using the Credential Factory

Run `eval $(substrate-credentials)` in your terminal and follow its instructions. You'll be asked to login via your identity provider.

Or visit [https://example.com/credential-factory](https://example.com/credential-factory), login, and paste the `export` command into your terminal.

### Using the Instance Factory

Visit [https://example.com/instance-factory](https://example.com/instance-factory) and follow the steps to provision an EC2 instance to use for your administrative work.

## Deleting your root credentials

Once you have credentials from the Credential Factory or are logged into an EC2 instance from the Instance Factory, verify that you can run `substrate-assume-role -special="management" -role="OrganizationAdministrator"`. If so, you can finally delete your root and `OrganizationAdministrator` access keys. They're simply security liabilities. Let's delete them:

1. Run `substrate-delete-static-access-keys` to delete access keys for the `OrganizationAdministrator` IAM user in your management account
2. Visit <https://console.aws.amazon.com/iam/home#/security_credentials> (as also prompted by the tool above)
3. Open the _Access keys (access key ID and secret access key)_ section
4. Click **Delete** next to your root access key

From now on, the Credential and Instance Factories are how you access your organization via the command line.

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../integrating-your-original-aws-account/">Integrating your original AWS account</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../managing-your-infrastructure-in-service-accounts/">Managing your infrastructure in service accounts</a></p>
    </section>
</section>
