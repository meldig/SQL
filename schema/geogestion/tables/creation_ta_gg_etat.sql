/*
TA_GG_ETAT : Création de la table TA_GG_ETAT qui spécificie les états d'avancement des dossiers
*/

-- 1. La table
CREATE TABLE G_GESTIONGEO.TA_GG_ETAT (
	"ETAT_ID" NUMBER(38,0) GENERATED BY DEFAULT AS IDENTITY,
	"ETAT_LIB" VARCHAR2(4000 BYTE) NOT NULL,
	"ETAT_AFF" NUMBER(1,0) NOT NULL,
	"ETAT_LIB_SMALL" VARCHAR2(50 BYTE) NOT NULL,
	"ETAT_SMALL" VARCHAR2(25 BYTE) NOT NULL
);

-- 2. Les commentaires
COMMENT ON TABLE G_GESTIONGEO.TA_GG_ETAT IS 'Table listant tous les états d''avancement que peuvent prendre les dossiers créés dans GestionGeo, avec leur code couleur respectif :
   0 : actif en base (visible en carto : vert)
   1 : non valide (non visible en carto)
   2 : prévisionnel (visible en carto : bleu)
   3 : non vérifié (visible en carto : orange)
   4 : vérifié, non validé (visible en carto : rouge)
';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_ID IS 'Identifiant de chaque état d''avancement.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_LIB IS 'Libellés longs expliquant les états d''avancement des dossiers.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_AFF IS 'Je ne sais pas à quoi correspond ce champ.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_LIB_SMALL IS 'Libellés courts.';
COMMENT ON COLUMN G_GESTIONGEO.TA_GG_ETAT.ETAT_SMALL IS 'Etats d''avancement des dossiers en abrégé.';

-- 3. Les contraintes
-- Contrainte de clé primaire
ALTER TABLE G_GESTIONGEO.TA_GG_ETAT
ADD CONSTRAINT TA_GG_ETAT_PK
PRIMARY KEY("ETAT_ID")
USING INDEX TABLESPACE G_ADT_INDX;

-- Contraintes d'unicité
ALTER TABLE G_GESTIONGEO.TA_GG_ETAT
ADD CONSTRAINT TA_GG_ETAT_AFF_UN
UNIQUE("ETAT_AFF")
USING INDEX TABLESPACE G_ADT_INDX;

ALTER TABLE G_GESTIONGEO.TA_GG_ETAT
ADD CONSTRAINT TA_GG_ETAT_ETAT_LIB_SMALL_UN
UNIQUE("ETAT_LIB_SMALL")
USING INDEX TABLESPACE G_ADT_INDX;

ALTER TABLE G_GESTIONGEO.TA_GG_ETAT
ADD CONSTRAINT TA_GG_ETAT_ETAT_SMALL_UN
UNIQUE("ETAT_SMALL")
USING INDEX TABLESPACE G_ADT_INDX;

-- 4. Les droits de lecture, écriture, suppression
GRANT SELECT ON G_GESTIONGEO.TA_GG_ETAT TO G_ADMIN_SIG;

/

