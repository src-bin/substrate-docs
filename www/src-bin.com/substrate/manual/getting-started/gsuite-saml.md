# GSuite SAML setup

These steps must be completed by a GSuite Super Admin. Be mindful, too, of which GSuite account you're using if you're signed into more than one in the same browser profile. Google has a habit of switching accounts when you least expect it.

1. Visit [https://admin.google.com/ac/customschema](https://admin.google.com/ac/customschema) in a browser (or visit [https://admin.google.com](https://admin.google.com), click **Users**, click **More**, and click **Manage custom attributes**)
2. Click **ADD CUSTOM ATTRIBUTE**
3. Enter "AWS" for _Category_, enter "Role" for _Name_ under _Custom fields_, select "Text" for _Info type_, select "Visible to user and admin" for _Visibility_, select "Single Value" for _No. of values_
4. Click **ADD**
5. Click **ADD CUSTOM ATTRIBUTE**
6. Enter "AWS" for _Category_, enter "SessionDuration" for _Name_ under _Custom fields_, select "Whole Number" for _Info type_, select "Visible to user and admin" for _Visibility_, select "Single Value" for _No. of values_
7. Click **ADD**
8. Visit [https://admin.google.com/ac/apps/unified](https://admin.google.com/ac/apps/unified) in the same browser (or visit [https://admin.google.com](https://admin.google.com), click **Apps**, and click **SAML apps**)
9. Click **Add App** and select **Search for apps**
10. Enter "Amazon Web Services"
11. Click **Select** in the Amazon Web Services row
12. Take option 1 by clicking the **DOWNLOAD METADATA** button
13. In a terminal, run `substrate-create-admin-account -quality="..."`
14. Paste the contents of the IDP metadata XML file downloaded above when prompted
15. Back in your browser, click **CONTINUE** twice
16. Select "Basic Information / Primary email" under _Google Directory attributes_ in the first row, to the left of "https://aws.amazon.com/SAML/Attributes/RoleSessionName"
17. Select "AWS / Role" under _Google Directory attributes_ in the second row, to the left of "https://aws.amazon.com/SAML/Attributes/Role"
18. Click **ADD MAPPING**
19. In the new third row, select "AWS / SessionDuration" under _Google Directory attributes_ and enter "https://aws.amazon.com/SAML/Attributes/SessionDuration" under _App attributes_.
20. Click **FINISH**
21. Click **User access**
22. Select "ON for everyone" (noting that this doesn't actually grant anyone in your organization access to AWS on its own)
23. Click **SAVE**
24. Visit [https://admin.google.com/ac/users](https://admin.google.com/ac/users) in the same browser (or visit [https://admin.google.com](https://admin.google.com) and click **Users**)
25. For every user who needs AWS console access:
    1. Click the user's name
    2. Click **User information**
    3. In the _AWS_ section, click **Add Role** and paste the ARN of your Administrator role e.g. `arn:aws:iam::944106955638:role/Administrator,arn:aws:iam::944106955638:saml-provider/Google` but use your IAM role and SAML provider ARNs provided by `substrate-create-admin-account`
    4. In the _AWS_ section, click **Add SessionDuration** and enter "43200" (representing 12-hour maximum session duration in the AWS Console)
    5. Click **SAVE**
26. Back in your terminal, press enter to continue `substrate-create-admin-account`

Your authorized users can now access the AWS Console by finding _Amazon Web Services_ in the grid menu in the top right corner of any Google page.

## References

- Create and set custom attributes in GSuite: [https://support.google.com/a/answer/6208725?hl=en](https://support.google.com/a/answer/6208725?hl=en)
- SAML apps backed by GSuite: [https://support.google.com/a/answer/6194963?hl=en](https://support.google.com/a/answer/6194963?hl=en)
- Concerning the format of the custom attribute value for telling AWS what role to assume: [https://docs.aws.amazon.com/IAM/latest/UserGuide/id\_roles\_providers\_create\_saml\_assertions.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_saml_assertions.html)
