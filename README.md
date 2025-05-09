# ops_framework

# Create project
```bash
mkdir <env>/<project>
cd <env>/<project>
curl artifactory:8082/ops-framework-repo.tar.gz --output - | gunzip - | tar xvf -
```

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

```bash
source ops_framework/set_env.sh
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


## file_processor

```bash
file_processor --source /path_to_file/file.txt --new_name the_file_{{ yyyymmdd_hhmmss }}.txt \\
--copy_to /other_path_1  --gpg-encrypt key=the_key file_name=the_file_{{ yyyymmdd_hhmmss }}.asc --copy_to /other_path_2 --zip_to /other_path/the_file_{{ yyyymmdd_hhmmss }}.zip


file_processor rename --source file.txt --to the_file_{{ yyyymmdd_hhmmss }}.txt \
    copy --to /other_path_1 \
    encrypt --gpg-key the_key --to the_file_{{ yyyymmdd_hhmmss }}.asc \
    zip --to /other_path/the_file_{{ yyyymmdd_hhmmss }}.zip

file_processor source=/from_path/file.txt new_name=the_file_{{ yyyymmdd_hhmmss }}.txt \
    copy --to /archive \
    encrypt --gpg-key the_key --to the_file_{{ yyyymmdd_hhmmss }}.txt.asc \
    zip --to /other_path/the_file_{{ yyyymmdd_hhmmss }}.zip \
    del /from_path/file.txt

file_processor new_name=the_file_{{ yyyymmdd_hhmmss }}.txt \
 the_source=file.txt new_name=the_file_{{ yyyymmdd_hhmmss }}.txt encrypted_name=the_file_{{ yyyymmdd_hhmmss }}.txt.asc \
    copy /from_path/%the_source% /work_path/%new_name% \
    gpg_encrypt /work_path/%new_name% %encrypted_name% --gpg_key the_key \
    copy /work_path/%new_name% /target_path/%new_name% \
    on_failure try_del /work_path/%new_name% \
    on_success del %source_path%/%the_source% copy %source_path%/%the_source% \
    always del /work_path/%new_name%
```




### Get latest file from folder
```bash
./file_processor.sh \
  from_path=/source_path \
  regexp_filter="the_file_[0-9]{8}_[0-9]{6}$.txt" \
  filter=last \
  sort=mtime_desc \
  youger_than=1d \
  actions='
    copy %from_path% --regexp_filter 'the_file_[0-9]{8}_[0-9]{6}.txt' --to %work_path% ;
  '
```


### Extract zip and copy
```bash
./file_processor.sh \
  ziped_file='/path_to/the_zipped_file.zip' \
  expected_file_name='the_file_'[0-9]{8}_[0-9]{6}$'.txt' \
  actions='
    copy --from_zip %ziped_file% --regexp_filter 'the_file_[0-9]{8}_[0-9]{6}.txt' --to_path %work_path% ;
    on_success:
      del ziped_file;
'
```


### Encrypt file
```bash
./file_processor.sh \
  src='/path_to/the_file.txt' \
  to_path='/path_to/the_file.txt.enc' \
  actions='
    gpg_encrypt %src% --gpgp_key key_id --as encrypted_file --new_name='file.txt.enc' ;
    zip %encrypted_file% --as zipped_file --new_name='file.zip' ;
    copy %zipped_file% --to /path_to/send ;
  '

```


### Encrypt file
```bash
./file_processor.sh \
  src='/path_to/the_file.txt' \
  to_path='/path_to/the_file.txt.enc' \
  actions='
    copy %src% --to_gpg gpgp_key=key_id name='file.txt.enc' --to_zip name='file.zip' ;
  '
```


### Get latest file from folder encrypt it zip it and send it
```bash
./file_processor.sh \
  src='/path_to/the_file.txt' \
  actions='
    copy --src /path_from --mask 'the_file_[0-9]{8}_[0-9]{6}.txt' --sort mtime_desc filter=last --as source_file ; \
    encrypt --src @{source_file} --key the_key --new_name @{source_file:name} --as encrypted_file ; \
    zip --src @{encrypted_file} --as ziped_file ; \
    copy_partner --src @{ziped_file} /target_path'
  on_success='
    delete @{src}
    
```


