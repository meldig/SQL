@echo off
echo Bienvenu dans l'import des familles/libellés utilisés pour les grilles de saisie/vérification ! 

:: 1. gestion des identifiants Oracle
SET /p USER_P="Veuillez saisir l'utilisateur Oracle de provenance : "
SET /p MDP_P="Veuillez saisir le mot de passe de l'utilisateur Oracle de provenance : "
SET /p INSTANCE_P="Veuillez saisir l'instance Oracle de provenance: "
SET /p USER_D1="Famille/Libelle : Veuillez saisir l'utilisateur Oracle de destination : "
SET /p MDP_D1="Famille/Libelle : Veuillez saisir le mot de passe de l'utilisateur Oracle de destination : "
SET /p INSTANCE_D1="Famille/Libelle : Veuillez saisir l'instance Oracle de destination: "
SET /p USER_D2="GRILLES : Veuillez saisir l'utilisateur Oracle de destination : "
SET /p MDP_D2="GRILLES : Veuillez saisir le mot de passe de l'utilisateur Oracle de destination : "
SET /p INSTANCE_D2="GRILLES : Veuillez saisir l'instance Oracle de destination: "
:: 2. se mettre dans l'environnement QGIS
cd C:\Program Files\QGIS 3.16.9\bin

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 4. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.16\share\proj"

:: 5. commande ogr2ogr pour importer dans la base oracle les données contenues dans un CSV

:: 5.1. table TEMP_LIBELLE
ogr2ogr.exe -f OCI OCI:%USER_D1%/%MDP_D1%@%INSTANCE_D1% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TA_LIBELLE -sql "SELECT * FROM GEO.TA_LIBELLE WHERE OBJECTID IN(1, 2, 3)" -nln TEMP_LIBELLE

:: 5.2. table TEMP_THEMATIQUE
ogr2ogr.exe -f OCI OCI:%USER_D1%/%MDP_D1%@%INSTANCE_D1% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TA_THEMATIQUE -sql "SELECT * FROM GEO.TA_THEMATIQUE" -nln TEMP_THEMATIQUE

:: 5.3. table TEMP_GRILLE
ogr2ogr.exe -f OCI OCI:%USER_D2%/%MDP_D2%@%INSTANCE_D2% OCI:%USER_P%/%MDP_P%@%INSTANCE_P%:TA_GRILLE -sql "SELECT * FROM GEO.TA_GRILLE" -nln TEMP_GRILLE -nlt POLYGON -lco SRID=2154 -dim 2

:: 6. MISE EN PAUSE
PAUSE