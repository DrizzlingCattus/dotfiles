#!/usr/bin/env bash

## TODO: sudoer 권한 요구하는 방법
## TODO: mac /bin/bash를 최신버전 binary로 교체하는 좋은 방법 하드링킹이면 충분?

function echo_pretty() {
  input_str=$1
  level="${2:-1}"
  case "$level" in
    "1")
      echo -e "🚜\e[34m [[[[[[[[[[ $input_str ]]]]]]]]]] \e[0m"

      ;;
    "2")
      echo -e "🛺\e[32m {{{{{{{{{{ $input_str }}}}}}}}}} \e[0m"
      ;;
    "3")
     echo -e "🛵\e[33m (((((((((( $input_str )))))))))) \e[0m"
      ;;
    *)
      echo "Invalid input: Please provide a level number between 1 and 3"
      ;;
  esac
}

OS_NAME=$(uname -s)
if [ "$OS_NAME" = 'Darwin' ]
then
  BASE="$(pwd)/mac"
else
  BASE="$(pwd)/linux"
fi

# backup current conf files and replace predefined conf-linked files
mkdir -pv bak
for conf in tmux.conf; do
  [ -e ~/."$conf" ] && mv -v ~/."$conf" bak/."$conf"
  ln -sfv "$(pwd)/$conf" ~/."$conf"
done

# backup current system rc files and replace predefined rc-linked files
for rc in $BASE/*; do
  RC_FILENAME=`basename $rc`
  [ -e ~/."$RC_FILENAME" ] && mv -v ~/."$RC_FILENAME" bak/."$RC_FILENAME"
  ln -sfv "$rc" ~/."$RC_FILENAME"
done

if [ "$OS_NAME" = 'Darwin' ]
then
  if [ -z "$(which brew)" ]
  then
    echo "Install homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$BASE/bashrc"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # install basic homebrew packages
  echo_pretty "Install homebrew packages"
  brew install --cask iterm2 karabiner-elements google-chrome rectangle  # for utility
  brew install --cask insomnia # for dev
  brew install --cask eul # for information

  brew install vim wget curl coreutils git bash-completion \
    jq \
    cscope reattach-to-user-namespace tmux \
    docker docker-compose

  # install asdf
  echo_pretty "Install asdf"
  if [ -z "$(which asdf)" ]
  then
    brew install asdf
    # echo -e "\n. \"$(brew --prefix asdf)/libexec/asdf.sh\"" >> "$BASE/bashrc"
    # echo -e "\n. \"$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash\"" >> "$BASE/bashrc"
  fi

  echo_pretty "Install asdf node" 2
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs latest
  asdf global nodejs latest

  echo_pretty "Install asdf python" 2
  asdf plugin add python
  asdf install python latest
  asdf global python latest

  echo_pretty "Install asdf golang" 2
  asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
  asdf install golang 1.21.0
  asdf global golang 1.21.0

  echo_pretty "Install asdf ruby" 2
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby latest
  asdf global ruby latest

  echo_pretty "Install asdf kubectl" 2
  asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
  asdf install kubectl latest
  asdf global kubectl latest

  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags

  echo_pretty "Install latest bash"
  brew install bash
  if [-z $(echo $(which bash) | grep $(which bash))]
  then
    echo_pretty "Enroll default shell path into /etc/shells" 2
    sudo bash -c 'echo $(which bash) >> /etc/shells'
  fi
  chsh -s $(which bash)
  echo_pretty "Changing default shell into $SHELL [version: $($SHELL --version | awk '/GNU bash, version/ {print $4}')]" 2

  gem install gem-ctags
  gem ctags
else
  echo_pretty "keyboard mapping for Linux"
  xmodmap -pke > ~/Xmodmap_origin_backup
  xmodmap ~/.Xmodmap

  # make tmux without reattach-to-user-namespace related things
  echo_pretty "Make tmux settings for Linux"
  rm -f ~/.tmux.conf
  grep -v reattach-to-user-namespace tmux.conf > ~/.tmux.conf
fi

# theme
git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git color-schemes
cd color-schemes
tools/import-scheme.sh "Solarized Dark Higher Contrast"
cd ..

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
