# Provision the demo service in staging

_This section is a work in-progress and will be expanded._

We're going to pick up where the [getting started](/substrate/manual/getting-started/) guide left your staging environment and provision a real service there.

Because AWS accounts are notoriously tedious to close, feel free to use a domain, environment, and quality that suit your organization instead of the placeholders used here.

Ensure the environment and quality you wish to use is a valid pair by re-running `substrate-bootstrap-network-account`. If you wish to follow the tutorial to the letter, allow _beta_-quality infrastructure in the _staging_ environment.

Run `substrate-create-account -domain="demo" -environment="staging" -quality="beta"` to (re)create the AWS account and generate the structure of the Terraform code.

For this tutorial we're going to use the DNS to route traffic but this could just as easily be done via your favorite edge load balancing and routing software.

Buy a domain name to use in staging or delegate a zone from a domain you already own. If you're buying a domain name, buy it using Route 53 Domains in your demo staging alpha account.

In `modules/demo/global/main.tf`, add the following code (substituting the domain names and regions you're using):

    locals {
      domain_name = module.substrate.tags.environment == "production" ? "src-bin.com" : "src-bin.org"
    }

    resource "aws_acm_certificate" "demo" {
      domain_name       = "demo.${local.domain_name}"
      validation_method = "DNS"
    }

    resource "aws_acm_certificate_validation" "demo" {
      certificate_arn         = aws_acm_certificate.demo.arn
      validation_record_fqdns = [for record in aws_route53_record.domain-validation : record.fqdn]
    }

    resource "aws_route53_record" "demo" {
      for_each = toset(["us-east-2", "us-west-2"])

      latency_routing_policy {
        region = each.key
      }
      name           = "global"
      records        = ["${each.key}.${aws_route53_zone.demo.name}"]
      set_identifier = each.key
      ttl            = 1
      type           = "CNAME"
      zone_id        = aws_route53_zone.demo.zone_id
    }

    resource "aws_route53_record" "domain-validation" {
      for_each = {
        for dvo in aws_acm_certificate.demo.domain_validation_options : dvo.domain_name => {
          name   = dvo.resource_record_name
          record = dvo.resource_record_value
          type   = dvo.resource_record_type
        }
      }

      name    = each.value.name
      records = [each.value.record]
      ttl     = 60
      type    = each.value.type
      zone_id = data.aws_route53_zone.demo.zone_id
    }

    resource "aws_route53_zone" "demo" {
      name = "${module.substrate.tags.quality}.demo.${local.domain_name}"
    }

In `modules/demo/regional/main.tf`, add the following code:

    data "aws_region" "current" {}

    data "aws_route53_zone" "demo" {
      name = "${module.substrate.tags.quality}.demo.${local.domain_name}"
    }

    locals {
      body        = <<EOF
    <!doctype HTML>
    <html lang="en">
    <head>
    <meta charset="utf-8">
    <title>Substrate Demo</title>
    </head>
    <body>
    <h1>Substrate Demo</h1>
    <dl>
    <dt>Domain</dt><dd>${module.substrate.tags.domain}</dd>
    <dt>Environment</dt><dd>${module.substrate.tags.environment}</dd>
    <dt>Quality</dt><dd>${module.substrate.tags.quality}</dd>
    <dt>Region</dt><dd>${data.aws_region.current.name}</dd>
    </dl>
    </body>
    </html>
    EOF
      domain_name = module.substrate.tags.environment == "production" ? "src-bin.com" : "src-bin.org"
    }

    resource "aws_acm_certificate" "demo" {
      domain_name       = "demo.${local.domain_name}"
      validation_method = "DNS"
    }

    resource "aws_acm_certificate_validation" "demo" {
      certificate_arn         = aws_acm_certificate.demo.arn
      validation_record_fqdns = [for record in aws_route53_record.demo : record.fqdn]
    }

    resource "aws_lb" "demo" {
      internal           = false
      load_balancer_type = "application"
      name               = "demo"
      security_groups    = [aws_security_group.demo-alb.id]
      subnets            = module.substrate.private_subnet_ids
    }

    resource "aws_lb_listener" "http" {
      default_action {
        fixed_response {
          content_type = "text/html"
          message_body = local.body
          status_code  = 200
        }
        type = "fixed-response"
      }
      load_balancer_arn = aws_lb.demo.arn
      port              = 80
      protocol          = "HTTP"
    }


    resource "aws_lb_listener" "https" {
      certificate_arn = aws_acm_certificate_validation.demo.certificate_arn
      default_action {
        fixed_response {
          content_type = "text/html"
          message_body = local.body
          status_code  = 200
        }
        type = "fixed-response"
      }
      load_balancer_arn = aws_lb.demo.arn
      port              = 443
      protocol          = "HTTPS"
      ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
    }

    resource "aws_route53_record" "demo" {
      alias {
        evaluate_target_health = false
        name                   = aws_lb.demo.dns_name
        zone_id                = aws_lb.demo.zone_id
      }
      name    = data.aws_region.current.name
      type    = "A"
      zone_id = data.aws_route53_zone.demo.zone_id
    }

    resource "aws_security_group" "demo-alb" {
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP"
        from_port   = 80
        protocol    = "tcp"
        to_port     = 80
      }
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS"
        from_port   = 443
        protocol    = "tcp"
        to_port     = 443
      }
      name   = "demo-alb"
      vpc_id = module.substrate.vpc_id
    }

In `root-modules/demo/staging/alpha/main.tf`, add the following code:

    data "aws_route53_zone" "staging" {
      name = "${local.domain_name}."
    }

    locals {
      domain_name    = "src-bin.org"
    }

    resource "aws_route53_record" "CNAME-demo-alpha" {
      name           = "demo"
      records        = ["global.alpha.demo.${data.aws_route53_zone.staging.name}"]
      set_identifier = "alpha"
      ttl            = 1
      type           = "CNAME"
      weighted_routing_policy {
        weight = 100
      }
      zone_id = data.aws_route53_zone.staging.zone_id
    }

Once more, run `substrate-create-account -domain="demo" -environment="staging" -quality="beta"`, this time to run all your Terraform code to create the DNS records, certificate, and ALB we just described.

Visit <https://demo.src-bin.org> (substituting your domain name (or not)) to see the fruits of your labor.

Iterate on this to your heart's content. Add EC2 auto-scaling groups, other compute resources, databases, or whatever else you need to support your service.

When you're happy with what you've built, move on to [provision the demo service in production](/substrate/manual/demo-service-in-production/).
