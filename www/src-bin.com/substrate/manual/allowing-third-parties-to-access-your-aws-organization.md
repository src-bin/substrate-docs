# Allowing third parties to access your AWS organization

Most modern business use hundreds of SaaS products to get the job done. In organizations that deliver software services themselves, many of these third parties are integrated into the development and operation of the software and that often means they need some amount of access to AWS. Here are several ways to give them access.

The best strategies use IAM roles to avoid the need for long-lived access keys. If available, choose these over strategies that use IAM users.

## Special-purpose IAM roles in certain accounts

Simplistic integrations with AWS will require you to create an IAM role in each account the third party needs to access. This can be tedious for you, having many AWS accounts, but it's perhaps the best security story because everything is very explicit. The pattern is just like [adding non-Administrator (and non-Auditor) roles for humans](../adding-non-administrator-roles-for-humans/) (the &ldquo;in your service accounts&rdquo; section), trusting the third party's AWS account number or IAM role ARN instead of your admin account.

## Special-purpose IAM role that can assume roles

More advanced integrations with AWS, ones that are aware of AWS Organizations, may be able to use `sts:AssumeRole` to move around your organization automatically. For these cases, act like you're [adding non-Administrator (and non-Auditor) roles for humans](../adding-non-administrator-roles-for-humans/), following every step. Trust the third party's account number or IAM role ARN to assume the role in your admin account; trust that role to assume the role in all your service accounts.

## Reusing the Substrate-managed Auditor role

A great many integrations can be trusted with read-only access (specifically, the kind of read-only access that Substrate manages, without blanket `s3:GetObject`). In those cases, the `substrate.Auditor.assume-role-policy.json` file discussed along with [auditing your Substrate-managed AWS organization](../auditing/) offers a simple solution.

## Reusing the Substrate-managed Administrator role

Sometimes you will want to grant third-parties administrative access (e.g. to allow a CI/CD system to `terraform apply`). In those cases, the `substrate.Administrator.assume-role-policy.json` file discussed in [adding administrators to your AWS organization](../adding-administrators/) offers a simple solution.

## Creating an IAM user

If no better option exists, you can create an IAM user for a third party. Here, due to the riskier credential management story, we recommend granting absolutely minimal permissions. In the example, we'll use Circle CI, a service that (at the time of this writing) only supported AWS integration via IAM user.

1. <code>root-modules/admin/<em>quality</em>/global/<em>circle-ci</em>.tf</code>: Add an IAM user in your admin account; allow it to `sts:AssumeRole`, constraining which roles it's allowed to assume as you see fit
2. <code>root-modules/<em>domain</em>/<em>environment</em>/<em>quality</em>/global/admin-providers.tf</code>: Add a provider referencing your admin account with `alias = "admin"` so that the IAM user in your admin account may assume roles in this other account
    - This isn't strictly necessary &mdash; IAM users can of course be created in any AWS account &mdash; but it's more convenient to centralize credential management in your admin accounts so it's easier to manage multiple domains, environments, and/or qualities
3. <code>root-modules/<em>domain</em>/<em>environment</em>/<em>quality</em>/global/main.tf</code>: Add `aws.admin = aws.admin` to the `providers` map passed to <code>module "<em>domain</em>"</code> so that the IAM role in step 6 may reference the IAM user from step 1 (substituting the domain, environment, and quality of the account in question)
4. <code>modules/<em>domain</em>/global/admin-providers.tf</code>: Add `provider "aws" { alias = "admin" }` to tell Terraform to expect an `aws.admin` provider
5. <code>modules/<em>domain</em>/global/main.tf</code>: Add a data source that looks up the Circle CI user in the admin account using the `aws.admin` provider so that the IAM role in step 6 may reference the IAM user from step 1 (substituting the domain of the account in question)
6. <code>modules/<em>domain</em>/global/main.tf</code>: Add an IAM role that may be assumed by the Circle CI user in your admin account
7. <code>modules/<em>domain</em>/global/main.tf</code>: Attach policies, inline or managed, to allow the service account to perform its duties
8. <code>substrate create-admin-account -quality <em>quality</em></code>
9. <code>substrate create-account -domain <em>domain</em> -environment <em>environment</em> -quality <em>quality</em></code>
10. <code>aws iam create-access-key --user-name <em>circle-ci</em></code> and give the resulting access key to Circle CI

Again, this is risky, because you're about to let this access key out of your control. Be sure you trust the third party. If you've established a SOC 2 compliance program (or are even considering it), this third party is now a subprocessor and you should be reviewing their security practices and, ideally, their SOC 2 report.
