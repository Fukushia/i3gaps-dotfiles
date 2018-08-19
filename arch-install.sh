#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
devBase=$1

if [[ $# -eq 0 ]]; then
  echo "plz insert the device name"
  exit 1
fi

if [[ `ping archlinux.org -c 1` ]]; then
  echo "network ok"
else
  echo "network fail"
  exit 1
fi

preChroot() {
loadkeys us-acentos
timedatectl set-ntp true

sgdisk --zap-all "$devBase"
partprobe "$devBase"

# MORE IN: https://fitzcarraldoblog.wordpress.com/2017/02/10/partitioning-hard-disk-drives-for-bios-mbr-bios-gpt-and-uefi-gpt-in-linux/

# typecodes:
# ef02 -> EFI System
# 8304 -> Linux x86-64 root
# 8305 -> Linux ARM64 root
# 8200 -> Linux swap
# 8302 -> Linux /home

sgdisk -o "$devBase"
sgdisk --new=0:0:+550M --typecode=0:ef02 "$devBase"
sgdisk --new=1:0:+32G --typecode=1:8305 "$devBase"
sgdisk --new=2:0:+12G --typecode=2:8200 "$devBase"
sgdisk --new=3:0:+80G --typecode=3:8302 "$devBase"

mkfs.vfat "$devBase"1
mkfs.ext4 "$devBase"2
mkswap "$devBase"3
swapon "$devBase"3
mkfs.ext4 "$devBase"4

mount "$devBase"2 /mnt
mkdir -p /mnt/boot
mount "$devBase"1 /mnt/boot
mkdir -p /mnt/home
mount "$devBase"4 /mnt/home

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab

mkdir -p /mnt/chroot
cp $SCRIPT /mnt/chroot/arch-install.sh
arch-chroot /mnt /usr/bin/bash /chroot/arch-install.sh $devBase --chroot
}

posChroot() {
  ln -sf /usr/share/zoneinfo/Brazil/East /etc/localtime
  hwclock --systohc # Para gerar o /etc/adjtime // ele assume que o relogio do hardware é UTC

  echo "LANG=en_US.UTF-8" >> /etc/locale.conf
  echo "KEYMAP=us-acentos" >> /etc/vconsole.conf
  echo "en_US.UTF=8 UTF-8" >> /etc/locale.gen
  locale-gen

  mkinitcpio -p linux

  # Se usar processador intel:
  # pacman --noconfirm -S intel-ucode
  pacman --noconfirm -S grub efibootmgr # necessario para o funcionamento do grub
  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub
  grub-mkconfig -o /boot/grub/grub.cfg

  pacman --noconfirm -S wpa_supplicant dialog
  pacman --noconfirm -S bash-completion

  useradd -m -g users -G log,sys,wheel,rfkill,dbus -s /bin/bash vinicius

  sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers

  passwd
  passwd vinicius
  rm -rf /chroot
}

if [[ $2 == "--chroot" ]]; then
  posChroot
else
  preChroot
fi
