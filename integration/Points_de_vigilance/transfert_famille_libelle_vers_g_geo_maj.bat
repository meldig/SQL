@echo off
:: utilisation de ogr2ogr pour exporter des tables de CUDL vers MULTIT
echo Bienvenu dans l import des familles/libelles dans G_GEO_MAJ !
:: 1. gestion des identifiants Oracle
SET /p USER_D="Veuillez saisir l'utilisateur Oracle de destination: "
SET /p USER_P="Veuillez saisir l'utilisateur Oracle de provenance: "
SET /p MDP_D="Veuillez saisir le mot de passe de l'utilisateur Oracle de destination: "
SET /p MDP_P="Veuillez saisir le mot de passe de l'utilisateur Oracle de provenance: "
SET /p INSTANCE_D="Veuillez saisir l'instance Oracle de destination: "
SET /p INSTANCE_P="Veuillez saisir l'instance Oracle de provenance: "

:: 2. se mettre dans l'environnement QGIS
cd C:\Program Files\QGIS 3.16\bin

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 4. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.16\share\proj"

:: 5. commande ogr2ogr pour exporter les couches du schéma X@X vers le schéma X@X
:: 5.1. table TA_FAMILLE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT a.objectid, a.valeur FROM TA_FAMILLE a WHERE a.valeur IN('type de signalement des points de vigilance','type de vérification des points de vigilance','éléments de vigilance','statut du dossier','type de points de vigilance')" -nln TEMP_FAMILLE 

:: 5.2. table TA_LIBELLE_LONG
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT c.objectid, c.valeur FROM G_GEO.TA_FAMILLE a INNER JOIN G_GEO.TA_FAMILLE_LIBELLE b ON b.fid_famille = a.objectid INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long WHERE a.valeur IN('type de signalement des points de vigilance','type de vérification des points de vigilance','éléments de vigilance','statut du dossier','type de points de vigilance')" -nln TEMP_LIBELLE_LONG

:: 5.3. table TA_LIBELLE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT d.objectid, d.fid_libelle_long FROM G_GEO.TA_FAMILLE a INNER JOIN G_GEO.TA_FAMILLE_LIBELLE b ON b.fid_famille = a.objectid INNER JOIN G_GEO.TA_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long INNER JOIN G_GEO.TA_LIBELLE d ON d.fid_libelle_long = c.objectid WHERE a.valeur IN('type de signalement des points de vigilance','type de vérification des points de vigilance','éléments de vigilance','statut du dossier','type de points de vigilance')" -nln TEMP_LIBELLE

:: 6. MISE EN PAUSE
PAUSE