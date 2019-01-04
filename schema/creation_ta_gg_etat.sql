CREATE TABLE "GEO"."TA_GG_ETAT" (
	"ETAT_ID" NUMBER NOT NULL ENABLE,
	"ETAT_LIB" VARCHAR2(100 BYTE) NOT NULL ENABLE,
	"ETAT_AFF" NUMBER(1,0),
	"ETAT_LIB_SMALL" VARCHAR2(50 BYTE),
	"ETAT_STYLE" CHAR(6 BYTE),
	CONSTRAINT "PK_TA_GG_ETAT" PRIMARY KEY ("ETAT_ID")
		USING TABLESPACE "INDX_GEO"  ENABLE
) TABLESPACE "DATA_GEO" ;

COMMENT ON TABLE "GEO"."TA_GG_ETAT"  IS 'Etat de l''avancement du dossier
0 : actif en base (visible en carto : vert)
1 : non valide (non visible en carto)
2 : prévisionnel (visible en carto : bleu)
3 : non vérifié (visible en carto : orange)
4 : vérifié, non validé (visible en carto : rouge)'
;
