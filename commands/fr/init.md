---
name: init
description: >
  Initialise l'environnement de travail flow pour un projet.
disable-model-invocation: true
---

Initialiser l'environnement de travail du projet.

1. Verifier si le fichier `.gitignore` a la racine du projet existe. Si non, le creer.
2. Verifier si le `.gitignore` contient le bloc suivant. Si absent (en tout ou en partie), l'ajouter ou le completer :
   ```
   # flow
   /.flow
   ```
3. Creer l'arborescence suivante (ignorer les dossiers/fichiers qui existent deja) :
   ```
   {project-dir}
   └── .flow
       ├── asks/
       ├── docs/
       │   └── best-practices.md
       ├── imgs/
       ├── outs/
       └── note.txt
   ```
4. Confirmer a l'utilisateur les actions realisees.
