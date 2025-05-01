#!/bin/bash

# Script pour démarrer automatiquement un émulateur Android
echo "Vérification et démarrage d'un émulateur Android..."

# Charger les variables d'environnement depuis .env.local
if [ -f "$(pwd)/.env.local" ]; then
    export $(grep -v '^#' "$(pwd)/.env.local" | xargs)
    echo "Variables d'environnement chargées depuis .env.local"
fi

# Vérifier la version de Java
java_version=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed 's/^1\.//' | cut -d'.' -f1)
echo "Version Java détectée: $java_version"

if [ "$java_version" -lt "17" ]; then
    echo "ERREUR: Java 17 ou supérieur est requis pour le SDK Android moderne."
    echo "Veuillez installer une version plus récente de Java."
    echo "Vous pouvez utiliser SDKMAN (https://sdkman.io/) ou votre gestionnaire de paquets."
    echo "Par exemple: sudo apt install openjdk-17-jdk"
    exit 1
fi

# Vérifier si ANDROID_HOME est défini
if [ -z "$ANDROID_HOME" ]; then
    if [ -d "$HOME/Android/Sdk" ]; then
        ANDROID_HOME="$HOME/Android/Sdk"
    elif [ -d "$HOME/Library/Android/sdk" ]; then
        ANDROID_HOME="$HOME/Library/Android/sdk"
    else
        echo "ERREUR: Variable ANDROID_HOME non définie et aucun SDK Android trouvé aux emplacements par défaut."
        echo "Veuillez installer Android Studio ou définir ANDROID_HOME."
        exit 1
    fi
    echo "ANDROID_HOME défini à: $ANDROID_HOME"
fi

# Vérifier que les répertoires nécessaires existent
if [ ! -d "$ANDROID_HOME" ]; then
    echo "ERREUR: Le répertoire ANDROID_HOME ($ANDROID_HOME) n'existe pas."
    exit 1
fi

# Ajouter les outils android au PATH
echo "Configuration des chemins du SDK Android..."
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/emulator"

# Vérifier l'existence des outils
if ! command -v adb &> /dev/null; then
    echo "ERREUR: adb n'est pas disponible dans le PATH. Vérifiez votre installation d'Android SDK."
    echo "PATH actuel: $PATH"
    if [ -f "$ANDROID_HOME/platform-tools/adb" ]; then
        echo "adb trouvé à $ANDROID_HOME/platform-tools/adb mais pas dans le PATH"
        # Utiliser le chemin absolu comme solution de repli
        ADB="$ANDROID_HOME/platform-tools/adb"
    else
        echo "adb introuvable dans $ANDROID_HOME/platform-tools/"
        exit 1
    fi
else
    ADB="adb"
fi

# Vérifier l'existence de l'émulateur
EMULATOR_CMD=""
if command -v emulator &> /dev/null; then
    EMULATOR_CMD="emulator"
elif [ -f "$ANDROID_HOME/emulator/emulator" ]; then
    EMULATOR_CMD="$ANDROID_HOME/emulator/emulator"
else
    echo "ERREUR: La commande 'emulator' est introuvable. Vérifiez votre installation d'Android SDK."
    echo "PATH actuel: $PATH"
    exit 1
fi
echo "Commande émulateur trouvée: $EMULATOR_CMD"

# Vérifier si un appareil est déjà connecté
echo "Vérification des appareils connectés..."
DEVICES=$($ADB devices | grep -v "List" | grep "device" | wc -l)

if [ "$DEVICES" -gt 0 ]; then
    echo "Appareil Android déjà connecté! Utilisation de cet appareil."
    exit 0
fi

# Lister les émulateurs disponibles
echo "Recherche d'émulateurs disponibles..."
EMULATORS=$($EMULATOR_CMD -list-avds)

