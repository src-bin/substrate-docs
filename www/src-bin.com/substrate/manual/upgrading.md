# Upgrading Substrate

In general, upgrading Substrate is a matter of replacing the Substrate binary on your PATH and re-running certain of the bootstrapping and account creation commands. The most thorough upgrade requires that you run the following after replacing the binaries:

1. `substrate bootstrap-management-account`
2. `substrate bootstrap-network-account`
3. `substrate bootstrap-deploy-account`
4. `substrate create-admin-account -quality "..."` for each of your admin accounts
5. `substrate create-account -domain "..." -environment "..." -quality "..."` for each of your other accounts

See the [release notes](../releases/) for version-specific upgrade instructions. They will endeavor to call out which of these steps, and potentially additional steps, are necessary to gain access to new features. It is, however, good hygiene to regularly run all of these commands.

**Upgrade compatibility is only guaranteed from one month to the next so it's important to stay up-to-date. Behavior of upgrading several versions in one step is undefined and may not function properly.**
