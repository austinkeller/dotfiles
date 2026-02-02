#
# System aliases
#

# macOS uses BSD ls (no --color or -N), Linux uses GNU ls
if is_mac; then
  alias ls='ls -G'
  alias ll='ls -lahG'
else
  alias ls='ls --color -N'
  alias ll='ls -lah --color=auto'
fi
