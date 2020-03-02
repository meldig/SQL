/*
La table ta_famille rassemble toutes les familles de libellés.
*/
-- 1. Création de la table
CREATE TABLE ta_famille(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	famille VARCHAR2(255)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_famille IS 'Table contenant les familles de libellés.';
COMMENT ON COLUMN g_geo.ta_famille.objectid IS 'Identifiant de chaque famille de libellés.';
COMMENT ON COLUMN g_geo.ta_famille.famille IS 'Valeur de chaque famille de libellés.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_famille
ADD CONSTRAINT 
	ta_famille_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_famille TO G_ADMIN_SIG;

/*
La table ta_libelle regroupe tous les états ou actions regroupés dans une famille elle-même située dans la table ta_famille.

*/
-- 1. Création de la table
CREATE TABLE ta_libelle(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	libelle VARCHAR2(4000)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_libelle IS 'Table contenant les libellés utilisés dans pour définir un état. Lien avec la table ta_fam_lib.';
COMMENT ON COLUMN g_geo.ta_libelle.objectid IS 'Identifiant de chaque libellé.';
COMMENT ON COLUMN g_geo.ta_libelle.libelle IS 'Valeur de chaque libellé définissant l''état d''un objet ou d''une action.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_libelle
ADD CONSTRAINT 
	ta_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_libelle TO G_ADMIN_SIG;

/*
La table ta_famille_libelle sert à faire la liaison entre les tables ta_libelle et ta_famille.
*/
-- 1. Création de la table
CREATE TABLE ta_famille_libelle(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	fid_famille NUMBER(38,0),
	fid_libelle NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_famille_libelle IS 'Table contenant les identifiant des tables ta_libelle et ta_famille, permettant de joindre le libellé à sa famille de libellés.';
COMMENT ON COLUMN g_geo.ta_famille_libelle.objectid IS 'Identifiant de chaque ligne.';
COMMENT ON COLUMN g_geo.ta_famille_libelle.fid_famille IS 'Identifiant de chaque famille de libellés - FK de la table ta_famille.';
COMMENT ON COLUMN g_geo.ta_famille_libelle.fid_libelle IS 'Identifiant de chaque libellés - FK de la table ta_libelle.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT 
	ta_famille_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT
	ta_famille_libelle_fid_famille_FK
FOREIGN KEY(fid_famille)
REFERENCES
	ta_famille(objectid);

ALTER TABLE 
	ta_famille_libelle
ADD CONSTRAINT
	ta_famille_libelle_fid_libelle_FK
FOREIGN KEY(fid_libelle)
REFERENCES
	ta_libelle(objectid)INITIALLY IMMEDIATE DEFERRABLE;

-- 5. Création de l'index de la clé étrangère
CREATE INDEX ta_famille_libelle_fid_famille_IDX ON ta_famille_libelle(fid_famille)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_famille_libelle_fid_libelle_IDX ON ta_famille_libelle(fid_libelle)
TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_famille_libelle TO G_ADMIN_SIG;

/*
La table TA_CODE regroupe tous les codes du schéma. 
*/

-- 1. Création de la table
CREATE TABLE ta_code(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	code VARCHAR2(50),
	fid_libelle NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_code IS 'La table regroupe tous les codes du schéma G_GEO.';
COMMENT ON COLUMN g_geo.ta_code.objectid IS 'Clé primaire de la table.';
COMMENT ON COLUMN g_geo.ta_code.code IS 'Codes de chaque donnée du schéma.';
COMMENT ON COLUMN g_geo.ta_code.fid_libelle IS 'Clé étrangère de ta_libelle permettant de connaître la signification de chaque code.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_code
ADD CONSTRAINT 
	ta_code_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangère
ALTER TABLE ta_code
ADD CONSTRAINT ta_code_fid_libelle_FK
FOREIGN KEY (fid_libelle)
REFERENCES ta_libelle(objectid)INITIALLY IMMEDIATE DEFERRABLE;

-- 5. Création de l'index de la clé étrangère
CREATE INDEX ta_code_fid_libelle_IDX ON ta_code(fid_libelle)
TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_code TO G_ADMIN_SIG;

/*
La table ta_organisme recense tous les organismes créateurs de données desquels proviennent les données source de la table ta_source.
*/

-- 1. Création de la table ta_organisme
CREATE TABLE ta_organisme(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    acronyme VARCHAR2(50),
    nom_organisme VARCHAR2(2000)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_organisme IS 'Table rassemblant tous les organismes créateurs des données source utilisées par la MEL.';
COMMENT ON COLUMN g_geo.ta_organisme.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_organisme.nom_organisme IS 'Nom de l''organisme créateur des données sources utilisées par la MEL';

-- 3. Création de la clé primaire
ALTER TABLE ta_organisme 
ADD CONSTRAINT ta_organisme_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_organisme TO G_ADMIN_SIG;

/*
La table ta_source permet de rassembler toutes les données sources provenant d'une source extérieure à la MEL.
*/

-- 1. Création de la table ta_date_acquisition
CREATE TABLE ta_date_acquisition(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    date_acquisition DATE,
    millesime DATE,
    nom_obtenteur VARCHAR2(200)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_date_acquisition IS 'Table recensant les dates d''acquisition, de millésime et du nom de l''obtenteur de chaque donnée source extérieure à la MEL.';
COMMENT ON COLUMN g_geo.ta_date_acquisition.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_date_acquisition.date_acquisition IS 'Date d''importation de la donnée dans la table - DD/MM/AAAA.';
COMMENT ON COLUMN g_geo.ta_date_acquisition.millesime IS 'Date de création de la donnée - MM/AAAA.';
COMMENT ON COLUMN g_geo.ta_date_acquisition.nom_obtenteur IS 'Nom de la personne ayant inséré la donnée source dans la base.';

-- 3. Création de la clé primaire
ALTER TABLE ta_date_acquisition 
ADD CONSTRAINT ta_date_acquisition_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

/*-- 4. Création du déclencheur d'enregistrement de la date d'insertion de la donnée et du nom de la personne ayant fait cet import, dans la table ta_date_acquisition.

CREATE OR REPLACE TRIGGER ta_date_acquisition
BEFORE INSERT ON ta_source
FOR EACH ROW
DECLARE
	username VARCHAR2(200)

BEGIN
	select sys_context('USERENV','OS_USER') into username from dual;
	IF INSERTING THEN
		ta_date_acquisition.date_acquisition := sysdate;
		ta_date_acquisition.nom_obtenteur := username; 
	END IF;

END;*/
-- 5. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_date_acquisition TO G_ADMIN_SIG;

/*
La table ta_source permet de rassembler toutes les données sources provenant d'une source extérieure à la MEL.
*/

-- 1. Création de la table ta_source
CREATE TABLE ta_source(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    nom_source VARCHAR2(4000),
    description VARCHAR2(4000)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_source IS 'Table rassemblant toutes les sources des données utilisées par la MEL.';
COMMENT ON COLUMN g_geo.ta_source.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_source.nom_source IS 'Nom de la source des données.';
COMMENT ON COLUMN g_geo.ta_source.description IS 'Description de la source de données.';

-- 3. Création de la clé primaire
ALTER TABLE ta_source 
ADD CONSTRAINT ta_source_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_source TO G_ADMIN_SIG;

/*
La table ta_provenance regroupe tous les processus d'acquisition des donnees du referentiel (équivalent de TA_PROVENANCE)
*/

-- 1. Création de la table ta_provenance
CREATE TABLE ta_provenance(
    objectid NUMBER(38,0)GENERATED ALWAYS AS IDENTITY,
    url VARCHAR2(4000),
    methode_acquisition VARCHAR2(4000)
);
   
-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_provenance IS 'Table rassemblant tous les processus d''acquisition des donnees du referentiel.';
COMMENT ON COLUMN g_geo.ta_provenance.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_provenance.url IS 'URL à partir de laquelle les données source ont été téléchargées, si c''est le cas.';
COMMENT ON COLUMN g_geo.ta_provenance.methode_acquisition IS 'Méthode d''acquisition des données.';

-- 3. Création de la clé primaire
ALTER TABLE ta_provenance 
ADD CONSTRAINT ta_provenance_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.provenance TO G_ADMIN_SIG;

/*
La table ta_echelle regroupe toutes les échelles d'affichage des données source.
*/

-- 1. Création de la table ta_echelle
CREATE TABLE ta_echelle(
    objectid NUMBER(38,0)GENERATED ALWAYS AS IDENTITY,
    echelle VARCHAR2(20)
);
  
-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_echelle IS 'Table rassemblant toutes les échelles d''affichage des données source';
COMMENT ON COLUMN g_geo.ta_echelle.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_echelle.echelle IS 'Echelle de chaque donnée source.';

-- 3. Création de la clé primaire
ALTER TABLE ta_echelle 
ADD CONSTRAINT ta_echelle_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_echelle TO G_ADMIN_SIG;

/*
La table ta_metadonnee regroupe toutes les informations relatives aux différentes donnees du schemas.
*/
-- 1. Création de la table
CREATE TABLE ta_metadonnee(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	fid_source NUMBER(38,0),
	fid_acquisition NUMBER(38,0),
	fid_provenance NUMBER(38,0),
	fid_organisme NUMBER(38,0),
	fid_echelle NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_metadonnee IS 'Table qui regroupe toutes les informations relatives aux différentes donnees du schema.';
COMMENT ON COLUMN g_geo.ta_metadonnee.objectid IS 'clé primaire de la table.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_source IS 'clé étrangère vers la table TA_SOURCE pour connaitre la source de la donnée.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_acquisition IS 'clé étrangère vers la table ta_date_acquisition pour connaitre la date d''acquisition de la donnée.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_provenance IS 'clé étrangère vers la table TA_PROVENANCE pour connaitre la provenance de la donnée.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_organisme IS 'clé étrangère vers la table TA_ORGANISME pour connaitre l''organisme producteur de la donnee.';
COMMENT ON COLUMN g_geo.ta_metadonnee.fid_echelle IS 'clé étrangère vers la table TA_ECHELLE pour connaitre l''echelle de la donnee.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_metadonnee
ADD CONSTRAINT 
	ta_metadonnee_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";


-- 4. Création des clés étrangère

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_source_FK
FOREIGN KEY (fid_source)
REFERENCES ta_source(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_acquisition_FK
FOREIGN KEY (fid_acquisition)
REFERENCES ta_date_acquisition(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_provenance_FK
FOREIGN KEY (fid_provenance)
REFERENCES ta_provenance(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_organisme_FK
FOREIGN KEY (fid_organisme)
REFERENCES ta_organisme(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_echelle_FK
FOREIGN KEY (fid_echelle)
REFERENCES ta_echelle(objectid)INITIALLY IMMEDIATE DEFERRABLE;

-- 7. Création de l'index de la clé étrangère
CREATE INDEX ta_metadonnee_fid_source_IDX ON ta_metadonnee(fid_source)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_metadonnee_fid_acquisition_IDX ON ta_metadonnee(fid_acquisition)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_metadonnee_fid_provenance_IDX ON ta_metadonnee(fid_provenance)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_metadonnee_fid_organisme_IDX ON ta_metadonnee(fid_organisme)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_metadonnee_fid_echelle_IDX ON ta_metadonnee(fid_echelle)
TABLESPACE G_ADT_INDX;


-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_metadonnee TO G_ADMIN_SIG;

/*
La table Ta_NOM regroupe le nom de tous les objets du référentiel (les zones administratives)
*/

-- 1. Création de la table ta_nom
CREATE TABLE ta_nom(
    objectid NUMBER(38,0)GENERATED BY DEFAULT AS IDENTITY,
    acronyme VARCHAR2(50),
    nom VARCHAR2(4000)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_nom IS 'Table rassemblant tous les noms des objets du schéma.';
COMMENT ON COLUMN g_geo.ta_nom.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_nom.acronyme IS 'Acronyme de chaque nom - Exemple : MEL pour la Métropole Européenne de Lille.';
COMMENT ON COLUMN g_geo.ta_nom.nom IS 'Nom de chaque objet.';

-- 3. Création de la clé primaire
ALTER TABLE ta_nom 
ADD CONSTRAINT ta_nom_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_nom TO G_ADMIN_SIG;

/*
La table ta_commune regroupe toutes les communes de la MEL.
*/

-- 1. Création de la table ta_commune
CREATE TABLE ta_commune(
    objectid NUMBER(38,0)GENERATED BY DEFAULT AS IDENTITY,
    geom SDO_GEOMETRY,
    fid_lib_type_commune NUMBER(38,0),
    fid_nom NUMBER(38,0),
    fid_metadonnee NUMBER(38,0)    
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_commune IS 'Table rassemblant tous les contours communaux de la MEL et leur équivalent belge.';
COMMENT ON COLUMN g_geo.ta_commune.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_commune.geom IS 'Géométrie de chaque commune ou équivalent international.';
COMMENT ON COLUMN g_geo.ta_commune.fid_lib_type_commune IS 'Clé étrangère permettant de connaître le statut de la commune ou équivalent international - ta_libelle.';
COMMENT ON COLUMN g_geo.ta_commune.fid_nom IS 'Clé étrangère de la table TA_NOM permettant de connaître le nom de chaque commune ou équivalent international.';
COMMENT ON COLUMN g_geo.ta_commune.fid_metadonnee IS 'Clé étrangère permettant de retrouver la source à partir de laquelle la donnée est issue - ta_source.';


-- 3. Création de la clé primaire
ALTER TABLE ta_commune 
ADD CONSTRAINT ta_commune_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_commune',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX ta_commune_SIDX
ON ta_commune(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 6. Création des clés étrangères
ALTER TABLE ta_commune
ADD CONSTRAINT ta_commune_fid_lib_type_commune_FK 
FOREIGN KEY (fid_lib_type_commune)
REFERENCES ta_libelle(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_commune
ADD CONSTRAINT ta_commune_fid_nom_FK 
FOREIGN KEY (fid_nom)
REFERENCES ta_nom(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_commune
ADD CONSTRAINT ta_commune_fid_metadonnee_FK 
FOREIGN KEY (fid_metadonnee)
REFERENCES ta_metadonnee(objectid)INITIALLY IMMEDIATE DEFERRABLE;

-- 7. Création des index sur les clés étrangères
CREATE INDEX ta_commune_fid_lib_type_commune_IDX ON ta_commune(fid_lib_type_commune)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_commune_fid_nom_IDX ON ta_commune(fid_nom)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_commune_fid_metadonnee_IDX ON ta_commune(fid_metadonnee)
    TABLESPACE G_ADT_INDX;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_commune TO G_ADMIN_SIG;

/*
La table TA_IDENTIFIANT_COMMUNE permet de regrouper tous les codes par commune. 
*/

-- 1. Création de la table
CREATE TABLE ta_identifiant_commune(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
	fid_commune NUMBER(38,0),
	fid_identifiant NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_identifiant_commune IS 'La table permet de regrouper tous les codes par commune.';
COMMENT ON COLUMN g_geo.ta_identifiant_commune.objectid IS 'Clé primaire de la table.';
COMMENT ON COLUMN g_geo.ta_identifiant_commune.fid_commune IS 'Clé étrangère de la table TA_COMMUNE.';
COMMENT ON COLUMN g_geo.ta_identifiant_commune.fid_identifiant IS 'Clé étrangère de la table TA_CODE.';

-- 3. Création de la clé primaire
ALTER TABLE 
	TA_IDENTIFIANT_COMMUNE
ADD CONSTRAINT 
	TA_IDENTIFIANT_COMMUNE_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 6. Création des clés étrangères
ALTER TABLE ta_identifiant_commune
ADD CONSTRAINT ta_identifiant_commune_fid_commune_FK 
FOREIGN KEY (fid_commune)
REFERENCES ta_commune(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_identifiant_commune
ADD CONSTRAINT ta_identifiant_commune_fid_identifiant_FK 
FOREIGN KEY (fid_identifiant)
REFERENCES ta_code(objectid)INITIALLY IMMEDIATE DEFERRABLE;

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.TA_IDENTIFIANT_COMMUNE TO G_ADMIN_SIG;

/* 
La table TA_ZONE_ADMINISTRATIVE permet de recenser tous les noms des zones supra-communales.

*/
-- 1. Création de la table ta_zone_administrative
CREATE TABLE ta_zone_administrative(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_nom NUMBER(38,0),
    fid_libelle Number(38,0),
    fid_metadonnee NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_zone_administrative IS 'Table regroupant tous les noms des zones supra-communales.';
COMMENT ON COLUMN g_geo.ta_zone_administrative.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_zone_administrative.fid_nom IS 'Clé étrangère de la table TA_NOM permettant de connaître le nom de la zone supra-communale.';
COMMENT ON COLUMN g_geo.ta_zone_administrative.fid_libelle IS 'Clé étrangère de la table TA_LIBELLE permettant de catégoriser les zones administratives.';
COMMENT ON COLUMN g_geo.ta_zone_administrative.fid_metadonnee IS 'Clé étrangère de la table TA_METADONNEE.';


-- 3. Création de la clé primaire
ALTER TABLE ta_zone_administrative 
ADD CONSTRAINT ta_zone_administrative_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE ta_zone_administrative
ADD CONSTRAINT ta_zone_administrative_fid_nom_FK
FOREIGN KEY (fid_nom)
REFERENCES ta_nom(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_zone_administrative
ADD CONSTRAINT ta_zone_administrative_fid_libelle_FK
FOREIGN KEY (fid_libelle)
REFERENCES ta_libelle(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_zone_administrative
ADD CONSTRAINT ta_zone_administrative_fid_metadonnee_FK
FOREIGN KEY (fid_metadonnee)
REFERENCES ta_metadonnee(objectid)INITIALLY IMMEDIATE DEFERRABLE;

-- 5. Création des index sur les clés étrangères
CREATE INDEX ta_zone_administrative_fid_nom_IDX ON ta_zone_administrative(fid_nom)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_zone_administrative_fid_libelle_IDX ON ta_zone_administrative(fid_libelle)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_zone_administrative_fid_metadonnee_IDX ON ta_zone_administrative(fid_metadonnee)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_zone_administrative TO G_ADMIN_SIG;

/* 
La table TA_IDENTIFIANT_ZONE_ADMINISTRATIVE permet de lier les zones supra-communales avec leurs codes.

*/
-- 1. Création de la table ta_identifiant_zone_administrative
CREATE TABLE ta_identifiant_zone_administrative(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_zone_administrative Number(38,0),
    fid_identifiant NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_identifiant_zone_administrative IS 'Table permettant de lier les zones supra-communales avec leurs codes.';
COMMENT ON COLUMN g_geo.ta_identifiant_zone_administrative.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_identifiant_zone_administrative.fid_zone_administrative IS 'Clé étrangère de la table TA_ZONE_ADMINISTRATIVE.';
COMMENT ON COLUMN g_geo.ta_identifiant_zone_administrative.fid_identifiant IS 'Clé étrangère de la table TA_CODE.';


-- 3. Création de la clé primaire
ALTER TABLE ta_identifiant_zone_administrative 
ADD CONSTRAINT ta_identifiant_zone_administrative_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE ta_identifiant_zone_administrative
ADD CONSTRAINT ta_identifiant_zone_administrative_fid_zone_administrative_FK
FOREIGN KEY (fid_zone_administrative)
REFERENCES ta_zone_administrative(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_identifiant_zone_administrative
ADD CONSTRAINT ta_identifiant_zone_administrative_fid_identifiant_FK
FOREIGN KEY (fid_identifiant)
REFERENCES ta_code(objectid)INITIALLY IMMEDIATE DEFERRABLE;

-- 5. Création des index sur les clés étrangères
CREATE INDEX ta_identifiant_zone_administrative_fid_zone_administrative_IDX ON ta_identifiant_zone_administrative(fid_zone_administrative)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_identifiant_zone_administrative_fid_identifiant_IDX ON ta_identifiant_zone_administrative(fid_identifiant)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_identifiant_zone_administrative TO G_ADMIN_SIG;

/* 
La table ta_za_communes sert de table de liaison entre les tables ta_commune et ta_zone_administrative.
Fonction : savoir quelle commune appartient à quelle zone supra-communale.

*/
-- 1. Création de la table ta_za_communes
CREATE TABLE ta_za_communes(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_commune NUMBER(38,0),
    fid_zone_administrative NUMBER(38,0),
    debut_validite DATE,
    fin_validite DATE
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.ta_za_communes IS 'Table de liaison entre les tables ta_commune et ta_unite_territoriale';
COMMENT ON COLUMN g_geo.ta_za_communes.objectid IS 'Identifiant de chaque objet de la table.';
COMMENT ON COLUMN g_geo.ta_za_communes.fid_commune IS 'Clé étrangère de la table TA_COMMUNE.';
COMMENT ON COLUMN g_geo.ta_za_communes.fid_zone_administrative IS 'Clé étrangère de la table TA_ZONE_ADMINISTRATIVE.';
COMMENT ON COLUMN g_geo.ta_za_communes.debut_validite IS 'Début de validité de la zone supra-communale. Ce champ est mis à jour dés qu''une commune change.';
COMMENT ON COLUMN g_geo.ta_za_communes.fin_validite IS 'Fin de validité de la zone supra-communale. Ce champ est mis à jour dés qu''une commune change.';

-- 3. Création de la clé primaire
ALTER TABLE ta_za_communes 
ADD CONSTRAINT ta_za_communes_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 6. Création des clés étrangères

ALTER TABLE ta_za_communes
ADD CONSTRAINT ta_za_communes_fid_commune_FK
FOREIGN KEY (fid_commune)
REFERENCES ta_commune(objectid)INITIALLY IMMEDIATE DEFERRABLE;

ALTER TABLE ta_za_communes
ADD CONSTRAINT ta_za_communes_fid_zone_administrative_FK
FOREIGN KEY (fid_zone_administrative)
REFERENCES ta_zone_administrative(objectid)INITIALLY IMMEDIATE DEFERRABLE;

-- 7. Création des index sur les clés étrangères
CREATE INDEX ta_za_communes_fid_commune_IDX ON ta_za_communes(fid_commune)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_za_communes_fid_zone_administrative_IDX ON ta_za_communes(fid_zone_administrative)
    TABLESPACE G_ADT_INDX;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_za_communes TO G_ADMIN_SIG;

/*
Creation de la table TA_BPE qui recense les equipement de la Base Permanente des Equipements.
*/

-- 1. Création de la table
CREATE TABLE ta_bpe(
	objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
    fid_metadonnee NUMBER(38,0),
    geom MDSYS.SDO_GEOMETRY
	);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_bpe IS 'Table regroupant les equipements de la Base Permanente des Equipements';
COMMENT ON COLUMN g_geo.ta_bpe.objectid IS 'Clef primare de la table TA_BPE.';
COMMENT ON COLUMN g_geo.ta_bpe.fid_metadonnee IS 'Clef étrangère vers la table TA_METADONNEE';
COMMENT ON COLUMN g_geo.ta_bpe.geom IS 'Geometrie de la table';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_bpe
ADD CONSTRAINT 
	ta_bpe_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_bpe',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX ta_bpe_SIDX
ON ta_bpe(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_DATA, work_tablespace=DATA_TEMP');

--6 Création de la clef étrangère vers la table ta_metadonnée

ALTER TABLE ta_bpe
ADD
CONSTRAINT  "TA_METADONNE_OBJECTID_FK"
FOREIGN KEY
("FID_METADONNEE")
REFERENCES  "G_GEO"."TA_METADONNEE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;

-- 7. Création des index sur les cléfs étrangères.

CREATE INDEX ta_bpe_fid_metadonnee_IDX ON ta_bpe_relation_libelle(fid_libelle_fils)
    TABLESPACE G_ADT_INDX;

-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_bpe TO G_ADMIN_SIG;

/*
Creation de la table TA_BPE_CARACTERISTIQUE_NOMBRE pour faire la liaison entre un equipement de la BPE vers ses caractéristiques numerique.
*/

-- 1. Création de la table
CREATE TABLE ta_bpe_caracteristique_nombre(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    fid_bpe NUMBER(38,0),
    fid_libelle NUMBER(38,0),
    nombre NUMBER(38,0)
	);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_bpe_caracteristique_nombre IS 'Table de relation entre les equipements et les libelles ou l''information et sous la forme d''un nombre: exemple NB_SALLES: 4. L''équipement dispose de 4 salles';
COMMENT ON COLUMN g_geo.ta_bpe_caracteristique_nombre.objectid IS 'Clef primaire de la table TA_BPE_CARACTERISTIQUE_NOMBRE.';
COMMENT ON COLUMN g_geo.ta_bpe_caracteristique_nombre.fid_bpe IS 'Clef étrangère vers la table TA_BPE';
COMMENT ON COLUMN g_geo.ta_bpe_caracteristique_nombre.fid_libelle IS 'Clef étrangère vers la table TA_LIBELLE pour connaitre la caractéristique de l''équipement';
COMMENT ON COLUMN g_geo.ta_bpe_caracteristique_nombre.nombre IS 'nombre de salles de théatre par cinéma, théatre ou nombre d''aires de pratique d''un même type au sein de l''équipement';

--3. Création de la clef primaire
ALTER TABLE 
	ta_bpe_caracteristique_nombre
ADD CONSTRAINT 
	ta_bpe_caracteristique_nombre_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Création des clefs étrangères

-- clef étrangère vers la table TA_BPE
ALTER TABLE ta_bpe_caracteristique_nombre
ADD
CONSTRAINT  "TA_BPE_CARACTERISTIQUE_NOMBRE_TA_BPE_OBJECTID_FK"
FOREIGN KEY
("FID_BPE")
REFERENCES  "G_GEO"."TA_BPE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;

-- clef étrangère vers la table TA_LIBELLE pour connaitre la caractéristique de l'equipement
ALTER TABLE ta_bpe_caracteristique_nombre
ADD
CONSTRAINT  "TA_BPE_CARACTERISTIQUE_NOMBRE_TA_LIBELLE_OBJECTID_FK"
FOREIGN KEY
("FID_LIBELLE")
REFERENCES  "G_GEO"."TA_LIBELLE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;

-- 5. Création des index sur les clefs étrangères.

CREATE INDEX ta_bpe_caracteristique_nombre_fid_bpe_IDX ON ta_bpe_caracteristique_nombre(fid_bpe)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_bpe_caracteristique_nombre_fid_libelle_IDX ON ta_bpe_caracteristique_nombre(fid_libelle)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_bpe_caracteristique_nombre TO G_ADMIN_SIG;

/*
La table ta_bpe_relation_libelle sert à acceuillir les relations qui existent entre les libelles et des libelles court issus de la Base Permanente des Equipements.
Exemple A101/Police est un sous élément de A1/Services Publics.x/Sans Object peut être un sous élément de COUVERT/Equipement couvert ou non mais aussi de ECLAIRE/Equipement éclairé ou non.
*/

-- 1. Création de la table
CREATE TABLE ta_bpe_relation_libelle(
	fid_libelle_fils NUMBER(38,0),
	fid_libelle_parent NUMBER(38,0)
);

-- 2. Création des commentaires
COMMENT ON TABLE ta_bpe_relation_libelle IS 'Table qui sert à définir les relations entre les différents libelle de la nomenclature de la base permanente des equipements. Exemple A101/Police est un sous élément du libelle A1/Services Publics.x/Sans Object peut être un sous élément de COUVERT/Equipement couvert ou non mais aussi de ECLAIRE/Equipement éclairé ou non.';
COMMENT ON COLUMN ta_bpe_relation_libelle.fid_libelle_fils IS 'Composante de la clef primaire. Clef étrangère vers la table TA_LIBELLE pour connaitre le libelle fils.';
COMMENT ON COLUMN ta_bpe_relation_libelle.fid_libelle_parent IS 'Composante de la clef primaire. Clef étrangère vers la table TA_LIBELLE pour connaitre le libelle parent.';

-- 3. Création de la clé primaire composée.
ALTER TABLE 
	ta_bpe_relation_libelle
ADD CONSTRAINT 
	ta_bpe_relation_libelle_PK 
PRIMARY KEY("FID_LIBELLE_FILS","FID_LIBELLE_PARENT")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Création des clefs etrangères

ALTER TABLE ta_bpe_relation_libelle
ADD
CONSTRAINT  "TA_LIBELLE_OBJECTID_FID_LIBELLE_FILS_FK"
FOREIGN KEY
("FID_LIBELLE_FILS")
REFERENCES  "G_GEO"."TA_LIBELLE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;


ALTER TABLE ta_bpe_relation_libelle
ADD
CONSTRAINT  "TA_LIBELLE_OBJECTID_FID_LIBELLE_PARENT_FK"
FOREIGN KEY
("FID_LIBELLE_PARENT")
REFERENCES  "G_GEO"."TA_LIBELLE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;

-- 5. Création des index sur les cléfs étrangères.

CREATE INDEX ta_bpe_relation_libelle_fid_relation_fils_IDX ON ta_bpe_relation_libelle(fid_libelle_fils)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_bpe_relation_libelle_fid_relation_parent_IDX ON ta_bpe_relation_libelle(fid_libelle_parent)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_bpe_relation_libelle TO G_ADMIN_SIG;

/*
Creation de la table TA_BPE_CARACTERISTIQUE pour faire la liaison entre un equipement de la BPE vers ses caractéristique.
*/

-- 1. Création de la table
CREATE TABLE ta_bpe_caracteristique(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
    fid_bpe NUMBER(38,0),
    fid_libelle_fils NUMBER(38,0),
    fid_libelle_parent NUMBER(38,0)
	);

-- 2. Création des commentaires
COMMENT ON TABLE ta_bpe_caracteristique IS 'Table de relation entre les equipements et les libelles pour connaitre les caractéristiques des équipements';
COMMENT ON COLUMN ta_bpe_caracteristique.objectid IS 'Clef primare de la table TA_BPE_CARACTERISTIQUE.';
COMMENT ON COLUMN ta_bpe_caracteristique.fid_bpe IS 'Clef étrangère vers la table TA_BPE';
COMMENT ON COLUMN ta_bpe_caracteristique.fid_libelle_fils IS 'Clef étrangère vers la table TA_LIBELLE pour connaitre la caractéristique de l''equipement';
COMMENT ON COLUMN ta_bpe_caracteristique.fid_libelle_parent IS 'Clef étrangère vers la table TA_LIBELLE pour connaitre la caractéristique parent de l''equipement';

--3. Création de la clef primaire
ALTER TABLE 
	ta_bpe_caracteristique
ADD CONSTRAINT 
	ta_bpe_caracteristique_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Création des clefs etrangères

-- clef étrangère vers la table TA_BPE
ALTER TABLE ta_bpe_caracteristique
ADD
CONSTRAINT  "TA_BPE_OBJECTID_FK"
FOREIGN KEY
("FID_BPE")
REFERENCES  "G_GEO"."TA_BPE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;

-- clef étrangère vers la table TA_LIBELLE pour connaitre la caractéristique de l'equipement
ALTER TABLE ta_bpe_caracteristique
ADD
CONSTRAINT  "TA_LIBELLE_FILS_OBJECTID_FK"
FOREIGN KEY
("FID_LIBELLE_FILS")
REFERENCES  "G_GEO"."TA_LIBELLE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;

-- clef étrangère vers la table TA_LIBELLE pour connaitre le libelle parent de la caractéristique de l'equipement
ALTER TABLE ta_bpe_caracteristique
ADD
CONSTRAINT  "TA_LIBELLE_PARENT_OBJECTID_FK"
FOREIGN KEY
("FID_LIBELLE_PARENT")
REFERENCES  "G_GEO"."TA_LIBELLE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;

-- 5. Création des index sur les clefs étrangères.

CREATE INDEX ta_bpe_caracteristique_fid_bpe_IDX ON ta_bpe_caracteristique(fid_bpe)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_bpe_caracteristique_fid_libelle_fils_IDX ON ta_bpe_caracteristique(fid_libelle_fils)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_bpe_caracteristique_fid_libelle_parent_IDX ON ta_bpe_caracteristique(fid_libelle_parent)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_bpe_caracteristique TO G_ADMIN_SIG;

/*
La table ta_libelle_court sert à acceuillir les différentes modalites qui peuvent prendre les données issues de la Base Permanente des Equipement 
*/

-- 1. Création de la table
CREATE TABLE ta_libelle_court(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
	libelle_court VARCHAR2(255)
);

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_libelle_court IS 'Table regroupant les libelles court de la Base Permanente des Equipements. Par exemple A101 ou X.';
COMMENT ON COLUMN g_geo.ta_libelle_court.objectid IS 'Clef primaire de la table ta_libelle_court.';
COMMENT ON COLUMN g_geo.ta_libelle_court.libelle_court IS 'Valeur pouvant être prises par les variables exemple A101 ou 1 ou 0 ou x.';

-- 3. Création de la clé primaire
ALTER TABLE 
	ta_libelle_court
ADD CONSTRAINT 
	ta_libelle_court 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_libelle_court TO G_ADMIN_SIG;

/*
Creation de la table ta_correspondance_libelle
Cette table sert à faire la correspondance entre les libelles longs et les libelles courts.
*/

-- 1. Création de la table

CREATE TABLE ta_correspondance_libelle(
  objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
  fid_libelle NUMBER(38,0), 
  fid_libelle_court NUMBER(38,0)
  )

-- 2. Création des commentaires
COMMENT ON TABLE g_geo.ta_correspondance_libelle  IS 'Table indiquant les correspondances entre les libelles et les libelles court issus de la Base Permanente des Equipements. Exemple Police = A10 ou Sans objet = x';
COMMENT ON COLUMN g_geo.ta_correspondance_libelle.objectid IS 'Clef primaire de la table ta_correspondance_libelle.';
COMMENT ON COLUMN g_geo.ta_correspondance_libelle.fid_libelle IS 'Clef etrangere vers la table TA_LIBELLE';
COMMENT ON COLUMN g_geo.ta_correspondance_libelle.fid_libelle_court IS 'Clef etrangere vers la table TA_LIBELLE_COURT pour connaitre les libelles courts des libelles. Exemple Police = A10 ou Sans objet  = x';

-- 3. Création de la clef primaire

ALTER TABLE 
  ta_correspondance_libelle
ADD CONSTRAINT 
  ta_correspondance_libelle_PK 
PRIMARY KEY("OBJECTID")
USING INDEX
TABLESPACE "G_ADT_INDX";

-- 4. Création des clefs étrangères

-- clef étrangère vers la table TA_LIBELLE pour connaitre le libelle
ALTER TABLE ta_correspondance_libelle
ADD
CONSTRAINT  "TA_CORRESPONDANCE_FID_LIBELLE_FK"
FOREIGN KEY
("FID_LIBELLE")
REFERENCES  "G_GEO"."TA_LIBELLE" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;

-- clef étrangère vers la table ta_libelle_court pour connaitre le libelle court
ALTER TABLE ta_correspondance_libelle
ADD
CONSTRAINT "TA_CORRESPONDANCE_FID_LIBELLE_COURT_FK"
FOREIGN KEY
("FID_LIBELLE_COURT")
REFERENCES "G_GEO"."TA_LIBELLE_COURT" ("OBJECTID")INITIALLY IMMEDIATE DEFERRABLE;


--5. Creation des index

CREATE INDEX ta_correspondance_libelle_fid_libelle_IDX ON ta_correspondance_libelle(fid_libelle)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_correspondance_libelle_fid_libelle_court_IDX ON ta_correspondance_libelle(fid_libelle_court)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_correspondance_libelle TO G_ADMIN_SIG;
