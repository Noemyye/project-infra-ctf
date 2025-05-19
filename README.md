# Projet Cybersécurité : Serveur CTF sécurisé avec Rocky Linux

## 🌟 Objectif du projet

Mettre en place un serveur CTF auto-hébergé sous Rocky Linux avec CTFd, puis le sécuriser afin d'empêcher tout accès non autorisé, même en réseau local. Utilisation d'outils d'analyse réseau pour détecter les tentatives d'intrusion.
---

## I. Serveur principal

* Installation de Rocky Linux sur une VM avec réseau configuré sur `192.168.56.1`
* Configuration IP statique : `192.168.56.10`
* Installation des outils de base : `dnf`, `nano`, `wget`, `firewalld`, etc.
* Installation de **Docker** pour déployer CTFd

---

## II. Déploiement de la plateforme CTF

### (Facultatif) Page d'accueil récapitulative

Un script permet de déployer une page web statique pour l'accueil :
- [Script bash ici](./setup_welcome_page.sh)
```
./setup_welcome_page.sh
```

### ✅ Installation de CTFd avec Docker

```bash
git clone https://github.com/CTFd/CTFd.git
cd CTFd
```

Pour une maintenance de ctfd toujours en ligne ajouter dans le docker compose : `restart: always` dans le service ctfd

Puis :
```
sudo docker compose up -d
```

* Accès à la plateforme via `http://192.168.56.10:8000`
* Création d'un compte administrateur à la première connexion

### ✅ Vérification

* Interface administrateur accessible
* Défis visibles et fonctionnels

Après ca au bon vouloir de l'administrateur de créer/importer ces défis ctf

---

## III. Sécurisation du serveur

### 1) Accès SSH par clé uniquement

Sur la machine admin création d'une clé :
```bash
ssh-keygen
type $env:USERPROFILE\.ssh\id_rsa.pub
```

Sur le serveur Rocky Linux, copier la clé publique affichée précédemment :
```bash
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
```

Et sécuriser les permissions :
```
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### 2) Désactivation de l'accès SSH par mot de passe

Éditez la configuration SSH :
```bash
sudo nano /etc/ssh/sshd_config
```

Modifier/Ajouter les lignes suivantes :
```
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
PubkeyAuthentication yes ⚠️(Très important pour autoriser la clé)
```

Redémarrer le service :
```bash
sudo systemctl restart sshd
```

### 3) Pare-feu

```bash
# Activation du service :
sudo systemctl enable firewalld --now

# Suppression des services par défaut
sudo firewall-cmd --permanent --remove-service=ssh
sudo firewall-cmd --permanent --remove-service=http
sudo firewall-cmd --permanent --remove-service=https

# Autoriser les ports nécessaires
sudo firewall-cmd --permanent --add-port=22/tcp     # SSH par clé
sudo firewall-cmd --permanent --add-port=8080/tcp   # Port alternatif éventuel
sudo firewall-cmd --permanent --add-port=8000/tcp   # Port de CTFd

# Appliquer et vérifier
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```

---

## IV. Outils de sécurité 🔍

### Installation de Suricata

```bash
sudo dnf install epel-release -y
sudo dnf install suricata -y
sudo systemctl enable --now suricata
```

Configurer l'interface réseau sur laquelle on veut vérifier (ici enp0s3):
```bash
sudo nano /etc/sysconfig/suricata

# Modifier la ligne options pour qu'elle corresponde à ça :
OPTIONS="-i enp0s3"
```

Redémarrer le service :
```bash
sudo systemctl restart suricata
sudo systemctl status suricata
```

### Mise en place d'un IDS simple

📂 Fichiers surveillés :
- /etc/ssh/sshd_config

- /etc/firewalld

- /etc/nginx/nginx.conf

- /etc/sudoers

- /etc/passwd

- /etc/shadow

Créer le script :
```
sudo nano /usr/local/bin/check_integrity.sh
```

Copier le contenu :
- [Script bash ici](./check_integrity.sh)

Donne les permissions d’exécution :
```
sudo chmod +x /usr/local/bin/check_integrity.sh
```

Planifier une vérification toutes les 5 minutes via cron :
```bash
sudo crontab -e

# Copier ca :
*/5 * * * * /usr/local/bin/check_integrity.sh
```

### Logwatch en plus

```bash
sudo dnf install logwatch -y
```

---

## VI. Journalisation & Analyse

### 📃 Consultation des journaux

```bash
sudo less /var/log/secure
sudo less /var/log/messages
sudo less /var/log/suricata/fast.log
```

### 📈 Rapport quotidien avec logwatch

```bash
sudo logwatch --range today --detail high --service all --format text
```

### 📄 Script de résumé des attaques

Si un script resume_scripts.sh a été défini, vous pouvez le copier et l'utiliser comme suit :
```bash
sudo chmod +x resume_scripts.sh
sudo ./resume_scripts.sh
```

Puis voir le fichier log qui répertorie les connexions ssh réussis ou échoués

---

## VII. Bonus – Concepts avancés

* **Zero Trust** : aucune confiance par défaut
* **IAM** : gestion des comptes utilisateurs et accès limités
* **VLAN** : possibilité de segmentation réseau via pfSense ou autres outils
* **Automatisation** : Script d'installation, de hardening
