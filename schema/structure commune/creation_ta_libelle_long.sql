/*
La table ta_libelle_long regroupe les libelles long pouvant être pris par les objets de la base.

*/
-- 1. Création de la table
CREATE TABLE g_geo.ta_libelle_long(
	objectid NUMBER(38,0),
	valeur VARCHAR2(255)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_libelle IS 'Table regroupant les libelles long pouvant être pris par les objets, états ou actions présents dans le schéma.';
COMMENT ON COLUMN g_geo.ta_libelle.objectid IS 'Clef primaire de la table TA_LIBELLE_LONG.';
COMMENT ON COLUMN g_geo.ta_libelle.valeur IS 'Valeur pouvant être prises par les objets, états ou actions présents dans le schéma.';

-- 3. Création de la clé primaire
ALTER TABLE g_geo.ta_libelle_long
ADD CONSTRAINT ta_libelle_long_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 5. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_libelle_long TO G_ADT_DSIG_ADM;