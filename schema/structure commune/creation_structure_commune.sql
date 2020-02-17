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

/*-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_famille TO G_ADT_DSIG_ADM;*/

/*
La table ta_libelle regroupe tous les états ou actions regroupés dans une famille elle-même située dans la tabe ta_famille.

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

/*-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_libelle TO G_ADT_DSIG_ADM;*/

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
	ta_libelle(objectid);

-- 5. Création de l'index de la clé étrangère
CREATE INDEX ta_famille_libelle_fid_famille_IDX ON ta_famille_libelle(fid_famille)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_famille_libelle_fid_libelle_IDX ON ta_famille_libelle(fid_libelle)
TABLESPACE G_ADT_INDX;

/*-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_famille_libelle TO G_ADT_DSIG_ADM;*/

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
REFERENCES ta_libelle(objectid);

-- 5. Création de l'index de la clé étrangère
CREATE INDEX ta_code_fid_libelle_IDX ON ta_code(fid_libelle)
TABLESPACE G_ADT_INDX;

/*-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_code TO G_ADT_DSIG_ADM;*/

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

/*-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_organisme TO G_ADT_DSIG_ADM;*/

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
/*-- 5. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_date_acquisition TO G_ADT_DSIG_ADM;*/

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

/*-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_source TO G_ADT_DSIG_ADM;*/

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

/*-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.provenance TO G_ADT_DSIG_ADM;*/

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

/*-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_echelle TO G_ADT_DSIG_ADM;*/

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
REFERENCES ta_source(objectid);

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_acquisition_FK
FOREIGN KEY (fid_acquisition)
REFERENCES ta_date_acquisition(objectid);

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_provenance_FK
FOREIGN KEY (fid_provenance)
REFERENCES ta_provenance(objectid);

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_organisme_FK
FOREIGN KEY (fid_organisme)
REFERENCES ta_organisme(objectid);

ALTER TABLE ta_metadonnee
ADD CONSTRAINT ta_metadonnee_fid_echelle_FK
FOREIGN KEY (fid_echelle)
REFERENCES ta_echelle(objectid);

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


/*-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_metadonnee TO G_ADT_DSIG_ADM;*/

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

/*-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_nom TO G_ADT_DSIG_ADM;*/

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
REFERENCES ta_libelle(objectid);

ALTER TABLE ta_commune
ADD CONSTRAINT ta_commune_fid_nom_FK 
FOREIGN KEY (fid_nom)
REFERENCES ta_nom(objectid);

ALTER TABLE ta_commune
ADD CONSTRAINT ta_commune_fid_metadonnee_FK 
FOREIGN KEY (fid_metadonnee)
REFERENCES ta_metadonnee(objectid);

-- 7. Création des index sur les clés étrangères
CREATE INDEX ta_commune_fid_lib_type_commune_IDX ON ta_commune(fid_lib_type_commune)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_commune_fid_nom_IDX ON ta_commune(fid_nom)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_commune_fid_metadonnee_IDX ON ta_commune(fid_metadonnee)
    TABLESPACE G_ADT_INDX;



/*-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_commune TO G_ADT_DSIG_ADM;*/

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
REFERENCES ta_commune(objectid);

ALTER TABLE ta_identifiant_commune
ADD CONSTRAINT ta_identifiant_commune_fid_identifiant_FK 
FOREIGN KEY (fid_identifiant)
REFERENCES ta_code(objectid);

/*-- 4. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.TA_IDENTIFIANT_COMMUNE TO G_ADT_DSIG_ADM;*/

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
REFERENCES ta_nom(objectid);

ALTER TABLE ta_zone_administrative
ADD CONSTRAINT ta_zone_administrative_fid_libelle_FK
FOREIGN KEY (fid_libelle)
REFERENCES ta_libelle(objectid);

ALTER TABLE ta_zone_administrative
ADD CONSTRAINT ta_zone_administrative_fid_metadonnee_FK
FOREIGN KEY (fid_metadonnee)
REFERENCES ta_metadonnee(objectid);

-- 5. Création des index sur les clés étrangères
CREATE INDEX ta_zone_administrative_fid_nom_IDX ON ta_zone_administrative(fid_nom)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_zone_administrative_fid_libelle_IDX ON ta_zone_administrative(fid_libelle)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_zone_administrative_fid_metadonnee_IDX ON ta_zone_administrative(fid_metadonnee)
    TABLESPACE G_ADT_INDX;

/*-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_zone_administrative TO G_ADT_DSIG_ADM;*/

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
REFERENCES ta_zone_administrative(objectid);

ALTER TABLE ta_identifiant_zone_administrative
ADD CONSTRAINT ta_identifiant_zone_administrative_fid_identifiant_FK
FOREIGN KEY (fid_identifiant)
REFERENCES ta_code(objectid);

-- 5. Création des index sur les clés étrangères
CREATE INDEX ta_identifiant_zone_administrative_fid_zone_administrative_IDX ON ta_identifiant_zone_administrative(fid_zone_administrative)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_identifiant_zone_administrative_fid_identifiant_IDX ON ta_identifiant_zone_administrative(fid_identifiant)
    TABLESPACE G_ADT_INDX;

/*-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_identifiant_zone_administrative TO G_ADT_DSIG_ADM;*/

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
REFERENCES ta_commune(objectid);

ALTER TABLE ta_za_communes
ADD CONSTRAINT ta_za_communes_fid_zone_administrative_FK
FOREIGN KEY (fid_zone_administrative)
REFERENCES ta_zone_administrative(objectid);

-- 7. Création des index sur les clés étrangères
CREATE INDEX ta_za_communes_fid_commune_IDX ON ta_za_communes(fid_commune)
    TABLESPACE G_ADT_INDX;

CREATE INDEX ta_za_communes_fid_zone_administrative_IDX ON ta_za_communes(fid_zone_administrative)
    TABLESPACE G_ADT_INDX;

/*-- 8. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON g_geo.ta_za_communes TO G_ADT_DSIG_ADM;*/