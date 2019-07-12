#!/bin/bash

sudo pacman -S --noconfirm xorg-server xorg-apps xorg-xinit
sudo pacman -S --noconfirm feh xcompmgr

mkdir -p ~/src

echo "Installing st from source..."
cd ~/src
if [ -d st ]
then
    cd st
    git pull
else
    git clone https://github.com/empeee/st
    cd st
fi
make
sudo make install
make clean
rm config.h

echo "Installing dwm from source..."
cd ~/src
if [ -d dwm ]
then
    cd dwm
    git pull
else
    git clone https://git.suckless.org/dwm
    cd dwm
fi
make
sudo make install
make clean
rm config.h

echo "Installing dmenu from source..."
cd ~/src
if [ -d dmenu ]
then
    cd dmenu
    git pull
else
    git clone https://git.suckless.org/dmenu
    cd dmenu
fi
make
sudo make install
make clean
rm config.h
