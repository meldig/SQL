:: suppression des fichiers CSV
@ECHO OFF

:: 0. Encodage en UTF-8
chcp 65001
SET /P CHEMIN="Veuillez saisir le chemin de sortie du fichier qui va contenir les nouveaux chemins des repertoires: "  
SET /p USER="Veuillez saisir l utilisateur Oracle : " 
SET /p MDP="Veuillez saisir le MDP : " 
SET /p INSTANCE="Veuillez saisir l instance Oracle :"

:: Deplacement dans le repertoire fichier
CD %CHEMIN%

:: Suppression des fichiers CSV
DEL liste_fichier.csv
DEL liste_fichier_gestiongeo_test_incremente.csv
DEL liste_fichier_gestiongeo_test_incremente_colonne.csv
DEL liste_repertoire.csv
DEL liste_repertoire_gestiongeo_test_incremente.csv
DEL liste_repertoire_gestiongeo_test_incremente_colonne.csv
DEL liste_repertoire_renommer.csv

:: Suppression des éléments temporaire en base
:: table TEMP_LISTE_FICHIER_GESTION_GEO
:: table TEMP_LISTE_REPERTOIRE_GESTION_GEO

:: 7. Mise en forme de la table TEMP_LISTE_REPERTOIRE_GESTION_GEO afin de renommer les dossiers GESTION_GEO.
 CALL C:/ora12c/R1/BIN/sqlplus.exe %USER%/%MDP%@%INSTANCE% @%CHEMIN%\G_GESTION_GEO_NETTOYAGE_3.sql

PAUSE