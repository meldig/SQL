-- 6. Création de la table TA_GG_RECUPERATION_2_ETAPE_6: Mise à 0 de l'atitude pour des sommets pour lesquels il n'y a pas de point topo.
-- 6.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6 
   (	
	OBJECTID NUMBER(38,0), 
	FID_NUMERO_DOSSIER NUMBER(38,0), 
	OBJECTID_ELEMENT NUMBER, 
	OBJECTID_SOMMET NUMBER, 
	COORD_X NUMBER, 
	COORD_Y NUMBER, 
	COORD_Z NUMBER
   )
;

-- 6.2. Création de la contrainte d'unité
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_6_OBJECTID_OBJECTID_ELEMENT_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID","OBJECTID_ELEMENT","OBJECTID_SOMMET");



-- 6.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Mise à 0 de l''altitude des sommets pour lesquels il n''y a pas de point topo.';

-- 6.4. Création des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6.OBJECTID IS 'Identifiant de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6.OBJECTID_ELEMENT IS 'Identifiant du sous élément de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6.COORD_X IS 'Coordonnée X du sommet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6.COORD_Y IS 'Coordonnée Y du sommet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6.COORD_Z IS 'Coordonnée Z du sommet';

/
