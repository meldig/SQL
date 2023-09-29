-- 1. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_1: Recuperation de la geométrie des éléments linéaire au format WKT
-- 1.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1
	(
	OBJECTID NUMBER(38,0), 
	FID_NUMERO_DOSSIER NUMBER(38,0), 
	TYPE_WKT_LIGNE_GEOMETRY CLOB,
	GEOM CLOB
	)
;

-- 1.2. Contrainte d'unicité de la table.
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_1_OBJECTID_UNIQUE UNIQUE("OBJECTID");

-- 1.3. Création du commentaire de la table.
COMMENT ON TABLE "G_GESTIONGEO"."TA_GG_RECUPERATION_Z_ETAPE_1" IS 'Table temporaire utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Récupère la geométrie des éléments linéaire au format WKT.';

-- 1.4. Creation des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.OBJECTID IS 'Contrainte d''unicité de la table TA_GG_RECUPERATION_Z_ETAPE_1, Identifiant de la ligne';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.TYPE_WKT_LIGNE_GEOMETRY IS 'Type de géométrie WKT de la objet.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.GEOM IS 'Géométrie de l''élément au format WKT';

/
