-- 8. TA_GG_RECUPERATION_Z_ETAPE_8: Conversion des sommets au format wkt
-- 8.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8 
	(	
	OBJECTID NUMBER(38,0), 
	FID_NUMERO_DOSSIER NUMBER(38,0), 
	OBJECTID_ELEMENT NUMBER, 
	OBJECTID_SOMMET NUMBER, 
	GEOM CLOB
	)
;

-- 8.2. Création de la contrainte d'unité
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_8_OBJECTID_OBJECTID_ELEMENT_OBJECTID_SOMMET_UNIQUE UNIQUE("OBJECTID","OBJECTID_ELEMENT","OBJECTID_SOMMET");



-- 8.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Conversion des sommets des éléments au format WKT après jointure avec la table G_GESTIONGEO.PTTOPO.';

-- 8.4. Création des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8.OBJECTID IS 'Identifiant de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8.OBJECTID_ELEMENT IS 'Identifiant du sous élément de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8.OBJECTID_SOMMET IS 'Identifiant du sommet au sein du sous élément de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8.GEOM IS 'Géométrie du sommet au format SDO_GEOM - type point';


/
