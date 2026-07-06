#!/bin/bash
set -e

green() {
	printf '\e[0;32m%b\e[0m\n' "$1"
}

red() {
	printf '\e[0;31m%b\e[0m\n' "$1"
}

yellow() {
	printf '\e[0;33m%b\e[0m\n' "$1"
}

install() {
	local tmp_file="/tmp/gg_$$"
	local install_dir=""

	green "Downloading gg script..."
	if ! curl -fsSL -o "$tmp_file" https://raw.githubusercontent.com/csi-lk/gg/master/bin/gg; then
		red "Failed to download script"
		exit 1
	fi

	green "Setting permissions..."
	chmod +x "$tmp_file"

	# Try to install to /usr/local/bin first (preferred location)
	if [ -w /usr/local/bin ]; then
		install_dir="/usr/local/bin"
		mv -f "$tmp_file" "$install_dir/gg"
		green "Installed to $install_dir/gg"
	elif [ -d /usr/local/bin ] && [ "$(id -u)" != "0" ]; then
		# Try with sudo if directory exists but not writable
		yellow "/usr/local/bin requires sudo access..."
		if sudo -n true 2>/dev/null; then
			# sudo available without password
			sudo mv -f "$tmp_file" /usr/local/bin/gg
			install_dir="/usr/local/bin"
			green "Installed to $install_dir/gg"
		elif read -p "Install to /usr/local/bin with sudo? [y/N] " -n 1 -r; then
			echo
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				sudo mv -f "$tmp_file" /usr/local/bin/gg
				install_dir="/usr/local/bin"
				green "Installed to $install_dir/gg"
			else
				install_dir=""
			fi
		else
			install_dir=""
		fi
	fi

	# Fallback to ~/.local/bin
	if [ -z "$install_dir" ]; then
		install_dir="$HOME/.local/bin"
		yellow "Installing to $install_dir instead..."
		mkdir -p "$install_dir"
		mv -f "$tmp_file" "$install_dir/gg"
		green "Installed to $install_dir/gg"

		# Check if ~/.local/bin is in PATH
		if [[ ":$PATH:" != *":$install_dir:"* ]]; then
			yellow "⚠ Warning: $install_dir is not in your PATH"
			echo "Add the following line to your ~/.bashrc or ~/.zshrc:"
			echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
		fi
	fi

	# Verify installation
	if command -v gg &> /dev/null; then
		version=$(gg -V 2>/dev/null || echo "unknown")
		green "Successfully installed! $version"
	else
		yellow "Installation complete, but 'gg' not found in PATH"
		echo "You may need to restart your shell or run: hash -r"
	fi
}

install
