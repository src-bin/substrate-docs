# Installing Substrate and Terraform

Most steps in the getting started guide only need to be performed once. This step is the exception. Everyone who's going to be running Substrate commands, writing Terraform code, or really interacting with AWS in any but the most superficial ways, should follow these steps.

## Substrate

Substrate is distributed directly to customers. You'll have access to a feed of releases which includes links to download tarballs. Download the latest one for your platform. Then extract it by running a command like this from your downloads directory:

<pre><code>tar xf substrate-<em>version</em>-<em>commit</em>-<em>GOOS</em>-<em>GOARCH</em>.tar.gz -C ~/bin --strip-components 2 substrate-<em>version</em>-<em>commit</em>-<em>GOOS</em>-<em>GOARCH</em>/bin/substrate</code></pre>

Each released _version_ and _commit_ is offered in four binary formats; choose the appropriate one for your system. _`GOOS`_ is one of &ldquo;`darwin`&rdquo; or &ldquo;`linux`&rdquo; and _`GOARCH`_ is one of &ldquo;`amd64`&rdquo; or &ldquo;`arm64`&rdquo;.

You can install Substrate wherever you like. If `~/bin` doesn't suit you, just ensure the directory where you install it is on your `PATH`.

## Terraform

Substrate currently requires _exactly_ Terraform 1.2.3. (Substrate asks for Terraform to be upgraded every few releases to stay nearly current with Terraform.)

You can download [Terraform 1.2.3](https://releases.hashicorp.com/terraform/1.2.3/) from Hashicorp, with the filenames being parameterized with _`GOOS`_ and _`GOARCH`_ the same as Substrate itself. Download and `unzip` the appropriate build. Move `terraform` into a directory on your `PATH`. (It doesn't have to be the same directory where you placed `substrate`.)

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../opening-a-fresh-aws-account/">Opening a fresh AWS account</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../shell-completion/">Configuring Substrate shell completion</a></p>
    </section>
</section>
