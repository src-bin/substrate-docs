# Deleting unnecessary root access keys

Once you have credentials from the Credential Factory or are logged into an EC2 instance from the Instance Factory, verify that you can run `substrate assume-role -management`. If so, you can finally delete your root and OrganizationAdministrator access keys. They're simply security liabilities. Let's delete them:

1. Run `substrate delete-static-access-keys` to delete access keys for the OrganizationAdministrator IAM user in your management account
2. Visit [https://console.aws.amazon.com/iam/home#/security\_credentials](https://console.aws.amazon.com/iam/home#/security\_credentials) while signed in using the root email address, password, and second factor on your management account
3. Open the _Access keys (access key ID and secret access key)_ section
4. Click **Delete** next to your root access key

From now on, the Credential and Instance Factories are how you access your organization via the command line.
