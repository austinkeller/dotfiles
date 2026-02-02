# ~/.zshrc - Modular loader
#
# Uncomment to run zsh profiling. Run `zprof` to see results
#zmodload zsh/zprof

# Claude Code: minimal config - just PATH and essential env
# Skip Prezto, prompts, completions, aliases, hooks, etc.
if [[ -n "${CLAUDECODE}" ]]; then
  # Only source PATH, basic functions, and direnv
  [[ -f ~/.zshrc.d/20-path.zsh ]] && source ~/.zshrc.d/20-path.zsh
  [[ -f ~/.zshrc.d/25-direnv.zsh ]] && source ~/.zshrc.d/25-direnv.zsh
  [[ -f ~/.zshrc.d/30-functions.zsh ]] && source ~/.zshrc.d/30-functions.zsh
  return 0
fi

# Source all .zsh files in zshrc.d/ in numeric order
for config in ~/.zshrc.d/*.zsh(N); do
  source "$config"
done
