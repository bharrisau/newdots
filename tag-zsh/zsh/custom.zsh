# Default editor
EDITOR=vim
export EDITOR

# Default browser
BROWSER=firefox
export BROWSER

# Ledger file
LEDGER=~/doc/bank/personal.dat
export LEDGER

# ls colours
LS_COLORS='ow=37;42'
export LS_COLORS

# Some aliases

# ZMV for mass renaming
autoload -Uz zmv

# History options
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=20000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Don't clobber files when redirecting stdout
setopt NOCLOBBER
setopt HIST_ALLOW_CLOBBER

# Change word separator
autoload -U select-word-style
select-word-style bash

#export PATH
# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
# export EDITOR='vim'
#else
# export EDITOR='vim'
#fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# ssh agent
#if [ -f "${HOME}/.ssh-agent-info" ]; then
#  . "${HOME}/.ssh-agent-info"
#fi

# added by travis gem
[ -f /home/ben/.travis/travis.sh ] && source /home/ben/.travis/travis.sh

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

wiki() {
    curl -s -G 'http://en.wikipedia.org/w/api.php?continue=&action=query&prop=extracts&exintro=&explaintext=&format=json&redirects' --data-urlencode titles="$*" | jq -r '.query.pages[].extract' | fold -s -w 80
}

TIME_SHEET=time_sheet.tsv

function inn() {
    if [[ ! -f $TIME_SHEET || "$(tail -n 1 $TIME_SHEET)" =~ ^STOP.* ]];
    then echo -e "START\t$(date)" >> $TIME_SHEET;
         tail -n 1 $TIME_SHEET;
    else echo "already inn!";
    fi
}

function out() {
    tail -n 1 $TIME_SHEET;
    if [[ "$(tail -n 1 $TIME_SHEET)" =~ ^START.* ]];
    then echo -e "STOP\t$(date)" >> $TIME_SHEET;
         tail -n 1 $TIME_SHEET;
    else echo "not inn!";
    fi
}
