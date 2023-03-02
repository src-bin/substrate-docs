# Changing identity providers

Suppose when you began using Substrate you chose to use Google as your identity provider but now you've grown and decided to make the leap to Azure AD or Okta. Here's how to proceed:

1. `rm -f substrate.azure-ad-tenant substrate.oauth-oidc-client-id substrate.oauth-oidc-client-secret-timestamp substrate.okta-hostname`
2. Follow the [integrating your identity provider to control access to AWS](https://github.com/src-bin/substrate-manual/blob/main/getting-started/integrating-your-identity-provider/README.md) section of the getting started guide again
