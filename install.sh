loadkeys es   # Cambiar teclado a español
ping archlinux.org -c 5  # Probar conexión a internet
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart ESP fat32 1MiB 301MiB
parted /dev/sda --script set 1 esp on
parted /dev/sda --script mkpart primary linux-swap 301MiB 2301MiB
parted /dev/sda --script mkpart primary ext4 2301MiB 100%
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
pacstrap -K /mnt base 
pacstrap -K /mnt linux
pacstrap -K /mnt linux-firmware
pacstrap -K /mnt vim
pacstrap -K /mnt networkmanager
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
echo "herculerch" > /etc/hostname
useradd -m -G wheel -s /bin/bash herculex
echo "root:123456" | chpasswd
echo "herculex:123456" | chpasswd
pacman -S grub efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
exit
umount -R /mnt
echo "Ya está"
