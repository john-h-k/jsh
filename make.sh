#!/bin/zsh

cp ~/.zshrc .zshrc

# helix
mkdir -p helix
cp ~/.config/helix/*(.) helix

# oh-my-zsh
mkdir -p '.oh-my-zsh/custom'
cp -LR ~/.oh-my-zsh/custom '.oh-my-zsh/'

cp ~/.gitignore '.gitignore'
cp ~/.gitconfig '.gitconfig'
