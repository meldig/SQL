/*
La table TA_GG_POINT_VIGILANCE regroupe tous les points de vigilance utilisés dans GestionGeo.
*/

-- 1. Création de la table TA_GG_POINT_VIGILANCE
CREATE TABLE TA_GG_POINT_VIGILANCE(
    objectid NUMBER(38,0),
    fid_lib_categorie NUMBER(38,0),
    fid_type_signalement NUMBER(38,0),
    fid_verification NUMBER(38,0),
    fid_lib_statut NUMBER(38,0),
    fid_libelle NUMBER(38,0),
    fid_type_point NUMBER(38,0),
    commentaire VARCHAR2(4000 BYTE),
    geom SDO_GEOMETRY  
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.TA_GG_POINT_VIGILANCE IS 'La table TA_GG_POINT_VIGILANCE permet d''indiquer un problème ou une interrogation sur une donnée (c-a-d un bâti ou une voirie) utilisée dans GestionGeo.' ;
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_lib_categorie IS 'Clé étrangère vers la table TA_LIBELLE permettant de savoir si le point de vigilance doit être traité en priorité ou non.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_type_signalement IS 'Clé étrangère vers la table TA_LIBELLE permettant d''indiquer le type de signalement du point : création, modification manuelle ou vérification';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_verification IS 'Clé étrangère vers la table TA_LIBELLE permettant de connaître la réponse envisagée au signalement fait lors de la création du point.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_lib_statut IS 'Clé étrangère vers la table TA_LIBELLE permettant de savoir si le point a été traité ou non.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_libelle IS 'Clé étrangère vers la table TA_LIBELLE permettant de connaître le type d''objet sur lequel porte le point de vigilance';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.fid_type_point IS 'Champ permettant de différencier les points de vigilance des autres types de points utilisés dans gestion geo.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.commentaire IS 'Champ dans lequel l''auteur/modificateur du point de vigilance peut inscrire l''interrogation qu''il avait lors de la création/modification du point ou écrire une question à destination de l''UF TOPO.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE.geom IS 'géométrie de chaque objet de type point';

-- 3. Création de la clé primaire
ALTER TABLE TA_GG_POINT_VIGILANCE 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PK 
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
    'TA_GG_POINT_VIGILANCE',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 5. Création de l'index spatial sur le champ geom
CREATE INDEX TA_GG_POINT_VIGILANCE_SIDX
ON TA_GG_POINT_VIGILANCE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

-- 6. Création des clés étrangères
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_LIB_CATEGORIE_FK 
FOREIGN KEY (FID_LIB_CATEGORIE)
REFERENCES G_GEO.TA_LIBELLE(OBJECTID);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_LIBELLE_FK 
FOREIGN KEY (FID_LIBELLE)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_LIB_STATUT_FK 
FOREIGN KEY (FID_LIB_STATUT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_TYPE_SIGNALEMENT_FK 
FOREIGN KEY (FID_TYPE_SIGNALEMENT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_VERIFICATION_FK 
FOREIGN KEY (FID_VERIFICATION)
REFERENCES G_GEO.TA_LIBELLE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_FID_TYPE_POINT_FK 
FOREIGN KEY (FID_TYPE_POINT)
REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 7. Création des indexes sur les clés étrangères
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_LIB_CATEGORIE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_LIB_CATEGORIE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_FID_LIBELLE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_LIBELLE)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_LIB_STATUT_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_LIB_STATUT)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_FID_TYPE_SIGNALEMENT_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_TYPE_SIGNALEMENT)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_VERIFICATION_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_VERIFICATION)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_FID_TYPE_POINT_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_TYPE_POINT)
    TABLESPACE G_ADT_INDX;

--### Cette partie est temporaire le temps que tous les utilisateurs passent sur QGIS 3.12 et qu'on puisse utiliser le champ IDENTITY
-- 8. Création de la séquence d'autoincrémentation de la PK
CREATE SEQUENCE  G_GEO.SEQ_TA_GG_POINT_VIGILANCE 
INCREMENT BY 1 START WITH 1;

