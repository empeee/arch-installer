#!/bin/bash

sudo pacman -S --noconfirm xorg-server xorg-apps xorg-xinit

mkdir -p ~/src

echo "Installing st source..."
cd ~/src
git clone https://git.suckless.org/st
cd st
make
sudo make install
make clean
rm config.h

echo "Installing dwm from source..."
cd ~/src
git clone https://git.suckless.org/dwm
cd dwm
make
sudo make install
make clean
rm config.h

echo "Installing dmenu from source..."
cd ~/src
git clone https://git.suckless.org/dmenu
cd dmenu
make
sudo make install
make clean
rm config.h
