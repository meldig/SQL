/*
La table TA_GG_POINT_VIGILANCE_AUDIT permet d'évaluer les actions faites sur les objets contenus dans la table TA_GG_POINT_VIGILANCE.
*/
-- 1. Création de la table TA_GG_POINT_VIGILANCE_AUDIT ;
CREATE TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(
    objectid NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
    fid_point_vigilance NUMBER(38,0),
    pnom VARCHAR2(255 BYTE),
    fid_libelle NUMBER(38,0),
    date_action DATE
);

-- 2. Création des commentaires sur la table et les champs ;
COMMENT ON TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT IS 'La table TA_GG_POINT_VIGILANCE_AUDIT permet d''évaluer les actions faites sur les objets contenus dans la table TA_GG_POINT_VIGILANCE.' ;
COMMENT ON COLUMN G_GEO.TA_GG_POINT_VIGILANCE_AUDIT.objectid IS 'Clé primaire auto-incrémentée de la table.';
COMMENT ON COLUMN G_GEO.TA_GG_POINT_VIGILANCE_AUDIT.fid_point_vigilance IS 'Clé étrangère de la table TA_GG_POINT_VIGILANCE permettant d''associer un point de vigilance à une action.';
COMMENT ON COLUMN G_GEO.TA_GG_POINT_VIGILANCE_AUDIT.pnom IS 'Pnom de l''utilisateur ayant fait une action sur un point de vigilance.';
COMMENT ON COLUMN G_GEO.TA_GG_POINT_VIGILANCE_AUDIT.fid_libelle IS 'Clé étrangère de la table TA_LIBELLE permettant de catégoriser les action effectuées sur un point de vigilance : insertion, édition, suppression';
COMMENT ON COLUMN G_GEO.TA_GG_POINT_VIGILANCE_AUDIT.date_action IS 'Date à laquelle une action a été effectuée sur un point de vigilance.';

-- 3. Création de la clé primaire ;
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT 
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_PK 
PRIMARY KEY("OBJECTID") 
USING INDEX TABLESPACE "G_ADT_INDX";

-- 4. Création des clés étrangères ;
ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_POINT_VIGILANCE_FK 
FOREIGN KEY (FID_POINT_VIGILANCE)
REFERENCES G_GEO.TA_GG_POINT_VIGILANCE(objectid);

ALTER TABLE G_GEO.TA_GG_POINT_VIGILANCE_AUDIT
ADD CONSTRAINT TA_GG_POINT_VIGILANCE_AUDIT_FID_LIBELLE_FK 
FOREIGN KEY (FID_LIBELLE)
REFERENCES G_GEO.TA_LIBELLE(objectid);

-- 5. Création des indexes ;
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_POINT_VIGILANCE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(FID_POINT_VIGILANCE)
    TABLESPACE G_ADT_INDX;

CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_FID_LIBELLE_IDX ON G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(FID_LIBELLE)
    TABLESPACE G_ADT_INDX;
    
CREATE INDEX TA_GG_POINT_VIGILANCE_AUDIT_DATE_ACTION_IDX ON G_GEO.TA_GG_POINT_VIGILANCE_AUDIT(DATE_ACTION)
    TABLESPACE G_ADT_INDX;