-- 9. Création du trigger d'incrémentation de la PK
CREATE OR REPLACE TRIGGER G_GEO.BEF_TA_GG_POINT_VIGILANCE
BEFORE INSERT ON G_GEO.TA_GG_POINT_VIGILANCE
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TA_GG_POINT_VIGILANCE.nextval;
END;
--###
/*
La table TA_GG_PERMIS_CONSTRUIRE permet de regrouper tous les numéros et dates de permis de construire récupéré et utilisé par lkes photo-interprètes via GestionGeo.
*/
-- 1. Création de la table TA_GG_PERMIS_CONSTRUIRE
CREATE TABLE G_GEO.TA_GG_PERMIS_CONSTRUIRE(
    objectid NUMBER(38,0), 
    numero VARCHAR2(100 BYTE) NOT NULL, 
    debut DATE NOT NULL, 
    fin DATE NOT NULL
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.TA_GG_PERMIS_CONSTRUIRE IS 'La table TA_GG_PERMIS_CONSTRUIRE permet de regrouper tous les numéros et dates de permis de construire récupéré et utilisé par lkes photo-interprètes via GestionGeo.' ;
COMMENT ON COLUMN g_geo.TA_GG_PERMIS_CONSTRUIRE.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN g_geo.TA_GG_PERMIS_CONSTRUIRE.numero IS 'Numéro du permis de construire.';
COMMENT ON COLUMN g_geo.TA_GG_PERMIS_CONSTRUIRE.debut IS 'Date de début de validité du permis de contruire';
COMMENT ON COLUMN g_geo.TA_GG_PERMIS_CONSTRUIRE.fin IS 'Date de fin de validité du permis de construire';

-- 3. Création de la clé primaire
ALTER TABLE TA_GG_PERMIS_CONSTRUIRE 
ADD CONSTRAINT TA_GG_PERMIS_CONSTRUIRE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des indexes
CREATE INDEX TA_GG_PERMIS_CONSTRUIRE_NUMERO_IDX ON G_GEO.TA_GG_PERMIS_CONSTRUIRE(NUMERO)
    TABLESPACE G_ADT_INDX;

--### Cette partie est temporaire le temps que tous les utilisateurs passent sur QGIS 3.12 et qu'on puisse utiliser le champ IDENTITY
-- 5. Création de la séquence d'autoincrémentation de la PK
CREATE SEQUENCE  G_GEO.SEQ_TA_GG_PERMIS_CONSTRUIRE
INCREMENT BY 1 START WITH 1;

-- 6. Création du trigger d'incrémentation de la PK
CREATE OR REPLACE TRIGGER G_GEO.BEF_TA_GG_PERMIS_CONSTRUIRE
BEFORE INSERT ON G_GEO.TA_GG_PERMIS_CONSTRUIRE
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TA_GG_PERMIS_CONSTRUIRE.nextval;
END;
--###

/*
La table TA_GG_POINT_VIGILANCE_AUDIT permet d'évaluer les actions faites sur les objets contenus dans la table TA_GG_POINT_VIGILANCE.
*/
-- 1. Création de la table TA_GG_POINT_VIGILANCE_AUDIT
CREATE TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(
    objectid NUMBER(38,0),
    fid_point_vigilance NUMBER(38,0),
    pnom VARCHAR2(255 BYTE),
    fid_libelle NUMBER(38,0),
    date_action DATE
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.TA_GG_POINT_VIGILANCE_AUDIT IS 'La table TA_GG_POINT_VIGILANCE_AUDIT permet d''évaluer les actions faites sur les objets contenus dans la table TA_GG_POINT_VIGILANCE.' ;
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.fid_point_vigilance IS 'Clé étrangère de la table TA_GG_POINT_VIGILANCE permettant d''associer un point de vigilance à une action.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.pnom IS 'Pnom de l''utilisateur ayant fait une action sur un point de vigilance.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.fid_libelle IS 'Clé étrangère de la table TA_LIBELLE permettant de catégoriser les action effectuées sur un point de vigilance : insertion, édition, suppression';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_AUDIT.date_action IS 'Date à laquelle une action a été effectuée sur un point de vigilance.';

-- 3. Création de la clé primaire
ALTER TABLE TA_GG_POINT_VIGILANCE_AUDIT 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_POINT_VIGILANCE_FK 
FOREIGN KEY (FID_POINT_VIGILANCE)
REFERENCES G_GEO.TA_GG_POINT_VIGILANCE(OBJECTID);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_LIBELLE_FK 
FOREIGN KEY (FID_LIBELLE)
REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 5. Création des indexes
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_POINT_VIGILANCE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_POINT_VIGILANCE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_LIBELLE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_LIBELLE)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_DATE_ACTION_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(DATE_ACTION)
    TABLESPACE G_ADT_INDX;

--### Cette partie est temporaire le temps que tous les utilisateurs passent sur QGIS 3.12 et qu'on puisse utiliser le champ IDENTITY
-- 6. Création de la séquence d'autoincrémentation de la PK
CREATE SEQUENCE  G_GEO.SEQ_TA_GG_POINT_VIGILANCE_AUDIT
INCREMENT BY 1 START WITH 1;

-- 7. Création du trigger d'incrémentation de la PK
CREATE OR REPLACE TRIGGER G_GEO.BEF_TA_GG_POINT_VIGILANCE_AUDIT
BEFORE INSERT ON G_GEO.TA_GG_POINT_VIGILANCE_AUDIT
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TA_GG_POINT_VIGILANCE_AUDIT.nextval;
END;
--###

/*
La table TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE est une table pivot permettant d'associer les points de vigilance aux permis de construire
*/
-- 1. Création de la table TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
CREATE TABLE G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE(
    objectid NUMBER(38,0),
    fid_point_vigilance NUMBER(38,0),
    fid_permis_construire NUMBER(38,0)
);

-- 2. Création des commentaires sur la table et les champs
COMMENT ON TABLE g_geo.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE IS 'La table TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE est une table pivot permettant d''associer les points de vigilance aux permis de construire.' ;
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE.fid_point_vigilance IS 'Clé étrangère de la table TA_GG_POINT_VIGILANCE permettant d''associer un point de vigilance à un permis de construire.';
COMMENT ON COLUMN g_geo.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE.fid_permis_construire IS 'Clé étrangère de la table TA_GG_PERMIS_CONSTRUIRE permettant d''associer un permis de construire à un point de vigilance.';

-- 3. Création de la clé primaire
ALTER TABLE TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_FID_POINT_VIGILANCE_FK 
FOREIGN KEY (FID_POINT_VIGILANCE)
REFERENCES G_GEO.TA_GG_POINT_VIGILANCE(OBJECTID);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_FID_PERMIS_CONSTRUIRE_FK 
FOREIGN KEY (FID_PERMIS_CONSTRUIRE)
REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 5. Création des indexes
CREATE INDEX TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_FID_POINT_VIGILANCE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE(FID_POINT_VIGILANCE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE_FID_PERMIS_CONSTRUIRE_IDX ON G_GEO.TA_GG_PERMIS_CONSTRUIRE(FID_PERMIS_CONSTRUIRE)
    TABLESPACE G_ADT_INDX;

--### Cette partie est temporaire le temps que tous les utilisateurs passent sur QGIS 3.12 et qu'on puisse utiliser le champ IDENTITY
-- 6. Création de la séquence d'autoincrémentation de la PK
CREATE SEQUENCE  G_GEO.SEQ_TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
INCREMENT BY 1 START WITH 1;

-- 7. Création du trigger d'incrémentation de la PK
CREATE OR REPLACE TRIGGER G_GEO.BEF_TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
BEFORE INSERT ON G_GEO.TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE
FOR EACH ROW
BEGIN
    :new.objectid := SEQ_TA_GG_POINT_VIGILANCE_PERMIS_CONSTRUIRE.nextval;
END;
--###