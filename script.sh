#!/bin/bash
set -e  # Salir si hay un error

# --- Variables ---
DISK="/dev/sda"
HOSTNAME="herculerch"
USER="herculex"
PASSWORD="123456"   # Cambia esto por una contraseña segura
LOCALE="es_ES.UTF-8"
TIMEZONE="Europe/Madrid"

# --- 1. Particionado ---
pacman -Sy
echo "Particionando disco..."
sgdisk -Z $DISK                   # Borrar disco
sgdisk -n 1:0:+512M -t 1:ef00 $DISK  # EFI
sgdisk -n 2:0:0 -t 2:8300 $DISK      # Root

# --- 2. Formateo ---
echo "Formateando particiones..."
mkfs.fat -F32 ${DISK}1
mkfs.ext4 ${DISK}2

# --- 3. Montaje ---
echo "Montando sistemas de archivos..."
mount ${DISK}2 /mnt
mkdir /mnt/boot
mount ${DISK}1 /mnt/boot

# --- 4. Instalar base ---
echo "Instalando sistema base..."
pacstrap /mnt base linux linux-firmware vim sudo

# --- 5. Configuración ---
echo "Generando fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF
# Zona horaria
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Localización
echo "$LOCALE UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

# Hostname
echo "$HOSTNAME" > /etc/hostname

# Root password
echo "root:$PASSWORD" | chpasswd

# Usuario normal
useradd -m -G wheel -s /bin/bash $USER
echo "$USER:$PASSWORD" | chpasswd

# Sudoers
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# GRUB
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

#Red
pacman -Sy networkmanager
systemctl enable NetworkManager
EOF

# --- 6. Desmontar y reiniciar ---
umount -R /mnt
echo "Instalación finalizada. Reinicia la máquina y quita la ISO."
