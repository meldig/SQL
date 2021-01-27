@echo off
echo Bienvenu dans la creation en base des objets necessaires aux points de vigilance et à l import des donnees !

:: 1. Déclaration et valorisation des variables
SET /p chemin_traitement="Veuillez saisir le chemin d'accès du dossier contenant les codes à exécuter :"
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"     

:: 7. Se mettre dans l'environnement SQL plus.
CD C:/ora12c/R1/BIN

:: 8. Lancement des requetes SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_traitement%\Creation_structure_points_de_vigilance.sql
pause