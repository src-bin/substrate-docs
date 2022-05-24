# Customizing EC2 instances from the Instance Factory

The Substrate-managed Instance Factory launches EC2 instances with the latest Amazon Linux 2 AMI by default. This is a good default. You should consider, if you're just getting started, always using Amazon Linux 2 as the base operating system for your EC2 instances. If you'd rather use Ubuntu or something else, however, that's perfectly reasonable and Substrate will help you do so. In fact, Substrate will help you customize EC2 instances from the Instance Factory however you see fit.

Define a launch template in your admin account(s) called `InstanceFactory-arm64` and another called `InstanceFactory-x86_64`. Specifically, define these Terraform resources in `modules/intranet/regional/launch-templates.tf` (or another new file in that directory). Configure all your customizations there. Substrate will choose the appropriate launch template based on the instance type users choose in the Instance Factory.

## Customizing via user data

If you define launch templates that does not include the `image_id` argument, Substrate will fill in the gap with its usual Amazon Linux 2 AMI. At first thought this might seem useless but it isn't &mdash; you can customize almost anything you can imagine by providing an executable program to the `user_data` argument to the launch template:

    resource "aws_launch_template" "instance-factory" {
      for_each = ["arm64", "x86_64"]

      name = "InstanceFactory-${each.value}"
      user_data = base64encode(<<EOF
    #!/bin/sh
    # TODO configure whatever you like
    EOF
      )
    }

This gives you enough to e.g. install custom software or configure an SSH CA. The sky's the limit!

## Customizing the AMI itself

If you define launch templates that _do_ include the `image_id` argument, Substrate (well, AWS) will dutifully launch instances from your AMI of choice. And beyond that you can still go wild with user data and other possibilities opened by using a launch template. Here's an example configuring the Instance Factory to use Ubuntu instead of Amazon Linux 2:

    data "aws_ami" "ubuntu" {
      for_each = toset(["arm64", "x86_64"])

      filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-${each.value == "x86_64" ? "amd64" : each.value}-server-*"]
      }
      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
      most_recent = true
      owners      = ["099720109477"] # Canonical
    }

    resource "aws_launch_template" "instance-factory" {
      for_each = toset(["arm64", "x86_64"])

      image_id = data.aws_ami.ubuntu[each.value].id
      name     = "InstanceFactory-${each.value}"
      user_data = base64encode(<<EOF
    #!/bin/sh
    # TODO configure whatever you like
    EOF
      )
    }
