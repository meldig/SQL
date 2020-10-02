/* 
La table TA_IDENTIFIANT_ZONE_ADMINISTRATIVE permet de lier les zones supra-communales avec leurs codes.

*/
-- 1. Création de la table ta_identifiant_zone_administrative
CREATE TABLE g_referentiel.ta_identifiant_zone_administrative(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_zone_administrative Number(38,0),
    fid_identifiant NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_referentiel.ta_identifiant_zone_administrative IS 'Table permettant de lier les zones supra-communales avec leurs codes.';
COMMENT ON COLUMN g_referentiel.ta_identifiant_zone_administrative.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_referentiel.ta_identifiant_zone_administrative.fid_zone_administrative IS 'Clé étrangère de la table TA_ZONE_ADMINISTRATIVE.';
COMMENT ON COLUMN g_referentiel.ta_identifiant_zone_administrative.fid_identifiant IS 'Clé étrangère de la table TA_CODE.';


-- 3. Création de la clé primaire
ALTER TABLE g_referentiel.ta_identifiant_zone_administrative 
ADD CONSTRAINT ta_identifiant_zone_administrative_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE g_referentiel.ta_identifiant_zone_administrative
ADD CONSTRAINT ta_identifiant_zone_administrative_fid_zone_administrative_FK
FOREIGN KEY (fid_zone_administrative)
REFERENCES g_referentiel.ta_zone_administrative(objectid);

ALTER TABLE g_referentiel.ta_identifiant_zone_administrative
ADD CONSTRAINT ta_identifiant_zone_administrative_fid_identifiant_FK
FOREIGN KEY (fid_identifiant)
REFERENCES g_referentiel.ta_code(objectid);

-- 5. Création des index sur les clés étrangères
CREATE INDEX ta_identifiant_zone_administrative_fid_zone_administrative_IDX ON g_referentiel.ta_identifiant_zone_administrative(fid_zone_administrative)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_identifiant_zone_administrative_fid_identifiant_IDX ON g_referentiel.ta_identifiant_zone_administrative(fid_identifiant)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_referentiel.ta_identifiant_zone_administrative TO G_ADMIN_SIG;