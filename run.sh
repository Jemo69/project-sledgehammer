#!/bin/bash 

./art.sh
echo "automating Jemo setup"

./zshsetup.sh
./installer.sh
./dotfiles.sh