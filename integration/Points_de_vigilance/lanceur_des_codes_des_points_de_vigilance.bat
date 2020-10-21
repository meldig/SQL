@echo off
echo Bienvenu dans la creation en base des objets necessaires aux points de vigilance !

:: 1. Déclaration et valorisation des variables
SET /p chemin="Veuillez saisir le chemin d'accès du dossier contenant les codes à exécuter :"
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"     

:: 2. Concatener les fichiers de codes pour en permettre l'execution
type %chemin%\Creation_structure_points_de_vigilance.sql > pts_vigilance_temp.sql | echo. >> pts_vigilance_temp.sql ^
| type %chemin%\nomenclature_points_de_vigilance.sql >> pts_vigilance_temp.sql | echo. >> pts_vigilance_temp.sql ^
| type %chemin%\declencheurs_points_de_vigilance.sql >> pts_vigilance_temp.sql | echo. >> pts_vigilance_temp.sql

:: 3. Se mettre sur son lecteur local ;
c:

:: 4. Se mettre dans l'environnement SQL plus.
CD C:/ora12c/R1/BIN

:: 5. Lancement des requetes SQL.
sqlplus.exe USER/MDP@INSTANCE @chemin\pts_vigilance_temp.sql
pause