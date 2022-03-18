# Getting started with Substrate

Substrate helps you manage secure, reliable, and compliant cloud infrastructure in AWS. This part of the manual exists to guide you through installing Substrate and bootstrapping your Substrate-managed AWS organization.

## Prerequisites

- [Terraform 1.1.6](https://releases.hashicorp.com/terraform/1.1.6/) (unzip and put `terraform` on your `PATH`)

## Installation

<!--### From a binary release-->

`tar xf substrate-VERSION-COMMIT-GOOS-GOARCH.tar.gz -C ~/bin` (substituting the filename where you've stored the binary release and the directory on your `PATH` where you want it installed)

<!--
### From source

Additional prerequsites:

- [Go 1.17](https://golang.org/dl/)
- GNU Make

Procedure:

1. `git clone git@github.com:src-bin/substrate.git`
2. `cd substrate`
3. `make && make install` (or `make && make install GOBIN="..."` if you want to customize `GOBIN` where it's installed)
-->

## Decide where you'll run Substrate commands

All Substrate commands should be run from the same directory. Many commands will read and write files there to save your input and pass configuration and state from one command to another.

The most natural options are, in no particular order:

- The root of the Git repository where you keep your Terraform code
- A subdirectory of a Git repository
- A new Git repository just for Substrate

(Git is by no means required - you're free to choose any version control software.)

You can always change your mind on this simply by moving `substrate.*` and all the Terraform modules that Substrate generates into another directory.

Decide and change to that directory before proceeding.

## Bootstrapping your management account

### Sign up for a new AWS account

Substrate is designed to manage your entire AWS organization. As such it is highly recommended that you start using Substrate in a brand new AWS account. Later you'll have opportunities to bring preexisting AWS accounts into the fold.

You should strongly consider creating a mailing list or alias like <aws@example.com> to own your AWS organization as it provides your company flexibility later as personnel and roles change. If you're using Google Groups, ensure that your group allows _External_ users to _Publish posts_.

Visit [https://portal.aws.amazon.com/billing/signup](https://portal.aws.amazon.com/billing/signup#/start) to begin. Sign up for a new account, provide payment information, and verify your phone number. This account will remain nearly devoid of activity once the rest of the Substrate organization is configured.

You should setup multi-factor authentication for the root of this new account immediately:

1. Visit [https://console.aws.amazon.com/iam/home#/security\_credentials](https://console.aws.amazon.com/iam/home#/security_credentials)
2. Open the _Multi-factor authentication (MFA)_ section
3. Click **Activate MFA**
4. Follow the prompts as you see fit

### `substrate-bootstrap-management-account`

When you run this program, you'll be prompted several times for input. As much as is possible, this input is all saved to the local filesystem and referenced on subsequent runs.

The first of these inputs is an access key from the root of your new AWS account. It is never saved to disk (for security reasons) so keep it handy until later in this guide when it you're told it's safe to delete it. To create a root access key:

1. Visit [https://console.aws.amazon.com/iam/home#/security\_credentials](https://console.aws.amazon.com/iam/home#/security_credentials)
2. Open the _Access keys (access key ID and secret access key)_ section
3. Click **Create New Access Key**
4. Click **Show Access Key**
5. Save these values in your password manager for now

This program creates your AWS organization, creates the audit account and enables CloudTrail, creates the deploy and network accounts, configures a basic service control policy, and creates the necessary roles and policies to allow your administrators to move relatively freely.

When this program exits, you should commit `substrate.*` to version control. Do not forget your root access key yet. It is safe to re-run this program at any time.

### Delegate access to billing data

While you're logged into your management account using the root credentials, follow these steps to delegate access to billing data to people and tools assuming IAM roles.

1. Visit [https://console.aws.amazon.com/billing/home?#/account](https://console.aws.amazon.com/billing/home?#/account)
2. Open the _IAM User and Role Access to Billing Information_ section
3. Check &ldquo;Activate IAM Access&rdquo;
4. Click **Update**
5. Visit [https://console.aws.amazon.com/billing/home#/costexplorer](https://console.aws.amazon.com/billing/home#/costexplorer)
6. Click **Enable Cost Explorer**

## Bootstrapping your deploy and network accounts

The previous step created the three special AWS accounts - audit, deploy, and network - but neglected to complete the configuration of the deploy and network accounts. The reason for this is because both of these accounts are managed by Terraform code. The bootstrapping steps generate some code while leaving room for you to add more later.

### `substrate-bootstrap-network-account`

Here, too, during your first run you'll be prompted for your root access key.

This program additionally asks for the names of your environments, the release qualities you want to use, and the specific combinations that are valid. Environments typically have names like &ldquo;development&rdquo; and &ldquo;production&rdquo; - they identify a set of data and all the infrastructure that may access it. Qualities are names given to independent copies of your infrastructure _within an environment_ that make it possible to gradually deploy changes to AWS resources just like you might gradually deploy changes to your software.

It also asks which AWS regions you want to use. Your answers inform how it lays out your networks to strike a balance between security, reliability, ergonomics, and cost. Substrate recommends starting with 2-4 regions that make geographic sense to your customers.

This program may attempt to programmatically raise the limit on some specific AWS service quotas. Depending on the regions you chose, how many environments and qualities you specified, and how the AWS support staff are feeling, this may block you for a long time. It's recommended to start slow by, for instance, only specifying &ldquo;admin&rdquo; and &ldquo;staging&rdquo; environments, expecting to add more later.

When this program exits, you should commit `substrate.*` and `root-modules/network/` to version control. It is safe to re-run this program at any time and during those runs you can add additional environments and qualities if you so choose.

### `substrate-bootstrap-deploy-account`

This program doesn't need any input except during its first run in which you'll be prompted for your root access key.

When this program exits, you should commit `root-modules/deploy/` to version control. It is safe to re-run this program at any time.

## Creating your first admin account

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
2. Visit [https://console.aws.amazon.com/iam/home#/security\_credentials](https://console.aws.amazon.com/iam/home#/security_credentials) (as also prompted by the tool above)
3. Open the _Access keys (access key ID and secret access key)_ section
4. Click **Delete** next to your root access key

From now on, the Credential and Instance Factories are how you access your organization via the command line.

## Building your staging environment

If you're like most modern teams, the vast majority of your development work is happening on folks' laptops. Thus, it probably makes the most sense for the first cloud infrastructure to be something more like a staging environment for a service which demands high reliability.

### `substrate-create-account -domain="..." -environment="staging" -quality="default"`

This is the first of probably many accounts that'll be created in your organization. This command creates an empty root Terraform module that's ready to hold whatever you need it to. Here, for the first time, you're being asked to name a domain, as well as an environment and quality. A domain is a collection of one or more applications/services, often owned by the same group of people, that run in an AWS account of their own to protect them from changes in other domains.

When this program exits, you should commit the generated files to version control as instructed. It is safe to re-run this program at any time.

## Bringing existing AWS accounts into the fold

Inviting your existing AWS account(s) into your new Substrate-managed AWS organization is a good idea for a few reasons:

- It can quickly improve your security posture if you create an `Administrator` role there that can be assumed by the `Administrator` role in your admin account(s), thus allowing you to delete long-lived access keys and uncontrolled IAM users there.
- It may simplify some migrations by allowing policies written using the `aws:PrincipalOrgID` condition key to interoperate with this account.
- Integrating access to its billing data will give you better visibility into the state of migration into Substrate-managed accounts.

To begin, you'll need root login credentials for the AWS Console for the account you wish to invite into your organization. When you're ready, proceed:

1. Open the AWS Console via your identity provider; assume the `Administrator` role
2. Assume the `OrganizationAdministrator` role in your management account via your Intranet's accounts page
3. Visit <https://console.aws.amazon.com/organizations/home?#/accounts>
4. Click **Add account**
5. Click **Invite account**
6. Enter the email address attached to the account you're inviting into your organization (or its account number, if you have that handy)
7. Click **Invite**
8. In an incognito window, sign into the AWS Console using your root credentials for the account you just invited into your organization
9. In that incognito window, visit <https://console.aws.amazon.com/cloudtrail/home#/dashboard> and delete any existing trails (to avoid very expensive surprises in your consolidated AWS bills)
10. In that incognito window, visit <https://console.aws.amazon.com/organizations/home#/invites>
11. Click **Accept**
12. Click **Confirm**

If you stop here, you'll have integrated billing data from your legacy account into your organization and you'll have the ability to constrain your legacy account using service control policies.

To allow your admin accounts to access this legacy account, proceed:

1. Note all the role ARNs in the table listing your admin accounts in `substrate.accounts.txt`
2. Create a new role named `Administrator` in your legacy account with the following assume role policy, substituting your admin account number for `ADMIN_ACCOUNT_NUMBER` (and adding additional elements to that list if you have multiple admin accounts):

        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "AWS": [
                  "arn:aws:iam::ADMIN_ACCOUNT_NUMBER:role/Administrator",
                  "arn:aws:iam::ADMIN_ACCOUNT_NUMBER:role/Intranet"
                ]
              },
              "Action": "sts:AssumeRole"
            }
          ]
        }

3. Attach the managed `AdministratorAccess` policy to this new role

You can follow those steps in the AWS Console or implement this policy using your legacy account's CloudFormation or Terraform infrastructure. Once you've done so, reap the security benefits of disabling any long-lived access keys your legacy account's IAM users have.

After you've completed these steps, your legacy account is part of your Substrate-managed AWS organization. It's not presumed to be totally interoperable, though, so Substrate will not take any actions against it automatically.

## Operate your organization

Now might be a good time to read through more of the Substrate manual to better understand exactly what you have at your fingertips and how best to use it:

- [Domains, environments, and qualities](/substrate/manual/domains-environments-qualities/)
- [Your Substrate-managed AWS organization](/substrate/manual/your-aws-organization/)

Or you can jump straight into your new daily workflow: [Your daily workflow in your Substrate-managed AWS organization](/substrate/manual/your-daily-workflow/)

This manual includes architectural advice, specific guidance on adding domains, environments, qualities, and regions, deploying software, auditing, cost management, and more - see the [table of contents](/substrate/manual/).
