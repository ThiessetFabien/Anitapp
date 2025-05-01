# Mise à jour de Java sur EndeavourOS

Ce dossier contient des scripts utilitaires pour configurer l'environnement de développement Android, notamment la mise à jour de Java.

## Comment mettre à jour Java

EndeavourOS étant basé sur Arch Linux, il existe plusieurs méthodes pour installer et gérer les versions de Java. Le script `update_java.sh` simplifie ce processus.

### Méthode 1 : Utiliser le script automatique

1. Rendez le script exécutable :
   ```bash
   chmod +x ./scripts/update_java.sh
   ```

2. Exécutez le script avec les privilèges administrateur :
   ```bash
   sudo ./scripts/update_java.sh
   ```

3. Suivez les instructions à l'écran pour choisir la version de Java à installer.

### Méthode 2 : Installation manuelle via pacman

Si vous préférez l'installation manuelle, vous pouvez utiliser directement `pacman` :

```bash
# Mettre à jour la liste des paquets
sudo pacman -Sy

# Installer OpenJDK 17 (recommandé pour Android Studio)
sudo pacman -S jdk17-openjdk

# Définir comme version par défaut
sudo archlinux-java set java-17-openjdk
```

### Méthode 3 : Utiliser SDKMAN

SDKMAN est un outil de gestion de versions pour de nombreuses SDK, y compris Java.

1. Installer SDKMAN (si ce n'est pas déjà fait) :
   ```bash
   curl -s "https://get.sdkman.io" | bash
   source "$HOME/.sdkman/bin/sdkman-init.sh"
   ```

2. Installer Java 17 :
   ```bash
   sdk install java 17.0.7-tem
   ```

3. Pour basculer entre versions :
   ```bash
   sdk use java 17.0.7-tem
   ```

## Vérification de l'installation

Pour vérifier votre installation Java :

```bash
java -version
javac -version
```

## Configuration pour Android Studio

Pour Android Studio et le développement d'applications mobiles, Java 17 est recommandé. Le script `update_java.sh` configure automatiquement les variables d'environnement nécessaires dans le fichier `.env.java`.