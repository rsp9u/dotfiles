~/.docker/config.json:
	mkdir -p ~/.docker
	ln -s $(PWD)/docker.config/config.json $@

~/.ssh/config:
	mkdir -p ~/.ssh
	chmod 700 ~/.ssh
	ln -s $(PWD)/ssh_config $@

~/.vimrc:
	ln -s $(PWD)/vimrc/nvim-arch-mng.vim $@

~/.config/nvim/init.vim:
	if command -v nvim; then \
	  ln -s $(PWD)/vimrc/nvim-arch-mng.vim $@; \
	fi
