@echo off
:: utilisation de ogr2ogr pour exporter des tables de CUDL vers MULTIT
:: 1. gestion des identifiants Oracle
SET /p USER_D="Veuillez saisir l'utilisateur Oracle de destination: "
SET /p USER_P="Veuillez saisir l'utilisateur Oracle de provenance: "
SET /p MDP_D="Veuillez saisir le mot de passe de l'utilisateur Oracle de destination: "
SET /p MDP_P="Veuillez saisir le mot de passe de l'utilisateur Oracle de provenance: "
SET /p INSTANCE_D="Veuillez saisir l'instance Oracle de destination: "
SET /p INSTANCE_P="Veuillez saisir l'instance Oracle de provenance: "

:: 2. se mettre dans l'environnement QGIS
cd C:\Program Files\QGIS 3.20.3\bin

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 4. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.20.3\share\proj"

:: 5. commande ogr2ogr pour exporter les couches du schéma X@X vers le schéma X@X
:: 5.1. table TA_GG_FAMILLE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TA_GG_FAMILLE -sql "SELECT * FROM GEO.TA_GG_FAMILLE" -nln TEMP_TA_GG_FAMILLE 

:: 5.2. table TA_GG_ETAT
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TA_GG_ETAT -sql "SELECT * FROM GEO.TA_GG_ETAT" -nln TEMP_TA_GG_ETAT

:: 5.4. table TA_GG_DOSSIER
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TEMP_TA_GG_DOSSIER -sql "SELECT * FROM GEO.TEMP_TA_GG_DOSSIER" -nln TEMP_TA_GG_DOSSIER

:: 5.5. table TA_GG_GEO
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TEMP_TA_GG_GEO -sql "SELECT * FROM GEO.TEMP_TA_GG_GEO" -nln TEMP_TA_GG_GEO -nlt MULTIPOLYGON -lco SRID=2154 -dim 2

:: 5.6. table TA_CLASSE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TA_CLASSE -sql "SELECT * FROM GEO.TA_CLASSE" -nln TEMP_TA_CLASSE

:: 5.7. table TA_GG_DOMAINE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TA_DOM -sql "SELECT * FROM GEO.TA_DOM" -nln TEMP_TA_DOM

:: 6. MISE EN PAUSE
PAUSE