# Configuring Substrate shell completion

Substrate 2022.04 introduced shell completion. It is developed against Bash so any shell which supports Bash completion or includes a compatibility layer with Bash completion should be able to configure Substrate's shell completion.

Shell completion makes using Substrate interactively much more pleasant. We recommend adding the appropriate configuration to your `~/.profile` or equivalent.

## Bash

```shell
complete -C "substrate --shell-completion" substrate
```

## Fish
Create $HOME/.config/fish/completions/substrate.fish with the following contents:
```shell
function _fish_complete_substrate
    env COMP_LINE=(commandline -pc) substrate --shell-completion
end

complete -c substrate -f -a "(_fish_complete_substrate)"
```

## Z shell

```shell
autoload compinit
compinit
autoload bashcompinit
bashcompinit
complete -C "substrate --shell-completion" substrate
```
