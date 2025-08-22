# ==============================
# Instalación de GNOME + i3 + GDM
# ==============================

# 1. Actualizar mirrors y sistema
sudo pacman -Syu --noconfirm

# 2. Instalar GNOME, i3 y utilidades básicas
sudo pacman -S --noconfirm \
    gnome gnome-extra gdm \
    i3-wm i3status i3lock i3-gaps \
    xorg xorg-xinit xorg-xinput xorg-xrandr xorg-xsetroot \
    nitrogen feh xterm xdg-utils xdg-user-dirs \
    networkmanager network-manager-applet \
    gvfs gvfs-smb gvfs-afc

# 3. Habilitar GDM y NetworkManager
sudo systemctl enable gdm
sudo systemctl enable NetworkManager

# 4. Configurar teclado en español para X11
sudo localectl set-x11-keymap es

# 5. Crear configuración mínima de i3 para usuario
mkdir -p ~/.config/i3
cat <<EOF > ~/.config/i3/config
# i3 básico con terminal xterm
set \$mod Mod4
bindsym \$mod+Return exec xterm
bindsym \$mod+d exec dmenu_run
bindsym \$mod+Shift+q kill
EOF

# 6. Mensaje final
echo "Instalación completa. Reinicia la máquina y GDM te permitirá iniciar sesión en GNOME o i3."
