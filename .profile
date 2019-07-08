DIRECTORY="$( cd "$( dirname "$( readlink "${BASH_SOURCE[0]}")" )" && pwd )"

touch "$HOME/.bash_sessions_disable"

PATH=$HOME/bin:$PATH
PATH=/usr/local/sbin:$PATH

#PATH=/Users/mark/Projects/xcodeenv/bin/:$PATH
#eval "$(xcenv init -)"

function add_line_if_not_present {
	LINE=$1
	FILE=$2
	grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE" || echo "$LINE" | sudo tee -a "$FILE" > /dev/null
}

add_line_if_not_present "set completion-ignore-case on" "/etc/inputrc"

export PS1='\T ${PWD##*/} $(vcprompt) \$ '

export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

#run this if mate has issues
ln -sf /Applications/TextMate.app/Contents/Resources/mate ~/bin/mate
ln -sf /Applications/GitX.app/Contents/Resources/gitx ~/bin/gitx
ln -sf /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport ~/bin/airport

export EDITOR='mate -w'

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

export HISTFILESIZE=10000
export HISTSIZE=10000

export CLICOLOR=1

ProjectsDir=~/Projects
alias prj='cd $ProjectsDir'

for folder in $ProjectsDir/*; do
  folder_name=`basename $folder`
  [[ -d $folder ]] && alias $folder_name="cd $folder"
done

function aliasifyfolder {
  folder=$1
  folder_name=`basename $folder`
  [[ -d $folder ]] && alias $folder_name="cd $folder"
}

function aliasifysubfolders {
  aliasifyfolder $1
  for folder in $1/*
  do
	  aliasifyfolder $folder
  done
}

function add-alias {
  newAlias="$DIRECTORY/.$1alias"
  touch "$newAlias"
  mate "$newAlias"
}

function notes {
  mate "$DIRECTORY/../notes"
}

for aliasFile in "$DIRECTORY"/.*alias; do
  aliasname=$(basename "$aliasFile")
  [[ $aliasname =~ ^\.(.*)$ ]]
  alias ${BASH_REMATCH[1]}="mate -w \"$aliasFile\"; unalias -a; source ~/.profile"
  source "$aliasFile"
done

alias ralias="unalias -a; source ~/.profile"
alias ealias="mate -w $DIRECTORY; ralias"

alias pushaliases="(cd $DIRECTORY && git commit -a -m \"$(date)\" && git push origin master)"
alias pullaliases="(cd $DIRECTORY && git fetch origin && git reset --hard origin/master)"
