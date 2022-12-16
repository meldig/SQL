-- 10. TA_GG_RECUPERATION_Z_ETAPE_10: Conversion des géométries des sous éléments au format SDO_GEOMETRY.
-- 10.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10 
	(	
	OBJECTID_LIGNE NUMBER(38,0), 
	OBJECTID_ELEMENT_LIGNE NUMBER, 
	GEOM SDO_GEOMETRY 
   )
;

-- 10.2. Création de la contrainte d'unité
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_10_OBJECTID_LIGNE_OBJECTID_ELEMENT_LIGNE_UNIQUE UNIQUE("OBJECTID_LIGNE","OBJECTID_ELEMENT_LIGNE");


-- 10.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Conversion des géométries des sous éléments au format SDO_GEOMETRY.';

--10.4. Création des commentaires sur les colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10.OBJECTID_LIGNE IS 'Identifiant de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10.OBJECTID_ELEMENT_LIGNE IS 'Identifiant du sous élément de la ligne, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10.GEOM IS 'Géométrie du sous élément de la ligne';

/
