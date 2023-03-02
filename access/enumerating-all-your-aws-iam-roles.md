# Enumerating all your custom AWS IAM roles

Substrate can inspect your AWS organization and all your AWS accounts to provide a higher-level view of all your AWS IAM roles than simply iterating through AWS accounts and listing all the IAM roles that exist in each one. Substrate understands how IAM roles in different accounts are related to one another.

`substrate roles` is analogous to `substrate accounts`. It prints a textual representation of all the roles you've created with `substrate create-role`, the accounts in which they exist, the principals who may assume the roles, and the policies that are attached.

`substrate roles -format json` provides the same data in a format that you can process programmatically.

`substrate roles -format shell` provides the same data as an executable shell program, allowing you to implement something of a continuous integration workflow with IAM roles. This is especially handy if you're adding new AWS accounts because, for example, it will create any roles created with `-domain <example>` in new (and existing) AWS accounts that were created with `-domain <example>`.
