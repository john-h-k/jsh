#!/bin/zsh

ln -sf ~/.zshrc .zshrc

# helix
mkdir -p helix
ln -sf ~/.config/helix/*(.) helix
