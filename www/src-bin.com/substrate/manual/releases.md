# Substrate release notes

<h2 id="2021.09">2021.09</h2>

This release changes the interactive interface to `substrate-bootstrap-network-account` and `substrate-create-admin-account` to make them easier to run in CI. **If you are automating these commands by providing `yes` and `no` answers on standard input, this release will break your automation; you should run these commands interactively first to see what's changed.** The details of what's changed are listed in the usual format below.

* Move all Substrate commands into the `substrate` binary with symbolic links replacing the `substrate-*` binaries from previous releases. This can mostly be considered a no-op but note that now Substrate commands may be also be invoked as <code>substrate <em>subcommand</em></code>. This is not a deprecation notice for the original invocation style.
* Added `-fully-interactive`, `-minimally-interactive`, and `-non-interactive` to all Substrate commands. `-fully-interactive` is almost identical (see below) to the behavior of 2021.08 and earlier releases. `-minimally-interactive` is the new default and removes the incessant "is this correct? (yes/no)" dialogs, which I thought would be welcome but turned out to be annoying. `-non-interactive` will never prompt for input and will instead exit with a non-zero status if input is required.
* Changed the interactive prompts concerning GSuite and Okta configuration to make them less bothersome and (in the Okta case) less prone to unintentional changes. **If you are automating `substrate-create-admin-account` by providing `yes` and `no` answers on standard input, this change will break your automation; you should run this command interactively first to see what's changed.**
* Added a confirmation to `substrate-create-admin-account` and `substrate-create-account` to prevent errant creation of new AWS accounts (which are tedious to delete in case creation was a mistake) plus a new `-create` option to suppress that confirmation.
* Updated the Substrate-managed Service Control Policy attached to your organization to deny access to the `cloudtrail:CreateTrail` API. Substrate creates a multi-region, organization-wide trail early in its initialization. This policy prevents what additional trails from being created because they are excessively expensive and redundant.
* Added e-mail address columns to tables of AWS accounts in `substrate.accounts.txt`, `substrate-accounts`, and the Intranet's `/accounts` page.
* Added `-format=shell` to `substrate-accounts`, which enumerates AWS accounts as shell commands to the various `substrate-bootstrap-*` and `substrate-create-*` commands. This is useful for driving CI/CD of Terraform changes. It's also useful for automating Substrate upgrades.
* Added `substrate-root-modules`, which enumerates every Substrate-managed Terraform root module in a sensible order. This, too, is useful for driving CI/CD of Terraform changes.
* Bug fix: Ensure that objects put into the deploy buckets in S3 by any account in your organization may actually be fetched by other accounts in your organization. Requires objects be uploaded with the `bucket-owner-full-control` canned ACL.
* Bug fix: Avoid a fork bomb in case `substrate-whoami` is invoked with a `/` in the pathname (i.e. as `~/bin/substrate-whoami`).

After upgrading Substrate:

1. Run `substrate-bootstrap-management-account` to update your organization's Service Control Policy.
1. Run `substrate-bootstrap-deploy-account` to reconfigure the deploy buckets in S3.

<h2 id="2021.08">2021.08</h2>

* Roll `substrate-apigateway-authorizer`, `substrate-credential-factory`, and `substrate-instance-factory` into `substrate-intranet`. This is a no-op listed here for transparency. It's a prerequisite step towards unifying all the Substrate tools as subcommands of `substrate`, thereby reducing the size and complexity of the Substrate distribution.
* Stop using the `archive` and `external` Terraform providers by embedding `substrate-intranet.zip` directly in `substrate-create-admin-account`. Dependence on these providers will be made optional in a subsequent release.
* VPCs are no longer shared organization-wide, leaving the fine-grained VPC sharing introduced in 2021.07 to maintain each service account's access to its intended VPCs.
* The Instance Factory now supports ARM instances (i.e. the a1, c6g, m6g, r6g, and t4g families).
* Bug fix: Switch back to the original working directory in `substrate-assume-role` (which will have changed if invoked with `SUBSTRATE_ROOT` set) before forking and executing a child process.
* Added `substrate-whoami` to make it easy to learn the domain, environment, and quality of the AWS account your current credentials operate on.
* Added `-format=json` to `substrate-accounts` to make it easier to enumerate and act programatically on every AWS account in your organization. See [enumerating all your AWS accounts](../enumerating-all-your-aws-accounts/) for an example.

