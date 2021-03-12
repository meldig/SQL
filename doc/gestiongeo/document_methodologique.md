## Methodologie développée pour renommer les dossiers contenus dans Appli_GG et pour corriger le champ __DOS_URL_FILE__ de chaque dossier géré par l'application gestiongeo.

### 1. Correction du nom des dossier contenus dans Appli_GG.

Le but de cette étape est de renommer chaque dossier avec son identifiant de dossier (ID_DOS).

#### 1.1. Exporter les dossiers de la table TA_GG_DOSSIER dans un fichier CSV.

Durant cette opération, vont être exporté de la table TA_GG_DOSSIER chaque dossier avec son code DOS_NUM, pour cela une commande *ogr2ogr* va être utilisée:

``
ogr2ogr.exe -f "CSV" CHEMIN\FICHIER.csv OCI:*SCHEMA*/*MDP*@*INSTANCE* -sql "SELECT ID_DOS, DOS_NUM, DOS_URL_FILE FROM TA_GG_DOSSIER"
``

Ce fichier va pouvoir être utilisé pour pouvoir associer à chaque dossier contenu dans APLLI_GG son code ID_DOS. En effet le nom des répertoires contenus dans APPLI_GG commence par le numéro DOS_NUM.

#### 1.2. Lister les répertoires contenus dans APPLI_GG.

Durant cette étape nous allons lister l'ensemble des répertoires contenus dans les répertoires APPLI_GG\IC et APPLIGG\RECOL. Pour cela nous allons utiliser le script liste_repertoire.bat. Ce fichier va lister l'ensemble des répertoires contenus dans APPLI_GG.

Ce script fait egalement appelle à un fichier shell (liste_repertoire.sh) afin de mettre en forme le fichier csv. Ce fichier shell va notamment ajouter une colonne OBJECTID et rajouter des en-têtes à celles-ci.

#### 1.3. Utilisation des fonctions excels afin de mettre à jour le nom du repertoire.

Durant cette étape, plusieurs fonctiosn SQL vont être appliquées afin de pouvoir former le nouveau nom des répertoires.

Liste des fonctions appliquées sur un exemple: P:\Appli_GG\RECOL\100090331_59009_rue_parmentier

| ORDRE | COLONNE    | FONCTION                                                                                                                                                                                                                                                                 | RESULTAT                                     | REMARQUE               |
|-------|------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|------------------------|
| 1     | DOS_NUM    | =STXT(B2;CHERCHE("\|";SUBSTITUE(B2;"\";"\|";NBCAR(B2)-NBCAR(SUBSTITUE(B2;"\";""))))+1;CHERCHE("_";STXT(B2;CHERCHE("\|";SUBSTITUE(B2;"\";"\|";NBCAR(B2)-NBCAR(SUBSTITUE(B2;"\";""))))+1;CHERCHE("\|";SUBSTITUE(B2;"\";"\|";NBCAR(B2)-NBCAR(SUBSTITUE(B2;"\";"")))));1)-1) | 100090331                                    |                        |
| 2     | ID_DOS     | =RECHERCHEV(C2;Feuil1!$A$2:$A$4525;2;FAUX)                                                                                                                                                                                                                               | 3744                                         | ATTENTION A LA MATRICE |
| 3     | NVX_CHEMIN | =CONCATENER(SUBSTITUE((STXT(B2;1;CHERCHE("\|";SUBSTITUE(B2;"\";"\|";NBCAR(B2)-NBCAR(SUBSTITUE(B2;"\";""))))));"\";"/");D2)                                                                                                                                               | V:/PROJET/14_GESTION_GEO/Appli_GG/RECOL/3744 |                        |


REMARQUE:
La fonction utilisée lors de l'étape deux est une fonction RECHERCHEV. Pour cela il est nécessaire de copier le csv issue de l'étape 1.1 dans le fichier csv issue de l'étape 1.2 ouvert avec excel.
il faut ensuite intervertir les deux colonnes __DOS_NUM__ et __ID_DOS__.

#### 1.4. Renommer les répertoires.

Une fois les étapes précédentes réalisées nous avons obtenus dans le fichier _CSV_ pour chaque répetoire son nouvau nom au format CHEMIN\ID_DOS. Il est alors possible de renommer chaque répertoire avec la commande SHELL suivante:
``
awk -F ; '{ system("mv -v "$1" "$2"") }' V:/PROJET/14_GESTION_GEO/CORRECTION_DOSSIER_APPLI_GG/IC/RENOMMAGE_TEST.csv
``

Avec cette commande, les répertoires contenus dans la colonne 1 du fichier csv ("$1") seront renommés avec les noms contenus dans la colonne 2 ("$2"). Il faut donc renseigner à la place les bonnes colonnes.

### 2. Insertion des liens des fichiers des dossiers dans la colonne DOS_URL_FILE de la table TA_GG_URL_FILE.

#### 2.1. Liste des fichiers contenus dans le répertoire APPLI_GG.

Durant cette étape nous allons lister l'ensemble des fichiers contenus dans les répertoires dossiers de chaque répertoire APPLI_GG\IC et APPLIGG\RECOL. Pour cela nous allons utiliser le script liste_fichier.bat. Ce script va lister l'ensemble des fichiers contenus dans APPLI_GG. Il s'agit des mêmes commandes que celles contenues dans le fichier liste_repertoire.bat. Seules les options des commandes diffèrent.

Ce script fait également appelle à un fichier shell (liste_fichier.sh) afin de mettre en forme le fichier csv. Ce fichier shell va notamment ajouter une colonne OBJECTID et rajouter des en-têtes à celles-ci.

#### 2.1. Import de la liste dans G_DALC afin de pouvoir mettre à jour la Liste des fichiers contenu dans le repertoire APPLI_GG.

La liste des fichiers précédemment créée va être importée en base et ensuite être traitée pour mettre à jour la table G_GESTION.TA_GG_URL_FILE. Pour cela un ensemble de requête a été créé:
GESTIONGEO_CORRECTION_URL.sql

``
ogr2ogr.exe -f OCI OCI:#UTILISATEUR#/#MDP#@#INSTANCE# V:/PROJET/14_GESTION_GEO/CORRECTION_DOSSIER_APPLI_GG/test_3/fichier/liste_fichier_gestiongeo_test_incremente_colonne.csv -nln TEMP_GG_FILES_LIST
``

Phasage des opérations réalisées pour mettre à jour la table G_GESTIONGEO.TA_GG_URL_FILE:

* CREATION D UNE COLONNE DE CLE PRIMARE.
	* SUPPRESSION DE LA COLONNE OBJECTID.
	* SUPPRESSION DES LIGNES CONTENANT DES FICHIERS Thumbs.db.
	* SUPPRESSION DE LA CONTRAINTE DE CLE PRIMAIRE.
	* SUPPRESSION DE LA COLONNE OGR_FID.
	* AJOUT D'UNE COLONNE CLE PRIMAIRE.
* CREATION DE LA COLONNE ID_DOS POUR LA JOINTURE.
* CREATION DE LA COLONNE INTEGRATION.
* AJOUT DES COMMENTAIRES SUR LES COLONNES DE LA TABLE.
* MISE EN FORME DE LA TABLE POUR ENSUITE INSERER LES INFORMATIONS DANS LA TABLE TA_GG_URL_FILE.
	* MISE EN FORME DE LA COLONNE LIEN.
		* REMPLACER LES  '/' PAR '\'.
		* MISE EN FORME DU LIEN \\volt\INFOGEO.
	* DETERMINATION DU ID_DOS POUR POUVOIR PERMETTRE SA JOINTURE AVEC LA TABLE TA_GG_URL_FILE.
	* MISE A JOUR LE COLONNE INTEGRATION.
		* MISE A 1 DE LA COLONNE POUR LES DOSSIERS OU UN SEUL FICHIER EST PRESENT.
		* MISE A 0 DE LA COLONNE INTEGRATION POUR LES DOSSIERS OU LES AUTRES FICHIERS D UN DOSSIER OU UN FICHIER EST DEJA A 1.
		* MISE A 0 DE LA COLONNE INTEGRATION POUR LES ELEMENTS QUI NE SONT NI DES FICHIERS DWG OU DXF.
* MERGE AVEC LA TABLE G_GESTIONGEO.TA_GG_URL_FILE