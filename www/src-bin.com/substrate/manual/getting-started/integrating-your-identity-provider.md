# Integrating your identity provider to control access to AWS

Substrate uses an OAuth OIDC identity provider to broker all your human access to AWS. Substrate supports [Google Workspace](https://workspace.google.com) and [Okta](https://www.okta.com). You almost certainly already have one but, on the off chance you don't: Which one should you choose?

Your organization probably already uses Google to host your mail and calendars. Why not use it to broker access to the AWS Console and your Intranet? It's perfectly capable. You'll find, however, that Okta's strength is in scale. In Google Workspace, each user that's granted access to AWS must have a role assigned specifically to them. Okta's integration with AWS IAM roles is much better when you're managing even dozens of users.

Feel free to try them both. Whichever you choose, take comfort in knowing your decision isn't permanent. [Changing identity providers](../../changing-identity-providers/) documents how to move from one to another.

The next section, whichever identity provider you choose, you'll run <code>substrate create-admin-account -quality <em>quality</em></code> and the documentation will help you respond to its prompts.

One of those prompts concerns purchasing or transferring a DNS domain name or delegating a DNS zone from elsewhere into this new account. If you're at a loss for inspiration, consider using your company's name with the `.company` or `.tools` TLD. Avoid overloading any domain you use for public-facing web services, especially those that set cookies, to reduce the impact of e.g. CSRF or XSS vulnerabilities. **Be sure to respond to the emails sent by Route 53 (which Google often flags as suspicious) to avoid your domain being suspended in a few days.** This is the domain where Substrate will arrange to serve your Credential Factory for minting temporary AWS credentials, your Instance Factory for launching personal EC2 instances, your account listing which also gets you into the AWS Console, and any tools you choose to add to your Intranet later.

<!--TODO It is also safe to have multiple admin accounts of various qualities.-->

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../bootstrapping/">Bootstrapping your Substrate-managed AWS organization</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../integrating-your-google-identity-provider/">Integrating your Google identity provider</a><br>or<br><a href="../integrating-your-okta-identity-provider/">Integrating your Okta identity provider</a></p>
    </section>
</section>
