---
name: process
description: >
  Realise les modifications de code selon une analyse existante.
argument-hint: <path/to/ask.txt|ask-analysis.md> [comment]
disable-model-invocation: true
---

Realiser les modifications de code en suivant strictement une analyse existante.

**Parametre :** `$0`
**Informations supplementaires :** `$ARGUMENTS`

## Resolution du parametre

- Si le parametre est un fichier de demande (`ask.txt`, `ask.md`), retrouver l'analyse correspondante dans `.flow/outs/` (meme nom sans extension + `-analysis.md`).
- Si le parametre est directement un fichier `*-analysis.md`, l'utiliser et retrouver la demande correspondante dans `.flow/asks/` (meme nom sans le suffixe `-analysis`, au format `.txt` ou `.md`).

## Prerequis

L'analyse correspondante doit exister dans `.flow/outs/`. Si elle est absente, **demander a l'utilisateur** de d'abord produire une analyse. Ne pas continuer sans l'analyse.

## Comportement

1. Lire l'analyse correspondante.
2. Appliquer les modifications de code decrites dans l'analyse.
3. Respecter les **normes et standards** du code existant dans le projet.
4. Suivre les **bonnes pratiques** definies dans `.flow/docs/best-practices.md` si le fichier existe.

5. Afficher a l'utilisateur la proposition de commande suivante :
   - Ligne 1 : `Pour lancer la validation :`
   - Ligne 2 : `/flow:validate <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

## Regles

- **Modifier le code** en suivant strictement l'analyse.
- **Ne pas prendre de decisions** en dehors du perimetre de l'analyse.
