#!/bin/bash
# ==========================================
# Configuración completa BSPWM + Xorg minimal
# ==========================================

# Crear directorios de configuración
mkdir -p ~/.config/bspwm
mkdir -p ~/.config/sxhkd
mkdir -p ~/.config/polybar
mkdir -p ~/.config/dunst
mkdir -p ~/Pictures

# ==========================================
# 1. Configuración de .xinitrc
# ==========================================
cat > ~/.xinitrc << 'EOF'
#!/bin/sh
# Compositor, notificaciones y barra
picom &
dunst &
polybar example &

# Fondo de pantalla
feh --bg-scale ~/Pictures/wallpaper.jpg &

# Arrancar BSPWM
exec bspwm
EOF
chmod +x ~/.xinitrc

# ==========================================
# 2. Configuración de BSPWM
# ==========================================
cat > ~/.config/bspwm/bspwmrc << 'EOF'
#!/bin/sh
# Configuración de monitores (ajusta según tu VM)
xrandr --output Virtual1 --primary --mode 1920x1080 --rate 60

# Escritorios
bspc monitor -d I II III IV V VI VII VIII IX X

# Compositor y barra
picom &
polybar example &

# Fondo de pantalla
feh --bg-scale ~/Pictures/wallpaper.jpg &
EOF
chmod +x ~/.config/bspwm/bspwmrc

# ==========================================
# 3. Configuración de SXHKD
# ==========================================
cat > ~/.config/sxhkd/sxhkdrc << 'EOF'
# Terminal
super + Return
    kitty &

# Cerrar ventana
super + q
    bspc node -c

# Cambiar de escritorio
super + {1-10}
    bspc desktop -f {1-10}

# Mover ventana a escritorio
super + shift + {1-10}
    bspc node -d {1-10}

# Volumen
XF86AudioRaiseVolume
    pactl set-sink-volume @DEFAULT_SINK@ +5%
XF86AudioLowerVolume
    pactl set-sink-volume @DEFAULT_SINK@ -5%
XF86AudioMute
    pactl set-sink-mute @DEFAULT_SINK@ toggle
EOF

# ==========================================
# 4. Configuración de Polybar
# ==========================================
cat > ~/.config/polybar/config << 'EOF'
[bar/example]
width = 100%
height = 25
background = #222222
foreground = #ffffff
modules-left = bspwm
modules-center = date
modules-right = pulseaudio

[module/bspwm]
type = internal/bspwm

[module/date]
type = internal/date
format = %Y-%m-%d %H:%M:%S

[module/pulseaudio]
type = internal/pulseaudio
EOF

# ==========================================
# 5. Configuración de Dunst
# ==========================================
cat > ~/.config/dunst/dunstrc << 'EOF'
[global]
geometry = "300x50-10+50"
transparency = 10
font = Monospace 10
follow_mode = false
history_length = 20

[urgency_low]
background = "#222222"
foreground = "#ffffff"

[urgency_normal]
background = "#444444"
foreground = "#ffffff"

[urgency_critical]
background = "#ff0000"
foreground = "#ffffff"
EOF

echo " Configuración de BSPWM + Xorg lista. Arranca con startx."
