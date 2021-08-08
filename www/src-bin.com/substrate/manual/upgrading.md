# Upgrading Substrate

In general, upgrading Substrate is a matter of replacing the Substrate binaries and re-running certain of the bootstrapping and account creation commands. The most thorough upgrade requires that you run the following after replacing the binaries:

1. `substrate-bootstrap-management-account`
2. `substrate-bootstrap-network-account`
3. `substrate-bootstrap-deploy-account`
4. `substrate-create-admin-account` for each of your admin accounts
5. `substrate-create-account` for each of your other accounts

Release notes will endeavor to call out specific of these steps that are necessary to gain access to new features. Others remain recommended, of course.

Upgrade compatibility is only guaranteed from one month to the next so it's important to stay up-to-date. Behavior of upgrading several versions in one step is undefined and may not function properly.

## Upgrade notes by release

See the [release notes](/substrate/manual/releases/) for version-specific upgrade notes for versions 2021.02 and beyond.

### 2021.01

You must run `substrate-create-admin-account` for each of your admin accounts before you'll be able to use `eval $(substrate-credentials)` to streamline your use of the Credential Factory.

### 2020.12

You must run `substrate-bootstrap-management-account` in order to re-tag your former master account as your management account. (This rename follows AWS' own renaming.)
