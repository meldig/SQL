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

COMMENT ON TABLE GEO.TA_GG_GEO IS 'Table rassemblant les géométries des dossiers créés dans GestionGeo. Le lien avec TA_GG_DOSSIER se fait via le champ ID_DOS.';
COMMENT ON COLUMN GEO.TA_GG_GEO.ID_GEOM IS 'Clé primaire (identifiant unique) de la table auto-incrémentée par un trigger.';
COMMENT ON COLUMN GEO.TA_GG_GEO.ID_DOS IS 'Clé étrangère vers la table TA_GG_DOSSIER permettant d''associer un dossier à une géométrie.';
COMMENT ON COLUMN GEO.TA_GG_GEO.GEOM IS 'Champ géométrique de la table (mais sans contrainte de type de géométrie)';
COMMENT ON COLUMN GEO.TA_GG_GEO.ETAT_ID IS 'Identifiant de l''état d''avancement du dossier. Attention même si ce champ reprend les identifiants de la table TA_GG_ETAT, il n''y a pas de contrainte de clé étrangère dessus pour autant.';
COMMENT ON COLUMN GEO.TA_GG_GEO.DOS_NUM IS 'Numéro de dossier associé à la géométrie de la table. Attention il n''y a pas de contrainte de clé étrangère vers la table TA_GG_DOSSIER dans laquelle ne numéro de dossier est créé';

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
