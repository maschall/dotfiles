#DIRECTORY="$( cd "$( dirname "$( readlink "$0")" )" && pwd )"

if [ -n "$SSH_TTY" ]; then
  export EDITOR='emacs'
else
  export EDITOR='mate -w'
fi

for aliasFile in "$DIRECTORY"/.*alias; do
  source "$aliasFile"
done

setopt null_glob
for aliasFile in "$DIRECTORY"/../.*alias/.*alias; do
  source "$aliasFile"
done
unsetopt null_glob

PATH=$DIRECTORY/.bin:$PATH
PATH=/usr/local/sbin:$PATH

alias pushaliases="(cd $DIRECTORY && git add -A && git commit -a -m \"$(date)\" && git push origin master)"
alias pullaliases="(cd $DIRECTORY && git fetch origin && git reset --hard origin/master)"