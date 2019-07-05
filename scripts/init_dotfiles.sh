ln -s .dotfiles/.gitconfig
ln -s .dotfiles/.tmux.conf
ln -s .dotfiles/.vimrc
ln -s .dotfiles/.zshrc
cp .dotfiles/.ssh/rc .ssh/rc
cat .dotfiles/.ssh/config >> .ssh/config
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone git@github.com:austinkeller/prezto "${ZDOTDIR:-$HOME}"/.zprezto

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^(README.md|zshrc)(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

