# Configuring Substrate shell completion

Substrate 2022.04 introduced shell completion. It is developed against Bash so any shell which supports Bash completion or includes a compatibility layer with Bash completion should be able to configure Substrate's shell completion.

Shell completion makes using Substrate interactively much more pleasant. We recommend adding the appropriate configuration to your `~/.profile` or equivalent.

## Bash

```
complete -C "substrate --shell-completion" substrate
```

## Z shell

```
autoload compinit
compinit
autoload bashcompinit
bashcompinit
complete -C "substrate --shell-completion" substrate
```
