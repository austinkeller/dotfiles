#
# Claude Code compatibility
#

if [[ -n "${CLAUDECODE}" ]]; then
  # Disable rcquotes to prevent quote escaping issues
  unsetopt rcquotes
  # Use simple prompt instead of powerlevel10k to avoid shell snapshot parsing bugs
  POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
fi
