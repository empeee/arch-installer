#!/bin/bash

DRIVE = '/dev/sda'
HOSTNAME = 'hostname'
USER_NAME = 'username'
TIMEZONE = 'America/New_York'
KEYMAP = 'us'

timedatectl set-ntp true

parted -s $DRIVE \
    mklabel msdos \
    mkpart primary fat32 0 300M \
    set 1 esp on
    mkpart primary ext4 300M 20.3G \
    mkpart primary ext4 20.3G 100%

mkfs.fat -F32 "${DRIVE}1"
mkfs.ext4 "${DRIVE}2"
mkfs.ext4 "${DRIVE}3"
