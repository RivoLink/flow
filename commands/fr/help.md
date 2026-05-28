---
name: help
description: >
  Affiche la liste des commandes flow avec une breve description et le flux d'analyse recommande.
disable-model-invocation: true
---

Afficher le message suivant a l'utilisateur :

**Flow** — Commandes disponibles :

1. **flow:init** — Initialise l'environnement de travail du projet.
2. **flow:best-practices** `<comment>` — Ajoute des bonnes pratiques.
3. **flow:asking** `<prompt>` — Cree un fichier de demande a partir d'un prompt.
4. **flow:analysis** `<path/to/ask.txt>` `<comment>` — Analyse une demande sans modifier le code.
5. **flow:review** `<path>` `<comment>` — Revue critique de l'analyse.
6. **flow:process** `<path>` `<comment>` — Applique les modifications de code.
7. **flow:validate** `<path>` `<comment>` — Revue critique des modifications de code.
8. **flow:re-process** `<path>` `<comment>` — Corrige le code selon le rapport de validation.

**Syntaxe :** `/flow:<commande> [arguments]`

**Flux recommande :**

```
asking ──> analysis <──> review ──> process ──> validate <──> re-process
```

- **Boucle 1** : `analysis` et `review` jusqu'a ce que l'analyse soit coherente.
- **Boucle 2** : `validate` et `re-process` jusqu'a obtenir le statut "Valide".
