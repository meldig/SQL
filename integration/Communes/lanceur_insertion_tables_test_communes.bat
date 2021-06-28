@echo off
echo Bienvenu dans l insertion des communes, deja en base, dans les tables de test, afin de simuler l etat des tables de production !
echo WARNING : CETTE ETAPE PREND PLACE APRES AVOIR CREE LES TABLES TEST !
:: Import des communes reçues de l'IGN en base.

:: Déclaration et valorisation des variables
SET /p chemin_insertion="Veuillez saisir le chemin d'accès du dossier contenant la requêtes d insertion des communes : "  
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"     

:: 3. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 7. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 8. Execution de sqlplus. pour lancer les requetes SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_insertion%\insertion_tables_test_communes.sql
pause