# Substrate filesystem hierarchy

The directory in which you first run `substrate bootstrap-management-account` becomes the root of your Substrate repository. The tools will read and write many files in this directory tree, all of which should be committed to version control. (Substrate manages `.gitignore` files in certain subdirectories to keep your commits tidy.)

You can create a Git (or other version control) repository specifically for Substrate, add Substrate to the root of an existing repository, or add Substrate in a subdirectory of a new or existing repository. If you're already a Terraform user, we find it convenient for Substrate to be committed to the same repository in which you store your existing Terraform modules.

Many Substrate commands tolerate being run in subdirectories of your Substrate repository. If you want even greater freedom to run Substrate commands from anywhere, set `SUBSTRATE_ROOT` in your environment (permanently via your `~/.profile`, even) to the fully-qualified directory where you initially ran Substrate. All Substrate tools will change to this working directory if this environment variable is set.

The following index describes the contents and purpose of all the files the various Substrate tools create in your Substrate repository on your behalf.

- **`modules`**  
  A tree of Terraform modules, the ones listed below to support your network and admin accounts, one module for each domain you define, and all the modules you define to encapsulate your own code. Substrate-managed files include a header identifying them as such and declaring whether you may edit them.
    - **`common`**
        - **`global`**  
          A blank slate, where you can add global resources to all your service accounts. (Managed by `substrate create-account`.)
        - **`regional`** 
          A blank slate, where you can add regional resources to all your service accounts. (Managed by `substrate create-account`.)
    - **`deploy`**
        - **`global`**  
          A blank slate, where you can add global resources (e.g. IAM roles) to your deploy account. (Managed by `substrate bootstrap-deploy-account`.)
        - **`regional`**  
          A blank slate, where you can add regional resources (e.g. ECR repositories) to your deploy account. (Managed by `substrate bootstrap-deploy-account`.)
    - **`intranet`**  
      Your Intranet, which runs in your admin account, and serves the Credential and Instance Factories, the Accounts page used to access the AWS Console, and potentially more. (Managed by `substrate create-admin-account`.)
    - **`lambda-function`**  
      An abstraction used by `modules/intranet` and that you're free to use if it works for you. (Managed by `substrate create-admin-account`.)
    - **`peering-connection`**  
      An abstraction used by `root-modules/network/peering`. (Managed by `substrate create-admin-account`.)
    - **`substrate`**  
      A convenience for making domain, environment, and quality plus network configuration easy to access from your modules. (Managed by `substrate create-account` and `substrate create-admin-account`.)
    - **<code><em>domain</em></code>**
        - **`global`**
            - **`main.tf`**  
              A blank slate, where you can add your global Terraform resources. (Managed by `substrate create-account`.)
            - **`substrate.tf`**  
              A reference to `modules/substrate/global`, which makes `module.substrate.tags` work in this module. (Managed by `substrate create-account`.)
            - **`versions.tf`**  
              Configuration of Terraform and provider versions, etc. (Managed by `substrate create-account`.)
        - **`regional`**
            - **`main.tf`**  
              A blank slate, ready for you to add your regional Terraform resources. (Managed by `substrate create-account`.)
            - **`substrate.tf`**  
              A reference to `modules/substrate/regional`, which makes `module.substrate.tags`, `module.substrate.vpc_id`, etc. work in this module. (Managed by `substrate create-account`.)
            - **`versions.tf`**  
              Configuration of Terraform and provider versions, etc. (Managed by `substrate create-account`.)
