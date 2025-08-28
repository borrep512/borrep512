#!/bin/sh
# Terminar instancias previas
killall -q polybar

# Esperar que terminen
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lanzar barra principal
polybar main &
