# Substrate release notes

<!--
<h2 id="2021.08">2021.08</h2>

* Roll `substrate-apigateway-authorizer`, `substrate-credential-factory`, and `substrate-instance-factory` into `substrate-intranet`. This is a no-op listed here for transparency. It's a prerequisite step towards unifying all the Substrate tools as subcommands of `substrate`, thereby reducing the size and complexity of the Substrate distribution.
* Stop using the `archive` and `external` Terraform providers by embedding `substrate-intranet.zip` directly in `substrate-create-admin-account`. Dependence on these providers will be made optional in a subsequent release.
* VPCs are no longer shared organization-wide, leaving the fine-grained VPC sharing introduced in 2021.07 to maintain each service account's access to its intended VPCs.
-->

<h2 id="2021.07">2021.07</h2>

* The Intranet's `/accounts` page now opens the AWS Console in new browser tabs as it probably always should have.
* Substrate now only manages the version constraint on the `archive`, `aws`, and `external` providers rather than all of `versions.tf`. This opens the door to Substrate users adding (and version constraining) additional providers. See [additional Terraform providers](additional-terraform-providers/) for an example.
* Upgrade to and pin Terraform 1.0.2 and the `aws` provider >= 3.49.0.
* Tag many more AWS resources with `Manager` and `SubstrateVersion` using the `default_tags` facility of the AWS provider.
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
