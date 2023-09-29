-- 3. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_3: Conversion des géométries des sous éléments au format SDO_GEOMETRY
-- 3.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3 
   (
   	OBJECTID NUMBER(38,0), 
	OBJECTID_ELEMENT NUMBER, 
	FID_NUMERO_DOSSIER NUMBER(38,0), 
	TYPE_WKT_ELEMENT_GEOMETRY CLOB, 
	GEOM SDO_GEOMETRY
   ) 
;

-- 3.2. Contrainte d'unicite de la table.
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_3_OBJECTID_OBJECTID_ELEMENT_UNIQUE UNIQUE("OBJECTID","OBJECTID_ELEMENT");


-- 3.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3 IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: récupère les sous éléments des géométries au format SDO_GEOMETRY.';

-- 3.4. Créa des commantaires de la table.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3.OBJECTID IS 'Identifiant de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3.OBJECTID_ELEMENT IS 'Identifiant du sous élément de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3.TYPE_WKT_ELEMENT_GEOMETRY IS 'Type de géométrie WKT des éléments des objets';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3.GEOM IS 'Géométrie de l''élément';

/
