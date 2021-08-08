# Your Substrate repository

The directory in which you run `substrate-bootstrap-management-account` becomes the root of your Substrate repository. This is the directory in which you're always expected to run Substrate commands because this is the directory where all its various files are stored.

We recommend here, and the tools recommend whenever they create files on your behalf, that all these files be committed to some form of version control. You are free to create a repository specifically for Substrate, to add Substrate to the root of an existing repository, or to add Substrate in a subdirectory of a new or existing repository. If you're already a Terraform user, we find it convenient for Substrate to be committed to the same repository in which you store existing Terraform modules.

The following index describes the contents and purpose of all the files the various Substrate tools create in your Substrate repository on your behalf.

- `modules`
    - `intranet`
    - `lambda-function`
    - `peering-connection`
    - `substrate`
- `root-modules`
    - `admin`
    - `deploy`
    - `network`
- `substrate.accounts.txt`  
  A convenient listing of all your AWS accounts and the IAM roles to assume when you need to access them.
- `substrate.admin-networks.json`  
  Allocator for CIDR blocks used by VPCs and subnets for your admin accounts.
- `substrate.default-region`
- `substrate.environments`  
  Logically ordered list of all your environments.
- `substrate.intranet-dns-domain-name`
- `substrate.networks.json`  
  Allocator for CIDR blocks used by VPCs and subnets for your non-admin accounts.
- `substrate.oauth-oidc-client-id`
- `substrate.oauth-oidc-client-secret-timestamp`
- `substrate.okta-hostname`
- `substrate.prefix`
- `substrate.qualities`  
  Logically ordered list of all your qualities.
- `substrate.regions`
- `substrate.saml-metadata.xml`
- `substrate.valid-environment-quality-pairs.json`  
  Pairings you've declared as valid. Used to avoid creating VPCs you'll never use to spare your service quotas.
