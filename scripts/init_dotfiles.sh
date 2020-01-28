#!/usr/bin/env zsh

cd $HOME

ln -s .dotfiles/.gitconfig
ln -s .dotfiles/.tmux.conf
ln -s .dotfiles/.vimrc
ln -s .dotfiles/.zshrc
ln -s .dotfiles/.p10k.zsh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --recursive git@github.com:austinkeller/prezto "${ZDOTDIR:-$HOME}"/.zprezto
cd "${ZDOTDIR:-$HOME}"/.zprezto
git remote add upstream https://github.com/sorin-ionescu/prezto.git
cd $HOME

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^(README.md|zshrc)(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
