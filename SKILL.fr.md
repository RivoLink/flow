---
name: flow
description: >
  Ensemble de commandes pour structurer et piloter le cycle d'analyse, de revue, d'implementation
  et de validation d'une demande ou tache. Commandes disponibles : help, init, best-practices,
  asking, analysis, review, process, validate, re-process.
argument-hint: <commande> [arguments]
disable-model-invocation: true
---

# Flow

Executer la commande **$0**.

Identifier la commande parmi les sections ci-dessous et suivre ses instructions. Les arguments supplementaires sont : `$ARGUMENTS`.

## Resolution du parametre

Applicable aux commandes qui acceptent `<path/to/ask.txt|ask-analysis.md>` :

- Si le parametre est un fichier de demande (`ask.txt`, `ask.md`), retrouver l'analyse correspondante dans `.flow/outs/` (meme nom sans extension + `-analysis.md`).
- Si le parametre est directement un fichier `*-analysis.md`, l'utiliser et retrouver la demande correspondante dans `.flow/asks/` (meme nom sans le suffixe `-analysis`, au format `.txt` ou `.md`).

---

## Commande : help

Afficher le message suivant a l'utilisateur :

**Flow** — Commandes disponibles :

1. **flow init** — Initialise l'environnement de travail du projet.
2. **flow best-practices** `<comment>` — Ajoute des bonnes pratiques.
3. **flow asking** `<prompt>` — Cree un fichier de demande a partir d'un prompt.
4. **flow analysis** `<path/to/ask.txt>` `<comment>` — Analyse une demande sans modifier le code.
5. **flow review** `<path>` `<comment>` — Revue critique de l'analyse.
6. **flow process** `<path>` `<comment>` — Applique les modifications de code.
7. **flow validate** `<path>` `<comment>` — Revue critique des modifications de code.
8. **flow re-process** `<path>` `<comment>` — Corrige le code selon le rapport de validation.

**Syntaxe :** `/flow <commande> [arguments]`

**Flux recommande :**

```
asking ──> analysis <──> review ──> process ──> validate <──> re-process
```

- **Boucle 1** : `analysis` et `review` jusqu'a ce que l'analyse soit coherente.
- **Boucle 2** : `validate` et `re-process` jusqu'a obtenir le statut "Valide".

---

## Commande : init

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

---

## Commande : best-practices

Ajouter des bonnes pratiques au fichier de reference du projet.

**Arguments :** `<comment>` — Description des bonnes pratiques a ajouter.

1. Ouvrir `.flow/docs/best-practices.md`. Si le fichier n'existe pas, le creer avec un titre `# Bonnes pratiques`.
2. Ajouter les bonnes pratiques decrites dans `<comment>`, formulees de maniere concise.
3. Organiser les ajouts par sections thematiques si applicable.
4. Confirmer a l'utilisateur les pratiques ajoutees.

---

## Commande : asking

Creer un fichier de demande a partir du prompt utilisateur.

**Arguments :**
- `<prompt>` — Prompt libre decrivant la demande.

**Fichier de sortie :** `.flow/asks/<slug>.txt`.

**Comportement :**

