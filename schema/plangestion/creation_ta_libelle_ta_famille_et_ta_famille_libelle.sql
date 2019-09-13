-- Création de la table ta_libelle

-- 1. Création de la table
CREATE TABLE ta_libelle(
	objectid NUMBER(38,0),
	libelle VARCHAR2(4000)
);

-- 2. Création des commentaires
COMMENT ON TABLE ta_libelle IS 'Table contenant les libellés utilisés dans pour définir un état. Lien avec la table ta_famille_libelle.';
COMMENT ON COLUMN ta_libelle.objectid IS 'Identifiant de chaque libellé.';
COMMENT ON COLUMN ta_libelle.libelle IS 'Valeur de chaque libellé définissant l''état d''un objet ou d''une action.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_libelle
ADD CONSTRAINT 
	ta_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation de la clé primaire
CREATE SEQUENCE SEQ_ta_libelle
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur d'auto-incrémentation de la clé primaire
CREATE OR REPLACE TRIGGER BEF_ta_libelle
BEFORE INSERT ON ta_libelle
FOR EACH ROW

BEGIN
	:new.objectid := SEQ_ta_libelle.nextval;
END;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_libelle TO G_ADT_DSIG_ADM;

-- Création de la table ta_famille

-- 1. Création de la table
CREATE TABLE ta_famille(
	objectid NUMBER(38,0),
	famille VARCHAR2(255)
);

-- 2. Création des commentaires
COMMENT ON TABLE ta_famille IS 'Table contenant les familles de libellés.';
COMMENT ON COLUMN ta_famille.objectid IS 'Identifiant de chaque famille de libellés.';
COMMENT ON COLUMN ta_famille.famille IS 'Valeur de chaque famille de libellés.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_famille
ADD CONSTRAINT 
	ta_famille_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation de la clé primaire
CREATE SEQUENCE SEQ_ta_famille
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur d'auto-incrémentation de la clé primaire
CREATE OR REPLACE TRIGGER BEF_ta_famille
BEFORE INSERT ON ta_famille
FOR EACH ROW

BEGIN
	:new.objectid := SEQ_ta_famille.nextval;
END;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_famille TO G_ADT_DSIG_ADM;

-- Création de la table ta_famille_libelle

-- 1. Création de la table
CREATE TABLE ta_famille_libelle(
	objectid NUMBER(38,0),
	fid_famille NUMBER(38,0),
	fid_libelle NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE ta_famille_libelle IS 'Table contenant les identifiant des tables ta_libelle et ta_famille, permettant de joindre le libellé à sa famille de libellés.';
COMMENT ON COLUMN ta_famille_libelle.objectid IS 'Identifiant de chaque ligne.';
COMMENT ON COLUMN ta_famille_libelle.fid_famille IS 'Identifiant de chaque famille de libellés - FK de la table ta_famille.';
COMMENT ON COLUMN ta_famille_libelle.fid_libelle IS 'Identifiant de chaque libellés - FK de la table ta_libelle.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT 
	ta_famille_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "INDX_GEO";

-- 4. Création de la séquence d'auto-incrémentation de la clé primaire
CREATE SEQUENCE SEQ_ta_famille_libelle
START WITH 1 INCREMENT BY 1;

-- 5. Création du déclencheur d'auto-incrémentation de la clé primaire
CREATE OR REPLACE TRIGGER BEF_ta_famille_libelle
BEFORE INSERT ON ta_famille_libelle
FOR EACH ROW

BEGIN
	:new.objectid := SEQ_ta_famille_libelle.nextval;
END;

-- 6. Création des clés étrangères
ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT
	ta_fam_lib_fid_famille_FK
FOREIGN KEY(fid_famille)
REFERENCES GEO.ta_famille(objectid);

ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT
	ta_fam_lib_fid_libelle_FK
FOREIGN KEY(fid_libelle)
REFERENCES GEO.ta_libelle(objectid);

-- 7. Création de l'index de la clé étrangère
CREATE INDEX ta_fam_lib_fid_famille_IDX ON ta_famille_libelle(fid_famille)
TABLESPACE INDX_GEO;

CREATE INDEX ta_fam_lib_fid_libelle_IDX ON ta_famille_libelle(fid_libelle)
TABLESPACE INDX_GEO;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON geo.ta_famille_libelle TO G_ADT_DSIG_ADM;

-- Création de la vue V_libelles

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW v_libelles (
    id_libelle, 
    id_famille, 
    libelle,
    CONSTRAINT v_libelles_PK PRIMARY KEY (id_libelle) DISABLE
) AS

SELECT
   a.objectid,
   b.objectid,
   c.libelle
FROM
    ta_famille_libelle a
    INNER JOIN ta_famille b
    ON a.id_famille = b.objectid
    INNER JOIN ta_libelle c
    ON a.id_libelle = c.objectid
;

-- 2. Création des commentaires sur la vue et les champs
COMMENT ON TABLE v_libelles IS 'Vue récupérant les libellés avec leur famille de libellés.';
COMMENT ON COLUMN geo.v_libelles.id_libelle IS 'Identifiant de chaque libellé.';
COMMENT ON COLUMN geo.v_libelles.id_famille IS 'Identifiant de chaque famille de libellés.';
COMMENT ON COLUMN geo.v_libelles.libelle IS 'Valeur de chaque libellé.';