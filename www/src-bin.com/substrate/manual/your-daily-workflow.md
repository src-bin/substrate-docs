# Your daily workflow in your Substrate-managed AWS organization

You've reached the end of the [getting started](/substrate/manual/getting-started/) guide and [you understand your Substrate-managed AWS organization](/substrate/manual/your-aws-organization). Now what? Now you get to work. Here's how.

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

[Referencing Substrate parameters in Terraform](../referencing-substrate-parameters-in-terraform/) documents how, within these modules and files, you can parameterize your own code by domain, environment, and quality and make use of the VPC Substrate automatically shares with each AWS account.

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
