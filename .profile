DIRECTORY="$( cd "$( dirname "$( readlink "$0")" )" && pwd )"

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

setopt null_glob
for aliasFile in "$DIRECTORY"/../.*alias/.*alias; do
  source "$aliasFile"
done
unsetopt null_glob

PATH=$DIRECTORY/.bin:$PATH
PATH=/usr/local/sbin:$PATH

alias ralias="unalias -a; source ${BASH_SOURCE[0]}"
alias ealias="${EDITOR} $DIRECTORY"

alias pushaliases="(cd $DIRECTORY && git add -A && git commit -a -m \"$(date)\" && git push origin master)"
alias pullaliases="(cd $DIRECTORY && git fetch origin && git reset --hard origin/master)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
