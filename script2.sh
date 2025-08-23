#!/bin/bash
# ==============================
# Instalación completa: Arch Linux con BSPWM + GNOME + Kitty + Zsh
# ==============================

# ------------------------------
# 1. Variables
# ------------------------------
USER_NAME="usuario"
USER_PASS="123456"   # ⚠️ Cambiar después de la instalación
USER_HOME="/home/$USER_NAME"

# ------------------------------
# 2. Actualizar sistema
# ------------------------------
sudo pacman -Syu --noconfirm

# ------------------------------
# 3. Paquetes base
# ------------------------------
sudo pacman -S --noconfirm \
    base-devel git curl wget \
    gnome gdm \
    bspwm sxhkd polybar picom dunst nitrogen thunar kitty \
    zsh dmenu

# ------------------------------
# 4. Usuario normal
# ------------------------------
if ! id -u "$USER_NAME" >/dev/null 2>&1; then
    sudo useradd -m -G wheel -s /bin/zsh "$USER_NAME"
    echo "$USER_NAME:$USER_PASS" | sudo chpasswd
    sudo mkdir -p /etc/sudoers.d
    echo "%wheel ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/wheel
    sudo chmod 440 /etc/sudoers.d/wheel
fi

# ------------------------------
# 5. Habilitar servicios
# ------------------------------
sudo systemctl enable gdm

# ------------------------------
# 6. Configuración BSPWM y SXHKD
# ------------------------------
sudo -u "$USER_NAME" mkdir -p "$USER_HOME/.config/bspwm"
sudo -u "$USER_NAME" mkdir -p "$USER_HOME/.config/sxhkd"

# BSPWM básico
sudo -u "$USER_NAME" tee "$USER_HOME/.config/bspwm/bspwmrc" > /dev/null <<'EOF'
#!/bin/bash
bspc monitor -d I II III IV V
bspc config border_width 2
bspc config window_gap 10
bspc config focus_follows_pointer true
bspc config click_to_focus true

# Autostart
picom &
nitrogen --restore &
dunst &
EOF

sudo -u "$USER_NAME" chmod +x "$USER_HOME/.config/bspwm/bspwmrc"

# SXHKD básico
sudo -u "$USER_NAME" tee "$USER_HOME/.config/sxhkd/sxhkdrc" > /dev/null <<'EOF'
# Abrir terminal Kitty con Ctrl+Alt+Enter
ctrl + alt + Return
    kitty

# Cerrar ventana
super + q
    bspc node -c

# Lanzar dmenu
super + d
    dmenu_run
EOF

# ------------------------------
# 7. Configuración Kitty
# ------------------------------
sudo -u "$USER_NAME" mkdir -p "$USER_HOME/.config/kitty"
sudo -u "$USER_NAME" tee "$USER_HOME/.config/kitty/kitty.conf" > /dev/null <<'EOF'
font_family      FiraCode
font_size        13
scrollback_lines 10000

# Cerrar ventana/pestaña
map ctrl+shift+w close_window
map ctrl+shift+q close_tab

# Nueva pestaña y ventana
map ctrl+shift+t new_tab
map ctrl+shift+enter new_window

# Dividir ventana
map ctrl+shift+v split_window_vertically
map ctrl+shift+g split_window_horizontally

# Navegar entre paneles
map ctrl+alt+up focus_up
map ctrl+alt+down focus_down
map ctrl+alt+left focus_left
map ctrl+alt+right focus_right

# Navegar entre pestañas
map ctrl+shift+e next_tab
map ctrl+shift+r previous_tab

# Ajuste de fuente
map ctrl+plus increase_font_size
map ctrl+minus decrease_font_size

# Scroll
map ctrl+shift+up scroll_line_up
map ctrl+shift+down scroll_line_down
EOF

# ------------------------------
# 8. Configuración Zsh y Oh My Zsh
# ------------------------------
sudo -u "$USER_NAME" sh -c 'export RUNZSH=no; \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

# Instalar Powerlevel10k y plugins
sudo -u "$USER_NAME" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k"
sudo -u "$USER_NAME" git clone https://github.com/zsh-users/zsh-autosuggestions "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
sudo -u "$USER_NAME" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

# Config zshrc
sudo -u "$USER_NAME" tee "$USER_HOME/.zshrc" > /dev/null <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
EOF

echo "Instalación completa. Reinicia el sistema y podrás usar GNOME o BSPWM desde GDM."
