#!/bin/bash

loadkeys es
ping archlinux.org -c 5
echo "[+] Hay conexión, se procede a instalar."
sleep 5

# --- Particionado ---
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart ESP fat32 1MiB 301MiB
parted /dev/sda --script set 1 esp on
parted /dev/sda --script mkpart primary linux-swap 301MiB 2301MiB
parted /dev/sda --script mkpart primary ext4 2301MiB 100%
echo "[+] Particiones 1 completado."
sleep 5

# --- Formateo ---
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
echo "[+] Particiones 2 completado."
sleep 5

# --- Montaje ---
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
echo "[+] Particiones 3 completado."
sleep 5

# --- Preparar pseudo-sistemas ---
mkdir -p /mnt/{proc,sys,dev,run,tmp}
mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --make-rslave /mnt/sys
mount --rbind /dev /mnt/dev
mount --make-rslave /mnt/dev
mount --bind /run /mnt/run
echo "[+] Pseudosistemas montados."
sleep 5

# --- Copiar pacman temporal para instalar base por partes ---
mkdir -p /mnt/usr/bin /mnt/etc
cp -a /usr/bin/pacman /mnt/usr/bin/
cp -a /etc/pacman.conf /mnt/etc/

# --- Instalar base por partes ---
arch-chroot /mnt pacman -S --noconfirm bash coreutils filesystem
echo "[+] Base mínimo instalado."
sleep 5
arch-chroot /mnt pacman -S --noconfirm linux
echo "[+] Linux instalado."
sleep 5
arch-chroot /mnt pacman -S --noconfirm linux-firmware
echo "[+] Linux firmware instalado."
sleep 5
arch-chroot /mnt pacman -S --noconfirm vim
echo "[+] Vim instalado."
sleep 5
arch-chroot /mnt pacman -S --noconfirm networkmanager
echo "[+] NetworkManager instalado."
sleep 5

# --- Configuración dentro del chroot ---
arch-chroot /mnt /bin/bash <<EOF

# Hora
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

# Locales
sed -i 's/#es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf

# Host y usuarios
echo "herculerch" > /etc/hostname
useradd -m -G wheel -s /bin/bash herculex
echo "root:123456" | chpasswd
echo "herculex:123456" | chpasswd
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Instalar GRUB y habilitar NetworkManager
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

EOF

# --- Desmontar todo ---
umount -R /mnt
echo "[+] Todo listo, ya puedes reiniciar y quitar la ISO."
