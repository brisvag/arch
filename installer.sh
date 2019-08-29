#!/bin/bash

# Installer script for arch-linux
# Based on brisvag's script at https://github.com/brisvag/arch-pkgs

# run with: curl -sL https://git.io/brisvag-arch | bash

# raise error on undefined variables and properly handle errorcodes in pipes
set -uo pipefail
# trap errors and tell some more info about it; then exit
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
# separators used to split sequences: remove space and keep \t and \n
IFS=$'\n\t'

# idiot-proof stop-step
dialog --stdout --yesno "This script might erase your drive and kill your dog.
                         Are you sure you want to continue?" 0 0 || exit 1
clear

#####################################################

# hardcoded variables
mirrorlist="https://www.archlinux.org/mirrorlist/all/"

# set ntp as active
timedatectl set-ntp true

## necessary for rankmirrors
#pacman -Sy --noconfirm pacman-contrib
#
## get mirrorlist backup (this way, if script is interrupted, no need to reboot)
#curl -s "${mirrorlist}" | sed -e 's/^#Server/Server/' -e '/^#/d' > /etc/pacman.d/mirrorlist.bak
#
## update mirrorlist
#echo "Updating mirror list"
#rankmirrors -n 10 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist

#####################################################

# require several inputs for configuration
dryrun=$(dialog --stdout --menu "Is this a dry run?" 0 0 0 \
         "Yes" "Fake the run and show me what you'll do" \
         "No" "Do your thing") || exit 1
clear

hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

user=$(dialog --stdout --inputbox "Enter username" 0 0) || exit 1
clear
: ${user:?"user cannot be empty"}

password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( echo "Passwords did not match"; exit 1; )

format_disk=$(dialog --stdout --no-tags --menu "Do you want to wipe and format a disk?" 0 0 0 \
              0 "Yes, I'll choose a disk to be completely wiped." \
              1 "No, format a whole partition. It will be divided in all the necessary partitions." \
              2 "No, I have partitions ready. (You will be prompted to choose which one is which)") || exit 1
clear

case ${format_disk} in
  # yes. Disk will be wiped, formatted and linux installed
  0)
    devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop|rom" | \
                 awk '{print $1"\t"$2}' | tac)
    device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1
    clear
    makehome=$(dialog --stdout --yesno "Do you want to create a home partition?" 0 0)
    clear
    makeswap=$(dialog --stdout --yesno "Do you want to create a swap partition?" 0 0)
    clear
    ;;
  # no. Choose one partition to be wiped
  1)
    devicelist=$(lsblk -plnx size -o name,size,mountpoint | grep -Ev "boot|rpmb|loop|rom" | \
                 awk '{if ($3=="") {$3="-"}; print $1"\t"$2"    "$3}' | tac)
    device=$(dialog --stdout --menu "Select installation partition" 0 0 0 ${devicelist}) || exit 1
    clear
    makehome=$(dialog --stdout --yesno "Do you want to create a home partition?" 0 0)
    clear
    makeswap=$(dialog --stdout --yesno "Do you want to create a swap partition?" 0 0)
    clear
    ;;
  # no. Choose partitions one by one.
  2)
    devicelist=$(lsblk -plnx size -o name,size,mountpoint | grep -Ev "boot|rpmb|loop|rom" | \
                 awk '{if ($3=="") {$3="-"}; print $1"\t"$2"    "$3}' | tac)
    rootpart=$(dialog --stdout --menu "Select root partition" 0 0 0 ${devicelist}) || exit 1
    clear
    bootpart=$(dialog --stdout --menu "Select boot partition" 0 0 0 ${devicelist}) || exit 1
    clear
    homepart=$(dialog --stdout --menu "Select home partition, if you want it" 0 0 0 ${devicelist})
    # if cancel is pressed, don't create a home partition
    nohome=$?
    [[ ${nohome} -eq 0 ]] || [[ ${nohome} -eq 1 ]] || exit 1
    clear
    swappart=$(dialog --stdout --menu "Select swap partition, if you want it" 0 0 0 ${devicelist})
    # if cancel is pressed, don't create a swap partition
    noswap=$?
    [[ ${noswap} -eq 0 ]] || [[ ${noswap} -eq 1 ]] || exit 1
    clear
