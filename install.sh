green() {
	printf "\e[0;32m$1\e[0m"
}

install() {
	echo $(green "Downloading script...")
	curl -L#o /var/tmp/gg_$$ https://raw.githubusercontent.com/csi-lk/gg/master/bin/gg
    echo $(green "Setting permissions...")
	chmod -v +x /var/tmp/gg_$$
    echo $(green "Moving to \$PATH")
	sudo mv -fv /var/tmp/gg_$$ /usr/local/bin/gg
	version=($(gg -V))
	echo $(green "Successfully installed! v${version}")
}

install
