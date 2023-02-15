# Moving between AWS accounts

There isn't usually much to do in your admin account(s). Instead, you'll be assuming roles in other accounts where your real work happens. There are three ways this happens:

```shell-session
substrate assume-role
```

Ad-hoc movement throughout your organization is made easy by the `substrate assume-role` command. It understands the layout and can convert domains, environments, and qualities into the appropriate AWS account numbers for you.

To get temporary credentials in your _example development default_ account (once you've created such an account), you'd run `substrate assume-role -domain example -environment development -quality default`. Without any additional arguments, `substrate assume-role` prints shell environment variables so you should wrap it in `eval`. It will also feed the shell an `unassume-role` alias you can use to pop back into your admin account:

```shell-session
eval $(substrate assume-role -domain example -environment development -quality default)
# do whatever you like
unassume-role
```

If you have a specific command you need to run, tack it onto the end thus:

```shell-session
substrate assume-role -domain example -environment development -quality default aws ec2 describe-security-groups
```

In addition to the forms above that allow specifying a domain, environment, and quality, `substrate assume-role` can select your management account with `-management`, your deploy or network account with `-special deploy` or `-special network`, and an admin account with `-admin -quality`` `_`quality`_. Or you can go completely off-road and specify any arbitrary AWS account with `-number`` `_`number`_.

By default, `substrate assume-role` will carry on with the same role name — Administrator (or OrganizationAdministrator, etc. as appropriate) when you're Administrator, Auditor when you're Auditor, and so on. You can specify a different role name using `-role`` `_`role`_.

## Terraform

A lot of work in your AWS organization hopefully happens in Terraform and not ad-hoc shell sessions. `substrate create-account` creates a root Terraform module for you with providers configured to assume the appropriate role so you don't have to think about matching credentials in your environment with directories in which you invoke `terraform apply`. All you'll ever need to invoke Terraform are those Administrator you get from the Credential and Instance Factories.

## AWS console

The AWS Console includes a “switch role” feature that you're welcome to use but [accessing the AWS Console](https://github.com/src-bin/substrate-manual/blob/main/accessing-the-aws-console/README.md) shows that you probably won't need it. In your Substrate-managed AWS organization, access to the AWS Console feels less like switching roles and more like going straight into the account you need to access.
