## Methodologie developpée Pour renommer les dossier contenus dans Appli_GG et pour corriger le champ __DOS_URL_FILE__ de chaque dossier gérés par l'application gestiongeo.

### 1. Correction du nom des dossier contenus dans Appli_GG.

Le but de cette étape est de renommer chaque dossier avec son identiant de dossier (ID_DOS).

#### 1.1. Exporter les dossiers de la table TA_GG_DOSSIER dans un fichier CSV.

Durant cette opération, vont être exporter de la table TA_GG_DOSSIER chaque dossier avec sont code DOS_NUM, pour cela une commande *ogr2ogr* va être utilisée:

``
ogr2ogr.exe -f "CSV" CHEMIN\FICHIER.csv OCI:*SCHEMA*/*MDP*@*INSTANCE* -sql "SELECT ID_DOS, DOS_NUM, DOS_URL_FILE FROM TA_GG_DOSSIER"
``

Ce fichier va pouvoir être utilisé pour pouvoir associer à chaque dossier contenu dans APLLI_GG son code ID_DOS. En effet le nom des repertoires contenu dans APPLI_GG commence par le numéro DOS_NUM.

#### 1.2. Lister les répertoires contenus dans APPLI_GG.

Durant cette étape nous allons lister l'ensemble des répertoires contenu dans les répertoires APPLI_GG\IC et APPLIGG\RECOL. Pour cela nous allons utiliser le script liste_repertoire.bat. Ce fichier va lister l'ensemble des repertoires contenu dans APPLI_GG.

Ce script fait egalement appelle à un fichier shell (liste_repertoire.sh) afin de mettre en forme le fichier csv. Ce fichier shell va notamment ajouter une colonne OBJECTID et rajouter des en-tête à celles-ci.

#### 1.3. Utilisation des fonctions excels afin de mettre à jour le nom du repertoire.

durant cette étape, plusieur fonction SQL vont être appliquées afin de pouvoir former le nouveau nom des repertoires.

Liste des fonctions appliquées sur un exemple: P:\Appli_GG\RECOL\100090331_59009_rue_parmentier

| ORDRE | COLONNE    | FONCTION                                                                                                                                                                                                                                                                 | RESULTAT                                     | REMARQUE               |
|-------|------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|------------------------|
| 1     | DOS_NUM    | =STXT(B2;CHERCHE("\|";SUBSTITUE(B2;"\";"\|";NBCAR(B2)-NBCAR(SUBSTITUE(B2;"\";""))))+1;CHERCHE("_";STXT(B2;CHERCHE("\|";SUBSTITUE(B2;"\";"\|";NBCAR(B2)-NBCAR(SUBSTITUE(B2;"\";""))))+1;CHERCHE("\|";SUBSTITUE(B2;"\";"\|";NBCAR(B2)-NBCAR(SUBSTITUE(B2;"\";"")))));1)-1) | 100090331                                    |                        |
| 2     | ID_DOS     | =RECHERCHEV(C2;Feuil1!$A$2:$A$4525;2;FAUX)                                                                                                                                                                                                                               | 3744                                         | ATTENTION A LA MATRICE |
| 3     | NVX_CHEMIN | =CONCATENER(SUBSTITUE((STXT(B2;1;CHERCHE("\|";SUBSTITUE(B2;"\";"\|";NBCAR(B2)-NBCAR(SUBSTITUE(B2;"\";""))))));"\";"/");D2)                                                                                                                                               | V:/PROJET/14_GESTION_GEO/Appli_GG/RECOL/3744 |                        |


REMARQUE:
La fonction utilisée lors de l'étape deux est une fonction RECHERCHEV. Pour cela il est nécessaire de copier le csv issue de l'étape 1.1 dans le fichier csv issue de l'étape 1.2 ouvert avec excel.
il est juste necessaire d'intervertir les deux colonnes __DOS_NUM__ et __ID_DOS__.

#### 1.4. Renommer les repertoires.

Une fois les étapes précédentes réalisé nous avons obtenus dans le fichier _CSV_ pour chaque répetoire son nouvau nom au format CHEMIN\ID_DOS. Il est alors possible de renommer chaque fichier avec la commande SHELL suivante:
``
awk -F ; '{ system("mv -v "$1" "$2"") }' V:/PROJET/14_GESTION_GEO/CORRECTION_DOSSIER_APPLI_GG/IC/RENOMMAGE_TEST.csv
``

Avec cette commande, les repertoires contenus dans la colonne 1 ("$1") seront renommés avec les noms contenus dans la colonne 2 ("$2"). Il faut donc renseigner à la place les bonnes colonnes.

### 2. Insertion des liens des fichiers des dossiers dans la colonne DOS_URL_FILE de la table TA_GG_URL_FILE.

#### 2.1. Lister des fichiers contenu dans le repertoire APPLI_GG.

Durant cette étape nous allons lister l'ensemble des fichiers contenus dans les répertoires dossiers de chaque répertoires APPLI_GG\IC et APPLIGG\RECOL. Pour cela nous allons utiliser le script fichier.bat. Ce fichier va lister l'ensemble des repertoires contenu dans APPLI_GG. Il s'agit des mêmes commandes que celles contenues dans le fichier liste_repertoire.bat. Seul les options des commandes diffèrent.

Ce script fait egalement appelle à un fichier shell (liste_fichier.sh) afin de mettre en forme le fichier csv. Ce fichier shell va notamment ajouter une colonne OBJECTID et rajouter des en-tête à celles-ci.


#### 2.1. Import de la liste dans G_DALC afin de pouvoir mettre à jour la Liste des fichiers contenu dans le repertoire APPLI_GG.

La liste des fichiers précédemment crée va être importer en base et ensuite être traiter pour mettre à jour la table G_GESTION.TA_GG_URL_FILE.