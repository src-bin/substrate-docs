# Adding non-administrator roles for humans

## Adding non-Administrator (and non-Auditor) roles for humans

_This feature is currently only supported when using Google as your identity provider._

In order to set the `RoleName` attribute on any of your users in your identity provider to any value except “Administrator” or “Auditor”, you'll need to define a role in your admin account and possibly some (or all) of your service accounts.

### In your admin account(s)

In a new file in `modules/intranet/global`, add code like this:

```
data "aws_iam_policy_document" "developer" {
  statement {
    actions = [
      "ec2:DescribeVpcs",                   # an example for demonstration purposes; could be anything, including wildcards
      "organizations:DescribeOrganization", # required to use Substrate command-line tools
      "sts:AssumeRole",                     # required to use Substrate command-line tools and the Intranet's Accounts page
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "developer-trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = [ # both are references to stanzas in main.tf
        data.aws_iam_user.credential-factory.arn,
        module.intranet.role_arn,
      ]
      type = "AWS"
    }
    principals {
      identifiers = ["ec2.amazonaws.com"] # for Instance Factory
      type        = "Service"
    }
  }
}

resource "aws_iam_instance_profile" "developer" {
  name = "Developer"
  role = aws_iam_role.developer.name
}

resource "aws_iam_policy" "developer" {
  name   = "Developer"
  policy = data.aws_iam_policy_document.developer.json
}

resource "aws_iam_role" "developer" {
  assume_role_policy   = data.aws_iam_policy_document.developer-trust.json
  max_session_duration = 43200
  name                 = "Developer"
}

resource "aws_iam_role_policy_attachment" "developer" {
  policy_arn = aws_iam_policy.developer.arn
  role       = aws_iam_role.developer.name
}
```

This role is called “Developer” but of course you can call yours whatever you like and have as many as you like.

Run `substrate create-admin-account -quality <quality>` to create this role, then update the `RoleName` attribute in your identity provider to assign it to whichever users you like.

## In your service accounts

In order for users assigned this role to assume roles in other AWS accounts, your service accounts, you'll need to create roles in those accounts, too, and authorize this role to assume them. You do this on each account individually.

In each service account, code like this in a new file in `modules/<domain>/global` or `root-modules/<domain>/<environment>/<quality>/global` will allow these new non-Administrator users to assume a role in that account:

```
data "aws_iam_policy_document" "developer" {
  statement {
    actions = [
      "ec2:DescribeVpcs",                   # an example for demonstration purposes; could be anything, including wildcards
      "organizations:DescribeOrganization", # required to use Substrate command-line tools
      "sts:AssumeRole",                     # required to use Substrate command-line tools
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "developer-trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = [
        # admin account number or
        # ARN of the role you created above
      ]
      type = "AWS"
    }
  }
}

resource "aws_iam_policy" "developer" {
  name   = "Developer"
  policy = data.aws_iam_policy_document.developer.json
}

resource "aws_iam_role" "developer" {
  assume_role_policy   = data.aws_iam_policy_document.developer-trust.json
  max_session_duration = 43200
  name                 = "Developer"
}

resource "aws_iam_role_policy_attachment" "developer" {
  policy_arn = aws_iam_policy.developer.arn
  role       = aws_iam_role.developer.name
}
```

Run `substrate create-account -domain <domain> -environment <environment> -quality <quality>` to create this role.

### In your identity provider

Visit [https://admin.google.com/ac/users](https://admin.google.com/ac/users) in a browser (or visit [https://admin.google.com](https://admin.google.com) and click **Users**) and modify the _RoleName_ attribute in the _AWS_ section for whomever you want to assume this new role.
