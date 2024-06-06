#!/usr/bin/env zsh

ln -s -T "$(pwd)" ~/.dotfiles

cd $HOME

ln -s .dotfiles/env.nix
mkdir -p .nix-defexpr
ln -s -T ~/.dotfiles/.nix-defexpr/nixpkgs .nix-defexpr/nixpkgs
ln -s .dotfiles/.gitconfig
ln -s .dotfiles/.tmux.conf
ln -s .dotfiles/.vimrc
ln -s .dotfiles/.zshrc
ln -s .dotfiles/.p10k.zsh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --recursive https://github.com/austinkeller/prezto.git "${ZDOTDIR:-$HOME}"/.zprezto
cd "${ZDOTDIR:-$HOME}"/.zprezto
git remote add upstream https://github.com/sorin-ionescu/prezto.git
cd $HOME

mkdir $HOME/.ssh
cp .dotfiles/ssh/allowed_signers $HOME/.ssh/allowed_signers

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^(README.md|zshrc)(N); do
  echo "$rcfile"
  ln -snv "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

mkdir -p $HOME/.local/bin

ln -sf $HOME/.dotfiles/scripts/nix-diff.sh $HOME/.local/bin/nix-diff
ln -sf $HOME/.dotfiles/scripts/nix-update-nixpkgs.sh $HOME/.local/bin/nix-update-nixpkgs
ln -sf $HOME/.dotfiles/scripts/start-ec2.sh $HOME/.local/bin/start-ec2
ln -sf $HOME/.dotfiles/scripts/stop-ec2.sh $HOME/.local/bin/stop-ec2
ln -sf $HOME/.dotfiles/scripts/switch-ec2.sh $HOME/.local/bin/switch-ec2
