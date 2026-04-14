#!/usr/bin/env zsh
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

./scripts/init_dotfiles.sh

if [ -z "$CODESPACES" ]; then
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