- **`root-modules`**  
  A tree of Terraform root modules, each with a correctly configured state file stored in DynamoDB and S3. The tree is organized by domain, environment, quality, and region with some additional complexity for network peering arrangements. Substrate-managed files include a header identifying them as such and declaring whether you may edit them.
    - **`admin`**  
      Your admin account, especially a reference to `modules/intranet`. (Managed by `substrate create-admin-account`.)
    - **`deploy`**  
      Your deploy account, managing S3 buckets and also a good place to put e.g. AWS ECR resources. (Managed by `substrate bootstrap-deploy-account.)
    - **`network`**  
      Your network, where VPCs are defined before being shared. (Managed by `substrate bootstrap-network-account`.)
        - **`peering`**  
          VPC peering relationships between regions and qualities within the same environment. (Managed by `substrate bootstrap-network-account`.)
    - **<code><em>domain</em></code>**
        - **<code><em>environment</em></code>**
            - **<code><em>quality</em></code>**  
              Each of your domains has root Terraform modules in each environment, quality, and region which configure Terraform and refer to <code>modules/<em>domain</em></code>. (Managed by `substrate create-account`.)
                - **`global`**
                    - **`main.tf`**  
                      A reference to <code>modules/<em>domain</em>/global</code> plus a place to put global, non-environmental Terraform resources. (Managed by `substrate create-account`.)
                    - **`Makefile`**  
                      A convenience that allows running Terraform commands in this directory from another, like the more recently added `terraform -chdir` does. (Managed by `substrate create-account`.)
                    - **`providers.tf`**  
                      Terraform provider declarations. (Managed by `substrate create-account`.)
                    - **`terraform.tf`**  
                      S3- and DynamoDB-backed Terraform state file configuration. (Managed by `substrate create-account`.)
                    - **`versions.tf`**  
                      Configuration of Terraform and provider versions, etc. (Managed by `substrate create-account`.)
                - **<code><em>region</em></code>**
                    - **`main.tf`**  
                      A reference to <code>modules/<em>domain</em>/regional</code> plus a place to put regional, non-environmental Terraform resources. (Managed by `substrate create-account`.)
                    - **`Makefile`**  
                      A convenience that allows running Terraform commands in this directory from another, like the more recently added `terraform -chdir` does. (Managed by `substrate create-account`.)
                    - **`network.tf`**  
                      Sharing and tagging the correct VPC from the network account into this account.
                    - **`providers.tf`**  
                      Terraform provider declarations. (Managed by `substrate create-account`.)
                    - **`terraform.tf`**  
                      S3- and DynamoDB-backed Terraform state file configuration. (Managed by `substrate create-account`.)
                    - **`versions.tf`**  
                      Configuration of Terraform and provider versions, etc. (Managed by `substrate create-account`.)
- **`substrate.accounts.txt`**  
  A convenient listing of all your AWS accounts and the IAM roles to assume when you need to access them. (Managed by all the programs that potentially create AWS accounts.)
- **`substrate.admin-networks.json`**  
  Allocator for CIDR blocks used by VPCs and subnets for your admin accounts. (Managed by `substrate bootstrap-network-account`.)
- **`substrate.default-region`**  
  The AWS region where CloudTrail logs and other global resources are located. (Managed by `substrate bootstrap-management-account`.)
- **`substrate.environments`**  
  Logically ordered list of all your environments. (Managed by `substrate bootstrap-network-account`.)
- **`substrate.intranet-dns-domain-name`**  
  DNS domain name that's owned by, or at least hosted in, your admin account. (Managed by `substrate create-admin-account`.)
- **`substrate.networks.json`**  
  Allocator for CIDR blocks used by VPCs and subnets for your non-admin accounts. (Managed by `substrate bootstrap-network-account`.)
- **`substrate.oauth-oidc-client-id`**  
  OAuth OIDC client ID from your identity provider. (Managed by `substrate create-admin-account`.)
- **`substrate.oauth-oidc-client-secret-timestamp`**  
  Timestamp of the AWS Secrets Manager secret version that's storing the OAuth OIDC client secret from your identity provider. (Managed by `substrate create-admin-account`.)
- **`substrate.okta-hostname`**  
  Hostname of your Okta-hosted identity provider, if you're using Okta. (Managed by `substrate create-admin-account`.)
- **`substrate.nat-gateways`**  
  "yes" or "no" to indicate whether NAT Gateways will be provisioned with your private subnets. (Managed by `substrate bootstrap-network-account`.)
- **`substrate.prefix`**  
  Prefix to use for the names of global resources like S3 buckets. (Managed by `substrate bootstrap-management-account`.)
- **`substrate.qualities`**  
  Logically ordered list of all your qualities. (Managed by `substrate bootstrap-network-account`.)
- **`substrate.regions`**  
  List of AWS regions you're using. (Managed by `substrate bootstrap-network-account`.)
- **`substrate.saml-metadata.xml`**  
  Legacy configuration for a SAML integration that early Substrate installations have for getting into the AWS Console. (Not created for new installations.)
- **`substrate.telemetry`**  
  "yes" or "no" to indicate whether telemetry may be sent to Source &amp; Binary. (Managed by all Substrate tools.)
- **`substrate.valid-environment-quality-pairs.json`**  
  Pairings you've declared as valid. Used to avoid creating VPCs you'll never use to spare your service quotas. (Managed by `substrate bootstrap-network-account`.)
