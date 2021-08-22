# Enumerating all your AWS accounts

Substrate 2021.08 added `-format="json"` to `substrate-accounts` which makes it easier to programmatically enumerate all your AWS accounts. You might want to integrate Substrate into your CI/CD system, implement a monitoring function, or something else entirely. The JSON output includes account numbers, ARNs, and tags, which should be enough to parameterize almost anything you might want to do to most or all of your AWS accounts.

The rest of this page considers how to run the appropriate Substrate command against every AWS account in your organization.

The special accounts are singletons and thus don't need to be parameterized by the output of `substrate-accounts`:

    substrate-bootstrap-management-account

    substrate-bootstrap-network-account # possibly with -no-nat-gateways

    substrate-bootstrap-deploy-account

But admin accounts and service accounts need to be identified by quality (for admin accounts) or domain, environment, and quality (for service accounts). You can pass these parameters from the output of `substrate-accounts` to `substrate-create-admin-account` and `substrate-create-account` thus:

    substrate-accounts -format=json |
    jq -e -r '.[].Tags | select(.Domain == "admin") | "substrate-create-admin-account -quality=\(.Quality)"' |
    sh -e -x

    substrate-accounts -format=json |
    jq -e -r '.[].Tags | select(.Domain and .Domain != "admin") | "substrate-create-account -domain=\(.Domain) -environment=\(.Environment) -quality=\(.Quality)"' |
    sh -e -x


