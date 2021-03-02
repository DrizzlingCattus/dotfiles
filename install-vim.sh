#!/usr/bin/env bash

cd $(dirname $BASH_SOURCE)
BASE=$(pwd)

export GIT_SSL_NO_VERIFY=true
mkdir -p ~/.vim/autoload
curl --insecure -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim

## vim-plug for nvim
#curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# vimrc
mv -v ~/.vimrc ~/.vimrc.old 2> /dev/null
ln -sfv $BASE/vimrc ~/.vimrc
mv -v ~/.vim/snippet ~/.vim/snippet.old 2> /dev/null
ln -sfv $BASE/snippet ~/.vim

# nvim
mkdir -p ~/.config/nvim/autoload
ln -sfv $BASE/nvim/init.vim ~/.config/nvim/init.vim
ln -sfv ~/.vim/autoload/plug.vim ~/.config/nvim/autoload/
ln -sfv $BASE/coc-settings.json ~/.config/nvim/coc-settings.json

vim +PlugInstall +qall
