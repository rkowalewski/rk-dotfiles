# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If running interactively, then:
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    xterm*)
        if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
            PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
        else
            PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
        fi
        ;;
    screen)
        if [ -e /etc/sysconfig/bash-prompt-screen ]; then
            PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
        else
            PROMPT_COMMAND='printf "\033]0;%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
        fi
        ;;
    *)
        [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
        ;;
      esac
  fi
  # Turn on checkwinsize
  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "

  export HOSTALIASES=~/.hosts

  # don't put duplicate lines in the history. See bash(1) for more options
  export HISTCONTROL=ignoreboth
  # append to history file, don't overwrite
  shopt -s histappend
  HISTSIZE=1000
  HISTFILESIZE=2000

  export EDITOR=vim

  # make less more friendly for non-text input files, see lesspipe(1)
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  export CLASSPATH=/usr/share/java/servlet-2.3.jar:$CLASSPATH
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/:/usr/local/lib/
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/mpich-3.1/lib/
  export INCLUDE_PATH=$INCLUDE_PATH:/usr/include/postgresql:/usr/local/include/:/usr/include/
  export PATH=~/bin:~/opt/bin:$PATH
  export HOSTALIASES=~/.hosts
  export MKLROOT=/opt/intel/composer_xe_2013_sp1.2.144/mkl/
  export INTELROOT=/opt/intel/

# Prompt ------------------------------------------------------------------

  # enable color support of ls and also add handy aliases
  alias ..='cd ..'
  alias p='pwd'
  alias dir='ls --color=auto --format=vertical'
  alias vdir='ls --color=auto --format=long'
  alias l='ls -CF'
  alias vl='ls --color=auto --format=long'
  alias ll='ls -alGh --color=auto --format=long'
  alias la='ls -lash --color=auto --format=long'

  alias psa='pstree -aAl'

  # filter color escape sequences
  alias nocolor="sed 's/\x1b\[[0-9;]*m//g'"

  PS1='\u@\h:\w\$ '

  function exitcode
  {
      EXIT_CODE=$?
      if [ $EXIT_CODE != 0 ]
        then echo "[$EXIT_CODE]"
      fi
  }
  function codemode
  {
      PS1='\[\033[0;32m\]\[\033[0;31m\]$(exitcode)\[\033[0;36m\](\W) \[\033[0;37m\]$\[\033[0m\] ';
  }
  function normmode
  {
      PS1='\[\033[0;32m\]$HOSTNAME \[\033[0;33m\]$(exitcode)\[\033[0;36m\]$(pwd) \[\033[0;37m\]$\[\033[0m\] '
  }
  normmode

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

  function gdiff() {
      git diff --no-ext-diff
  }

# SSH agent ---------------------------------------------------------------

  SSH_ENV="$HOME/.ssh/environment"
  function start_agent {
      echo "Initialising new SSH agent..."
      /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
      echo succeeded
      chmod 600 "${SSH_ENV}"
      . "${SSH_ENV}" > /dev/null
      /usr/bin/ssh-add
  }
  if [ -f "${SSH_ENV}" ]; then
      . "${SSH_ENV}" > /dev/null
      #ps ${SSH_AGENT_PID} doesn't work under cywgin
      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
          start_agent;
      }
  else
      start_agent;
  fi

# Locales -----------------------------------------------------------------

  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8

  # X11 settings
  #
  if [ -n "$DISPLAY"  ]; then
    # deactivae Xorg system bell
    xset b off
    if command -v setxkbmap >/dev/null 2>&1; then
      # no dead keys
      setxkbmap -variant "nodeadkeys"
    fi
    # Fix backspace
    if command -v loadkeys >/dev/null 2>&1; then
      echo "keycode 14 = BackSpace" | loadkeys >/dev/null 2>&1
    fi
  fi

# Aliases and utils -------------------------------------------------------

  # Redirect make output to less
  function lmake {
    make 2>&1 | less
  }

  alias cm='codemode'
  alias nm='normmode'

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
fi
