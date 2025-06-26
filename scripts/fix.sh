#!/usr/bin/env bash

set -euo pipefail

# Detect and fix common issues with my development environment

check_ssh_keys_loaded() {
	# Check if ssh-agent is running. `ssh-add -l` returns 2 if the agent is not running.
	if ! ssh-add -l &>/dev/null && [[ "$?" -eq 2 ]]; then
		echo "❌ ssh-agent is not running. Please start it, e.g., 'eval \$(ssh-agent -s)'" >&2
		exit 1
	fi

	local -r key_suffixes=("junkanoo" "github" "goosebox")
	local missing_keys=()

	# Helper function to check for missing keys and populate the missing_keys array.
	check_for_missing_keys() {
		missing_keys=() # Reset the array
		local loaded_keys
		# `ssh-add -L` returns 1 if no keys are loaded. `|| true` prevents script exit.
		loaded_keys=$(ssh-add -L 2>/dev/null || true)

		for suffix in "${key_suffixes[@]}"; do
			# Use a here-string `<<<` which is cleaner than `echo |`
			if ! grep -q -- "${suffix}$" <<<"$loaded_keys"; then
				missing_keys+=("$suffix")
			fi
		done
	}

	echo "Checking loaded SSH keys..."
	check_for_missing_keys

	# If keys are missing, attempt to add all of them.
	if [[ ${#missing_keys[@]} -gt 0 ]]; then
		echo "Attempting to add missing SSH keys: ${missing_keys[*]}"
		for suffix in "${key_suffixes[@]}"; do
			local key_path="$HOME/.ssh/id_ed25519_${suffix}"
			if [[ -f "$key_path" ]]; then
				# Use --apple-use-keychain as requested. Suppress output on success.
				if ssh-add --apple-use-keychain "$key_path" &>/dev/null; then
					echo "  -> Added ~/.ssh/$(basename "$key_path")"
				else
					echo "  ⚠️ Failed to add ~/.ssh/$(basename "$key_path"). Check passphrase or file." >&2
				fi
			else
				echo "  ⚠️ Key file not found: ~/.ssh/$(basename "$key_path")" >&2
			fi
		done

		echo "Re-checking keys..."
		check_for_missing_keys
	fi

	# Final status report.
	if [[ ${#missing_keys[@]} -eq 0 ]]; then
		echo "✅ All required SSH keys are loaded."
	else
		echo "❌ The following SSH keys are still not loaded:" >&2
		for key in "${missing_keys[@]}"; do
			echo "  - ${key}" >&2
		done
		echo "Please add the remaining keys manually using 'ssh-add'." >&2
		exit 1
	fi
}

check_ssh_keys_loaded
