#!/bin/zsh

cp ~/.zshrc .zshrc

# helix
mkdir -p helix
cp ~/.config/helix/*(.) helix

# oh-my-zsh
mkdir -p '.oh-my-zsh/custom'
cp $ZSH_CUSTOM/**/* '.oh-my-zsh/custom'
