# Conectar y verificar red
ping -c 5 google.com

# Sincronizar reloj

timedatectl set-ntp true
echo "KEYMAP=es" > /etc/vconsole.conf

# Crear particiones automáticamente
parted /dev/sda --script \
  mklabel gpt \
  mkpart ESP fat32 1MiB 513MiB \
  set 1 boot on \
  mkpart primary ext4 513MiB 100%

# Formatear particiones
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# Montar particiones
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# Instalar base y kernel
pacstrap /mnt base linux linux-firmware vim nano sudo

# Generar fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Entrar al sistema chroot
arch-chroot /mnt /bin/bash <<'EOF'
# Configurar zona horaria Nueva York
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Configurar idioma inglés (US)
sed -i 's/^#es_MX.UTF-8 UTF-8/es_MX.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=es_MX.UTF-8" > /etc/locale.conf

# Configurar hostname y hosts
echo "herculerch" > /etc/hostname
cat <<EOT > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   herculerch.localdomain herculerch
EOT

# Establecer contraseña de root
echo "root:123456" | chpasswd

# Red y vbox
sudo pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet dialog os-prober mtools dosfstools base-devel linux-headers cups reflector openssh git xdg-utils xdg-user-dirs virtualbox-guest-utils

# Instalar GRUB EFI
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux
grub-mkconfig -o /boot/grub/grub.cfg

#Servicios
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable org.cups.cupsd
EOF

# Desmontar y reiniciar
umount -R /mnt
reboot