esac
clear

# if dryrun answer was yes (or KeyboardInterrupt), exit
if [[ ${dryrun} == "Yes" ]]; then
  exit 1
fi

#####################################################

# start some decent logging, cause the real suff starts here
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

boot_size=512
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
root_size=20480

case ${format_disk} in
  # yes. Disk will be wiped, formatted and linux installed
  0)
    # create gpt table
    gptcommand="mklabel gpt"
    makebootcommand="mkpart EDP fat32 0% ${boot_size}MiB set 1 boot on"
    if [[ ${makeswap} -eq 0 ]]; then
      makeswapcommand="mkpart primary linux-swap ${boot_size}MiB ${swap_size}MiB"
      root_start=$((${boot_size} + ${swap_size}))
    else
      root_start=${boot_size}
    fi
    if [[ ${makehome} -eq 0 ]]; then
      root_end=$((${root_start} + ${root_size}))
      makerootcommand="mkpart primary ext4 ${root_start}MiB ${root_end}MiB"
      makehomecommand="mkpart primary ext4 ${root_end}MiB 100%"
    else
      makerootcommand="mkpart primary ext4 ${root_start}MiB 100%"
    fi
    ;;
  1)
    echo "nothing"
esac

parted --script ${device} -- gptcommand \
${makebootcommand} \
${makeswapcommand} \
${makerootcommand} \
${makehomecommand}

#    parted --script "${device}" -- mklabel gpt \
#      mkpart ESP fat32 0 129MiB \
#      set 1 boot on \
#      mkpart primary linux-swap 129MiB ${swap_end} \
#      mkpart primary ext4 ${swap_end} 100%

## Simple globbing was not enough as on one device I needed to match /dev/mmcblk0p1
## but not /dev/mmcblk0boot1 while being able to match /dev/sda1 on other devices.
#part_boot="$(ls ${device}* | grep -E "^${device}p?1$")"
#part_swap="$(ls ${device}* | grep -E "^${device}p?2$")"
#part_root="$(ls ${device}* | grep -E "^${device}p?3$")"

#wipefs "${part_boot}"
#wipefs "${part_swap}"
#wipefs "${part_root}"

#mkfs.vfat -F32 "${part_boot}"
#mkswap "${part_swap}"
#mkfs.f2fs -f "${part_root}"

#swapon "${part_swap}"
#mount "${part_root}" /mnt
#mkdir /mnt/boot
#mount "${part_boot}" /mnt/boot

#### Install and configure the basic system ###
#cat >>/etc/pacman.conf <<EOF
#[brisvag]
#SigLevel = Optional TrustAll
#Server = $REPO_URL
#EOF

#pacstrap /mnt brisvag-desktop
#genfstab -t PARTUUID /mnt >> /mnt/etc/fstab
#echo "${hostname}" > /mnt/etc/hostname

#cat >>/mnt/etc/pacman.conf <<EOF
#[brisvag]
#SigLevel = Optional TrustAll
#Server = $REPO_URL
#EOF

#arch-chroot /mnt bootctl install

#cat <<EOF > /mnt/boot/loader/loader.conf
#default arch
#EOF

#cat <<EOF > /mnt/boot/loader/entries/arch.conf
#title    Arch Linux
#linux    /vmlinuz-linux
#initrd   /initramfs-linux.img
#options  root=PARTUUID=$(blkid -s PARTUUID -o value "$part_root") rw
#EOF

#echo "LANG=en_GB.UTF-8" > /mnt/etc/locale.conf

#arch-chroot /mnt useradd -mU -s /usr/bin/zsh -G wheel,uucp,video,audio,storage,games,input "$user"
#arch-chroot /mnt chsh -s /usr/bin/zsh

#echo "$user:$password" | chpasswd --root /mnt
#echo "root:$password" | chpasswd --root /mnt
