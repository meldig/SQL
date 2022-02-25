/*
Affectation des droits de lecture, édition et suppression des tables et les séquences du schéma GestionGeo.
*/
-- G_GESTIONGEO_R :
GRANT SELECT ON G_GESTIONGEO.TA_GG_FAMILLE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_AGENT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOMAINE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE TO G_GESTIONGEO_R;
--GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_GEO TO G_GESTIONGEO_R;
--GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_GESTIONGEO_R;

-- G_GESTIONGEO_RW :
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FAMILLE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_AGENT TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOMAINE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_DECALAGE_ABSCISSE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_DECALAGE_ABSCISSE TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE TO G_GESTIONGEO_RW;
--GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_GEO TO G_GESTIONGEO_RW;
--GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_GESTIONGEO_RW;








