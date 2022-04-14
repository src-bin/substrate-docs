# Changing identity providers

Suppose when you began using Substrate you chose to use Google as your identity provider but now you've grown and decided to make the leap to Okta. Here's how to bring your access to the AWS Console and Substrate's Intranet along into this new future:

1. `rm -f substrate.oauth-oidc-client-id substrate.oauth-oidc-client-secret-timestamp`
2. Follow the [integrating your identity provider to control access to AWS](../getting-strated/integrating-your-identity-provider) section of the getting started guide
