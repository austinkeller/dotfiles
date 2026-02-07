# austinkeller's dotfiles

## Nix

Package management is done using [Determinate Nix](https://determinate.systems/nix/) with [Home Manager](https://nix-community.github.io/home-manager/) via flakes.

### Installation

1. Install Determinate Nix:
   ```
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. Clone this repo and run the install script:
   ```
   git clone https://github.com/austinkeller/dotfiles.git ~/git/github.com/austinkeller/dotfiles
   cd ~/git/github.com/austinkeller/dotfiles
   ./install.sh
   ```

3. Activate Home Manager:
   ```
   home-manager switch --flake '.#austinkeller'
   ```

### Agent Instructions

`./install.sh` links `~/AGENTS.md` to this repo's `AGENTS.md` so local coding agents inherit the default instructions.

### Managing Packages

Packages are declared in `home.nix`. After modifying:

```
home-manager switch --flake '.#austinkeller'
```

Or use the convenience alias (after first activation):
```
hms
```

### Updating Packages

To update all flake inputs (nixpkgs, home-manager) to their latest versions:

```
nix flake update
home-manager switch --flake '.#austinkeller'
```

### Stable vs Unstable Packages

- By default, packages come from the stable Darwin channel (`nixpkgs-25.11-darwin`)
- For bleeding-edge versions, prefix with `unstable.` (e.g., `unstable.claude-code`)
- Unstable packages come from `nixpkgs-unstable`

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
