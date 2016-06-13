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

  function __name_and_server {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
      echo "`whoami`@`hostname -s`"
    fi
  }

  function __git_prompt {
    GIT_PS1_SHOWDIRTYSTATE=1
    [ `git config user.pair` ] && GIT_PS1_PAIR="`git config user.pair`@"
    __git_ps1 "($GIT_PS1_PAIR%s)" | sed 's/ \([+*]\{1,\}\)$/\1/'
  }


  function bash_prompt
  {
    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white

    # emphasized (bolded) colors
    local BK="\[\033[1;30m\]"
    local BR="\[\033[1;31m\]"
    local BG="\[\033[1;32m\]"
    local BY="\[\033[1;33m\]"
    local BB="\[\033[1;34m\]"
    local BM="\[\033[1;35m\]"
    local BC="\[\033[1;36m\]"
    local BW="\[\033[1;37m\]"

    # reset
    local RESET="\[\033[0;0m\]"
    norm="norm"

    if [ "$1" -eq "1" ]; then
      echo "switching to norm"
      PS1="$B\$(__name_and_server) $Y\w \$(__git_prompt) $W$ $RESET";
    elif [ "$1" -eq "2" ]; then
      echo "switching to code"
      PS1="$Y\W \$(__git_prompt) $W$ $RESET";
    fi
  }

  function codemode
  {
    bash_prompt 2
  }
  function normmode
  {
    bash_prompt 1
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

  dotfiles_bash_dir=$(dirname $(readlink -f "${HOME}/.bashrc"))

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
