-- 1. Creation de la table TA_GG_RECUPERATION_Z_ETAPE_1: Recuperation de la geométrie des éléments linéaire au format WKT
-- 1.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1
	(
	OBJECTID_LIGNE NUMBER(38,0), 
	NUMERO_DOSSIER VARCHAR2(13 BYTE), 
	TYPE_WKT_LIGNE_GEOMETRY CLOB,
	GEOM CLOB
	)
;

-- 1.2. Contrainte d'unicité de la table.
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_1_OBJECTID_LIGNE_UNIQUE UNIQUE("OBJECTID_LIGNE");

-- 1.3. Création du commentaire de la table.
COMMENT ON TABLE "G_GESTIONGEO"."TA_GG_RECUPERATION_Z_ETAPE_1" IS 'Table temporaire utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Récupère la geométrie des éléments linéaire au format WKT.';

-- 1.4. Creation des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.OBJECTID_LIGNE IS 'Contrainte d''unicité de la table TA_GG_RECUPERATION_Z_ETAPE_1, Identifiant de la ligne';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.NUMERO_DOSSIER IS 'Numéro du dossier de l''élément';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.TYPE_WKT_LIGNE_GEOMETRY IS 'Type de géométrie WKT de la ligne.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.GEOM IS 'Géométrie de l''élément au format WKT';

/
