# Bootstrapping your Substrate-managed AWS organization

The time has come! This section will guide you through running the first several Substrate commands to configure your Substrate-managed AWS organization.

## Decide where you'll run Substrate commands

All Substrate commands should be run from the same directory. Many commands will read and write files there to save your input and pass configuration and state from one command to another.

The most natural options are, in no particular order:

* The root of the Git repository where you keep your Terraform code
* A subdirectory of a Git repository
* A new Git repository just for Substrate

(Git is by no means required - you're free to choose any version control software.)

You can always change your mind on this simply by moving `modules`, `root-modules`, and `substrate.*` into another directory or repository.

Decide and change to that directory before proceeding.

If you like, now or later, you can set `SUBSTRATE_ROOT` in your environment to a fully-qualified directory pathname. Substrate will change to this directory at the beginning of every command so you don't have to micromanage your working directory.

## Bootstrapping your management account

Run:

```shell-session
substrate bootstrap-management-account
```

When you run this program, you'll be prompted several times for input. As much as is possible, this input is all saved to the local filesystem and referenced on subsequent runs.

The first of these inputs is an access key from the root of your new AWS account. It is never saved to disk (for security reasons) so keep it handy until later in this guide when it you're told it's safe to delete it. To create a root access key:

1. Visit [https://console.aws.amazon.com/iam/home#/security\_credentials](https://console.aws.amazon.com/iam/home#/security\_credentials)
2. Scroll to the _Access keys_ section
3. Click **Create access key**
4. Check the “I understand...” box and click **Create access key**
5. Click **Show**
6. Save these values in your password manager for now

This program creates your AWS organization, creates the audit account and enables CloudTrail, creates the deploy and network accounts, configures a basic service control policy, and creates the necessary roles and policies to allow your administrators to move relatively freely.

When this program exits, you should add `.substrate.*` to your version control system's ignore list (e.g. `.gitignore`) and commit `substrate.*` to version control. Do not forget your root access key yet. It is safe to re-run this program at any time.

### Delegate access to billing data

While you're logged into your management account using the root credentials, follow these steps to delegate access to billing data to people and tools assuming IAM roles.

1. Visit [https://console.aws.amazon.com/billing/home?#/account](https://console.aws.amazon.com/billing/home?#/account)
2. Open the _IAM User and Role Access to Billing Information_ section
3. Check “Activate IAM Access”
4. Click **Update**
5. Visit [https://console.aws.amazon.com/billing/home#/costexplorer](https://console.aws.amazon.com/billing/home#/costexplorer)
6. Click **Enable Cost Explorer** or **Launch Cost Explorer** (whichever is displayed)

## Bootstrapping your network account

The previous step created the three special AWS accounts - audit, deploy, and network - but neglected to complete the configuration of the deploy and network accounts. The reason for this is because both of these accounts are managed by Terraform code. The bootstrapping steps generate some code while leaving room for you to add more later.

Run:

```shell-session
substrate bootstrap-network-account
```

Here, too, during your first run you'll be prompted for your root access key.

This program additionally asks for the names of your environments, the release qualities you want to use, and the specific combinations that are valid. You may want to peek ahead at [domains, environments, and qualities](../ref/domains-environments-qualities.md) to see how these pieces fit together. Environments typically have names like “development” and “production” — they identify a set of data and all the infrastructure that may access it. Qualities are names given to independent copies of your infrastructure _within an environment_ that make it possible to incrementally change AWS resources. If you're unsure, defining a single quality called “default” is good.

It also asks which AWS regions you want to use. Your answers inform how it lays out your networks to strike a balance between security, reliability, ergonomics, and cost. If you're unsure, starting with one region is fine.

Substrate will provoision NAT Gateways for your networks if you so choose, which will enable outbound IPv4 access to the Internet from your private subnets. The AWS-managed NAT Gateways will cost about $100 per month per region per environment/quality pair. Without them, private subnets will only have outbound IPv6 access to the Internet; this is very possibly a fine state as the only notable thing that servers tend to access that isn't available via IPv6 is GitHub.

Even if you want Substrate to provision NAT Gateways, we recommend you initially answer "no" when prompted about them. This is because provisioning NAT Gateways for two or more environments will require more Elastic IP addresses than AWS' default service quota allows. Substrate will programmatically raise the limit on the relevant AWS service quotas but it may take AWS staff hours or days to respond. Thus, we think it's best to come back later to request these quotas be raised. Once they are, you can change that "no" to a "yes" and Substrate will provision your NAT Gateways.

When this program exits, you should commit `substrate.*` and `root-modules/network/` to version control. It is safe to re-run this program at any time and during those runs you can add additional environments and qualities if you so choose.

## Bootstrapping your deploy account

Run:

```shell-session
substrate bootstrap-deploy-account
```

This program doesn't need any input except during its first run in which you'll be prompted for your root access key.

When this program exits, you should commit `modules/deploy/` and `root-modules/deploy/` to version control. It is safe to re-run this program at any time.
