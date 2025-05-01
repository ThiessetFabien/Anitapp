#!/bin/bash

# Script pour installer/mettre à jour Java sur EndeavourOS/Arch Linux
echo "==============================================="
echo "Script d'installation/mise à jour de Java sur EndeavourOS"
echo "==============================================="

# Vérifier si le script est exécuté avec les privilèges root
if [ "$EUID" -ne 0 ]; then
    echo "Ce script nécessite des privilèges administrateur."
    echo "Veuillez l'exécuter avec sudo:"
    echo "sudo ./update_java.sh"
    exit 1
fi

# Mettre à jour la liste des paquets
echo "Mise à jour de la liste des paquets..."
pacman -Sy

# Afficher les versions de Java actuellement installées
echo "Versions de Java actuellement installées:"
pacman -Q | grep -E 'jre|jdk|java'

echo "==============================================="
echo "OPTIONS D'INSTALLATION DE JAVA:"
echo "1) OpenJDK 17 (LTS, recommandé pour Android Studio)"
echo "2) OpenJDK 21 (LTS, plus récent)"
echo "3) OpenJDK 8 (ancien, pour compatibilité)"
echo "4) Oracle JDK 17 via AUR (nécessite yay/paru)"
echo "5) Tous les OpenJDKs (8, 17 et 21)"
echo "6) Quitter sans rien installer"
echo "==============================================="

read -p "Votre choix (1-6): " choice

case $choice in
    1)
        echo "Installation d'OpenJDK 17..."
        pacman -S --needed jdk17-openjdk
        archlinux-java set java-17-openjdk
        ;;
    2)
        echo "Installation d'OpenJDK 21..."
        pacman -S --needed jdk21-openjdk
        archlinux-java set java-21-openjdk
        ;;
    3)
        echo "Installation d'OpenJDK 8..."
        pacman -S --needed jdk8-openjdk
        archlinux-java set java-8-openjdk
        ;;
    4)
        echo "Installation d'Oracle JDK 17 via AUR..."
        if command -v yay &> /dev/null; then
            yay -S jdk17-oracle
            archlinux-java set java-17-oracle
        elif command -v paru &> /dev/null; then
            paru -S jdk17-oracle
            archlinux-java set java-17-oracle
        else
            echo "Ni yay ni paru n'est installé. Installation de yay..."
            pacman -S --needed git base-devel
            sudo -u "$SUDO_USER" bash -c "
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
                yay -S jdk17-oracle
            "
            archlinux-java set java-17-oracle
        fi
        ;;
    5)
        echo "Installation de toutes les versions d'OpenJDK..."
        pacman -S --needed jdk8-openjdk jdk17-openjdk jdk21-openjdk
        echo "Définition d'OpenJDK 17 comme version par défaut..."
        archlinux-java set java-17-openjdk
        ;;
    6)
        echo "Aucune action effectuée. Au revoir!"
        exit 0
        ;;
    *)
        echo "Choix invalide. Sortie."
        exit 1
        ;;
esac

# Vérifier l'installation
echo "==============================================="
echo "Vérification de l'installation de Java:"
java -version
javac -version
echo "==============================================="

# Afficher les versions disponibles et la version par défaut
echo "Toutes les versions de Java disponibles sur le système:"
archlinux-java status

echo "==============================================="
echo "Installation terminée!"
echo "Pour changer la version par défaut de Java ultérieurement, utilisez:"
echo "sudo archlinux-java set NOM_VERSION"
echo "Exemple: sudo archlinux-java set java-17-openjdk"
echo "==============================================="

# Créer un fichier .env.java avec les chemins Java pour les scripts
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
echo "# Fichier généré automatiquement par update_java.sh" > /home/$SUDO_USER/Projets/Anita/.env.java
echo "export JAVA_HOME=$JAVA_HOME" >> /home/$SUDO_USER/Projets/Anita/.env.java
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /home/$SUDO_USER/Projets/Anita/.env.java
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/Projets/Anita/.env.java

echo "Variables d'environnement Java ajoutées dans .env.java"
echo "Pour les charger dans votre shell, utilisez: source .env.java"

exit 0