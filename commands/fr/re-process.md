---
name: re-process
description: >
  Traite les corrections identifiees dans le rapport de validation d'une analyse.
  Modifie le code pour resoudre les points du rapport sans faire d'analyse supplementaire.
argument-hint: <path/to/ask.txt|ask-analysis.md> [comment]
disable-model-invocation: true
---

Traiter les corrections identifiees dans le rapport de validation.

**Parametre :** `$0`
**Informations supplementaires :** `$ARGUMENTS`

## Resolution du parametre

- Si le parametre est un fichier de demande (`ask.txt`, `ask.md`), retrouver l'analyse correspondante dans `.flow/outs/` (meme nom sans extension + `-analysis.md`).
- Si le parametre est directement un fichier `*-analysis.md`, l'utiliser et retrouver la demande correspondante dans `.flow/asks/` (meme nom sans le suffixe `-analysis`, au format `.txt` ou `.md`).

## Prerequis

- L'analyse correspondante doit exister dans `.flow/outs/`. Si elle est absente, **demander a l'utilisateur** de d'abord produire une analyse.
- L'analyse doit contenir une section **"Validation Report"**. Si elle est absente, **demander a l'utilisateur** de d'abord lancer une validation.
- Ne pas continuer si l'un de ces prerequis n'est pas rempli.

## Comportement

1. Lire la section **"Validation Report"** dans l'analyse.
2. Traiter chaque point/note identifie dans le rapport.
3. Appliquer les corrections de code necessaires.
4. Respecter les **normes et standards** du code existant dans le projet.
5. Suivre les **bonnes pratiques** definies dans `.flow/docs/best-practices.md` si le fichier existe.

6. Afficher a l'utilisateur la proposition de commande suivante :
   - Ligne 1 : `Pour relancer la validation :`
   - Ligne 2 : `/flow:validate <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

## Regles

- **Modifier le code** uniquement pour traiter les points du rapport de validation.
- **Ne faire aucune analyse.** Ne pas prendre de decisions en dehors du perimetre du rapport.
- **Ne pas modifier la section "Validation Report".** Sa mise a jour est le role de la commande validate.
