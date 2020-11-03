@echo off
echo Bienvenu dans la creation en base des objets necessaires aux points de vigilance et à l import des donnees !

:: 1. Déclaration et valorisation des variables
SET /p chemin_traitement="Veuillez saisir le chemin d'accès du dossier contenant les codes à exécuter :"
SET /p chemin_import="Veuillez saisir le chemin d'accès du dossier contenant les donnees à importer :"
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"     

:: 2. Concatener les fichiers de codes pour en permettre l'execution
type %chemin_traitement%\Creation_structure_points_de_vigilance.sql > pts_vigilance_temp.sql | echo. >> pts_vigilance_temp.sql ^
| type %chemin_traitement%\nomenclature_points_de_vigilance.sql >> pts_vigilance_temp.sql | echo. >> pts_vigilance_temp.sql ^
| type %chemin_traitement%\declencheurs_points_de_vigilance.sql >> pts_vigilance_temp.sql | echo. >> pts_vigilance_temp.sql ^
| type %chemin_traitement%\conversion_donnees_points_vigilance.sql >> pts_vigilance_temp.sql | echo. >> pts_vigilance_temp.sql ^
| type %chemin_traitement%\suppression_tables_de_construction.sql >> pts_vigilance_temp.sql | echo. >> pts_vigilance_temp.sql

:: 3. Se mettre dans l'environnement de QGIS ;
c:
cd C:\Program Files\QGIS 3.10\bin

:: 4. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 5. Rediriger la variable PROJ_LIB vers le bon fichier proj.db afin qu'ogr2ogr trouve le bon scr
setx PROJ_LIB "C:\Program Files\QGIS 3.10\share\proj"

:: 6. Importer les données brutes en base
ogr2ogr -f OCI OCI:%USER%/%MDP%@%INSTANCE% %chemin_import%\Point_interet_yann.shp -nln TEMP_POINT_VIGILANCE -nlt point -lco SRID=2154 -dim 2
ogr2ogr -f OCI -append OCI:%USER%/%MDP%@%INSTANCE% %chemin_import%\Point_interet.shp -nln TEMP_POINT_VIGILANCE -nlt point -lco SRID=2154 -dim 2

:: 7. Se mettre dans l'environnement SQL plus.
CD C:/ora12c/R1/BIN

:: 8. Lancement des requetes SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_traitement%\pts_vigilance_temp.sql
pause