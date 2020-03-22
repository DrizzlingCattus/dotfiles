alias ll='ls -FGlAhp'
alias ls="ls -G"
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
alias vim=/usr/local/bin/nvim

cd() { builtin cd "$@"; ll; }
hcurl() { curl "cheat.sh/$1"; }

# go env
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

export EDITOR=/usr/local/bin/nvim
export PATH="/usr/local/sbin:$PATH"
export PATH=$HOME/bin:$PATH
# mysql-client binarys
export PATH=/usr/local/Cellar/mysql-client/8.0.18/bin:$PATH
# go downloaded bin
export PATH=$GOBIN:$PATH

source $HOME/.bashrc.d/ps1_test.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
