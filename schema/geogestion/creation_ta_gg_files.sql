CREATE TABLE "GEO"."TA_GG_FILES" (
	"OBJECTID" NUMBER(38,0), 
	"DOS_NUM" NUMBER(9,0), 
	"LIEN" VARCHAR2(2000 BYTE), 
	 CONSTRAINT "TA_GG_FILES_PK" PRIMARY KEY ("OBJECTID")
	)
 TABLESPACE "DATA_GEO" ;

   COMMENT ON COLUMN "GEO"."TA_GG_FILES"."OBJECTID" IS 'Clé primaire de la table (identifiant unique) auto-incrémentée par un trigger.';
   COMMENT ON COLUMN "GEO"."TA_GG_FILES"."DOS_NUM" IS 'Numéro de dossier associé au fichier dont le lien se trouve dans le champ LIEN. Attention il n''y a pas de contrainte de clé étrangère vers la table TA_GG_DOSSIER sur ce champ.';
   COMMENT ON COLUMN "GEO"."TA_GG_FILES"."LIEN" IS 'Lien hypertexte d''une image, concernant le récollement ou les IC, liée au dossier utilisé dans GestionGeo';
   COMMENT ON TABLE "GEO"."TA_GG_FILES"  IS 'Table servant à associer un dossier GestionGeo à son image (via un lien hypertexte) pour les récollements et les IC - Commentaire à faire confirmer.';

  CREATE INDEX "GEO"."TA_GG_FILES_DOS_NUM_IDX" ON "GEO"."TA_GG_FILES" ("DOS_NUM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "INDX_GEO" ;

 CREATE OR REPLACE TRIGGER "GEO"."BEF_TA_GG_FILES" 
BEFORE INSERT ON TA_GG_FILES FOR EACH ROW
BEGIN
  :new.OBJECTID := SEQ_TA_GG_FILES.nextval;
END;
/
ALTER TRIGGER "GEO"."BEF_TA_GG_FILES" ENABLE;