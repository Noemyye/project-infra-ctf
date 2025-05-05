# Projet Cybersécurité : Serveur CTF sécurisé avec Rocky Linux

## 🎯 Objectif du projet

Mettre en place un serveur CTF auto-hébergé sous Rocky Linux avec CTFd, puis le sécuriser afin d'empêcher tout accès non autorisé, même en réseau local. Utiliser des outils d'analyse réseau pour détecter les tentatives d'intrusion et configurer une machine Kali Linux comme attaquante pour tester la résistance du système.

---

# Mi no comprendo 

🧱 Étapes de mise en place
1. Installation du serveur principal (Rocky Linux)
    - Installation de Rocky Linux sur une VM (ou serveur physique)✅

    - Configuration IP statique ✅

    - Installation des outils de base (dnf, nano, wget, firewalld, etc.)

2. Déploiement de la plateforme CTF
    - Installation de CTFd (via Docker ou en local)✅

    - Création d’un challenge simple✅

    - Configuration de l’accès local ou via VPN

3. Sécurisation du serveur
    - Suppression des accès SSH par mot de passe

    - Option 1 : accès par clé uniquement

    - Option 2 : interdiction totale de l’accès SSH (via firewalld)

    - Ajout de règles de pare-feu :

    - Refuser toutes les connexions sauf HTTP/HTTPS (CTFd)

    - Bloquer SSH même en LAN

4. Installation d’outils de sécurité🔍 
    - Installation de Suricata (ou Snort) pour l’analyse du trafic

🔐 Installation de logwatch pour centraliser les journaux

    - Ajout d’un script Bash pour lancer un audit de sécurité (ex : lynis ou rkhunter)

5. Machine attaquante : Kali Linux
    - Création d’une VM Kali

    - Lancement de scans (nmap, nikto, hydra, dirb)

    - Test des règles de sécurité : SSH bloqué ? HTTP autorisé ? Détection active ?

6. Journalisation et analyse
    - Vérification des logs /var/log/secure, /var/log/messages, journaux Suricata

    - Génération de rapports automatisés

    - Script Bash pour sauvegarder les logs et résumer les attaques

7. Bonus – Concepts avancés
    - Introduction à Zero Trust : aucune confiance accordée à aucune machine par défaut

    - IAM basique : ajout de rôles d’accès pour l’administration du serveur

    - Mise en place d’un VLAN si l’infrastructure réseau le permet

🛠️ Automatisation
    - Script d'installation de CTFd et de configuration du pare-feu

    - Script de hardening (désactivation des ports, installation d’outils de log, etc.)

    - Script de backup automatique des logs

📊 Évaluation
Ce projet montre :

Ta capacité à administrer un serveur de manière sécurisée

Tes compétences en virtualisation, configuration réseau, sécurité, et scripting

Une mise en œuvre réaliste des outils professionnels : firewall, IDS, gestion des accès