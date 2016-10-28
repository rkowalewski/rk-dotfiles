# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If running interactively, then:
if [ "$PS1" ]; then

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

  . $HOME/dotfiles/bash/.bash_prompt

  function codemode
  {
    bash_prompt 2
  }
  function normmode
  {
    bash_prompt 1
  }

#  normmode


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
    if command -v xset >/dev/null 2>&1; then
      xset b off
    fi

    # if command -v setxkbmap >/dev/null 2>&1; then
      # no dead keys
    #  setxkbmap -variant "nodeadkeys"
    #fi
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
