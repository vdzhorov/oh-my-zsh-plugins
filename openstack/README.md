# openstack plugin

The `openstack` plugin adds aliases and helper functions for the
[OpenStack CLI](https://docs.openstack.org/python-openstackclient/latest/),
plus cached tab completion for the `openstack` command.

To use it, put this directory in `$ZSH_CUSTOM/plugins/openstack` (see the
[main README](../README.md#installation)) and add `openstack` to the plugins array of your zshrc file:

```zsh
plugins=(... openstack)
```

Or, once the directory is in place, enable it with:

```zsh
omz plugin enable openstack
```

## Functions

| Command                                  | Description                                                                 |
|:-----------------------------------------|:----------------------------------------------------------------------------|
| `openstack-version` / `osver`            | Show the installed OpenStack client version                                 |
| `openstack-cloud [name]` / `oscl`        | Set `OS_CLOUD` to `name`. With no argument, show the current cloud and the clouds found in `clouds.yaml` (has tab completion) |
| `openstack-env` / `osenv`                | Show all `OS_*` environment variables, with passwords, secrets and tokens masked |
| `openstack-unset` / `osunset`            | Unset all `OS_*` environment variables (e.g. after sourcing an openrc file) |
| `openstack-aliases` / `osalias`          | List all aliases provided by this plugin                                    |
| `openstack_prompt_info`                  | Print the current cloud (`OS_CLOUD`, or `OS_PROJECT_NAME`) for your prompt  |

`clouds.yaml` is read from the same places the client uses: `./clouds.yaml`,
`~/.config/openstack/clouds.yaml` and `/etc/openstack/clouds.yaml`.

## Aliases

| Alias     | Command                          |
|:----------|:---------------------------------|
| `os`      | `openstack`                      |
| `ostoken` | `openstack token issue`          |
| `oscat`   | `openstack catalog list`         |
| `osproj`  | `openstack project`              |
| `oss`     | `openstack server`               |
| `ossl`    | `openstack server list`          |
| `osss`    | `openstack server show`          |
| `osimg`   | `openstack image`                |
| `osimgl`  | `openstack image list`           |
| `osfl`    | `openstack flavor`               |
| `osfll`   | `openstack flavor list`          |
| `osnet`   | `openstack network`              |
| `osnetl`  | `openstack network list`         |
| `ossub`   | `openstack subnet`               |
| `osport`  | `openstack port`                 |
| `osrt`    | `openstack router`               |
| `osfip`   | `openstack floating ip`          |
| `ossg`    | `openstack security group`       |
| `ossgr`   | `openstack security group rule`  |
| `osvol`   | `openstack volume`               |
| `osvoll`  | `openstack volume list`          |
| `oskey`   | `openstack keypair`              |
| `osstack` | `openstack stack`                |
| `osq`     | `openstack quota show`           |

## Prompt

Add the current cloud to your prompt:

```zsh
RPROMPT='$(openstack_prompt_info)'
```

The default format is `<os:mycloud>`. Change it with:

```zsh
ZSH_THEME_OPENSTACK_PREFIX="%F{red}☁ "
ZSH_THEME_OPENSTACK_SUFFIX="%f"
```

## Completion

The output of `openstack complete --shell bash` is cached in `$ZSH_CACHE_DIR`. It takes a few
seconds to generate, so it is built in the background: completion works from the next shell
on, and it is rebuilt when the `openstack` binary is updated.
