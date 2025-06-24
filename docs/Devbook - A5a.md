# Devbook - A5a Launcher Android

## Table des matières
1. [Vue d'ensemble technique](#1-vue-densemble-technique)
2. [Architecture par feature](#2-architecture-par-feature)
3. [Configuration de l'environnement](#3-configuration-de-lenvironnement)
4. [Méthodologie TDD](#4-méthodologie-tdd)
5. [Qualité du code (ESLint/Prettier)](#5-qualité-du-code-eslintprettier)
6. [Gestion des commits (Commitlint)](#6-gestion-des-commits-commitlint)
7. [Implémentation des features](#7-implémentation-des-features)
8. [Interfaces et types TypeScript](#8-interfaces-et-types-typescript)
9. [Intégrations natives Android](#9-intégrations-natives-android)
10. [Tests et validation](#10-tests-et-validation)
11. [Build et déploiement](#11-build-et-déploiement)
12. [Maintenance et debugging](#12-maintenance-et-debugging)

---

## 1. Vue d'ensemble technique

### 1.1 Stack technologique
```
Framework: React Native 0.72+
Language: TypeScript
Styling: NativeWind (Tailwind CSS for React Native)
State Management: React Context + useReducer
Storage: AsyncStorage
Build: React Native CLI
Target: Android 8.0+ (API 26+)
```

### 1.2 Architecture générale
```
A5a Launcher
├── Interface principale (Grille 3x3)
├── Module Communications (2 contacts)
├── Module Jeux (4-6 applications)
├── Module Dalida (YouTube)
├── Configuration/Admin
└── Persistance des données
```

### 1.3 Contraintes techniques spécifiques
- **Orientation verrouillée** : Landscape uniquement
- **Taille minimale des boutons** : 150x150px
- **Performance** : Démarrage < 2s, réactivité < 200ms
- **Mémoire** : Consommation < 150MB
- **Cible** : Tablette Archos T1015 FHD 4G
- **Grille 3x3** : Maximum 9 éléments (2 contacts + 1 Dalida + 1 Admin + 4-6 jeux)
- **Page unique** : Pas de navigation complexe, tout sur le même écran
- **Confirmations visuelles** : Obligatoires pour actions importantes (appels)

---

## 2. Architecture par feature

### 2.1 Principe d'organisation par feature
L'architecture suit le principe **"Feature-First"** où chaque fonctionnalité métier est encapsulée dans son propre module avec ses composants, services, tests et types.

### 2.2 Structure des dossiers par feature
```
src/
├── shared/
│   ├── components/
│   │   ├── ui/
│   │   │   ├── Button/
│   │   │   │   ├── Button.tsx
│   │   │   │   ├── Button.test.tsx
│   │   │   │   └── Button.styles.ts
│   │   │   ├── Modal/
│   │   │   │   ├── Modal.tsx
│   │   │   │   ├── Modal.test.tsx
│   │   │   │   └── Modal.styles.ts
│   │   │   └── Grid/
│   │   │       ├── Grid.tsx
│   │   │       ├── Grid.test.tsx
│   │   │       └── Grid.styles.ts
│   │   └── layout/
│   │       ├── MainLayout/
│   │       │   ├── MainLayout.tsx
│   │       │   ├── MainLayout.test.tsx
│   │       │   └── MainLayout.styles.ts
│   ├── services/
│   │   ├── storage/
│   │   │   ├── StorageService.ts
│   │   │   ├── StorageService.test.ts
│   │   │   └── index.ts
│   │   ├── permissions/
│   │   │   ├── PermissionService.ts
│   │   │   ├── PermissionService.test.ts
│   │   │   └── index.ts
│   │   └── validation/
│   │       ├── ValidationService.ts
│   │       ├── ValidationService.test.ts
│   │       └── index.ts
│   ├── types/
│   │   ├── common.ts
│   │   ├── api.ts
│   │   └── navigation.ts
│   ├── utils/
│   │   ├── constants.ts
│   │   ├── helpers.ts
│   │   └── testUtils.ts
│   └── hooks/
│       ├── useStorage.ts
│       ├── useStorage.test.ts
│       ├── usePermissions.ts
│       └── usePermissions.test.ts
├── features/
│   ├── communications/
│   │   ├── components/
│   │   │   ├── ContactButton/
│   │   │   │   ├── ContactButton.tsx
│   │   │   │   ├── ContactButton.test.tsx
│   │   │   │   └── ContactButton.styles.ts
│   │   │   ├── CallConfirmation/
│   │   │   │   ├── CallConfirmation.tsx
│   │   │   │   ├── CallConfirmation.test.tsx
│   │   │   │   └── CallConfirmation.styles.ts
│   │   │   └── ContactManager/
│   │   │       ├── ContactManager.tsx
│   │   │       ├── ContactManager.test.tsx
│   │   │       └── ContactManager.styles.ts
│   │   ├── services/
│   │   │   ├── ContactService.ts
│   │   │   ├── ContactService.test.ts
│   │   │   ├── CallService.ts
│   │   │   ├── CallService.test.ts
│   │   │   └── index.ts
│   │   ├── hooks/
│   │   │   ├── useContacts.ts
│   │   │   ├── useContacts.test.ts
│   │   │   ├── useCallConfirmation.ts
│   │   │   └── useCallConfirmation.test.ts
│   │   ├── types/
│   │   │   └── contact.ts
│   │   └── index.ts
│   ├── games/
│   │   ├── components/
│   │   │   ├── GameButton/
│   │   │   │   ├── GameButton.tsx
│   │   │   │   ├── GameButton.test.tsx
│   │   │   │   └── GameButton.styles.ts
│   │   │   ├── GameLauncher/
│   │   │   │   ├── GameLauncher.tsx
│   │   │   │   ├── GameLauncher.test.tsx
│   │   │   │   └── GameLauncher.styles.ts
│   │   │   └── GameSelector/
│   │   │       ├── GameSelector.tsx
│   │   │       ├── GameSelector.test.tsx
│   │   │       └── GameSelector.styles.ts
│   │   ├── services/
│   │   │   ├── AppLauncher.ts
│   │   │   ├── AppLauncher.test.ts
│   │   │   ├── GameDetection.ts
│   │   │   ├── GameDetection.test.ts
│   │   │   └── index.ts
│   │   ├── hooks/
│   │   │   ├── useGames.ts
│   │   │   ├── useGames.test.ts
│   │   │   ├── useGameLauncher.ts
│   │   │   └── useGameLauncher.test.ts
│   │   ├── types/
│   │   │   └── game.ts
│   │   └── index.ts
│   ├── music/
│   │   ├── components/
│   │   │   ├── DalidaButton/
│   │   │   │   ├── DalidaButton.tsx
│   │   │   │   ├── DalidaButton.test.tsx
│   │   │   │   └── DalidaButton.styles.ts
│   │   │   └── MusicPlayer/
│   │   │       ├── MusicPlayer.tsx
│   │   │       ├── MusicPlayer.test.tsx
│   │   │       └── MusicPlayer.styles.ts
│   │   ├── services/
│   │   │   ├── YouTubeService.ts
│   │   │   ├── YouTubeService.test.ts
│   │   │   └── index.ts
│   │   ├── hooks/
│   │   │   ├── useYouTube.ts
│   │   │   └── useYouTube.test.ts
│   │   ├── types/
│   │   │   └── music.ts
│   │   └── index.ts
│   ├── admin/
│   │   ├── components/
│   │   │   ├── AdminButton/
│   │   │   │   ├── AdminButton.tsx
│   │   │   │   ├── AdminButton.test.tsx
│   │   │   │   └── AdminButton.styles.ts
│   │   │   ├── PinModal/
│   │   │   │   ├── PinModal.tsx
│   │   │   │   ├── PinModal.test.tsx
│   │   │   │   └── PinModal.styles.ts
│   │   │   ├── PinRecovery/
│   │   │   │   ├── PinRecovery.tsx
│   │   │   │   ├── PinRecovery.test.tsx
│   │   │   │   └── PinRecovery.styles.ts
│   │   │   └── AdminPanel/
│   │   │       ├── AdminPanel.tsx
│   │   │       ├── AdminPanel.test.tsx
│   │   │       └── AdminPanel.styles.ts
│   │   ├── services/
│   │   │   ├── AuthService.ts
│   │   │   ├── AuthService.test.ts
│   │   │   ├── ConfigService.ts
│   │   │   ├── ConfigService.test.ts
│   │   │   └── index.ts
│   │   ├── hooks/
│   │   │   ├── useAdminAccess.ts
│   │   │   ├── useAdminAccess.test.ts
│   │   │   ├── useConfig.ts
│   │   │   └── useConfig.test.ts
│   │   ├── types/
│   │   │   └── admin.ts
│   │   └── index.ts
│   └── grid/
│       ├── components/
│       │   ├── MainGrid/
│       │   │   ├── MainGrid.tsx
│       │   │   ├── MainGrid.test.tsx
│       │   │   └── MainGrid.styles.ts
│       │   └── GridItem/
│       │       ├── GridItem.tsx
│       │       ├── GridItem.test.tsx
│       │       └── GridItem.styles.ts
│       ├── hooks/
│       │   ├── useGrid.ts
│       │   └── useGrid.test.ts
│       ├── types/
│       │   └── grid.ts
│       └── index.ts
├── App.tsx
├── App.test.tsx
└── index.ts
```

### 2.3 Avantages de l'architecture par feature
- **Cohésion** : Tous les éléments d'une feature sont regroupés
- **Découplage** : Les features sont indépendantes entre elles
- **Réutilisabilité** : Les composants partagés dans `shared/`
- **Maintenabilité** : Facilite les modifications et l'ajout de features
- **Testabilité** : Tests colocalisés avec le code métier
- **Scalabilité** : Ajout facile de nouvelles features

### 2.4 Flux de données entre features
```
App.tsx
├── Grid Feature (Orchestrateur principal)
│   ├── Communications Feature
│   │   ├── ContactService
│   │   └── CallService
│   ├── Games Feature
│   │   └── AppLauncher
│   ├── Music Feature
│   │   └── YouTubeService
│   └── Admin Feature
│       ├── AuthService
│       └── ConfigService
└── Shared Services
    ├── StorageService
    ├── PermissionService
    └── ValidationService
```

### 2.5 Index exports pour chaque feature
```typescript
// src/features/communications/index.ts
export * from './components/ContactButton';
export * from './components/CallConfirmation';
export * from './components/ContactManager';
export * from './services';
export * from './hooks/useContacts';
export * from './hooks/useCallConfirmation';
export * from './types/contact';

// src/features/games/index.ts
export * from './components/GameButton';
export * from './components/GameLauncher';
export * from './components/GameSelector';
export * from './services';
export * from './hooks/useGames';
export * from './hooks/useGameLauncher';
export * from './types/game';

// src/shared/index.ts
export * from './components/ui';
export * from './components/layout';
export * from './services';
export * from './hooks';
export * from './types';
export * from './utils';
```

---

## 3. Configuration de l'environnement

### 3.1 Prérequis
```bash
# Node.js 18+
node --version

# React Native CLI
npm install -g @react-native-community/cli

# Android Studio + SDK
# Java JDK 11+
```

### 3.2 Installation des dépendances
```bash
# Création du projet
npx react-native init A5aLauncher --template react-native-template-typescript

# Navigation vers le projet
cd A5aLauncher

# Installation des dépendances de développement (ESLint/Prettier)
npm install --save-dev @typescript-eslint/eslint-plugin @typescript-eslint/parser
npm install --save-dev eslint-plugin-react eslint-plugin-react-hooks
npm install --save-dev eslint-plugin-react-native
npm install --save-dev prettier eslint-config-prettier eslint-plugin-prettier
npm install --save-dev @commitlint/config-conventional @commitlint/cli
npm install --save-dev husky lint-staged

# Installation des dépendances de test
npm install --save-dev jest @testing-library/react-native
npm install --save-dev @testing-library/jest-native

# Installation des dépendances spécifiques
npm install nativewind
npm install --save-dev tailwindcss
npm install react-native-contacts
npm install @react-native-async-storage/async-storage
npm install react-native-orientation-locker
npm install react-native-send-intent
npm install crypto-js
npm install react-native-vector-icons
```

### 3.3 Configuration NativeWind
```javascript
// tailwind.config.js
module.exports = {
  content: ["./App.{js,jsx,ts,tsx}", "./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {
      colors: {
        'a5a-primary': '#2563eb',
        'a5a-secondary': '#7c3aed',
        'a5a-accent': '#059669',
        'a5a-bg': '#f8fafc',
      },
      fontSize: {
        'a5a-large': '28px',
        'a5a-xl': '32px',
      }
    },
  },
  plugins: [],
}
```

### 3.4 Configuration Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.CALL_PHONE" />
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.INTERNET" />

<activity
  android:name=".MainActivity"
  android:screenOrientation="landscape"
  android:configChanges="orientation|screenSize">
```

### 7.4 Configuration du launcher par défaut (Exigence CDC Section 4.2)
```xml
<!-- Pour définir l'app comme launcher par défaut -->
<activity
  android:name=".MainActivity"
  android:exported="true"
  android:launchMode="singleTask"
  android:screenOrientation="landscape"
  android:configChanges="orientation|screenSize"
  android:theme="@style/AppTheme.NoActionBar">
  <intent-filter android:priority="1000">
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.HOME" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.LAUNCHER" />
  </intent-filter>
</activity>
```

### 7.5 Prevention des appels d'urgence (CDC Section 1.2)
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<!-- Note: Protection déjà assurée par app tierce avec PIN selon CDC 2.3 -->
<uses-permission android:name="android.permission.CALL_PHONE" />
<!-- Pas besoin de permission CALL_PRIVILEGED pour éviter les appels d'urgence -->
```

---

## 4. Méthodologie TDD

### 4.1 Principe du Test-Driven Development
Le développement suit le cycle **Red-Green-Refactor** :
1. **Red** : Écrire un test qui échoue
2. **Green** : Écrire le code minimal pour faire passer le test
3. **Refactor** : Améliorer le code tout en gardant les tests verts

### 4.2 Structure des tests par feature
```
src/features/communications/
├── components/
│   └── ContactButton/
│       ├── ContactButton.tsx
│       └── ContactButton.test.tsx
├── services/
│   ├── ContactService.ts
│   └── ContactService.test.ts
└── hooks/
    ├── useContacts.ts
    └── useContacts.test.ts
```

### 4.3 Configuration Jest
```javascript
// jest.config.js
module.exports = {
  preset: 'react-native',
  setupFilesAfterEnv: ['<rootDir>/src/shared/utils/testSetup.ts'],
  testMatch: ['**/__tests__/**/*.(ts|tsx|js)', '**/*.(test|spec).(ts|tsx|js)'],
  transformIgnorePatterns: [
    'node_modules/(?!(react-native|@react-native|react-native-vector-icons)/)',
  ],
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/*.styles.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
};
```

### 4.4 Setup des tests
```typescript
// src/shared/utils/testSetup.ts
import '@testing-library/jest-native/extend-expect';

// Mock des modules natifs
jest.mock('react-native-contacts', () => ({
  getAll: jest.fn(),
  requestPermission: jest.fn(),
}));

jest.mock('@react-native-async-storage/async-storage', () =>
  require('@react-native-async-storage/async-storage/jest/async-storage-mock')
);

jest.mock('react-native-orientation-locker', () => ({
  lockToLandscape: jest.fn(),
}));

// Configuration globale des tests
global.console = {
  ...console,
  warn: jest.fn(),
  error: jest.fn(),
};
```

### 4.5 Utilitaires de test
```typescript
// src/shared/utils/testUtils.tsx
import React from 'react';
import { render, RenderOptions } from '@testing-library/react-native';
import { AppProvider } from '../contexts/AppContext';

const AllTheProviders: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  return (
    <AppProvider>
      {children}
    </AppProvider>
  );
};

const customRender = (ui: React.ReactElement, options?: RenderOptions) =>
  render(ui, { wrapper: AllTheProviders, ...options });

export * from '@testing-library/react-native';
export { customRender as render };

// Mock factories
export const createMockContact = (overrides = {}) => ({
  id: '1',
  name: 'Test Contact',
  phone: '+33123456789',
  photo: 'https://example.com/photo.jpg',
  ...overrides,
});

export const createMockGame = (overrides = {}) => ({
  id: '1',
  name: 'Test Game',
  packageName: 'com.test.game',
  icon: 'https://example.com/icon.png',
  ...overrides,
});
```

### 4.6 Exemple de cycle TDD pour ContactButton
```typescript
// ContactButton.test.tsx - RED
describe('ContactButton', () => {
  it('should display contact name and photo', () => {
    const contact = createMockContact();
    const { getByText, getByTestId } = render(
      <ContactButton contact={contact} onPress={jest.fn()} />
    );
    
    expect(getByText(contact.name)).toBeTruthy();
    expect(getByTestId('contact-photo')).toBeTruthy();
  });

  it('should call onPress when pressed', () => {
    const onPress = jest.fn();
    const contact = createMockContact();
    const { getByRole } = render(
      <ContactButton contact={contact} onPress={onPress} />
    );
    
    fireEvent.press(getByRole('button'));
    expect(onPress).toHaveBeenCalledTimes(1);
  });

  it('should have minimum dimensions of 150x150px', () => {
    const { getByTestId } = render(
      <ContactButton contact={createMockContact()} onPress={jest.fn()} />
    );
    
    const button = getByTestId('contact-button');
    expect(button.props.style.width).toBeGreaterThanOrEqual(150);
    expect(button.props.style.height).toBeGreaterThanOrEqual(150);
  });
});
```

---

## 5. Qualité du code (ESLint/Prettier)

### 5.1 Configuration ESLint
```javascript
// .eslintrc.js
module.exports = {
  root: true,
  extends: [
    '@react-native-community',
    '@typescript-eslint/recommended',
    'prettier',
  ],
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint', 'react-hooks', 'react-native'],
  rules: {
    // TypeScript
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/explicit-function-return-type': 'warn',
    '@typescript-eslint/no-explicit-any': 'error',
    
    // React
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'warn',
    'react/jsx-boolean-value': ['error', 'never'],
    'react/jsx-curly-brace-presence': ['error', 'never'],
    
    // React Native
    'react-native/no-unused-styles': 'error',
    'react-native/split-platform-components': 'error',
    'react-native/no-inline-styles': 'warn',
    'react-native/no-raw-text': 'error',
    
    // Général
    'prefer-const': 'error',
    'no-var': 'error',
    'object-shorthand': 'error',
    'prefer-arrow-callback': 'error',
  },
  overrides: [
    {
      files: ['*.test.ts', '*.test.tsx'],
      rules: {
        '@typescript-eslint/no-explicit-any': 'off',
      },
    },
  ],
};
```

### 5.2 Configuration Prettier
```javascript
// .prettierrc.js
module.exports = {
  arrowParens: 'avoid',
  bracketSameLine: true,
  bracketSpacing: true,
  singleQuote: true,
  trailingComma: 'es5',
  tabWidth: 2,
  semi: true,
  printWidth: 80,
  endOfLine: 'lf',
};
```

### 5.3 Scripts de qualité
```json
// package.json
{
  "scripts": {
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "lint:fix": "eslint . --ext .js,.jsx,.ts,.tsx --fix",
    "prettier": "prettier --check .",
    "prettier:fix": "prettier --write .",
    "type-check": "tsc --noEmit",
    "quality:check": "npm run lint && npm run prettier && npm run type-check",
    "quality:fix": "npm run lint:fix && npm run prettier:fix"
  }
}
```

### 5.4 Configuration VS Code
```json
// .vscode/settings.json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "javascript.preferences.importModuleSpecifier": "relative"
}
```

### 5.5 Règles spécifiques au projet
```javascript
// .eslintrc.js - Règles personnalisées
module.exports = {
  // ...existing config
  rules: {
    // ...existing rules
    
    // Architecture par feature
    'import/no-relative-parent-imports': 'error',
    
    // Performance React Native
    'react-native/no-color-literals': 'warn',
    'react-native/no-single-element-style-arrays': 'error',
    
    // Accessibilité
    'jsx-a11y/accessible-emoji': 'error',
    
    // Nommage
    'camelcase': ['error', { properties: 'never' }],
    
    // Tests
    'jest/expect-expect': 'error',
    'jest/no-disabled-tests': 'warn',
    'jest/no-focused-tests': 'error',
  }
};
```

---

## 6. Gestion des commits (Commitlint)

### 6.1 Configuration Commitlint
```javascript
// .commitlintrc.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // Nouvelle fonctionnalité
        'fix',      // Correction de bug
        'test',     // Ajout/modification de tests
        'refactor', // Refactoring sans changement fonctionnel
        'style',    // Changements de style/format
        'docs',     // Documentation
        'chore',    // Tâches de maintenance
        'perf',     // Amélioration des performances
        'ci',       // Intégration continue
        'build',    // Système de build
        'revert',   // Annulation d'un commit
      ],
    ],
    'scope-enum': [
      2,
      'always',
      [
        'communications', // Feature communications
        'games',         // Feature jeux
        'music',         // Feature Dalida/musique
        'admin',         // Feature administration
        'grid',          // Feature grille principale
        'shared',        // Composants partagés
        'config',        // Configuration
        'deps',          // Dépendances
        'release',       // Release
      ],
    ],
    'subject-case': [2, 'always', 'lower-case'],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'header-max-length': [2, 'always', 72],
  },
};
```

### 6.2 Configuration Husky
```json
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS",
      "pre-push": "npm run test && npm run type-check"
    }
  }
}
```

### 6.3 Configuration Lint-staged
```json
// package.json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "git add"
    ],
    "*.{json,md}": [
      "prettier --write",
      "git add"
    ]
  }
}
```

### 6.4 Types de commits et exemples
```bash
# Nouvelle fonctionnalité
feat(communications): add contact confirmation modal

# Correction de bug
fix(games): resolve app launcher crash on Android 8

# Tests
test(admin): add PIN validation unit tests

# Refactoring
refactor(shared): extract common button component

# Documentation
docs(readme): update installation instructions

# Configuration
chore(config): update eslint rules for accessibility

# Performance
perf(grid): optimize grid rendering performance

# Style/format
style(communications): apply prettier formatting

# Build
build(android): update gradle configuration

# CI/CD
ci(github): add automated testing workflow
```

### 6.5 Template de commit
```bash
# .gitmessage
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>
#
# Types:
# feat: nouvelle fonctionnalité
# fix: correction de bug
# test: ajout/modification de tests
# refactor: refactoring
# style: style/format
# docs: documentation
# chore: maintenance
# perf: performance
# ci: intégration continue
# build: système de build
# revert: annulation
#
# Scopes:
# communications, games, music, admin, grid, shared, config, deps, release
```

### 6.6 Workflow de développement
```bash
# 1. Créer une branche pour la feature
git checkout -b feat/communications-contact-button

# 2. Développement TDD
# RED: Écrire le test
git add src/features/communications/components/ContactButton/ContactButton.test.tsx
git commit -m "test(communications): add contact button display test"

# GREEN: Implémenter le code minimal
git add src/features/communications/components/ContactButton/ContactButton.tsx
git commit -m "feat(communications): implement basic contact button component"

# REFACTOR: Améliorer le code
git add src/features/communications/components/ContactButton/ContactButton.tsx
git commit -m "refactor(communications): optimize contact button performance"

# 3. Tests et qualité
npm run test
npm run quality:check

# 4. Push et PR
git push origin feat/communications-contact-button
```