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
<body>
    <h1>Bienvenue sur le serveur CTF 🚩</h1>
    <p>Ce serveur héberge la plateforme CTFd accessible sur le port <strong>8000</strong>.</p>
    <p>🔐 Les ports autorisés : 22 (SSH), 8000 (CTFd), $PORT (cette page)</p>
    <p>📘 Pour commencer, allez sur : <a href="http://192.168.56.10:8000">CTFd</a></p>
</body>
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
