#!/bin/bash

# Directorio donde se guardarán los archivos .flatpak
DIRECTORIO_SALIDA="$HOME/flatpak_bundles"
mkdir -p "$DIRECTORIO_SALIDA"

# Obtener la lista de aplicaciones Flatpak instaladas con su rama
APPS=$(flatpak list --app --columns=application,branch)

# Iterar sobre cada aplicación y crear un bundle
while IFS= read -r LINE; do
    APP=$(echo "$LINE" | awk '{print $1}')
    RAMA=$(echo "$LINE" | awk '{print $2}')

    # Verificar si se obtuvo un nombre de rama válido
    if [ -z "$RAMA" ]; then
        RAMA="stable"
        echo "Advertencia: No se pudo obtener una rama para $APP. Usando 'stable' como valor predeterminado."
    fi

    # Nombre del archivo de salida
    NOMBRE_ARCHIVO="$DIRECTORIO_SALIDA/${APP//\//-}.flatpak"

    # Crear el bundle
    flatpak build-bundle /var/lib/flatpak/repo "$NOMBRE_ARCHIVO" "$APP" "$RAMA"

    echo "Guardado: $NOMBRE_ARCHIVO"
done <<< "$APPS"

echo "Todos los bundles han sido creados en $DIRECTORIO_SALIDA."
