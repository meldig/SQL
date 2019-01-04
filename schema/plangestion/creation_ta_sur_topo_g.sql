CREATE TABLE "GEO"."TA_SUR_TOPO_G" (
	"OBJECTID" NUMBER(38,0) NOT NULL ENABLE,
	"CLA_INU" NUMBER(8,0) NOT NULL ENABLE,
	"GEO_REF" VARCHAR2(13 BYTE),
	"GEO_INSEE" CHAR(3 BYTE),
	"GEOM" "SDO_GEOMETRY",
	"GEO_DV" DATE,
	"GEO_DF" DATE,
	"GEO_ON_VALIDE" NUMBER(1,0) DEFAULT 0,
	"GEO_TEXTE" VARCHAR2(2048 BYTE),
	"GEO_TYPE" CHAR(1 BYTE),
	"GEO_NMN" VARCHAR2(20 BYTE),
	"GEO_DS" DATE,
	"GEO_NMS" VARCHAR2(20 BYTE),
	"GEO_DM" DATE,
	CONSTRAINT "PK_TA_SUR_TOPO_G" PRIMARY KEY ("OBJECTID") TABLESPACE "INDX_GEO" ENABLE
  )
	TABLESPACE "DATA_GEO" ;

COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."OBJECTID" IS 'Identifiant interne de l''objet geographique';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."CLA_INU" IS 'Reference a la classe a laquelle appartient l''objet';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_REF" IS 'Identifiant metier. Non obligatoire car certain objet geographique n''ont pas d''objet metier associe.';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_INSEE" IS 'Code insee de la commune sur laquelle se situe l''objet';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEOM" IS 'Geometrie ORACLE de l''objet';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_DV" IS 'Date de debut de validite de l''objet';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_DF" IS 'Date de fin de validite de l''objet.';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_ON_VALIDE" IS 'Statut valide O/N de l''objet';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_TEXTE" IS 'Texte de commentaire';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_TYPE" IS 'Type de geometrie de l''objet geographique';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_NMN" IS 'Auteur de la derniere modification';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_DS" IS 'Date de creation de l''objet';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_NMS" IS 'Auteur de la creation de l''objet';
COMMENT ON COLUMN "GEO"."TA_SUR_TOPO_G"."GEO_DM" IS 'Date de deniere modification de l''objet';
COMMENT ON TABLE "GEO"."TA_SUR_TOPO_G"  IS 'Objets surfaciques du plan topographique de gestion';

CREATE INDEX "GEO"."INDEX1" ON "GEO"."TA_SUR_TOPO_G" ("CLA_INU") TABLESPACE "INDX_GEO" ;

CREATE INDEX "GEO"."INDEX2" ON "GEO"."TA_SUR_TOPO_G" ("GEO_REF") TABLESPACE "INDX_GEO" ;

CREATE INDEX "GEO"."TA_SUR_TOPO_G_SIDX" ON "GEO"."TA_SUR_TOPO_G" ("GEOM")
	INDEXTYPE IS "MDSYS"."SPATIAL_INDEX"  PARAMETERS (' LAYER_GTYPE = MULTIPOLYGON WORK_TABLESPACE=DATA_TEMP TABLESPACE=ISPA_GEO');

CREATE INDEX "GEO"."TA_SUR_TOPO_G_VALIDE_IDX" ON "GEO"."TA_SUR_TOPO_G" ("GEO_ON_VALIDE", "CLA_INU") TABLESPACE "DATA_GEO" ;

