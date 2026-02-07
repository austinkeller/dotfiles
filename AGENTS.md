# Global Agent Instructions

## Package Installation Policy

- Do not use Homebrew for installing command-line tools, libraries, or project dependencies.
- Homebrew is allowed only for GUI application casks (`brew install --cask ...`).
- Prefer Nix for project-based dependencies.
- This machine supports Nix flakes, so prefer flake-based workflows (`flake.nix`, `nix develop`, `nix run`) for reproducible project environments.
