/*
Création de la table G_GESTIONGEO.TA_GG_AGENT dans laquelle sont stockés tous les pnoms des agents ayant participé ou qui participe encore à la mise à jour du plan de gestion.
*/
-- 1. Création de la table
CREATE TABLE "G_GESTIONGEO"."TA_GG_AGENT" (
	"OBJECTID" NUMBER NOT NULL ENABLE,
	"PNOM" VARCHAR2(100 BYTE) NOT NULL ENABLE,
	"VALIDITE" NUMBER(1,0) NOT NULL ENABLE
 );

-- 2. Création de la clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_AGENT
ADD CONSTRAINT TA_GG_AGENT_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE "G_ADT_INDX";

-- 3. Création des commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_AGENT IS 'Table recensant tous les agents participant à la création, l''édition et la suppression des dossiers dans G_GESTIONGEO.';
COMMENT ON COLUMN TA_GG_AGENT.OBJECTID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation. Il s''agit des codes agents.';
COMMENT ON COLUMN TA_GG_AGENT.PNOM IS 'Pnom de chaque agent.';
COMMENT ON COLUMN TA_GG_AGENT.VALIDITE IS 'Champ booléen permettant de savoir si l''agent participe encore à la vie des données de GestionGeo : 1 = oui ; 0 = non.';

-- 4. Création des indexes
CREATE INDEX TA_GG_AGENT_VALIDITE_IDX ON G_GESTIONGEO.TA_GG_AGENT(VALIDITE)
    TABLESPACE G_ADT_INDX;