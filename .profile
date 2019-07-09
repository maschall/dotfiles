DIRECTORY="$( cd "$( dirname "$( readlink "${BASH_SOURCE[0]}")" )" && pwd )"

#PATH=/Users/mark/Projects/xcodeenv/bin/:$PATH
#eval "$(xcenv init -)

if [ -n "$SSH_TTY" ]; then
  export EDITOR='emacs'
else
  export EDITOR='mate -w'
fi

for aliasFile in "$DIRECTORY"/.*alias; do
  source "$aliasFile"
done

shopt -s nullglob
for aliasFile in "$DIRECTORY"/../.*alias/.*alias; do
  source "$aliasFile"
done
shopt -u nullglob

PATH=$DIRECTORY/.bin:$PATH
PATH=/usr/local/sbin:$PATH

alias ralias="unalias -a; source ~/.profile"
alias ealias="${EDITOR} $DIRECTORY; ralias"

alias pushaliases="(cd $DIRECTORY && git add -A && git commit -a -m \"$(date)\" && git push origin master)"
alias pullaliases="(cd $DIRECTORY && git fetch origin && git reset --hard origin/master)"
