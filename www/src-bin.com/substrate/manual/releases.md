# Substrate release notes

<h2 id="2021.12">2021.12</h2>

* Substate now uses your default region (the one you chose to host your organization&rsquo;s CloudTrail logs, among other things) when it executes global root modules. This allows you to more completely decouple yourself from us-east-1 if you so choose.
* Bug fix: Allow the Instance Factory to pass any IAM role configured in your IdP on to EC2 instances your non-Administrator users provision.
* Safety feature: No longer read `~/.aws/credentials` under any circumstances. Since we never use this file in a Substrate-managed AWS organization, reading this file can only serve to &ldquo;cross the streams&rdquo; with a legacy AWS account.

The upgrade process this month is much more involved that most. As such, we&rsquo;ll talk in Slack about when you&rsquo;re going to perform the upgrade to ensure support&rsquo;s available in the moment.

Before upgrading Substrate, audit your Terraform modules for resources in global modules that aren&rsquo;t from global AWS serivces by copying the following program to `audit.sh` in your Substrate repository and running `sh audit.sh`.

    set -e

    substrate root-modules |
    grep "/global\$" |
    while read DIRNAME
    do
        echo "$DIRNAME" >&2
        terraform -chdir="$DIRNAME" state pull >"$DIRNAME/audit.tfstate"
        grep -F ":us-east-1:" "$DIRNAME/audit.tfstate" || :
        rm -f "$DIRNAME/audit.tfstate"
        echo >&2
    done

Every resource this program identifies needs to be modified before proceeding. The most likely modification is to add `provider = aws.us-east-1` to resources in the Terraform code that manages them.

Block all your coworkers from making Terraform changes however you usually do (announcing in Slack, deactivating CI/CD jobs, taking state file locks, etc.) and move your global state files from us-east-1 to your default region by copying the following program to `mv-state.sh` in your Substrate repository and running `sh mv-state.sh`.

    set -e

    DEFAULT_REGION="$(cat "substrate.default-region")"
    PREFIX="$(cat "substrate.prefix")"

    if [ "$DEFAULT_REGION" = "us-east-1" ]
    then exit # nothing to do
    fi

    eval $(substrate-assume-role -role="DeployAdministrator" -special="deploy")

    substrate root-modules |
    grep "/global\$" |
    while read DIRNAME
    do
        echo "$DIRNAME" >&2
        aws s3 cp "s3://$PREFIX-terraform-state-us-east-1/$DIRNAME/terraform.tfstate" "s3://$PREFIX-terraform-state-$DEFAULT_REGION/$DIRNAME/terraform.tfstate"
        aws s3 rm "s3://$PREFIX-terraform-state-us-east-1/$DIRNAME/terraform.tfstate"
        echo >&2
    done

Once you&rsquo;ve run this program, there&rsquo;s a provider to thread through the tree of Terraform modules before you can upgrade to Substrate 2021.12.

* Add the following four lines in the domain module stanzas in `root-modules/*/*/*/global/main.tf`:

        providers = {
          aws           = aws
          aws.us-east-1 = aws.us-east-1
        }

* Add the following three lines below `aws = {` in `modules/*/global/versions.tf` except `modules/lambda-function/global/versions.tf`, `modules/substrate/global/versions.tf`, and your own modules:

        configuration_aliases = [
          aws.us-east-1,
        ]

(I regret not being able to provide a `patch`(1) file for these operations but the contents of `versions.tf` post-Terraform 1.0 are too unpredictable to do so safely.)

Now you can upgrade Substrate. Don&rsquo;t release your block just yet, though.

After upgrading Substrate:

1. `substrate-bootstrap-deploy-account`
2. `substrate-create-admin-account -quality="..."` for each of your admin accounts
3. `substrate-create-account -domain="..." -environment="..." -quality="..."` for each of your service accounts

Once all of these have run successfully, ensure all your coworkers upgrade Substrate and unblock Terraform changes.

I regret the complexity of this upgrade process but feel it is, on balance, less risky than attempting to hide all this motion behind automation. Thanks for your patience.

<h2 id="2021.11">2021.11</h2>

