# AWS Support

You may wish to purchase an AWS Support plan for one or more of your AWS accounts. Doing so can get you access to phone support, more urgent SLAs, and more. AWS Support is annoyingly account-centric rather than organization-centric which makes it potentially a lot more expensive and much harder to purchase.

If you've decided one (or more) of your accounts need an AWS Support plan, here's how you purchase it (buckle up).

1. Visit [https://console.aws.amazon.com](https://console.aws.amazon.com) in an incognito window
2. Leave &ldquo;Root user&rdquo; selected
3. Enter the email address of the account
    - If you're purchasing for the management account, the email address is the one you used when you first signed up for AWS
    - If you're purchasing for an account that `substrate-create-account` created, the email address is the same as you used for your management account with &ldquo;+_domain_-_environment_-_quality_&rdquo; appended to the local part
    - If you're purchasing for an account that `substrate-create-admin-account` created, the email address is the same as you used for your management account with &ldquo;+admin-_quality_&rdquo; appended to the local part
    - If you're purchasing for an account you invited into your organization, the email address is unchanged from what it was before it joined the organization
4. Click **Next**
5. Click **Forgot password?**
6. Respond to the captcha and click **Send email**
7. Open the link emailed to you in an incognito window
8. Reset the password (change it to something truly outlandish and setup MFA in order to ensure the continuity of your organization's security) and, after that's finished, click **Sign in**
9. Sign in using that same email address and the password you just set
10. Visit [https://console.aws.amazon.com/support/plans/home](https://console.aws.amazon.com/support/plans/home)
11. Click **Change plan**
12. Select the plan you intend to purchase
13. Click **Change plan** again (or, if you're purchasing Enterprise Support, follow the flow to contact AWS as they're going to want to speak to you)
