[ -n "$DIRECTORY" ] || DIRECTORY="$( cd "$( dirname "$( readlink "$BASH_SOURCE")" )" && pwd )"

## load required files
for aliasFile in "$DIRECTORY"/._*alias; do
  source "$aliasFile"
done

if [ -n "$SSH_TTY" ]; then
  export EDITOR='emacs'
elif is_osx; then
  export EDITOR='mate -w'
else
  export EDITOR='vi'
fi

## load up the alias files
for aliasFile in "$DIRECTORY"/.*alias; do
  source "$aliasFile"
done

is_zsh && setopt null_glob
is_zsh || shopt -s nullglob

## load up private alias files
## ~/.privalias/.workalias
for aliasFile in "$DIRECTORY"/../.*alias/.*alias; do
  source "$aliasFile"
done

is_zsh && unsetopt null_glob
is_zsh || shopt -u nullglob

PATH=$DIRECTORY/.bin:$PATH
PATH=/usr/local/sbin:$PATH

alias pushaliases="(cd $DIRECTORY && git add -A && git commit -a -m \"$(date)\" && git push origin master)"
alias pullaliases="(cd $DIRECTORY && git fetch origin && git reset --hard origin/master)"

alias ralias="unalias -a; source ${funcsourcetrace[1]%:*}"
alias ealias="${EDITOR} $DIRECTORY"

alias fixaudio="sudo killall coreaudiod; sudo launchctl stop com.apple.audio.coreaudiod && sudo launchctl start com.apple.audio.coreaudiod"