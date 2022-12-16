-- 4. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_4: Récupération des sommets des sous éléments géométrique
-- 4.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4
	(
	OBJECTID_LIGNE NUMBER(38,0), 
	OBJECTID_ELEMENT_LIGNE NUMBER, 
	OBJECTID_SOMMET NUMBER, 
	COORD_X NUMBER, 
	COORD_Y NUMBER, 
	COORD_Z NUMBER, 
	GEOM MDSYS.SDO_GEOMETRY 
	)
;

-- 4.2. Création de la contrainte d'unité
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_4_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE","OBJECTID_SOMMET");


-- 4.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Récupération des sommets des sous éléments géométrique';

-- 4.4. Création des commentaires sur les colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4.COORD_X IS 'Coordonnée X du sommet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4.COORD_Y IS 'Coordonnée Y du sommet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4.COORD_Z IS 'Coordonnée Z du sommet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4.GEOM IS 'Géométrie du sommet de type point';

/
