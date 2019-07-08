#!/bin/bash

if [ -f config.sh ]
then
    source config.sh
else
    DRIVE='/dev/sda'
    HOSTNAME='thishostname'
    USERNAME='thisusername'
    TIMEZONE='America/New_York'
fi

setup() {
    echo "Setting up time..."
    timedatectl set-ntp true

    echo "Generating partitions..."
    parted -s $DRIVE \
        mklabel msdos \
        mkpart primary fat32 0 300M \
        set 1 esp on \
        mkpart primary ext4 300M 20.3G \
        mkpart primary ext4 20.3G 100%

    echo "Formatting partitions..."
    mkfs.fat -F32 "${DRIVE}1"
    mkfs.ext4 "${DRIVE}2"
    mkfs.ext4 "${DRIVE}3"

    echo "Mounting partitions..."
    mount "${DRIVE}2" /mnt
    mkdir /mnt/boot
    mount "${DRIVE}1" /mnt/boot
    mkdir /mnt/home
    mount "${DRIVE}3" /mnt/home

    echo "Installing base packages..."
    pacstrap /mnt base base-devel

    echo "Generating fstab..."
    genfstab -U /mnt >> /mnt/etc/fstab

    echo "Chrooting into installed system to continue setup..."
    cp $0 /mnt/install.sh
    if [ -f config.sh ]
    then
        cp config.sh /mnt/config.sh
    fi


    arch-chroot /mnt ./install.sh chroot

    if [ -f /mnt/install.sh ]
    then
        echo "ERROR: Something failed inside the chroot, not unmounting filesystems so you can investigate."
        echo "Make sure you unmount everything before you try to run this script again."
    else
        echo "Unmounting filesystems..."
        umount /mnt/boot
        umount /mnt/home
        umount /mnt
        echo "Done. Reboot system."
    fi
}

configure() {
    echo "Setting up timezone..."
    ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
    hwclock --systohc

    echo "Setting up locale..."
    sed -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen > /etc/locale.temp
    mv /etc/locale.temp /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf

    echo "Setting up hostname and hosts..."
    echo "${HOSTNAME}" > /etc/hostname
    echo "127.0.0.1 localhost" > /etc/hosts
    echo "::1 localhost" >> /etc/hosts
    echo "127.0.1.1 ${HOSTNAME}.local ${HOSTNAME}" >> /etc/hosts

    echo "Setting root password..."
    passwd

    echo "Installing GRUB with UEFI..."
    pacman -S --noconfirm grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    grub-mkconfig -o /boot/grub/grub.cfg

    echo "Installing NetworkManager..."
    pacman -S --noconfirm networkmanager
    systemctl enable NetworkManager

    echo "Creating user ${USERNAME}..."
    useradd -m -g users -G wheel $USERNAME
    passwd $USERNAME

    echo "Install and setup sudo..."
    pacman -S --noconfirm sudo
    sed -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers > /etc/sudoers.tmp
    mv /etc/sudoers.tmp /etc/sudoers

    echo "Install useful packages..."
    pacman -S --noconfirm vim tmux git arch-audit net-tools ranger
    echo "Cleaning up..."
    rm ./install.sh
    if [ -f /config.sh ]
    then
        rm ./config.sh
    fi
}

if [ "$1" == "chroot" ]
then
    configure
else
    setup
fi
