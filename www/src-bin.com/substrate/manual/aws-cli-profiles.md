# Using AWS CLI profiles

The AWS CLI is deceptively powerful and ubiquitous but can be tough to configure in a multi-account organization and the most obvious way to configure it &mdash; using an access key ID and secret access key &mdash; is far and away the most risky.

Fortunately, there are two less-well-known configurations that can help you address both: Profiles and the `credential_process` directive.

Define one or more profiles in `~/.aws/config`, naming them whatever you like, that defer credential management to Substrate via `substrate assume-role`:

<pre><code>[profile <em>whatever-you-want-to-call-it</em>]
credential_process = substrate assume-role -format json -quiet -domain <em>domain</em> -environment <em>environment</em> -quality <em>quality</em></code></pre>

Note well that, in order for this to succeed, you'll need to have already run `eval $(substrate credentials)` to prime the environment to have any access to AWS at all.

Use your profile thus:

<pre><code>eval $(substrate credentials)
aws sts get-caller-identity --profile <em>whatever-you-want-to-call-it</em></code></pre>

Or, if you so choose, use [Granted](https://granted.dev/) to navigate the profiles you configure in `~/.aws/config`.

A downside of using profiles is that they're not shared amongst you and your teammates the way domains, environments, and qualities are but they can save a bit of typing and you will arrive at the same point so use whichever tool suits you in every situation &mdash; there's no need to commit to one exclusively.
