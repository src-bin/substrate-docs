# Provision the demo service in production

_This section is a work in-progress and will be expanded._

With your service running as you intend in staging, the lion's share of your work is finished. That's the point, after all, isn't it? We're reusing `modules/demo` in its entirety so that it can be tested in staging in a way that inspires confidence.

Provisioning the service in production could be as simple as configuring the production domain name. But, for completeness' sake, we're going to go one step further in the name of reliability. We're going to provision the demo service twice, as beta-quality and gamma-quality in order to allow changes of any sort (truly - security groups, load balancers, etc.) to be implemented for 10% of traffic before bringing along the other 90%.

_TODO need to sanction the use of a DNS account for this demo_

In `root-modules/demo/production/gamma/main.tf`, add the following code:

    data "aws_route53_zone" "production" {
      name = "${local.domain_name}."
    }

    locals {
      domain_name    = "src-bin.com"
    }

    resource "aws_route53_record" "CNAME-demo-beta" {
      name           = "demo"
      records        = ["global.beta.demo.${data.aws_route53_zone.production.name}"]
      set_identifier = "beta"
      ttl            = 1
      type           = "CNAME"
      weighted_routing_policy {
        weight = 10
      }
      zone_id = data.aws_route53_zone.production.zone_id
    }

    resource "aws_route53_record" "CNAME-demo-gamma" {
      name           = "demo"
      records        = ["global.beta.demo.${data.aws_route53_zone.production.name}"]
      set_identifier = "gamma"
      ttl            = 1
      type           = "CNAME"
      weighted_routing_policy {
        weight = 90
      }
      zone_id = data.aws_route53_zone.production.zone_id
    }
