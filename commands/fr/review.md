---
name: review
description: >
  Effectue une revue critique de l'analyse associee a une demande, sans modifier le code source.
  Detecte les incoherences, regressions potentielles et pose des questions.
argument-hint: <path/to/ask.txt|ask-analysis.md> [comment]
disable-model-invocation: true
---

Effectuer une revue critique d'une analyse existante sans modifier le code source.

**Parametre :** `$0`
**Informations supplementaires :** `$ARGUMENTS`

## Resolution du parametre

- Si le parametre est un fichier de demande (`ask.txt`, `ask.md`), retrouver l'analyse correspondante dans `.flow/outs/` (meme nom sans extension + `-analysis.md`).
- Si le parametre est directement un fichier `*-analysis.md`, l'utiliser et retrouver la demande correspondante dans `.flow/asks/` (meme nom sans le suffixe `-analysis`, au format `.txt` ou `.md`).

## Prerequis

L'analyse correspondante doit exister dans `.flow/outs/`. Si elle est absente, **demander a l'utilisateur** de d'abord produire une analyse. Ne pas continuer sans l'analyse.

## Comportement

1. Lire la demande originale et l'analyse correspondante.
2. Detecter les **incoherences** entre la demande et l'analyse.
3. Detecter les **incoherences internes** dans l'analyse elle-meme.
4. Detecter les **regressions potentielles** si applicable.
5. Poser des **questions** si des zones d'ombre subsistent.
6. Pour chaque question, proposer **2 a 3 reponses possibles** afin de guider l'utilisateur dans son choix. L'utilisateur reste libre de choisir une proposition ou de formuler sa propre reponse dans le champ "Reponse :".
7. Parmi les propositions, indiquer clairement celle qui est **recommandee** en ajoutant la mention `(recommande)`. Format :

   **Q1 : [Intitule de la question]**
   - a) [Proposition 1]
   - b) [Proposition 2] **(recommande)**
   - c) [Proposition 3]
   **Reponse :**

8. Mettre a jour le fichier `*-analysis.md` pour y ajouter une section **"Review Report"** contenant les incoherences et les questions identifiees. Les incoherences restent en texte libre. Si **aucune incoherence**, aucune question et aucune regression potentielle n'est detectee, ajouter quand meme la section avec un statut positif :
   ```
   ## Review Report

   Aucune incoherence detectee. L'analyse est coherente avec la demande.
   ```
9. Afficher a l'utilisateur la proposition de commande suivante :
   - Ligne 1 : `Pour relancer l'analyse :`
   - Ligne 2 : `/flow:analysis <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

## Regles

- **Ne jamais modifier le code source.** Cette commande produit uniquement une revue.
