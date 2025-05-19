#!/bin/bash

echo "=== Lancement de l'audit de sécurité ==="
date

# Mise à jour de rkhunter
rkhunter --update

# Analyse de rootkits
rkhunter --check --sk

# Audit Lynis
lynis audit system --quick

# Génération de rapport logwatch
logwatch --detail medium --range today --service all > /~/analyse_logs/ "Audit terminé" | echo "Audit terminé" > ~/logwatch_audit.logecho "Audit terminé. Rapport dans /~"