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

# Step 1
```mermaid
graph LR
  subgraph UserZone
    subgraph user["🧑‍🌾 User"]
      user_upload["Destop"]
    end
    di{proxy}
  end

      user_upload -- "🧑‍🌾​ package / 🧑‍🌾​ upload" --> di{proxy}
  subgraph HostZone
  
    artifactory["artifactory"]
    artifactory -- 🧑‍🌾​ download --> host_1
    artifactory -- 🧑‍🌾​ download --> host_2
  end
  di{proxy} ---> artifactory
```
# Step 2
```mermaid
graph LR
  subgraph "User Zone"
    subgraph user["🧑‍🌾 User"]
      user_upload["Destop"]
    end
    di{proxy}
  end
      user_upload -- "🧑‍🌾​ push code" --> di{proxy}
  subgraph "Host Zone"
    gitlab["GitLab"]
    artifactory["artifactory"]
    artifactory -- 🧑‍🌾​ download --> host_1
    artifactory -- 🧑‍🌾​ download --> host_2
  end
  di{proxy} --> gitlab
  gitlab -- Create package / upload package--> artifactory
```

# Step 3
```mermaid
graph LR
  subgraph "User Zone"
    subgraph user["🧑‍🌾 User"]
      user_upload["Destop"]
    end
    di{proxy}
  end

      user_upload -- "🧑‍🌾​ push code" --> di{proxy}
  subgraph "Host Zone"
    gitlab["GitLab"]
    artifactory["artifactory"]
    automate["Automator"]
    gitlab  -- notify --> automate
    artifactory -- download --> automate
    automate -- push and install --> host_1
    automate -- push and install --> host_2

  end
  di{proxy} --> gitlab
  gitlab -- Create package / upload package--> artifactory
```


# Mindmap

```mermaid
mindmap
  root(DevOps mindmap))
    (Versioning))
      [Git
    #45; Branches
    #45; git clone
    #45; git push
    #45; etc ...]
    (Formats))
      [
      yaml
      json
      mardown
      mermaid]
    (Automatisation))
      [Gitlab CI/CD]
```

# Infinity


## Circle

```mermaid
flowchart LR
  Plan((Plan)) --> Develop((Develop))
  Develop --> Build((Build))
  Build --> Test((Test))
  Test --> Release((Release))
  Release --> Deploy((Deploy))
  Deploy --> Operate((Operate))
  Operate --> Monitor((Monitor))
  Monitor --> Plan
```

```mermaid
flowchart LR
  Plan((Plan)) --> Develop((Develop))
  Develop --> Build((Build))
  Build --> Test((Test))
  Test --> Release((Release))
  Release --> Deploy((Deploy))
  Deploy --> Operate((Operate))
  Operate --> Monitor((Monitor))
  Monitor --> Plan
  Test --> Develop
```





