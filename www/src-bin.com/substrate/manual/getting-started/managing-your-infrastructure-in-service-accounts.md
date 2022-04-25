# Managing your infrastructure in service accounts

With your identity provider integrated, you're now entering the choose-your-own adventure phase of adopting Substrate. You'll use service accounts to host the meat of your infrastructure &mdash; potentially lots of them.

Substrate helps you use multiple accounts to separate environments (like _development_ or _production_). Substrate also encourages you to organize your services into domains &mdash; single services or groups of tightly-coupled services &mdash; that help you reduce the blast radius of changes. You should read about [domains, environments, and qualities](../../domains-environments-qualities/) to get a feel for it.

You've probably got in mind the first thing you're going to build with Substrate's help, so next you can jump straight into [adding a domain](../../adding-a-domain/). Or just run a command like this:

<pre><code>substrate create-account -domain <em>domain</em> -environment <em>environment</em> -quality <em>quality</em></code></pre>

The environment and quality there should be a combination you defined way back when you ran `substrate bootstrap-network-account`. If it's not, no big deal: Just run `substrate bootstrap-network-account -fully-interactive` and change your answers. And, as with all Substrate commands, this one's safe to run over and over again; in fact, running it again is the quickest way to run all the Terraform code related to that service account.

After creating your first (or your fiftieth) service account, you'll be [writing Terraform code](../../writing-terraform-code/). Substrate doesn't change or restrict how you write Terraform code but it does introduce a few handy shortcuts you can use to name things sensibly and get access to the network it's configured for each of your environments.

The [Substrate manual](../../) has architectural reference material, day-to-day advice, runbooks for emergencies, and more.

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../deleting-unnecessary-root-access-keys/">Deleting unnecessary root access keys</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../../#working">Working in your Substrate-managed AWS organization</a></p>
    </section>
</section>
