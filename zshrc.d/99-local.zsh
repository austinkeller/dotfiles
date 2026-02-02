#
# Local and machine-specific configurations
#

# Conda configuration (not in dotfiles repo)
[[ -f ~/.zshrc_conda ]] && . ~/.zshrc_conda || true

# Smartsheet-specific configuration (not in dotfiles repo)
[[ -f ~/.zshrc_smartsheet ]] && . ~/.zshrc_smartsheet || true

# Powerlevel10k customization
# Skip in Claude Code to avoid shell snapshot parsing bugs
if [[ -z "${CLAUDECODE}" ]]; then
  [[ ! -f ~/.dotfiles/.p10k.zsh ]] || source ~/.dotfiles/.p10k.zsh
fi
