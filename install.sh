Script3
#!/bin/bash
pacman -Sy --noconfirm
loadkeys es   # Cambiar teclado a español
ping archlinux.org -c 5  # Probar conexión a internet
echo "[+] Hay conexion, se procede a instalar."
sleep 5

#Particiones
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart ESP fat32 1MiB 301MiB
parted /dev/sda --script set 1 esp on
parted /dev/sda --script mkpart primary linux-swap 301MiB 2301MiB
parted /dev/sda --script mkpart primary ext4 2301MiB 100%
echo "[+] Particiones 1 completado."
sleep 5

#Particiones 2
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
echo "[+] Particiones 2 completado."
sleep 5

#Particiones 3
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
echo "[+] Particiones 3 completado."
sleep 5


#Instalaciones
pacstrap -K /mnt base 
echo "[+] Base instalado."
sleep 15
pacstrap -K /mnt linux
echo "[+] Linux instalado."
sleep 15
pacstrap -K /mnt linux-firmware
echo "[+] Linux firmware instalado."
sleep 15
pacstrap -K /mnt vim
echo "[+] Vim instalado."
sleep 15
pacstrap -K /mnt networkmanager
echo "[+] NetworkManager instalado."
sleep 15
pacstrap -K /mnt grub 
echo "[+] Grub instalado."
sleep 15
pacstrap -K /mnt efibootmgr
echo "[+] Efibootmgr instalado."
sleep 15

sleep 60

#Doble instalación
pacstrap -K /mnt base 
echo "[+] Base instalado."
sleep 15
pacstrap -K /mnt linux
echo "[+] Linux instalado."
sleep 15
pacstrap -K /mnt linux-firmware
echo "[+] Linux firmware instalado."
sleep 15
pacstrap -K /mnt vim
echo "[+] Vim instalado."
sleep 15
pacstrap -K /mnt networkmanager
echo "[+] NetworkManager instalado."
sleep 15
pacstrap -K /mnt grub 
echo "[+] Grub instalado."
sleep 15
pacstrap -K /mnt efibootmgr
echo "[+] Efibootmgr instalado."
sleep 15


#Fstab
genfstab -U /mnt >> /mnt/etc/fstab 
echo "[+] fstab generado." 
sleep 5


# ---- Script post-instalación dentro del chroot ----
cat > /mnt/root/postinstall.sh <<'EOS'
#!/bin/bash
set -e

# Zona horaria y reloj
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
echo "[+] Hora establecida."

# Hostname y usuarios
echo "herculerch" > /etc/hostname
useradd -m -G wheel -s /bin/bash herculex
echo "root:123456" | chpasswd
echo "herculex:123456" | chpasswd
echo "[+] Usuarios creados."

# Instalar y configurar grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
echo "[+] GRUB instalado."

# NetworkManager
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager
echo "[+] NetworkManager activado."

echo "[+] Script dentro del chroot terminado correctamente."
EOS

chmod +x /mnt/root/postinstall.sh

# ---- Entrar al chroot y ejecutar configuración ----
arch-chroot /mnt /root/postinstall.sh

# ---- Salida final ----
umount -R /mnt
echo "[+] Instalación completa. Retira la ISO y reinicia."