CREATE OR REPLACE TRIGGER "GEO"."TA_SUR_1005"
after update or insert ON TA_SUR_TOPO_G for each row
declare
username varchar(30);
vMessage varchar2(32000);
req varchar2(255);
BEGIN
select sys_context('USERENV','OS_USER') into username from dual;
   if updating then
      if geo.get_info(:new.geom,2)=1005 then
        update geo.ta_sur_1005 set
        CLA_INU=:new.CLA_INU,
        GEO_REF=:new.GEO_REF,
        GEO_INSEE=:new.GEO_INSEE,
        GEOM=sdo_geom.sdo_arc_densify(:new.GEOM,0.005,'arc_tolerance=0.05 unit=m'),
        GEO_DV=:new.GEO_DV,
        GEO_DF=:new.GEO_DF,
        GEO_ON_VALIDE=:new.GEO_ON_VALIDE,
        GEO_TEXTE=:new.GEO_TEXTE,
        GEO_NMN=:new.GEO_NMN,
        GEO_DS=:new.GEO_DS,
        GEO_NMS=:new.GEO_NMS,
        GEO_DM=:new.GEO_DM,
        GEO_TYPE=:new.GEO_TYPE
        where OBJECTID=:new.OBJECTID;
      else
        update geo.ta_sur_1005 set
        CLA_INU=:new.CLA_INU,
        GEO_REF=:new.GEO_REF,
        GEO_INSEE=:new.GEO_INSEE,
        GEOM=:new.GEOM,
        GEO_DV=:new.GEO_DV,
        GEO_DF=:new.GEO_DF,
        GEO_ON_VALIDE=:new.GEO_ON_VALIDE,
        GEO_TEXTE=:new.GEO_TEXTE,
        GEO_NMN=:new.GEO_NMN,
        GEO_DS=:new.GEO_DS,
        GEO_NMS=:new.GEO_NMS,
        GEO_DM=:new.GEO_DM,
        GEO_TYPE=:new.GEO_TYPE
        where OBJECTID=:new.OBJECTID;
      end if;
      if geo.get_info(:new.geom,2)=1003 and geo.get_info(:new.geom,3) in (4,2)  then
         update geo.ta_sur_1005 set GEOM=sdo_geom.sdo_arc_densify(:new.GEOM,0.005,'arc_tolerance=0.05 unit=m') where OBJECTID=:new.OBJECTID;
      end if;
      vMessage := vMessage||' '||SQLERRM||' '|| chr(10) || 'Le trigger TA_SUR_1005 update '||:new.objectid;
   end if;
   if inserting then
      if geo.get_info(:new.geom,2)=1005 then
        insert into geo.ta_sur_1005(
        OBJECTID,CLA_INU,GEO_REF,GEO_INSEE,GEOM,GEO_DV,GEO_DF,GEO_ON_VALIDE,GEO_TEXTE,GEO_NMN,GEO_DS,GEO_NMS,GEO_DM,GEO_TYPE
        ) values (
        :new.OBJECTID,:new.CLA_INU,:new.GEO_REF,:new.GEO_INSEE,
        sdo_geom.sdo_arc_densify(:new.GEOM,0.005,'arc_tolerance=0.05 unit=m'),
        :new.GEO_DV,:new.GEO_DF,:new.GEO_ON_VALIDE,:new.GEO_TEXTE,:new.GEO_NMN,:new.GEO_DS,:new.GEO_NMS,:new.GEO_DM,:new.GEO_TYPE
        );
      else
        insert into geo.ta_sur_1005(
        OBJECTID,CLA_INU,GEO_REF,GEO_INSEE,GEOM,GEO_DV,GEO_DF,GEO_ON_VALIDE,GEO_TEXTE,GEO_NMN,GEO_DS,GEO_NMS,GEO_DM,GEO_TYPE
        ) values (
        :new.OBJECTID,:new.CLA_INU,:new.GEO_REF,:new.GEO_INSEE,
        :new.GEOM,
        :new.GEO_DV,:new.GEO_DF,:new.GEO_ON_VALIDE,:new.GEO_TEXTE,:new.GEO_NMN,:new.GEO_DS,:new.GEO_NMS,:new.GEO_DM,:new.GEO_TYPE
        );
      end if;
      if geo.get_info(:new.geom,2)=1003 and geo.get_info(:new.geom,3) in (4,2)  then
         update geo.ta_sur_1005 set GEOM=sdo_geom.sdo_arc_densify(:new.GEOM,0.005,'arc_tolerance=0.05 unit=m') where OBJECTID=:new.OBJECTID;
      end if;
      vMessage := vMessage||' '||SQLERRM||' '|| chr(10) || 'Le trigger TA_SUR_1005 insert '||:new.objectid;
   end if;
 EXCEPTION

WHEN OTHERS THEN
  vMessage := vMessage||' '||SQLERRM||' '|| chr(10) || 'Le trigger TA_SUR_1005 rencontre des problèmes par '||username;
  mail.sendmail('fvoet@lillemetropole.fr',vMessage,'Souci Le trigger TA_SUR_TOPO_G ',
          'fvoet@lillemetropole.fr','fvoet@lillemetropole.fr') ;
END;
/
ALTER TRIGGER "GEO"."TA_SUR_1005" ENABLE;

  CREATE OR REPLACE TRIGGER "GEO"."TA_SUR_TOPO_G"
	before update or insert ON TA_SUR_TOPO_G for each row
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
        if geo.get_info(:new.geom,2)=1005 then
           :new.geom:=sdo_geom.sdo_arc_densify(:new.GEOM,0.005,'arc_tolerance=0.005 unit=m');
        end if;
     end if;
     if inserting then
        :new.geo_nmn:='';
        :new.geo_dm:='';
        :new.geo_nms:=username;
        :new.geo_ds:=sysdate;
        :new.geo_dv:=sysdate;
        :new.geo_df:='31/12/2099';
        :new.geo_on_valide:='0';
         if geo.get_info(:new.geom,2)=1005 then
           :new.geom:=sdo_geom.sdo_arc_densify(:new.GEOM,0.005,'arc_tolerance=0.005 unit=m');
        end if;
     end if;
   EXCEPTION

  WHEN OTHERS THEN
    vMessage := vMessage||' '||SQLERRM||' '|| chr(10) || 'Le trigger TA_SUR_TOPO_G rencontre des problèmes par '||username;
    mail.sendmail('jrmorreale@lillemetropole.fr',vMessage,'Souci Le trigger TA_SUR_TOPO_G ',
            'jrmorreale@lillemetropole.fr','jrmorreale@lillemetropole.fr') ;
END;
/
ALTER TRIGGER "GEO"."TA_SUR_TOPO_G" ENABLE;
