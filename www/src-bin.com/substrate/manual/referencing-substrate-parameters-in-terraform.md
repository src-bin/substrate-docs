# Referencing Substrate parameters in Terraform

As you write your own Terraform modules, you're certainly going to want to parameterize them in the same ways Substrate helps you parameterize your AWS accounts. Plus, you're also going to need a network, and Substrate's already created and shared one with every account to make it easy, secure, and cost-effective to build new things.

`substrate-create-account` automatically creates a Terraform module for your domain and automatically references it from every environment and quality in that domain. This is generally the best place to put your Terraform code. Each domain module in turn instantiates the `substrate` module which includes some helpful context you're likely to need.

* `module.substrate.tags.domain`: The domain of this AWS account, from the tags on the account itself.
* `module.substrate.tags.environment`: The environment of this AWS account, from the tags on the account itself.
* `module.substrate.tags.quality`: The quality of this AWS account, from the tags on the account itself.
* `module.substrate.private_subnet_ids`: A _set_ of three private subnet IDs in this environment/quality's shared VPC.
* `module.substrate.public_subnet_ids`: A _set_ of three public subnet IDs in this environment/quality's shared VPC. (This set is empty in admin accounts.)
* `module.substrate.vpc_id`: The ID of this environment/quality's shared VPC.
