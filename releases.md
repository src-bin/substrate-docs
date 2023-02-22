# Substrate release notes

## 2023.02 <a href="#2023.02" id="2023.02"></a>

* Allow adopting an existing account as the Substrate-managed audit account to prevent duplication when bootstrapping Substrate in existing organizations.
* Make the Substrate-managed CloudTrail configuration optional to prevent very expensive duplication when bootstrapping Substrate in existing organizations.
* Allow opting out of the Service Control Policy that enforces the uses of the EC2 IMDSv2 to allow more time for legacy workloads to be upgraded.
* Don't make folks go through the exercise of pairing environments and qualities in `substrate bootstrap-network-account` in case there's only one valid quality.
* Stop asking for confirmation before applying Terraform changes in `root-modules/network/peering`, which are completely generated, very simple, and very safe to make `substrate bootstrap-network-account` a much more pleasant experience.
* Rewrite `module.substrate.tags` to be based on the `root-modules` filesystem hierarchy instead of an external process so it can be used earlier in the Terraform run.
* Annotate the Intranet's Accounts page, the output of `substrate accounts`, and the `substrate.accounts.txt` file with the version of Substrate last used to manage each account in your organization to make upgrades more observable.
* Remove long-unused `substrate-instance-factory` security group from admin accounts. The Instance Factory stopped using this security group over a year ago but if there do happen to still be EC2 instances using this security group, `substrate create-admin-account` will fail.
* Enforce CSRF protections in the Intranet more aggressively when the CSRF cookie isn't present, closing the transitional period for this security feature.
* Introduce the `SUBSTRATE_DEBUG_AWS_LOGS` and `SUBSTRATE_DEBUG_AWS_RETRIES` environment variables to support debugging Substrate.
* Bug fix: Race between VPC-related Terraform resources and sharing/tagging the appropriate VPC in admin and service accounts is no longer a race.

Upgrade Substrate by running `substrate upgrade` and following its prompts. If your copy of `substrate` is writeable, this will be all you need to do to upgrade.

After upgrading Substrate, you should run `sh <(substrate accounts -format shell -no-apply)`, review what Terraform plans to do, and then run `sh <(substrate accounts -auto-approve -format shell)` to apply the changes. Commit the new `substrate.enforce-imdsv2` and `substrate.manage-cloudtrail` files to version control.

## 2023.01 <a href="#2023.01" id="2023.01"></a>

* Upgrade Terraform to version 1.3.6 and the Terraform AWS provider to at least version 4.47.0.
* `substrate terraform` will now download and unzip the correct version of Terraform into the same directory as `substrate` itself.
* `substrate intranet-zip` now supports `-base64sha256` and `-format json` which are used in the generated Terraform code to prevent Intranet downgrades.
* Bug fix: `substrate -version` now writes to standard output instead of standard error to make install automation easier to write.

Upgrade Substrate by running `substrate upgrade` and following its prompts. If your copy of `substrate` is writeable, this will be all you need to do to upgrade.

After upgrading Substrate:

