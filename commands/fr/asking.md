---
name: asking
description: >
  Cree un fichier de demande (ask) a partir d'un prompt utilisateur dans
  .flow/asks/ et propose de lancer l'analyse.
argument-hint: <prompt>
disable-model-invocation: true
---

Creer un fichier de demande a partir du prompt utilisateur.

**Prompt :** `$ARGUMENTS`

## Comportement

1. Si `$ARGUMENTS` est vide, **demander interactivement** a l'utilisateur de fournir un prompt. Ne pas continuer tant qu'un prompt non vide n'est pas obtenu.
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
   - Ligne 4 : `/flow:analysis .flow/asks/<slug>.txt`

## Regles

- **Ne jamais modifier le code source.** Cette commande ne produit qu'un fichier ask.
- **Ne pas declencher l'analyse automatiquement.** Se contenter de la proposer.
- **Ne pas ajouter d'en-tete** dans le fichier (pas de date, pas d'auteur, pas de titre).
- **Ne pas alterer le sens du prompt** lors de la reformulation.