* New installations no longer configure a SAML provider. Instead, all AWS API and Console access is brokered by OAuth OIDC and your Intranet. Existing SAML providers are not removed.
* For those using Google as their IdP, read the name of the role to assume in the Credential and Instance Factories and the AWS Console from custom attributes on Google Workspace users. (For Okta users, Administrator is still the default.)
* Forward `Cookie` headers to HTTP(S) services wired into the Intranet by the experimental new `modules/intranet/regional/proxy` module. The theoretical security benefit of not exposing raw cookies (and instead exposing identity) is not remotely worth the loss in functionality it cost.
* Reduce the chance of Intranet misconfiguration by limiting which API Gateways can forward to the `substrate-intranet` Lambda function.
* Bug fix: The links to other parts of the Intranet from the page that `substrate-credentials` opens in your browser are relative links and were missing the `../` prefix, which has now been added.
* Removed version pinning of the long-unused Terraform `archive` provider.
* Removed `-no-cloudwatch` from `substrate-bootstrap-management-account`, `substrate-create-admin-account`, and `substrate-create-account` in favor of just actually detecting when it&rsquo;s necessary and not doing it when it&rsquo;s not.

Before upgrading Substrate, if you&rsquo;re using Google as your IdP:

1. Add an additional custom attribute as follows:
    1. Visit <https://admin.google.com/ac/customschema> in a browser (or visit <https://admin.google.com>, click **Users**, click **More**, and click **Manage custom attributes**)
    2. Click the **AWS section**
    3. In the blank bottom row, enter &ldquo;RoleName&rdquo; for _Name_, select &ldquo;Text&rdquo; for _Info type_, select &ldquo;Visible to user and admin&rdquo; for _Visibility_, select &ldquo;Single Value&rdquo; for _No. of values_
    4. Click **SAVE**
2. Visit <https://admin.google.com/ac/users> and set the _RoleName_ attribute in the _AWS_ category to &ldquo;Administrator&rdquo; for every user authorized to use AWS.
3. Visit <https://console.cloud.google.com/apis/library/admin.googleapis.com>, confirm the selected project is the one that contains your Intranet&rsquo;s OAuth OIDC configuration (its name will be listed next to "Google Cloud Platform" in the header), and click **ENABLE**.

After upgrading Substrate:

1. Run `substrate-create-admin-account -quality="..."` to upgrade your Intranet.

<h2 id="2021.10">2021.10</h2>

* The Intranet&rsquo;s `/accounts` page now logs you into the AWS Console and assumes the specified role without requiring you to have already been logged in.
* The `-console` option to `substrate-assume-role` likewise now logs into the AWS Console and assumes the specified role without requiring you to have already been logged in.
* Auditor roles can now assume other Auditor roles, making it possible for Auditor to move throughout the organization while retaining its read-only status.
* The lists of principals that can assume the `Administrator` and `Auditor` roles may now be augmented by adding a JSON-encoded assume role policy in `substrate.Administrator.assume-role-policy.json` and/or `substrate.Auditor.assume-role-policy.json`.
* Enforce the use of IMDSv2 on instances from the Instance Factory. This is a prerequisite for organization-wide enforcement of using IMDSv2, which is an important default that reduces the potential impact of SSRF vulnerabilities.
* `substrate-whoami` output now also includes your IAM role ARN.
* Prompt folks to `cd` or set `SUBSTRATE_ROOT` when they try to `eval $(substrate-credentials)` from outside the Substrate repository.
* Allow all accounts in the organization, not just admin accounts, to read shared CloudWatch metrics.
* Added experimental `modules/intranet/regional/proxy` that makes it easy to put SSO in front of internal websites and HTTP APIs. See [protecting internal websites](../protecting-internal-websites/) for more information and an example.
* Bug fix: Grant `s3:PutObjectAcl` so that it&rsquo;s possible for all authorized principals to upload objects with the `bucket-owner-full-control` canned ACL.
* Bug fix: Extract `substrate-intranet.zip` from the `substrate` binary during Terraform runs in `root-modules/admin/*/*` instead of only during `substrate-create-admin-account`. This makes it far less painful for mulitple teammates to work in the same Substrate repository and for CI/CD systems to apply Terraform changes.
* Bug fix: Prevent a race between VPC sharing and tagging that caused `substrate-create-admin-account` and `substrate-create-account` to fail every time they were used to actually create an account.
* Added `-no-cloudwatch` to `substrate-bootstrap-management-account`, `substrate-create-admin-account`, and `substrate-create-account` that skips the slow process of managing all the roles necessary for cross-account CloudWatch sharing. (Useful if you&rsquo;re certain you&rsquo;ve not created a new account and you&rsquo;re in a hurry.)

After upgrading Substrate:

1. Run `substrate-bootstrap-deploy-account` to fix the bucket policy so that all authorized principals in the organization can upload to the deploy artifact bucket(s).
1. Run `substrate-create-admin-account -quality="..."` to upgrade your Intranet and Auditor roles. Note well this will produce a fair number of new resources; this is step one in a multi-month process of brining some naming consistency to Substrate-managed resources in IAM, Lambda, and other AWS services.

