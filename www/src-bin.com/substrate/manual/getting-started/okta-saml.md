# Okta SAML setup

1. Visit your Okta admin panel in a browser
2. Click **Get Started** in the menu bar (or visit `/admin/apps/add-app` on your Okta admin domain and skip to step 4)
3. Click **Add App**
4. Search for &ldquo;AWS Account Federation&rdquo;
5. Click **AWS Account Federation** in the search results
6. Click **Add**
7. Customize the _Application label_ if you please
8. Uncheck &ldquo;Automatically log in when user lands on login page&rdquo;
9. Click **Next**
10. Select &ldquo;SAML 2.0&rdquo;
11. Click **Identity Provider metadata**; keep the browser tab this opens handy
12. Run `substrate-create-admin-account -quality="..."`
13. Paste the Identity Provider metadata XML from your browser tab when prompted
14. The tool will offer an IAM role ARN and a SAML provider ARN
15. Paste the SAML provider ARN into _Identity Provider ARN_
16. Change _Session Duration_ to 43200 (optional)
17. Check &ldquo;Join all roles&rdquo; and &ldquo;Use Group Mapping&rdquo;
17. Click **Done**
18. Click **Provisioning**
19. Click **Configure API integration**
20. Check &ldquo;Enable API integration&rdquo;
21. Paste the access key ID and secret access key provided by `substrate-create-admin-account` as _Access Key_ and _Secret Key_
22. Click **Save**
23. In _Provisioning to App_ click **Edit**
24. Check &ldquo;Enable&rdquo; under both _Create Users_ and _Update User Attributes_
25. Click **Save**
26. Click **Assignments**
27. Click **Assign** and follow the prompts to grant your people access to AWS; check both the &ldquo;Administrator&rdquo; and &ldquo;Auditor&rdquo; roles for each
