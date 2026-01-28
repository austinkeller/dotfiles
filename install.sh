#!/usr/bin/env zsh
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

./scripts/init_dotfiles.sh

if [ -z "$CODESPACES" ]; then
    # Only set gpg signing if we aren't in a Codespace
    git config --global user.signingkey "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMvmx1RhpgLTuLjbp3PHpRahBHs1RE1nl2pOaFhohAZ austinkeller@Austins-MacBook-Pro.local github"
    git config --global commit.gpgsign true
    git config --global gpg.format ssh
    git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers

    echo ""
    echo "Dotfiles installed. To complete setup:"
    echo ""
    echo "1. Install Determinate Nix (if not already installed):"
    echo "   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"
    echo ""
    echo "2. Activate Home Manager:"
    echo "   cd ${DOTFILES_DIR} && home-manager switch --flake '.#austinkeller'"
else
    # In Codespaces, activate Home Manager directly
    home-manager switch --flake "${DOTFILES_DIR}#austinkeller"
fi
