# enable color support of ls and also add handy aliases
alias ..='cd ..'
alias p='pwd'
alias l='ls -CF'

alias psa='pstree -aAl | vim -'

# filter color escape sequences
alias nocolor="sed 's/\x1b\[[0-9;]*m//g'"


# Aliases and utils -------------------------------------------------------

if type -P dircolors >/dev/null ; then
  if [[ -f ~/.dir_colors ]] ; then
    eval $(dircolors -b ~/.dir_colors)
  elif [[ -f /etc/DIR_COLORS ]] ; then
    eval $(dircolors -b /etc/DIR_COLORS)
  fi
fi

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

# if colordiff is installed, use it
if type colordiff &>/dev/null; then
  alias diff=colordiff
fi

# Redirect make output to less
function lmake {
  make 2>&1 | less
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

alias tmux='tmux -2'


# clang
alias clang='clang-3.6'
alias clang-format='clang-format-3.6'


alias cm='codemode'
alias nm='normmode'
