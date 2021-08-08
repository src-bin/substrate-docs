# Regaining access if Credential and Instance Factories are broken

If for some reason your Credential and Instance Factories are both broken, which could in fact be because the API Gateway authenticator and/or authorizer that ties them to your identity provider are broken, you'll find yourself feeling pretty locked out.

If you happen to have credentials in your shell environment that are still valid, you can run `substrate-create-admin-account` to remedy the situation.

More likely, though, you'll need to follow these steps:

1. Login to the AWS Console via your identity provider (or, in extreme situations, login to your AWS organization's management account directly and skip to step 3)
2. Assume the `OrganizationAdministrator` role in your management account (using the information in `substrate.accounts.txt` as your guide)
3. Visit [https://console.aws.amazon.com/iam/home?#/users/OrganizationAdministrator?section=security_credentials](https://console.aws.amazon.com/iam/home?#/users/OrganizationAdministrator?section=security_credentials)
4. Click **Create access key**
5. Provide the resulting access key ID and secret access key to `substrate-create-admin-account`
6. When your Credential and Instance Factories return to service, delete the access key you created in step 4
