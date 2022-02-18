@echo off
echo Bienvenu dans la suppression des tables temporaires ayant servi a importer les tables GestionGeo dans Oracle12c !

:: 1. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 2. Déclaration et valorisation des variables
SET /p chemin_code_ddl="Veuillez saisir le chemin d'accès du dossier contenant le code de suppression des tables temporaires : "  
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :" 

:: 3. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 4. Execution de sqlplus. pour lancer la requete SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_code_ddl%\suppression_tables_temporaires_oracle12c.sql
pause