After upgrading Substrate:

1. Run `substrate-bootstrap-management-account` to grant `substrate-whoami` the permissions it needs.
1. Run `substrate-bootstrap-network-account` to remove coarse-grained organization-wide VPC sharing.
1. Run `substrate-create-admin-account` to upgrade your Intranet.

<h2 id="2021.07">2021.07</h2>

* The Intranet's `/accounts` page now opens the AWS Console in new browser tabs as it probably always should have.
* Substrate now only manages the version constraint on the `archive`, `aws`, and `external` providers rather than all of `versions.tf`. This opens the door to Substrate users adding (and version constraining) additional providers. See [additional Terraform providers](../additional-terraform-providers/) for an example.
* Upgrade to and pin Terraform 1.0.2 and the `aws` provider >= 3.49.0.
* Tag many more AWS resources with `Manager` and `SubstrateVersion` using the `default_tags` facility of the AWS provider. If you encounter the following error, remove `Manager` and `SubstrateVersion` (if present) from the indicated resources and re-run.<br><pre>Error: "tags" are identical to those in the
"default_tags" configuration block of the provider:
please de-duplicate and try again</pre>
* All Substrate tools will now change their working directory to the value of the `SUBSTRATE_ROOT` environment variable, if set, rather than always proceeding in whatever the working directory was when invoked.
* Share VPCs specifically with accounts that match their environment and quality. This is a no-op that enables a future release to remove organization-wide VPC sharing.

You must upgrade to Terraform 1.0.2 in order to use Substrate 2021.07. Terraform 1.0.2 may be found here:

* <https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_darwin_amd64.zip>
* <https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_darwin_arm64.zip>
* <https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_linux_amd64.zip>
* <https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_linux_arm64.zip>

After upgrading Terraform and Substrate:

1. Run `substrate-bootstrap-network-account` and `substrate-bootstrap-deploy-account` to complete the Terraform 1.0.2 upgrade there. Note well that `tags` and `tags_all` output will be somewhat confusing but will ultimately do the right thing.
1. Run `substrate-create-admin-account` and `substrate-create-account` to complete the Terraform 1.0.2 upgrade for each of your admin and service accounts. Here, too, note well that `tags` and `tags_all` output will be somewhat confusing but will ultimately do the right thing.

<h2 id="2021.06">2021.06</h2>

* List all the Intranet resources on the Intranet homepage, not just top-level resources.
* Roll `substrate-apigateway-authenticator` and `substrate-apigateway-index` into `substrate-intranet`. This is a no-op listed here for transparency.
* Tag shared VPCs in service accounts to clearly indicate in the AWS Console which one you should be using. This lays the groundwork for finer-grained VPC sharing in a future release.
* Upgrade to and pin Terraform 0.15.5 and newer providers with relaxed `>=` version constraints on providers (but not Terraform itself).

You must upgrade to Terraform 0.15.5 in order to use Substrate 2021.06. Terraform 0.15.5 may be found here:

* <https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_darwin_amd64.zip>
* <https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip>
* <https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_arm64.zip>

After upgrading Terraform and Substrate:

1. Run `substrate-bootstrap-network-account` and `substrate-bootstrap-deploy-account` to complete the Terraform 0.15.5 upgrade there.
1. Run `substrate-create-admin-account -quality="..."` to update your Intranet.
1. Run `substrate-create-account -domain="..." -environment="..." -quality="..."` for all your service accounts to tag your shared VPCs.

If you've added any stub `provider` blocks to your modules, leave them in place for now and accept the deprecation warning. Terraform only allows one `required_providers` block and that is now managed by Substrate. A future release will accommodate these additional providers.

