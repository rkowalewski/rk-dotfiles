# enable color support of ls and also add handy aliases
alias ..='cd ..'
alias p='pwd'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias l='ls -CF'
alias vl='ls --color=auto --format=long'
alias ll='ls -alGh --color=auto --format=long'
alias la='ls -lash --color=auto --format=long'
alias cls='clear'

alias psa='pstree -aAl'

# filter color escape sequences
alias nocolor="sed 's/\x1b\[[0-9;]*m//g'"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && \
      eval "$(dircolors -b ~/.dircolors)" || \
      eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases and utils -------------------------------------------------------

# Redirect make output to less
function lmake {
  make 2>&1 | less
}


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i \
               "$([ $? = 0 ] && echo terminal || echo error)" \
               "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


alias psa='pstree -aAl | vim -'

# filter color escape sequences
alias nocolor="sed 's/\x1b\[[0-9;]*m//g'"

# Git aliases
alias Gr='git remote -v'
alias Gs='git status'
alias Gb='git branch'
alias Gi='git remote -v && echo "===" && git branch && echo "===" && git status'

