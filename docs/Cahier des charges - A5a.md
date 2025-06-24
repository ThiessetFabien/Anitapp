## 1. Contexte et objectifs

### 1.1 Contexte
Développement d'un launcher Android personnalisé "A5a" pour une résidente en maison d'accueil spécialisé, présentant une déficience intellectuelle avec troubles de la mémoire et difficultés de concentration. Le projet vise à remplacer Nova Launcher par une solution plus adaptée à ses besoins spécifiques.

### 1.2 Objectifs principaux
- Faciliter l'accès aux communications familiales (2 frères) via téléphone natif
- Permettre le lancement rapide de ses jeux habituels (mémoire, puzzle du Play Store)
- Donner un accès direct et simplifié aux recherches Dalida sur YouTube
- Garantir une interface avec des icônes/tuiles suffisamment grandes
- Prévenir les appels accidentels aux services d'urgence

## 2. Public cible et besoins spécifiques

### 2.1 Utilisateur principal
- Personne adulte avec déficience intellectuelle
- Troubles de la mémoire et oublis fréquents
- Manque de persistance dans ses souhaits
- Difficulté à arrêter une action en cours
- Utilise actuellement une tablette Archos avec Nova Launcher

### 2.2 Besoins identifiés
- Interface épurée et intuitive avec tuiles/icônes agrandies (Nova Launcher insuffisant)
- Gros boutons facilement identifiables (difficultés de clic sur petits éléments)
- Utilisation préférentielle en mode paysage
- Navigation simplifiée sans menus complexes
- Prévention des erreurs d'utilisation et des appels d'urgence accidentels

### 2.3 Environnement d'usage et matériel
- Utilisation en maison d'accueil spécialisé
- Équipe d'accompagnement : AS (Aide-Soignants) et AMP (Aide Médico-Psychologique)
- Support technique : développeur fullstack JavaScript sur site
- **Matériel** : Tablette Archos T1015 FHD 4G
- **Protection appels** : Application tierce avec code PIN déjà installée

## 3. Interface principale et fonctionnalités

### 3.0 Conception générale
**Interface unifiée** : Grille unique 3x3 en mode paysage contenant tous les éléments :
- 2 boutons d'appel (frères)
- 1 bouton Dalida (YouTube)
- 4-6 jeux favoris
- Total : 7-9 éléments maximum dans la grille

### 3.1 Éléments "Communications"
**Objectif** : 2 boutons d'appel intégrés dans la grille principale

**Fonctionnalités détaillées :**
- 2 contacts préenregistrés avec photos des frères
- Boutons d'appel de très grande taille (minimum 150x150px)
- Intégration avec l'application téléphone native Android
- Confirmation visuelle obligatoire avant l'appel
- Protection déjà assurée par application tierce avec code PIN
- Historique des derniers appels limité et simplifié

**Critères d'acceptation :**
- L'utilisatrice peut identifier visuellement chaque frère
- L'appel se lance en maximum 2 clics avec confirmation
- Protection d'urgence gérée par l'app existante
- Feedback visuel immédiat (pas de retour sonore nécessaire)

### 3.2 Éléments "Jeux"
**Objectif** : 4-6 boutons de jeux intégrés dans la grille principale

**Fonctionnalités détaillées :**
- 4-6 jeux favoris affichés directement dans la grille 3x3
- Icônes de jeux agrandies (minimum 150x150px)
- Lancement direct des applications Play Store installées
- Mémorisation des jeux préférés de l'utilisatrice
- Pas de navigation séparée - tout sur le même écran

**Critères d'acceptation :**
- 4-6 jeux maximum dans la grille principale
- Icônes de jeux minimum 150x150px
- Temps de lancement des jeux < 3 secondes
- Retour au launcher automatique quand on quitte un jeu

### 3.3 Élément "Musique Dalida"
**Objectif** : 1 bouton Dalida intégré dans la grille principale

**Fonctionnalités détaillées :**
- Bouton unique "Dalida" affiché directement dans la grille 3x3
- Icône agrandie (minimum 150x150px)
- Ouverture directe d'une recherche YouTube préformatée "Dalida"
- Lancement de l'application YouTube native ou navigateur
- Retour au launcher facilité

