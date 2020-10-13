@echo off
echo Bienvenu dans la normalisation des donnees des communes en base !
:: Import des communes reçues de l'IGN en base.

:: Déclaration et valorisation des variables
SET /p chemin_normalisation="Veuillez saisir le chemin d'accès du fichier insertion_des_communes_des_hauts_de_france.sql : "
SET /p USER="Veuillez saisir l'utilisateur Oracle : "    
SET /p MDP="Veuillez saisir le MDP : "    
SET /p INSTANCE="Veuillez saisir l'instance Oracle :"     

:: Lancement du code de normalisation des données des communes
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_normalisation%insertion_des_communes_des_hauts_de_france.sql
pause