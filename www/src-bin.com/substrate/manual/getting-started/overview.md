# Overview

Substrate helps you manage secure, reliable, and compliant cloud infrastructure in AWS. This part of the manual exists to guide you through installing Substrate and bootstrapping your Substrate-managed AWS organization.

## A warning about existing AWS organizations

Substrate expects to be able to create and configure AWS Organizations itself. Bootstrapping Substrate in an existing AWS organization is possible but requires more finesse than simply following this guide. If you have an existing AWS organization and want to adopt Substrate, please email <hello@src-bin.com> so we can work with you through your adoption.

## What to expect

Following this getting started guide start to finish usually takes an hour or two, depending on how many environments and regions you define right out of the gate. You're free to work in fits and starts with the comfort of knowing that every Substrate command can be killed and restarted without losing your place or causing any harm.

You're going to need administrative privileges in your identity provider (&ldquo;super admin&rdquo; in Google or at least the ability to configure new apps in Okta) in the sixth step. If you don't already have that it might be wise to seek that out now before it becomes a blocker.

Substrate's output will tell you what it's doing, what to commit to version control, and what to do next. If you're ever in doubt, get in touch in Slack or at <hello@src-bin.com>.

After you've completed this getting started guide you'll have a fully configured AWS organization integrated with your identity provider, access to AWS via your terminal and the AWS Console protected by your identity provider, a fully configured Terraform installation, and a head start delivering secure, reliable, and compliant cloud infrastructure in AWS.

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../../">Substrate manual</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../opening-a-fresh-aws-account/">Opening a fresh AWS account</a></p>
    </section>
</section>
