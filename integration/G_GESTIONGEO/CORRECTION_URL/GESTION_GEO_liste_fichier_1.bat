:: Le but de ces commandes est d'importer en base la liste des chemins des fichiers de chaque dossier créé avec GESTIONGEO en base.
:: Afin de corriger la colonne DOS_URL_FILE de la table GEO.TA_GG_DOSSIER

:: 1. Encodage en UTF-8
chcp 65001

:: 2. Déclaration des variables des chemins et des identifiants de la base Oracle:
SET /p CHEMIN='Entrez un chemin de sortie: '
SET /p CHEMIN_IC='Entrez le chemin des repertoire des donnees IC: '
SET /p CHEMIN_RECOL='Entrez le chemin des repertoires des donnees RECOL: '

:: 3. Commande pour avoir la liste des fichiers contenues dans le repertoire RECOL:
FOR /D %%A IN (%CHEMIN_RECOL%) DO (DIR /b /s /A-D>> %CHEMIN%\liste_fichier.csv "%%A\")
ECHO liste RECOL fait

:: 4. Commande pour avoir la liste des fichiers contenues dans le repertoire IC:
FOR /D %%A IN (%CHEMIN_IC%) DO (DIR /b /s /A-D>> %CHEMIN%\liste_fichier.csv "%%A\")
ECHO liste IC fait

:: 5. Mise en forme du fichier généré aux étapes 3 et 4 par des commandes linux. Appelle du fichier généré en shell

GESTION_GEO_liste_fichier_1.sh

PAUSE