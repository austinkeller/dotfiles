#!/usr/bin/env zsh
./scripts/init_dotfiles.sh

if [ -z "$CODESPACES" ]; then
    # Only set gpg signing if we aren't in a Codespace
    git config --global user.signingkey "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMvmx1RhpgLTuLjbp3PHpRahBHs1RE1nl2pOaFhohAZ austinkeller@Austins-MacBook-Pro.local github"
    git config --global commit.gpgsign true
    git config --global gpg.format ssh
    git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
else
    home-manager switch
fi
