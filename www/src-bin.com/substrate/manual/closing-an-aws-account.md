# Closing an AWS account

From time to time you may want to close an AWS account that you've created through Substrate or close a legacy account you invited into your organization and finished migrating into domain accounts. Either way, the process is unfortunately tedious.

Before you begin this process, note well that AWS enforces a waiting period of "a few days" (which they really do neglect to specify more precisely) between an account joining an organization, whether by invitation or creation, and that account leaving the organization. If you're met with this error (or you know you will be), do what it says and try again in a few days and possibly up to a full week.

1. Visit [https://console.aws.amazon.com](https://console.aws.amazon.com) in an incognito window
2. Leave &ldquo;Root user&rdquo; selected
3. Enter the email address of the account
    - If you're closing an account that `substrate-create-account` created, the email address is the same as you used for your management account with &ldquo;+_domain_-_environment_-_quality_&rdquo; appended to the local part
    - If you're closing an account that `substrate-create-admin-account` created, the email address is the same as you used for your management account with &ldquo;+admin-_quality_&rdquo; appended to the local part
    - If you're closing an account you invited into your organization, the email address is unchanged from what it was before it joined the organization
4. Click **Next**
5. Click **Forgot password?**
6. Respond to the captcha and click **Send email**
7. Open the link emailed to you in an incognito window
8. Reset the password and, after that's finished, click **Sign in**
9. Sign in using that same email address and the password you just set
10. Visit [https://console.aws.amazon.com/organizations/home?#/organization/overview](https://console.aws.amazon.com/organizations/home?#/organization/overview)
11. Click **Leave organization**
12. Confirm; click **Leave organization** again
13. Click **Complete the account sign-up steps**
14. Provide payment information
15. Verify your phone number
16. Select the free support plan
17. When returned to the AWS Organizations console, click **Leave organization** again and confirm
18. Click on the name of your account, the third option from the right in the top row of the console
19. Click **My Account**
20. Scroll to the bottom of the page
21. Read all four conditions and check all four checkboxes
22. Click **Close Account**
23. Confirm; click **Close Account**

## References

- [https://docs.aws.amazon.com/organizations/latest/userguide/orgs\_manage\_accounts\_close.html](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_close.html)
- [https://docs.aws.amazon.com/organizations/latest/userguide/orgs\_manage\_accounts\_access.html#orgs\_manage\_accounts\_access-as-root](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html#orgs_manage_accounts_access-as-root)
