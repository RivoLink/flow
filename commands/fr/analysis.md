---
name: analysis
description: >
  Analyse une demande ou tache decrite dans un fichier ask sans modifier le code source.
  Produit une analyse detaillee dans .flow/outs/.
argument-hint: <path/to/ask.txt> [comment]
disable-model-invocation: true
---

Analyser une demande ou une tache sans modifier le code source.

**Fichier de demande :** `$0`
**Informations supplementaires :** `$ARGUMENTS`

## Fichier de sortie

Le resultat est enregistre dans `.flow/outs/` avec le meme nom que la source (sans extension), suffixe par `-analysis.md`.
- `.flow/asks/feature.txt` → `.flow/outs/feature-analysis.md`
- `.flow/asks/feature.md` → `.flow/outs/feature-analysis.md`

## Comportement

1. Lire et analyser la demande decrite dans le fichier de demande.
2. Prendre en compte les informations supplementaires si fournies.
3. Si le fichier de sortie existe deja, verifier s'il contient une section **"Review Report"**. Si oui :
   - Lire chaque incoherence et question identifiee dans le rapport de revue.
   - Corriger les points concernes dans l'analyse (reformuler, completer ou supprimer les parties incoherentes).
   - Les questions du rapport de revue sont repondues manuellement par l'utilisateur. Integrer ses reponses dans l'analyse.
   - Si des questions n'ont pas encore de reponse, les conserver dans la section "Review Report".
   - Une fois tous les points traites et toutes les questions repondues, supprimer la section "Review Report" de l'analyse mise a jour.
4. Explorer le code source du projet pour comprendre le contexte technique.
5. Produire (ou mettre a jour) une analyse detaillee au format Markdown couvrant :
   - Comprehension de la demande
   - Impact sur le code existant
   - Approche technique recommandee
   - Points d'attention
6. Enregistrer le resultat dans le fichier de sortie.
7. Afficher a l'utilisateur la proposition de commande suivante selon la logique :
   - Si c'est la **premiere analyse** (le fichier de sortie n'existait pas avant cette execution) → afficher :
     - Ligne 1 : `Pour lancer la revue :`
     - Ligne 2 : `/flow:review <path>`
   - Si le fichier existait et contenait un "Review Report" avec des **questions sans reponse** restantes → ne proposer aucune commande. Afficher :
     - Ligne 1 : `Des questions du rapport de revue n'ont pas encore de reponse.`
     - Ligne 2 : `Repondez aux questions dans le fichier, puis relancez :`
     - Ligne 3 : `/flow:analysis <path>`
   - Sinon (analyse suivante sans questions en suspens) → afficher :
     - Ligne 1 : `Pour relancer une revue :`
     - Ligne 2 : `/flow:review <path>`
     - Ligne 3 : vide
     - Ligne 4 : `Pour lancer le traitement :`
     - Ligne 5 : `/flow:process <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

## Regles

- **Ne jamais modifier le code source.** Cette commande produit uniquement une analyse.
