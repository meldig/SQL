/*
La table ta_libelle regroupe tous les états ou actions regroupés dans une famille elle-même située dans la tabe ta_famille.

*/
-- 1. Création de la table
CREATE TABLE g_geo.ta_libelle(
	objectid NUMBER(38,0),
	fid_libelle_long NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_libelle IS 'Table listant les libelles utilisé afin d''établir une hiérarchie.';
COMMENT ON COLUMN g_geo.ta_libelle.objectid IS 'Identifiant de chaque libellé.';
COMMENT ON COLUMN g_geo.ta_libelle.fid_libelle_long IS 'Clé étrangère vers la table TA_LIBELLE_LONG';

-- 3. Création de la clé primaire
ALTER TABLE g_geo.ta_libelle
ADD CONSTRAINT ta_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création de l'index de la clé étrangère
CREATE INDEX ta_libelle_fid_libelle_long_IDX ON ta_libelle(objectid)
TABLESPACE G_ADT_INDX;

-- 5. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_libelle TO G_ADT_DSIG_ADM;