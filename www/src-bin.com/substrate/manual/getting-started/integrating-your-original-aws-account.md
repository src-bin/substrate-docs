# Integrating your original AWS account(s)

Most likely, you've already opened (at least) one AWS account(s), and you're probably a little apprehensive about what will happen to it once you adopt Substrate. Let's address the two most common concerns right away:

1. Don't worry, you won't be left maintaining two AWS worlds forever.
2. Yes, you'll be able to keep your AWS credit balance.

In fact, integrating your original AWS account(s) into your new Substrate-managed AWS organization is a good idea for a few reasons:

- It can quickly improve your security posture if you create an Administrator role there that can be assumed by the Administrator role in your admin account(s), thus allowing you to delete long-lived access keys and uncontrolled IAM users there.
- It may simplify some migrations by allowing policies written using the `aws:PrincipalOrgID` condition key to interoperate with this account. (Don't worry if policies and condition keys are not familiar topics.)
- Integrating access to its billing data will give you better visibility into where you're spending money with AWS.

You can invite as many AWS accounts as you like into your new Substrate-managed AWS organization but only if you have _not_ configured AWS Organizations manually in those accounts. If you have and you would still like to adopt Substrate, ask us at <hello@src-bin.com> and we'll work with you to make everything right.

To begin, you'll need root (not IAM user) login credentials for the AWS Console for the account you wish to invite into your organization. If you don't have them now or you just don't want to do this now, feel free to skip this section and combe back to it later. When you're ready, proceed:

1. Open the Accounts page of your Intranet
2. Assume the OrganizationAdministrator role in your management account
3. Visit <https://console.aws.amazon.com/organizations/home?#/accounts>
4. Click **Add account**
5. Click **Invite account**
6. Enter the email address of your original AWS account, the one that you're inviting into your organization (or its account number, if you have that handy)
7. Click **Invite**
8. In an incognito window, sign into the AWS Console using root (not IAM user) credentials for the account you just invited into your organization
9. In that incognito window, visit <https://console.aws.amazon.com/cloudtrail/home#/dashboard> and delete any existing trails (to avoid very expensive surprises in your consolidated AWS bills)
10. In that incognito window, visit <https://console.aws.amazon.com/organizations/home#/invites>
11. Click **Accept**
12. Click **Confirm**

If you stop here, you'll have integrated billing data from your original AWS account into your organization and you'll have the ability to constrain your original AWS account using service control policies.

To allow your admin accounts to access this original AWS account, proceed as follows, either in the AWS Console or using whatever configuration management tooling you use in your original AWS account:

1. Note all the role ARNs in the table listing your admin accounts in `substrate.accounts.txt`
2. Create a new role named Administrator in your original AWS account with the following assume role policy, substituting your admin account number for `ADMIN_ACCOUNT_NUMBER` (and adding additional elements to that list if you have multiple admin accounts):

        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "AWS": [
                  "arn:aws:iam::ADMIN_ACCOUNT_NUMBER:role/Administrator",
                  "arn:aws:iam::ADMIN_ACCOUNT_NUMBER:role/Intranet"
                ]
              },
              "Action": "sts:AssumeRole"
            }
          ]
        }

3. Attach the managed AdministratorAccess policy to this new role

You can follow those steps in the AWS Console or implement this policy using your original AWS account's CloudFormation or Terraform infrastructure. Once you've done so, reap the security benefits of disabling any long-lived access keys your original AWS account's IAM users have.

After you've completed these steps, your original AWS account is part of your Substrate-managed AWS organization. It's not presumed to be totally interoperable, though, so Substrate will not take any actions against it automatically. You'll be able to assume roles in it using <code>substrate assume-role -number <em>12-digit-account-number</em></code>, though, which is enough for most folks to realize the security benefits of Substrate by removing all their IAM users and long-lived AWS access keys.

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../deleting-unnecessary-root-access-keys/">Deleting unnecessary root access keys</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../managing-your-infrastructure-in-service-accounts/">Managing your infrastructure in service accounts</a></p>
    </section>
</section>
