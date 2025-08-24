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
arch-chroot /mnt pacman -S --noconfirm base
echo "[+] Base instalado."
sleep 15
arch-chroot /mnt pacman -S --noconfirm linux
echo "[+] Linux instalado."
sleep 15
arch-chroot /mnt pacman -S --noconfirm linux-firmware
echo "[+] Linux firmware instalado."
sleep 15
arch-chroot /mnt pacman -S --noconfirm vim
echo "[+] Vim instalado."
sleep 15
arch-chroot /mnt pacman -S --noconfirm networkmanager
echo "[+] NetworkManager instalado."
sleep 15

#Hora
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
echo "[+] Hora establecida."
sleep 5

#Host y usuarios
echo "herculerch" > /etc/hostname
useradd -m -G wheel -s /bin/bash herculex
echo "root:123456" | chpasswd
echo "herculex:123456" | chpasswd
echo "[+] Ajustes de host y de usuarios completados."
sleep 5

#Grub
pacman -S grub efibootmgr --noconfirm
sleep 15
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
sleep 15
grub-mkconfig -o /boot/grub/grub.cfg
sleep 15
echo "[+] Grub instalado."

#Network
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager
echo "[+] Network manager instalado y operativo."
sleep 15

exit
umount -R /mnt
echo "[+] Todo listo, ya puedes quitar salir y quitar la ISO."
