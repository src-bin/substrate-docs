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

## Concepts and terms <a href="#concepts" id="concepts"></a>

* [Accounts in a Substrate-managed AWS organization](concepts/accounts.md)
* [Domains, environments, and qualities](concepts/domains-environments-qualities.md)
* [Networking](concepts/networking.md)
* [Diagram of a Substrate-managed AWS organization](concepts/diagram-substrate-managed-aws-organization.md)
* [Global and regional Terraform modules](concepts/global-and-regional-terraform-modules.md)
* [Root Terraform modules](concepts/root-terraform-modules.md)
* [Substrate filesystem hierarchy](concepts/substrate-filesystem-hierarchy.md)

## Architectural guidance <a href="#guidance" id="guidance"></a>

* [Technology choices](guidance/technology-choices.md)
* [Multi-tenancy](guidance/multi-tenancy.md)
* [Diagram of a multi-quality, multi-region service](guidance/diagram-multi-quality-multi-region-service.md)
* [Deciding where to host internal tools](guidance/internal-tools.md)

## Working in your Substrate-managed AWS organization <a href="#working" id="working"></a>

* [Accessing AWS in your terminal](working/accessing-aws-in-your-terminal.md)
* [Accessing the AWS console](working/accessing-the-aws-console.md)
* [Moving between AWS accounts](working/moving-between-aws-accounts.md)
* [Using AWS CLI profiles](working/aws-cli-profiles.md)
* [Jumping into private networks](working/jumping-into-private-networks.md)
* [Writing Terraform code](working/writing-terraform-code.md)
* [Using Amazon EC2 when IMDSv2 is required](working/ec2-imdsv2.md)
* [Additional Terraform providers](working/additional-terraform-providers.md)
* [Adding a domain](working/adding-a-domain.md)
* [Adding an environment or quality](working/adding-an-environment-or-quality.md)
* [Adding an AWS region](working/adding-an-aws-region.md)
* [Deploying software](working/deploying-software.md)
* [Protecting internal websites](working/protecting-internal-websites.md)

## Automating operations with Substrate <a href="#automating" id="automating"></a>

* [Enumerating all your AWS accounts](automating/enumerating-all-your-aws-accounts.md)
* [Enumerating all your root Terraform modules](automating/enumerating-all-your-root-terraform-modules.md)

## Administering your Substrate-managed AWS organization <a href="#administering" id="administering"></a>

* [Onboarding users](administering/onboarding-users.md)
* [Offboarding users](administering/offboarding-users.md)
* [Allowing third parties to access your AWS organization](administering/allowing-third-parties-to-access-your-aws-organization.md)
* [Adding administrators to your AWS organization](administering/adding-administrators.md)
* [Customizing EC2 instances from the Instance Factory](administering/customizing-instance-factory.md)
* [Cost management](administering/cost-management.md)
* [Adding non-administrator roles for humans](administering/adding-non-administrator-roles-for-humans.md)

## Compliance

* [Addressing SOC 2 criteria with Substrate](compliance/addressing-soc-2-criteria-with-substrate.md)
* [Auditing your Substrate-managed AWS organization](compliance/auditing.md)

## Runbooks for emergency and once-in-a-blue-moon operations <a href="#runbooks" id="runbooks"></a>

* [Subscribing to AWS support plans](runbooks/aws-support.md)
* [Closing an AWS account](runbooks/closing-an-aws-account.md)
* [Removing an AWS account from your organization](runbooks/removing-an-aws-account-from-your-organization.md)
* [Removing an AWS region](runbooks/removing-an-aws-region.md)
* [Changing identity providers](runbooks/changing-identity-providers.md)
* [Sharing CloudWatch data between accounts](runbooks/cloudwatch-sharing.md)
* [Regaining access in case the Credential and Instance Factories are broken](runbooks/regaining-access.md)
* [Debugging Substrate](runbooks/debugging.md)

## Release notes and upgrading <a href="#upgrading" id="upgrading"></a>

* [Upgrading Substrate](upgrading/upgrading.md)

## Meta

* [Telemetry in Substrate](telemetry.md)
* [Substrate release notes](meta/releases.md)
