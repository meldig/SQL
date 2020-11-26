CREATE TABLE "GEO"."TA_GG_POINT" (
	"ID_GEOM" NUMBER NOT NULL ENABLE,
	"ID_DOS" NUMBER NOT NULL ENABLE,
	"CLASSE_DICT" VARCHAR2(1 BYTE),
	"GEOM" "MDSYS"."SDO_GEOMETRY" ,
	CONSTRAINT "TA_GG_POINT_PK" PRIMARY KEY ("ID_GEOM")
		TABLESPACE "INDX_GEO"  ENABLE
 )
TABLESPACE "DATA_GEO" ;

COMMENT ON TABLE GEO.TA_GG_POINT IS 'Table des centroïdes des objets présents dans TA_GG_GEO.';
COMMENT ON COLUMN GEO.TA_GG_POINT.ID_GEOM IS 'Identifiant de la géométrie présente dans TA_GG_GEO et à partir de laquelle est issue chaque point de la table. Attention, il n''y a pas de contrainte de clé étrangère sur ce champ.';
COMMENT ON COLUMN GEO.TA_GG_POINT.ID_DOS IS 'Identifiant du dossier GestionGeo présent dans TA_GG_DOSSIER. Attention, il n''y a pas de contrainte de clé étrangère sur ce champ.';
COMMENT ON COLUMN GEO.TA_GG_POINT.GEOM IS 'Champ géométrique rassemblant tous les centroïdes des objets de la table TA_GG_GEO.';

CREATE INDEX "GEO"."TA_GG_POINT_SIDX" ON "GEO"."TA_GG_POINT" ("GEOM")
	INDEXTYPE IS "MDSYS"."SPATIAL_INDEX"  PARAMETERS (' LAYER_GTYPE = COLLECTION WORK_TABLESPACE=DATA_TEMP TABLESPACE=ISPA_GEO');
