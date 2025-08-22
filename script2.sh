# ==============================
# Instalación de GNOME + i3 + GDM en Arch
# ==============================

# 1. Actualizar mirrors y sistema
sudo pacman -Syu --noconfirm

# 2. Instalar paquetes base para escritorio
sudo pacman -S --noconfirm \
    gnome gnome-extra gdm \
    i3-wm i3status i3lock i3-gaps \
    xorg xorg-xinit xorg-xinput xorg-xrandr xorg-xsetroot \
    nitrogen feh xterm xdg-utils xdg-user-dirs \
    networkmanager network-manager-applet \
    gvfs gvfs-smb gvfs-afc \
    xclip xsel

# 3. Configurar teclado y locales en inglés (Estados Unidos)
sudo localectl set-keymap us
sudo localectl set-x11-keymap us
sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf

# 4. Crear usuario normal
sudo useradd -m -G wheel -s /bin/bash archuser
echo "archuser:123456" | sudo chpasswd
echo "%wheel ALL=(ALL) ALL" | sudo tee -a /etc/sudoers

# 5. Habilitar servicios
sudo systemctl enable gdm
sudo systemctl enable NetworkManager
sudo systemctl enable sshd
sudo systemctl enable org.cups.cupsd

# 6. Configuración mínima de i3 para usuario
mkdir -p ~/.config/i3
cat <<EOF > ~/.config/i3/config
# i3 básico
set \$mod Mod4
bindsym \$mod+Return exec xterm
bindsym \$mod+d exec dmenu_run
bindsym \$mod+Shift+q kill
EOF

echo "Instalación completa. Reinicia la máquina y GDM permitirá iniciar sesión en GNOME o i3."
