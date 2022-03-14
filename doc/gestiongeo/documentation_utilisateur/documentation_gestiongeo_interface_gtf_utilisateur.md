# Documentation GESTIONGEO: Utilisation des chaines de traitements FME.

## 1. Ojectif:
Le but de ce document est d'expliquer comment utiliser les chaines de traitement FME dans le cadre de l'application __GESTIONGEO__.

## 2. Outil à utiliser:
Les chaines de traitement FME utiliser dans le cadre de l'application __GESTIONGEO__ sont disponibles à travers notre formulaire GTF:
- [Formulaire GTF](https://gtf.lillemetropole.fr/extraction/login) ;  

## 3. Lancer un traitement depuis GTF:

### 3.1. Etapes:
1. Après votre connexion sur l'interface GTF, vous serez automatiquement sur l'onglet Mes extractions. Vous devez vous rendre dans l'onglet mon travail puis demande
2. cliquer sur le bouton + Ajouter présent sur la partie en haut à droite de la page.
3. choisir la catégorie __GESTIONGEO__
3. choisissez l'une des trois chaines de la catégorie suivant son besoin.

### 3.2. Traitements disponibles:
Dans le cadre de l'application GESTIONGEO, trois chaines de traitement FME sont disponibles:

1. Intégration d'un récolement ou d'une Inverstigation complémentaire dans __GESTIONGEO__.
2. Déplacement d'un fichier attaché à un dossier __GESTIONGEO__ dans son répertoire.
3. Invalider un dossier de l'application __GESTIONGEO__.

#### 3.2.1. Intégration d'un récolement ou d'une Inverstigation complémentaire dans __GESTIONGEO__.

##### 3.2.1.1. Fonction de la chaine.

Le but de cette chaine est d'intégrer dans la base de données les éléments issus des recolements.
Cette chaine, si le dossier est un recolement effectue:
* Intégrer les éléments contenus dans les tables:
	* __GEO.TA_POINT_TOPO_GPS__.
	* __GEO.TA_LIG_TOPO_GPS__.
	* __PTOPO__.
* Met à jour la géométrie du périmètre du dossier.
* Déplace le fichier intégré dans le repertoire du dossier et le renommer suivant le nombre de dossier déjà intégré, son numéro de dossier et le code insee du dossier.
* Rajoute le fichier intégrer dans la table __G_GESTIONGEO.TA_GG_FICHIER__. Ajoute un 1 dans la colonne __INTEGRATION__ de la table pour indiquer que ce fichier est celui qui a été intégré dans les tables des éléments géométriques pour le dossier considérer.

Dans le cadre d'un dossier d'Investigation complémentaire:
* __Aucun élément géographique ne sera intégrer dans les tables en base__
* Met à jour le périmètre du dossier.
* Rajoute le fichier intégrer dans la table __G_GESTIONGEO.TA_GG_FICHIER__. Ajoute un 0 dans la colonne __INTEGRATION__ de la table car les éléments ne sont pas insérer dans les tables des éléments topographique en base.

##### 3.2.1.2. Utilisation de la chaine.

Pour fonctionner, cette chaine necessite trois paramètres.
1. Fichier source autocad à insérer
2. Le type de dossier, s'il s'agit d'un recolement ou d'une investigation complémentaire
3. Le numéro du dossier. A récupérer sur l'interface QGIS lors de la création de dossier.

#### 3.2.2. Déplacement d'un fichier attaché à un dossier __GESTIONGEO__ dans son répertoire.

##### 3.2.2.1. Fonction de la chaine.

Le but de cette chaine est de déplacer dans son répertoire dossier un fichier qui n'est pas déstiné à être intégré dans les tables des éléments topographiques. Cette chaine peut servir à déplacer dans son repertoire dossier des fichiers de différents formats, word, pdf, txt...
cette chaine effectue les opérations suivantes:
* Déplace le fichier fournit dans le repertoire du dossier et le renommer suivant le nombre de dossier déjà intégré, son numéro de dossier et le code insee du dossier.
* Rajoute le fichier intégrer dans la table __G_GESTIONGEO.TA_GG_FICHIER__. Ajoute un 0 dans la colonne __INTEGRATION__ de la table car les éléments ne sont pas insérer dans les tables des éléments topographique en base.

##### 3.2.2.2. Utilisation de la chaine.

Pour fonctionner, cette chaine necessite deux paramètres.
1. Fichier à déplacer.
2. Le numéro du dossier. A récupérer sur l'interface QGIS lors de la création de dossier.

#### 3.2.3. Invalider un dossier de l'application __GESTIONGEO__.

##### 3.2.3.1. Fonction de la chaine.

La chaine __Invalider un dossier de l'application GESTIONGEO__ à pour objectif de supprimer un dossier de l'application. Deux types de suppression sont possibles. La première va supprimer complètement un dossier, son perimètre, son repertoire, ses éléments dans les tables de l'application __GESTIONGEO__. Le deuxième type de suppression ne va supprimer que les éléments topographiques du dossier. 

##### 3.2.3.2. Utilisation de la chaine.

Pour fonctionner, cette chaine necessite deux paramètres.
1. Le numéro du dossier. A récupérer sur l'interface QGIS lors de la création de dossier.
2. Le type de suppression.