:: Migration des données des schémas G_GESTIONGEO vers G_DALC

@echo off
:: utilisation de ogr2ogr pour exporter des tables du schéma d'import dans le schéma de production
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

:: 5.1. table TA_GG_AGENT
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_AGENT" -nln TA_GG_AGENT 

:: 5.2. table TA_GG_FAMILE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_FAMILLE" -nln TA_GG_FAMILLE

:: 5.3. table TA_GG_ETAT_AVANCEMENT
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT" -nln TA_GG_ETAT_AVANCEMENT

:: 5.4. table TA_GG_DOSSIER
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_DOSSIER" -nln TA_GG_DOSSIER

:: 5.4. table TA_GG_GEO
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_GEO" -nln TA_GG_GEO -nlt MULTIPOLYGON -lco SRID=2154 -dim 2

:: 5.5. table TA_GG_FME_FILTRE_SUR_LIGNE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE" -nln TA_GG_FME_FILTRE_SUR_LIGNE

:: 5.6. table TA_GG_CLASSE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_CLASSE" -nln TA_GG_CLASSE

:: 5.7. table TA_GG_DOMAINE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_DOMAINE" -nln TA_GG_DOMAINE

:: 5.8. table TA_GG_FICHIER
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_FICHIER" -nln TA_GG_FICHIER

:: 5.9. table TA_GG_DOS_NUM
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_DOS_NUM" -nln TA_GG_DOS_NUM

:: 5.10. table TA_GG_RELATION_CLASSE_DOMAINE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE" -nln TA_GG_RELATION_CLASSE_DOMAINE

:: 5.11. table TA_GG_FME_MESURE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_FME_MESURE" -nln TA_GG_FME_MESURE

:: 5.13. table TA_GG_REPERTOIRE
ogr2ogr.exe -f OCI OCI:%USER_D%/%MDP_D%@%INSTANCE_D% OCI:%USER_P%/%MDP_P%@%INSTANCE_P% -sql "SELECT * FROM G_GESTIONGEO.TA_GG_REPERTOIRE" -nln TA_GG_REPERTOIRE