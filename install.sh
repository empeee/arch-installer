#!/bin/bash

DRIVE='/dev/vda'
HOSTNAME='hostname'
USER_NAME='username'
TIMEZONE='America/New_York'
KEYMAP='us'

timedatectl set-ntp true

# Generate partitions
parted -s $DRIVE \
    mklabel msdos \
    mkpart primary fat32 0 300M \
    set 1 esp on \
    mkpart primary ext4 300M 20.3G \
    mkpart primary ext4 20.3G 100%

# Format partitions
mkfs.fat -F32 "${DRIVE}1"
mkfs.ext4 "${DRIVE}2"
mkfs.ext4 "${DRIVE}3"

# Mount partitions
mount "${DRIVE}2" /mnt
mkdir /mnt/boot
mount "${DRIVE}1" /mnt/boot
mkdir /mnt/home
mount "${DRIVE}3" /mnt/home

# Install base packages
pacstrap /mnt base base-devel

# Start configuration
genfstab -U /mnt >> /mnt/etc/fstab
mkdir /mnt/scripts
cp post_chroot.sh /mnt/scripts
arch-chroot /mnt /scripts/post_chroot.sh

