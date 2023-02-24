# Onboarding users

When new folks join your company they're probably going to need access to AWS. Here's a quick guide for granting it, depending on which identity provider you use.

After you've added folks to the identity provider per your usual onboarding process for all employees, do the following for each user who needs access to AWS.

## Google Workspace

1. Visit [https://admin.google.com/ac/users](https://admin.google.com/ac/users) (or visit [https://admin.google.com](https://admin.google.com) and click **Users**)
2. Click the user's name
3. Click **User information**
4. In the _AWS_ section, click **Add RoleName** and paste the name (not the ARN) of the IAM role they should assume in your admin account (if it's not “Administrator” or “Auditor”, ensure you've followed [adding non-Administrator roles for humans](https://github.com/src-bin/substrate-manual/blob/main/adding-non-administrator-roles-for-humans/README.md) first)
5. Click **SAVE**

## Okta

1. Open the configuration screen for your “Intranet” app
2. Click the **Assignments** tab
3. Click **Assign** and then **Assign to People**
4. Select your new folks
5. Click **Assign**
