# Upgrading Substrate

In general, upgrading Substrate is a matter of running `substrate upgrade`. If your `substrate` binary is not writeable, `substrate upgrade` will produce the URL of the tarball you'll need to download and untar to get the new `substrate` binary. You should put this in your PATH, replacing the old version.

After upgrading, you should re-run the bootstrapping and account creation commands. The most thorough upgrade requires that you run the following after replacing the binaries:

1. `substrate bootstrap-management-account`
2. `substrate bootstrap-network-account`
3. `substrate bootstrap-deploy-account`
4. `substrate create-admin-account -quality "..."` for each of your admin accounts
5. `substrate create-account -domain "..." -environment "..." -quality "..."` for each of your other accounts

As a convenience, `substrate accounts -format shell` will generate all of these commands and put them in the proper order. For the most streamlined workflow, run `sh <(substrate accounts -format shell -no-apply)`, review what Terraform plans to do, and then run `sh <(substrate accounts -auto-approve -format shell)` to apply the changes.

See the [release notes](https://github.com/src-bin/substrate-manual/blob/main/releases/README.md) for version-specific upgrade instructions. They will endeavor to call out which of these steps, and potentially additional steps, are necessary to gain access to new features.

**Upgrade compatibility is only guaranteed from one month to the next so it's important to stay up-to-date. Behavior of upgrading several versions in one step is undefined and may not function properly.**
