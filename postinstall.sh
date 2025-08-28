#--------------------
#1. Xorg al mínimo
#--------------------
sudo pacman -Sy
sudo pacman -S xorg-server --noconfirm
sudo pacman -S xorg-xinit --noconfirm
sudo pacman -S xorg-xrandr --noconfirm
sudo pacman -S xorg-xsetroot --noconfirm
sudo pacman -S xorg-xprop --noconfirm
sudo pacman -S xorg-xev --noconfirm

#-----------
#2. Instalación de entorno (bspwn, sxhkd, polybar, picom, dunst, feh, thunar, pavucontrol, brightnessctl, kitty, zsh, xclip, xsel, virtualbox-services, network fuentes)
#-----------
sudo pacman -S bspwm sxhkd --noconfirm
sudo pacman -S polybar --noconfirm
sudo pacman -S picom --noconfirm
sudo pacman -S dunst --noconfirm
sudo pacman -S feh --noconfirm
sudo pacman -S thunar thunar-volman gvfs gvfs-smb --noconfirm
sudo pacman -S pavucontrol --noconfirm
sudo pacman -S brightnessctl --noconfirm
sudo pacman -S kitty --noconfirm
sudo pacman -S zsh --noconfirm
sudo pacman -S xclip xsel --noconfirm
sudo pacman -S virtualbox-guest-utils linux-headers --noconfirm
sudo pacman -S networkmanager network-manager-applet nm-connection-editor --noconfirm
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji --noconfirm
#----------
#3. Instalación de herramientas ()
#-------------
sudo pacman -S git --noconfirm
sudo pacman -S wget --noconfirm
sudo pacman -S curl --noconfirm
sudo pacman -S neofetch --noconfirm
sudo pacman -S htop --noconfirm
