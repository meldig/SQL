-- 2. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_2: Extraire pour chaque géométrie les sous éléments.
-- 2.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2 
	(
	OBJECTID NUMBER(38,0), 
    FID_NUMERO_DOSSIER NUMBER(38,0), 
	OBJECTID_ELEMENT NUMBER,
	TYPE_WKT_LIGNE_GEOMETRY CLOB, 
	TYPE_WKT_ELEMENT_GEOMETRY CLOB, 
	GEOM CLOB
	)
;

-- 2.2. Contrainte d'unicite de la table.
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_2_OBJECTID_OBJECTID_ELEMENT_UNIQUE UNIQUE("OBJECTID","OBJECTID_ELEMENT");


-- 2.3. Création du commentaire de la table.
COMMENT ON TABLE "G_GESTIONGEO"."TA_GG_RECUPERATION_Z_ETAPE_2"  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: récupère les sous éléments des géométries au format WKT.';

-- 2.4. Creation des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2.OBJECTID IS 'Identifiant de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2.OBJECTID_ELEMENT IS 'Identifiant du sous élément de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2.TYPE_WKT_LIGNE_GEOMETRY IS 'Type de géométrie WKT des objets complets';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2.TYPE_WKT_ELEMENT_GEOMETRY IS 'Type de géométrie WKT des éléments des objets';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2.GEOM IS 'Géométrie de l''objet au format WKT';

/
