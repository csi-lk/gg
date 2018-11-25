green() {
	printf "\e[0;32m$1\e[0m"
}

install() {
	$(green "Downloading script..")
	curl -L#o /var/tmp/gg_$$ https://raw.githubusercontent.com/csi-lk/gg/blob/master/bin/gg
    $(green "Setting permissions..")
	chmod -v +x /var/tmp/gg_$$
    $(green "Moving to \$PATH..")
	sudo mv -fv /var/tmp/gg_$$ /usr/local/bin/gg
	version=($(gg -V))
	$(green "Successfully installed! v${version}")
}

install