<h2 id="2021.09.28">2021.09.28</h2>

* Bug fix: Properly detect when Substrate tools are invoked via symbolic links (i.e. in their original `substrate-assume-role` form rather than their new `substrate assume-role` form) on MacOS.

If you&rsquo;re upgrading from 2021.08, follow the upgrade instructions from 2021.09. If you already upgraded to 2021.09, there are no further upgrade steps.

<h2 id="2021.09">2021.09</h2>

This release changes the interactive interface to `substrate-bootstrap-network-account` and `substrate-create-admin-account` to make them easier to run in CI. **If you are automating these commands by providing `yes` and `no` answers on standard input, this release will break your automation; you should run these commands interactively first to see what&rsquo;s changed.** The details of what&rsquo;s changed are listed in the usual format below.

* Move all Substrate commands into the `substrate` binary with symbolic links replacing the `substrate-*` binaries from previous releases. This can mostly be considered a no-op but note that now Substrate commands may be also be invoked as <code>substrate <em>subcommand</em></code>. This is not a deprecation notice for the original invocation style.
* Added `-fully-interactive`, `-minimally-interactive`, and `-non-interactive` to all Substrate commands. `-fully-interactive` is almost identical (see below) to the behavior of 2021.08 and earlier releases. `-minimally-interactive` is the new default and removes the incessant &ldquo;is this correct? (yes/no)&rdquo; dialogs, which I thought would be welcome but turned out to be annoying. `-non-interactive` will never prompt for input and will instead exit with a non-zero status if input is required.
* Changed the interactive prompts concerning Google and Okta configuration to make them less bothersome and (in the Okta case) less prone to unintentional changes. **If you are automating `substrate-create-admin-account` by providing `yes` and `no` answers on standard input, this change will break your automation; you should run this command interactively first to see what&rsquo;s changed.**
* Added a confirmation to `substrate-create-admin-account` and `substrate-create-account` to prevent errant creation of new AWS accounts (which are tedious to delete in case creation was a mistake) plus a new `-create` option to suppress that confirmation.
* Updated the Substrate-managed Service Control Policy attached to your organization to deny access to the `cloudtrail:CreateTrail` API. Substrate creates a multi-region, organization-wide trail early in its initialization. This policy prevents additional trails from being created because they are excessively expensive and redundant.
* Added e-mail address columns to tables of AWS accounts in `substrate.accounts.txt`, `substrate-accounts`, and the Intranet&rsquo;s `/accounts` page.
* Added `-format=shell` to `substrate-accounts`, which enumerates AWS accounts as shell commands to the various `substrate-bootstrap-*` and `substrate-create-*` commands. This is useful for driving CI/CD of Terraform changes. It&rsquo;s also useful for automating Substrate upgrades.
* Added `substrate-root-modules`, which enumerates every Substrate-managed Terraform root module in a sensible order. This, too, is useful for driving CI/CD of Terraform changes.
* Added a new `root-modules/deploy/global` root module under the management of `substrate-bootstrap-deploy-account`. Substrate doesn&rsquo;t manage any resources there but you&rsquo;re free to.
* Bug fix: Ensure that objects put into the deploy buckets in S3 by any account in your organization may actually be fetched by other accounts in your organization. Requires objects be uploaded with the `bucket-owner-full-control` canned ACL.
* Bug fix: Avoid a fork bomb in case `substrate-whoami` is invoked with a `/` in the pathname (i.e. as `~/bin/substrate-whoami`).

After upgrading Substrate:

1. Run `substrate-bootstrap-management-account` to update your organization&rsquo;s Service Control Policy.
1. Run `substrate-bootstrap-deploy-account` to reconfigure the deploy buckets in S3 and generate the `global` root module.
1. Run `substrate-create-admin-account -quality="..."` to add the e-mail address column to your Intranet&rsquo;s `/accounts` page.

<h2 id="2021.08">2021.08</h2>

