ln -s .dotfiles/.gitconfig
ln -s .dotfiles/.tmux.conf
ln -s .dotfiles/.vimrc
cp .dotfiles/.ssh/rc .ssh/rc
cat .dotfiles/.ssh/config >> .ssh/config
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

