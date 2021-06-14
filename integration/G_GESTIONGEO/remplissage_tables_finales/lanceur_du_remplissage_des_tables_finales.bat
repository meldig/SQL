@echo off
echo Bienvenu dans le remplissage des tables finales sur Oracle 12c !

:: 1. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 2. Déclaration et valorisation des variables
SET /p chemin_acces="Veuillez saisir le chemin d'accès du dossier contenant le code d'insertion des données dans les tables finales' : "  
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :" 

:: 3. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 4. Execution de sqlplus. pour lancer la requete SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_acces%\remplissage_tables_finales_gestiongeo.sql
pause