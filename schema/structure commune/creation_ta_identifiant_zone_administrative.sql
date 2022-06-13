/* 
La table TA_IDENTIFIANT_ZONE_ADMINISTRATIVE permet de lier les zones supra-communales avec leurs codes.

*/
-- 1. Création de la table TA_IDENTIFIANT_ZONE_ADMINISTRATIVE
CREATE TABLE G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE(
    objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
    fid_zone_administrative Number(38,0),
    fid_identifiant NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE IS 'Table permettant de lier les zones supra-communales avec leurs codes.';
COMMENT ON COLUMN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE.fid_zone_administrative IS 'Clé étrangère de la table TA_ZONE_ADMINISTRATIVE.';
COMMENT ON COLUMN G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE.fid_identifiant IS 'Clé étrangère de la table TA_CODE.';


-- 3. Création de la clé primaire
ALTER TABLE G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE 
ADD CONSTRAINT TA_IDENTIFIANT_ZONE_ADMINISTRATIVE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE
ADD CONSTRAINT TA_IDENTIFIANT_ZONE_ADMINISTRATIVE_FID_ZONE_ADMINISTRATIVE_FK
FOREIGN KEY (fid_zone_administrative)
REFERENCES G_GEO.TA_ZONE_ADMINISTRATIVE(objectid);

ALTER TABLE G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE
ADD CONSTRAINT TA_IDENTIFIANT_ZONE_ADMINISTRATIVE_FID_IDENTIFIANT_FK
FOREIGN KEY (fid_identifiant)
REFERENCES G_GEO.TA_CODE(objectid);

-- 5. Création des index sur les clés étrangères
CREATE INDEX TA_IDENTIFIANT_ZONE_ADMINISTRATIVE_FID_ZONE_ADMINISTRATIVE_IDX ON G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE(fid_zone_administrative)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_IDENTIFIANT_ZONE_ADMINISTRATIVE_FID_IDENTIFIANT_IDX ON G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE(fid_identifiant)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_GEO.TA_IDENTIFIANT_ZONE_ADMINISTRATIVE TO G_ADMIN_SIG;