/*
La table TA_IDENTIFIANT_COMMUNE est une table pivot permettant de regrouper tous les codes par commune. 
*/

-- 1. Création de la table
CREATE TABLE g_referentiel.ta_identifiant_commune(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	fid_commune NUMBER(38,0),
	fid_identifiant NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_referentiel.ta_identifiant_commune IS 'La table permet de regrouper tous les codes par commune.';
COMMENT ON COLUMN g_referentiel.ta_identifiant_commune.objectid IS 'Clé primaire de la table.';
COMMENT ON COLUMN g_referentiel.ta_identifiant_commune.fid_commune IS 'Clé étrangère de la table TA_COMMUNE.';
COMMENT ON COLUMN g_referentiel.ta_identifiant_commune.fid_identifiant IS 'Clé étrangère de la table TA_CODE.';

-- 3. Création de la clé primaire
ALTER TABLE g_referentiel.TA_IDENTIFIANT_COMMUNE
ADD CONSTRAINT	TA_IDENTIFIANT_COMMUNE_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE g_referentiel.ta_identifiant_commune
ADD CONSTRAINT ta_identifiant_commune_fid_commune_FK 
FOREIGN KEY (fid_commune)
REFERENCES g_referentiel.ta_commune(objectid);

ALTER TABLE g_referentiel.ta_identifiant_commune
ADD CONSTRAINT ta_identifiant_commune_fid_identifiant_FK 
FOREIGN KEY (fid_identifiant)
REFERENCES g_referentiel.ta_code(objectid);

-- 5. Création des index sur les clés étrangères
CREATE INDEX ta_identifiant_commune_fid_commune_IDX ON g_referentiel.ta_identifiant_commune(fid_commune)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_identifiant_commune_fid_identifiant_IDX ON g_referentiel.ta_identifiant_commune(fid_identifiant)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_referentiel.TA_IDENTIFIANT_COMMUNE TO G_ADMIN_SIG;