/*
TA_GG_FAMILLE : Création de la table TA_GG_FAMILLE qui contient les familles de dossiers des géomètres.
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_FAMILLE (
	"OBJECTID" NUMBER(38,0) DEFAULT G_GESTIONGEO.SEQ_TA_GG_FAMILLE_OBJECTID.NEXTVAL NOT NULL,
	"LIBELLE" VARCHAR2(4000 BYTE),
	"VALIDITE" NUMBER(38,0),
	"LIBELLE_ABREGE" VARCHAR2(2 BYTE)
 );

-- 2. Les commentaires
 COMMENT ON TABLE G_GESTIONGEO.TA_GG_FAMILLE IS 'Famille de données liées au dossier
 - plan topo
 - réseau (IC)
 - autres
Dans un premier temps l''appli se limitera au plan topo et au données des IC
';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.OBJECTID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.LIBELLE IS 'Libellé de la famille';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.VALIDITE IS 'Champ permettant de savoir si la famille est encore valide ou non. 1 = oui ; 0 = non.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_FAMILLE.LIBELLE_ABREGE IS 'Libellé abrégé de la famille sur 2 caractères uniquement.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_FAMILLE
ADD CONSTRAINT TA_GG_FAMILLE_PK
PRIMARY KEY("OBJECTID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_FAMILLE
ADD CONSTRAINT TA_GG_FAMILLE_LIBELLE_UN
UNIQUE("LIBELLE")
USING INDEX TABLESPACE G_ADT_INDX;

ALTER TABLE G_GESTIONGEO.TA_GG_FAMILLE
ADD CONSTRAINT TA_GG_FAMILLE_LIBELLE_ABREGE_UN
UNIQUE("LIBELLE_ABREGE")
USING INDEX TABLESPACE G_ADT_INDX;

-- 5. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_FAMILLE TO G_ADMIN_SIG;

/

