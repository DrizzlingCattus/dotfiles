#!/bin/bash

BASE=$(pwd)
for rc in *rc *profile tmux.conf; do
  mkdir -pv bak
  [ -e ~/."$rc" ] && mv -v ~/."$rc" bak/."$rc"
  ln -sfv "$BASE/$rc" ~/."$rc"
done

if [ "$(uname -s)" = 'Darwin' ]
then
  [ -z "$(which brew)" ] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  
  echo "Install homebrew packages"
  brew install --cask iterm2 karabiner-element

  brew install vim wget git bash-completion cscope \ 
    jq ruby python go reattach-to-user-namespace git tmux

  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags

  gem install gem-ctags
  gem ctags
else
  rm -f ~/.tmux.conf
  grep -v reattach-to-user-namespace tmux.conf > ~/.tmux.conf
fi

git config --global user.email "hit0473@gmail.com"
git config --global user.name "DrizzlingCattus"

# install git completion
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source-file ~/.tmux.conf

./install-vim.sh
