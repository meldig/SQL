-- Ajout de droit de lectures des tables de l'application G_GESTIONGEO contenues dans le schéma G_DALC pour permettre la mise à jour des tables dans le schéma G_GESTIONGEO.
GRANT SELECT ON G_DALC.TA_GG_AGENT TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_FAMILLE TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_ETAT_AVANCEMENT TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_DOSSIER TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_FME_FILTRE_SUR_LIGNE TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_CLASSE TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_DOMAINE TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_FICHIER TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_DOS_NUM TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_RELATION_CLASSE_DOMAINE TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_FME_MESURE TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_GEO TO G_GESTIONGEO_MAJ;
GRANT SELECT ON G_DALC.TA_GG_REPERTOIRE TO G_GESTIONGEO_MAJ;