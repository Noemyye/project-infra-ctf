Voici un **cahier des charges** détaillé pour ton projet de mise en place d'un **CTF auto-hébergé avec un focus réseau, Linux et infrastructure**. Ce projet est conçu pour que tu puisses progresser à ton rythme, en commençant par des tâches simples et en ajoutant progressivement des éléments plus complexes.

---
Noémie Dublanc, Ingrid Lare, Maxime Isidore
---

## 🎯 **Cahier des charges : Projet CTF Auto-Hébergé avec Réseau, Linux et Infrastructure**

### 1. **Objectif du projet**
L’objectif est de mettre en place une plateforme de **Capture The Flag (CTF)** auto-hébergée qui permet de résoudre des défis en cybersécurité tout en intégrant un focus sur la **sécurisation du réseau**, **l’utilisation de machines Linux** et la **mise en place d’une infrastructure de surveillance**. Ce projet sera évolutif, en commençant par des éléments de base pour arriver à une architecture complète avec la gestion du trafic réseau et la détection d’intrusions.

---

### 2. **Technologies nécessaires**
Voici les **outils et technologies** qui seront utilisés pour ce projet :

- **CTFd** : plateforme d’hébergement de CTF (permet de gérer les défis, scores, etc.).
- **Docker** : utilisé pour déployer CTFd et des services dans un environnement isolé.
- **Proxmox** : gestionnaire de machines virtuelles (pour isoler les différentes parties du projet).
- **VMs** : Kali Linux (machine d'attaque), Ubuntu/Debian (machines vulnérables), pfSense (pare-feu), etc.
- **Suricata** : IDS (Intrusion Detection System) pour surveiller les attaques réseau.
- **Nginx** : serveur web pour héberger des services dans les machines vulnérables.
- **Wireshark** et **Tcpdump** : pour analyser le trafic réseau.

---

### 3. **Détails des étapes du projet**

#### **Phase 1 : Mise en place de la plateforme CTF (facile)**

1. **Installer Docker sur un serveur Linux**
   - Utiliser **Ubuntu** ou **Debian** pour le système d'exploitation du serveur.
   - Installer Docker et Docker Compose :
     ```
     sudo apt update
     (voir sur la doc de docker pour l'installer)
     ```

2. **Déployer CTFd avec Docker**
   - Cloner le dépôt CTFd depuis GitHub :
     ```bash
     git clone https://github.com/CTFd/CTFd.git
     cd CTFd
     sudo docker compose up -d
     ```
   - Accéder à la plateforme via `http://localhost:8000` (ou l'IP de ton serveur 192.168.56.10 ici) et créer un compte administrateur.
   - Ajouter des **challenges préexistants** téléchargés depuis des plateformes comme CTFtime, Vulnhub, etc.

3. **Vérification**
   - S’assurer que la plateforme fonctionne bien et que les défis sont visibles dans l’interface d’administration.

---

#### **Phase 2 : Mise en place des machines virtuelles et environnement de test (intermédiaire)**

1. **Installer Proxmox**  
   - Installer **Proxmox** sur un serveur ou une machine dédiée pour gérer les VMs.
   - Créer les machines virtuelles suivantes :  
     - **Kali Linux** (machine attaquante).  
     - **Metasploitable / Ubuntu / Debian** (machine vulnérable).  
     - **pfSense** (pare-feu).

2. **Configurer le réseau avec pfSense**
   - **pfSense** servira à filtrer et surveiller le trafic réseau entre les différentes VMs.
   - Configurer pfSense pour analyser le trafic réseau et bloquer certaines attaques (par exemple, attaques par brute force sur SSH).
   - Connecter les VMs à pfSense pour contrôler le trafic entrant et sortant.

3. **Vérification**
   - Tester le réseau en lançant des attaques simples depuis Kali Linux (par exemple, un scan nmap) et s'assurer que pfSense bloque ou logge les connexions.

---

#### **Phase 3 : Sécurisation et surveillance réseau (avancé)**

1. **Installer et configurer Suricata pour la détection d’intrusions**
   - Suricata sera installé sur **pfSense** pour surveiller le trafic réseau et détecter les attaques en temps réel.
   - Configurer des règles de base pour détecter des attaques courantes (par exemple, attaques par SQL injection, attaques par force brute, etc.).
   - Analyser les logs générés par Suricata dans une interface comme **Kibana** ou **Grafana** pour avoir des visualisations en temps réel.

2. **Ajouter des défis réseau sur CTFd**
   - Ajouter des **challenges orientés réseau** : par exemple, des défis sur l’exploitation des services réseau, l’analyse de paquets, ou la manipulation du trafic.
   - Les participants devront résoudre des problèmes de sécurité réseau, et ces défis peuvent être surveillés par Suricata pour voir les attaques en temps réel.

3. **Analyser le trafic avec Wireshark et Tcpdump**
   - Configurer **Wireshark** ou **Tcpdump** pour capturer le trafic réseau entre les machines.
   - Les utilisateurs devront peut-être résoudre des défis qui incluent l’analyse d’un fichier de capture ou la détection d'une vulnérabilité exploitée via le réseau.

4. **Vérification**
   - Effectuer des tests pour s'assurer que **Suricata** détecte correctement les attaques et que **pfSense** bloque ou filtre le trafic de manière adéquate.

---

### 4. **Livrables**
À la fin du projet, tu devras obtenir :

- **Une plateforme CTF** fonctionnelle (CTFd) où des défis peuvent être résolus par les participants.
- **Des machines virtuelles** configurées, dont une machine attaquante (Kali Linux) et une machine vulnérable (Ubuntu/Debian).
- **Un pare-feu pfSense** configuré pour surveiller et filtrer le trafic réseau.
- **Un IDS (Suricata)** installé pour détecter les attaques en temps réel et visualiser les événements dans Kibana ou Grafana.
- Des **challenges de cybersécurité** ajoutés à la plateforme CTFd, en particulier orientés sur le réseau et les vulnérabilités des services.

---

### 5. **Matériel requis**
- **Un serveur ou une machine dédiée** avec assez de mémoire (minimum 8 Go de RAM recommandé) pour faire tourner plusieurs VMs simultanément.
- **Proxmox ou VirtualBox** pour gérer les machines virtuelles.
- **Accès à Internet** pour télécharger les outils nécessaires (Docker, CTFd, VMs, etc.).

---

### 6. **Planning estimé**
Voici un plan de travail possible sur **2 à 3 semaines**, en fonction de ton rythme :

- **Semaine 1** : Installer Docker et CTFd, ajouter des défis, tester la plateforme CTF.  
- **Semaine 2** : Installer Proxmox et créer des VMs Kali Linux et Metasploitable, configurer pfSense.  
- **Semaine 3** : Installer Suricata, ajouter des défis réseau sur CTFd, tester la surveillance et l’analyse du trafic.

---

### 7. **Points de vérification**
- **CTFd** doit être accessible et fonctionnelle.
- **Proxmox** doit être correctement configuré pour gérer plusieurs VMs.
- Le **pare-feu pfSense** doit contrôler le trafic réseau.
- **Suricata** doit être capable de détecter des attaques sur le réseau.
- Les **défis de cybersécurité** doivent être clairs et résoudre des problèmes concrets de réseau et sécurité.

---

Si tu as des questions ou si tu veux qu’on adapte certaines parties, n’hésite pas à me le dire ! Ce projet peut vraiment être une bonne expérience pour te plonger dans le monde de la cybersécurité. 😊