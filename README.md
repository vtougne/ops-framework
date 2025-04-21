# ops_framework

Framework d'accompagnement DevOps pour équipes opérationnelles

## Application immédiates

Fournir un socle commun, normé, regroupant les outils couramment utilisés sous forme de script type cli, fonctions.
Il est compatbible sur les plateformes linux, AIX, ainsi que l'émulateur Linux intégré dans Git Bash, permettant ainsi de travailler au maximum sur son poste de travail dans votre VS Code ou autre.


## Contenu du dépôt

- `ops_framework/` : scripts shell du framework (setup, logging, fichiers, etc.)
- `projects/` : exemples de projets utilisant le framework
- `properties/` : dictionnaires de propriétés pour chaque projet
- `docs/` : documentation utilisateur et technique
- `roadmap.md` : feuille de route, vision globale du projet

## Prérequis

- Shell bash
- Accès GitLab
- AIX compatible (pas de dépendance Python pour le moment)

## Utilisation

Chaque projet initialise le framework via un script unique :

```sh
source ops_framework/setup.sh
```

Le framework lit automatiquement le dictionnaire de propriétés lié au projet pour configurer les fonctionnalités activées.

## Fonctionnalités principales

- Initialisation standardisée
- Logging centralisé
- Copie/organisation de fichiers
- Templates et bonnes pratiques DevOps embarquées

## Fonctionnalités à venir

- Intégration future dans un automate de type Tower
- Génération automatique des chaines IWS à partir de GitLab.
- Évolutivité assurée via les retours utilisateurs

## Collaboration

Des contributeurs motivés sont invités à rejoindre le projet :

- Tests et validation
- Documentation
- Amélioration des scripts
- Veille technique (compatibilité, automatisation)

➡️ Voir `docs/contribution.md` pour participer.

## Feuille de route

➡️ Voir [roadmap.md](./roadmap.md)

---

*Projet initié dans le cadre de la transformation DevOps de l'équipe OPS.*
