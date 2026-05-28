---
name: validate
description: >
  Effectue une revue critique des modifications de code, sans modifier le code source.
  Verifie la coherence avec la demande et l'analyse, les bonnes pratiques et les regressions.
  Produit un rapport de validation (Valide/Non valide) dans l'analyse.
argument-hint: <path/to/ask.txt|ask-analysis.md> [comment]
disable-model-invocation: true
---

Effectuer une revue critique des modifications de code sans modifier le code source.

**Parametre :** `$0`
**Informations supplementaires :** `$ARGUMENTS`

## Resolution du parametre

- Si le parametre est un fichier de demande (`ask.txt`, `ask.md`), retrouver l'analyse correspondante dans `.flow/outs/` (meme nom sans extension + `-analysis.md`).
- Si le parametre est directement un fichier `*-analysis.md`, l'utiliser et retrouver la demande correspondante dans `.flow/asks/` (meme nom sans le suffixe `-analysis`, au format `.txt` ou `.md`).

## Prerequis

L'analyse correspondante doit exister dans `.flow/outs/`. Si elle est absente, **demander a l'utilisateur** de d'abord produire une analyse. Ne pas continuer sans l'analyse.

## Comportement

1. Faire une revue critique des modifications de code realisees.
2. Verifier la **coherence** entre les modifications, la demande et l'analyse.
3. Verifier que les modifications respectent les **bonnes pratiques** definies dans `.flow/docs/best-practices.md` si le fichier existe.
4. Verifier les **regressions potentielles** introduites par les modifications.
5. Mettre a jour l'analyse en ajoutant (ou en mettant a jour) une section **"Validation Report"** contenant :
   - Le statut de validation : **Valide** ou **Non valide**.
   - Si **Non valide** : les notes, remarques et questions detaillees, suffisamment documentees pour etre traitees.
6. Si une section "Validation Report" existe deja :
   - Verifier si les points precedemment releves ont ete traites.
   - Supprimer les points resolus.
   - Conserver les points non resolus dans la version mise a jour de la section.

7. Afficher a l'utilisateur la proposition de commande suivante selon la logique :
   - Si le statut est **Valide** → ne proposer aucune commande. Afficher :
     `Tache validee. Le flux est termine.`
   - Si le statut est **Non valide**, evaluer la nature des problemes :
     - **Corrections mineures** (erreurs de style, petits bugs, oublis simples, ajustements de nommage, formatage) → afficher :
       - Ligne 1 : `Pour lancer le re-traitement :`
       - Ligne 2 : `/flow:re-process <path>`
     - **Problemes majeurs** (logique incorrecte, incoherence avec la demande, approche technique a revoir, regression fonctionnelle) → afficher :
       - Ligne 1 : `Pour relancer l'analyse :`
       - Ligne 2 : `/flow:analysis <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

## Regles

- **Ne jamais modifier le code source.** Cette commande produit uniquement un rapport de validation.
