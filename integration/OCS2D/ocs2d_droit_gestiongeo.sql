/*
Affectation des droits de lecture et de référence vers le schéma G_GESTIONGEO pour référencer les utilisateurs.
*/

GRANT REFERENCES ON G_GESTIONGEO.TA_GG_AGENT TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GESTIONGEO.TA_GG_AGENT TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GESTIONGEO.TA_GRILLE TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GESTIONGEO.TA_GRILLE TO G_OCS2D WITH GRANT OPTION;

GRANT REFERENCES ON G_GESTIONGEO.TA_GRILLE_RELATION_ETAT TO G_OCS2D WITH GRANT OPTION;

GRANT SELECT ON G_GESTIONGEO.TA_GRILLE_RELATION_ETAT TO G_OCS2D WITH GRANT OPTION;