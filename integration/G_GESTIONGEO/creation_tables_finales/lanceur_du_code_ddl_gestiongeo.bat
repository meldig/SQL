@echo off
echo Bienvenu dans la creation des tables, vues et declencheurs de GestionGeo !

:: 1. Configurer le système d'encodage des caractères en UTF-8
SET NLS_LANG=AMERICAN_AMERICA.AL32UTF8

:: 2. Déclaration et valorisation des variables
SET /p chemin_code_sequence="Veuillez saisir le chemin d'acces du dossier contenant le code DDL des SEQUENCES du schema : "
SET /p chemin_code_fonction="Veuillez saisir le chemin d'acces du dossier contenant le code DDL des FONCTIONS du schema : "
SET /p chemin_code_table="Veuillez saisir le chemin d'acces du dossier contenant le code DDL des TABLES du schema : "
SET /p chemin_code_trigger="Veuillez saisir le chemin d'acces du dossier contenant le code DDL des DECLENCHEURS du schema : "
SET /p chemin_code_vue="Veuillez saisir le chemin d'acces du dossier contenant le code DDL des VUES du schema : "
SET /p chemin_code_droits="Veuillez saisir le chemin d'acces du dossier contenant les droits de lecture et ecriture du schema : "
SET /p chemin_code_temp="Veuillez saisir le chemin d'acces du dossier integration\G_GESTIONGEO\creation_tables_finales : "
::SET /p USER="Veuillez saisir l'utilisateur Oracle : "
::SET /p MDP="Veuillez saisir le MDP : "
::SET /p INSTANCE="Veuillez saisir l'instance Oracle : "

copy /b %chemin_code_fonction%\creation_get_code_insee_polygon.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_etat_avancement_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_etat_avancement.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_famille_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_famille.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_classe_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_classe.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_geo_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_geo.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_dossier_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_dossier.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_url_file_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_url_file.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_dos_num_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_dos_num.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_domaine_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_domaine.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_relation_classe_domaine_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_relation_classe_domaine.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_fme_mesure_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_fme_mesure.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_fme_filtre_sur_ligne_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_fme_filtre_sur_ligne.sql + ^
%chemin_code_sequence%\creation_seq_ta_gg_fme_decalage_abscisse_objectid.sql + ^
%chemin_code_table%\creation_ta_gg_fme_decalage_abscisse.sql + ^
%chemin_code_fonction%\creation_get_id_dossier.sql + ^
%chemin_code_fonction%\creation_get_etat_avancement.sql + ^
%chemin_code_temp%\ajout_champs_calcules_ta_gg_geo.sql + ^
%chemin_code_trigger%\creation_b_uxx_ta_gg_dossier.sql + ^
%chemin_code_trigger%\creation_b_ixx_ta_gg_dossier.sql + ^
%chemin_code_trigger%\creation_a_ixx_ta_gg_geo.sql + ^
%chemin_code_trigger%\creation_b_iux_ta_gg_geo.sql + ^
%chemin_code_trigger%\creation_a_iud_ta_gg_geo_log.sql + ^
%chemin_code_trigger%\creation_a_iud_ta_gg_dossier_log.sql + ^
%chemin_code_vue%\creation_v_creation_dos_num.sql + ^
%chemin_code_fonction%\creation_get_dos_num.sql + ^
%chemin_code_vue%\creation_v_valeur_traitement_fme.sql + ^
%chemin_code_droits%\droits_lecture_edition_suppression_objets_gestiongeo.sql ^
%chemin_code_temp%\temp_code_ddl_schema.sql

:: 3. lancement de SQL plus.
CD C:/ora12c/R1/BIN

:: 4. Execution de sqlplus. pour lancer les requetes SQL.
sqlplus.exe %USER%/%MDP%@%INSTANCE% @%chemin_code_temp%\temp_code_ddl_schema.sql

:: 5. MISE EN PAUSE
PAUSE