# Auditing your Substrate-managed AWS organization

One of the very first things Substrate does is to configure AWS CloudTrail with a single trail that covers all organization accounts in all regions. To access this wealth of data, assume the `Auditor` role in your audit account.

On the command line: `substrate-assume-role -special="audit" -role="Auditor"`

Or you can assume the role in the AWS Console. The audit account number is listed in `substrate.accounts.txt` for use with the AWS Console's **Switch Role** feature.

In either case, the data you seek is in the `PREFIX-cloudtrail` (substituting your chosen prefix as stored in `substrate.prefix`) S3 bucket. You can download it to analyze locally or [query it with Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/cloudtrail-logs.html).