if [ -z "$EMULATORS" ]; then
    echo "Aucun émulateur trouvé. Création d'un nouvel émulateur..."
    
    # Vérifier les chemins des outils du SDK
    CMDLINE_TOOLS="$ANDROID_HOME/cmdline-tools"
    
    # Trouver le chemin du SDK Manager
    SDKMANAGER=""
    if [ -f "$CMDLINE_TOOLS/latest/bin/sdkmanager" ]; then
        SDKMANAGER="$CMDLINE_TOOLS/latest/bin/sdkmanager"
    elif [ -f "$CMDLINE_TOOLS/tools/bin/sdkmanager" ]; then
        SDKMANAGER="$CMDLINE_TOOLS/tools/bin/sdkmanager"
    else
        # Rechercher dans tous les sous-répertoires
        SDKMANAGER=$(find "$CMDLINE_TOOLS" -name "sdkmanager" -type f | head -1)
    fi
    
    # Trouver le chemin du AVD Manager
    AVDMANAGER=""
    if [ -f "$CMDLINE_TOOLS/latest/bin/avdmanager" ]; then
        AVDMANAGER="$CMDLINE_TOOLS/latest/bin/avdmanager"
    elif [ -f "$CMDLINE_TOOLS/tools/bin/avdmanager" ]; then
        AVDMANAGER="$CMDLINE_TOOLS/tools/bin/avdmanager"
    else
        # Rechercher dans tous les sous-répertoires
        AVDMANAGER=$(find "$CMDLINE_TOOLS" -name "avdmanager" -type f | head -1)
    fi
    
    if [ -z "$SDKMANAGER" ] || [ -z "$AVDMANAGER" ]; then
        echo "ERREUR: sdkmanager ou avdmanager introuvable."
        echo "Veuillez installer les Command Line Tools via Android Studio."
        exit 1
    fi
    
    echo "Installation d'une image système Android 32 (compatible avec Java 11+)..."
    echo "y" | "$SDKMANAGER" "system-images;android-32;google_apis;x86_64"
    
    echo "Création d'un émulateur Android..."
    echo "no" | "$AVDMANAGER" create avd -n "ExpoDevice" -k "system-images;android-32;google_apis;x86_64" -d "pixel_5"
    
    EMULATORS="ExpoDevice"
    echo "Émulateur 'ExpoDevice' créé avec succès!"
fi

# Choisir le premier émulateur disponible
AVD_NAME=$(echo "$EMULATORS" | head -n 1)
echo "Démarrage de l'émulateur: $AVD_NAME"

# Démarrer l'émulateur en arrière-plan
echo "Exécution de: $EMULATOR_CMD -avd $AVD_NAME -no-boot-anim -no-audio -no-snapshot"
"$EMULATOR_CMD" -avd "$AVD_NAME" -no-boot-anim -no-audio -no-snapshot &
EMULATOR_PID=$!

# Attendre que l'émulateur démarre
echo "Attente du démarrage de l'émulateur..."
$ADB wait-for-device

# Vérifier si l'émulateur est prêt
BOOT_COMPLETE=0
MAX_ATTEMPTS=30
ATTEMPT=0

echo "Vérification du démarrage complet de l'émulateur..."
while [ $BOOT_COMPLETE -eq 0 ] && [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    BOOT_COMPLETE=$($ADB shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
    if [ -z "$BOOT_COMPLETE" ]; then
        BOOT_COMPLETE=0
    fi
    ATTEMPT=$((ATTEMPT+1))
    sleep 2
    echo "Démarrage en cours... Tentative $ATTEMPT/$MAX_ATTEMPTS"
done

if [ $ATTEMPT -ge $MAX_ATTEMPTS ]; then
    echo "AVERTISSEMENT: Délai d'attente dépassé, mais l'émulateur pourrait encore être en cours de démarrage."
    echo "Continuez avec l'exécution de votre application, mais elle pourrait ne pas se connecter immédiatement."
else
    echo "Émulateur Android démarré avec succès!"
fi

echo "Vous pouvez maintenant exécuter votre application sur cet émulateur."
echo "Pour voir l'interface de l'émulateur, vous pouvez aussi le démarrer normalement via Android Studio."

exit 0