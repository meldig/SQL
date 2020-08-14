/*
La table ta_famille_libelle sert à faire la liaison entre les tables ta_libelle_long et ta_famille.
*/
-- 1. Création de la table
CREATE TABLE g_geo.ta_famille_libelle(
	objectid NUMBER(38,0),
	fid_famille NUMBER(38,0),
	fid_libelle_long NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_famille_libelle IS 'Table contenant les identifiant des tables ta_libelle_long et ta_famille, permettant de joindre le libellé à sa famille de libellés.';
COMMENT ON COLUMN g_geo.ta_famille_libelle.objectid IS 'Identifiant de chaque ligne.';
COMMENT ON COLUMN g_geo.ta_famille_libelle.fid_famille IS 'Identifiant de chaque famille de libellés - FK de la table ta_famille.';
COMMENT ON COLUMN g_geo.ta_famille_libelle.fid_libelle_long IS 'Identifiant de chaque libellés - FK de la table ta_libelle_long.';

-- 3. Création de la clé primaire
ALTER TABLE g_geo.ta_famille_libelle
ADD CONSTRAINT ta_famille_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE g_geo.ta_famille_libelle
ADD CONSTRAINT ta_fam_lib_fid_famille_FK
FOREIGN KEY("fid_famille")
REFERENCES g_geo.ta_famille(objectid);

ALTER TABLE g_geo.ta_famille_libelle
ADD CONSTRAINT ta_fam_lib_fid_libelle_long_FK
FOREIGN KEY("fid_libelle_long")
REFERENCES g_geo.ta_libelle_long(objectid);

-- 7. Création de l'index de la clé étrangère
CREATE INDEX ta_fam_lib_fid_famille_IDX ON ta_famille(objectid)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_fam_lib_fid_libelle_long_IDX ON ta_libelle_long(objectid)
TABLESPACE G_ADT_INDX;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_famille_libelle TO G_ADT_DSIG_ADM;