<h2 id="2021.05">2021.05</h2>

* Bug fix: S3 traffic from private subnets is now correctly routed via the VPC Endpoint and not through the NAT Gateway.
* Bug fix: Allow outbound IPv6 traffic from Instance Factory instances to match IPv4 and enable use of the IPv6 Internet.
* Bug fix: Instance Factory instances now have 100GB disks instead of whatever the AMI happened to request, which recently shrank from 8GB to 2GB.
* Bug fix: The Instance Factory now only lists instances which belong to you. It previously listed all instances for all your users.
* By popular request, authorize admin accounts to directly access CloudWatch logs and metrics from all your accounts.

After upgrading:

* Run `substrate-bootstrap-network-account` to fix S3 routes.
* Run `substrate-create-admin-account -quality="..."` to enable direct CloudWatch access and make Instance Factory improvements.

<h2 id="2021.04">2021.04</h2>

* Added `/accounts` to the Intranet with links to assume the Administrator and Auditor roles in all your accounts in the AWS Console.
* Added `-console` to `substrate-assume-role` which attempts to open the AWS Console's role switching screen in your web browser with all the values filled in.
* Added `substrate-create-terraform-module` which creates the directory structure (with the `global` and `regional` pattern), providers, and Substrate metadata for a new Terraform module.
* Now building for M1 Macs, too.

After upgrading, run `substrate-create-admin-account -quality="..."` to add `/accounts` to your Intranet.

<h2 id="2021.03">2021.03</h2>

* Extended AWS Console sessions to 12 hours for organizations using GSuite as their IdP.
* Upgrade to and pin Terraform 0.14.7.
* `substrate-bootstrap-network-account` now creates peering connections between all VPCs in all regions for each environment across all valid qualities.
* Fixed a bug in the `Administrator` role in admin accounts that prevented Instance Factory instances from seamlessly assuming the role.

You must upgrade to Terraform 0.14.7 in order to use Substrate 2021.03. Terraform 0.14.7 may be found here:

* <https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_darwin_amd64.zip>
* <https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip>
* <https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_arm64.zip>

After upgrading:

1. `rm -f -r root-modules/network/*/peering` and remove these files from version control.
2. `substrate-bootstrap-network-account` to peer all your VPCs that should be peered.
3. `substrate-create-admin-account -quality="..."` to fix Instance Factory IAM roles, following the [GSuite SAML setup](https://src-bin.com/substrate/manual/getting-started/gsuite-saml/) guide if GSuite is your IdP to also get 12-hour AWS Console sessions.

<h2 id="2021.02">2021.02</h2>

* Added `-format` from `substrate-credentials` to `substrate-assume-role` per request from a customer. Now credentials can be had with or without the ` export` prefix or as JSON a la `aws sts assume-role` itself.
* Removed `root-modules/admin/*`'s awkward dependency on finding `GOBIN` in the environment. The generated `Makefile` in each root module remains, however.
* Upgrade to and pin Terraform 0.13.6 and the Terraform AWS provider 3.26.0.
* `substrate-assume-role` and `substrate-credentials` now (better) tolerate being invoked from subdirectories of your Substrate repository.
* Fix a bug in Terraform module generation in which the `aws.network` provider was incorrectly added to global modules and thus should have been expected in module stanzas.
* Stop printing the ` export AWS_ACCESS_KEY_ID=...` line when `substrate-assume-role` is given a command to execute directly.
* Provide the Intranet's REST API ID, root resource ID, and a few other necessities as outputs from the `intranet/regional` module to facilitate adding more resources to these APIs.

You must upgrade to Terraform 0.13.6 in order to use Substrate 2021.02. Terraform 0.13.6 may be found here:

* <https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_darwin_amd64.zip>
* <https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_linux_amd64.zip>
* <https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_linux_arm64.zip>

## 2021.01 and prior releases

Contact <hello@src-bin.com> for prior release notes.
