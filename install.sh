#!/bin/bash

OS_NAME=$(uname -s)
if [ "$OS_NAME" = 'Darwin' ]
then
  BASE="$(pwd)/mac"
else
  BASE="$(pwd)/linux"
fi

mkdir -pv bak
for rc_common in tmux.conf; do
  [ -e ~/."$rc" ] && mv -v ~/."$rc" bak/."$rc"
  ln -sfv "$(pwd)/$rc" ~/."$rc"
done

for rc in $BASE/*; do
  RC_FILENAME=`basename $rc`
  [ -e ~/."$RC_FILENAME" ] && mv -v ~/."$RC_FILENAME" bak/."$RC_FILENAME"
  ln -sfv "$rc" ~/."$RC_FILENAME"
done

if [ "$OS_NAME" = 'Darwin' ]
then
  if [ -z "$(which brew)" ]
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$BASE/bashrc"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # install basic homebrew packages
  echo "Install homebrew packages"
  brew install --cask iterm2 karabiner-elements google-chrome rectangle

  brew install vim wget curl coreutils git bash-completion \
    jq \
    cscope reattach-to-user-namespace tmux \
    docker docker-compose

  # install asdf
  echo "Install asdf and asdf related packages"
  if [ -z "$(which asdf)" ]
  then
    brew install asdf
    # echo -e "\n. \"$(brew --prefix asdf)/libexec/asdf.sh\"" >> "$BASE/bashrc"
    # echo -e "\n. \"$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash\"" >> "$BASE/bashrc"
  fi

  ## asdf nodejs
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs latest
  asdf global nodejs latest

  ## asdf python
  asdf plugin add python
  asdf install python latest
  asdf global python latest

  ## asdf go
  asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
  asdf install golang 1.21.0
  asdf global golang 1.21.0

  ## asdf ruby
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby latest
  asdf global ruby latest

  ## asdf kubectl
  asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
  asdf install kubectl latest
  asdf global kubectl latest

  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags

  gem install gem-ctags
  gem ctags
else
  echo "keyboard mapping for Linux"
  xmodmap -pke > ~/Xmodmap_origin_backup
  xmodmap ~/.Xmodmap

  # make tmux without reattach-to-user-namespace related things
  echo "Make tmux settings for Linux"
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
