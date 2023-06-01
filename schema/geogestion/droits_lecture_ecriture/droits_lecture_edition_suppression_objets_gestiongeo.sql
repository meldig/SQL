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
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO_LOG TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER_LOG TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOMAINE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_CLASSE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_CHEMIN_FICHIER_GESTIONGEO TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_GESTION_TRAITEMENT_FME TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_CREATION_DOS_NUM TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.VM_STAT_DOSSIER_PAR_COMMUNE TO G_GESTIONGEO_R;

-- G_GESTIONGEO_RW :
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FAMILLE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_ETAT_AVANCEMENT_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_AGENT TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_GEO_LOG TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_GEO_OBJECTID TO G_GESTIONGEO_RW;
GRANT UPDATE(GEOM) ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOSSIER_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOSSIER_LOG TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOMAINE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_DOMAINE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_CLASSE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_CLASSE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_MESURE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_MESURE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_GG_FME_FILTRE_SUR_LIGNE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_RW;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_REPERTOIRE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_AGENT_ANNEE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_ANNEE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_ETAT_AVANCEMENT TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_STAT_DOSSIER_PAR_TERRITOIRE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_TRAITEMENT_FME TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_VALEUR_GESTION_TRAITEMENT_FME TO G_GESTIONGEO_RW;

-- SEQUENCE
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_POINT_INTEGRATION_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_LINEAIRE_INTEGRATION_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_POINT_PRODUCTION_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_LINEAIRE_PRODUCTION_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_OCSMEL_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_PTTOPO_INTEGRATION_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_OCSMEL_LINEAIRE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_SURFACE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_IC_LINEAIRE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_SURFACE_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_POINT_INTEGRATION_LOG_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_POINT_PRODUCTION_LOG_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_LINEAIRE_INTEGRATION_LOG_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_LINEAIRE_PRODUCTION_LOG_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_OCSMEL_LOG_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_OCSMEL_LINEAIRE_LOG_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_IC_LINEAIRE_LOG_OBJECTID TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.SEQ_TA_RTGE_SURFACE_OBJECTID TO G_GESTIONGEO_RW;

/
