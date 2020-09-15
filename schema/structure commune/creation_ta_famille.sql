/*
La table ta_famille rassemble toutes les familles de libellés.
*/
-- 1. Création de la table
CREATE TABLE g_geo.ta_famille(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	valeur VARCHAR2(255)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_famille IS 'Table contenant les familles de libellés.';
COMMENT ON COLUMN g_geo.ta_famille.objectid IS 'Identifiant de chaque famille de libellés.';
COMMENT ON COLUMN g_geo.ta_famille.valeur IS 'Valeur de chaque famille de libellés.';

-- 3. Création de la clé primaire
ALTER TABLE g_geo.ta_famille
ADD CONSTRAINT ta_famille_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_famille TO G_ADMIN_SIG;