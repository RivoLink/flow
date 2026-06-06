# Flow

Skill leger pour les **flow**s d'automatisation IA.

Ensemble de commandes pour structurer et piloter le cycle d'analyse, de revue,
d'implementation et de validation d'une demande ou tache.

## Installation

**Bash**

```bash
curl -fsSL https://github.com/RivoLink/flow/raw/main/scripts/install.sh | bash
```

**PowerShell**

```powershell
irm https://github.com/RivoLink/flow/raw/main/scripts/install.ps1 | iex
```

Le script demande interactivement le harness (Claude, Codex ou Gemini).

### Usage avance

Pour passer des options, telecharger d'abord le script puis l'executer avec des arguments.

**Bash**

```bash
curl -fsSL https://github.com/RivoLink/flow/raw/main/scripts/install.sh -o flow.sh
bash flow.sh --claude --user --as-command --fr
```

**PowerShell**

```powershell
irm https://github.com/RivoLink/flow/raw/main/scripts/install.ps1 -OutFile flow.ps1
./flow.ps1 -Claude -User -AsCommand -Fr
```

### Options

| Flag | Description | Defaut |
|---|---|---|
| `claude` \| `codex` \| `gemini` | Harness cible | Prompt interactif |
| `user` \| `project` | Portee d'installation | `project` |
| `as-skill` \| `as-command` | Mode d'installation | `as-skill` |
| `en` \| `fr` | Langue des fichiers .md | `en` |

## Fonctionnalites

| Commande | Description |
|---|---|
| `flow help` | Affiche les commandes disponibles et le flux |
| `flow init` | Initialise l'environnement de travail du projet |
| `flow best-practices` | Ajoute des bonnes pratiques a la reference du projet |
| `flow asking` | Cree un fichier de demande a partir d'un prompt |
| `flow analysis` | Analyse une demande sans modifier le code |
| `flow review` | Revue critique de l'analyse |
| `flow process` | Applique les modifications de code |
| `flow validate` | Revue critique des modifications de code |
| `flow re-process` | Corrige le code selon le rapport de validation |

## Flux

Le cycle commence par `asking` et se termine quand `validate` renvoie `Valide`.

```
asking ──> analysis <──> review ──> process ──> validate <──> re-process
```

- **Boucle 1** : `analysis` et `review` jusqu'a ce que l'analyse soit coherente.
- **Boucle 2** : `validate` et `re-process` jusqu'au statut "Valide".

## Fonctionnement

Flow pilote une tache a travers un cycle fixe. Chaque etape lit et ecrit des
fichiers sous `.flow/`, donc la progression est toujours inspectable sur disque.

**Artefacts**

- `.flow/asks/<slug>.txt` : la demande reformulee.
- `.flow/outs/<slug>-analysis.md` : l'analyse. Une section `Review Report` puis
  une section `Validation Report` y sont ajoutees au fil du cycle.
- `.flow/docs/best-practices.md` : conventions du projet, lues par `process` et
  `re-process`.

**Deux boucles de retour**

- **Boucle 1** : `analysis` ↔ `review`. Iterer jusqu'a ce que l'analyse soit
  coherente et que chaque question de revue ait une reponse.
- **Boucle 2** : `validate` ↔ `re-process`. Iterer jusqu'a ce que le statut de
  validation soit `Valide`.

**Sortie**

Le cycle se termine quand `validate` renvoie `Valide`.

## Commandes

Commandes du cycle d'abord, puis setup, puis meta.

#### `flow asking <prompt>`

- **But** : Transformer un prompt libre en un fichier de demande propre.
- **Entree** : Texte du prompt.
- **Sortie** : `.flow/asks/<slug>.txt`.

#### `flow analysis <path>`

- **But** : Produire une analyse detaillee de la demande. Sans modifier le code.
- **Entree** : `.flow/asks/<slug>.txt`.
- **Sortie** : `.flow/outs/<slug>-analysis.md`.

#### `flow review <path>`

- **But** : Critiquer l'analyse sur les incoherences, questions et risques.
- **Entree** : Chemin de l'analyse.
- **Sortie** : Section `Review Report` ajoutee a l'analyse.

#### `flow process <path>`

- **But** : Appliquer les modifications de code en suivant l'analyse.
- **Entree** : Chemin de l'analyse.
- **Sortie** : Modifications du code source.

#### `flow validate <path>`

- **But** : Critiquer les modifications de code par rapport a l'analyse.
- **Entree** : Chemin de l'analyse.
- **Sortie** : Section `Validation Report` ajoutee a l'analyse, avec statut
  `Valide` ou `Non valide`.

#### `flow re-process <path>`

- **But** : Corriger les points releves par le dernier rapport de validation.
- **Entree** : Chemin de l'analyse avec un `Validation Report`.
- **Sortie** : Corrections du code source.

#### `flow init`

- **But** : Initialiser l'environnement de travail du projet.
- **Entree** : Aucune.
- **Sortie** : Entree `.gitignore` et arborescence `.flow/`.

#### `flow best-practices <comment>`

- **But** : Enregistrer les conventions du projet utilisees par `process` et
  `re-process`.
- **Entree** : Texte du commentaire.
- **Sortie** : Ajoute a `.flow/docs/best-practices.md`.

#### `flow help`

- **But** : Afficher la liste des commandes et le diagramme du flux.
- **Entree** : Aucune.
- **Sortie** : Message console.

## Langues

Flow est disponible en anglais (`en`, par defaut) et en francais (`fr`).

## Licence

[MIT](LICENSE)
