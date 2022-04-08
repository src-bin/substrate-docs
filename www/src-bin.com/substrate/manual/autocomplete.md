# Autocomplete for Substrate commands

## Bash

    complete -C "substrate --shell-completion" substrate

## Z shell

    autoload bashcompinit
    bashcompinit
    complete -C "substrate --shell-completion" substrate
