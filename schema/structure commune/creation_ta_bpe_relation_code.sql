/*
Création de la table G_GEO.TA_BPE_RELATION_CODE, table de relation entre les équipements et les codes insee des communes ainsi que les codes IRIS d'implantation.
*/
-- 1. Création de la table
CREATE TABLE G_GEO.TA_BPE_RELATION_CODE(
    fid_bpe NUMBER(38,0),
    fid_code NUMBER(38,0)
    );

-- 2. Création des commentaires
COMMENT ON TABLE G_GEO.TA_BPE_RELATION_CODE IS 'Table regroupant les equipements de la Base Permanente des Equipements et leurs code d''INSEE et IRIS.';
COMMENT ON COLUMN G_GEO.TA_BPE_RELATION_CODE.fid_bpe IS 'Clé primaire de la table G_GEO.TA_BPE pour connaitre l''identifiant de l''équipement BPE.';
COMMENT ON COLUMN G_GEO.TA_BPE_RELATION_CODE.fid_code IS 'Clé étrangère vers la table TA_CODE pour connaitre les codes insee des communes ainsi que les codes IRIS des zones IRIS d''implantation de l''équipement';

-- 3. Création de la clé primaire.
ALTER TABLE G_GEO.TA_BPE_RELATION_CODE
ADD CONSTRAINT TA_BPE_RELATION_CODE_PK 
PRIMARY KEY("FID_BPE","FID_CODE")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
-- 4.1. Création de la clé étrangère vers la table ta_libelle pour connaitre le BPE concerné par le code.
ALTER TABLE G_GEO.TA_BPE_RELATION_CODE
ADD CONSTRAINT TA_BPE_RELATION_CODE_FID_BPE_FK
FOREIGN KEY ("FID_BPE")
REFERENCES G_GEO.TA_BPE("OBJECTID");

-- 4.2. Création de la clé étrangère vers la table ta_libelle pour connaitre le code de la commune d'implantation de l'équipement.
ALTER TABLE G_GEO.TA_BPE_RELATION_CODE
ADD CONSTRAINT TA_BPE_RELATION_CODE_FID_CODE_FK
FOREIGN KEY ("FID_CODE")
REFERENCES  G_GEO.TA_CODE ("OBJECTID");

-- 5. Création des index sur les clés étrangères.

CREATE INDEX TA_BPE_RELATION_CODE_FID_BPE_IDX ON G_GEO.TA_BPE_RELATION_CODE(fid_bpe)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_BPE_RELATION_CODE_FID_CODE_IDX ON G_GEO.TA_BPE_RELATION_CODE(fid_code)
    TABLESPACE G_ADT_INDX;