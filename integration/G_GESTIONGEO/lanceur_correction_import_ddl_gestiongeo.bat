@echo off
echo Bienvenu dans la correction des donnees de gestiongeo !

:: 1. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 2. Déclaration et valorisation des variables
SET /p chemin_correction_data="Veuillez saisir le chemin d'acces du dossier contenant le code de correction des donnees : "  
SET /p chemin_code_ddl="Veuillez saisir le chemin d'acces du dossier contenant le code DDL du schema : "  
SET /p USER_D="Veuillez saisir l'utilisateur Oracle de destination: "
SET /p USER_P="Veuillez saisir l'utilisateur Oracle de provenance: "
SET /p MDP_D="Veuillez saisir le mot de passe de l'utilisateur Oracle de destination: "
SET /p MDP_P="Veuillez saisir le mot de passe de l'utilisateur Oracle de provenance: "
SET /p INSTANCE_D="Veuillez saisir l'instance Oracle de destination: "
SET /p INSTANCE_P="Veuillez saisir l'instance Oracle de provenance: "

:: 3. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 4. Execution de sqlplus. pour lancer la requete SQL.
:: 4.1. Correction des données
sqlplus.exe %USER_P%/%MDP_P%@%INSTANCE_P% @%chemin_correction_data%\correction_donnees_gestiongeo.sql.

:: 4.2. Création ds tables finales
sqlplus.exe %USER_D%/%MDP_D%@%INSTANCE_D% @%chemin_code_ddl%\code_ddl_g_gestiongeo.sql

:: 5. se mettre dans l'environnement QGIS
cd C:\Program Files\QGIS 3.16\bin

:: 5.1. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 5.2. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.16\share\proj"

:: 6. commande ogr2ogr pour exporter les couches du schéma X@X vers le schéma X@X
:: 6.1. table TA_GG_FAMILLE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM GEO.TA_GG_FAMILLE" -nln TEMP_TA_GG_FAMILLE 

:: 6.2. table TA_GG_ETAT
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM GEO.TA_GG_ETAT" -nln TEMP_TA_GG_ETAT

:: 6.3. table TA_GG_SOURCE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM GEO.TA_GG_SOURCE" -nln TEMP_TA_GG_SOURCE

:: 6.4. table TA_GG_DOSSIER
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM GEO.TEMP_DOSSIER_CORRECTION" -nln TEMP_TA_GG_DOSSIER

:: 6.5. table TA_GG_GEO
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM GEO.TEMP_GEO_CORRECTION" -nln TEMP_TA_GG_GEO -nlt MULTIPOLYGON -lco SRID=2154 -dim 2
