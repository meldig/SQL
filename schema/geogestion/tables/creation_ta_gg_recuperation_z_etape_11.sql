-- 11. TA_GG_RECUPERATION_Z_ETAPE_11: Reconstitution de la géométrie complète avec la fonction SDO_AGGR_UNION 
-- 11.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11 
   (	
   	OBJECTID NUMBER(38,0), 
	FID_NUMERO_DOSSIER NUMBER(38,0),
	GEOM SDO_GEOMETRY 
   )
;

-- 11.2. Création de la contrainte d'unité
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_11_OBJECTID_UNIQUE UNIQUE("OBJECTID");



-- 11.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Reconstitution de la géométrie complète avec la fonction SDO_AGGR_UNION ';

-- 11.4. Création des commentaires sur les colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11.OBJECTID IS 'Identifiant de l''objet'', contrainte d''unicité de la table';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11.GEOM IS 'Géométrie de l''objet''';

/
