-- 9. TA_GG_RECUPERATION_Z_ETAPE_9: Reconstitution des sous éléments en concaténant les sommets d'un meme sous élément suivant les identifiants des sommets.
-- 9.1. Création de la table.
CREATE GLOBAL TEMPORARY TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9 
	(	
	OBJECTID NUMBER(38,0), 
	FID_NUMERO_DOSSIER NUMBER(38,0), 
	OBJECTID_ELEMENT NUMBER, 
	GEOM VARCHAR2(4000 BYTE)
	)
;

-- 9.2. Création de la contrainte d'unité
ALTER TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9
ADD CONSTRAINT TA_GG_RECUPERATION_Z_ETAPE_9_OBJECTID_OBJECTID_ELEMENT_UNIQUE UNIQUE("OBJECTID","OBJECTID_ELEMENT");


-- 9.3. Création du commentaire de la table.
COMMENT ON TABLE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9  IS  'Table temporaire  utilisée pour récupérer le Z des éléments linéaire de la table TA_LIG_TOPO_GPS: Reconstitution des sous éléments en concaténant les sommets d''un meme sous élément suivant les identifiants des sommets.';

-- 9.4. Création des commentaires des colonnes.
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9.OBJECTID IS 'Identifiant de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1.FID_NUMERO_DOSSIER IS 'Numéro du dossier de l''objet';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9.OBJECTID_ELEMENT IS 'Identifiant du sous élément de l''objet, champ constituant de la contrainte d''unité';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9.GEOM IS 'Géométrie du sous élément de l''objet';

/
