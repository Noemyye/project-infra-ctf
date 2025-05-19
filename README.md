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

### (Facultatif) Execution de la page d'accueil

Lancer le script bash pour déployer le serveur nginx pour avoir la page d'accueil récapitulative
```
./setup_welcome_page.sh
```

### ✅ Installation de CTFd avec Docker

```bash
git clone https://github.com/CTFd/CTFd.git
cd CTFd
sudo docker compose up -d
```

* Accès à la plateforme via `http://192.168.56.10:8000`
* Création d'un compte administrateur

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

Sur le serveur Rocky, copier manuellement la clé public que vous venez d'afficher dans le fichier (authorized_keys) et lui changer les permissions pour plus de sécurité ::

```bash
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### 2) Désactivation de l'accès SSH par mot de passe

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
sudo systemctl enable firewalld --now

# Suppression des services par défaut
sudo firewall-cmd --permanent --remove-service=ssh
sudo firewall-cmd --permanent --remove-service=http
sudo firewall-cmd --permanent --remove-service=https

# Autoriser les ports nécessaires
sudo firewall-cmd --permanent --add-port=22/tcp
sudo firewall-cmd --permanent --add-port=8000/tcp

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

Configurer l'interface réseau :

```bash
sudo -i
nano /etc/sysconfig/suricata

# Modifier la ligne options pour qu'elle corresponde à ça :
OPTIONS="-i enp0s3"
```

Redémarrer le service :

```bash
sudo systemctl restart suricata
sudo systemctl status suricata
```

---

## VI. Journalisation & Analyse

### 📃 Consultation des journaux

```bash
sudo less /var/log/secure
sudo less /var/log/messages
sudo less /var/log/suricata/fast.log
```

### 📈 Rapport quotidien

Installer logwatch :

```bash
sudo dnf install logwatch 
```

Configurer logwatch :

```bash
sudo logwatch --range today --detail high --service all --format text
```

### 📄 Script de résumé des attaques

```bash
sudo ./rapport_resume.sh
```

---

## VII. Bonus – Concepts avancés

* **Zero Trust** : aucune confiance par défaut
* **IAM** : gestion des comptes utilisateurs et accès limités
* **VLAN** : possibilité de segmentation réseau via pfSense ou autres outils
* **Automatisation** : Script d'installation, de hardening

---

## 📊 Évaluation

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

