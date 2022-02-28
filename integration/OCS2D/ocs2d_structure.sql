-- Creation de la structure pour les données OCS2D

-- 1. Création de la table TA_OCS2D_GEOM
-- 1.1. La table TA_OCSD_GEOM sert à acceuillir la géométrie des polygones OCS2D.
CREATE TABLE TA_OCS2D_GEOM(
    objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
    geom SDO_GEOMETRY
    );

-- 1.2. Création des commentaires des colonnes
COMMENT ON TABLE TA_OCS2D_GEOM IS 'Table regroupant les zones IRIS';
COMMENT ON COLUMN TA_OCS2D_GEOM.objectid IS 'Clé primaire de la table TA_OCS2D_GEOM.';
COMMENT ON COLUMN TA_OCS2D_GEOM.geom IS 'Géométrie des zones OCS2D.';

-- 1.3. Création de la clé primaire
ALTER TABLE 
    TA_OCS2D_GEOM
    ADD CONSTRAINT TA_OCS2D_GEOM_PK 
    PRIMARY KEY("OBJECTID")
    USING INDEX TABLESPACE "G_ADT_INDX";

-- 1.4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_OCS2D_GEOM',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.001),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.001)), 
    2154
);

-- 1.5. Création de l'index spatial sur le champ geom
CREATE INDEX TA_OCS2D_GEOM_SIDX
ON TA_OCS2D_GEOM(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 2. Création de la table TA_OCS2D
-- 2.1. La table TA_OCS2D sert à acceuillir les informations provenant des données OCS2D
CREATE TABLE G_OCS2D.TA_OCS2D(
	objectid NUMBER(38,0) DEFAULT SEQ_TA_OCS2D_OBJECTID.NEXTVAL NOT NULL,
    fid_ocs2d_geom NUMBER(38,0)
);


-- 2.2. Création des commentaires
COMMENT ON TABLE G_OCS2D.TA_OCS2D IS 'Table qui contient les identifiants des elements OCS2D';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D.objectid IS 'Clé primaire de la table TA_OCS2D, identifiant des elements OCS2D';
COMMENT ON COLUMN TA_OCS2D.fid_ocs2d_geom IS 'Clé étrangère vers la table TA_OCS2D_GEOM pour connaitre la geométrie d''un élément OCS2D.';


-- 2.3. Création de la clé primaire
ALTER TABLE 
	G_OCS2D.TA_OCS2D
	ADD CONSTRAINT TA_OCS2D_PK 
	PRIMARY KEY("OBJECTID")
	USING INDEX
	TABLESPACE "G_ADT_INDX";


-- 2.4.1. vers la table ta_ocs2d_source
ALTER TABLE TA_OCS2D
    ADD CONSTRAINT TA_OCS2D_FID_OCS2D_GEOM_FK
    FOREIGN KEY (fid_ocs2d_geom)
    REFERENCES G_OCS2D.TA_OCS2D_GEOM(objectid);


-- 3. Creation de la table TA_OCS2D_MILLESIME
-- 3.1. Table qui sert à associé un élément OCS2D à son millesime
CREATE TABLE G_OCS2D.TA_OCS2D_MILLESIME(
    objectid NUMBER(38,0) DEFAULT SEQ_TA_OCS2D_MILLESIME_OBJECTID.NEXTVAL NOT NULL,
    fid_ocs2d NUMBER(38,0),
    fid_metadonnee NUMBER(38,0)
);

-- 3.2. Création des commentaires
COMMENT ON TABLE G_OCS2D.TA_OCS2D_MILLESIME IS 'Table qui met en relation les éléments OCS2D avec ses metadonnees.';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_MILLESIME.objectid IS 'Clé primaire de la table TA_OCS2D_MILLESIME';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_MILLESIME.fid_ocs2d IS 'Clé étrangère vers la G_OCS2D.TA_OCS2D';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_MILLESIME.fid_metadonnee IS 'Clé étrangère vers la table G_GEO.TA_METADONNEE';

-- 3.3. Création de la clé primaire
ALTER TABLE 
    G_OCS2D.TA_OCS2D_MILLESIME
    ADD CONSTRAINT TA_OCS2D_MILLESIME_PK 
    PRIMARY KEY("OBJECTID")
    USING INDEX
    TABLESPACE "G_ADT_INDX";

-- 3.4. création de la clé étrangère vers la table ta_metadonnee pour connaitre les métadonnees des éléments OCS2D
-- 3.4.1. Clé étrangère vers la table G_GEO.TA_OCS2D
ALTER TABLE G_OCS2D.TA_OCS2D_MILLESIME
    ADD CONSTRAINT TA_OCS2D_MILLESIME_FID_OCS2D_FK
    FOREIGN KEY (fid_ocs2d)
    REFERENCES G_OCS2D.TA_OCS2D(objectid);

-- 3.4.2. Clé étrangère vers la table G_GEO.TA_METADONNEE
ALTER TABLE G_OCS2D.TA_OCS2D_MILLESIME
    ADD CONSTRAINT TA_OCS2D_MILLESIME_FID_METADONNEE_FK
    FOREIGN KEY (fid_metadonnee)
    REFERENCES G_GEO.TA_METADONNEE(objectid);

-- 3.5. Ajout d'une contrainte d'unicite sur les champs fid_ocs2d, fid_metadonnee.
-- un élement ne peut pas avoir deux fois les memes metadonnee
ALTER TABLE G_OCS2D.TA_OCS2D_MILLESIME
ADD CONSTRAINT TA_OCS2D_MILLESIME_FID_OCS2D_FID_METADONNEE_CH UNIQUE("FID_OCS2D","FID_METADONNEE");


-- 4. Creation de la table TA_OCS2D_RELATION_LIBELLE
-- 4.1. La table TA_OCS2D_RELATION_LIBELLE sert à acceuillir les informations permettant de joindre un élément OCS2D multidate à ses attributs
CREATE TABLE G_OCS2D.TA_OCS2D_RELATION_LIBELLE(
    objectid NUMBER(38,0) DEFAULT SEQ_TA_OCS2D_RELATION_LIBELLE_OBJECTID.NEXTVAL NOT NULL,
    fid_ocs2d_millesime NUMBER(38,0),
    fid_libelle NUMBER(38,0)
);

-- 4.2. Création des commentaires
COMMENT ON TABLE G_OCS2D.TA_OCS2D_RELATION_LIBELLE IS 'Table qui permet d''associer chaque element OCS2D à son code de couvert et d''usage du sol, ainsi qu''à son indice de photo-interpretation';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_RELATION_LIBELLE.objectid IS 'Clé primaire de la table TA_OCS2D_RELATION_LIBELLE';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_RELATION_LIBELLE.fid_ocs2d_millesime IS 'Clé étrangère vers la table TA_OCS2D_MILLESIME';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_RELATION_LIBELLE.fid_libelle IS 'Clé étrangère vers la table G_GEO.TA_LIBELLE';

-- 4.3. Création de la table TA_OCS2D_RELATION_LIBELLE
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_LIBELLE
    ADD CONSTRAINT TA_OCS2D_RELATION_LIBELLE_PK 
    PRIMARY KEY("OBJECTID")
    USING INDEX
    TABLESPACE "G_ADT_INDX";

-- 4.4. création de la clé étrangère vers la table ta_metadonnee pour connaitre les métadonnees des éléments OCS2D
-- 4.4.1. Clé étrangère vers la table G_GEO.TA_OCS2D
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_LIBELLE
    ADD CONSTRAINT TA_OCS2D_RELATION_LIBELLE_fid_ocs2d_MILLESIME_FK
    FOREIGN KEY (fid_ocs2d_millesime)
    REFERENCES G_OCS2D.TA_OCS2D_MILLESIME(objectid);

-- 4.4.1. Clé étrangère vers la table G_GEO.TA_METADONNEE
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_LIBELLE
    ADD CONSTRAINT TA_OCS2D_RELATION_LIBELLE_FID_LIBELLE_FK
    FOREIGN KEY (fid_libelle)
    REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 4.5. Création d'une contrainte d'unicite. Un element OCS2D à un millesime distingue ne peut pas avoir deux fois le meme fid_libelle
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_LIBELLE
ADD CONSTRAINT G_OCS2DTA_OCS2D_RELATION_LIBELLE_fid_ocs2d_MILLESIME_FID_LIBELLE_CH UNIQUE ("FID_OCS2D_MILLESIME","FID_LIBELLE");


-- 5. Création de la table TA_OCS2D_COMMENTAIRE
-- 5.1. Table TA_OCS2D_COMMENTAIRE pour acceuillir les commentaires que peuvent avoir les surfaces OCS2D
CREATE TABLE TA_OCS2D_COMMENTAIRE(
    objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
    valeur VARCHAR2(255)
);

-- 5.2. Création des commentaires
COMMENT ON TABLE TA_OCS2D_COMMENTAIRE IS 'Table contenant les commentaires que peuvent avoir les surfaces OCS2D';
COMMENT ON COLUMN ta_ocs2d_commentaire.objectid IS 'Clé primaire de la table';
COMMENT ON COLUMN ta_ocs2d_commentaire.valeur IS 'Valeur du commentaire';

-- 5.3. Création de la clé primaire
ALTER TABLE 
    ta_ocs2d_commentaire
    ADD CONSTRAINT ta_ocs2d_commentaire_PK 
    PRIMARY KEY("OBJECTID")
    USING INDEX TABLESPACE "G_ADT_INDX";


-- 6. Création de la table TA_OCS2D_RELATION_COMMENTAIRE
-- 6.1. La table TA_OCS2D_RELATION_COMMENTAIRE est une table qui relie les zones OCS2D avec les commentaires qu'elles peuvent avoir.
CREATE TABLE G_OCS2D.TA_OCS2D_RELATION_COMMENTAIRE(
	fid_ocs2d_millesime NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
	fid_ocs2d_commentaire NUMBER(38,0)
);

-- 6.2. Création des commentaires
COMMENT ON TABLE G_OCS2D.TA_OCS2D_RELATION_COMMENTAIRE IS 'Table permettant d''associer chaque element OCS2D à un millesime distingue à ses commentaires.';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_RELATION_COMMENTAIRE.fid_ocs2d_millesime IS 'Clé étrangère vers la table TA_OCS2D_MILLESIME.';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_RELATION_COMMENTAIRE.fid_ocs2d_commentaire IS 'Clé étrangère vers la table TA_OCS2D_COMMENTAIRE pour connaitre le commentaire de la zone OCS2D concernée.';

-- 6.3. Création de la clé primaire
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_COMMENTAIRE
	ADD CONSTRAINT TA_OCS2D_RELATION_COMMENTAIRE_PK 
	PRIMARY KEY(fid_ocs2d_millesime,fid_ocs2d_commentaire)
	USING INDEX TABLESPACE "G_ADT_INDX";

-- 6.4. Création des clé étrangère
-- 6.4.1. vers la table G_OCS2D.TA_OCS2D_RELATION_LIBELLE
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_COMMENTAIRE
	ADD CONSTRAINT TA_OCS2D_RELATION_COMMENTAIRE_fid_ocs2d_MILLESIME_FK
	FOREIGN KEY (fid_ocs2d_millesime)
	REFERENCES TA_OCS2D_MILLESIME(objectid);

-- 6.4.2. vers la table G_OCS2D.TA_OCS2D_COMMENTAIRE
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_COMMENTAIRE
	ADD CONSTRAINT TA_OCS2D_RELATION_COMMENTAIRE_FID_COCS2D_COMMENTAIRE_FK
	FOREIGN KEY (fid_ocs2d_commentaire)
	REFERENCES TA_OCS2D_COMMENTAIRE(objectid);


-- 7. Création de la table TA_OCS2D_SOURCE
-- 7.1. Table TA_OCS2D_SOURCE pour acceuillir les sources que peuvent avoir les surfaces OCS2D
CREATE TABLE TA_OCS2D_SOURCE(
    objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY START WITH 1 INCREMENT BY 1,
    valeur VARCHAR2(255)
);

-- 7.2. Création des commentaires
COMMENT ON TABLE TA_OCS2D_SOURCE IS 'Table contenant les sources que peuvent avoir les surfaces OCS2D';
COMMENT ON COLUMN ta_ocs2d_source.objectid IS 'Clé primaire de la table';
COMMENT ON COLUMN ta_ocs2d_source.valeur IS 'Valeur de la source';

-- 7.3. Création de la clé primaire
ALTER TABLE 
    ta_ocs2d_source
    ADD CONSTRAINT ta_ocs2d_source_PK 
    PRIMARY KEY("OBJECTID")
    USING INDEX TABLESPACE "G_ADT_INDX";


-- 8. Création de la table G_OCS2D.TA_OCS2D_RELATION_SOURCE
-- 8.1. La table TA_OCS2D_RELATION_SOURCE est une table qui relie les zones OCS2D avec les commentaires qu'elles peuvent avoir.
CREATE TABLE G_OCS2D.TA_OCS2D_RELATION_SOURCE(
	fid_ocs2d_millesime NUMBER(38,0),
	fid_ocs2d_source NUMBER(38,0)
);

-- 8.2. Création des commentaires
COMMENT ON TABLE G_OCS2D.TA_OCS2D_RELATION_SOURCE IS 'Table permettant d''associer chaque element OCS2D à un millesime distingue à ses sources.';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_RELATION_SOURCE.fid_ocs2d_millesime IS 'Clé étrangère vers la table TA_OCS2D_MILLESIME.';
COMMENT ON COLUMN G_OCS2D.TA_OCS2D_RELATION_SOURCE.fid_ocs2d_source IS 'Clé étrangère vers la table TA_OCS2D_SOURCE pour connaitre la source de la zone OCS2D concernée.';

-- 8.3. Création de la clé primaire
ALTER TABLE 
	G_OCS2D.TA_OCS2D_RELATION_SOURCE
	ADD CONSTRAINT TA_OCS2D_RELATION_SOURCE_PK 
	PRIMARY KEY(fid_ocs2d_millesime,fid_ocs2d_source)
	USING INDEX TABLESPACE "G_ADT_INDX";

-- 8.4. Création des clé étrangère
-- 8.4.1. vers la table TA_OCS2D
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_SOURCE
	ADD CONSTRAINT TA_OCS2D_RELATION_SOURCE_fid_ocs2d_MILLESIME_FK
	FOREIGN KEY (fid_ocs2d_millesime)
	REFERENCES G_OCS2D.TA_OCS2D_MILLESIME(objectid);

-- 8.4.2. vers la table ta_ocs2d_source
ALTER TABLE G_OCS2D.TA_OCS2D_RELATION_SOURCE
	ADD CONSTRAINT TA_OCS2D_RELATION_SOURCE_FID_COCS2D_SOURCE_FK
	FOREIGN KEY (fid_ocs2d_source)
	REFERENCES G_OCS2D.TA_OCS2D_SOURCE(objectid);