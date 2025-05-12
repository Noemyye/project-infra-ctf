# Projet Cybersécurité : Serveur CTF sécurisé avec Rocky Linux

## 🎯 Objectif du projet

Mettre en place un serveur CTF auto-hébergé sous Rocky Linux avec CTFd, puis le sécuriser afin d'empêcher tout accès non autorisé, même en réseau local. Utiliser des outils d'analyse réseau pour détecter les tentatives d'intrusion et configurer une machine Kali Linux comme attaquante pour tester la résistance du système.

## I. Serveur principal

Installation de Rocky Linux sur une VM et mise en réseau (192.168.56.1)

Configuration IP statique ici **192.168.56.10**

Vérification et installation des outils de base (dnf, nano, wget, firewalld, etc.)

Installation de **Docker** pour CTFd (voir doc de Docker)

## II. Déploiement de la plateforme CTF

**Déployer CTFd avec Docker**
- Cloner le dépôt CTFd depuis GitHub :
```bash
git clone https://github.com/CTFd/CTFd.git
cd CTFd
sudo docker compose up -d
```

- Accéder à la plateforme via `http://localhost:8000` (ou l'IP de ton serveur 192.168.56.10 ici) et créer un compte administrateur.

- Création de challenge comme tu le souhaites

**Vérification :**

S’assurer que la plateforme fonctionne bien et que les défis sont visibles dans l’interface d’administration.

## III. Sécurisation du serveur
    
### 1) Accès par clé uniquement

Création d'une clé avec :
```
ssh-keygen
```

Afficher la clé public :
```
type $env:USERPROFILE\.ssh\id_rsa.pub
```

Sur le serveur rocky créer un dossier et un fichier pour sauvegarder la clé :
```
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
```
    
Copier manuellement la clé dans le fichier (authorized_keys) et lui changer les permissions pour plus de sécurité :
```
chmod 600 ~/.ssh/authorized_keys 
(Lecture et écriture uniquement pour le propriétaire)

chmod 700 ~/.ssh 
(Lecture, écriture, et éxécution uniquement pour le propriétaire)
```

### 2) Suppression des accès SSH par mot de passe

Se connecter au serveur Rocky avec mot de passe une dernière fois puis :
```
sudo nano /etc/ssh/sshd_config
```

Modifie (ou décommente) ces lignes :

> PasswordAuthentication no

> ChallengeResponseAuthentication no

> UsePAM no

> PubkeyAuthentication yes ⚠️(Très important pour autoriser la clé)

Redémarrer le services ssh pour appliquer les modifications :
```
sudo systemctl restart sshd
```

### 3) Parefeu 

**✅ Autoriser uniquement :**
- Le port 22 pour SSH 

- Le port 8000 pour CTFd

```
# Activer le firewall si ce n’est pas déjà fait
sudo systemctl enable firewalld --now

# Supprimer toutes les règles par défaut 
sudo firewall-cmd --permanent --remove-service=ssh
sudo firewall-cmd --permanent --remove-service=http
sudo firewall-cmd --permanent --remove-service=https

# Autoriser le SSH 
sudo firewall-cmd --permanent --add-port=22/tcp

# Autoriser le port de CTFd
sudo firewall-cmd --permanent --add-port=8000/tcp

# Appliquer les règles
sudo firewall-cmd --reload

# Vérifier les règles appliquées
sudo firewall-cmd --list-all
```

## IV. Installation d’outils de sécurité🔍 
    - Installation de Suricata (ou Snort) pour l’analyse du trafic

        ```
        sudo dnf install epel-release -y

        sudo dnf install suricata -y
        ```

     - Allumer Suricata 
        ```
        sudo systemctl enable --now suricata
        ```
    -  Modifier le fichier de logs pour ajouter la bonne interface 
        ```
        sudo nano /etc/sysconfig/suricata

        si ça ne marche pas :
        sudo -i
        nano /etc/sysconfig/suricata

        Modifier la ligne options pour qu'elle corresponde à ça :
        OPTIONS="-i enp0s3"
        ```

    - Redémarrer Suricata :
    ```
    sudo systemctl restart suricata
    ```
    - Vérifier si Suricata fonctionne : 
    ```
    sudo systemctl status suricata
    ```
    ____


5. Machine attaquante : Kali Linux
    - Création d’une VM Kali

    - Lancement de scans (nmap, nikto, hydra, dirb)

    - Test des règles de sécurité : SSH bloqué ? HTTP autorisé ? Détection active ?

6. Journalisation et analyse
    
    Vérification des logs /var/log/secure, /var/log/messages, journaux Suricata

    ```
    sudo less /var/log/secure
    sudo less /var/log/messages
    sudo less /var/log/suricata/fast.log
    ```

    - Génération de rapports automatisés
    
        Pour générer un rapport, j'execute la commande :

    ```
    sudo logwatch --range today --detail high --service all --format text
    ```


    Script Bash pour sauvegarder les logs et résumer les attaques
    
    - Pour générer un rapport lisible par un utilisateur non-technique :

    ```
    sudo ./rapport_resume.sh
    ```

7. Bonus – Concepts avancés
    - Introduction à Zero Trust : aucune confiance accordée à aucune machine par défaut

    - IAM basique : ajout de rôles d’accès pour l’administration du serveur

    - Mise en place d’un VLAN si l’infrastructure réseau le permet

### 🛠️ Automatisation
- Script d'installation de CTFd et de configuration du pare-feu

- Script de hardening (désactivation des ports, installation d’outils de log, etc.)

- Script de backup automatique des logs

### 📊 Évaluation
Ce projet montre :

- La capacité à administrer un serveur de manière sécurisée

- Les compétences en virtualisation, configuration réseau, sécurité, et scripting

- Une mise en œuvre réaliste des outils professionnels : firewall, IDS, gestion des accès


--- 

# Critère

### ✅ ADMINISTRER UN SERVEUR
| Critère                                 | Réponse dans le projet                                                                                  |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **Installer et configurer un système**  | Installation de Rocky Linux, configuration IP, installation de CTFd                                     |
| **Diagnostiquer et réparer un système** | Surveillance avec logwatch et analyse des tentatives d’intrusion avec journaux et outils comme Suricata |
| **Automatiser des tâches simples**      | Scripts Bash pour hardening, backup, audit, configuration de base                                       |
| **Déployer des services**               | Déploiement de la plateforme CTF via CTFd (avec ou sans Docker), configuration de firewalld             |


### ✅ METTRE EN PLACE UNE INFRASTRUCTURE SYSTÈME ET RÉSEAU
| Critère                                        | Réponse dans le projet                                                                                                                          |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| **Adressage, routage, VLAN**                   | Possibilité d’ajouter un VLAN ou une séparation réseau avec pfSense/VirtualBox selon ton setup                                                  |
| **Haute disponibilité / Tolérance aux pannes** | Non prioritaire ici, mais on peut simuler un scénario HA avec backups et redémarrage automatique des services via `systemd` ou `docker restart` |
| **Connectivité WAN**                           | Configuration du réseau pour restreindre ou permettre l’accès WAN/HTTP au serveur via règles précises dans le pare-feu                          |


### ✅ GÉRER UN ENVIRONNEMENT VIRTUEL
| Critère                    | Réponse dans le projet                                                                                              |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **Virtualiser un système** | VMs pour Rocky Linux (serveur), Kali Linux (attaquant), Ubuntu/Debian (client si besoin)                            |
| **Virtualiser un réseau**  | Réseaux internes simulés via VirtualBox/Proxmox/VMware ; possibilité d’ajouter pfSense ou GNS3 pour aller plus loin |

### ✅ APPREHENDER LA SÉCURITÉ

| Critère                               | Réponse dans le projet                                                                                                         |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Terminologie sécurité**             | Mise en place de firewall, IDS, logs, audit, fail2ban/Suricata                                                                 |
| **Connaissance de la réglementation** | (À insérer dans le rapport : RGPD, notion de confidentialité, disponibilité, intégrité)                                        |
| **Démarche sécuritaire**              | Blocage SSH, logs détaillés, monitoring, audit, machine attaquante pour tester la robustesse                                   |
| **Zero Trust, IAM**                   | Aucun accès par défaut, accès limité aux IP de confiance, désactivation de services inutiles, gestion des comptes utilisateurs |
