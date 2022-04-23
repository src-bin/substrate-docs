# Integrating your original AWS account(s)

TODO review and update

Inviting your original AWS account(s), those you opened before adopting Substrate, into your new Substrate-managed AWS organization is a good idea for a few reasons:

- It can quickly improve your security posture if you create an `Administrator` role there that can be assumed by the `Administrator` role in your admin account(s), thus allowing you to delete long-lived access keys and uncontrolled IAM users there.
- It may simplify some migrations by allowing policies written using the `aws:PrincipalOrgID` condition key to interoperate with this account.
- Integrating access to its billing data will give you better visibility into the state of migration into Substrate-managed accounts.

To begin, you'll need root login credentials for the AWS Console for the account you wish to invite into your organization. When you're ready, proceed:

1. Open the AWS Console via your identity provider; assume the `Administrator` role
2. Assume the `OrganizationAdministrator` role in your management account via your Intranet's accounts page
3. Visit <https://console.aws.amazon.com/organizations/home?#/accounts>
4. Click **Add account**
5. Click **Invite account**
6. Enter the email address attached to the account you're inviting into your organization (or its account number, if you have that handy)
7. Click **Invite**
8. In an incognito window, sign into the AWS Console using your root credentials for the account you just invited into your organization
9. In that incognito window, visit <https://console.aws.amazon.com/cloudtrail/home#/dashboard> and delete any existing trails (to avoid very expensive surprises in your consolidated AWS bills)
10. In that incognito window, visit <https://console.aws.amazon.com/organizations/home#/invites>
11. Click **Accept**
12. Click **Confirm**

If you stop here, you'll have integrated billing data from your legacy account into your organization and you'll have the ability to constrain your legacy account using service control policies.

To allow your admin accounts to access this legacy account, proceed:

1. Note all the role ARNs in the table listing your admin accounts in `substrate.accounts.txt`
2. Create a new role named `Administrator` in your legacy account with the following assume role policy, substituting your admin account number for `ADMIN_ACCOUNT_NUMBER` (and adding additional elements to that list if you have multiple admin accounts):

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

3. Attach the managed `AdministratorAccess` policy to this new role

You can follow those steps in the AWS Console or implement this policy using your legacy account's CloudFormation or Terraform infrastructure. Once you've done so, reap the security benefits of disabling any long-lived access keys your legacy account's IAM users have.

After you've completed these steps, your legacy account is part of your Substrate-managed AWS organization. It's not presumed to be totally interoperable, though, so Substrate will not take any actions against it automatically.

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../bootstrapping/">Bootstrapping your Substrate-managed AWS organization</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../integrating-your-identity-provider/">Integrating your identity provider</a></p>
    </section>
</section>
