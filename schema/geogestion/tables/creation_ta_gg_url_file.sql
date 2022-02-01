/*
TA_GG_URL_FILE : Création de la table TA_GG_URL_FILE permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_URL_FILE (
    "OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_URL_FILE_OBJECTID.NEXTVAL NOT NULL,
    "FID_DOSSIER" NUMBER(38,0),
    "DOS_URL_FILE" VARCHAR2(250) NOT NULL,
    "INTEGRATION" NUMBER(1,0) NULL
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_URL_FILE IS 'Table permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.OBJECTID IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque URL.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.FID_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un l''URL de fichier (exemple : dwg, pdf, etc) à un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.DOS_URL_FILE IS 'URL de chaque fichier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_URL_FILE.INTEGRATION IS 'Champ permettant de savoir si le fichier a été utilisé lors de l''intégration du fichier dwg par FME pour déterminer le périmètre du dossier. : 1 = oui ; 0 = non.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_URL_FILE
ADD CONSTRAINT TA_GG_URL_FILE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_URL_FILE
ADD CONSTRAINT TA_GG_URL_FILE_FID_DOSSIER_FK
FOREIGN KEY("FID_DOSSIER")
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER ("OBJECTID");

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_URL_FILE_FID_DOSSIER_IDX" ON G_GESTIONGEO.TA_GG_URL_FILE ("FID_DOSSIER") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_URL_FILE_DOS_URL_FILE_IDX" ON G_GESTIONGEO.TA_GG_URL_FILE ("DOS_URL_FILE") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_URL_FILE_INTEGRATION_IDX" ON G_GESTIONGEO.TA_GG_URL_FILE ("INTEGRATION") 
    TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_URL_FILE TO G_ADMIN_SIG;

/
