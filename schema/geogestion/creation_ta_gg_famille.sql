CREATE TABLE "GEO"."TA_GG_FAMILLE" (
	"FAM_ID" NUMBER NOT NULL ENABLE,
	"FAM_LIB" VARCHAR2(100 BYTE) NOT NULL ENABLE,
	"FAM_VAL" NUMBER(*,0) NOT NULL ENABLE,
	"FAM_LIB_SMALL" VARCHAR2(2 BYTE),
	CONSTRAINT "PK_TA_GG_FAMILLE" PRIMARY KEY ("FAM_ID")
		TABLESPACE "INDX_GEO"  ENABLE
 )
TABLESPACE "DATA_GEO" ;

 COMMENT ON TABLE "GEO"."TA_GG_FAMILLE"  IS 'Famille de données liées au dossier
 - plan topo
 - réseau (IC)
 - autres
Dans un premier temps l''appli se limitera au plan topo et au données des IC
';
COMMENT ON COLUMN GEO.TA_GG_FAMILLE.FAM_ID IS 'Clé primaire de la table (identifiant unique) sans auto-incrémentation.';
COMMENT ON COLUMN GEO.TA_GG_FAMILLE.FAM_LIB IS 'Libellé de la famille';
COMMENT ON COLUMN GEO.TA_GG_FAMILLE.FAM_VAL IS 'Champ permettant de savoir si la famille est encore valide ou non. 1 = oui ; 0 = non.';
COMMENT ON COLUMN GEO.TA_GG_FAMILLE.FAM_LIB_SMALL IS 'Libellé abrégé de la famille sur 2 caractères uniquement.';