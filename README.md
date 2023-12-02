# austinkeller's dotfiles

## nix

Package management is done using Nix to provide a declarative, reproducible and consistent development environment. My setup is based on that of [checkoway](https://checkoway.net/musings/nix/).

Any packages to be installed are declared in `env.nix`.

To install packages:

```
nix-env -irf env.nix
```

To update packages:

```
nix-update-nixpkgs
```

## tmux

### Files

* .tmux.conf
* .ssh/config
* .ssh/rc

### Usage

Read .tmux.conf instructions for installing the tmux plugin manager (tpm) before using.

The .ssh/rc and .ssh/config files are needed for tmux to work properly with ssh-agent forwarding when reattaching tmux after reconnecting an ssh session.

## zsh

### Files

* .zshrc
* .p10k.zsh

### Usage

powelevel10k assumes that you have the [recommended fonts](https://github.com/romkatv/powerlevel10k#recommended-meslo-nerd-font-patched-for-powerlevel10k) installed.

  * Arch: [ttf-meslo-nerd-font-powerlevel10k](https://aur.archlinux.org/packages/ttf-meslo-nerd-font-powerlevel10k/).

## vim

### Files

* .vimrc

### Usage

When first run with this config file, vim will try to install the plugin manager Plug and then install all of the necessary plugins.

## Git

### Files

.gitconfig

# Archive dotfiles

These are for tools that I don't typically use, but can be helpful when my tools of choice aren't available for a system.

## screen

### Files

* .screenrc

### Usage

This is a windowing tool like tmux that is usually installed by default on linux systems.

