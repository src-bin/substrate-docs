# Architecture within your Substrate-managed AWS organization

Very little about your use of AWS is constrained by Substrate. Beyond a few central assumptions, your choices are as endless as AWS makes them. This is a double-edged sword. Part of the value of Substrate is in helping Source & Binary's clients through the endless maze that must be navigated just to _start_ using AWS in a scalable manner. But as soon as Substrate gets in their way, its benefits become costs and it falls to the same "but what if I outgrow it?" fear that has so often doomed the likes of Heroku.

So Substrate stays modest in the constraints it imposes:

- It wants you to use AWS accounts to create separation between domains (services or collections of services) and between environments (data sets and the infrastructure that store and process them).
- It wants you to use shared VPCs (that it manages) to simplify network layout and minimize transit costs. (Note well, though, that this is not required. You're welcome to create more VPCs and wire them together with VPC Peering or even PrivateLink.)
- It wants you to be prepared to deploy to multiple regions even if you don't choose to do so immediately or at all times.
- It wants you to use Terraform to define the vast majority of your infrastructure and it wants you to organize your Terraform resources into global and regional modules to preserve your ability to run in multiple regions. See [global versus regional modules](/substrate/manual/global-vs-regional-modules/) for more information.

That leaves weighty choices like service architecture, storage and compute technologies, multi-tenancy, traffic routing, and more entirely up to you. These can still be overwhelming choices. Some advice follows.

## Domains: How many? How big?

Because it is so notoriously difficult to close an AWS account, you should define domains based on both how you want to isolate services from one another and how you organize your engineers. A domain per engineering organizational unit is a good default. Combine two potential domains into one to increase engineering velocity a bit. Split a service or collection of services into their own domain to increase isolation.

## Should a given tool be hosted in an admin account or another domain?

It's easy to put all Intranet tools into one basket but, if you look closely, they can typically be cleanly put into two smaller groups. Some tools are, for lack of a better word, devops tools; they're concerned with cluster management, deployment, and the like. Other tools are part of your product; they understand and interact with your data model and your services. You should put devops tools in your admin accounts and you should put product tools in the appropriate domain accounts.

If you like, you can expose them all via your Intranet DNS domain name, though you'll want to namespace product tool URLs with an environment e.g. [https://example.com/production/user/123](https://example.com/production/user/123).

Finally, you are likely to encounter many situations in which tools running in your admin accounts need to access either control plane services or EC2 instances in service accounts. To facilitate this, admin accounts are guaranteed to use networks in the 192.168.0.0/16 RFC 1918 address space, which means that security groups in your service accounts can feel free to allow access from 192.168.0.0/16 without any risk they're unknowingly allowing other service accounts a back door.

## Storage technologies

The particular storage technology you choose makes absolutely no difference but you should absolutely count on hosting many instances of your chosen storage technologies, with at least one in every domain account in every environment. Service-oriented architecture is (partially) about encapsulation, after all, and the services in a domain should absolutely be encapsulating their data.

## Compute technologies

As with storage technologies, your choice of compute technology is your own except that if you choose to use container orchestration frameworks like ECS or Kubernetes you should operate e.g. one cluster per AWS account. This ensures that the failure domain in case of cluster failure is the same as in case of application failure. ECS and Kubernetes users may be (rationally, justifiably) tempted to define slightly larger domains than they otherwise would in order to take advantage of some economies of scale by having larger clusters where more bin-packing efficiency can be had.

## Multi-tenancy

Most SaaS products embrace multi-tenancy as a necessary design point to enable freemium pricing. If you're not subject to such constraints, you could consider something as extreme as creating an environment for every customer. Slightly less extreme would be to create many qualities and host a subset of your customers in each one, further reducing the blast radius of changes by accounting for changes initiated by customers.

## DNS, load balancers, and accepting traffic from the Internet

It seems like Substrate should express an opinion on how DNS domains and load balancers are organized. The truth, though, is that these decisions are more tightly tied to how traffic enters your network than how that network is laid out.

If you have a single service that "fronts" all your other services then buying your DNS names and hosting your load balancers in domain accounts makes sense.

On the other hand, if you use a single load balancer to route traffic to many services spread across more than one domain then buying DNS domains and hosting the load balancer in a dedicated domain account or even the network account makes sense.

A practical matter is the buying of DNS domain names. Here's what we recommend:

1. Buy the DNS domain name using the Route 53 console in the appropriate AWS account for the domain, environment, and quality (e.g. buying [example-staging.com](http://example-staging.com) in a staging account)
2. Use a Terraform data source to refer to the hosted zone created when you buy the domain
3. Manage DNS records in Terraform as usual

## Considerations for shared VPCs

Relatively speaking, shared VPCs are new to AWS. As such, they come with some quirks.

The interaction between VPC endpoints and security groups in a shared VPC can be confusing. We've verified that creating both the VPC endpoint and its security group in your network account is the best path to follow.

## Serverless

If you want to go to the extreme, you can use Substrate in a purely serverless and even VPC-less environment by simply declining to run generated Terraform code in the network account. Doing so will restrict domain accounts to use of their global Terraform modules, which may be acceptable. Enabling this to work more smoothly to enable regional yet VPC-less infrastructures is a work in progress.

In the meantime, you can audit that you're not incurring charges from NAT Gateways serving private subnets you're not using with the following command:

    while read REGION; do substrate-assume-role -quiet -special="network" -role="Auditor" aws ec2 describe-nat-gateways --region="$REGION"; done <"substrate.regions"

## Secrets

Where to store your secrets? Regardless of your choice of AWS Secrets Manager, Hashicorp Vault, Square's Keywhiz, or something else, you'll need to decide which AWS accounts host these services.

I think the most important property of any secret management strategy is that it makes storing a secret the right way easier than storing one the wrong way i.e. committed alongside your source code. For my money, the solution with the lowest barrier to entry is AWS Secrets Manager in whatever account needs to access the secrets. This makes the requisite IAM policies straightforward to write, access relatively restricted, and adding new secrets as easy as I can imagine. (See the `aws-secrets-manager` tool bundled with Substrate for an example of how easy putting secrets into AWS Secrets Manager can be.)
