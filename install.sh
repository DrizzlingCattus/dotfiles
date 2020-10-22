#!/bin/bash

BASE=$(pwd)
for rc in *rc *profile tmux.conf; do
  mkdir -pv bak
  [ -e ~/."$rc" ] && mv -v ~/."$rc" bak/."$rc"
  ln -sfv "$BASE/$rc" ~/."$rc"
done

if [ "$(uname -s)" = 'Darwin' ]
then
  brew install reattach-to-user-namespace git tmux
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
