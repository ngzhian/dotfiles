#!/bin/bash
# Helper script to backup/restore dotfiles, to keep dev env somewhat *in sync*.

# The rule is that dotfiles are maintained in this directory, and copy pasted from it.
# I prefer this to the bare git repository way, because it is easier to have 2 copies
# that are in conflict, and choose what to include.
DOTFILES="$HOME/.dotfiles"

[[ -e "$DOTFILES/.git" ]] || (
    echo "Please clone .dotfiles into ~." >&2
    exit 1
)

# Poor man associative array...
# Using this because I might want to back up certain files as different names.
# Mapping from "local" to "remote"/backed-up name
files=(
  .tmux.conf .tmux.conf
  .vimrc .vimrc
  .bash_aliases .bash_aliases
  .agignore .agignore
  .inputrc .inputrc
  .vim/spell/en.utf-8.add .vim/spell/en.utf-8.add
  .vim/spell/en.utf-8.add.spl .vim/spell/en.utf-8.add.spl
  bin/backup-dotfiles.sh bin/backup-dotfiles.sh
  bin/dev.sh bin/dev.sh
  bin/gm_completion.sh bin/gm_completion.sh
  bin/git-prompt.sh bin/git-prompt.sh
)

# Check that I did not mess up the files array.
count=${#files[*]}
if [[ $((count % 2)) -ne 0 ]]; then
  echo "Wrong number of files specified in 'files'." >&2
  exit 1
fi

# Diff local dotfiles and backed up files
diff_files() {
  local i=0
  while [[ i -lt count ]]; do
    from=$i
    to=$((i+1))
    diff -u "$HOME/${files[from]}" "$DOTFILES/${files[to]}"
    i=$((i+2))
  done
}

# Backup local dotfiles into $DOTFILES.
backup() {
  local i=0
  while [[ i -lt count ]]; do
    from=$i
    to=$((i+1))
    cp "$HOME/${files[from]}" "$DOTFILES/${files[to]}"
    i=$((i+2))
  done
}

# Restore $DOTFILES to local dotfiles.
restore() {
  i=0
  while [[ i -lt count ]]; do
    from=$((i+1))
    to=$i
    cp "$DOTFILES/${files[from]}" "$HOME/${files[to]}"
    i=$((i+2))
  done
}

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 [ --backup | --restore ]"
  exit 0
fi

if [[ $1 = "--diff" ]]; then
  diff_files
elif [[ $1 = "--backup" ]]; then
  backup
elif [[ $1 = "--restore" ]]; then
  restore
fi

# .bashrc gets special treatment
# cp "$HOME/.common.bashrc" "$DOTFILES/.bashrc"
