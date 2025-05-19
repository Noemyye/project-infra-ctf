#!/bin/bash

# Variables
HTML_DIR="/usr/share/nginx/html"
PORT=8080
FIREWALL_PORT="${PORT}/tcp"

echo "[+] Installation de NGINX..."
sudo dnf install -y nginx

echo "[+] Configuration de NGINX pour écouter sur le port $PORT..."
sudo sed -i "s/listen       80;/listen       $PORT;/g" /etc/nginx/nginx.conf

echo "[+] Création de la page d'accueil..."
sudo tee $HTML_DIR/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bienvenue sur le serveur CTF</title>
    <style>
        body { font-family: sans-serif; background: #f5f5f5; padding: 2em; }
        h1 { color: #007acc; }
    </style>
</head>
<section>
    <h2>🔐 Informations réseau</h2>
    <ul>
        <li><strong>Adresse IP :</strong> 192.168.56.10</li>
        <li><strong>Ports ouverts :</strong> 22 (SSH), 8000 (CTFd), $PORT (page d'accueil)</li>
    </ul>
</section>

<section>
    <h2>⚙️ Plateforme CTFd</h2>
    <p>Le serveur héberge <strong>CTFd</strong>, une plateforme de Capture The Flag personnalisable.</p>
    <p>🔗 <a href="http://192.168.56.10:8000" target="_blank">Accéder à CTFd</a></p>
    <p>📘 Documentation officielle : <a href="https://docs.ctfd.io" target="_blank">docs.ctfd.io</a></p>
</section>

<section>
    <h2>🛠️ Outils de sécurité installés</h2>
    <ul>
        <li><strong>Suricata</strong> – IDS pour détecter les intrusions</li>
        <li><strong>Firewalld</strong> – Configuration des ports et filtrage réseau</li>
        <li><strong>Logwatch</strong> – Rapport quotidien des logs système</li>
        <li><strong>Script d'intégrité</strong> – Vérifie les modifications de fichiers sensibles</li>
    </ul>
    <p>Commandes utiles :</p>
    <ul>
        <li><code>sudo less /var/log/suricata/fast.log</code> – Alertes Suricata</li>
        <li><code>sudo logwatch --range today</code> – Rapport du jour</li>
        <li><code>sudo firewall-cmd --list-all</code> – Vérifier les ports ouverts</li>
    </ul>
</section>

<section>
    <h2>🔎 Sécurité réseau & bonnes pratiques</h2>
    <ul>
        <li>Accès SSH limité par clé uniquement</li>
        <li>Mot de passe désactivé pour SSH</li>
        <li>Firewall restrictif avec uniquement les ports nécessaires ouverts</li>
        <li>Utilisateurs avec privilèges limités</li>
        <li>Utilisation du principe <strong>Zero Trust</strong></li>
    </ul>
</section>

<section>
    <h2>📁 Ressources utiles</h2>
    <ul>
        <li><a href="https://github.com/CTFd/CTFd" target="_blank">CTFd sur GitHub</a></li>
        <li><a href="https://wiki.owasp.org" target="_blank">OWASP – Meilleures pratiques en sécurité</a></li>
        <li><a href="https://www.rockylinux.org" target="_blank">Site officiel Rocky Linux</a></li>
    </ul>
</section>

<footer>
    <p>🎯 Projet cybersécurité – VM Rocky Linux | Par <em>Noémie Dublanc, Ingrid Lare, Maxime Isidore</em></p>
</footer>
</html>
EOF

echo "[+] Ouverture du port $PORT dans le pare-feu..."
sudo firewall-cmd --permanent --add-port=$FIREWALL_PORT
sudo firewall-cmd --reload

echo "[+] Activation et démarrage de NGINX..."
sudo systemctl enable --now nginx

# Tentative d'ouverture automatique dans navigateur (si GUI présente)
if command -v xdg-open &>/dev/null; then
    echo "[+] Ouverture automatique dans le navigateur..."
    xdg-open "http://localhost:$PORT"
else
    echo "[i] Serveur actif sur : http://192.168.56.10:$PORT"
fi

echo "[✔] Page d'accueil déployée avec succès."
