#
# PATH modifications
#

# Add local bin directories
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.npm-global/bin

# Add snap bin
export PATH=$PATH:/snap/bin

# Android SDK tools
export PATH=$PATH:$HOME/Android/Sdk/cmdline-tools/latest/bin

# Go paths
export GOPATH=$HOME/go
# Add all $GOPATH/bin directories to path
export PATH="$PATH:${GOPATH//://bin:}/bin"

# Antigravity tools
export PATH="/Users/austinkeller/.antigravity/antigravity/bin:$PATH"
