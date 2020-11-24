-- Table non-utilisée

CREATE TABLE "GEO"."TA_GG_EXTERIEUR" (
	"USER_ID" NUMBER NOT NULL ENABLE,
	"EXT_NOM" VARCHAR2(200 BYTE) NOT NULL ENABLE,
	"EXT_DT_FIN_VAL2" DATE NOT NULL ENABLE,
	"EXT_EMAIL" VARCHAR2(200 BYTE) NOT NULL ENABLE,
	"EXT_LOGIN" VARCHAR2(100 BYTE) NOT NULL ENABLE,
	"EXT_PWD" VARCHAR2(2048 BYTE) NOT NULL ENABLE,
	"EXT_DT_CONS" DATE
 )
TABLESPACE "DATA_GEO" ;

COMMENT ON TABLE GEO.TA_GG_EXTERIEUR IS 'Table vide, mais d''après les noms de champs elle devait ou aurait dû servir à stocker les informations des utilisateurs externes (dont les identifiants de connexion) se connectant au schéma GEO.';

CREATE INDEX "GEO"."EXT_USER_FK" ON "GEO"."TA_GG_EXTERIEUR" ("USER_ID")
	TABLESPACE "INDX_GEO";