* Roll `substrate-apigateway-authorizer`, `substrate-credential-factory`, and `substrate-instance-factory` into `substrate-intranet`. This is a no-op listed here for transparency. It&rsquo;s a prerequisite step towards unifying all the Substrate tools as subcommands of `substrate`, thereby reducing the size and complexity of the Substrate distribution.
* Stop using the `archive` and `external` Terraform providers by embedding `substrate-intranet.zip` directly in `substrate-create-admin-account`. Dependence on these providers will be made optional in a subsequent release.
* VPCs are no longer shared organization-wide, leaving the fine-grained VPC sharing introduced in 2021.07 to maintain each service account&rsquo;s access to its intended VPCs.
* The Instance Factory now supports ARM instances (i.e. the a1, c6g, m6g, r6g, and t4g families).
* Bug fix: Switch back to the original working directory in `substrate-assume-role` (which will have changed if invoked with `SUBSTRATE_ROOT` set) before forking and executing a child process.
* Added `substrate-whoami` to make it easy to learn the domain, environment, and quality of the AWS account your current credentials operate on.
* Added `-format=json` to `substrate-accounts` to make it easier to enumerate and act programatically on every AWS account in your organization. See [enumerating all your AWS accounts](../enumerating-all-your-aws-accounts/) for an example.

After upgrading Substrate:

1. Run `substrate-bootstrap-management-account` to grant `substrate-whoami` the permissions it needs.
1. Run `substrate-bootstrap-network-account` to remove coarse-grained organization-wide VPC sharing.
1. Run `substrate-create-admin-account -quality="..."` to upgrade your Intranet.

<h2 id="2021.07">2021.07</h2>

* The Intranet&rsquo;s `/accounts` page now opens the AWS Console in new browser tabs as it probably always should have.
* Substrate now only manages the version constraint on the `archive`, `aws`, and `external` providers rather than all of `versions.tf`. This opens the door to Substrate users adding (and version constraining) additional providers. See [additional Terraform providers](../additional-terraform-providers/) for an example.
* Upgrade to and pin Terraform 1.0.2 and the `aws` provider >= 3.49.0.
* Tag many more AWS resources with `Manager` and `SubstrateVersion` using the `default_tags` facility of the AWS provider. If you encounter the following error, remove `Manager` and `SubstrateVersion` (if present) from the indicated resources and re-run.<br><pre>Error: "tags" are identical to those in the "default_tags" configuration block of the provider: please de-duplicate and try again</pre>
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

If you&rsquo;ve added any stub `provider` blocks to your modules, leave them in place for now and accept the deprecation warning. Terraform only allows one `required_providers` block and that is now managed by Substrate. A future release will accommodate these additional providers.

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
* Added `-console` to `substrate-assume-role` which attempts to open the AWS Console&rsquo;s role switching screen in your web browser with all the values filled in.
* Added `substrate-create-terraform-module` which creates the directory structure (with the `global` and `regional` pattern), providers, and Substrate metadata for a new Terraform module.
* Now building for M1 Macs, too.

After upgrading, run `substrate-create-admin-account -quality="..."` to add `/accounts` to your Intranet.

<h2 id="2021.03">2021.03</h2>

* Extended AWS Console sessions to 12 hours for organizations using Google as their IdP.
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
3. `substrate-create-admin-account -quality="..."` to fix Instance Factory IAM roles, following the [Google SAML setup](https://src-bin.com/substrate/manual/getting-started/google-saml/) guide if Google is your IdP to also get 12-hour AWS Console sessions.

<h2 id="2021.02">2021.02</h2>

* Added `-format` from `substrate-credentials` to `substrate-assume-role` per request from a customer. Now credentials can be had with or without the ` export` prefix or as JSON a la `aws sts assume-role` itself.
* Removed `root-modules/admin/*`&rsquo;s awkward dependency on finding `GOBIN` in the environment. The generated `Makefile` in each root module remains, however.
* Upgrade to and pin Terraform 0.13.6 and the Terraform AWS provider 3.26.0.
* `substrate-assume-role` and `substrate-credentials` now (better) tolerate being invoked from subdirectories of your Substrate repository.
* Fix a bug in Terraform module generation in which the `aws.network` provider was incorrectly added to global modules and thus should have been expected in module stanzas.
* Stop printing the ` export AWS_ACCESS_KEY_ID=...` line when `substrate-assume-role` is given a command to execute directly.
* Provide the Intranet&rsquo;s REST API ID, root resource ID, and a few other necessities as outputs from the `intranet/regional` module to facilitate adding more resources to these APIs.

You must upgrade to Terraform 0.13.6 in order to use Substrate 2021.02. Terraform 0.13.6 may be found here:

* <https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_darwin_amd64.zip>
* <https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_linux_amd64.zip>
* <https://releases.hashicorp.com/terraform/0.13.6/terraform_0.13.6_linux_arm64.zip>

## 2021.01 and prior releases

Contact <hello@src-bin.com> for prior release notes.