**Critères d'acceptation :**
- Accès à la recherche Dalida en 1 clic depuis la grille
- Ouverture automatique des résultats YouTube
- Icône Dalida minimum 150x150px
- Intégration harmonieuse dans la grille avec les autres éléments

## 4. Exigences techniques

### 4.1 Plateforme et matériel
- **OS cible** : Android (Tablette Archos T1015 FHD 4G)
- **Framework** : React Native
- **Styling** : Tailwind CSS (NativeWind)
- **Orientation** : Mode paysage obligatoire et verrouillé
- **Disposition** : Grille 3x3 (9 éléments maximum par écran)
- **Permissions** : Accès téléphone, contacts, lancement d'applications

### 4.2 Interface principale
- **Page unique** : Launcher par défaut sans navigation complexe
- **Évolutivité** : Architecture modulaire pour ajouts futurs faciles
- **Configuration** : Interface d'administration pour gestion contacts/jeux
- **Open Source** : Code disponible publiquement (portfolio développeur)

### 4.3 Performances
- Temps de démarrage : < 2 secondes
- Réactivité interface : < 200ms par action
- Consommation mémoire : < 150MB
- Stabilité : Fonctionnement 24h/7j sans redémarrage

### 4.4 Connectivité et déploiement
- Connexion Internet requise pour YouTube
- Accès aux contacts téléphone natifs Android
- Lancement d'applications Play Store installées
- **Installation** : APK direct sur appareil
- **Mises à jour** : Manuelles pour le moment (automatisation non prioritaire)

## 5. Exigences d'accessibilité

### 5.1 Interface utilisateur
- **Taille des boutons** : Minimum 150x150px (plus grand que Nova Launcher)
- **Contraste** : Ratio 4.5:1 minimum
- **Police** : Sans-serif, taille 28px minimum
- **Couleurs** : Palette réduite et contrastée
- **Pictogrammes** : Universels et explicites

### 5.2 Navigation
- Navigation au clavier complète
- Pas de double-clic requis
- Confirmations pour actions importantes
- Retour à l'accueil toujours possible

### 5.3 Retours utilisateur
- Feedback visuel immédiat (pas de retours sonores nécessaires)
- Messages d'erreur simples et clairs
- Confirmations visuelles pour actions importantes

## 6. Contraintes et limitations

### 6.1 Contraintes techniques
- Pas d'accès administrateur requis sur la tablette
- Installation simplifiée par APK direct
- Optimisation pour Archos T1015 FHD 4G

### 6.2 Contraintes d'usage
- Configuration initiale par l'équipe technique/éducative
- Évolutivité requise pour ajouts futurs (nouveaux contacts/jeux)
- Interface d'administration pour maintenance

### 6.3 Contraintes projet
- Développement bénévole (1 développeur)
- Code open source pour portfolio
- Pas de budget alloué

## 7. Critères d'acceptation généraux

### 7.1 Utilisabilité
- L'utilisateur peut réaliser chaque tâche principale sans aide après 1 session de formation
- Taux d'erreur inférieur à 5% après familiarisation
- Satisfaction utilisateur mesurée positivement

### 7.2 Fiabilité
- Aucun crash pendant 8h d'utilisation continue
- Récupération automatique en cas d'erreur
- Sauvegarde automatique des préférences

### 7.3 Performance
- Réponse instantanée aux interactions utilisateur
- Chargement fluide des contenus multimédias
- Optimisation pour matériel standard

## 8. Planning et livrables

### Phase 1 : Analyse et conception (2 semaines)
- Maquettes détaillées
- Architecture technique
- Spécifications fonctionnelles

### Phase 2 : Développement core (4 semaines)
- Interface principale
- Module communications
- Module jeux

### Phase 3 : Intégration multimédia (2 semaines)
- Module musique Dalida
- Optimisations performances
- Tests d'accessibilité

### Phase 4 : Tests et déploiement (1 semaine)
- Tests utilisateur
- Corrections finales
- Packaging et documentation

## 9. Maintenance et évolution

### 9.1 Maintenance corrective
- Corrections de bugs critiques sous 24h
- Mises à jour de sécurité automatiques
- Support technique dédié

### 9.2 Évolutions possibles
- Ajout de nouveaux contacts
- Extension de la bibliothèque musicale
- Intégration d'autres services accessibles
- Personnalisation avancée de l'interface