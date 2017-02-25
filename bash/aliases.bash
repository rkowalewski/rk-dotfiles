# enable color support of ls and also add handy aliases
alias ..='cd ..'
alias p='pwd'
alias l='ls -CF'

alias psa='pstree -aAl | vim -'

# filter color escape sequences
alias nocolor="sed 's/\x1b\[[0-9;]*m//g'"


# Aliases and utils -------------------------------------------------------

alias ls='ls --color=auto'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias vl='ls --color=auto --format=long'
alias ll='ls -alGh --color=auto --format=long'
alias la='ls -lash --color=auto --format=long'
alias cls='clear'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias dmesg='dmesg --color'
alias less='less -M'

# if colordiff is installed, use it
if type colordiff &>/dev/null; then
  alias diff=colordiff
fi

# Redirect make output to less
function lmake {
  script -c "make $@ 2>&1" /dev/null < /dev/null |& less -R
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i \
               "$([ $? = 0 ] && echo terminal || echo error)" \
               "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Git aliases
alias Gr='git remote -v'
alias Ga='git add'
alias Gp='git push'
alias Gc='git commit'
alias Gs='git status'
alias Gb='git branch'
alias Gi='git remote -v && echo "===" && git branch && echo "===" && git status'

alias cm='codemode'
alias nm='normmode'
