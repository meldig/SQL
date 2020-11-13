@echo off
echo Bienvenu dans l insertion des donnees des recensement en base !
:: Import des données historique de la population en base.

:: 1. Déclaration et valorisation des variables
SET /p chemin_insertion="Veuillez saisir le chemin d'accès du dossier contenant les données du recensement : "
SET /p chemin_fichier="Veuillez indiquer le chemin des fichiers SQL à concaténer : "
SET /p chemin_fichier_concatene="Veuillez indiquer le chemin vers le fichier concatene : "
SET /p USER="Veuillez saisir l'utilisateur Oracle : "
SET /p MDP="Veuillez saisir le MDP : "
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"

:: 2. Concatenation des fichiers SQL en un seul pour pour permettre l'execution des commandes par Oracle
type %chemin_fichier%\format_date.sql > %chemin_fichier_concatene%\recensement_temp.sql | echo. >> %chemin_fichier_concatene%\recensement_temp.sql ^
| type %chemin_fichier%\creation_structure_recensement.sql >> %chemin_fichier_concatene%\recensement_temp.sql | echo. >> %chemin_fichier_concatene%\recensement_temp.sql ^
| type %chemin_fichier%\insertion_nomenclature_recensement_donnees_historique.sql >> %chemin_fichier_concatene%\recensement_temp.sql | echo. >> %chemin_fichier_concatene%\recensement_temp.sql ^
| type %chemin_fichier%\normalisation_recensement_donnees_historique.sql >> %chemin_fichier_concatene%\recensement_temp.sql | echo. >> %chemin_fichier_concatene%\recensement_temp.sql

:: 3. Se mettre dans l'environnement de QGIS ;
c:
cd C:\Program Files\QGIS 3.10\bin

:: 4. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 5. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.10\share\proj"

:: 6. Import de la donnée avec ogr2ogr.
ogr2ogr -f OCI OCI:%USER%/%MDP%@%INSTANCE% %chemin_insertion%\base_pop_historiques_1876_2017_oracle.xlsx -nln temp_recensement
:: 5. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 6. Execution de sqlplus. pour lancer les requetes SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_fichier_concatene%\recensement_temp.sql