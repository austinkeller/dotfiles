#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq nix-prefetch
# shellcheck shell=bash

set -euo pipefail

dryrun=0
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
HOME_NIX="${DOTFILES_DIR}/home.nix"

usage() {
  cat <<USAGEEOF
Usage: $0 [OPTIONS]

Options:
  -h  --help      show this help
  -n  --dry-run   do not make any changes
USAGEEOF
}

for arg in "$@"; do
  case ${arg} in
    '-n' | '--dry-run')
      dryrun=1
      ;;
    '-h' | '--help')
      usage
      exit 0
      ;;
    *)
      echo "$0: Unexpected argument: ${arg}" >&2
      usage >&2
      exit 1
      ;;
  esac
done

# Function to update unstable nixpkgs pin in home.nix
update_unstable() {
  local is_dryrun=${1:-0}

  echo "Updating nixpkgs-unstable pin..."

  if [[ ! -f "${HOME_NIX}" ]]; then
    echo "Warning: home.nix not found at ${HOME_NIX}, skipping unstable update" >&2
    return 0
  fi

  # Check if home.nix has unstable configuration
  if ! grep -q "unstableTarball" "${HOME_NIX}"; then
    echo "Note: home.nix does not have unstable nixpkgs configured, skipping"
    return 0
  fi

  echo "Querying GitHub for latest nixpkgs-unstable revision..."
  local unstable_revision
  unstable_revision=$(curl -L --silent --show-error \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/NixOS/nixpkgs/branches/nixpkgs-unstable" \
    | jq -r '.commit.sha')

  if [[ -z "${unstable_revision}" || "${unstable_revision}" == "null" ]]; then
    echo "Warning: Failed to fetch latest nixpkgs-unstable revision" >&2
    return 1
  fi

  # Extract current revision
  local current_revision
  current_revision=$(grep -A1 'unstableTarball = fetchTarball' "${HOME_NIX}" | grep 'url' | sed -E 's|.*archive/([a-f0-9]+)\.tar\.gz.*|\1|')

  if [[ "${current_revision}" == "${unstable_revision}" ]]; then
    echo "Unstable pin already up to date (${unstable_revision:0:12})"
    return 0
  fi

  echo "Latest unstable revision: ${unstable_revision}"

  if [[ ${is_dryrun} -ne 0 ]]; then
    echo "[Change] Would update unstable pin: ${current_revision:0:12} -> ${unstable_revision:0:12}"
    return 0
  fi

  echo "Calculating SHA256 hash (this may take a moment)..."

  local tarball_url="https://github.com/NixOS/nixpkgs/archive/${unstable_revision}.tar.gz"
  local unstable_sha256
  unstable_sha256=$(nix-prefetch-url --unpack "${tarball_url}" 2>/dev/null)

  if [[ -z "${unstable_sha256}" ]]; then
    echo "Warning: Failed to calculate SHA256 hash" >&2
    return 1
  fi

  echo "Updating home.nix with new unstable pin..."

  # Update the URL with new revision and sha256
  sed -E \
    -e "s|(url = \"https://github.com/NixOS/nixpkgs/archive/)[a-f0-9A-Z_]+(\.tar\.gz\";)|\1${unstable_revision}\2|" \
    -e "s|(sha256 = \")[^\"]+(\".*# unstable)|\1${unstable_sha256}\2|" \
    "${HOME_NIX}" > "${HOME_NIX}.tmp" && mv "${HOME_NIX}.tmp" "${HOME_NIX}"

  echo "Unstable pin updated: ${current_revision:0:12} -> ${unstable_revision:0:12}"
}

echo "Querying NixOS Prometheus for latest stable-darwin revision..."

# 1. Fetch Revision AND Channel Name
# We need the channel name (e.g. nixpkgs-25.11-darwin) to know which Home Manager release to use
api_result=$(curl -L --silent --show-error 'https://monitoring.nixos.org/prometheus/api/v1/query?query=channel_revision' \
  | jq -r '.data.result[] | select(.metric.status == "stable" and .metric.variant == "darwin") | "\(.metric.revision) \(.metric.channel)"')

read -r revision channel_name <<< "$api_result"

# Extract version number (e.g., turns "nixpkgs-25.11-darwin" into "25.11")
release_version=$(echo "$channel_name" | sed -E 's/nixpkgs-([0-9.]+)-darwin/\1/')

# 2. Construct the Nix Expression (keeping the import as requested)
nixexpr="import (fetchTarball \"https://github.com/NixOS/nixpkgs/archive/${revision}.tar.gz\")"
nixpkgsfile=~/.nix-defexpr/nixpkgs/default.nix

# 3. Construct Home Manager URL
hm_url="https://github.com/nix-community/home-manager/archive/release-${release_version}.tar.gz"

mkdir -p "$(dirname "${nixpkgsfile}")"

# Check if file changed
file_changed=0
if [[ ! -f "${nixpkgsfile}" ]] || ! diff -q "${nixpkgsfile}" - <<< "${nixexpr}" >/dev/null; then
  file_changed=1
fi

if [[ ${dryrun} -ne 0 ]]; then
  echo "--- DRY RUN ---"
  if [[ ${file_changed} -eq 1 ]]; then
    echo "[Change] Would update nixpkgs definition to revision ${revision}"
  else
    echo "[No Change] nixpkgs definition is up to date"
  fi
  echo "[Change] Would update home-manager channel to release-${release_version}"
  echo ""
  update_unstable 1
else
  echo "Detected Release: ${release_version}"
  echo "Detected Revision: ${revision}"

  if [[ ${file_changed} -eq 1 ]]; then
    echo "Updating nixpkgs definition..."
    echo "${nixexpr}" > "${nixpkgsfile}"
  else
    echo "nixpkgs definition already up to date"
  fi

  # Update Home Manager Channel to match the detected Nixpkgs version
  echo "Syncing home-manager channel to release-${release_version}..."
  nix-channel --add "${hm_url}" home-manager
  nix-channel --update

  echo "--------------------------------------------------------"
  echo ""

  # Update unstable nixpkgs pin in home.nix
  update_unstable

  echo "--------------------------------------------------------"
  echo "Done."
  echo "Run 'home-manager switch' to apply."
fi
