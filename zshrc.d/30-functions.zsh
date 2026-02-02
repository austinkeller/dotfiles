#
# Utility functions
#

# Useful test for breaking dependencies
function is_bin_in_path {
  builtin whence -p "$1" &> /dev/null
}

# Allows for overriding shell functions
function save_function {
  # Usage: save_function func new_func
  # From https://mharrison.org/post/bashfunctionoverride/
  local ORIG_FUNC="$(declare -f $1)"
  local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
  eval "$NEWNAME_FUNC"
}
