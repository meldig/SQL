/*
Creation de la table G_GEO.TA_BPE_CARACTERISTIQUE pour faire la liaison entre un equipement de la BPE vers ses caractéristiques.
*/
-- 1. Création de la table
CREATE TABLE G_GEO.TA_BPE_CARACTERISTIQUE(
	objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
    fid_bpe NUMBER(38,0),
    fid_libelle NUMBER(38,0)
	);

-- 2. Création des commentaires
COMMENT ON TABLE G_GEO.TA_BPE_CARACTERISTIQUE IS 'Table de relation entre les equipements et les libelles pour connaitre les caractéristiques des équipements';
COMMENT ON COLUMN G_GEO.TA_BPE_CARACTERISTIQUE.objectid IS 'Clé primaire de la table G_GEO.TA_BPE_CARACTERISTIQUE.';
COMMENT ON COLUMN G_GEO.TA_BPE_CARACTERISTIQUE.fid_bpe IS 'Clé étrangère vers la table G_GEO.TA_BPE';
COMMENT ON COLUMN G_GEO.TA_BPE_CARACTERISTIQUE.fid_libelle IS 'Clé étrangère vers la table TA_LIBELLE pour connaitre la caractéristique de l''equipement';

-- 3. Création de la clé primaire
ALTER TABLE G_GEO.TA_BPE_CARACTERISTIQUE
ADD CONSTRAINT TA_BPE_CARACTERISTIQUE_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. clé étrangère

-- 4.1 clé étrangère vers la table G_GEO.TA_BPE
ALTER TABLE G_GEO.TA_BPE_CARACTERISTIQUE
ADD CONSTRAINT TA_BPE_CARACTERISTIQUE_FID_BPE_FK
FOREIGN KEY ("FID_BPE")
REFERENCES G_GEO.TA_BPE ("OBJECTID");

-- 4.2 clé étrangère vers la table TA_LIBELLE pour connaitre la caractéristique de l'equipement
ALTER TABLE G_GEO.TA_BPE_CARACTERISTIQUE
ADD CONSTRAINT TA_BPE_CARACTERISTIQUE_FID_LIBELLE_FK
FOREIGN KEY ("FID_LIBELLE")
REFERENCES G_GEO.TA_LIBELLE ("OBJECTID");

-- 5. Création des index sur les clés étrangères.

CREATE INDEX TA_BPE_CARACTERISTIQUE_FID_BPE_IDX ON G_GEO.TA_BPE_CARACTERISTIQUE(fid_bpe)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_BPE_CARACTERISTIQUE_FID_LIBELLE_FILS_IDX ON G_GEO.TA_BPE_CARACTERISTIQUE(fid_libelle)
    TABLESPACE G_ADT_INDX;