# https://superuser.com/a/583502/225931
export PLATFORM=$(uname -s)

if [ "$PLATFORM" = 'Darwin' ] && [ -f /etc/profile ]; then
  PATH=
  source /etc/profile
fi

. ~/.bashrc

export GPG_TTY=$(tty)
