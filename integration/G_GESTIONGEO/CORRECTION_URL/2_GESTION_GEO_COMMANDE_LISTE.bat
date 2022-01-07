:: export des chemins corriges des dossiers GESTION_GEO.

:: 0.
SET /P CHEMIN="Veuillez saisir le chemin de sortie des listes issues de la base: " 
SET /P CHEMIN_SHELL="Veuillez saisir le chemin de localisation des traitements shell de renommage des fichiers et des dossiers.: "  
SET /p USER="Veuillez saisir l utilisateur Oracle : " 
SET /p MDP="Veuillez saisir le MDP : " 
SET /p INSTANCE="Veuillez saisir l instance Oracle :"

:: 1. Se mettre dans l'environnement de QGIS ;
c:
cd C:\Program Files\QGIS 3.16.9\bin

:: 2. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 3. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.16\share\proj"

:: 3. Export des nouveaux chemins des dossiers GESTION GEO.
CALL ogr2ogr.exe -f "CSV" %CHEMIN%/liste_repertoire_renommer.csv OCI:%USER%/%MDP%@%INSTANCE%: -sql "SELECT REPLACE(DOSSIER,'\','/') AS DOSSIER, REPLACE(LIEN_RENOMMAGE_DOSSIER,'\','/') AS LIEN_RENOMMAGE_DOSSIER FROM TEMP_LISTE_FICHIER_GESTION_GEO WHERE ID_DOS IS NOT NULL"

:: 4. Export des nouveaux chemins des fichier GESTION GEO.
CALL ogr2ogr.exe -f "CSV" %CHEMIN%/liste_fichier_renommer.csv OCI:%USER%/%MDP%@%INSTANCE%: -sql "SELECT REPLACE(LIEN,'\','/') AS FICHIER, REPLACE(LIEN_RENOMMAGE_FICHIER,'\','/') AS LIEN_RENOMMAGE_FICHIER FROM TEMP_LISTE_FICHIER_GESTION_GEO WHERE ID_DOS IS NOT NULL"

:: 5. Retour dans le dossier ou ce trouve les deux fichiers shell pour renommer les repertoires.
cd %CHEMIN_SHELL%

:: 6. Appel de la commande GESTION_GEO_renommer_fichier_2 pour modifier le nom des repertoires
GESTION_GEO_renommer_fichier_2.sh

:: 7. Appel de la commande GESTION_GEO_renommer_repertoire_2 pour modifier le nom des repertoires
GESTION_GEO_renommer_repertoire_2.sh

PAUSE