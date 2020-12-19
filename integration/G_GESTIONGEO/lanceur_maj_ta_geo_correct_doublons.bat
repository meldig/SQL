@echo off
echo Bienvenu dans la mise à jour de la table TA_GEO_CORRECT_DOUBLONS !

:: 1. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 2. Déclaration et valorisation des variables
SET /p chemin_acces="Veuillez saisir le chemin d'accès du dossier contenant le code de mise à jour de TA_GEO_CORRECT_DOUBLONS : "  
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :" 

:: 3. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 4. Execution de sqlplus. pour lancer la requete SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_acces%\maj_ta_geo_correct_doublons.sql
pause