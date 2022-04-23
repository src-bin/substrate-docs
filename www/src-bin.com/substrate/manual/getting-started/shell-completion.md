# Configuring Substrate shell completion

Substrate 2022.04 introduced shell completion. It is developed against Bash so any shell which supports Bash completion or includes a compatibility layer with Bash completion should be able to configure Substrate's shell completion.

Shell completion makes using Substrate interactively much more pleasant. We recommend adding the appropriate configuration to your `~/.profile` or equivalent.

## Bash

    complete -C "substrate --shell-completion" substrate

## Z shell

    autoload bashcompinit
    bashcompinit
    complete -C "substrate --shell-completion" substrate

<section class="table">
    <section id="previous">
        <p>Previous:<br><a href="../installing/">Installing Substrate and Terraform</a></p>
    </section>
    <section id="next">
        <p>Next:<br><a href="../bootstrapping/">Bootstrapping your Substrate-managed AWS organization</a></p>
    </section>
</section>
