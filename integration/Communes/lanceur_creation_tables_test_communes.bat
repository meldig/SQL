@echo off
echo Bienvenu dans la creation des tables visant à tester l import des communes de la nouvelle BdTopo en base !

:: Import des communes reçues de l'IGN en base.

:: Déclaration et valorisation des variables
SET /p chemin_creation="Veuillez saisir le chemin d'accès du dossier contenant la requête de creation des tables permettant de tester l import des communes de la nouvelle BdTopo : "  
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"     

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 7. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 8. Execution de sqlplus. pour lancer les requetes SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_creation%\creation_tables_test_communes.sql
pause