# Additional Terraform providers

Terraform 0.15 migrated from stub `provider { alias = "..." }` blocks to using `configuration_aliases` in the `terraform` block to define which providers a module expects. Unfortunately, this introduces a limitation in that additional providers cannot be added in arbitrary additional files.

Substrate since 2021.07 deals with this limitation by managing only the version constraints for the `archive`, `aws`, and `external` providers and leaving other providers alone.

In order to add a new provider, add it to `versions.tf` with a version constraint that suits you:

<pre>terraform {
  required_providers {
    aws = {
      configuration_aliases = [
        aws.network,
      ]
      source  = "hashicorp/aws"
      version = ">= 3.45.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.1.0"
    }
    <strong>pagerduty = {
      source = "PagerDuty/pagerduty"
      version = "= 1.9.9"
    }</strong>
  }
  required_version = "= 1.2.3"
}</pre>

Then add a `provider` block to the root modules that need to use this provider and pass it to your module via its `providers` attribute:

<pre>module "example" {
  <strong>providers = {
    aws         = aws
    aws.network = aws
    pagerduty   = pagerduty
  }</strong>
  source = "../../../../../modules/example/regional"
}

<strong>provider "pagerduty" {
  token = var.pagerduty_token
}</strong></pre>
