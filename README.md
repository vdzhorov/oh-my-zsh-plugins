# oh-my-zsh-plugins

Oh My ZSH Plugins

| Plugin                    | Description                                    |
|:--------------------------|:-----------------------------------------------|
| [openstack](openstack/)   | Aliases, cloud switching and completion for the OpenStack CLI |

## Installation

Clone the repo and link the plugins you want into your oh-my-zsh custom plugins directory:

```zsh
git clone https://github.com/vdzhorov/oh-my-zsh-plugins.git ~/oh-my-zsh-plugins
ln -s ~/oh-my-zsh-plugins/openstack ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/openstack
```

Then add the plugin to the plugins array in `~/.zshrc`:

```zsh
plugins=(... openstack)
```

or let oh-my-zsh add it for you:

```zsh
omz plugin enable openstack
```
