/*
TA_GG_AGENT : Création de la table TA_GG_AGENT dans laquelle sont recensés les pnoms de tous les agents travaillant avec gestiongeo.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_AGENT (
	"OBJECTID" NUMBER(38,0) NOT NULL,
	"PNOM" VARCHAR2(100 BYTE) NOT NULL,
	"VALIDITE" NUMBER(38,0) NOT NULL
 );

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_AGENT IS 'Table recensant tous les agents participant à la création, l''édition et la suppression des dossiers dans GESTIONGEO.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_AGENT.OBJECTID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation. Il s''agit des codes agents.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_AGENT.PNOM IS 'Pnom de chaque agent.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_AGENT.VALIDITE IS 'Champ booléen permettant de savoir si l''agent participe encore à la vie des données de GestionGeo : 1 = oui ; 0 = non.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_AGENT
ADD CONSTRAINT TA_GG_AGENT_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_AGENT
ADD CONSTRAINT TA_GG_AGENT_PNOM_UN
UNIQUE("PNOM")
USING INDEX TABLESPACE G_ADT_INDX;

-- 4. Les indexes
CREATE INDEX G_GESTIONGEO."TA_GG_AGENT_VALIDITE_IDX" ON G_GESTIONGEO.TA_GG_AGENT ("VALIDITE") 
	TABLESPACE G_ADT_INDX;

CREATE INDEX G_GESTIONGEO."TA_GG_AGENT_PNOM_IDX" ON G_GESTIONGEO.TA_GG_AGENT ("PNOM") 
	TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_AGENT TO G_ADMIN_SIG;

/

