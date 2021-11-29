@echo off
echo Bienvenu dans la creation des tables temporaires visant a corriger les tables de GestionGeo !

:: 1. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 2. Déclaration et valorisation des variables
SET /p chemin_code_ddl="Veuillez saisir le chemin d acces du dossier contenant le code de creation des tables de correction : "  
SET /p USER="Veuillez saisir l utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l instance Oracle :" 

:: 3. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 4. Execution de sqlplus. pour lancer la requete SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_code_ddl%\creation_tables_de_correction.sql
pause