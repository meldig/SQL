/*
Affectation des droits de lecture, édition et suppression des tables GestionGeo.
*/
-- G_GESTIONGEO_R :
GRANT SELECT ON G_GESTIONGEO.TA_GG_FAMILLE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_ETAT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_AGENT TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.TA_GG_URL_FILE TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_GEO TO G_GESTIONGEO_R;
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_GESTIONGEO_R;

-- G_GESTIONGEO_RW :
GRANT SELECT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FAMILLE TO G_GESTIONGEO_RW;
GRANT SELECT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_ETAT TO G_GESTIONGEO_RW;
GRANT SELECT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_AGENT TO G_GESTIONGEO_RW;
GRANT SELECT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_GEO TO G_GESTIONGEO_RW;
GRANT SELECT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_DOSSIER TO G_GESTIONGEO_RW;
GRANT SELECT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_URL_FILE TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_GG_DOSSIER_GEO TO G_GESTIONGEO_RW;
GRANT SELECT ON G_GESTIONGEO.V_GG_POINT TO G_GESTIONGEO_RW;