CREATE TABLE "GEO"."TA_GG_SOURCE" (
	"SRC_ID" NUMBER NOT NULL ENABLE,
	"SRC_LIBEL" VARCHAR2(100 BYTE) NOT NULL ENABLE,
	"SRC_VAL" NUMBER(*,0) NOT NULL ENABLE,
CONSTRAINT "PK_TA_GG_SOURCE" PRIMARY KEY ("SRC_ID")
  USING INDEX TABLESPACE "INDX_GEO"  ENABLE
 )
TABLESPACE "DATA_GEO" ;

COMMENT ON TABLE GEO.TA_GG_SOURCE IS 'Table recensant tous les agents participant à la création, l''édition et la suppression des dossiers dans GestionGeo.';
COMMENT ON COLUMN GEO.TA_GG_SOURCE.SRC_ID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation. Je ne sais pas d''où viennent ces numéros, peut-être du schéma annuaire.';
COMMENT ON COLUMN GEO.TA_GG_SOURCE.SRC_LIBEL IS 'Pnom de chaque agent.';
COMMENT ON COLUMN GEO.TA_GG_SOURCE.SRC_VAL IS 'Champ booléen permettant de savoir si l''agent participe encore à la vie des données de GestionGeo : 1 = oui ; 0 = non.';

GRANT SELECT ON GEO.TA_GG_SOURCE TO ELYX_DATA WITH GRANT OPTION;
