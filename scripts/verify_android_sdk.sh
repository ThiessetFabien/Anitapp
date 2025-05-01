#!/bin/bash

# Script pour vérifier et préparer l'environnement Android SDK
echo "Vérification de l'environnement Android SDK..."

# Vérifier la version de Java
java_version=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed 's/^1\.//' | cut -d'.' -f1)
echo "Version Java détectée: $java_version"

if [ "$java_version" -lt "17" ]; then
    echo "AVERTISSEMENT: Java 17 ou supérieur est recommandé pour le SDK Android moderne."
    echo "Votre version Java actuelle ($java_version) peut ne pas fonctionner avec les derniers outils Android."
    echo "Considérez installer une version plus récente:"
    echo "  - Sous Ubuntu/Debian: sudo apt install openjdk-17-jdk"
    echo "  - Avec SDKMAN: sdk install java 17.0.7-tem"
fi

# Définir ANDROID_HOME s'il n'est pas déjà défini
if [ -z "$ANDROID_HOME" ]; then
    if [ -d "$HOME/Android/Sdk" ]; then
        ANDROID_HOME="$HOME/Android/Sdk"
    elif [ -d "$HOME/Library/Android/sdk" ]; then
        ANDROID_HOME="$HOME/Library/Android/sdk"
    else
        echo "ERREUR: Variable ANDROID_HOME non définie et aucun SDK Android trouvé aux emplacements par défaut."
        echo "Veuillez installer Android Studio ou définir ANDROID_HOME manuellement."
        exit 1
    fi
    echo "ANDROID_HOME défini à: $ANDROID_HOME"
fi

# Exporter ANDROID_HOME pour les futurs scripts
echo "export ANDROID_HOME=$ANDROID_HOME" > "$(pwd)/.env.android"

# Vérifier l'existence du répertoire ANDROID_HOME
if [ ! -d "$ANDROID_HOME" ]; then
    echo "ERREUR: Le répertoire ANDROID_HOME ($ANDROID_HOME) n'existe pas."
    echo "Veuillez installer Android Studio ou vérifier la variable ANDROID_HOME."
    exit 1
fi

# Vérifier l'existence des outils CLI
CMDLINE_TOOLS="$ANDROID_HOME/cmdline-tools"
if [ ! -d "$CMDLINE_TOOLS" ]; then
    echo "AVERTISSEMENT: Command Line Tools non trouvés dans $CMDLINE_TOOLS"
    echo "Vous devriez installer Command Line Tools via Android Studio."
    
    # Créer le répertoire cmdline-tools s'il n'existe pas
    mkdir -p "$CMDLINE_TOOLS"
fi

# Vérifier si les Command Line Tools sont déjà installés
if [ ! -d "$CMDLINE_TOOLS/latest" ] && [ ! -d "$CMDLINE_TOOLS/tools" ]; then
    echo "Installation des Command Line Tools..."
    
    # Télécharger la dernière version des Command Line Tools
    TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip"
    TOOLS_ZIP="/tmp/commandlinetools-latest.zip"
    
    echo "Téléchargement de $TOOLS_URL..."
    if command -v wget &> /dev/null; then
        wget -q "$TOOLS_URL" -O "$TOOLS_ZIP"
    elif command -v curl &> /dev/null; then
        curl -sL "$TOOLS_URL" -o "$TOOLS_ZIP"
    else
        echo "ERREUR: Ni wget ni curl n'est disponible. Veuillez installer l'un d'eux."
        exit 1
    fi
    
    # Décompresser dans un répertoire temporaire
    TMP_DIR="/tmp/cmdline-tools"
    mkdir -p "$TMP_DIR"
    unzip -q -o "$TOOLS_ZIP" -d "$TMP_DIR"
    
    # Déplacer les outils dans le bon répertoire
    mkdir -p "$CMDLINE_TOOLS/latest"
    cp -r "$TMP_DIR/cmdline-tools"/* "$CMDLINE_TOOLS/latest/"
    
    # Nettoyer
    rm -rf "$TMP_DIR" "$TOOLS_ZIP"
    
    echo "Command Line Tools installés avec succès!"
fi

# Ajouter les outils Android au PATH
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/emulator:$CMDLINE_TOOLS/latest/bin:$CMDLINE_TOOLS/tools/bin"

# Trouver sdkmanager
SDKMANAGER=""
if [ -f "$CMDLINE_TOOLS/latest/bin/sdkmanager" ]; then
    SDKMANAGER="$CMDLINE_TOOLS/latest/bin/sdkmanager"
elif [ -f "$CMDLINE_TOOLS/tools/bin/sdkmanager" ]; then
    SDKMANAGER="$CMDLINE_TOOLS/tools/bin/sdkmanager"
else
    # Rechercher dans tous les sous-répertoires
    SDKMANAGER=$(find "$CMDLINE_TOOLS" -name "sdkmanager" -type f | head -1)
fi

if [ -z "$SDKMANAGER" ]; then
    echo "ERREUR: sdkmanager introuvable. L'installation des Command Line Tools a échoué."
    exit 1
fi

echo "sdkmanager trouvé à: $SDKMANAGER"

# Vérifier et installer les packages essentiels
echo "Vérification et installation des packages Android essentiels..."

# Répondre automatiquement "y" à toutes les questions
echo "y" | "$SDKMANAGER" --update
echo "y" | "$SDKMANAGER" "platform-tools" "platforms;android-32" "build-tools;32.0.0"
echo "y" | "$SDKMANAGER" "system-images;android-32;google_apis;x86_64"
echo "y" | "$SDKMANAGER" "emulator"

# Vérifier que ADB est disponible
if [ ! -f "$ANDROID_HOME/platform-tools/adb" ]; then
    echo "ERREUR: ADB n'a pas été installé correctement."
    exit 1
fi

# Vérifier que l'émulateur est disponible
if [ ! -f "$ANDROID_HOME/emulator/emulator" ]; then
    echo "ERREUR: L'émulateur n'a pas été installé correctement."
    exit 1
fi

echo "=== Environnement Android SDK vérifié et préparé avec succès ==="
echo "ANDROID_HOME: $ANDROID_HOME"
echo "Pour créer un nouvel émulateur, utilisez: npm run emulator"
echo "Pour exécuter votre application: npm run android-dev"

exit 0