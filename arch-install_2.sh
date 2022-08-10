#!/bin/bash

read -p "Enter computer name: " hostname 
read -p "Enter username: " username

echo 'Entering the computer name'
echo $hostname > /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime

echo 'Adding the system locale'

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen

echo 'Update the current system locale'
locale-gen

#echo 'Specify the system language'
#echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Create a bootable RAM disk'
mkinitcpio -p linux

echo 'Installing the bootloader'

pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install /dev/sda

echo 'Update grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

#We put a utility for motherboards that support a wireless network
#echo 'Ставим программу для Wi-fi'
#pacman -S dialog wpa_supplicant --noconfirm 


echo 'Adding a user'
useradd -m -g users -G wheel -s /bin/bash $username

echo 'Create a root password: '
passwd

echo 'Set user password: '
passwd $username

echo 'Set SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo "Let's uncomment the multilib repository For running 32-bit applications on a 64-bit system"
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo 'We install X and drivers'
pacman -Sy xorg-server xorg-drivers xorg-xinit

echo 'Install the display manager'
pacman -S lxdm --noconfirm
systemctl enable lxdm

echo 'We put fonts'
pacman -S ttf-liberation ttf-dejavu --noconfirm

echo 'We put the network'
pacman -S networkmanager network-manager-applet ppp --noconfirm

echo 'We connect autoloading of the login manager and the Internet'
systemctl enable NetworkManager

exit

echo 'Installation complete. The computer will reboot in 60 seconds...'

reboot



