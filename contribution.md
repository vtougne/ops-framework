# Contribution – ops_framework

Merci de ton intérêt pour `ops_framework` ! Ce projet vise à faciliter la transitionvers la duture solution de déploiement DevOps. Toute aide est la bienvenue, que tu sois utilisateur, testeur ou développeur.

## 📌 Types de contributions possibles

### 1. Test sur projets réels
- Intégrer le framework à un projet existant.
- Remonter les problèmes rencontrés.
- Proposer des idées d’amélioration ou de simplification.

### 2. Documentation
- Rédiger ou corriger la documentation utilisateur.
- Ajouter des exemples d’utilisation concrets.
- Expliquer les bonnes pratiques autour du framework.

### 3. Développement
- Proposer des fonctions shell utiles (ex: parsing, validation, etc.).
- Corriger des bugs dans les scripts existants.
- Suggérer des refactorings pour améliorer la lisibilité.

### 4. Automatisation (futur)
- Participer à la conception du système de génération des jobs IWS.
- Aider à définir le format du référentiel GitLab (clé/valeur).
- Travailler à l'intégration avec un outil d'automate maison.

## 🔧 Environnement recommandé

- Shell (bash)
- Git + GitLab (accès en lecture/écriture)
- vs code
<!-- - Éditeur : `vim`, `nano`, ou IDE shell-friendly -->

## 🔁 Workflow GitLab

1. Fork du projet (ou branche locale si accès autorisé)
2. Création d'une branche :
   ```bash
   git checkout -b feat/ma-contribution
   ```
3. Développement et tests locaux
4. Commit clair :
   ```bash
   git commit -m "feat(log): ajout d’un format de log JSON en option"
   ```
5. Merge request via GitLab

## 🧭 Besoin d’orientation ?

Voici quelques idées si tu veux te lancer :

- Ajouter une fonction `check_dependencies` dans `setup.sh`
- Améliorer le style de log (timestamps, niveaux d’erreur)
- Écrire un guide "Premier projet avec le framework"
- Documenter la gestion d’erreur dans les fonctions

---

Contacte le mainteneur du projet si tu veux qu’on code à deux, ou pour organiser une session d’échange rapide ⚡
