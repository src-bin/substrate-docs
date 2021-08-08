# Adding a service account

You'll no doubt need to authorize service accounts - those granted to software services rather than human beings - to access various AWS resources for reasons ranging from test coverage to integration with third parties to enabling your customer-facing applications to provision AWS resources on demand.

This example shows how you grant access to e.g. Circle CI, though these steps apply to any sort of service account that needs an IAM user, as is commonly required by third parties. Service accounts for your own services can skip most of this and start at step 6.

1. `root-modules/admin/alpha/global/circle-ci.tf`: Add an IAM user in your admin account; allow it to `sts:AssumeRole`, constraining which roles it's allowed to assume as you see fit (substituting the quality of your admin account and the filename you want to use)
2. `root-modules/api/staging/alpha/global/admin-providers.tf`: Add a provider referencing your admin account with `alias = "admin"` so that the service account in your admin account may assume roles in this other account (substituting the domain, environment, and quality of the account in question)
    - This isn't strictly necessary - service accounts can of course be created in any AWS account - but it's more convenient to centralize credential management in your admin accounts so it's easier to manage multiple domains, environments, and/or qualities
3. `root-modules/api/staging/alpha/global/main.tf`: Add `aws.admin = aws.admin` to the `providers` map passed to `module "api"` so that the IAM role in step 6 may reference the IAM user from step 1 (substituting the domain, environment, and quality of the account in question)
4. `modules/api/global/admin-providers.tf`: Add `provider "aws" { alias = "admin" }` to tell Terraform to expect an `aws.admin` provider (substituting the domain of the account in question)
5. `modules/api/global/main.tf`: Add a data source that looks up the Circle CI user in the admin account using the `aws.admin` provider so that the IAM role in step 6 may reference the IAM user from step 1 (substituting the domain of the account in question)
6. `modules/api/global/main.tf`: Add an IAM role that may be assumed by the Circle CI user in your admin account (substituting the domain of the account in question)
7. `modules/api/global/main.tf`: Attach policies, inline or managed, to allow the service account to perform its duties (substituting the domain of the account in question)
8. `substrate-create-admin-account -quality=alpha` (substituting the quality of your admin account)
9. `substrate-create-account -domain=api -environment=staging -quality=alpha` (substituting the domain, environment, and quality of the account in question)
10. `aws iam create-access-key --user-name circle-ci` and give the resulting access key to Circle CI (substituting the name of the IAM user from step 1)