1. Upgrade Terraform to version 1.3.6 by running `substrate terraform`, [downloading from Hashicorp](https://releases.hashicorp.com/terraform/1.3.6/), or some other means of your choice.
2. Run `sh <(substrate accounts -format shell -no-apply)` to review what Terraform plans to do.
3. Run `sh <(substrate accounts -auto-approve -format shell)` to apply the changes.

## 2022.12 <a href="#2022.12" id="2022.12"></a>

* Add support for Azure Active Directory identity providers. See [changing identity providers](https://github.com/src-bin/substrate-manual/blob/main/changing-identity-providers/README.md) and [integrating your Azure AD identity provider](https://github.com/src-bin/substrate-manual/blob/main/getting-started/integrating-your-azure-ad-identity-provider/README.md) if you want to switch.
* Bug fix: Don't interpret the new default value for `-quality` as an erroneously user-supplied value with `-management` or `-special` in `substrate assume-role`.
* Bug fix: Tolerate `substrate.qualities` being missing when trying to find a suitable default value for `-quality` options.
* Bug fix: Change to `SUBSTRATE_ROOT`, if set, before trying to use `substrate.qualities` to find a suitable default value for `-quality` options.

Upgrade Substrate by running `substrate upgrade` and following its prompts. If your copy of `substrate` is writeable, this will be all you need to do to upgrade.

After upgrading Substrate, you should run `sh <(substrate accounts -format shell -no-apply)`, review what Terraform plans to do, and then run `sh <(substrate accounts -auto-approve -format shell)` to apply the changes.

## 2022.11 <a href="#2022.11" id="2022.11"></a>

* `-quality "..."` is now optional in organizations that have only one line in `substrate.qualities`, which can allow `substrate assume-role`, `substrate create-account`, and `substrate create-admin-account` invocations to be a little shorter. Note that `substrate accounts -format shell` will continue to generate the longer version with an explicit `-quality` option.
* Use only tags to determine whether an account for a given domain, environment, and quality exists. This means that the email address on a Substrate-managed account doesn't have to be derived from the email address on the management account, that you don't absolutely have to change every account's email address if you want to change your management account's email address, and that you don't have to change the email address on every account you invite into your organization in order for Substrate to work with it.
* Add `-number` to `substrate create-account` which allows you to tag an existing organization account with a domain, environment, and quality, generate Terraform modules for it, and manage its basic IAM roles just like any other Substrate-managed account.
* Expand the bucket policy on the S3 buckets created in the deploy account in each region to allow `s3:GetBucketLocation`, `s3:GetObject*`, `s3:ListBucket*`, and `s3:PutObject*`.
* Keep the Intranet's logs in CloudWatch for seven days instead of just one to facilitate debugging after the fact.
* Transparently switch the Intranet's Lambda functions to run on the ARM architecture, which is 20% cheaper thanks in part to the underlying ARM instances using less power.
* Bug fix: Correctly detect when an organization hits its limit on the number of accounts it can contain and open a support case to raise that limit.

Upgrade Substrate by running `substrate upgrade` and following its prompts. If your copy of `substrate` is writeable, this will be all you need to do to upgrade.

After upgrading Substrate, you should run `sh <(substrate accounts -format shell -no-apply)`, review what Terraform plans to do, and then run `sh <(substrate accounts -auto-approve -format shell)` to apply the changes.

## 2022.10 <a href="#2022.10" id="2022.10"></a>

* Change Substrate's internal use of AWS IAM roles to only assume a role if it's different than the role Substrate has already assumed. This ensures folks won't run afoul of the new, stricter evaluation of IAM roles' trust policies, as outlined in [Announcing an update to IAM role trust policy behavior](https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/) and set to take full effect February 15, 2023.
* Allow the DeployAdministrator and NetworkAdministrator roles to assume themselves, explicitly allowing this after the new, stricter evaluation of IAM roles' trust policies (described above) takes full effect.
* Add `modules/common/global` and `modules/common/regional` which will be instantiated in every new service account. See below for directions on opting existing service accounts into this new default behavior.
* Add `modules/deploy/global` and `modules/deploy/regional` as blank slates so folks can add resources (e.g. AWS ECR repositories) to their deploy account in every region.
* Change the schema of the output of `substrate credentials -format json` to be compatible with the AWS SDK's `credential_process` directive. Specifically, rename `AccessKeyID` to `AccessKeyId` and `Expires` to `Expiration`, as documented in [Sourcing credentials with an external process](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sourcing-external.html).
* Add `substrate credentials -no-open` to give folks the opportunity to choose which browser window opens the Credential Factory authorization.
* Memoize and parallelize listing accounts to improve performance.
* Memoize OAuth OIDC signing keys in the Intranet to improve Intranet performance.
* Bug fix: Avoid infinite recursion when using `substrate credentials` as a `credential_process` for the AWS CLI/SDK. Substrate never intended to read `~/.aws/config` or `~/.aws/credentials` but was doing so inadvertantly; it no longer reads either of these files.

If you wish to instantiate the new common modules in your existing service accounts, take the following steps for each _domain_:

1.  Add the following block to `modules/`_`domain`_`/global/main.tf`:

    ```
     module "common" {
       providers = {
         aws           = aws
         aws.us-east-1 = aws.us-east-1
       }
       source = "../../common/global"
     }
    ```
2.  Add the following block to `modules/`_`domain`_`/regional/main.tf`:

    ```
     module "common" {
       providers = {
         aws         = aws
         aws.network = aws.network
       }
       source = "../../common/regional"
     }
    ```
3. Run ` substrate create-account -domain`` `` `_`domain`_` ``-environment`` `_`environment`_` ``-quality`` `_`quality`_ for each _domain_ service account.

These modules aren't being instantiated in existing service accounts automatically because Substrate can't guarantee that's safe.

Upgrade Substrate by running `substrate upgrade` and following its prompts. If your copy of `substrate` is writeable, this will be all you need to do to upgrade.

After upgrading Substrate, you should run `sh <(substrate accounts -format shell -no-apply)`, review what Terraform plans to do, and then run `sh <(substrate accounts -auto-approve -format shell)` to apply the changes.

## 2022.09 <a href="#2022.09" id="2022.09"></a>

* Ensure folks assigned non-Administrator roles in their identity provider can always get credentials and get into the AWS Console. This will manifest as Terraform changing an ARN to `"*"` in your admin account.
* Expand the Intranet's logging to CloudWatch Logs to better help folks diagnose any `substrate credentials` failures they may encounter.
* Tune retries and timeouts in the Credential Factory and `substrate credentials` to ensure we get more meaningful error messages and fewer 504 Gateway Timeout responses. This will manifest as Terraform lowering the Intranet Lambda functions' timeouts.
* Remove the long-unnecessary attachment of `arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs` to your admin account's Administrator role. This will manifest as Terraform destroying `module.intranet.aws_iam_role_policy_attachment.admin-cloudwatch` in your admin account.
* Bug fix: Garbage collect expired tokens that were never fetched by `substrate credentials` (whether due to bugs, the process being interrupted, or something else).
* Bug fix: Hide JavaScript paths introduced in 2022.08 from the Intranet's index page.

Get the 2022.09 release by running `substrate upgrade` and following its prompts. If your copy of `substrate` is writeable, this will be all you need to do to upgrade.

After upgrading Substrate, you at least need to run ` substrate create-admin-account -quality`` `` `_`quality`_ to update your Intranet. Even better would be to run `sh <(substrate accounts -format shell -no-apply)`, review what Terraform plans to do, and then run `sh <(substrate accounts -auto-approve -format shell)` to apply the changes.

## 2022.08 <a href="#2022.08" id="2022.08"></a>

* Automate the tedious step of logging out of the AWS Console before logging in again in a different account. The window that opens will now briefly display the AWS homepage before redirecting to the AWS Console. (This marks the first introduction of JavaScript in the Intranet but, having exhausted all other options, this seems a worthwhile cause. Note, however, that this enhancement does not cover the `-console` option to `substrate assume-role` in order to keep that command completely decoupled from the Intranet.)
* Add `-no-apply` to `substrate accounts -format shell` to enable you to review all the changes Terraform is planning to make across all your accounts at once. (After you review, you could swap `-no-apply` for `-auto-approve` or run `terraform apply` in each root module directly.)
* Enforce a one-hour time limit for invocations of `substrate credentials`. There's a theoretical security benefit to doing so but mostly this prevents forgotten shells from running up your Lambda and CloudWatch bill while muddling your Intranet's logs.
* Add a new `substrate upgrade` command, to be put into service with the 2022.09 release. (More details and updated documentation will accompany that release.)
* Bug fix: Prevent pathologically long email addresses from breaking Credential Factory by exceeding the allowed length of `RoleSessionName` in the `sts:AssumeRole` API.
* Bug fix: Don't fail spuriously when trying to create an account that already exists when the organization is at its limit for accounts.
* Bug fix: Prevent a rare crash when submitting telemetry to Source & Binary.

Upgrade Substrate as in the [updated installation manual](https://github.com/src-bin/substrate-manual/blob/main/getting-started/installing/README.md):

> ```
> tar xf substrate-version-commit-OS-ARCH.tar.gz -C ~/bin --strip-components 2 substrate-version-commit-OS-ARCH/bin/substrate
> ```
>
> Each released _version_ and _commit_ is offered in four binary formats; choose the appropriate one for your system. _`OS`_ is one of “`darwin`” or “`linux`” and _`ARCH`_ is one of “`amd64`” or “`arm64`”.
>
> You can install Substrate wherever you like. If `~/bin` doesn't suit you, just ensure the directory where you install it is on your `PATH`.

After upgrading Substrate, the best idea is to run `sh <(substrate accounts -format shell -no-apply)`, review what Terraform proposes to do, and then run `sh <(substrate accounts -auto-approve -format shell)` to ensure your code and your AWS organization don't diverge. If you need a minimal upgrade process, it's ` substrate create-admin-account -quality`` `` `_`quality`_ to update your Intranet.

**Advance notice of an upcoming change**: Next month's release will delete an old EC2 security group that was used by the Instance Factory until late 2021. Beware that, if you have any Instance Factory instances from 2021 or earlier, you'll have to change their security group or terminate them before upgrading next month.

## 2022.07 <a href="#2022.07" id="2022.07"></a>

* Restructure the Substrate distribution to:
  * Separate the `substrate` program in `bin/` from optional extra programs in `opt/bin/`.
  * Remove deprecated symbolic links from the distribution (though the functionality has not been and will not be removed from `substrate` so previously installed symbolic links will continue to function).
  * Include source code in release tarballs to obviate the need to micromanage GitHub collaborators.
* Always prefix `substrate accounts -format shell` output with `set -e -x` so the shell will stop on error and print the commands as they're executed.
* Add `-auto-approve` to `substrate accounts -format shell` to enable one-command, non-interactive upgrades for the most daring among us.
* Add `module.substrate.cidr_prefix` to the other outputs of the convenience `module.substrate` that's automatically available in domain modules.
* Bug fix: `substrate create-account` in 2022.06 failed to create accounts but now it's back. (It had one job!)
* Bug fix: Substrate shell completion never fully worked in Z shell but now it does.
* Bug fix: Running Lambda function processes could corrupt themselves with environment variables for the CredentialFactory user, losing access to the Intranet role until the process ends.

Upgrade Substrate as in the [updated installation manual](https://github.com/src-bin/substrate-manual/blob/main/getting-started/installing/README.md):

> ```
> tar xf substrate-version-commit-OS-ARCH.tar.gz -C ~/bin --strip-components 2 substrate-version-commit-OS-ARCH/bin/substrate
> ```
>
> Each released _version_ and _commit_ is offered in four binary formats; choose the appropriate one for your system. _`OS`_ is one of “`darwin`” or “`linux`” and _`ARCH`_ is one of “`amd64`” or “`arm64`”.
>
> You can install Substrate wherever you like. If `~/bin` doesn't suit you, just ensure the directory where you install it is on your `PATH`.

After upgrading Substrate:

1. `substrate bootstrap-management-account`
2. `substrate bootstrap-network-account`
3. `substrate bootstrap-deploy-account`
4. ` substrate create-admin-account -quality`` `` `_`quality`_ for each of your admin accounts
5. ` substrate create-account -domain`` `` `_`domain`_` ``-environment`` `_`environment`_` ``-quality`` `_`quality`_ for each of your service accounts

If your shell supports process substitution, you can run `sh <(substrate accounts -format shell)` to run all of these, in the proper order, in one command. As of this release you can make this non-interactive as `sh <(substrate accounts -auto-approve -format shell)` but this is not recommended as it forgoes your opportunity to object before Terraform applies changes.

## 2022.06 <a href="#2022.06" id="2022.06"></a>

* Substrate subcommands that create AWS accounts or apply Terraform code (`substrate bootstrap-*` and `substrate create-*account`) now prevent Substrate downgrades by checking the tags on the accounts themselves.
* POST requests to the Instance Factory have long-overdue CSRF mitigations in place.
* Upgrade Terraform to version 1.2.3 and the Terraform AWS provider to at least version 4.20.0.
* Address deprecation warnings about `aws_subnet_ids` everywhere except in the generated `modules/peering-connection` directory, which will take a little more time.
* Make the OAuth OIDC flow in your Intranet a little more debuggable in case of IdP misconfiguration or a Substrate bug.
* Bug fix: Don't give up too early waiting for IAM credentials to become usable. This caused `substrate credentials` to occasionally hang forever in 2022.05.

After upgrading Substrate:

1. Upgrade to [Terraform 1.2.3](https://releases.hashicorp.com/terraform/1.2.3/)
2. `substrate bootstrap-management-account`
3. `substrate bootstrap-network-account`
4. `substrate bootstrap-deploy-account`
5. ` substrate create-admin-account -quality`` `` `_`quality`_ for each of your admin accounts
6. ` substrate create-account -domain`` `` `_`domain`_` ``-environment`` `_`environment`_` ``-quality`` `_`quality`_ for each of your service accounts

If your shell supports process substitution, you can upgrade Terraform and then run `sh <(substrate accounts -format shell)` to run all of these, in the proper order, in one command.

## 2022.05 <a href="#2022.05" id="2022.05"></a>

* Allow customization of EC2 instances from the Instance Factory by using a launch template named `InstanceFactory-arm64` or `InstanceFactory-x86_64`, if the one matching the requested instance type is defined. See [customizing EC2 instances from the Instance Factory](https://github.com/src-bin/substrate-manual/blob/main/customizing-instance-factory/README.md) for details and an example.
* Add `cloudtrail:DeleteTrail` to the (short) list of APIs that are denied by the Substrate-managed service control policy on your management account.
* Remove verion constraints from Terraform modules in the `modules/` tree, instead letting all the version constraints come from the root module.
* Upgrade the Terraform AWS provider to at least 4.12.
* Remove dormant copies of various parts of the Intranet, which were deprecated as their functionality was moved into the monolithic Intranet IAM role and Lambda function.
* Bug fix: Add `organizations:DescribeOrganization` to the IAM policy attached to the CredentialFactory IAM user so that it can orient itself fully.
* Bug fix: Submit your Intranet URL to AWS so that when you're logged out of the AWS Console it links you to how you get back in instead of to the Substrate product page.
* Bug fix: Sort Terraform resources by their type and label as has always been intended. This will result in differences in source code but not in Terraform plans.
* Bug fix: Print prompts to standard error so they don't corrupt parseable output.

After upgrading Substrate:

1. `substrate bootstrap-management-account`
2. ` substrate create-admin-account -quality`` `` `_`quality`_ for each of your admin accounts

## 2022.04 <a href="#2022.04" id="2022.04"></a>

* Enforce, via organization-wide Service Control Policy, that EC2 instances must be launched with access to IMDSv2 and not IMDSv1. The Instance Factory has been launching compatible instances since 2021.10. If for some reason you need to roll this step back, use your Intranet's Accounts page to open the AWS Console in your management account with the OrganizationAdministrator role, visit [https://console.aws.amazon.com/organizations/v2/home/policies/service-control-policy](https://console.aws.amazon.com/organizations/v2/home/policies/service-control-policy), and delete SubstrateServiceControlPolicy. When you've migrated whatever needed IMDSv1 to use IMDSv2, re-run `substrate bootstrap-management-account`.
* Substrate now ships with a rudimentary autocomplete mechanism for Bash, Z shell, and other shells with compatibility for Bash completion.
* Substrate can now be used to drive the `--profile` option to the standard AWS CLI. See [using AWS CLI profiles](https://github.com/src-bin/substrate-manual/blob/main/aws-cli-profiles/README.md) for details.
* Upgrade the AWS Terraform provider to version 4.9.0 or (slightly) newer.
* Remove the dependency on the AWS CLI in the generated `modules/substrate` Terraform code.
* Bug fix: Lessen the possibility of a `TooManyRequestsException` from AWS Organizations during Terraform runs.
* Bug fix: Update the `SubstrateVersion` tag on your AWS accounts themselves when Substrate tries to create them and finds that they already exist.
* Bug fix: This time Substrate _actually_ asks if it may post [telemetry](https://github.com/src-bin/substrate-manual/blob/main/telemetry/README.md) to Source & Binary as promised in the previous release.
* Bug fix: Prevent a rare crash when trying to post tememetry early so commands can exit earlier.
* Bug fix: Use Terraform resource references in `root-modules/deploy` to avoid a race during `substrate bootstrap-deploy-account`.
* Bug fix: Properly support older instance types, especially t2, in the Instance Factory.

After upgrading Substrate:

1. [Configure Substrate shell completion](https://github.com/src-bin/substrate-manual/blob/main/getting-started/shell-completion/README.md)
2. `substrate bootstrap-management-account`
3. ` substrate create-admin-account -quality`` `` `_`quality`_ for each of your admin accounts

## 2022.03 <a href="#2022.03" id="2022.03"></a>

* Substrate now asks if it may post [telemetry](https://github.com/src-bin/substrate-manual/blob/main/telemetry/README.md) to Source & Binary. The data will be used to better understand how Substrate is being used and how it can be improved.
* Address deprecation warnings from the AWS Terraform provider by refactoring `root-modules/deploy`.
* Bug fix: Correctly pass an AWS access key to Terraform even if that access key is from an IAM user. This situation is unlikely but can come up during bootstrapping in brownfield environments.
* Bug fix: Display environments and qualities in the order they're defined in `substrate.environments` and `substrate.qualities` on the Intranet's Accounts page and in the output of `substrate accounts` and `substrate root-modules`.

After upgrading Substrate:

1. `substrate bootstrap-deploy-account`
2. `substrate-create-admin-account -quality="..."` for each of your admin accounts

## 2022.02 <a href="#2022.02" id="2022.02"></a>

* Upgrade to Terraform 1.1.6.
* Manage L-29A0C5DF, the AWS service limit on the number of accounts in an AWS organization, so that `substrate-create-admin-account` and `substrate-create-account` can proceed smoothly when you create your 11th account.
* Remove the `SubstrateVersion` tag from Terraform-managed resources. It hasn't been as helpful here as it is on Substrate-managed resources. Plus, Terraform plans are much easier to read without it.
* Bug fix: Pin the Terraform AWS provider to versions less than 4.0 which contains breaking changes that will be addressed in a subsequent Substrate release.

You must upgrade to Terraform 1.1.6 in order to use Substrate 2022.02. Terraform 1.1.6 may be found here:

* [https://releases.hashicorp.com/terraform/1.1.6/terraform\_1.1.6\_darwin\_amd64.zip](https://releases.hashicorp.com/terraform/1.1.6/terraform\_1.1.6\_darwin\_amd64.zip)
* [https://releases.hashicorp.com/terraform/1.1.6/terraform\_1.1.6\_darwin\_arm64.zip](https://releases.hashicorp.com/terraform/1.1.6/terraform\_1.1.6\_darwin\_arm64.zip)
* [https://releases.hashicorp.com/terraform/1.1.6/terraform\_1.1.6\_linux\_amd64.zip](https://releases.hashicorp.com/terraform/1.1.6/terraform\_1.1.6\_linux\_amd64.zip)
* [https://releases.hashicorp.com/terraform/1.1.6/terraform\_1.1.6\_linux\_arm64.zip](https://releases.hashicorp.com/terraform/1.1.6/terraform\_1.1.6\_linux\_arm64.zip)

After upgrading Substrate, do the following to land the Terraform upgrade and remove the `SubstrateVersion` tags:

1. `substrate-bootstrap-network-account`
2. `substrate-bootstrap-deploy-account`
3. `substrate-create-admin-account -quality="..."` for each of your admin accounts
4. `substrate-create-account -domain="..." -environment="..." -quality="..."` for each of your service accounts

## 2022.01 <a href="#2022.01" id="2022.01"></a>

* The `-role="..."` option to `substrate-assume-role` now defaults to OrganizationAdministrator, Auditor, DeployAdministrator, or NetworkAdministrator for the special accounts and Administrator for admin and service accounts (or Auditor pretty much across the board, if you begin in the Auditor role). This should save a great deal of typing.
* Add a navigational header to the Intranet to help folks get around.
* Allow the Auditor role in the audit account to use Amazon Athena to query the CloudTrail logs stored in S3 there. See [auditing your Substrate-managed AWS organization](https://github.com/src-bin/substrate-manual/blob/main/auditing/README.md) for more details.
* Bug fix: Substrate 2021.12 inadvertantly stopped accepting EC2 instance profile credentials on Instance Factory instances. (The instances are still assigned the correct role, Substrate programs just wouldn't use it.) Substrate programs once again use EC2 instance profile credentials when available.

After upgrading Substrate:

1. `substrate-create-admin-account -quality="..."`
2. Upgrade Substrate in your Instance Factory instances, if you install it there

## 2021.12 <a href="#2021.12" id="2021.12"></a>

* Substate now uses your default region (the one you chose to host your organization’s CloudTrail logs, among other things) when it executes global root modules. This allows you to more completely decouple yourself from us-east-1 if you so choose.
* Bug fix: Allow the Instance Factory to pass any IAM role configured in your IdP on to EC2 instances your non-Administrator users launch.
* Safety feature: No longer read `~/.aws/credentials` under any circumstances. Since we never use this file in a Substrate-managed AWS organization, reading this file can only serve to “cross the streams” with a legacy AWS account.

The upgrade process this month is much more involved that most. As such, we’ll talk in Slack about when you’re going to perform the upgrade to ensure support’s available in the moment.

Before upgrading Substrate, audit your Terraform modules for resources in global modules that aren’t from global AWS serivces by copying the following program to `audit.sh` in your Substrate repository and running `sh audit.sh`.

```
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
```

Every resource this program identifies needs to be modified before proceeding. The most likely modification is to add `provider = aws.us-east-1` to resources in the Terraform code that manages them.

Block all your coworkers from making Terraform changes however you usually do (announcing in Slack, deactivating CI/CD jobs, taking state file locks, etc.) and move your global state files from us-east-1 to your default region by copying the following program to `mv-state.sh` in your Substrate repository and running `sh mv-state.sh`.

```
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
```

Once you’ve run this program, there’s a provider to thread through the tree of Terraform modules before you can upgrade to Substrate 2021.12.

*   Add the following four lines in the domain module stanzas in `root-modules/*/*/*/global/main.tf`:

    ```
      providers = {
        aws           = aws
        aws.us-east-1 = aws.us-east-1
      }
    ```
*   Add the following three lines below `aws = {` in `modules/*/global/versions.tf` except `modules/lambda-function/global/versions.tf`, `modules/substrate/global/versions.tf`, and your own modules:

    ```
      configuration_aliases = [
        aws.us-east-1,
      ]
    ```

(I regret not being able to provide a `patch`(1) file for these operations but the contents of `versions.tf` post-Terraform 1.0 are too unpredictable to do so safely.)

Now you can upgrade Substrate. Don’t release your block just yet, though.

After upgrading Substrate:

1. `substrate-bootstrap-deploy-account`
2. `substrate-create-admin-account -quality="..."` for each of your admin accounts
3. `substrate-create-account -domain="..." -environment="..." -quality="..."` for each of your service accounts

Once all of these have run successfully, ensure all your coworkers upgrade Substrate and unblock Terraform changes.

I regret the complexity of this upgrade process but feel it is, on balance, less risky than attempting to hide all this motion behind automation. Thanks for your patience.

## 2021.11 <a href="#2021.11" id="2021.11"></a>

* New installations no longer configure a SAML provider. Instead, all AWS API and Console access is brokered by OAuth OIDC and your Intranet. Existing SAML providers are not removed.
* For those using Google as their IdP, read the name of the role to assume in the Credential and Instance Factories and the AWS Console from custom attributes on Google Workspace users. (For Okta users, Administrator is still the default.)
* Forward `Cookie` headers to HTTP(S) services wired into the Intranet by the experimental new `modules/intranet/regional/proxy` module. The theoretical security benefit of not exposing raw cookies (and instead exposing identity) is not remotely worth the loss in functionality it cost.
* Reduce the chance of Intranet misconfiguration by limiting which API Gateways can forward to the `substrate-intranet` Lambda function.
* Bug fix: The links to other parts of the Intranet from the page that `substrate-credentials` opens in your browser are relative links and were missing the `../` prefix, which has now been added.
* Removed version pinning of the long-unused Terraform `archive` provider.
* Removed `-no-cloudwatch` from `substrate-bootstrap-management-account`, `substrate-create-admin-account`, and `substrate-create-account` in favor of just actually detecting when it’s necessary and not doing it when it’s not.

Before upgrading Substrate, if you’re using Google as your IdP:

1. Add an additional custom attribute as follows:
   1. Visit [https://admin.google.com/ac/customschema](https://admin.google.com/ac/customschema) in a browser (or visit [https://admin.google.com](https://admin.google.com), click **Users**, click **More**, and click **Manage custom attributes**)
   2. Click the **AWS section**
   3. In the blank bottom row, enter “RoleName” for _Name_, select “Text” for _Info type_, select “Visible to user and admin” for _Visibility_, select “Single Value” for _No. of values_
   4. Click **SAVE**
2. Visit [https://admin.google.com/ac/users](https://admin.google.com/ac/users) and set the _RoleName_ attribute in the _AWS_ category to “Administrator” for every user authorized to use AWS.
3. Visit [https://console.cloud.google.com/apis/library/admin.googleapis.com](https://console.cloud.google.com/apis/library/admin.googleapis.com), confirm the selected project is the one that contains your Intranet’s OAuth OIDC configuration (its name will be listed next to "Google Cloud Platform" in the header), and click **ENABLE**.

After upgrading Substrate:

1. Run `substrate-create-admin-account -quality="..."` to upgrade your Intranet.

## 2021.10 <a href="#2021.10" id="2021.10"></a>

* The Intranet’s `/accounts` page now logs you into the AWS Console and assumes the specified role without requiring you to have already been logged in.
* The `-console` option to `substrate-assume-role` likewise now logs into the AWS Console and assumes the specified role without requiring you to have already been logged in.
* Auditor roles can now assume other Auditor roles, making it possible for Auditor to move throughout the organization while retaining its read-only status.
* The lists of principals that can assume the `Administrator` and `Auditor` roles may now be augmented by adding a JSON-encoded assume role policy in `substrate.Administrator.assume-role-policy.json` and/or `substrate.Auditor.assume-role-policy.json`.
* Enforce the use of IMDSv2 on instances from the Instance Factory. This is a prerequisite for organization-wide enforcement of using IMDSv2, which is an important default that reduces the potential impact of SSRF vulnerabilities.
* `substrate-whoami` output now also includes your IAM role ARN.
* Prompt folks to `cd` or set `SUBSTRATE_ROOT` when they try to `eval $(substrate-credentials)` from outside the Substrate repository.
* Allow all accounts in the organization, not just admin accounts, to read shared CloudWatch metrics.
* Added experimental `modules/intranet/regional/proxy` that makes it easy to put SSO in front of internal websites and HTTP APIs. See [protecting internal websites](https://github.com/src-bin/substrate-manual/blob/main/protecting-internal-websites/README.md) for more information and an example.
* Bug fix: Grant `s3:PutObjectAcl` so that it’s possible for all authorized principals to upload objects with the `bucket-owner-full-control` canned ACL.
* Bug fix: Extract `substrate-intranet.zip` from the `substrate` binary during Terraform runs in `root-modules/admin/*/*` instead of only during `substrate-create-admin-account`. This makes it far less painful for mulitple teammates to work in the same Substrate repository and for CI/CD systems to apply Terraform changes.
* Bug fix: Prevent a race between VPC sharing and tagging that caused `substrate-create-admin-account` and `substrate-create-account` to fail every time they were used to actually create an account.
* Added `-no-cloudwatch` to `substrate-bootstrap-management-account`, `substrate-create-admin-account`, and `substrate-create-account` that skips the slow process of managing all the roles necessary for cross-account CloudWatch sharing. (Useful if you’re certain you’ve not created a new account and you’re in a hurry.)

After upgrading Substrate:

1. Run `substrate-bootstrap-deploy-account` to fix the bucket policy so that all authorized principals in the organization can upload to the deploy artifact bucket(s).
2. Run `substrate-create-admin-account -quality="..."` to upgrade your Intranet and Auditor roles. Note well this will produce a fair number of new resources; this is step one in a multi-month process of brining some naming consistency to Substrate-managed resources in IAM, Lambda, and other AWS services.

## 2021.09.28 <a href="#2021.09.28" id="2021.09.28"></a>

* Bug fix: Properly detect when Substrate tools are invoked via symbolic links (i.e. in their original `substrate-assume-role` form rather than their new `substrate assume-role` form) on MacOS.

If you’re upgrading from 2021.08, follow the upgrade instructions from 2021.09. If you already upgraded to 2021.09, there are no further upgrade steps.

## 2021.09 <a href="#2021.09" id="2021.09"></a>

This release changes the interactive interface to `substrate-bootstrap-network-account` and `substrate-create-admin-account` to make them easier to run in CI. **If you are automating these commands by providing `yes` and `no` answers on standard input, this release will break your automation; you should run these commands interactively first to see what’s changed.** The details of what’s changed are listed in the usual format below.

* Move all Substrate commands into the `substrate` binary with symbolic links replacing the `substrate-*` binaries from previous releases. This can mostly be considered a no-op but note that now Substrate commands may be also be invoked as ` substrate`` `` `_`subcommand`_. This is not a deprecation notice for the original invocation style.
* Added `-fully-interactive`, `-minimally-interactive`, and `-non-interactive` to all Substrate commands. `-fully-interactive` is almost identical (see below) to the behavior of 2021.08 and earlier releases. `-minimally-interactive` is the new default and removes the incessant “is this correct? (yes/no)” dialogs, which I thought would be welcome but turned out to be annoying. `-non-interactive` will never prompt for input and will instead exit with a non-zero status if input is required.
* Changed the interactive prompts concerning Google and Okta configuration to make them less bothersome and (in the Okta case) less prone to unintentional changes. **If you are automating `substrate-create-admin-account` by providing `yes` and `no` answers on standard input, this change will break your automation; you should run this command interactively first to see what’s changed.**
* Added a confirmation to `substrate-create-admin-account` and `substrate-create-account` to prevent errant creation of new AWS accounts (which are tedious to delete in case creation was a mistake) plus a new `-create` option to suppress that confirmation.
* Updated the Substrate-managed Service Control Policy attached to your organization to deny access to the `cloudtrail:CreateTrail` API. Substrate creates a multi-region, organization-wide trail early in its initialization. This policy prevents additional trails from being created because they are excessively expensive and redundant.
* Added e-mail address columns to tables of AWS accounts in `substrate.accounts.txt`, `substrate-accounts`, and the Intranet’s `/accounts` page.
* Added `-format=shell` to `substrate-accounts`, which enumerates AWS accounts as shell commands to the various `substrate-bootstrap-*` and `substrate-create-*` commands. This is useful for driving CI/CD of Terraform changes. It’s also useful for automating Substrate upgrades.
* Added `substrate-root-modules`, which enumerates every Substrate-managed Terraform root module in a sensible order. This, too, is useful for driving CI/CD of Terraform changes.
* Added a new `root-modules/deploy/global` root module under the management of `substrate-bootstrap-deploy-account`. Substrate doesn’t manage any resources there but you’re free to.
* Bug fix: Ensure that objects put into the deploy buckets in S3 by any account in your organization may actually be fetched by other accounts in your organization. Requires objects be uploaded with the `bucket-owner-full-control` canned ACL.
* Bug fix: Avoid a fork bomb in case `substrate-whoami` is invoked with a `/` in the pathname (i.e. as `~/bin/substrate-whoami`).

After upgrading Substrate:

1. Run `substrate-bootstrap-management-account` to update your organization’s Service Control Policy.
2. Run `substrate-bootstrap-deploy-account` to reconfigure the deploy buckets in S3 and generate the `global` root module.
3. Run `substrate-create-admin-account -quality="..."` to add the e-mail address column to your Intranet’s `/accounts` page.

## 2021.08 <a href="#2021.08" id="2021.08"></a>

* Roll `substrate-apigateway-authorizer`, `substrate-credential-factory`, and `substrate-instance-factory` into `substrate-intranet`. This is a no-op listed here for transparency. It’s a prerequisite step towards unifying all the Substrate tools as subcommands of `substrate`, thereby reducing the size and complexity of the Substrate distribution.
* Stop using the `archive` and `external` Terraform providers by embedding `substrate-intranet.zip` directly in `substrate-create-admin-account`. Dependence on these providers will be made optional in a subsequent release.
* VPCs are no longer shared organization-wide, leaving the fine-grained VPC sharing introduced in 2021.07 to maintain each service account’s access to its intended VPCs.
* The Instance Factory now supports ARM instances (i.e. the a1, c6g, m6g, r6g, and t4g families).
* Bug fix: Switch back to the original working directory in `substrate-assume-role` (which will have changed if invoked with `SUBSTRATE_ROOT` set) before forking and executing a child process.
* Added `substrate-whoami` to make it easy to learn the domain, environment, and quality of the AWS account your current credentials operate on.
* Added `-format=json` to `substrate-accounts` to make it easier to enumerate and act programatically on every AWS account in your organization. See [enumerating all your AWS accounts](https://github.com/src-bin/substrate-manual/blob/main/enumerating-all-your-aws-accounts/README.md) for an example.

After upgrading Substrate:

1. Run `substrate-bootstrap-management-account` to grant `substrate-whoami` the permissions it needs.
2. Run `substrate-bootstrap-network-account` to remove coarse-grained organization-wide VPC sharing.
3. Run `substrate-create-admin-account -quality="..."` to upgrade your Intranet.

## 2021.07 <a href="#2021.07" id="2021.07"></a>

* The Intranet’s `/accounts` page now opens the AWS Console in new browser tabs as it probably always should have.
* Substrate now only manages the version constraint on the `archive`, `aws`, and `external` providers rather than all of `versions.tf`. This opens the door to Substrate users adding (and version constraining) additional providers. See [additional Terraform providers](https://github.com/src-bin/substrate-manual/blob/main/additional-terraform-providers/README.md) for an example.
* Upgrade to and pin Terraform 1.0.2 and the `aws` provider >= 3.49.0.
*   Tag many more AWS resources with `Manager` and `SubstrateVersion` using the `default_tags` facility of the AWS provider. If you encounter the following error, remove `Manager` and `SubstrateVersion` (if present) from the indicated resources and re-run.\\

    ```
    Error: "tags" are identical to those in the "default_tags" configuration block of the provider: please de-duplicate and try again
    ```
* All Substrate tools will now change their working directory to the value of the `SUBSTRATE_ROOT` environment variable, if set, rather than always proceeding in whatever the working directory was when invoked.
* Share VPCs specifically with accounts that match their environment and quality. This is a no-op that enables a future release to remove organization-wide VPC sharing.

You must upgrade to Terraform 1.0.2 in order to use Substrate 2021.07. Terraform 1.0.2 may be found here:

* [https://releases.hashicorp.com/terraform/1.0.2/terraform\_1.0.2\_darwin\_amd64.zip](https://releases.hashicorp.com/terraform/1.0.2/terraform\_1.0.2\_darwin\_amd64.zip)
* [https://releases.hashicorp.com/terraform/1.0.2/terraform\_1.0.2\_darwin\_arm64.zip](https://releases.hashicorp.com/terraform/1.0.2/terraform\_1.0.2\_darwin\_arm64.zip)
* [https://releases.hashicorp.com/terraform/1.0.2/terraform\_1.0.2\_linux\_amd64.zip](https://releases.hashicorp.com/terraform/1.0.2/terraform\_1.0.2\_linux\_amd64.zip)
* [https://releases.hashicorp.com/terraform/1.0.2/terraform\_1.0.2\_linux\_arm64.zip](https://releases.hashicorp.com/terraform/1.0.2/terraform\_1.0.2\_linux\_arm64.zip)

After upgrading Terraform and Substrate:

1. Run `substrate-bootstrap-network-account` and `substrate-bootstrap-deploy-account` to complete the Terraform 1.0.2 upgrade there. Note well that `tags` and `tags_all` output will be somewhat confusing but will ultimately do the right thing.
2. Run `substrate-create-admin-account` and `substrate-create-account` to complete the Terraform 1.0.2 upgrade for each of your admin and service accounts. Here, too, note well that `tags` and `tags_all` output will be somewhat confusing but will ultimately do the right thing.

## 2021.06 <a href="#2021.06" id="2021.06"></a>

* List all the Intranet resources on the Intranet homepage, not just top-level resources.
* Roll `substrate-apigateway-authenticator` and `substrate-apigateway-index` into `substrate-intranet`. This is a no-op listed here for transparency.
* Tag shared VPCs in service accounts to clearly indicate in the AWS Console which one you should be using. This lays the groundwork for finer-grained VPC sharing in a future release.
* Upgrade to and pin Terraform 0.15.5 and newer providers with relaxed `>=` version constraints on providers (but not Terraform itself).

You must upgrade to Terraform 0.15.5 in order to use Substrate 2021.06. Terraform 0.15.5 may be found here:

* [https://releases.hashicorp.com/terraform/0.15.5/terraform\_0.15.5\_darwin\_amd64.zip](https://releases.hashicorp.com/terraform/0.15.5/terraform\_0.15.5\_darwin\_amd64.zip)
* [https://releases.hashicorp.com/terraform/0.15.5/terraform\_0.15.5\_linux\_amd64.zip](https://releases.hashicorp.com/terraform/0.15.5/terraform\_0.15.5\_linux\_amd64.zip)
* [https://releases.hashicorp.com/terraform/0.15.5/terraform\_0.15.5\_linux\_arm64.zip](https://releases.hashicorp.com/terraform/0.15.5/terraform\_0.15.5\_linux\_arm64.zip)

After upgrading Terraform and Substrate:

1. Run `substrate-bootstrap-network-account` and `substrate-bootstrap-deploy-account` to complete the Terraform 0.15.5 upgrade there.
2. Run `substrate-create-admin-account -quality="..."` to update your Intranet.
3. Run `substrate-create-account -domain="..." -environment="..." -quality="..."` for all your service accounts to tag your shared VPCs.

If you’ve added any stub `provider` blocks to your modules, leave them in place for now and accept the deprecation warning. Terraform only allows one `required_providers` block and that is now managed by Substrate. A future release will accommodate these additional providers.

## 2021.05 <a href="#2021.05" id="2021.05"></a>

* Bug fix: S3 traffic from private subnets is now correctly routed via the VPC Endpoint and not through the NAT Gateway.
* Bug fix: Allow outbound IPv6 traffic from Instance Factory instances to match IPv4 and enable use of the IPv6 Internet.
* Bug fix: Instance Factory instances now have 100GB disks instead of whatever the AMI happened to request, which recently shrank from 8GB to 2GB.
* Bug fix: The Instance Factory now only lists instances which belong to you. It previously listed all instances for all your users.
* By popular request, authorize admin accounts to directly access CloudWatch logs and metrics from all your accounts.

After upgrading:

* Run `substrate-bootstrap-network-account` to fix S3 routes.
* Run `substrate-create-admin-account -quality="..."` to enable direct CloudWatch access and make Instance Factory improvements.

## 2021.04 <a href="#2021.04" id="2021.04"></a>

* Added `/accounts` to the Intranet with links to assume the Administrator and Auditor roles in all your accounts in the AWS Console.
* Added `-console` to `substrate-assume-role` which attempts to open the AWS Console’s role switching screen in your web browser with all the values filled in.
* Added `substrate-create-terraform-module` which creates the directory structure (with the `global` and `regional` pattern), providers, and Substrate metadata for a new Terraform module.
* Now building for M1 Macs, too.

After upgrading, run `substrate-create-admin-account -quality="..."` to add `/accounts` to your Intranet.

## 2021.03 <a href="#2021.03" id="2021.03"></a>

* Extended AWS Console sessions to 12 hours for organizations using Google as their IdP.
* Upgrade to and pin Terraform 0.14.7.
* `substrate-bootstrap-network-account` now creates peering connections between all VPCs in all regions for each environment across all valid qualities.
* Fixed a bug in the `Administrator` role in admin accounts that prevented Instance Factory instances from seamlessly assuming the role.

You must upgrade to Terraform 0.14.7 in order to use Substrate 2021.03. Terraform 0.14.7 may be found here:

* [https://releases.hashicorp.com/terraform/0.14.7/terraform\_0.14.7\_darwin\_amd64.zip](https://releases.hashicorp.com/terraform/0.14.7/terraform\_0.14.7\_darwin\_amd64.zip)
* [https://releases.hashicorp.com/terraform/0.14.7/terraform\_0.14.7\_linux\_amd64.zip](https://releases.hashicorp.com/terraform/0.14.7/terraform\_0.14.7\_linux\_amd64.zip)
* [https://releases.hashicorp.com/terraform/0.14.7/terraform\_0.14.7\_linux\_arm64.zip](https://releases.hashicorp.com/terraform/0.14.7/terraform\_0.14.7\_linux\_arm64.zip)

After upgrading:

1. `rm -f -r root-modules/network/*/peering` and remove these files from version control.
2. `substrate-bootstrap-network-account` to peer all your VPCs that should be peered.
3. `substrate-create-admin-account -quality="..."` to fix Instance Factory IAM roles, following the [Google SAML setup](https://src-bin.com/substrate/manual/getting-started/google-saml/) guide if Google is your IdP to also get 12-hour AWS Console sessions.

## 2021.02 <a href="#2021.02" id="2021.02"></a>

* Added `-format` from `substrate-credentials` to `substrate-assume-role` per request from a customer. Now credentials can be had with or without the `export` prefix or as JSON a la `aws sts assume-role` itself.
* Removed `root-modules/admin/*`’s awkward dependency on finding `GOBIN` in the environment. The generated `Makefile` in each root module remains, however.
* Upgrade to and pin Terraform 0.13.6 and the Terraform AWS provider 3.26.0.
* `substrate-assume-role` and `substrate-credentials` now (better) tolerate being invoked from subdirectories of your Substrate repository.
* Fix a bug in Terraform module generation in which the `aws.network` provider was incorrectly added to global modules and thus should have been expected in module stanzas.
* Stop printing the `export AWS_ACCESS_KEY_ID=...` line when `substrate-assume-role` is given a command to execute directly.
* Provide the Intranet’s REST API ID, root resource ID, and a few other necessities as outputs from the `intranet/regional` module to facilitate adding more resources to these APIs.

You must upgrade to Terraform 0.13.6 in order to use Substrate 2021.02. Terraform 0.13.6 may be found here:

* [https://releases.hashicorp.com/terraform/0.13.6/terraform\_0.13.6\_darwin\_amd64.zip](https://releases.hashicorp.com/terraform/0.13.6/terraform\_0.13.6\_darwin\_amd64.zip)
* [https://releases.hashicorp.com/terraform/0.13.6/terraform\_0.13.6\_linux\_amd64.zip](https://releases.hashicorp.com/terraform/0.13.6/terraform\_0.13.6\_linux\_amd64.zip)
* [https://releases.hashicorp.com/terraform/0.13.6/terraform\_0.13.6\_linux\_arm64.zip](https://releases.hashicorp.com/terraform/0.13.6/terraform\_0.13.6\_linux\_arm64.zip)

## 2021.01 <a href="#2021.01" id="2021.01"></a>

You must run `substrate-create-admin-account` for each of your admin accounts before you'll be able to use `eval $(substrate-credentials)` to streamline your use of the Credential Factory.

## 2020.12 <a href="#2020.12" id="2020.12"></a>

You must run `substrate-bootstrap-management-account` in order to re-tag your former master account as your management account. (This rename follows AWS' own renaming.)

## 2020.11 and prior releases

Contact [hello@src-bin.com](mailto:hello@src-bin.com) for prior release notes.