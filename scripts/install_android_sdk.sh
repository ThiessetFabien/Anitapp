#!/bin/zsh

# Script d'installation du SDK Android pour EndeavourOS/Arch Linux
echo "Installation du SDK Android pour EndeavourOS"

# 1. Installation des dépendances
echo "Installation des dépendances..."
sudo pacman -S --needed jdk-openjdk libxrender libxtst libxi unzip gradle

# 2. Création du répertoire pour le SDK
mkdir -p ~/Android/Sdk
cd ~/Android/Sdk

# 3. Téléchargement du Command Line Tools Only
echo "Téléchargement des Command Line Tools..."
wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip

# 4. Décompression des outils
echo "Décompression des outils..."
unzip commandlinetools-linux-10406996_latest.zip
rm commandlinetools-linux-10406996_latest.zip

# 5. Création de la structure de répertoires attendue par sdkmanager
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null
rmdir cmdline-tools/latest/cmdline-tools 2>/dev/null

# 6. Installation des composants SDK nécessaires
echo "Installation des composants SDK nécessaires..."
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Accepter les licences
yes | sdkmanager --licenses

# Installer les packages essentiels
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0" "emulator"

# 7. Configuration des variables d'environnement
echo "Configuration des variables d'environnement..."
echo '# Android SDK' >> ~/.zshrc
echo 'export ANDROID_HOME=~/Android/Sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc

# 8. Mise à jour du fichier .env.local dans le projet
echo "Mise à jour du fichier .env.local dans le projet..."
echo "ANDROID_HOME=~/Android/Sdk" > /home/fabien/Projets/Anita/.env.local

echo "Installation terminée !"
echo "Redémarrez votre terminal ou exécutez 'source ~/.zshrc' pour appliquer les modifications."
echo "Vous pouvez maintenant utiliser 'npm run android' dans votre projet."