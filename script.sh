#!/bin/bash
set -e  # salir si hay error

# --- Variables ---
DISK="/dev/sda"
HOSTNAME="herculerch"
USER="herculex"
PASSWORD="123456"   # cámbiala
LOCALE="es_ES.UTF-8"
TIMEZONE="Europe/Madrid"

# --- 0. Mirrors ---
echo "➤ Configurando mirrors..."
pacman -Sy --noconfirm reflector
# mirrors rápidos en Europa
reflector --country-name Spain,Germany,France --protocol https --sort rate --save /etc/pacman.d/mirrorlist || {
  echo "⚠️ Reflector falló, usando mirror de fallback (Ibercivis España)..."
  echo "Server = https://mirror.ibercivis.es/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
}

# --- 1. Particionado ---
echo "➤ Particionando disco $DISK..."
sgdisk -Z $DISK
sgdisk -n 1:0:+512M -t 1:ef00 $DISK  # EFI
sgdisk -n 2:0:0    -t 2:8300 $DISK  # Root

# --- 2. Formateo ---
mkfs.fat -F32 ${DISK}1
mkfs.ext4 ${DISK}2

# --- 3. Montaje ---
mount ${DISK}2 /mnt
mkdir /mnt/boot
mount ${DISK}1 /mnt/boot

# --- 4. Instalar base (paquetes uno a uno, más tolerante en red lenta) ---
echo "➤ Instalando sistema base..."
pacstrap /mnt base
pacstrap /mnt linux
pacstrap /mnt linux-firmware
pacstrap /mnt vim
pacstrap /mnt sudo

# --- 5. Configuración ---
echo "➤ Generando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF
# Zona horaria
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Localización
sed -i "s/#$LOCALE UTF-8/$LOCALE UTF-8/" /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

# Hostname
echo "$HOSTNAME" > /etc/hostname

# Root y usuario
echo "root:$PASSWORD" | chpasswd
useradd -m -G wheel -s /bin/bash $USER
echo "$USER:$PASSWORD" | chpasswd
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Bootloader EFI
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Red
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager
EOF

# --- 6. Final ---
umount -R /mnt
echo "✅ Instalación finalizada. Reinicia la máquina y quita la ISO."

