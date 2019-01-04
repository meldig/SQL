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
