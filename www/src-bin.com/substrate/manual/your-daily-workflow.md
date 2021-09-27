# Your daily workflow in your Substrate-managed AWS organization

You've reached the end of the [getting started](/substrate/manual/getting-started/) guide and [you understand your Substrate-managed AWS organization](/substrate/manual/your-aws-organization). Now what? Now you get to work. Here's how.

To make it easy to move around your directory tree, consider setting `SUBSTRATE_ROOT` in your environment (permanently via your `~/.profile`, even) to the fully-qualified directory where you initially ran Substrate. All Substrate tools will change to this working directory if this environment variable is set.

## Getting into AWS

For most tasks, you're going to need AWS credentials. Substrate strongly discourages the creation of personal IAM users with long-lived access keys; these are highly likely to be stolen in case of a laptop compromise and misuse can be difficult to detect. It's best not to have them at all. Instead, Substrate helps you get very short-lived AWS credentials in one of three ways:

Run `eval $(substrate-credentials)` in your terminal and follow its instructions. This will work from instances in the cloud or a laptop, though the flow is a smoothest on a laptop where a web browser can be opened from the command line. This is the best choice for most folks.

If for some reason `eval $(substrate-credentials)` doesn't work for you, visit [https://example.com/credential-factory](https://example.com/credential-factory) (substituting your Intranet DNS domain name), then paste the `export` command into your terminal. This makes the most sense for folks who like to work from their laptop, regardless of what the rest of their toolchain looks like.

You can also visit [https://example.com/instance-factory](https://example.com/instance-factory) (substituting your Intranet DNS domain name) and follow the steps to provision an EC2 instance to use for your administrative work. This makes the most sense for folks who use a terminal-based text editor and like to work &ldquo;in the cloud.&rdquo;

In all three cases, the temporary credentials are going to put you in the `Administrator` role in (one of) your admin account(s). From here you'll be able to go anywhere you need to go.

## Navigating your AWS organization

There isn't usually much to do in your admin account. Instead, you'll be assuming roles in other accounts where your real work happens. There are three ways this happens:

Ad-hoc movement throughout your organization is made easy by the `substrate-assume-role` tool. It understands the layout and can convert domains, environments, and qualities into the appropriate AWS account numbers for you. Thus, to get temporary credentials in your _example staging alpha_ account (once you've created such an account), you'd run `substrate-assume-role -domain=example -environment=staging -quality=alpha` and paste the resulting environment variables into your terminal. Or, if you had a specific command you needed to run, tack it onto the end thus: `substrate-assume-role -domain=example -environment=staging -quality=alpha aws ec2 describe-security-groups`. When you're finished, you can `unassume-role` to revert to the credentials previously stored in your environment. (This is analogous to the `cd` builtin's use of the `OLDPWD` environment variable.)

Exploration aside, most work on your AWS organization happens in Terraform. `substrate-create-account` creates a root Terraform module for you with providers configured to assume the appropriate role so you don't have to think about matching credentials in your environment with directories in which you invoke `terraform apply`. All you'll ever need to invoke Terraform are those `Administrator` credentials you get from the Credential and Instance Factories.

Finally, there is also `substrate.accounts.txt` in your Substrate directory. With the account numbers and roles in this file you can use the Switch Role feature in the AWS Console or any number of other tools built expecting IAM role ARNs.

### Networks

Your networks, all in your network account, are tagged according to their environment and quality. Unfortunately, those tags aren't visible outside the network account, so in order to see those, you'll need to assume the `Auditor` or `NetworkAdministrator` role in your network account.

This is, in practice, a rare occurrence because the `substrate` module that's automatically instantiated in all your domain Terraform modules gives you a quick reference to the correct public and private subnets via `module.substrate.public_subnet_ids` and `module.substrate.private_subnet_ids`.

## Organizing your code

**tl;dr: Write code in the `modules` subdirectories Substrate creates for you. Run Terraform from the `root-modules` subdirectories matching the domain, environment, quality, and AWS region you want.**

Suppose you're responsible for a service called _example_ that you run in _staging_ as _alpha_-quality and in _production_ as _beta_- and _gamma_-quality. You will have run the following commands to create all the AWS accounts:

- `substrate-create-account -domain=example -environment=staging -quality=alpha`
- `substrate-create-account -domain=example -environment=production -quality=beta`
- `substrate-create-account -domain=example -environment=production -quality=gamma`

These will create the following directory trees, which you will have committed to version control:

- `modules`
    - `example`
        - `global`
        - `regional`
- `root-modules`
    - `example`
        - `staging`
            - `alpha`
                - `global`
                - `us-east-2`
                - `us-west-2`
        - `production`
            - `beta`
                - `global`
                - `us-east-2`
                - `us-west-2`
            - `gamma`
                - `global`
                - `us-east-2`
                - `us-west-2`

What do you do next? And where do you do it?

The vast majority of your work should happen in your domain's Terraform modules. In this _example_ domain those are `modules/example/global` and `modules/example/regional`. Put global resources like IAM roles and Route 53 records in `modules/example/global`. Put regional resources like autoscaling groups and EKS clusters in `modules/example/regional`. (Substrate has generated all the `module` blocks necessary to instantiate these modules with the right Terraform providers.)

You selected some number of AWS regions when you configured your network but you may not want to run all your infrastructure in all those regions all the time (if for no other reason than cost control). You may edit `root-modules/*/*/*/*/main.tf` to customize which of your selected regions are actually in use. By default, all your selected regions are in use. If you don't want to provision your infrastructure in any of them, simply comment out the resources in `root-modules/*/*/*/*/main.tf` (substituting your domains, environments, qualities, and regions as desired).

## Testing and deploying Terraform changes

It's no accident that `modules/example/global` and `modules/example/regional` are referenced by the root Terraform modules for every environment and quality in the domain. These afford you multiple opportunities to implement changes in pre-_production_ and partial-_production_ in order to catch more bugs and failures before they impact all your capacity and all your customers. Continuing from the example above, here is the complete lifecycle of a Terraform change in the _example_ domain:

1. Change e.g. an EC2 launch template in `example/regional/main.tf`
2. Commit, push, get a code review, and merge into the main branch
3. `make -C root-modules/example/staging/alpha/us-east-2 plan` and inspect the output
4. `make -C root-modules/example/staging/alpha/us-east-2 apply`
5. Verify the correctness of the change in your _staging_ environment
6. `make -C root-modules/example/production/beta/us-east-2 plan` and inspect the output
7. `make -C root-modules/example/production/beta/us-east-2 apply`
8. Observe your product's behavior in your _production_ environment for long enough to convince yourself the change is correct
    - If your beta-quality infrastructure sees only a tiny trickle of traffic, this may take a while
    - As you mature, it'll become more and more valuable to [automate](https://aws.amazon.com/builders-library/automating-safe-hands-off-deployments/) this observation step
9. `make -C root-modules/example/production/gamma/us-east-2 plan` and inspect the output
10. `make -C root-modules/example/production/gamma/us-east-2 apply`
11. Observe your product's behavior in your _production_ environment for long enough to convince yourself the change is correct
    - Now that your change has landed everywhere, this should be a much shorter time

Any failure or suspicious behavior is reason to abort, revert the change, and rollback all the changes you actually made.

All the steps in this process can easily be executed by CI/CD systems according to your preferences. A CI/CD system running in AWS can be granted `Administrator` privileges directly. A CI/CD system offered as SaaS may be able to assume an IAM role but, more likely, you'll need to define an `aws_iam_user` resource in your admin account and arrange to provide an access key for that user to your CI/CD system. (Don't forget to accommodate _and practice_ access key rotation!)
