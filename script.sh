# 1. Conectar y verificar red
ping -c 3 google.com

# 2. Sincronizar reloj
timedatectl set-ntp true

# 3. Teclado en consola
echo "KEYMAP=es" > /etc/vconsole.conf

# 4. Crear particiones automáticamente (GPT: EFI + root)
parted /dev/sda --script \
  mklabel gpt \
  mkpart ESP fat32 1MiB 513MiB \
  set 1 esp on \
  mkpart primary ext4 513MiB 100%

# 5. Formatear particiones
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# 6. Montar particiones
mount /dev/sda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# 7. Instalar base y kernel
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo

# 8. Generar fstab
genfstab -U /mnt >> /mnt/etc/fstab

# 9. Entrar al sistema
arch-chroot /mnt /bin/bash <<'EOF'

# ==============================
# Configuración dentro de Arch
# ==============================

# Zona horaria
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# Locales
sed -i 's/^#es_MX.UTF-8 UTF-8/es_MX.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=es_MX.UTF-8" > /etc/locale.conf

# Hostname y hosts
echo "herculerch" > /etc/hostname
cat <<EOT > /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    herculerch.localdomain herculerch
EOT

# Root password
echo "root:123456" | chpasswd

# Crear usuario normal
useradd -m -G wheel -s /bin/bash archuser
echo "archuser:123456" | chpasswd
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Paquetes extra (VBox + red + utilidades)
pacman -S --noconfirm grub efibootmgr networkmanager dialog mtools dosfstools linux-headers cups reflector openssh git xdg-utils xdg-user-dirs virtualbox-guest-utils

# Instalar GRUB en EFI (forzado, con recheck)
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --recheck

# Crear configuración GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Registrar entrada en EFI (asegura arranque en VBox)
efibootmgr --create --disk /dev/sda --part 1 --label "ArchLinux" --loader "\EFI\GRUB\grubx64.efi"

# Habilitar servicios
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable org.cups.cupsd

EOF

# 10. Desmontar y reiniciar
umount -R /mnt
reboot

