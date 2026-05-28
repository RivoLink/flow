---
name: init
description: >
  Initialize the flow working environment for a project.
disable-model-invocation: true
---

Initialize the project working environment.

1. Check if the `.gitignore` file exists at the project root. If not, create it.
2. Check if `.gitignore` contains the following block. If missing (in whole or in part), add or complete it:
   ```
   # flow
   /.flow
   ```
3. Create the following directory structure (skip directories/files that already exist):
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
4. Confirm the actions taken to the user.
