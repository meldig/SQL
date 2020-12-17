:: Le but de ces commandes est d'importer en base la liste des chemins des fichiers de chaque dossier créé avec GESTIONGEO en base.
:: Afin de corriger la colonne DOS_URL_FILE de la table GEO.TA_GG_DOSSIER

:: 1. Encodage en UTF-8
chcp 65001

:: 2. Déclaration des variables des chemins et des identifiants de la base Oracle:
SET /p CHEMIN='Entrez un chemin de sortie: '
SET /p CHEMIN_IC='Entrez le chemin des repertoire des donnees IC: '
SET /p CHEMIN_RECOL='Entrez le chemin des repertoires des donnees RECOL: '
SET /p CHEMIN_CORRECTIF_SQL='Entrez le chemin du script SQL nécessaire a la mise en forme de la liste en base et des requetes necessaire pour corriger les tables GESTION_GEO: '
SET /p USER="Veuillez saisir l'utilisateur Oracle : "
SET /p MDP="Veuillez saisir le MDP : "
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"

:: 3. Commande pour avoir la liste des fichiers contenues dans le repertoire IC:
FOR /D %%A IN (%CHEMIN_IC%\*.*) DO (DIR /b /a-d /s >> %CHEMIN%\liste_fichier_gestiongeo_test.csv "%%A\")
ECHO liste IC fait

:: 4. Commande pour avoir la liste des fichiers contenues dans le repertoire IC:
FOR /D %%A IN (%CHEMIN_RECOL%\*.*) DO (DIR /b /a-d /s >> %CHEMIN%\liste_fichier_gestiongeo_test.csv "%%A\")
ECHO liste RECOL fait

:: 5. Mise en forme du fichier généré aux étapes 3 et 4 par des commandes linux. Appelle du fichier généré en shell
gestion_geo_forme_liste.sh

:: 6. Deplacement dans le dossier de QGIS.
CD C:/Program Files/QGIS 3.16/bin

:: 7. Mise à jour de l'encodage en UTF-8.
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 8. Mise à jour de la variable PROJ_LIB pour indiquer le bon chemin vers le fichier proj.db
setx PROJ_LIB "C:\Program Files\QGIS 3.10\share\proj"

:: 9. Import des donnees.
ogr2ogr.exe -f OCI OCI:%USER%/%MDP%@%INSTANCE% C:\Users\rjault\Documents\14_GESTION_GEO\liste_fichier_gestiongeo_test_incremente_colonne.csv -nln TEMP_GG_FILES_LIST

:: 10. Deplacement dans le dossier SQLplus pour lancer le script SQL de correction
CD C:/ora12c/R1/BIN

:: 11. Execution de sqlplus. pour lancer les requetes SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%CHEMIN_CORRECTIF_SQL%\gestion_geo_correction_url.sql

:: 12. Mise en pause de la fenetre de commande
PAUSE