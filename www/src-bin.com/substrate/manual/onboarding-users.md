# Onboarding users

When new folks join your company they're probably going to need access to AWS. Here's a quick guide for granting it, depending on which IdP you use.

## Google Workspace

1. Visit [https://admin.google.com/ac/users](https://admin.google.com/ac/users) (or visit [https://admin.google.com](https://admin.google.com) and click **Users**)
2. For each of your new folks:
    1. Click the user's name
    2. Click **User information**
    3. In the _AWS_ section, click **Add RoleName** and paste the name (not the ARN) of the IAM role they should assume in your admin account (most likely, &ldquo;Administrator&rdquo;)
    4. Click **SAVE**

## Okta

1. Add the new folks to Okta per your usual onboarding process
2. Open the configuration screen for your &ldquo;AWS Account Federation&rdquo; app
3. Click **Assign** and then **Assign to People**
4. Select your new folks
5. Click **Next**
6. For each one, choose the AWS IAM role(s) they're allowed to assume
7. Click **Assign**
8. Open the configuration screen for your &ldquo;Intranet&rdquo; app
9. Click the **Assignments** tab
10. Click **Assign** and then **Assign to People**
11. Select your new folks
12. Click **Assign**
