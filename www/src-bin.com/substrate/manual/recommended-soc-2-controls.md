# Recommended SOC 2 controls

Most Substrate users are already or soon will be operating a SOC 2 compliance program. This page documents the many SOC 2 criteria that are at least partially addressed merely by adopting Substrate. In some cases, reference controls are provided that you're free to adopt verbatim.

CC2.1, CC4.1 use the Auditor role to enable infrastructure-level vulnerability scanning and penetration testing

CC2.2, CC2.3 system boundaries (and internal partitions) as AWS accounts, mapped in `substrate.accounts.txt`

CC2.2, CC7.3 TODO publish a sample incident response plan like J's

CC3.2 to the degree that changes are risky, Substrate helps to minimize the blast radius of changes in service (especially) of availability

CC4.1 AWS access is brokered entirely by the IdP, which reduces the number of places where access must be granted, revoked, and reviewed

CC5.1 multiple AWS accounts severely limit risks between domains, between environments, of over-permissioning, and of confused deputies

CC6.1 IdP and IAM roles, 2FA or temporary credentials, segmentation of networks and AWS accounts, TLS or SSH for everything

CC6.2, CC6.3 IdP and IAM roles

CC6.4 no physical access to AWS so scope's reduced to laptops, mobile phones, and offices

CC6.6 IdP brokers all access from the outside, encrypted by TLS and SSH, firewall defaults to closed

CC6.7 IdP brokers all access

CC6.8, CC7.1 Terraform code under version control and mandatory code review governs everything that runs in AWS

CC7.1 TODO is there a scanner we can cost-effectively enable by default?

CC7.2 CloudTrail TODO what alerts should we configure by default? (also note that they need their own monitoring for availability)

CC8.1 having multiple AWS accounts enables (safe) testing and controlled implementation of all kinds of changes, environments separate development, staging, production, etc.

CC9.1 infrastructure can be (somewhat) easily rebuilt in a different AWS region, Substrate makes active use of multiple regions a bit easier than otherwise

CC9.1 IdP disaster can be averted by using the management account and (optionally) configuring a different IdP

A1.1 elastic nature of almost all AWS products makes this trivial, minimizing active capacity management burdens

A1.2 multiple availability zones and/or regions

A1.3 native use of environments and multiple regions can streamline disaster recovery exercises

<h2 class="break">* * *</h2>

Feeling a bit like a deer in headlights about SOC 2 compliance? Take Source <span class="fancy">&amp;</span> Binary's [SOC 2 compliance workshop](/compliance/) and make SOC 2 a competitive advantage for your business. Email [hello@src-bin.com](mailto:hello@src-bin.com) to schedule yours.
