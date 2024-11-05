#!/bin/bash

# Directorio donde se guardarán los archivos .flatpak
DIRECTORIO_SALIDA="$HOME/flatpak_bundles"
mkdir -p "$DIRECTORIO_SALIDA"

# Obtener la lista de runtimes Flatpak instalados con su rama
RUNTIMES=$(flatpak list --runtime --columns=application,branch)

# Iterar sobre cada runtime y crear un bundle
while IFS= read -r LINE; do
    RUNTIME=$(echo "$LINE" | awk '{print $1}')
    RAMA=$(echo "$LINE" | awk '{print $2}')

    # Verificar si se obtuvo un nombre de rama válido
    if [ -z "$RAMA" ]; then
        RAMA="stable"
        echo "Advertencia: No se pudo obtener una rama para $RUNTIME. Usando 'stable' como valor predeterminado."
    fi

    # Nombre del archivo de salida
    NOMBRE_ARCHIVO="$DIRECTORIO_SALIDA/${RUNTIME//\//-}_$RAMA.flatpak"

    # Crear el bundle
    flatpak build-bundle /var/lib/flatpak/repo "$NOMBRE_ARCHIVO" "$RUNTIME" "$RAMA" --runtime

    echo "Guardado: $NOMBRE_ARCHIVO"
done <<< "$RUNTIMES"

echo "Todos los bundles de runtimes han sido creados en $DIRECTORIO_SALIDA."
