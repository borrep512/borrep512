#--------------------
#1. Xorg al mínimo
#--------------------
sudo pacman -Syu
sudo pacman -S xorg-server 
sudo pacman -S xorg-xinit
sudo pacman -S xorg-xrandr
sudo pacman -S xorg-xsetroot
sudo pacman -S xorg-xprop
sudo pacman -S xorg-xev

#-----------
#2. Instalación de entorno (bspwn, sxhkd, polybar, picom, dunst, feh, thunar, pavucontrol, brightnessctl, kitty, zsh, xclip, xsel, virtualbox-services, network fuentes)
#-----------
sudo pacman -S bspwm sxhkd
sudo pacman -S polybar
sudo pacman -S picom
sudo pacman -S dunst
sudo pacman -S feh
sudo pacman -S thunar thunar-volman gvfs gvfs-smb 
sudo pacman -S pavucontrol 
sudo pacman -S brightnessctl
sudo pacman -S kitty
sudo pacman -S zsh
sudo pacman -S xclip xsel
sudo pacman -S virtualbox-guest-utils linux-headers
sudo pacman -S networkmanager network-manager-applet nm-connection-editor
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji
#----------
#3. Instalación de herramientas ()
#-------------
sudo pacman -S git 
sudo pacman -S wget
sudo pacman -S curl 
sudo pacman -S neofetch
sudo pacman -S htop
