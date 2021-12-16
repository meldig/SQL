@echo off
echo Bienvenu dans la creation des tables, vues et declencheurs de GestionGeo !

:: 1. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 2. Déclaration et valorisation des variables
SET /p chemin_code_table="Veuillez saisir le chemin d'acces du dossier contenant le code DDL des TABLES du schema : "
SET /p chemin_code_trigger="Veuillez saisir le chemin d'acces du dossier contenant le code DDL des DECLENCHEURS du schema : "
SET /p chemin_code_vue="Veuillez saisir le chemin d'acces du dossier contenant le code DDL des VUES du schema : "
SET /p chemin_code_mtd="Veuillez saisir le chemin d'acces du dossier integration\G_GESTIONGEO\import_des_donnees : "
SET /p chemin_code_temp="Veuillez saisir le chemin d'acces du dossier integration\G_GESTIONGEO\creation_tables_finales : "
::SET /p USER="Veuillez saisir l'utilisateur Oracle : "
::SET /p MDP="Veuillez saisir le MDP : "
::SET /p INSTANCE="Veuillez saisir l'instance Oracle : "

copy /b %chemin_code_table%\creation_ta_gg_agent.sql + ^
%chemin_code_table%\creation_ta_gg_etat.sql + ^
%chemin_code_table%\creation_ta_gg_famille.sql + ^
%chemin_code_table%\creation_ta_gg_dossier.sql + ^
%chemin_code_table%\creation_ta_gg_geo.sql + ^
%chemin_code_table%\creation_ta_gg_url_file.sql + ^
%chemin_code_trigger%\creation_b_iux_ta_gg_dossier.sql + ^
%chemin_code_trigger%\creation_b_iux_ta_gg_geo.sql + ^
%chemin_code_vue%\creation_v_gg_dossier_geo.sql + ^
%chemin_code_vue%\creation_v_gg_point.sql ^
%chemin_code_temp%\temp_code_ddl_schema.sql

%chemin_code_mtd%\creation_mtd_spatiales_temp_ta_gg_geo.sql ^

:: 3. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 4. Execution de sqlplus. pour lancer les requetes SQL.
qlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_code_temp%\temp_code_ddl_schema.sql

:: 5. MISE EN PAUSE
PAUSE