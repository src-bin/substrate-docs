# Bootstrapping your Substrate-managed AWS organization

The time has come! This section will guide you through running the first several Substrate commands to configure your Substrate-managed AWS organization.

## Decide where you'll run Substrate commands

All Substrate commands should be run from the same directory. Many commands will read and write files there to save your input and pass configuration and state from one command to another.

The most natural options are, in no particular order:

- The root of the Git repository where you keep your Terraform code
- A subdirectory of a Git repository
- A new Git repository just for Substrate

(Git is by no means required - you're free to choose any version control software.)

You can always change your mind on this simply by moving `modules`, `root-modules`, and `substrate.*` into another directory or repository.

Decide and change to that directory before proceeding.

If you like, now or later, you can set `SUBSTRATE_ROOT` in your environment to a fully-qualified directory pathname. Substrate will change to this directory at the beginning of every command so you don't have to micromanage your working directory.

## Bootstrapping your management account

### `substrate bootstrap-management-account`

When you run this program, you'll be prompted several times for input. As much as is possible, this input is all saved to the local filesystem and referenced on subsequent runs.

The first of these inputs is an access key from the root of your new AWS account. It is never saved to disk (for security reasons) so keep it handy until later in this guide when it you're told it's safe to delete it. To create a root access key:

1. Visit <https://console.aws.amazon.com/iam/home#/security_credentials>
2. Open the _Access keys (access key ID and secret access key)_ section
3. Click **Create New Access Key**
4. Click **Show Access Key**
5. Save these values in your password manager for now

This program creates your AWS organization, creates the audit account and enables CloudTrail, creates the deploy and network accounts, configures a basic service control policy, and creates the necessary roles and policies to allow your administrators to move relatively freely.

When this program exits, you should commit `substrate.*` to version control. Do not forget your root access key yet. It is safe to re-run this program at any time.

### Delegate access to billing data

While you're logged into your management account using the root credentials, follow these steps to delegate access to billing data to people and tools assuming IAM roles.

1. Visit <https://console.aws.amazon.com/billing/home?#/account>
2. Open the _IAM User and Role Access to Billing Information_ section
3. Check &ldquo;Activate IAM Access&rdquo;
4. Click **Update**
5. Visit <https://console.aws.amazon.com/billing/home#/costexplorer>
6. Click **Enable Cost Explorer**

## Bootstrapping your network account

The previous step created the three special AWS accounts - audit, deploy, and network - but neglected to complete the configuration of the deploy and network accounts. The reason for this is because both of these accounts are managed by Terraform code. The bootstrapping steps generate some code while leaving room for you to add more later.

### `substrate bootstrap-network-account`

Here, too, during your first run you'll be prompted for your root access key.

This program additionally asks for the names of your environments, the release qualities you want to use, and the specific combinations that are valid. You may want to peek ahead at [domains, environments, and qualities](../../domains-environments-qualities/) to see how these pieces fit together. Environments typically have names like &ldquo;development&rdquo; and &ldquo;production&rdquo; &mdash; they identify a set of data and all the infrastructure that may access it. Qualities are names given to independent copies of your infrastructure _within an environment_ that make it possible to gradually deploy changes to AWS resources just like you might gradually deploy changes to your software.

It also asks which AWS regions you want to use. Your answers inform how it lays out your networks to strike a balance between security, reliability, ergonomics, and cost. Substrate recommends starting with 2-4 regions that make geographic sense to your customers.

This program may attempt to programmatically raise the limit on some specific AWS service quotas. Depending on the regions you chose, how many environments and qualities you specified, and how the AWS support staff are feeling, this may block you for a long time. It's recommended to start slow by, for instance, only specifying &ldquo;admin&rdquo; and &ldquo;staging&rdquo; environments, expecting to add more later.

When this program exits, you should commit `substrate.*` and `root-modules/network/` to version control. It is safe to re-run this program at any time and during those runs you can add additional environments and qualities if you so choose.

## Bootstrapping your deploy account

### `substrate bootstrap-deploy-account`

This program doesn't need any input except during its first run in which you'll be prompted for your root access key.

When this program exits, you should commit `modules/deploy/` and `root-modules/deploy/` to version control. It is safe to re-run this program at any time.

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../shell-completion/">Configuring Substrate shell completion</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../integrating-your-identity-provider/">Integrating your identity provider to control access to AWS</a></p>
    </section>
</section>
