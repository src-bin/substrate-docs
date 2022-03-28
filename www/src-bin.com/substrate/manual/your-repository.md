# Your Substrate repository

The directory in which you run `substrate-bootstrap-management-account` becomes the root of your Substrate repository. This is the directory in which you're always expected to run Substrate commands because this is the directory where all its various files are stored.

We recommend here, and the tools recommend whenever they create files on your behalf, that all these files be committed to some form of version control. You are free to create a repository specifically for Substrate, to add Substrate to the root of an existing repository, or to add Substrate in a subdirectory of a new or existing repository. If you're already a Terraform user, we find it convenient for Substrate to be committed to the same repository in which you store existing Terraform modules.

The following index describes the contents and purpose of all the files the various Substrate tools create in your Substrate repository on your behalf.

- `modules`  
  A tree of Terraform modules, the ones listed below to support your network and admin accounts, one module for each domain you define, and all the modules you define to encapsulate your own code.
    - `intranet`
    - `lambda-function`
    - `peering-connection`
    - `substrate`
- `root-modules`  
  A tree of Terraform root modules, each with a correctly configured state file stored in DynamoDB and S3. The tree is organized by domain, environment, quality, and region with some additional complexity for network peering arrangements.
    - `admin`
    - `deploy`
    - `network`
        - `peering`
- `substrate.accounts.txt`  
  A convenient listing of all your AWS accounts and the IAM roles to assume when you need to access them. (Managed by all the programs that potentially create AWS accounts.)
- `substrate.admin-networks.json`  
  Allocator for CIDR blocks used by VPCs and subnets for your admin accounts. (Managed by `substrate bootstrap-network-account`.)
- `substrate.default-region`  
  The AWS region where CloudTrail logs and other global resources are located. (Managed by `substrate bootstrap-management-account`.)
- `substrate.environments`  
  Logically ordered list of all your environments. (Managed by `substrate bootstrap-network-account`.)
- `substrate.intranet-dns-domain-name`  
  DNS domain name that's owned by, or at least hosted in, your admin account. (Managed by `substrate create-admin-account`.)
- `substrate.networks.json`  
  Allocator for CIDR blocks used by VPCs and subnets for your non-admin accounts. (Managed by `substrate bootstrap-network-account`.)
- `substrate.oauth-oidc-client-id`  
  OAuth OIDC client ID from your identity provider. (Managed by `substrate create-admin-account`.)
- `substrate.oauth-oidc-client-secret-timestamp`  
  Timestamp of the AWS Secrets Manager secret version that's storing the OAuth OIDC client secret from your identity provider. (Managed by `substrate create-admin-account`.)
- `substrate.okta-hostname`  
  Hostname of your Okta-hosted identity provider, if you're using Okta. (Managed by `substrate create-admin-account`.)
- `substrate.nat-gateways`  
  "yes" or "no" to indicate whether NAT Gateways will be provisioned with your private subnets. (Managed by `substrate bootstrap-network-account`.)
- `substrate.prefix`  
  Prefix to use for the names of global resources like S3 buckets. (Managed by `substrate bootstrap-management-account`.)
- `substrate.qualities`  
  Logically ordered list of all your qualities. (Managed by `substrate bootstrap-network-account`.)
- `substrate.regions`  
  List of AWS regions you're using. (Managed by `substrate bootstrap-network-account`.)
- `substrate.saml-metadata.xml`  
  Legacy configuration for a SAML integration that early Substrate installations have for getting into the AWS Console. (Not created for new installations.)
- `substrate.telemetry`  
  "yes" or "no" to indicate whether telemetry may be sent to Source &amp; Binary. (Managed by all Substrate tools.)
- `substrate.valid-environment-quality-pairs.json`  
  Pairings you've declared as valid. Used to avoid creating VPCs you'll never use to spare your service quotas. (Managed by `substrate bootstrap-network-account`.)
