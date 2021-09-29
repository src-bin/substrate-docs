# Onboarding users

When new folks join your company they're probably going to need access to AWS. Here's a quick guide for granting it, depending on which IdP you use.

## Google Workspace

1. Visit [https://admin.google.com/ac/users](https://admin.google.com/ac/users) (or visit [https://admin.google.com](https://admin.google.com) and click **Users**)
2. Click on the name of a user who already has access to AWS
3. Click **User information**
4. Copy the value of _Role_ from the _AWS_ section
5. Go back to the list of users by clicking **Users** in the breadcrumbs or left-side menu
6. For each of your new folks:
    1. Click the user's name
    2. Click **User information**
    3. In the _AWS_ section, click **Add Role** and paste the string you copied in step 4 above
    4. In the _AWS_ section, click **Add SessionDuration** and enter &ldquo;43200&rdquo; (representing 12-hour maximum session duration in the AWS Console)
    5. Click **SAVE**

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
