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
ln -sf $BASE/vimrc ~/.vimrc

# nvim
mkdir -p ~/.config/nvim/autoload
ln -sf $BASE/vimrc ~/.config/nvim/init.vim
ln -sf ~/.vim/autoload/plug.vim ~/.config/nvim/autoload/

mkdir -p ~/.config/nvim
ln -sf $BASE/coc-settings.json ~/.config/nvim/coc-settings.json

vim +PlugInstall +qall
