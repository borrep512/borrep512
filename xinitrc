#!/bin/sh

# Fondo de pantalla
feh --bg-scale ~/Imágenes/fondo.png &

# Compositor
picom &

# Lanzador de atajos
sxhkd &

# Barra
polybar example &

# Ejecutar bspwm
exec bspwm
