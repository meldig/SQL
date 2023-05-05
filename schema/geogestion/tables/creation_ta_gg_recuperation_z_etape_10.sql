-- 10. TA_GG_RECUPERATION_Z_ETAPE_10: Conversion des géométries des sous éléments au format SDO_GEOMETRY.
-- 10.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10 
	(	
	OBJECTID NUMBER(38,0),
    FID_NUMERO_DOSSIER NUMBER(38,0), 
	OBJECTID_ELEMENT NUMBER, 
	GEOM SDO_GEOMETRY 
   )
;

-- 10.2. Création de la contrainte d'unité
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_10_OBJECTID_OBJECTID_ELEMENT_UNIQUE UNIQUE("OBJECTID","OBJECTID_ELEMENT");


-- 10.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Conversion des géométries des sous éléments au format SDO_GEOMETRY.';

--10.4. Création des commentaires sur les colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10.OBJECTID IS 'Identifiant de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet'; 
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10.OBJECTID_ELEMENT IS 'Identifiant du sous élément de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10.GEOM IS 'Géométrie du sous élément de la ligne';

/
