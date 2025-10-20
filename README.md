# austinkeller's dotfiles

## nix

Package management is done using Nix via [Home Manager](https://nix-community.github.io/home-manager/).

TODO determine if nix-update-nixpkgs is behaving more reasonably than home-manager (e.g., maybe it's better to use the nix-update-nixpkgs script to update the nix-channel, after which `home-manager switch` will work?)

Any packages to be installed are declared in `home.nix`.

To install packages after adding/removing from the `home.nix` file, run:

```
home-manager switch
```

To update packages:

```
nix-update-nixpkgs
home-manager switch
```

Packages are updated by default to use the latest stable Darwin version. To use the latest available version, prefix the package names in `home.nix` with `unstable.`.

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

