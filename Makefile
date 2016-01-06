
OH_MY_ZSH=$(shell realpath -m ~/.oh-my-zsh)
ZSH_GIT_PROMPT=$(shell realpath -m ~/.oh-my-zsh/custom/zsh-git-prompt)
PLUG_VIM=$(shell  realpath -m ~/.vim/autoload/plug.vim)
PLUG_NVIM=$(shell realpath -m ~/.config/nvim/autoload/plug.vim)

all: oh-my-zsh vim-setup link vim-install-plugins nvim-install-plugins

link:
	./link.sh
	rm -f ~/scripts
	ln -sf `realpath scripts` ~/scripts

oh-my-zsh: $(OH_MY_ZSH) $(ZSH_GIT_PROMPT)

$(OH_MY_ZSH):
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	chsh -s /bin/zsh

$(ZSH_GIT_PROMPT): $(OH_MY_ZSH)
	git clone https://github.com/olivierverdier/zsh-git-prompt.git $(ZSH_GIT_PROMPT)

vim-setup: $(PLUG_NVIM) $(PLUG_VIM)
	mkdir -p ~/.vim/tmp/backup/
	mkdir -p ~/.vim/tmp/swap/

$(PLUG_VIM):
	curl -fLo $(PLUG_VIM) --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$(PLUG_NVIM): $(PLUG_VIM)
	mkdir -p `dirname $(PLUG_NVIM)`
	cp $(PLUG_VIM) $(PLUG_NVIM)


vim-install-plugins:
	vim +PlugInstall +qall
nvim-install-plugins:
	ln -sf ~/.vim/colors ~/.config/nvim/colors
	(which nvim && nvim +PlugInstall +qall) || true
clean:
	./clean.sh
