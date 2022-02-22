/*
TA_GG_FICHIER : Création de la table TA_GG_FICHIER permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_FICHIER (
    "OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_FICHIER_OBJECTID.NEXTVAL NOT NULL,
    "FID_DOSSIER" NUMBER(38,0),
    "FICHIER" VARCHAR2(250) NOT NULL,
    "INTEGRATION" NUMBER(1,0) NULL
);


COMMENT ON TABLE G_GESTIONGEO.TA_GG_FICHIER IS 'Table permettant de lister tous les fichiers correspondant à un dossier (dwg, pdf, etc).';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FICHIER.OBJECTID IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque URL.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FICHIER.FID_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un l''URL de fichier (exemple : dwg, pdf, etc) à un dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FICHIER.FICHIER IS 'Nom de chaque fichier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FICHIER.INTEGRATION IS 'Champ permettant de savoir si le fichier a été utilisé lors de l''intégration du fichier dwg par FME pour déterminer le périmètre du dossier. : 1 = oui ; 0 = non.';


-- 3. Les contraintes
-- 3.1. Contrainte de clé primaire
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FICHIER
ADD CONSTRAINT TA_GG_FICHIER_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;


-- 3.2. Contraintes de clé étrangère
-- vers la table TA_GG_DOSSIER
-- Contraintes de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_FICHIER
ADD CONSTRAINT TA_GG_FICHIER_FID_DOSSIER_FK
FOREIGN KEY("FID_DOSSIER")
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER ("OBJECTID");


-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_FICHIER_FID_DOSSIER_IDX" ON G_GESTIONGEO.TA_GG_FICHIER ("FID_DOSSIER") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_FICHIER_FICHIER_IDX" ON G_GESTIONGEO.TA_GG_FICHIER ("FICHIER") 
    TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_FICHIER_INTEGRATION_IDX" ON G_GESTIONGEO.TA_GG_FICHIER ("INTEGRATION") 
    TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FICHIER TO G_ADMIN_SIG;
GRANT SELECT ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_R;
GRANT SELECT, INSERT, UPDATE, DELETE ON G_GESTIONGEO.TA_GG_FICHIER TO G_GESTIONGEO_RW;

/
