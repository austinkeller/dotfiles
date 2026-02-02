#
# Python utilities
#

# python-direnv-init
# Initializes directory with a new python virtualenv that is automatically
# loaded within the dir
function python-direnv-init {
  cat > .envrc << 'EOF'
export VIRTUAL_ENV=${XDG_CACHE_HOME:-~/.cache}/virtualenvs/$(basename $PWD)
export PATH="${VIRTUAL_ENV}/bin:$PATH"
python3 -m venv $VIRTUAL_ENV
EOF
}
