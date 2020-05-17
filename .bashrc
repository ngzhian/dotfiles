# vim: filetype=sh
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# shell options {{{
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# add to history
shopt -s histappend
# lines beginning with space are not saved
# lines matching previous history are not saved
# previous lines matching current line are removed
export HISTCONTROL=ignorespace:ignoredups:erasedups

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
# }}}

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

[ -f ~/bin/git-prompt.sh ] && source ~/bin/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1 # show unstaged (*) and staged changes (+)
GIT_PS1_SHOWSTASHSTATE=1 # show stash status ($)
GIT_PS1_SHOWUNTRACKEDFILES=1 # show untracked files (%)

# from https://wiki.archlinux.org/index.php/Color_Bash_Prompt
P_RESET='\[\e[00m\]'
P_BLACK='\[\e[30m\]'
P_RED='\[\e[31m\]'
P_GREEN='\[\e[32m\]'
P_BLUE='\[\e[36m\]'
P_WHITE='\[\e[37m\]'
P_DIM='\[\e[3m\]'
TOP="${P_BLACK}┌$P_RESET"
BOTTOM="${P_BLACK}└$P_RESET "
set_prompt () {
  last_exit=$? # Must come first!
  PS1="$TOP"
  # If it was successful, print a green check mark. Otherwise, print
  # a red X.
  if [[ $last_exit == 0 ]]; then
    PS1+="──$P_GREEN$P_RESET "
  else
    PS1+=" $P_RED$last_exit$P_RESET "
  fi
  DATE=$(date +%H:%M)
  PS1+="$DATE "
  # If root, just print the host in red. Otherwise, print the current user
  # and host in green.
  if [[ $EUID == 0 ]]; then
    PS1+="$P_RED\\h "
  else
    PS1+="$P_GREEN" # experiment to not show username, i know who i am, root is diff bashrc
  fi
  # Print the working directory and prompt marker in blue, and reset
  # the text color to the default.
  # chromium is too large, slows down the prompt
  if [[ $(pwd) =~ chromium ]]; then
      PS1+="$P_BLUE\\w$P_RESET $P_BLUE$P_WHITE\n"
  else
      PS1+="$P_BLUE\\w$P_RESET $P_BLUE$P_WHITE$(__git_ps1 "(%s)")\n"
  fi
  PS1+="$BOTTOM\\\$$P_RESET "
}

PROMPT_COMMAND='set_prompt'
# }}}

# fzf {{{
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# use ag for fzf's default command so that .gitignore is respected
export FZF_DEFAULT_COMMAND='ag -l'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# }}}

# aliases {{{
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# }}}

# utility functions {{{
function up () {
  path=$(pwd)
  if [ "$#" -eq 0 ]; then
    cd "$path/.."
  else
    TIMES=$1
    path+="/"
    while [ "$TIMES" -gt 0 ]; do
      path+="../"
      let TIMES=TIMES-1
    done
    cd "$path"
  fi
}

# dev {{{
source $HOME/bin/dev.sh
# }}}

# watch a directory recursively for changes then run a command
function watchandbuild() {
  dir=$1
  shift
  while inotifywait -r "$dir" -e modify; do
      $*
    done;
}

# chrome/v8/d8/wasm {{{
export PATH=$HOME/ssd2/wabt/bin:$HOME/ssd1/depot_tools:$HOME/ssd1/v8/v8/tools/dev:$PATH

function sync-chromium() {
  set -x
  if ! dev chromium; then
    echo "Failed to cd"
    set +x
    return
  fi

  if ! git rebase-update; then
    echo "Failed to rebase"
    set +x
    return
  fi

  gclient sync -D

  if [[ ! -e out/ia32-liftoff-fuzz ]]; then
    gn gen out/ia32-liftoff-fuzz
    gn args out/ia32-liftoff-fuzz --args="use_goma=true enable_nacl=false blink_symbol_level=0 use_libfuzzer=true is_asan=true is_lsan=true"
  fi
  autoninja -C out/ia32-liftoff-fuzz v8_wasm_compile_fuzzer

  if [[ ! -e out/Default ]]; then
    gn gen out/Default
    gn args out/Default --args="use_goma=true enable_nacl=false blink_symbol_level=0"
  fi
  autoninja -C out/Default/ chrome

  if [[ -e out/x64-fuzz ]]; then
    autoninja -C out/x64-fuzz v8_wasm_compile_fuzzer
  fi

  if [[ -e out/arm64-fuzz ]]; then
    autoninja -C out/arm64-fuzz v8_wasm_compile_fuzzer
  fi

  set +x
}

# bash completion for d8
[[ -e ~/v8 ]] && source ~/v8/tools/bash-completion.sh
# bash completion for gclient and git cl
source "$(type -P gclient_completion.sh)"
source "$(type -P git_cl_completion.sh)"

# home-made completion for `gm`, works for already built targets, and test targets
#  - cctest
#  - mjsunit
#  - inspector
# with fzf support when trying to complete "**" (source after fzf)
source "$(type -P gm_completion.sh)"
# }}}

# dotfiles management {{{
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
# prerequisite:
# git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# and optionally:
# config config --local status.showUntrackedFiles no
# }}}
