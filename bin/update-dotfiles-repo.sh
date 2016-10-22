#!/usr/bin/bash
# bin
cp -rv ~/bin ~/dotfiles/.

# bash
cp -v ~/.bash_aliases ~/dotfiles/.
cp -v ~/.bashrc ~/dotfiles/.

# vim
#cp -r ~/.vim ~/dotfiles/.
cp -rv ~/.vim/colors ~/dotfiles/.vim/.
cp -v ~/.vimrc ~/dotfiles/.

# git
cp -v ~/.gitconfig ~/dotfiles/.
cp -v ~/.gitignore ~/dotfiles/.

# wm
# cp -v ~/.xmobarrc ~/dotfiles/.
# cp -v ~/.xmonad/xmonad.hs ~/dotfiles/.xmonad/xmonad.hs

# x
cp -v ~/.xinitrc ~/dotfiles/.
cp -v ~/.Xresources ~/dotfiles/.

# tmux
cp -v ~/.tmux.conf ~/dotfiles/.
