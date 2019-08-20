#!/usr/bin/env bash

# Installer script for arch-linux
# Based on mdaffin's script at https://github.com/mdaffin/arch-pkgs

# run with: curl -sL https://git.io/brisvag-arch | bash

# raise error on undefined variables and properly handle errorcodes in pipes
set -uo pipefail
# trap errors and tell some more info about it; then exit
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
# separators used to split sequences: remove space and keep \t and \n
IFS=$'\n\t'

# idiot-proof stop-step
echo "This script will erase your drive and kill your family."
echo "Are you sure you want to continue? (yes/no)"
read sure
if [[ "${sure}" != "yes" ]]; then
  exit 1
fi

#####################################################

# hardcoded variables
mirrorlist="https://www.archlinux.org/mirrorlist/all/"

# set ntp as active
timedatectl set-ntp true

# necessary for rankmirrors
pacman -Sy --noconfirm pacman-contrib

# update mirrorlist
echo "Updating mirror list"
curl -s "${mirrorlist}" | \
  sed -e 's/^#Server/Server/' -e '/^#/d' | \
  rankmirrors -n 10 > /etc/pacman.d/mirrorlist

#####################################################

# require input for configuration
dryrun=$(dialog --stdout --inputbox "Is this a dry run? (yes/no)" 0 0) || exit 1
clear
: ${dryrun:?"dryrun cannot be empty"}

hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

User=$(dialog --stdout --inputbox "Enter username" 0 0) || exit 1
Clear
: ${user:?"user cannot be empty"}

password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( echo "Passwords did not match"; exit 1; )

devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
device=$(dialog --stdout --menu "Select installtion disk" 0 0 0 ${devicelist}) || exit 1
clear

if [[ ${dryrun} != "no" ]]; then
  exit 1

#####################################################

# start some decent logging, cause the real suff starts here
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

# setup the disk and partitions
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
swap_end=$(( $swap_size + 129 + 1 ))MiB

parted --script "${device}" -- mklabel gpt \
  mkpart ESP fat32 1Mib 129MiB \
  set 1 boot on \
  mkpart primary linux-swap 129MiB ${swap_end} \
  mkpart primary ext4 ${swap_end} 100%

# Simple globbing was not enough as on one device I needed to match /dev/mmcblk0p1
# but not /dev/mmcblk0boot1 while being able to match /dev/sda1 on other devices.
part_boot="$(ls ${device}* | grep -E "^${device}p?1$")"
part_swap="$(ls ${device}* | grep -E "^${device}p?2$")"
part_root="$(ls ${device}* | grep -E "^${device}p?3$")"

wipefs "${part_boot}"
wipefs "${part_swap}"
wipefs "${part_root}"

mkfs.vfat -F32 "${part_boot}"
mkswap "${part_swap}"
mkfs.f2fs -f "${part_root}"

swapon "${part_swap}"
mount "${part_root}" /mnt
mkdir /mnt/boot
mount "${part_boot}" /mnt/boot

### Install and configure the basic system ###
cat >>/etc/pacman.conf <<EOF
[mdaffin]
SigLevel = Optional TrustAll
Server = $REPO_URL
EOF

pacstrap /mnt mdaffin-desktop
genfstab -t PARTUUID /mnt >> /mnt/etc/fstab
echo "${hostname}" > /mnt/etc/hostname

cat >>/mnt/etc/pacman.conf <<EOF
[mdaffin]
SigLevel = Optional TrustAll
Server = $REPO_URL
EOF

arch-chroot /mnt bootctl install

cat <<EOF > /mnt/boot/loader/loader.conf
default arch
EOF

cat <<EOF > /mnt/boot/loader/entries/arch.conf
title    Arch Linux
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  root=PARTUUID=$(blkid -s PARTUUID -o value "$part_root") rw
EOF

echo "LANG=en_GB.UTF-8" > /mnt/etc/locale.conf

arch-chroot /mnt useradd -mU -s /usr/bin/zsh -G wheel,uucp,video,audio,storage,games,input "$user"
arch-chroot /mnt chsh -s /usr/bin/zsh

echo "$user:$password" | chpasswd --root /mnt
echo "root:$password" | chpasswd --root /mnt
