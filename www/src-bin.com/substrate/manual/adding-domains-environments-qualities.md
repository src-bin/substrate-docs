# Adding domains, environments, and qualities

## Adding a domain

Domains are a mechanism for protecting one service (or group of services) from others. You may create as many as you like. Creating and subsequent updates are simple: Run `substrate-create-account -domain="..." -environment="..." -quality="..."` with the name of your (new) domain and a declared environment and quality. This will create a new AWS account in your organization, add it to `substrate.accounts.txt`, and create all the necessary IAM roles to allow administrators to access the account.

In almost every case, you'll create an account for every domain in every environment. Sometimes you may create accounts with multiple qualities to allow changes (even changes to AWS resources) to be deployed gradually within the domain.

## Adding an environment

Especially in the early build-out of your Substrate-managed AWS organization, you may need to add an environment (or two) to create space for a new data set, perhaps to support a new phase in your development process, a quality-assurance function, disaster recovery, or something else.

Environments primarily create separation amongst themselves at the network level. Thus environments are created by `substrate-bootstrap-network-account`. To create a new one (or two), simply respond as follows to its prompts:

1. Run `substrate-bootstrap-network-account`
2. Answer "no" when asked if your list of environments is correct
3. Add your new one in the text editor that was opened for you, paying attention to the order you want your environments presented
4. Save and exit the text editor
5. Optionally, do the same with with qualities
6. Answer "no" when asked if the valid environment and quality pairs are correct
7. Then answer "yes" and "no" accordingly to allow whatever new combinations of environment and quality you want and continue to disallow the rest
8. Unfortunately, if your changes cause sufficiently many VPCs to be created, the tools will open support cases on your behalf to have service quotas for VPCs and related resources raised
    - If AWS gives you a hard time it is likely because they don't want to give you additional Elastic IPs; tell them you're trying to create VPCs to share to all your AWS accounts with three private subnets and zonal NAT Gateways and they'll hopefully let you get on with your life but if they don't, feel free to escalate to Source & Binary
    - These support cases sometimes take hours or even days to be resolved
    - If the tool exits or is interrupted it may simply be re-run
    - You can say "no" to applying Terraform changes in certain root modules so as to e.g. avoid actually instantiating your network in some regions that you want to keep around only as cold standbys
9. When `substrate-bootstrap-network-account` exits successfully, your new environment is ready for use

## Adding a quality

Likewise, you may need to add a quality (or two) to reduce the blast radius of changes, especially changes to AWS resources like load balancers, auto scaling groups, and higher-level clusters.

Qualities provide a means to reduce the blast radius of changes within an environment and, just like environments themselves, operate primarily at the network level. Thus qualities, too, are created by `substrate-bootstrap-network-account`. To create a new one (or two), simply respond as follows to its prompts:

1. Run `substrate-bootstrap-network-account`
2. Answer "no" when asked if your list of qualities is correct
3. Add your new one in the text editor that was opened for you, paying attention to the order you want your qualities presented
    - Substrate's recommended qualities of alpha, beta, and gamma have the nice side-effect of being alphabetically ordered but it is the order they appear in `substrate.qualities` that really matters
4. Save and exit the text editor
5. Answer "no" when asked if the valid environment and quality pairs are correct
6. Then answer "yes" and "no" accordingly to allow whatever new combinations of environment and quality you want and continue to disallow the rest
7. Unfortunately, if your changes cause sufficiently many VPCs to be created, the tools will open support cases on your behalf to have service quotas for VPCs and related resources raised
    - If AWS gives you a hard time it is likely because they don't want to give you additional Elastic IPs; tell them you're trying to create VPCs to share to all your AWS accounts with three private subnets and zonal NAT Gateways and they'll hopefully let you get on with your life but if they don't, feel free to escalate to Source & Binary
    - These support cases sometimes take hours or even days to be resolved
    - If the tool exits or is interrupted it may simply be re-run
    - You can say "no" to applying Terraform changes in certain root modules so as to e.g. avoid actually instantiating your network in some regions that you want to keep around only as cold standbys
8. When `substrate-bootstrap-network-account` exits successfully, your new quality is ready for use
