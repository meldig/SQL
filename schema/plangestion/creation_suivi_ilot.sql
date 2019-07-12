CREATE OR REPLACE FORCE VIEW "ELYX_DATA"."V_GEO_GESTION_ILOT" ("OBJECTID", "GEOM", "GEO_ON_VALIDE", "GEO_NMN", "GEO_DS", "GEO_NMS", "GEO_DM") AS
select
	objectid,
	GEOM,
	GEO_ON_VALIDE,
	GEO_NMN,
	GEO_DS,
	GEO_NMS,
	GEO_DM
from geo.ta_gestion_ilot_g f;
WHERE

CREATE TABLE "GEO"."TA_GESTION_ILOT_G" AS
SELECT

FROM GEO.TA_SUR_TOPO_G
WHERE
  GEO_ON_VALIDE = 0 AND
	CLA_INU =



CREATE TABLE "GEO"."TA_GESTION_ILOT_G"
 (
 	"OBJECTID" NUMBER(38,0) NOT NULL ENABLE,
	"CLA_INU" NUMBER(8,0) NOT NULL ENABLE,
	"GEO_REF" VARCHAR2(13 BYTE),
	"GEO_INSEE" CHAR(3 BYTE),
	"GEOM" "MDSYS"."SDO_GEOMETRY" ,
	"GEO_DV" DATE,
	"GEO_DF" DATE,
	"GEO_ON_VALIDE" NUMBER(1,0),
	"GEO_TEXTE" VARCHAR2(2048 BYTE),
	"GEO_TYPE" CHAR(1 BYTE),
	"GEO_NMN" VARCHAR2(20 BYTE),
	"GEO_DS" DATE,
	"GEO_NMS" VARCHAR2(20 BYTE),
	"GEO_DM" DATE
 )
TABLESPACE "DATA_GEO" ;


 CREATE INDEX "GEO"."TA_GESTION_ILOT_G_SIDX" ON "GEO"."TA_GESTION_ILOT_G" ("GEOM")
 INDEXTYPE IS "MDSYS"."SPATIAL_INDEX"  PARAMETERS (' LAYER_GTYPE = MULTIPOLYGON WORK_TABLESPACE=DATA_TEMP TABLESPACE=ISPA_GEO');

 CREATE OR REPLACE TRIGGER "GEO"."TA_GESTION_ILOT_G"
before update ON TA_GESTION_ILOT_G for each row
declare
username varchar(30);
vMessage varchar2(32000);
req varchar2(255);
BEGIN
select sys_context('USERENV','OS_USER') into username from dual;
	 if updating then
			:new.geo_nms:=:old.geo_nms;
			:new.geo_ds:=:old.geo_ds;
			:new.geo_nmn:=username;
			:new.geo_dm:=sysdate;
	 end if;
 EXCEPTION
WHEN OTHERS THEN
	vMessage := vMessage||' '||SQLERRM||' '|| chr(10) || 'Le trigger TA_GESTION_ILOT_G rencontre des problèmes par '||username;
	mail.sendmail('fvoet@lillemetropole.fr',vMessage,'Souci Le trigger TA_GESTION_ILOT_G ',
					'fvoet@lillemetropole.fr','fvoet@lillemetropole.fr') ;
END;
/
ALTER TRIGGER "GEO"."TA_GESTION_ILOT_G" ENABLE;
