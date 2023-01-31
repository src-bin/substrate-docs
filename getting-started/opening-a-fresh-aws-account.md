# Opening a fresh AWS account

Substrate manages secure, reliable, and compliant cloud infrastructure in AWS. It's only natural, then, that you need an AWS account to start using Substrate. In fact, in service of all of those goals, Substrate manages many AWS accounts via AWS Organizations. But it has to start with one.

Most customers adopt Substrate after they have opened one AWS account and started prototyping. We're going to leave that original account (or accounts, if there are more) alone at first, because the first account, called the management account, is ideally completely empty save for the several other AWS accounts it controls via AWS Organizations.

After a lot of trials, we can confidently say that it is best practice for the email address you use to open your management account — the AWS account you're about to open — should be an alias, group, or list so that it can easily be shared amongst a few of people and outlast any individual employee's tenure. If you're using Google Groups, you must adjust the group's permissions to allow _External_ users to _Publish posts_.

Visit [https://portal.aws.amazon.com/billing/signup#/start](https://portal.aws.amazon.com/billing/signup#/start) to begin. Follow the steps to open a new account, provide payment information, and verify your phone number.

You should setup multi-factor authentication for the root of this new account immediately:

1. Visit [https://console.aws.amazon.com/iam/home#/security\_credentials](https://console.aws.amazon.com/iam/home#/security\_credentials)
2. Open the _Multi-factor authentication (MFA)_ section
3. Click **Activate MFA**
4. Select “Virtual MFA device”
5. Click **Continue**
6. Take a screenshot of the QR code (don't fret, we'll delete it shortly)
7. Scan the QR code in Google Authenticator or your favorite TOTP app
8. Enter the next two six-digit codes the app generates
9. Click **Assign MFA**

For business continuity, you should ensure one or two other people can login to this account. Add them to the email distribution, securely share the password with them, and either send them the QR code or allow them to scan it from your screen. Backup that QR code because without either that or control of the phone number that originally opened the account, you will be unable to login.
