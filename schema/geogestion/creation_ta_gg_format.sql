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
COMMENT ON COLUMN GEO.TA_GG_FORMAT.FOR_ID IS 'Clé primaire (identifiant unique) de la table. ce champ n''est pas auto-incrémenté.';
COMMENT ON COLUMN GEO.TA_GG_FORMAT.FOR_LIB IS 'Libellé des formats utilisés pour la publication de données.'
COMMENT ON COLUMN GEO.TA_GG_FORMAT.FOR_VAL IS 'Champ permettant de savoir si le format est valide (pouvant être utilisé) ou non. 1 = oui ; 0 = non.';
/*
table réellement utilisée ?
un seul enregistrement présent pour le shpae
*/
