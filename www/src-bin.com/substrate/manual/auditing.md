# Auditing your Substrate-managed AWS organization

One of the very first things Substrate does is to configure AWS CloudTrail with a single trail that covers all organization accounts in all regions. To access this wealth of data, assume the `Auditor` role in your audit account.

On the command line: `substrate-assume-role -special="audit" -role="Auditor"`

Or you can assume the role in the AWS Console. The audit account number is listed in `substrate.accounts.txt` for use with the AWS Console's **Switch Role** feature.

In either case, the data you seek is in the `PREFIX-cloudtrail` (substituting your chosen prefix as stored in `substrate.prefix`) S3 bucket. You can download it to analyze locally or [query it with Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/cloudtrail-logs.html).

## Allowing third-parties to audit your Substrate-managed AWS organization

Many tools have grown the ability to assume an IAM role in your AWS account to perform some auditing or monitoring feature on your behalf. To allow these into your AWS organization, create an assume role policy in `substrate.Auditor.assume-role-policy.json` with contents like this:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": ["arn:aws:iam::ACCOUNT_NUMBER:role/ROLE_NAME"]
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }

You can include as many principals as you'd like and they can be IAM role ARNs (recommended) or AWS account numbers (as JSON strings).

Every time you update this file, you'll need to re-run whichever of `substrate-bootstrap-management-account`, `substrate-bootstrap-deploy-account`, `substrate-bootstrap-network-account`, `substrate-create-admin-account` (for each of your admin accounts), and/or `substrate-create-account` (for each of your service accounts) are relevant to your situation.

This will authorize third-party principals to `sts:AssumeRole` using the ARN of one of your Auditor roles and operate as you would there.
