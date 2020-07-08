DOTFILES="$HOME/.dotfiles"

[[ -e "$DOTFILES/.git" ]] || (
    echo "clone .dotfiles" >&2
    exit 1
)

files=(
  .tmux.conf
  .vimrc
  .bash_aliases
  .agignore
  .inputrc
  .vim/spell/en.utf-8.add
  .vim/spell/en.utf-8.add.spl
  bin/backup-dotfiles.sh
)


# these files are named the same, so just copy them as it is
for f in "${files[@]}"; do
  mkdir -p "$(dirname $DOTFILES/$f)"
  cp "$HOME/$f" "$DOTFILES/$f"
done

# .bashrc gets special treatment
cp "$HOME/.common.bashrc" "$DOTFILES/.bashrc"
