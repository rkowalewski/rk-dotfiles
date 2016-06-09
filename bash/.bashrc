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



# Prompt ------------------------------------------------------------------


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


  alias cm='codemode'
  alias nm='normmode'


  # source all required files

  dotfiles_bash_dir=$(dirname $(readlink -f "$(pwd -P)/.bashrc"))

  if [ -f "$dotfiles_bash_dir/.bashrc.local" ]; then
    source "$dotfiles_bash_dir/.bashrc.local"
  fi

  for f in $(find $dotfiles_bash_dir/completion -type f); do
    source $f
  done

  if [ -f "$dotfiles_bash_dir/aliases.bash" ]; then
    source "$dotfiles_bash_dir/aliases.bash"
  fi
fi
