# Telemetry in Substrate

Since 2022.03, Substrate asks if it may post telemetry to Source & Binary (and it remembers your answer). The data are used to better understand how Substrate is being used and how it can be improved.

The data collected were specifically chosen to avoid disclosing sensitive information about your organization and personally identifying information about you and your employees. Here is everything Substrate posts and how it's used:

* `Command` and `Subcommand`: The name of the Substrate tool being run, like `substrate assume-role` or `substrate-intranet` and `/accounts` (but never any custom resources added to the Intranet). These reveal how frequently each tool is used, which gives clues about people's workflows and how proactive versus reactive Substrate use is. Comparing to Substrate's release history reveals how quickly upgrades are undertaken.
* `Version`: The version of Substrate being used. This more directly reveals whether and how quickly upgrades are undertaken.
* `InitialAccountNumber` and `FinalAccountNumber`: The AWS account number(s) accessed by this command. In many cases, the two values are the same; they differ in commands like `substrate assume-role` which explicitly change from one account to another and `substrate bootstrap-*` that (potentially) switch from an admin account to one of the special accounts. AWS account numbers are not sensitive and their variety reveals how effectively people are using AWS accounts to promote security and reliability. Additionally, posting AWS account numbers keeps the names of your domains, environments, and qualities secret since they may be sensitive.
* `EmailDomainName`: The domain portion of the AWS accounts' email addresses (guaranteed to be the same for all Substrate-managed AWS accounts in an organization). This associates otherwise inscrutable AWS account numbers with a customer. Posting only the domain avoids disclosing domains, environments, and qualities from the local portion of the email address since they may be sensitive.
* `Prefix`: The contents of the `substrate.prefix` file that uniquely identifies your organization (but not any accounts, roles, or infrastructure within). This associates otherwise inscrutable AWS account numbers with a customer. Posting only this avoids disclosing domains, environments, and qualities and doesn't require valid AWS credentials.
* `InitialRoleName` and `FinalRoleName`: The AWS IAM role name(s) accessed by this command. In many cases, the two values are the same; they differ in commands like `substrate assume-role` which will try to assume any role you tell it to and `substrate bootstrap-*` that switch from a role like Administrator to OrganizationAdministrator, NetworkAdministrator, or DeployAdministrator (so named to make clear the special status of those accounts). Substrate will only ever post “Administrator”, “Auditor”, or “Other” to avoid disclosing the names of non-Substrate-managed AWS IAM roles.
* `IsEC2`: Boolean true if the Substrate command is being executed in EC2 (or another AWS service built on EC2 and exposing the Instance Metadata Service) or boolean false if not. This reveals the prevelance of remote and CI/CD workflows.
* `Format`: The `-format` flag, where applicable. This reveals a bit about how folks are integrating Substrate with other tools. (JSON? Shell environment variables?)

The Telemetry is posted to [https://src-bin.com/telemetry/](https://src-bin.com/telemetry/), an endpoint hosted in AWS and Honeycomb. If at any time you want to change whether your organization opts into or out of telemetry, change the contents of `substrate.telemetry` to “`no`” (that is, the word “no” followed by a newline) and commit the change.