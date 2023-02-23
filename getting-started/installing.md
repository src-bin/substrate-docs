# Installing Substrate and Terraform

Most steps in the getting started guide only need to be performed once. This step is the exception. Everyone who's going to be running Substrate commands, writing Terraform code, or really interacting with AWS in any but the most superficial ways, should follow these steps.

## Substrate

Substrate is distributed directly to customers. You'll have access to a feed of releases which includes links to download tarballs. Download the latest one for your platform. Then extract it by running a command like this from your downloads directory:

```shell-session
tar xf substrate-<version-commit>-<OS-ARCH>.tar.gz
```

This will create `substrate-<version>-<commit>-<OS>-<ARCH>`, which contains `bin/substrate` (typically all you need), `opt/bin/` with some optional extra programs that are part of the Substrate distribution, and `src/` with the complete source code for this release of Substrate.

To simply install Substrate in `~/bin` in a single command, run a command like this:

```shell-session
tar xf substrate-<version>-<commit>-<OS>-<ARCH>.tar.gz -C ~/bin --strip-components 2 substrate-version-commit-<OS>-<ARCH>/bin/substrate
```

Each released _version_ and _commit_ is offered in four binary formats; choose the appropriate one for your system. _`<OS>`_ is one of “`darwin`” or “`linux`” and _`<ARCH>`_ is one of “`amd64`” or “`arm64`”.

You can install Substrate wherever you like. If `~/bin` doesn't suit you, just ensure the directory where you install it is on your `PATH`.

## Terraform

Substrate currently requires _exactly_ Terraform 1.3.6. (Substrate asks for Terraform to be upgraded every few releases to stay nearly current with Terraform.)

The easist way to install Terraform 1.3.6 is to run `substrate terraform`. If the directory that contains `substrate` itself is writable, `terraform` will be placed there, too.

Alternatively, you can download [Terraform 1.3.6](https://releases.hashicorp.com/terraform/1.3.6/) from Hashicorp, with the filenames being parameterized with _`OS`_ and _`ARCH`_ the same as Substrate itself. Download and `unzip` the appropriate build. Move `terraform` into a directory on your `PATH`. (It doesn't have to be the same directory where you placed `substrate`.)
