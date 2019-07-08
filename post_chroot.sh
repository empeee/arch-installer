#!/bin/bash
# Time Zone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Locale
sed -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen > /etc/locale.temp
mv /etc/locale.temp /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname and hosts
echo "hostname" > /etc/hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 hostname.local hostname" >> /etc/hosts

# Reset root password
passwd
