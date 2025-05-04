# Projet Cybersécurité : Serveur CTF sécurisé avec Rocky Linux

## 🎯 Objectif du projet

Mettre en place un serveur CTF auto-hébergé sous Rocky Linux avec CTFd, puis le sécuriser afin d'empêcher tout accès non autorisé, même en réseau local. Utiliser des outils d'analyse réseau pour détecter les tentatives d'intrusion et configurer une machine Kali Linux comme attaquante pour tester la résistance du système.

---

## 📝 Cahier des charges

### 1. Serveur CTF
- Système : Rocky Linux (VM ou machine physique)
- Application : CTFd (plateforme d'hébergement de challenges)
- Objectif : héberger des challenges pour des tests d’intrusion internes

### 2. Sécurisation du serveur
- Interdiction des connexions SSH (même en local)
- Pare-feu strict
- Outils de surveillance du réseau

### 3. Analyse réseau
- Collecte de logs réseau
- Détection d'activités suspectes

### 4. Machine attaquante
- Kali Linux (VM ou physique)
- Utilisée pour lancer des attaques (scan, brute force, etc.)
- Objectif : observer le comportement du serveur et analyser les logs

---

## 🛠️ Étapes de mise en place

### Étape 1 : Déploiement du serveur Rocky Linux
- Télécharger l’image Rocky Linux
- Créer une VM ou booter sur une clé USB
- Installer le système avec un utilisateur `nono` et accès `sudo`

### Étape 2 : Installation de CTFd
```bash
sudo dnf install git python3 python3-pip -y
git clone https://github.com/CTFd/CTFd.git
cd CTFd
pip3 install -r requirements.txt
python3 serve.py
```

desactiver ssh 
sudo systemctl disable --now sshd
sudo firewall-cmd --permanent --remove-service=ssh
sudo firewall-cmd --reload

parefeu
sudo firewall-cmd --permanent --zone=public --add-port=8000/tcp
sudo firewall-cmd --reload

nftables
sudo dnf install nftables -y
sudo systemctl enable --now nftables


configurer les regles 
sudo nano /etc/nftables.conf

ex:
table inet filter {
    chain input {
        type filter hook input priority 0;
        policy drop;
        iif "lo" accept
        ct state established,related accept
        tcp dport 8000 accept
    }
}

puis
sudo systemctl restart nftables

Étape 4 : Mise en place de la machine attaquante (Kali Linux)
Installer Kali sur une autre VM ou PC

Connecter les deux machines au même réseau

Utiliser nmap, hydra, ou gobuster pour tester la surface d’attaque
nmap -p- <IP_du_serveur>

Étape 5 : Analyse et surveillance du trafic
Utiliser tcpdump ou wireshark

sudo dnf install tcpdump -y
sudo tcpdump -i <interface> -w capture.pcap

Analyser avec :
wireshark

logwatch (en l’installant avec : sudo dnf install logwatch)

✅ Résultat attendu
Serveur CTF opérationnel avec CTFd

Impossible de s’y connecter en SSH même depuis le LAN

Seul le port web du CTF est accessible

Les attaques sont détectées et enregistrées

Logs récupérables pour analyse

🧪 Bonus
Mettre en place un reverse proxy (Nginx) avec HTTPS pour sécuriser l’accès web

Utiliser fail2ban compilé manuellement si besoin

Intégration d’un tableau de bord comme Grafana pour la visualisation