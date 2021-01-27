/* 
Création des tables nécessaires aux points de vigilance.
1. TA_GG_POINT_VIGILANCE ;
    1.1. Création de la table TA_GG_POINT_VIGILANCE ;
    1.2. Création des commentaires sur la table et les champs ;
    1.3. Création de la clé primaire ;
    1.4. Création des métadonnées spatiales ;
    1.5. Création de l'index spatial sur le champ geom ;
    1.6. Création des clés étrangères ;
    1.7. Création des indexes sur les clés étrangères ;
2. TA_GG_POINT_VIGILANCE_AUDIT ;
    2.1. Création de la table TA_GG_POINT_VIGILANCE_AUDIT ;
    2.2. Création des commentaires sur la table et les champs ;
    2.3. Création de la clé primaire ;
    2.4. Création des clés étrangères ;
    2.5. Création des indexes ;
3. TEMP_POINT_VIGILANCE ;
*/

-- 1. TA_GG_POINT_VIGILANCE ;
-- La table TA_GG_POINT_VIGILANCE regroupe tous les points de vigilance utilisés dans GestionGeo.

-- 1.1. Création de la table TA_GG_POINT_VIGILANCE ;
CREATE TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_type_signalement NUMBER(38,0),
    fid_verification NUMBER(38,0),
    fid_lib_statut NUMBER(38,0),
    fid_libelle NUMBER(38,0),
    fid_type_point NUMBER(38,0),
    commentaire VARCHAR2(4000 BYTE),
    geom SDO_GEOMETRY  
);

-- 1.2. Création des commentaires sur la table et les champs ;
COMMENT ON TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE IS 'La table TA_GG_POINT_VIGILANCE permet d''indiquer un problème ou une interrogation sur une donnée (c-a-d un bâti ou une voirie) utilisée dans GestionGeo.' ;
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE.fid_type_signalement IS 'Clé étrangère vers la table TA_LIBELLE permettant d''indiquer le type de signalement du point : création, modification manuelle ou vérification';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE.fid_verification IS 'Clé étrangère vers la table TA_LIBELLE permettant de connaître la réponse envisagée au signalement fait lors de la création du point.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE.fid_lib_statut IS 'Clé étrangère vers la table TA_LIBELLE permettant de savoir si le point a été traité ou non.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE.fid_libelle IS 'Clé étrangère vers la table TA_LIBELLE permettant de connaître le type d''objet sur lequel porte le point de vigilance';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE.fid_type_point IS 'Champ permettant de différencier les points de vigilance des autres types de points utilisés dans gestion geo.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE.commentaire IS 'Champ dans lequel l''auteur/modificateur du point de vigilance peut inscrire l''interrogation qu''il avait lors de la création/modification du point ou écrire une question à destination de l''UF TOPO.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE.geom IS 'géométrie de chaque objet de type point';

-- 1.3. Création de la clé primaire ;
ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 1.4. Création des métadonnées spatiales ;
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TA_GG_POINT_VIGILANCE',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 1.5. Création de l'index spatial sur le champ geom ;
CREATE INDEX TA_GG_POINT_VIGILANCE_SIDX
ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 1.6. Création des clés étrangères ;
ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_LIBELLE_FK 
FOREIGN KEY (FID_LIBELLE)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_LIB_STATUT_FK 
FOREIGN KEY (FID_LIB_STATUT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_TYPE_SIGNALEMENT_FK 
FOREIGN KEY (FID_TYPE_SIGNALEMENT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_VERIFICATION_FK 
FOREIGN KEY (FID_VERIFICATION)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_TYPE_POINT_FK 
FOREIGN KEY (FID_TYPE_POINT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 1.7. Création des indexes sur les clés étrangères ;
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_LIBELLE_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE(FID_LIBELLE)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_LIB_STATUT_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE(FID_LIB_STATUT)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_FID_TYPE_SIGNALEMENT_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE(FID_TYPE_SIGNALEMENT)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_VERIFICATION_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE(FID_VERIFICATION)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_TYPE_POINT_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE(FID_TYPE_POINT)
    TABLESPACE G_ADT_INDX;

-- 3. TA_GG_POINT_VIGILANCE_AUDIT
-- La table TA_GG_POINT_VIGILANCE_AUDIT permet d'évaluer les actions faites sur les objets contenus dans la table TA_GG_POINT_VIGILANCE.

-- 3.1. Création de la table TA_GG_POINT_VIGILANCE_AUDIT ;
CREATE TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT(
    objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY,
    fid_point_vigilance NUMBER(38,0),
    date_creation DATE,
    fid_pnom_creation NUMBER(38,0),
    date_modification DATE,
    fid_pnom_modification NUMBER(38,0)
);

-- 3.2. Création des commentaires sur la table et les champs ;
OMMENT ON TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT IS 'La table TA_GG_POINT_VIGILANCE_AUDIT permet d''évaluer les actions faites sur les objets contenus dans la table TA_GG_POINT_VIGILANCE.' ;
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT.fid_point_vigilance IS 'Clé étrangère de la table TA_GG_POINT_VIGILANCE permettant d''associer un point de vigilance à une action.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT.date_creation IS 'Date de création du point de vigilance.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT.fid_pnom_creation IS 'Clé étrangère vers TA_GG_SOURCE permettant de récupérer le pnom de l''utilisateur ayant créé le point de vigilance.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT.date_modification IS 'Date de la dernière modification du point de vigilance.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT.fid_pnom_modification IS 'Clé étrangère vers TA_GG_SOURCE permettant de récupérer le pnom de l''utilisateur ayant modifié le point de vigilance.';

-- 3.3. Création de la clé primaire ;
ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 3.4. Création des clés étrangères ;
ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_POINT_VIGILANCE_FK 
FOREIGN KEY (FID_POINT_VIGILANCE)
REFERENCES G_GESTIONGEO.TA_GG_POINT_VIGILANCE(OBJECTID);

ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_PNOM_CREATION_FK 
FOREIGN KEY (FID_PNOM_CREATION)
REFERENCES G_GESTIONGEO.TA_GG_SOURCE(SRC_ID);

ALTER TABLE G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_PNOM_MODIFICATION_FK 
FOREIGN KEY (FID_PNOM_MODIFICATION)
REFERENCES G_GESTIONGEO.TA_GG_SOURCE(SRC_ID);

-- 3.5. Création des indexes ;
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_POINT_VIGILANCE_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT(FID_POINT_VIGILANCE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_PNOM_CREATION_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT(FID_PNOM_CREATION)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_PNOM_MODIFICATION_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT(FID_PNOM_MODIFICATION)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_DATE_CREATION_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT(DATE_CREATION)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_DATE_MODIFICATION_IDX ON G_GESTIONGEO.TA_GG_POINT_VIGILANCE_AUDIT(DATE_MODIFICATION)
    TABLESPACE G_ADT_INDX;
/
