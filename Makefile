
OH_MY_ZSH=$(shell realpath ~/.oh-my-zsh)

all: $(OH_MY_ZSH) link

link:
	./link.sh

$(OH_MY_ZSH):
	git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	chsh -s /bin/zsh

vim-plugins:
	# vim install plugins

clean:
	./clean.sh
