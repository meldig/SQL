@echo off
echo Bienvenu dans l insertion des donnees des recensement en base !
:: Import des données historique de la population en base.

:: 1. Déclaration et valorisation des variables
SET /p chemin_insertion="Veuillez saisir le chemin d'accès du dossier contenant les données du recensement : "    
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"     

:: 2. Se mettre dans l'environnement de QGIS ;
c:
cd C:\Program Files\QGIS 3.10\bin

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 4. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.10\share\proj"

:: 5. Import de la donnée avec ogr2ogr.
ogr2ogr -f OCI OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\historique_pop_oracle.xlsx -nln temp_recensement