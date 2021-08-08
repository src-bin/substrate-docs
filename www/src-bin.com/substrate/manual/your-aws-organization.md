# Your Substrate-managed AWS organization

The [getting started](/substrate/manual/getting-started/) guide ends once you have a fully configured AWS organization, one that should last you many years and weather all sorts of growth in infrastructure and team size. This manual exists to orient you within that organization so you know what you have and how to use it most effectively to achieve your company's goals.

This is a distillation of the original [Substrate design](https://www.notion.so/srcbin/Substrate-design-616feb1d5f3042ccb0bd9e8ede6589c1) that better aligns with the rest of the manual and omits all the aspirational parts.

## Your Substrate directory

In the [getting started](/substrate/manual/getting-started/) guide, you decided on a directory where you'll run Substrate commands and started committing all the files Substrate places there to version control. This directory is a critical part of your Substrate-managed AWS organization and should be managed like source code.

The `substrate.*` files in this directory are records of how you responded to the various prompts from Substrate commands. While it's possible to edit a file and re-run the corresponding Substrate commands, it's recommended to edit the files when offered the opportunity to do so by the Substrate commands themselves.

The Terraform modules placed in the `modules` subdirectory - `intranet`, `lambda-function`, and `substrate` - are generated and kept up-to-date by Substrate commands. They're copied here to ensure you completely control your Substrate-managed AWS organization even if you decide to stop using Substrate and continue on your own.

The root Terraform modules - every leaf directory in the `root-modules` subdirectory tree are where you run Terraform commands. Each has a `Makefile` to enable single command directory change and Terraform invocation thus: `make -C root-modules/example/staging/alpha apply`

## AWS accounts

Why even bother having more than one AWS account, anyway?

- Security: The AWS IAM team recommends using AWS accounts as the primary security boundary between unrelated systems. Within a single account it can be difficult to fully model permissions and convince oneself that two systems really are separate. Between multiple accounts, though, it's far easier to move quickly by granting broad permissions within one account with confidence that those permissions don't bleed over into the other accounts.
- Cost management: Most organizations struggle to tag AWS resources effectively enough to get a clear picture of where they're spending money. Every single AWS resource, though, is unavoidably attached to some account number. By mapping AWS accounts to cost centers, one can get a baseline picture of costs that's often enough all by itself.

Substrate wholeheartedly endorses the use of multiple AWS accounts. There are a few special AWS accounts in a Substrate-managed AWS organization and then as many more as you like for your purposes.

The special accounts are:

- The management account, which contains no resources and is only used to create and control other accounts within the organization.
- The audit account, which hosts CloudTrail logs for the entire organization.
- The deploy account, which hosts deployable artifacts for exchange between all domains, environments, and qualities in order to allow them to remain otherwise completely separate.
- The network account, which hosts VPCs and subnets that are shared with other accounts to simplify network topology and reduce network transfer costs.

There are additionally admin accounts (of which there can be more than one), which host Intranet services like the Credential and Instance Factories that can exchange IdP (Google or Okta) credentials for temporary AWS credentials or EC2 instances.

Finally, there are accounts where you host your software (be it software you've written yourself or an AWS-managed service). Each of these accounts is tagged with a [domain, environment, and quality](/substrate/manual/domains-environments-qualities/).

This constellation of AWS accounts works together to increase the reliability and security of your product and reduce the blast radius of changes to any part of it.

## AWS IAM roles

Now that you have many AWS accounts you'll inevitably need to switch between them rather frequently. Substrate provides two tools to aid you in this task.

`substrate.accounts.txt` in your Substrate directory is an up-to-date list of all your AWS accounts, their account numbers, and the roles you'll want to assume there. With this information you can use the Switch Role feature in the AWS Console or any number of other tools built expecting IAM role ARNs.

`substrate-assume-role` is a friendlier command-line interface that operates on domains, environments, and qualities instead of account numbers. So, for example, instead of assuming the `Administrator` role in account number 123456789012, you `substrate-assume-role -domain=example -environment=staging -quality=alpha` and get on your way.

In general, Substrate creates an `Administrator` and `Auditor` role in every account, though the special accounts have special names (e.g. the network account uses `NetworkAdministrator`) in order to prevent accidental access while looping through all the accounts in your organization.

## AWS regions

You're asked, as Substrate's preparing to construct your network, to select which AWS regions you'll use. Substrate is capable of operating a multi-region AWS organization across the board. This is, however, easier in many ways than operating a multi-region product. Thus, while it's recommended you select multiple regions, it's by no means required that you do so, nor that you actually use all the regions you select all at the same time.

You should not simply select every region, however. For one thing, it won't work due to the hard limits on VPC peering. (Peering multiple domains, each with multiple qualities across every AWS region is possible using Transit Gateway but that is expensive and currently not supported by Substrate.) For another, it will make applying Terraform changes terribly slow.

Substrate recommends starting with 2-4 regions that make geographic sense to your customers.

## Networks (VPCs and subnets)

Software-defined networking offers cloud infrastructure nearly endless flexibility that's nearly completely divorced from the physical networks that back it. Unfortunately, this flexibility is usually (as is the case in AWS) presented in its entirety to users. Substrate constructs networks on your behalf that, for the vast majority of use-cases, return you to the simplicity of one big, flat network that made cloud infrastructure so attractive in the first place.

Substrate defines VPCs and subnets in your network account, shares into all your other AWS accounts, and peers together to create one big network for each of your environments.

By using shared VPCs, your organization is free to use many domains to improve the security and reliability of your services without incurring huge network transfer costs going from one VPC to another.

But Substrate also preserves the ability to roll out network changes somewhat gradually. Each quality within an environment gets a separate VPC, peered with the VPCs for all the other qualities in the environment. This affords you the opportunity to apply Terraform changes to e.g. your production beta network that's carrying 10% of your traffic before your production gamma network carrying the remaining 90%.

Each of these networks comes with three public /22 subnets and three private /20 subnets in three availability zones with all the appropriate gateways and routes in place. Be mindful, as always, that traffic crossing between availability zones costs money.

Using these networks should be relatively straightforward. In your Terraform code, you can use `module.substrate.public_subnet_ids` and `module.substrate.private_subnet_ids` to get a `list(string)` of those three subnets to use in other Terraform resources that create clusters, define autoscaling groups, and so on. Likewise, you can use `module.substrate.vpc_id` to define security groups because you still get to control exactly what's allowed to access your services.

## Terraform state

All the root Terraform modules generated by Substrate use the standard [S3 backend](https://www.terraform.io/docs/backends/types/s3.html) with DynamoDB locking to safely manage Terraform state. The state is all stored in an S3 bucket in your deploy account, which Terraform accesses by assuming the `TerraformStateManager` role.
