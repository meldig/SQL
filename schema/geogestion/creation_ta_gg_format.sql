CREATE TABLE "GEO"."TA_GG_FORMAT" (
	"FOR_ID" NUMBER NOT NULL ENABLE,
  "FOR_LIB" VARCHAR2(100 BYTE) NOT NULL ENABLE,
  "FOR_VAL" NUMBER(*,0) NOT NULL ENABLE,
	CONSTRAINT "PK_TA_GG_FORMAT" PRIMARY KEY ("FOR_ID")
		TABLESPACE "INDX_GEO"  ENABLE
 )
TABLESPACE "DATA_GEO" ;

COMMENT ON TABLE "GEO"."TA_GG_FORMAT" IS 'Liste des formats acceptable pour l''upload
- dwg, dxf
 - shp
 - dgn
 - csv, geo
 - doc, odt
 - pdf
 - gif, jpeg, png
';

/*
table réellement utilisée ?
un seul enregistrement présent pour le shpae
*/
