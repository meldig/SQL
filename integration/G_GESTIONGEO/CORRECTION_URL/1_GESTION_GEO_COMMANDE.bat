:: extraction des dossiers gestiongeo de la base

:: 0.
SET /P CHEMIN_INSERTION="Veuillez saisir le chemin d'acces au repertoire contenant la liste des repertoires des dossiers GESTION_GEO: "
SET /p USER="Veuillez saisir l utilisateur Oracle : "
SET /p MDP="Veuillez saisir le MDP : "
SET /p INSTANCE="Veuillez saisir l instance Oracle :"

:: 5. Creation de la liste des repertoires présents dans le dossier gestion geo
CALL GESTION_GEO_liste_fichier_1.bat

:: 1. Encodage en UTF-8
chcp 65001

:: 2. Se mettre dans l'environnement de QGIS ;
c:
cd C:\Program Files\QGIS 3.20.3\bin

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 4. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.16\share\proj"

CALL OS

:: 6. Export de la liste des dossiers gestion geo
CALL ogr2ogr.exe -f OCI OCI:%USER%/%MDP%@%INSTANCE%:TEMP_LISTE_FICHIER_GESTION_GEO %CHEMIN%/liste_fichier_gestiongeo_test_incremente_colonne.csv -nln TEMP_LISTE_FICHIER_GESTION_GEO -lco ENCODING=UTF-8

:: 7. Mise en forme de la table TEMP_LISTE_FICHIER_GESTION_GEO afin de renommer les dossiers GESTION_GEO.
C:/ora12c/R1/BIN/sqlplus.exe %USER%/%MDP%@%INSTANCE% @%CHEMIN_INSERTION%\G_GESTION_GEO_MISE_EN_FORME_LIEN_1.sql

PAUSE