1. Si le prompt est vide, **demander interactivement** a l'utilisateur de fournir un prompt. Ne pas continuer tant qu'un prompt non vide n'est pas obtenu.
2. **Reformuler** le prompt pour plus de clarte tout en conservant strictement le sens d'origine : corriger la syntaxe, clarifier les tournures ambigues, retirer les typos. Ne pas ajouter d'information absente de l'original.
3. Generer un nom de fichier en **kebab-case** derive du **prompt reformule** (slug) :
   - Conserver uniquement les caracteres `[a-zA-Z0-9]`, passer en minuscules.
   - Remplacer tout autre caractere (espaces, ponctuation, accents, symboles) par `-`.
   - Fusionner les tirets consecutifs, retirer les tirets de debut/fin.
   - **Raccourcir intelligemment** le slug pour qu'il reste **expressif** tout en ne depassant pas **30 caracteres** (limite appliquee au slug seul, avant tout suffixe) :
     - Supprimer les mots vides (articles, prepositions, conjonctions) pour ne garder que les mots porteurs de sens. Exemples de mots vides : le, la, les, de, du, des, un, une, au, aux, en, et, ou, pour, dans, sur, avec, par, the, an, of, to, in, on, for, and, or, with. Cette liste est indicative — l'adapter selon le contexte et la langue du prompt.
     - Si le slug depasse encore la limite, raccourcir en conservant les mots-cles les plus significatifs (techniques, noms propres, verbes d'action) pour preserver le sens global du prompt. Privilegier l'ensemble des mots-cles porteurs de sens sur toute la longueur du prompt, pas seulement ceux du debut.
     - Toujours couper a une **frontiere de mot** (jamais au milieu d'un mot).
     - Retrimer les tirets de fin apres raccourcissement.
4. Cible : `.flow/asks/<slug>.txt`.
5. **Collision de nom** : si `<slug>.txt` existe deja, utiliser une **indexation numerique** incrementale (`<slug>-1.txt`, `<slug>-2.txt`, ...) jusqu'a obtenir un nom libre. Pas d'ecrasement.
6. Creer le dossier `.flow/asks/` s'il n'existe pas.
7. Ecrire dans le fichier le **prompt reformule** (texte brut, sans en-tete, sans metadonnees). Le texte doit etre **bien formate** selon les regles suivantes :
   - Limiter chaque ligne a environ **90-100 caracteres**. Les lignes doivent rester assez longues pour etre lisibles, mais ne pas depasser cette limite.
   - Inserer les retours a la ligne **intelligemment**, en coupant de preference apres une virgule, un point, un point-virgule, deux-points, ou un autre signe de ponctuation.
   - Ajouter des **lignes vides** entre les idees distinctes pour aerer le texte.
   - Utiliser des **listes a puces** (`- `) quand le contenu comporte plusieurs points ou elements enumeres, pour structurer le texte.
   - Ne pas ecrire un bloc de texte continu sur une seule ligne.
8. Afficher a l'utilisateur le resultat formate comme suit, en respectant les sauts de ligne :
   - Ligne 1 : `Fichier cree :` suivi du chemin `.flow/asks/<slug>.txt`
   - Ligne 2 : vide
   - Ligne 3 : `Pour lancer l'analyse :`
   - Ligne 4 : `/flow analysis .flow/asks/<slug>.txt`

**Regles :**
- **Ne jamais modifier le code source.** Cette commande ne produit qu'un fichier ask.
- **Ne pas declencher l'analyse automatiquement.** Se contenter de la proposer.
- **Ne pas ajouter d'en-tete** dans le fichier (pas de date, pas d'auteur, pas de titre).
- **Ne pas alterer le sens du prompt** lors de la reformulation.

---

## Commande : analysis

Analyser une demande ou une tache sans modifier le code source.

**Arguments :**
- `<path/to/ask.txt>` — Chemin vers le fichier de demande (normalement dans `.flow/asks/`, generalement `.txt`, peut aussi etre `.md`).
- `<comment>` — Informations supplementaires (optionnel).

**Fichier de sortie :** `.flow/outs/` avec le meme nom que la source (sans extension), suffixe par `-analysis.md`.
- `.flow/asks/feature.txt` → `.flow/outs/feature-analysis.md`
- `.flow/asks/feature.md` → `.flow/outs/feature-analysis.md`

**Comportement :**

1. Lire et analyser la demande decrite dans `<path/to/ask.txt>`.
2. Prendre en compte les informations supplementaires fournies dans `<comment>`.
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
     - Ligne 2 : `/flow review <path>`
   - Si le fichier existait et contenait un "Review Report" avec des **questions sans reponse** restantes → ne proposer aucune commande. Afficher :
     - Ligne 1 : `Des questions du rapport de revue n'ont pas encore de reponse.`
     - Ligne 2 : `Repondez aux questions dans le fichier, puis relancez :`
     - Ligne 3 : `/flow analysis <path>`
   - Sinon (analyse suivante sans questions en suspens) → afficher :
     - Ligne 1 : `Pour relancer une revue :`
     - Ligne 2 : `/flow review <path>`
     - Ligne 3 : vide
     - Ligne 4 : `Pour lancer le traitement :`
     - Ligne 5 : `/flow process <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

**Regles :**
- **Ne jamais modifier le code source.** Cette commande produit uniquement une analyse.

---

## Commande : review

Effectuer une revue critique d'une analyse existante sans modifier le code source.

**Arguments :**
- `<path/to/ask.txt|ask-analysis.md>` — Chemin vers le fichier de demande ou directement vers l'analyse.
- `<comment>` — Informations supplementaires (optionnel).

**Prerequis :** L'analyse correspondante doit exister dans `.flow/outs/`. Si elle est absente, **demander a l'utilisateur** de d'abord produire une analyse. Ne pas continuer sans l'analyse.

**Comportement :**

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
   - Ligne 2 : `/flow analysis <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

**Regles :**
- **Ne jamais modifier le code source.** Cette commande produit uniquement une revue.

---

## Commande : process

Realiser les modifications de code en suivant strictement une analyse existante.

**Arguments :**
- `<path/to/ask.txt|ask-analysis.md>` — Chemin vers le fichier de demande ou directement vers l'analyse.
- `<comment>` — Informations supplementaires (optionnel).

**Prerequis :** L'analyse correspondante doit exister dans `.flow/outs/`. Si elle est absente, **demander a l'utilisateur** de d'abord produire une analyse. Ne pas continuer sans l'analyse.

**Comportement :**

1. Lire l'analyse correspondante.
2. Appliquer les modifications de code decrites dans l'analyse.
3. Respecter les **normes et standards** du code existant dans le projet.
4. Suivre les **bonnes pratiques** definies dans `.flow/docs/best-practices.md` si le fichier existe.

5. Afficher a l'utilisateur la proposition de commande suivante :
   - Ligne 1 : `Pour lancer la validation :`
   - Ligne 2 : `/flow validate <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

**Regles :**
- **Modifier le code** en suivant strictement l'analyse.
- **Ne pas prendre de decisions** en dehors du perimetre de l'analyse.

---

## Commande : validate

Effectuer une revue critique des modifications de code sans modifier le code source.

**Arguments :**
- `<path/to/ask.txt|ask-analysis.md>` — Chemin vers le fichier de demande ou directement vers l'analyse.
- `<comment>` — Informations supplementaires (optionnel).

**Prerequis :** L'analyse correspondante doit exister dans `.flow/outs/`. Si elle est absente, **demander a l'utilisateur** de d'abord produire une analyse. Ne pas continuer sans l'analyse.

**Comportement :**

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
       - Ligne 2 : `/flow re-process <path>`
     - **Problemes majeurs** (logique incorrecte, incoherence avec la demande, approche technique a revoir, regression fonctionnelle) → afficher :
       - Ligne 1 : `Pour relancer l'analyse :`
       - Ligne 2 : `/flow analysis <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

**Regles :**
- **Ne jamais modifier le code source.** Cette commande produit uniquement un rapport de validation.

---

## Commande : re-process

Traiter les corrections identifiees dans le rapport de validation.

**Arguments :**
- `<path/to/ask.txt|ask-analysis.md>` — Chemin vers le fichier de demande ou directement vers l'analyse.
- `<comment>` — Informations supplementaires (optionnel).

**Prerequis :**
- L'analyse correspondante doit exister dans `.flow/outs/`. Si elle est absente, **demander a l'utilisateur** de d'abord produire une analyse.
- L'analyse doit contenir une section **"Validation Report"**. Si elle est absente, **demander a l'utilisateur** de d'abord lancer une validation.
- Ne pas continuer si l'un de ces prerequis n'est pas rempli.

**Comportement :**

1. Lire la section **"Validation Report"** dans l'analyse.
2. Traiter chaque point/note identifie dans le rapport.
3. Appliquer les corrections de code necessaires.
4. Respecter les **normes et standards** du code existant dans le projet.
5. Suivre les **bonnes pratiques** definies dans `.flow/docs/best-practices.md` si le fichier existe.

6. Afficher a l'utilisateur la proposition de commande suivante :
   - Ligne 1 : `Pour relancer la validation :`
   - Ligne 2 : `/flow validate <path>`
   - `<path>` est le meme parametre que celui recu par la commande.

**Regles :**
- **Modifier le code** uniquement pour traiter les points du rapport de validation.
- **Ne faire aucune analyse.** Ne pas prendre de decisions en dehors du perimetre du rapport.
- **Ne pas modifier la section "Validation Report".** Sa mise a jour est le role de la commande validate.
