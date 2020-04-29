[ -n "$DIRECTORY" ] || DIRECTORY="$( cd "$( dirname "$( readlink "$BASH_SOURCE[0]")" )" && pwd )"

if [ -n "$SSH_TTY" ]; then
  export EDITOR='emacs'
elif [ is_osx ]; then
  export EDITOR='mate -w'
else
  export EDITOR='emacs'
fi

for aliasFile in "$DIRECTORY"/.*alias; do
  source "$aliasFile"
done

is_zsh && setopt null_glob
is_zsh || shopt -s nullglob

for aliasFile in "$DIRECTORY"/../.*alias/.*alias; do
  source "$aliasFile"
done

is_zsh && unsetopt null_glob
is_zsh || shopt -u nullglob

PATH=$DIRECTORY/.bin:$PATH
PATH=/usr/local/sbin:$PATH

alias pushaliases="(cd $DIRECTORY && git add -A && git commit -a -m \"$(date)\" && git push origin master)"
alias pullaliases="(cd $DIRECTORY && git fetch origin && git reset --hard origin/master)"