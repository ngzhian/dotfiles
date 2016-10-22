#!/usr/bin/bash

# bash
cp -v ~/dotfiles/.bash_aliases ~/.bash_aliases
cp -v ~/dotfiles/.bashrc ~/.bashrc


# bin
cp -v -r ~/dotfiles/bin ~/.

# vim
cp -v ~/dotfiles/.vimrc ~/.
mkdir -p ~/.vim/colors
cp -rv ~/dotfiles/.vim/colors ~/.vim/

# git
cp -v ~/dotfiles/.gitconfig ~/.
cp -v ~/dotfiles/.gitignore ~/.

# x
cp -v ~/dotfiles/.xinitrc ~/.
cp -v ~/dotfiles/.Xresources ~/.

# tmux
cp -v ~/dotfiles/.tmux.conf ~/.tmux.conf

