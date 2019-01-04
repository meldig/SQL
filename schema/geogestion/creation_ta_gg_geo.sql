CREATE TABLE "GEO"."TA_GG_GEO" (
	"ID_GEOM" NUMBER NOT NULL ENABLE,
	"ID_DOS" NUMBER NOT NULL ENABLE,
	"CLASSE_DICT" VARCHAR2(1 BYTE),
	"GEOM" "MDSYS"."SDO_GEOMETRY" ,
	"ETAT_ID" NUMBER(1,0),
	"DOS_NUM" NUMBER(10,0),
	CONSTRAINT "PK_TA_GG_GEOM" PRIMARY KEY ("ID_GEOM")
		TABLESPACE "INDX_GEO"  ENABLE,
	CONSTRAINT "FK_TA_GG_GEO_TA_GG_DOS" FOREIGN KEY ("ID_DOS")
	REFERENCES "GEO"."TA_GG_DOSSIER" ("ID_DOS") ON DELETE CASCADE ENABLE
)
TABLESPACE "DATA_GEO" ;

CREATE INDEX "GEO"."TA_GG_GEO_SIDX" ON "GEO"."TA_GG_GEO" ("GEOM")
 INDEXTYPE IS "MDSYS"."SPATIAL_INDEX"  PARAMETERS (' LAYER_GTYPE = COLLECTION WORK_TABLESPACE=DATA_TEMP TABLESPACE=ISPA_GEO');

CREATE OR REPLACE TRIGGER "GEO"."TA_GG_POINT"
after insert or delete ON TA_GG_GEO for each row
declare
username varchar(30);
vMessage varchar2(32000);
point sdo_geometry;
BEGIN
   select sys_context('USERENV','OS_USER') into username from dual;
   point:=sdo_geom.sdo_centroid(sdo_geom.sdo_buffer(:new.GEOM,1,0.005),0.005);
  if inserting then
        insert into geo.ta_gg_point(
        id_geom,id_dos,classe_dict,geom
        ) values (
        :new.id_geom,:new.id_dos,:new.classe_dict,
        point
        );
   end if;
   if deleting then
        delete from geo.ta_gg_point where id_geom=:old.id_geom;
   end if;
 EXCEPTION

WHEN OTHERS THEN
  vMessage := vMessage||' '||SQLERRM||' '|| chr(10) || 'Le trigger TA_GG_POINT rencontre des problèmes par '||username;
  mail.sendmail('fvoet@lillemetropole.fr',vMessage,'Souci Le trigger TA_GG_POINT ', 'fvoet@lillemetropole.fr','fvoet@lillemetropole.fr') ;
END;

/
ALTER TRIGGER "GEO"."TA_GG_POINT" ENABLE;

  CREATE OR REPLACE TRIGGER "GEO"."TA_GG_GEO"
	BEFORE INSERT ON "GEO"."TA_GG_GEO"
	FOR EACH ROW
	BEGIN
	  select TA_GG_GEO_SEQ.nextval into :new.ID_GEOM from dual;
	END;
/
ALTER TRIGGER "GEO"."TA_GG_GEO" ENABLE;
