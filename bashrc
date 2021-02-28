alias ll='ls -FGlAhp'
alias ls="ls -G"
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
#alias vim=/usr/local/bin/nvim

cd() { builtin cd "$@"; ll; }
hcurl() { curl "cheat.sh/$1"; }

export EDITOR=/usr/local/bin/vim
export SHELL='/bin/bash'

# go env
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH
export PATH=/usr/local/go/bin:$PATH

export PATH="/usr/local/sbin:$PATH"
export PATH=$HOME/bin:$PATH
export PATH=/usr/local/bin:$PATH
# mysql-client binarys
export PATH=/usr/local/Cellar/mysql-client/8.0.18/bin:$PATH
export PATH=$HOME/scripts:$PATH

source $HOME/.bashrc.d/ps1_test.sh
if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

complete -C /usr/local/bin/terraform terraform

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export KUBERNETES_CLI_PATH=/Users/user/bin
export PATH=$KUBERNETES_CLI_PATH:$PATH
export NCC_CLI_PATH=/Users/user/bin
export PATH=$NCC_CLI_PATH:$PATH
export HELM_PATH=/Users/user/bin
export PATH=$HELM_PATH:$PATH
export DOCKER_PATH=/Users/user/bin
export PATH=$DOCKER_PATH:$PATH
[ -s "/Users/user/.jabba/jabba.sh" ] && source "/Users/user/.jabba/jabba.sh"
