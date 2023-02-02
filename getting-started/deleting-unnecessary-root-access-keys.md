# Deleting unnecessary root access keys

Once you have credentials from the Credential Factory or are logged into an EC2 instance from the Instance Factory, verify that you can run `substrate assume-role -management`. If so, you can finally delete your root and OrganizationAdministrator access keys. They're simply security liabilities. Let's delete them:

1. Run `substrate delete-static-access-keys` to delete access keys for the OrganizationAdministrator IAM user in your management account
2. Visit <https://console.aws.amazon.com/iam/home#/security_credentials> while signed in using the root email address, password, and second factor on your management account
3. Scroll to the _Access keys_ section
4. Select your root access key
5. Click **Actions**
6. Click **Delete**
7. Click **Deactivate**
8. Paste the access key ID into the confirmation prompt
9. Click **Delete**

From now on, the Credential and Instance Factories are how you access your organization via the command line.

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../integrating-your-identity-provider/">Integrating your identity provider to control access to AWS</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../integrating-your-original-aws-account/">Integrating your original AWS account(s)</a></p>
    </section>
</section>
