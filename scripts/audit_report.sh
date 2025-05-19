#!/bin/bash

# 📁 Dossier de sauvegarde
DATE=$(date +%F_%H-%M)
LOG_DIR="/var/log/ctf_logs_$DATE"
mkdir -p "$LOG_DIR"

# 🧾 Copie des logs importants
cp /var/log/secure "$LOG_DIR/secure.log"
cp /var/log/messages "$LOG_DIR/messages.log"
cp /var/log/suricata/fast.log "$LOG_DIR/suricata_fast.log" 2>/dev/null

# 📄 Rapport Logwatch
logwatch --range today --detail high --service all --format text > "$LOG_DIR/logwatch_report.txt"

# 🔍 Résumé dans un fichier
echo "Résumé des événements : " > "$LOG_DIR/summary.txt"
grep -i "failed\|denied\|alert" "$LOG_DIR/"* >> "$LOG_DIR/summary.txt"

echo "[✔] Rapport généré dans $LOG_DIR"
