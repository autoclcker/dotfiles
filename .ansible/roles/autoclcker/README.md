# Ansible Role: autoclcker

This role installs autoclcker' [dotfiles](https://github.com/autoclcker/dotfiles) on Linux hosts. Supported platforms are:

* Archlinux

## Requirements

- pip packages listed in [requirements.txt](requirements.txt).

## Role Variables

Available variables are listed below, along with default values (see [defaults](defaults/main.yml)):

```yaml
autoclcker_dotfiles_src: "../../../../../../dotfiles"
```
^^ dotfiles local directory. The source of truth.

```yaml
autoclcker_dotfiles_git: https://github.com/autoclcker/dotfiles.git
```
^^ dotfiles git repository. It is used as a fallback if **autoclcker_dotfiles_src** is not defined.

```yaml
autoclcker_dotfiles_dst: "/home/autoclcker"
```
^^ directory for installation.

## Dependencies

None

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: autoclcker
```

## License

MIT
