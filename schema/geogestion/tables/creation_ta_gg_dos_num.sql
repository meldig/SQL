/*
TA_GG_DOS_NUM : Création de la table TA_GG_DOS_NUM listant tous les DOS_NUM des dossiers créés dans GestionGeo. Cet identifiant de dossier est en cours d''abandon.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_DOS_NUM (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_DOS_NUM_OBJECTID.NEXTVAL NOT NULL,
	"FID_DOSSIER" NUMBER(38,0) NOT NULL,
	"DOS_NUM" NUMBER(38,0) NULL
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_DOS_NUM IS 'Table listant tous les DOS_NUM des dossiers créés dans GestionGeo. Cet identifiant de dossier est en cours d''abandon.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOS_NUM.OBJECTID IS 'Clé primaire de la table (identifiant unique) auto-incrémentée.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOS_NUM.FID_DOSSIER IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un DOS_NUM à son dossier.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_DOS_NUM.DOS_NUM IS 'Champ rempli par le trigger A_IXX_TA_GG_GEO. Le DOS_NUM est un identifiant de dossier historique conservé uniquement pour certains utilisateurs qui ont l''habitude de travailler avec. Il se compose des 2 derniers chiffres de l''année en cours, des 3 chiffres du code commune, de 5 chiffres représentant le nombre de dossiers créés + 1 durant l''année en cours.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_DOS_NUM
ADD CONSTRAINT TA_GG_DOS_NUM_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contrainte de clé étrangère
ALTER TABLE G_GESTIONGEO.TA_GG_DOS_NUM
ADD CONSTRAINT TA_GG_DOS_NUM_FID_DOSSIER_FK
FOREIGN KEY("FID_DOSSIER")
REFERENCES G_GESTIONGEO.TA_GG_DOSSIER("OBJECTID") ON DELETE CASCADE;

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_DOS_NUM_DOS_NUM_IDX" ON G_GESTIONGEO.TA_GG_DOS_NUM ("DOS_NUM") 
	TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_DOS_NUM_FID_DOSSIER_IDX" ON G_GESTIONGEO.TA_GG_DOS_NUM("FID_DOSSIER")
    TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_DOS_NUM TO G_ADMIN_SIG;

/
