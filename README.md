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
- [Script bash ici](./scripts/setup_welcome_page.sh)
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
- [Script bash ici](./scripts/check_integrity.sh)

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
- [Script bash ici](./scripts/resumer_scripts.sh)
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
<<<<<<< HEAD

---

## 📊 Évaluation

## Pentesting avec Kali Linux contre Rocky Linux

1. Configuration de la machine Kali Linux

    Hyperviseur : VirtualBox

    Nom de la VM : kali-linux

    Image : kali-linux-2024.X-amd64.iso

    Type : Linux (Debian 64-bit)

    RAM : 2 Go

    CPU : 2 processeurs

    Disque : VDI, 20 Go dynamique

    Mode réseau : Réseau privé hôte (vboxnet0)

    Installation : standard, partition unique, GRUB installé sur /dev/sda

    Utilisateur : kali / kali


    2. Mise à jour et installation des outils
    sudo apt update && sudo apt upgrade -y
    sudo apt install nmap nikto hydra dirb -y
    

    3. Résultats des scans Nmap sur la cible (192.168.56.10)
    Port	État	Service	Version
      22	ouvert	SSH	OpenSSH 8.7
      80	fermé	HTTP	Serveur web non actif
    9090	fermé	zeus-admin	Port fermé

    4. Attaque brute-force SSH avec Hydra

    Commande :
    hydra -l root -P /usr/share/wordlists/rockyou.txt ssh://192.168.56.10 -t 4

    Hydra a lancé l’attaque brute-force sur le port SSH (22).

    Le nombre de tentatives a augmenté régulièrement.

    Interruption manuelle a sauvegardé la session dans hydra.restore.

    5. Conclusion

    Les scans et attaques sur le port SSH ont fonctionné, mais aucune compromission n’a été obtenue.

    Le port 80 est fermé, empêchant les scans web (Nikto, Dirb).

    L’attaque sur la machine Rocky Linux depuis Kali Linux n’a pas abouti.

### ✅ ADMINISTRER UN SERVEUR

| Critère                             | Réponse                                      |
| ----------------------------------- | -------------------------------------------- |
| Installer et configurer un système  | Rocky Linux, IP statique, Docker, CTFd       |
| Diagnostiquer et réparer un système | Analyse de logs, Suricata, logwatch          |
| Automatiser des tâches simples      | Scripts : installation, sécurisation, backup |
| Déployer des services               | CTFd via Docker, gestion des ports           |

### ✅ METTRE EN PLACE UNE INFRASTRUCTURE SYSTÈME & RÉSEAU

| Critère                                | Réponse                                               |
| -------------------------------------- | ----------------------------------------------------- |
| Adressage, routage, VLAN               | Configuration réseau, possibilité de VLAN via pfSense |
| Haute disponibilité / tolérance pannes | Redémarrage auto avec `systemd` ou `docker restart`   |
| Connectivité WAN                       | Contrôle via pare-feu (ports précisément définis)     |

### ✅ GÉRER UN ENVIRONNEMENT VIRTUEL

| Critère               | Réponse                                                                                |
| --------------------- | -------------------------------------------------------------------------------------- |
| Virtualiser un OS     | VMs : Rocky Linux                                                                      |
| Virtualiser un réseau | Réseaux internes via VirtualBox, possibilité pfSense/GNS3 pour aller plus loin         |

### ✅ APPREHENDER LA SÉCURITÉ

| Critère                     | Réponse                                                                  |
| --------------------------- | ------------------------------------------------------------------------ |
| Terminologie sécurité       | IDS, journaux, pare-feu, accès par clé, hardening                        |
| Connaissance réglementation | Possibilité d'intégrer RGPD, triade CIA                                  |
| Démarche sécuritaire        | Pare-feu, désactivation SSH mot de passe, journaux, analyse              |
| Zero Trust, IAM             | Accès restreints, utilisateurs définis, suppression de services inutiles |

=======
>>>>>>> 30294e810da44567fa89d43709a229bb724f1833
