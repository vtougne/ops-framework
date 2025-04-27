# Roadmap – ops_framework

## Vue d'ensemble

Cette feuille de route accompagne le développement du framework `ops_framework`, dans une logique d'outillage DevOps pour les équipes opérationnelles.

## Objectifs prioritaires

- [x] Développement du framework en shell
- [x] Intégration dans 3 projets pilotes avec dictionnaires de propriétés
- [ ] tests automatisés
- [ ] documentation automatisée et publication vers Conflence
- [ ] Documentation des usages (log, déploiement, rollback)
- [ ] Intégration GitLab complète (templates, pipelines de base)
- [ ] Préparation des packages pour future solution Tower maison
- [ ] Génération automatique des jobs IWS depuis GitLab

## Schéma d'évolution

```mermaid
gantt
    title Roadmap de développement - ops_framework
    dateFormat  YYYY-MM-DD
    section Framework Shell
    Développement de base         :done, 2025-04-01, 2025-04-01
    Projets pilotes               :done, 2025-04-01, 2025-05-01
    Documentation                 :active, 2025-04-15, 2025-05-15
    Packaging standardisé         :active, 2025-04-15, 2025-05-15

    section Intégration GitLab
    Pipelines et templates        :2025-04-20, 2025-05-10
    Génération IWS (PoC)          :2025-05-15, 2025-06-10

    section Automatisation future
    Intégration dans le futur outil de déploiment   :2025-06-01, 2025-06-15
    Déploiement via automate      :2025-07-01, 2025-07-31

    section Collaboration
    Implication des contributeurs :2025-04-20, 2025-06-30
```

## Points clés à venir

- Rendre les projets autosuffisants avec le framework
- Documenter les usages types et pièges courants et solutions standards pour y répondre
- Mettre en place des templates GitLab standard
- Définir le format des clés/valeurs pour les jobs IWS
- Spécifier l'automate (droits, sécurité, logs)

---

Les jalons seront mis à jour régulièrement en fonction des retours de l'équipe et de l'avancement.
