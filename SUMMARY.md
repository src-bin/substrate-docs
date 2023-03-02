# Table of contents

* [Welcome](README.md)
* [Release notes](releases.md)

## Bootstrapping your Substrate-managed AWS organization <a href="#bootstrapping" id="bootstrapping"></a>

* [Overview](bootstrapping/overview.md)
* [Opening a fresh AWS account](bootstrapping/opening-a-fresh-aws-account.md)
* [Installing Substrate and Terraform](bootstrapping/installing.md)
* [Configuring Substrate shell completion](bootstrapping/shell-completion.md)
* [Bootstrapping your Substrate-managed AWS organization](bootstrapping/bootstrapping.md)
* [Integrating your identity provider to control access to AWS](bootstrapping/integrating-your-identity-provider/README.md)
  * [Integrating your Azure AD identity provider](bootstrapping/integrating-your-identity-provider/azure-ad.md)
  * [Integrating your Google identity provider](bootstrapping/integrating-your-identity-provider/google.md)
  * [Integrating your Okta identity provider](bootstrapping/integrating-your-identity-provider/okta.md)
* [Deleting unnecessary root access keys](bootstrapping/deleting-unnecessary-root-access-keys.md)
* [Integrating your original AWS account(s)](bootstrapping/integrating-your-original-aws-account.md)

## Using Substrate <a href="#use" id="use"></a>

* [Getting started (after someone else has bootstrapped Substrate)](use/getting-started.md)
* [Daily workflow](use/daily-workflow.md)
* [Upgrading Substrate](use/upgrading.md)

## Accessing and navigating AWS <a href="#access" id="access"></a>

* [Accessing AWS in your terminal](access/accessing-aws-in-your-terminal.md)
* [Accessing the AWS console](access/accessing-the-aws-console.md)
* [Moving between AWS accounts](access/moving-between-aws-accounts.md)
* [Using AWS CLI profiles](access/aws-cli-profiles.md)
* [Jumping into private networks](access/jumping-into-private-networks.md)
* [Enumerating all your AWS accounts](access/enumerating-all-your-aws-accounts.md)
* [Enumerating all your root Terraform modules](access/enumerating-all-your-root-terraform-modules.md)
* [Enumerating all your custom AWS IAM roles](access/enumerating-all-your-aws-iam-roles.md)
* [Cost management](access/cost-management.md)
* [Deep-linking into the AWS Console](access/deep-linking-into-the-aws-console.md)

## Managing AWS accounts, roles, and resources <a href="#mgmt" id="mgmt"></a>

* [Managing your infrastructure in service accounts](mgmt/service-accounts.md)
* [Adding a domain](mgmt/adding-a-domain.md)
* [Adding an environment or quality](mgmt/adding-an-environment-or-quality.md)
* [Adding custom IAM roles for humans or services](mgmt/custom-iam-roles.md)
* [Onboarding users](mgmt/onboarding-users.md)
* [Offboarding users](mgmt/offboarding-users.md)
* [Allowing third parties to access your AWS organization](mgmt/allowing-third-parties-to-access-your-aws-organization.md)
* [Adding administrators to your AWS organization](mgmt/adding-administrators.md)
* [Subscribing to AWS support plans](mgmt/aws-support.md)
* [Removing an AWS account from your organization](mgmt/removing-an-aws-account-from-your-organization.md)
* [Closing an AWS account](mgmt/closing-an-aws-account.md)
* [Adding an AWS region](mgmt/adding-an-aws-region.md)
* [Removing an AWS region](mgmt/removing-an-aws-region.md)
* [Using Amazon EC2 when IMDSv2 is required](mgmt/ec2-imdsv2.md)
* [Customizing EC2 instances from the Instance Factory](mgmt/customizing-instance-factory.md)
* [Writing Terraform code](mgmt/writing-terraform-code.md)
* [Additional Terraform providers](mgmt/additional-terraform-providers.md)
* [Deploying software](mgmt/deploying-software.md)
* [Protecting internal websites](mgmt/protecting-internal-websites.md)

## Compliance

* [Addressing SOC 2 criteria with Substrate](compliance/addressing-soc-2-criteria-with-substrate.md)
* [Auditing your Substrate-managed AWS organization](compliance/auditing.md)

## Architectural reference <a href="#ref" id="ref"></a>

* [Accounts in a Substrate-managed AWS organization](ref/accounts.md)
* [Diagram of a Substrate-managed AWS organization](ref/diagram-substrate-managed-aws-organization.md)
* [Domains, environments, and qualities](ref/domains-environments-qualities.md)
* [Root Terraform modules](ref/root-terraform-modules.md)
* [Global and regional Terraform modules](ref/global-and-regional-terraform-modules.md)
* [Substrate filesystem hierarchy](ref/substrate-filesystem-hierarchy.md)
* [Networking](ref/networking.md)
* [Diagram of a multi-quality, multi-region service](ref/diagram-multi-quality-multi-region-service.md)
* [Multi-region strategy](ref/multi-region-strategy.md)
* [Technology choices](ref/technology-choices.md)
* [Multi-tenancy](ref/multi-tenancy.md)
* [Deciding where to host internal tools](ref/internal-tools.md)
* [Telemetry in Substrate](ref/telemetry.md)

## Runbooks for emergency and once-in-a-blue-moon operations <a href="#runbooks" id="runbooks"></a>

* [Changing identity providers](runbooks/changing-identity-providers.md)
* [Sharing CloudWatch data between accounts](runbooks/cloudwatch-sharing.md)
* [Regaining access in case the Credential and Instance Factories are broken](runbooks/regaining-access.md)
* [Debugging Substrate](runbooks/debugging.md)

## Meta

* [Typographical conventions](meta/typography.md)
