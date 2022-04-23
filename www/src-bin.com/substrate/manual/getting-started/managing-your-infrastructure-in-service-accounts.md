# Managing your infrastructure in service accounts

TODO this file is terrible

## Building your staging environment

If you're like most modern teams, the vast majority of your development work is happening on folks' laptops. Thus, it probably makes the most sense for the first cloud infrastructure to be something more like a staging environment for a service which demands high reliability.

### <code>substrate create-account -domain <em>domain</em> -environment <em>environment</em> -quality <em>quality</em></code>

This is the first of probably many accounts that'll be created in your organization. This command creates an empty root Terraform module that's ready to hold whatever you need it to. Here, for the first time, you're being asked to name a domain, as well as an environment and quality. A domain is a collection of one or more applications/services, often owned by the same group of people, that run in an AWS account of their own to protect them from changes in other domains.

When this program exits, you should commit the generated files to version control as instructed. It is safe to re-run this program at any time.

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../integrating-your-identity-provider/">Integrating your identity provider</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../../#working">Working in your Substrate-managed AWS organization</a></p>
    </section>
</section>
