#! /bin/bash


# The purpose of the script is to quickly deploy the system

echo 'The author of this script is Anton'
echo 'Nickname on github Greenwood1'

echo 'Creating partitions'
(
 echo g;

 echo n;
 echo;
 echo;
 echo +500M;
 echo y;
 echo t;
 echo 1;

 echo n;
 echo;
 echo;
 echo +50G;
 echo y;

 echo n;
 echo;
 echo;
 echo;
 echo y;

 echo w;
 ) | fdisk /dev/sda

echo 'Your disk layout'
 fdisk -l 

echo 'Formatting disks'

 mkfs.fat -F32 /dev/sda1
 mkfs.ext4 /dev/sda2
 mkfs.ext4 /devsda3 

echo 'Mounting disks'

 mount /dev/sda2 /mnt
 mkdir /mnt/home
 mkdir -p /mnt/boot/efi
 mount /dev/sda1 /mnt/boot/efi
 mount /dev/sda3 /mnt/home

echo 'Select mirrors to download'

 rm -rf /etc/pacman.d/mirrorlist
 wget https://git.io/mirrorlist
 mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

echo 'Installing core packages'

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

