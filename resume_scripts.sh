#!/bin/bash

DATE=$(date +%F_%H-%M)
RAPPORT="/var/log/rapport_securite_$DATE.txt"

echo "🛡️ Rapport de sécurité – Généré le $DATE" > "$RAPPORT"
echo "-----------------------------------------" >> "$RAPPORT"

# 🔐 Connexions SSH réussies
echo -e "\n📥 Connexions SSH réussies :" >> "$RAPPORT"
grep "Accepted password\|Accepted publickey" /var/log/secure | awk '{print "-> Connexion SSH de l’utilisateur " $9 " depuis "$11 " à " $1, $2, $3}' >> "$RAPPORT" 

# ❌ Tentatives de connexion échouées
echo -e "\n🚫 Tentatives de connexion échouées :" >> "$RAPPORT"
grep "Failed password" /var/log/secure | awk '{print "-> Échec de connexion pour " $9 " depuis " $11 " à " $1, $2, $3}' >> "$RAPPORT"

# 🔍 Alertes réseau (Suricata)
echo -e "\n🌐 Alertes réseau détectées (Suricata) :" >> "$RAPPORT"
if [ -f /var/log/suricata/fast.log ]; then
    grep -v "^$" /var/log/suricata/fast.log | sed 's/\[.*\]//g' | awk -F "] " '{print "-> " $2}' >> "$RAPPORT"
else
    echo "-> Aucune alerte Suricata trouvée." >> "$RAPPORT"
fi

# 🧾 Résumé
echo -e "\n📊 Résumé : " >> "$RAPPORT"
echo "$(grep 'Accepted' "$RAPPORT" | wc -l) connexion(s) SSH réussie(s)." >> "$RAPPORT"
echo "$(grep 'Échec de connexion' "$RAPPORT" | wc -l) tentative(s) échouée(s)." >> "$RAPPORT"
echo "$(grep '->' "$RAPPORT" | grep -c 'ALERT')" "alerte(s) réseau détectée(s) par Suricata." >> "$RAPPORT"

echo -e "\n✅ Rapport généré dans : $RAPPORT"
