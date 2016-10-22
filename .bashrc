# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

source ~/.git-prompt.sh
# from https://wiki.archlinux.org/index.php/Color_Bash_Prompt
P_Black='\[\e[30m\]'
P_Blue='\[\e[36m\]'
P_Red='\[\e[31m\]'
P_Green='\[\e[32m\]'
P_Reset='\[\e[00m\]'
TOP="${P_Black}┌$P_Reset"
BOTTOM="${P_Black}└$P_Reset "
set_prompt () {
  Last_Command=$? # Must come first!
  PS1=
  PS1+="$TOP"
  # If it was successful, print a green check mark. Otherwise, print
  # a red X.
  if [[ $Last_Command == 0 ]]; then
    PS1+="──$P_Green "
  else
    PS1+=" $P_Red\$? "
  fi
  # If root, just print the host in red. Otherwise, print the current user
  # and host in green.
  if [[ $EUID == 0 ]]; then
    PS1+="$P_Red\\h "
  else
    PS1+="$P_Green\\u "
  fi
  # Print the working directory and prompt marker in blue, and reset
  # the text color to the default.
  PS1+="$P_Blue\\W$P_Reset\$(__git_ps1 \" (%s)\") $P_Blue\n$BOTTOM\\\$$P_Reset "
}

PROMPT_COMMAND='set_prompt'
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ls='ls -G'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export EDITOR=vim

export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM=1

up () {
  if [ "$#" -eq 0 ]; then
    cd ..
  else
    TIMES=$1
    while [ $TIMES -gt 0 ]; do
      cd ..
      let TIMES=TIMES-1
    done
  fi
}

# ssh
SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
function start_agent {
  echo "Initializing new SSH agent..."
  # spawn ssh-agent
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

genctags() {
    ctags --recurse --exclude=idl --exclude=migrations --exclude=*.json --exclude=*.js --exclude=*.css --exclude=*.scss --exclude=*.less --exclude=*.JSON
}

export NVM_DIR="/Users/ngzhian/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -f .secrets ]; then
  source .secrets
fi

###-tns-completion-start-###
if [ -f /Users/ngzhian/.tnsrc ]; then
    source /Users/ngzhian/.tnsrc
fi
###-tns-completion-end-###

# to manage dotfiles
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
