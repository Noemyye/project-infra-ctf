#!/bin/bash

# Fichiers à surveiller
FILES=(
    "/etc/ssh/sshd_config"
    "/etc/firewalld"
    "/etc/nginx/nginx.conf"
    "/etc/sudoers"
)

# Répertoire de stockage des sommes de contrôle
CHECKSUM_DIR="/var/log/file_integrity"
LOGFILE="/var/log/file_integrity/integrity_check.log"

mkdir -p "$CHECKSUM_DIR"

for file in "${FILES[@]}"; do
    [ -f "$file" ] || continue
    filename=$(echo "$file" | sed 's|/|_|g')
    current_checksum=$(sha256sum "$file" | awk '{print $1}')
    checksum_file="$CHECKSUM_DIR/$filename.chk"

    if [ -f "$checksum_file" ]; then
        old_checksum=$(cat "$checksum_file")
        if [ "$current_checksum" != "$old_checksum" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - CHANGEMENT détecté dans $file" >> "$LOGFILE"
            echo "$current_checksum" > "$checksum_file"
        fi
    else
        echo "$current_checksum" > "$checksum_file"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Initialisation du suivi pour $file" >> "$LOGFILE"
    fi
done
