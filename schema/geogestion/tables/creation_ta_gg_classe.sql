/*
TA_GG_CLASSE : Création de la table TA_GG_CLASSE dans laquelle sont recensés les états de tous les objets saisis par les géomètres (plan topo fin) et les photo-interprètes (plan de gestion).
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_CLASSE (
	"OBJECTID" NUMBER(38,0) DEFAULT SEQ_TA_GG_CLASSE_OBJECTID.NEXTVAL NOT NULL,
	--"FID_FAMILLE" NUMBER(38,0) NOT NULL,
	"LIBELLE_COURT" VARCHAR2(6 BYTE) NULL,
	"LIBELLE_LONG" VARCHAR2(1000 BYTE) NULL,
	"VALIDITE" NUMBER(38,0) NOT NULL
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_CLASSE IS 'Table recensant tous les états des objets du plan de gestion et du plan topo fin.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.OBJECTID IS 'Clé primaire auto-incrémentée de la table.';
--COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.FID_FAMILLE IS 'Clé étrangère vers la table TA_GG_FAMILLE, permettant d''associer un ou plusieurs états à leur famille.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.LIBELLE_COURT IS 'Libellé court de chaque état.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.LIBELLE_LONG IS 'Libellé long de chaque état.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_CLASSE.VALIDITE IS 'Champ booléen permettant de savoir si l''état est encore valide/utilisé ou non : 1 = oui ; 0 = non.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_CLASSE
ADD CONSTRAINT TA_GG_CLASSE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_CLASSE_VALIDITE_IDX" ON G_GESTIONGEO.TA_GG_CLASSE ("VALIDITE") 
	TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_CLASSE_LIBELLE_COURT_IDX" ON G_GESTIONGEO.TA_GG_CLASSE ("LIBELLE_COURT") 
	TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_CLASSE_LIBELLE_LONG_IDX" ON G_GESTIONGEO.TA_GG_CLASSE ("LIBELLE_LONG") 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_CLASSE TO G_ADMIN_SIG;

/

