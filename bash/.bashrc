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
  # Bash won't get SIGWINCH if another process is in the foreground.
  # Enable checkwinsize so that bash will check the terminal size when
  # it regains control.
  # http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
  shopt -s checkwinsize

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

    if [ "$1" -eq "1" ]; then
      PS1="$B\$(__name_and_server) $Y\w \$(__git_prompt) $W$ $RESET";
    elif [ "$1" -eq "2" ]; then
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

# LS COLORS -------------------------------------------------------------------

  if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dircolors ]] ; then
      eval "$(dircolors -b ~/.dircolors)"
    elif [[ -f /etc/DIR_COLORS ]] ; then
      eval "$(dircolors -b /etc/DIR_COLORS)"
    fi
  fi


# OTHER BASH STUFF LIKE ALIASES, ADDONS, ETC ------------------------------------

  dotfiles_bash_dir=$(dirname $(readlink -f "${HOME}/.bashrc"))

  # Completion
  for f in $(find $dotfiles_bash_dir/completion -type f); do
    source $f
  done

  # Aliases
  if [ -f "$dotfiles_bash_dir/aliases.bash" ]; then
    source "$dotfiles_bash_dir/aliases.bash"
  fi

  # Completion
  for f in $(find $dotfiles_bash_dir/config -type f); do
    source $f
  done

  # Local bashrc
  if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
  fi
fi
