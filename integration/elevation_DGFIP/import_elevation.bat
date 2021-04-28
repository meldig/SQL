@echo off
echo Bienvenu dans l insertion des elevations de TA_SUR_TOPO_G, issues de la cellule 3D, en base !
:: Import des données historique de la population en base.

:: 1. Déclaration et valorisation des variables
SET /p chemin_insertion="Veuillez saisir le chemin d'accès du dossier contenant les élévations : "
SET /p USER="Utilisateur Oracle de destination : "
SET /p MDP="MDP du schéma de destination : "
SET /p INSTANCE="Instance Oracle de destination :"

:: 2. Se mettre dans l'environnement de QGIS ;
cd C:\Program Files\QGIS 3.16\bin

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 4. Import de la donnée avec ogr2ogr.
ogr2ogr.exe -f OCI OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\table_extrusion_bati_test.csv -nln temp_elevation

:: 5. Mise en pause
pause