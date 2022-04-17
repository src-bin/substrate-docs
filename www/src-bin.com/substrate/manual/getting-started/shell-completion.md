# Configuring Substrate shell completion

Substrate 2022.04 introduced shell completion. It is developed against Bash so any shell which supports Bash completion or includes a compatibility layer with Bash completion should be able to configure Substrate's shell completion.

## Bash

    complete -C "substrate --shell-completion" substrate

## Z shell

    autoload bashcompinit
    bashcompinit
    complete -C "substrate --shell-completion" substrate
