#!/usr/bin/env zsh

ln -sfn "$(pwd)" ~/.dotfiles

cd $HOME

# Create home-manager config directory and link flake files
mkdir -p .config/home-manager
ln -sf ~/.dotfiles/home.nix .config/home-manager/home.nix
ln -sf ~/.dotfiles/flake.nix .config/home-manager/flake.nix
ln -sf ~/.dotfiles/flake.lock .config/home-manager/flake.lock

# Link dotfiles
ln -sf .dotfiles/AGENTS.md AGENTS.md
ln -sf .dotfiles/.gitconfig .gitconfig
ln -sf .dotfiles/.tmux.conf .tmux.conf
ln -sf .dotfiles/.vimrc .vimrc
ln -sf .dotfiles/.zshrc .zshrc
ln -sf .dotfiles/.p10k.zsh .p10k.zsh

# Install tmux plugin manager
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install prezto
if [[ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
  git clone --recursive https://github.com/austinkeller/prezto.git "${ZDOTDIR:-$HOME}"/.zprezto
  cd "${ZDOTDIR:-$HOME}"/.zprezto
  git remote add upstream https://github.com/sorin-ionescu/prezto.git
  cd $HOME
fi

# Setup SSH directory
mkdir -p $HOME/.ssh
cp -n .dotfiles/ssh/allowed_signers $HOME/.ssh/allowed_signers 2>/dev/null || true

# Link prezto runcoms
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^(README.md|zshrc)(N); do
  echo "$rcfile"
  ln -snv "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Setup local bin directory and link scripts
mkdir -p $HOME/.local/bin
ln -sf $HOME/.dotfiles/scripts/fix.sh $HOME/.local/bin/fix
ln -sf $HOME/.dotfiles/scripts/nix-diff.sh $HOME/.local/bin/nix-diff
ln -sf $HOME/.dotfiles/scripts/start-ec2.sh $HOME/.local/bin/start-ec2
ln -sf $HOME/.dotfiles/scripts/stop-ec2.sh $HOME/.local/bin/stop-ec2
ln -sf $HOME/.dotfiles/scripts/switch-ec2.sh $HOME/.local/bin/switch-ec2
