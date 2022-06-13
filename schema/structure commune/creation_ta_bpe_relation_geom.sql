/*
Creation de la table G_GEO.TA_BPE_RELATION_GEOM, table de correspondance entre les BPE et leurs positions géographiques.
*/
-- 1. Creation de la table
CREATE TABLE G_GEO.TA_BPE_RELATION_GEOM(
	fid_bpe NUMBER(38,0),
	fid_bpe_geom NUMBER(38,0)
	);

-- 2. Création des commentaires des colonnes
COMMENT ON TABLE G_GEO.TA_BPE_RELATION_GEOM IS 'Table de liaison entre les équipements et leurs géométries';
COMMENT ON COLUMN G_GEO.TA_BPE_RELATION_GEOM.fid_bpe IS 'Clé étrangère vers la table G_GEO.TA_BPE. Composante de la clé primaire.';
COMMENT ON COLUMN G_GEO.TA_BPE_RELATION_GEOM.fid_bpe_geom IS 'Clé étrangère vers la table G_GEO.TA_BPE_GEOM. Composante de la clé primaire.';

-- 3. Ajout de la clé primaire
ALTER TABLE G_GEO.TA_BPE_RELATION_GEOM
ADD CONSTRAINT TA_BPE_RELATION_GEOM_PK 
PRIMARY KEY(fid_bpe,fid_bpe_geom)
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères

-- 4.1 vers la table G_GEO.TA_BPE
ALTER TABLE G_GEO.TA_BPE_RELATION_GEOM
ADD CONSTRAINT TA_BPE_RELATION_GEOM_FID_BPE_FK
FOREIGN KEY ("FID_BPE")
REFERENCES G_GEO.TA_BPE("OBJECTID");

-- 4.2 vers la table G_GEO.TA_BPE_GEOM
ALTER TABLE G_GEO.TA_BPE_RELATION_GEOM
ADD CONSTRAINT TA_BPE_RELATION_GEOM_FID_BPE_GEOM_FK
FOREIGN KEY ("FID_BPE_GEOM")
REFERENCES G_GEO.TA_BPE_GEOM("OBJECTID");

-- 5. Création des index sur les cléfs étrangères.
CREATE INDEX TA_BPE_RELATION_GEOM_FID_BPE_IDX ON G_GEO.TA_BPE_RELATION_GEOM(fid_bpe)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_BPE_RELATION_GEOM_FID_BPE_GEOM_IDX ON G_GEO.TA_BPE_RELATION_GEOM(fid_bpe_geom)
    TABLESPACE G_ADT_INDX;