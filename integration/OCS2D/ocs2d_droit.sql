/*
Affectation des droits de lecture et de référence vers le schéma G_GEO pour les métadonnées et les Familles/Libellés.
*/

GRANT REFERENCES ON G_GEO.TA_METADONNEE TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GEO.TA_LIBELLE_LONG TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GEO.TA_LIBELLE_COURT TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GEO.TA_LIBELLE TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GEO.TA_LIBELLE_CORRESPONDANCE TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GEO.TA_LIBELLE_RELATION TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GEO.TA_FAMILLE_LIBELLE TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GEO.TA_FAMILLE TO G_OCS2D WITH GRANT OPTION;;

GRANT SELECT ON G_GEO.TA_METADONNEE TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_LIBELLE_LONG TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_LIBELLE_COURT TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_LIBELLE TO G_OCS2D WITH GRANT OPTION WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_LIBELLE_CORRESPONDANCE TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_LIBELLE_RELATION TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_FAMILLE TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_FAMILLE_LIBELLE TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_SOURCE TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_PROVENANCE TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_DATE_ACQUISITION TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_METADONNEE_RELATION_ORGANISME TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_ORGANISME TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_METADONNEE_RELATION_ECHELLE TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GEO.TA_ECHELLE TO G_OCS2D WITH GRANT OPTION;