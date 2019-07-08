#!/bin/bash

mkdir -p ~/src
cd ~/src
if [ -d yay ]
then
    cd yay
    git pull
else
    git clone https://aur.archlinux.org/yay.git
    cd yay
fi
makepkg -si --noconfirm
