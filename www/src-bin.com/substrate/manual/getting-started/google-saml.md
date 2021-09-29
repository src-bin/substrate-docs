# Google SAML setup

These steps must be completed by a Google Super Admin. Be mindful, too, of which Google account you're using if you're signed into more than one in the same browser profile. Google has a habit of switching accounts when you least expect it.

1. Visit [https://admin.google.com/ac/customschema](https://admin.google.com/ac/customschema) in a browser (or visit [https://admin.google.com](https://admin.google.com), click **Users**, click **More**, and click **Manage custom attributes**)
2. Click **ADD CUSTOM ATTRIBUTE**
3. Enter &ldquo;AWS&rdquo; for _Category_
4. Under _Custom fields_, enter &ldquo;Role&rdquo; for _Name_, select &ldquo;Text&rdquo; for _Info type_, select &ldquo;Visible to user and admin&rdquo; for _Visibility_, select &ldquo;Single Value&rdquo; for _No. of values_
5. In the new row that's appeared, enter &ldquo;SessionDuration&rdquo; for _Name_, select &ldquo;Whole Number&rdquo; for _Info type_, select &ldquo;Visible to user and admin&rdquo; for _Visibility_, select &ldquo;Single Value&rdquo; for _No. of values_
6. Click **ADD**
7. Visit [https://admin.google.com/ac/apps/unified](https://admin.google.com/ac/apps/unified) in the same browser (or visit [https://admin.google.com](https://admin.google.com), click **Apps**, and click **Web and mobile apps**)
8. Click **Add App** and select **Search for apps**
9. Enter &ldquo;Amazon Web Services&rdquo;
10. Click **Select** in the Amazon Web Services row
11. Take option 1 by clicking the **DOWNLOAD METADATA** button
12. In a terminal, run `substrate-create-admin-account -quality="..."`
13. Paste the contents of the IDP metadata XML file downloaded above when prompted
14. Back in your browser, click **CONTINUE** twice
15. Select &ldquo;Basic Information / Primary email&rdquo; under _Google Directory attributes_ in the first row, to the left of &ldquo;https://aws.amazon.com/SAML/Attributes/RoleSessionName&rdquo;
16. Select &ldquo;AWS / Role&rdquo; under _Google Directory attributes_ in the second row, to the left of &ldquo;https://aws.amazon.com/SAML/Attributes/Role&rdquo;
17. Click **ADD MAPPING**
18. In the new third row, select &ldquo;AWS / SessionDuration&rdquo; under _Google Directory attributes_ and enter &ldquo;https://aws.amazon.com/SAML/Attributes/SessionDuration&rdquo; under _App attributes_.
19. Click **FINISH**
20. Click **User access**
21. Select &ldquo;ON for everyone&rdquo; (noting that this doesn't actually grant anyone in your organization access to AWS on its own)
22. Click **SAVE**
23. Visit [https://admin.google.com/ac/users](https://admin.google.com/ac/users) in the same browser (or visit [https://admin.google.com](https://admin.google.com) and click **Users**)
24. For every user who needs AWS console access:
    1. Click the user's name
    2. Click **User information**
    3. In the _AWS_ section, click **Add Role** and paste the ARN of your Administrator role e.g. `arn:aws:iam::944106955638:role/Administrator,arn:aws:iam::944106955638:saml-provider/Google` but use your IAM role and SAML provider ARNs provided by `substrate-create-admin-account`
    4. In the _AWS_ section, click **Add SessionDuration** and enter &ldquo;43200&rdquo; (representing 12-hour maximum session duration in the AWS Console)
    5. Click **SAVE**
25. Back in your terminal, press enter to continue `substrate-create-admin-account`

Your authorized users can now access the AWS Console by finding _Amazon Web Services_ in the grid menu in the top right corner of any Google page.

## References

- Create and set custom attributes in Google: [https://support.google.com/a/answer/6208725?hl=en](https://support.google.com/a/answer/6208725?hl=en)
- SAML apps backed by Google: [https://support.google.com/a/answer/6194963?hl=en](https://support.google.com/a/answer/6194963?hl=en)
- Concerning the format of the custom attribute value for telling AWS what role to assume: [https://docs.aws.amazon.com/IAM/latest/UserGuide/id\_roles\_providers\_create\_saml\_assertions.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_saml_assertions.html)
