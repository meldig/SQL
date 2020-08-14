/*
La table ta_organisme recense tous les organismes créateurs de données desquels proviennent les données source de la table ta_source.
*/

-- 1. Création de la table ta_organisme
CREATE TABLE g_geo.ta_organisme(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    acronyme VARCHAR2(50),
    nom_organisme VARCHAR2(2000)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_organisme IS 'Table rassemblant tous les organismes créateurs des données source utilisées par la MEL.';
COMMENT ON COLUMN g_geo.ta_organisme.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_organisme.acronyme IS 'Sigle correspondant à l''organisme créateur de la donnée source';
COMMENT ON COLUMN g_geo.ta_organisme.nom_organisme IS 'Nom de l''organisme créateur des données sources utilisées par la MEL';

-- 3. Création de la clé primaire
ALTER TABLE g_geo.ta_organisme 
ADD CONSTRAINT ta_organisme_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_organisme TO G_ADT_DSIG_ADM;