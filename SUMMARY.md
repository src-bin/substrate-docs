# Table of contents

* [Substrate docs](README.md)

## Getting started

* [Overview](getting-started/overview.md)
* [Opening a fresh AWS account](getting-started/opening-a-fresh-aws-account.md)
* [Installing Substrate and Terraform](getting-started/installing.md)
* [Configuring Substrate shell completion](getting-started/shell-completion.md)
* [Bootstrapping your Substrate-managed AWS organization](getting-started/bootstrapping.md)
* [Integrating your identity provider to control access to AWS](getting-started/integrating-your-identity-provider/README.md)
  * [Integrating your Azure AD identity provider](getting-started/integrating-your-identity-provider/integrating-your-azure-ad-identity-provider.md)
  * [Integrating your Google identity provider](getting-started/integrating-your-identity-provider/integrating-your-google-identity-provider.md)
  * [Integrating your Okta identity provider](getting-started/integrating-your-identity-provider/integrating-your-okta-identity-provider.md)
* [Deleting unnecessary root access keys](getting-started/deleting-unnecessary-root-access-keys.md)
* [Integrating your original AWS account(s)](getting-started/integrating-your-original-aws-account.md)
* [Managing your infrastructure in service accounts](getting-started/managing-your-infrastructure-in-service-accounts.md)

## Concepts and terms

* [Accounts in a Substrate-managed AWS organization](concepts-and-terms/accounts.md)
* [Domains, environments, and qualities](concepts-and-terms/domains-environments-qualities.md)
* [Networking](concepts-and-terms/networking.md)
* [Diagram of a Substrate-managed AWS organization](concepts-and-terms/diagram-substrate-managed-aws-organization.md)
* [Global and regional Terraform modules](concepts-and-terms/global-and-regional-terraform-modules.md)
* [Root Terraform modules](concepts-and-terms/root-terraform-modules.md)
* [Substrate filesystem hierarchy](concepts-and-terms/substrate-filesystem-hierarchy.md)

## Architectural guidance

* [Technology choices](architectural-guidance/technology-choices.md)
* [Multi-tenancy](architectural-guidance/multi-tenancy.md)
* [Diagram of a multi-quality, multi-region service](architectural-guidance/diagram-multi-quality-multi-region-service.md)
* [Deciding where to host internal tools](architectural-guidance/internal-tools.md)

## Working in your Substrate-managed AWS organization

* [Accessing AWS in your terminal](working-in-your-substrate-managed-aws-organization/accessing-aws-in-your-terminal.md)
* [Accessing the AWS console](working-in-your-substrate-managed-aws-organization/accessing-the-aws-console.md)
* [Moving between AWS accounts](working-in-your-substrate-managed-aws-organization/moving-between-aws-accounts.md)
* [Using AWS CLI profiles](working-in-your-substrate-managed-aws-organization/aws-cli-profiles.md)
* [Jumping into private networks](working-in-your-substrate-managed-aws-organization/jumping-into-private-networks.md)
* [Writing Terraform code](working-in-your-substrate-managed-aws-organization/writing-terraform-code.md)
* [Using Amazon EC2 when IMDSv2 is required](working-in-your-substrate-managed-aws-organization/ec2-imdsv2.md)
* [Additional Terraform providers](working-in-your-substrate-managed-aws-organization/additional-terraform-providers.md)
* [Adding a domain](working-in-your-substrate-managed-aws-organization/adding-a-domain.md)
* [Adding an environment or quality](working-in-your-substrate-managed-aws-organization/adding-an-environment-or-quality.md)
* [Adding an AWS region](working-in-your-substrate-managed-aws-organization/adding-an-aws-region.md)
* [Deploying software](working-in-your-substrate-managed-aws-organization/deploying-software.md)
* [Protecting internal websites](working-in-your-substrate-managed-aws-organization/protecting-internal-websites.md)

## Automating operations with Substrate

* [Enumerating all your AWS accounts](automating-operations-with-substrate/enumerating-all-your-aws-accounts.md)
* [Enumerating all your root Terraform modules](automating-operations-with-substrate/enumerating-all-your-root-terraform-modules.md)

## Administering your Substrate-managed AWS organization

* [Onboarding users](administering-your-substrate-managed-aws-organization/onboarding-users.md)
* [Offboarding users](administering-your-substrate-managed-aws-organization/offboarding-users.md)
* [Allowing third parties to access your AWS organization](administering-your-substrate-managed-aws-organization/allowing-third-parties-to-access-your-aws-organization.md)
* [Adding administrators to your AWS organization](administering-your-substrate-managed-aws-organization/adding-administrators.md)
* [Customizing EC2 instances from the Instance Factory](administering-your-substrate-managed-aws-organization/customizing-instance-factory.md)
* [Cost management](administering-your-substrate-managed-aws-organization/cost-management.md)
* [Adding non-administrator roles for humans](administering-your-substrate-managed-aws-organization/adding-non-administrator-roles-for-humans.md)

## Compliance

* [Addressing SOC 2 criteria with Substrate](compliance/addressing-soc-2-criteria-with-substrate.md)
* [Auditing your Substrate-managed AWS organization](compliance/auditing.md)

## Runbooks for emergency and once-in-a-blue-moon operations

* [Subscribing to AWS support plans](runbooks/aws-support.md)
* [Closing an AWS account](runbooks/closing-an-aws-account.md)
* [Removing an AWS account from your organization](runbooks/removing-an-aws-account-from-your-organization.md)
* [Removing an AWS region](runbooks/removing-an-aws-region.md)
* [Changing identity providers](runbooks/changing-identity-providers.md)
* [Sharing CloudWatch data between accounts](runbooks/cloudwatch-sharing.md)
* [Regaining access in case the Credential and Instance Factories are broken](runbooks/regaining-access.md)
* [Debugging Substrate](runbooks/debugging.md)

## Release notes and upgrading

* [Substrate release notes](release-notes-and-upgrading/releases.md)
* [Upgrading Substrate](release-notes-and-upgrading/upgrading.md)

## Meta

* [Telemetry in Substrate](telemetry.md)
