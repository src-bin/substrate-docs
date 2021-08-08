# Global versus regional modules

Substrate generates a lot of Terraform code in modules with leaf directory names of `global` and `regional`. This is necessary because certain AWS services are global - IAM, notably - and thus their resources cannot be successfully managed from two AWS regions in two regional Terraform statefiles. Doing so will cause conflicts that generally aren't detected in Terraform plans but nonetheless fail when changes are applied. It's not simply a matter of importing resources, either, because every change will cause those imported copies to drift and require manual intervention.

Thus, we're stuck with `global` and `regional` modules. There are two situations in which Terraform resources should be placed in a `global` module:

1. The resource is one from a global AWS service like IAM or a pseudo-global service like Lambda@Edge (which may only be managed from us-east-1)
2. The resource, regardless of type, represents a global singleton resource in _your_ infrastructure e.g. a singular S3 bucket with a well-known name _and_ you're cool with it being managed from us-east-1

If you have global singleton resources that you want to exist in a region besides us-east-1, use `substrate-create-terraform-module` and then instantiate that module in <code>root-modules/<em>domain</em>/<em>environment</em>/<em>quality</em>/<em>region</em>/main.tf</code> as you see fit. If this singleton doesn't even need to be duplicated per environment, you can skip creating a module and instantiate the resource directly in some leaf subdirectory of `root-modules`, though beware that doing so gives up your ability to test changes to these resources.

It's common, once you've created resources in a `global` module, to need to reference these resources from regional modules. Use Terraform data sources to lookup these resource by their name, tags, or the like in the accompanying `regional` module.

Of course, with every rule there are exceptions. Sometimes it's not possible (or is significantly harder) to create a global resource without first knowing something about a regional resource. A typical example would be an IAM role used as a service account for EKS pods; the IAM role's trust policy needs to know the identity of the cluster and its OAuth OIDC provider before it can be written. In such cases, the correct practice is to namespace the global resource (e.g. the IAM role) with at least the AWS region in which it's being created and possibly also the name of the regional resource that forced it to be regional, too.
