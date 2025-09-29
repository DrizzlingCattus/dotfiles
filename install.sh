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
      echo -e "--> 🛺\e[32m {{{{{{{{{{ $input_str }}}}}}}}}} \e[0m"
      ;;
    "3")
     echo -e "----> 🛵\e[33m (((((((((( $input_str )))))))))) \e[0m"
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
confs=( tmux.conf eslintrc.js prettierrc ideavimrc )
for conf in ${confs[@]}; do
  [ -e ~/."$conf" ] && mv -v ~/."$conf" bak/."$conf"
  ln -sfv "$(pwd)/$conf" ~/."$conf"
done

# backup current system rc files and replace predefined rc-linked files
for rc in $BASE/*; do
  RC_FILENAME=`basename $rc`
  [ -e ~/."$RC_FILENAME" ] && mv -v ~/."$RC_FILENAME" bak/."$RC_FILENAME"
  ln -sfv "$rc" ~/."$RC_FILENAME"
done

mkdir -pv ~/bin
for bin in bin/*; do
  BIN_FILENAME=`basename $bin`
  if [ ! -e ~/bin/"$BIN_FILENAME" ]
  then
    echo "Copy $bin into ~/bin/$BIN_FILENAME"
    cp "$bin" ~/bin/"$BIN_FILENAME"
  fi
done

if [ "$OS_NAME" = 'Darwin' ]
then
  if [ -z "$(which brew)" ]
  then
    echo "=== Install homebrew ==="
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$BASE/bashrc"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # install basic homebrew packages
  echo_pretty "=== Install homebrew packages ===" 2
  brew install --cask ghostty karabiner-elements google-chrome rectangle \
    font-jetbrains-mono

  # coreutils for GNU utility
  brew install git bash-completion \
    jq wget curl coreutils \
    vim neovim \
    cscope reattach-to-user-namespace tmux \
    docker docker-compose podman \
    stats

  # install asdf
  echo_pretty "=== Install asdf multiple version manager ==="
  if [ -z "$(which asdf)" ]
  then
    brew install asdf
    # echo -e "\n. \"$(brew --prefix asdf)/libexec/asdf.sh\"" >> "$BASE/bashrc"
    # echo -e "\n. \"$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash\"" >> "$BASE/bashrc"
  fi

  echo_pretty "=== Install asdf node ===" 2
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs latest
  asdf set --home nodejs latest

  echo_pretty "=== Install asdf python ===" 2
  asdf plugin add python
  asdf install python latest
  asdf set --home python latest

  echo_pretty "=== Install asdf golang ===" 2
  asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
  asdf install golang 1.21.0
  asdf set --home golang 1.21.0

  echo_pretty "=== Install asdf ruby ===" 2
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby latest
  asdf set --home ruby latest

  echo_pretty "=== Install asdf kubectl ===" 2
  asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
  asdf install kubectl latest
  asdf set --home kubectl latest

  echo_pretty "=== Install asdf deno ===" 2
  asdf plugin add deno https://github.com/asdf-community/asdf-deno.git
  asdf install deno latest
  asdf set --home deno latest

  echo_pretty "=== Install asdf java ===" 2
  asdf plugin add java
  asdf install java corretto-22.0.2.9.1
  asdf set --home java corretto-22.0.2.9.1

  echo_pretty "=== Install asdf clojure ===" 2
  asdf plugin add clojure https://github.com/asdf-community/asdf-clojure.git
  asdf install clojure 1.12.0.1530
  asdf set --home clojure 1.12.0.1530

  echo_pretty "=== Install asdf kotlin ===" 2
  asdf plugin add kotlin
  asdf install kotlin 1.8.22
  asdf set --home kotlin 1.8.22

  brew tap universal-ctags/universal-ctags
  brew install --HEAD universal-ctags

  echo_pretty "=== Install latest bash ==="
  brew install bash
  # 1. brew --prefix를 사용해 Homebrew로 설치된 bash 경로를 명확히 지정합니다.
  #    Apple Silicon: /opt/homebrew/bin/bash
  #    Intel Mac: /usr/local/bin/bash
  BREW_BASH_PATH=$(brew --prefix)/bin/bash
  # 2. /etc/shells 파일에 해당 경로가 있는지 정확하게 확인합니다.
  #    grep -q: 결과를 출력하지 않고 종료 코드로 성공/실패만 반환합니다.
  #    grep -F: 경로에 포함될 수 있는 특수문자(., / 등)를 일반 문자열로 처리하여 안전합니다.
  #    '!'는 grep이 실패했을 때(경로가 없을 때) if문이 참이 되도록 합니다.
  if ! grep -qF "$BREW_BASH_PATH" /etc/shells; then
    echo_pretty "Adding '$BREW_BASH_PATH' to /etc/shells"
    # 3. sudo를 통해 파일에 안전하게 내용을 추가합니다.
    echo "$BREW_BASH_PATH" | sudo tee -a /etc/shells > /dev/null
  fi
  if [ -z $(echo $(which bash) | grep $(which bash))]
  then
    echo_pretty "Enroll default shell path into /etc/shells" 2
    sudo bash -c 'echo $(which bash) >> /etc/shells'
  fi
  chsh -s "$BREW_BASH_PATH"
  NEW_BASH_VERSION=$("$BREW_BASH_PATH" --version | awk '/version/ {print $4}')
  echo_pretty "✅ Default shell changed to $BREW_BASH_PATH" 2
  echo_pretty "   Version: $NEW_BASH_VERSION" 2
  echo_pretty "   (Changes will apply after your next login)" 2

  echo_pretty "=== Install pipx for isolated pyton app space ==="
  brew install pipx
  pipx ensurepath
  sudo pipx ensurepath --global

  echo_pretty "=== Install grpc ==="
  brew install protobuf

  echo_pretty "=== Install global lint & fixer ==="
  npm install -g eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin \
    prettier eslint-config-prettier
  # TODO: global python lint, fixer

  gem install gem-ctags
  gem ctags
else
  echo_pretty "keyboard mapping for Linux"
  xmodmap -pke > ~/Xmodmap_origin_backup
  xmodmap ~/.Xmodmap

  # TODO: install ghostty, chrome, development tools, vscode, intellij ...

  # make tmux without reattach-to-user-namespace related things
  echo_pretty "Make tmux settings for Linux"
  rm -f ~/.tmux.conf
  grep -v reattach-to-user-namespace tmux.conf > ~/.tmux.conf
fi

git config --global user.email "hit0473@gmail.com"
git config --global user.name "DrizzlingCattus"
git config --global core.editor "nvim"

# install git completion
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source-file ~/.tmux.conf

./install-vim.sh
