/*
La table ta_source permet de rassembler toutes les données sources provenant d'une source extérieure à la MEL.
*/

-- 1. Création de la table ta_source
CREATE TABLE g_geo.ta_source(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    nom_source VARCHAR2(4000),
    description VARCHAR2(4000)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_source IS 'Table rassemblant toutes les sources des données utilisées par la MEL.';
COMMENT ON COLUMN g_geo.ta_source.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_source.nom_source IS 'Nom de la source des données.';
COMMENT ON COLUMN g_geo.ta_source.description IS 'Description de la source de données..';

-- 3. Création de la clé primaire
ALTER TABLE g_geo.ta_source 
ADD CONSTRAINT ta_source_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_source TO G_ADMIN_SIG;