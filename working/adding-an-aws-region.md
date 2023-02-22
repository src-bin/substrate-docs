# Adding an AWS region

Substrate is designed to accommodate multi-region infrastructures from day one and is ready at a moment's notice if you start with one region but decide suddenly to add more.

As a prerequisite to adding a new region, it's critical that you follow the advice on [global and regional Terraform modules](https://github.com/src-bin/substrate-manual/blob/main/global-and-regional-terraform-modules/README.md) so that additional regional modules don't introduce conflicts during your Terraform runs.

Regions are added by `substrate bootstrap-network-account`. To add a new one (or two), simply respond as follows to its prompts:

1. Run `substrate bootstrap-network-account -fully-interactive`
2. Answer “no” when asked if your list of regions is correct
3. Add your new one in the text editor that was opened for you, paying attention to the order you want your qualities presented
4. Save and exit the text editor
5. If your changes cause sufficiently many VPCs to be created, the tools will open support cases on your behalf to have service quotas for VPCs and related resources raised
   * If AWS gives you a hard time it is likely because they don't want to give you additional Elastic IPs; tell them you're trying to create VPCs to share to all your AWS accounts with three private subnets and zonal NAT Gateways and they'll hopefully let you get on with your life but if they don't, feel free to escalate to Source & Binary
   * These support cases sometimes take hours or even days to be resolved
   * If the tool exits or is interrupted it may simply be re-run
6. When `substrate bootstrap-network-account` exits successfully, your network is ready for use in the added region(s)
7. Run `substrate bootstrap-deploy-account`
8. Run `substrate create-admin-account` for all your admin accounts
9. Run `substrate create-account` for all your domain, environment, quality accounts
