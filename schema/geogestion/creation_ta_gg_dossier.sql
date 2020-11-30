CREATE TABLE "GEO"."TA_GG_DOSSIER" (
	"ID_DOS" NUMBER NOT NULL ENABLE,
	"SRC_ID" NUMBER NOT NULL ENABLE,
	"ETAT_ID" NUMBER NOT NULL ENABLE,
	"USER_ID" NUMBER NOT NULL ENABLE,
	"FAM_ID" NUMBER DEFAULT 1,
	"DOS_DC" DATE NOT NULL ENABLE,
	"DOS_PRECISION" VARCHAR2(100 BYTE),
	"DOS_DMAJ" DATE,
	"DOS_RQ" VARCHAR2(2048 BYTE),
	"DOS_DT_FIN" DATE,
	"DOS_PRIORITE" NUMBER(1,0) NOT NULL ENABLE,
	"DOS_IDPERE" NUMBER,
	"DOS_DT_DEB_TR" DATE,
	"DOS_DT_FIN_TR" DATE,
	"DOS_DT_CMD_SAI" DATE,
	"DOS_INSEE" NUMBER(5,0),
	"DOS_VOIE" NUMBER(8,0),
	"DOS_MAO" VARCHAR2(200 BYTE),
	"DOS_ENTR" VARCHAR2(200 BYTE),
	"DOS_URL_FILE" VARCHAR2(200 BYTE),
	"ORDER_ID" NUMBER(10,0),
	"DOS_NUM" NUMBER,
	"DOS_NUM_SHORT" NUMBER(4,0),
	"DOS_OLD_ID" VARCHAR2(8 BYTE),
	"DOS_DT_DEB_LEVE" DATE,
	"DOS_DT_FIN_LEVE" DATE,
	"DOS_DT_PREV" DATE,
	 CONSTRAINT "PK_TA_GG_DOSSIER" PRIMARY KEY ("ID_DOS")
		TABLESPACE "INDX_GEO"  ENABLE,
 	CONSTRAINT "EU_TA_GG_DOSSIER" UNIQUE ("DOS_NUM")
		TABLESPACE "INDX_GEO"  ENABLE,
	CONSTRAINT "FK_TA_GG_DO_ETAT_GEST_TA_GG_ET" FOREIGN KEY ("ETAT_ID")	REFERENCES "GEO"."TA_GG_ETAT" ("ETAT_ID") ENABLE,
	CONSTRAINT "FK_TA_GG_DO_FAMILLE_TA_GG_FA" FOREIGN KEY ("FAM_ID") REFERENCES "GEO"."TA_GG_FAMILLE" ("FAM_ID") ENABLE,
	CONSTRAINT "FK_TA_GG_DO_SRC_GESTI_TA_GG_SO" FOREIGN KEY ("SRC_ID") REFERENCES "GEO"."TA_GG_SOURCE" ("SRC_ID") ENABLE
 )
TABLESPACE "DATA_GEO" ;

COMMENT ON TABLE "GEO"."TA_GG_DOSSIER"  IS 'Table principale. Chaque dossier correspond à un numéro de chantier pour le plan topo et IC';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.ETAT_ID IS 'Clé étrangère vers la table TA_GG_ETAT indiquant l''état d''avancement du dossier.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_RQ IS 'Remarque lors de la création du dossier permettant de préciser la raison de sa création, sa délimitation ou le type de bâtiment/voirie qui a été construit/détruit.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_DMAJ IS 'Date de mise à jour du dossier';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_PRECISION IS 'Précision apportée au dossier telle que sa surface et l''origine de la donnée.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.FAM_ID IS 'Clé étrangère vers la table TA_GG_FAMILLE permettant de savoir à quelle famille appartient chaque dossier : "plan de récolement", "investigation complémentaire", "maj carto"';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.SRC_ID IS 'Clé étrangère vers la table TA_GG_SOURCE permettant de savoir quel utilisateur a créé quel dossier.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.ID_DOS IS 'Clé primaire de la table correspondant à l''identifiant unique de chaque dossier - le trigger se chargeant de son incrémentation (TA_GG_DOSSIER) a été désactivé car il y avait des problèmes de doublons avec DynMap.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_PRIORITE IS 'Priorité de traitement des dossiers par les géomètres.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_INSEE IS 'Code INSEE de la commune dans laquelle se situe l''objet nécessitant un dossier.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_DT_DEB_TR IS 'Date de début des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_DT_FIN_TR IS 'Date de fin des travaux sur l''objet concerné par le dossier.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_DT_DEB_LEVE IS 'Date de début des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_DT_FIN_LEVE IS 'Date de fin des levés de l''objet (du dossier) par les géomètres.';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_NUM IS 'Numéro de chaque dossier - différent de son identifiant ID_DOS (PK).';
COMMENT ON COLUMN GEO.TA_GG_DOSSIER.DOS_NUM_SHORT IS 'Numéro abrégé de chaque dossier. Ce numéro était mis à jour par le trigger TA_DOSSIER_SHORTNUM qui est désactivé (commentaire écrit le 20/11/2020). Cependant les derniers dossiers ont bien un DOS_NUM_SHORT non null signe que ce champ continu d''être renseigné.';

CREATE INDEX "GEO"."ETAT_GESTION_FK" ON "GEO"."TA_GG_DOSSIER" ("ETAT_ID") TABLESPACE "INDX_GEO" ;

CREATE INDEX "GEO"."FAMILLE_FK" ON "GEO"."TA_GG_DOSSIER" ("FAM_ID") TABLESPACE "INDX_GEO" ;

CREATE INDEX "GEO"."PROFIL_FK" ON "GEO"."TA_GG_DOSSIER" ("USER_ID") TABLESPACE "INDX_GEO" ;

CREATE INDEX "GEO"."SRC_GESTION_FK" ON "GEO"."TA_GG_DOSSIER" ("SRC_ID") TABLESPACE "INDX_GEO" ;

CREATE OR REPLACE TRIGGER "GEO"."TA_DOSSIER_SHORTNUM"
		AFTER INSERT
		ON TA_GG_DOSSIER
		FOR EACH ROW
	DECLARE
		num_short number;
		num_long number;
		insee number;
	BEGIN
		insee := :OLD.DOS_INSEE;

select nvl(max(dos_num_short),0)+1 into num_short from ta_gg_dossier where dos_dc <= add_months(trunc(sysdate, 'YEAR'), 12)-1/24/60/60 and dos_dc >= trunc(sysdate, 'YEAR') AND dos_insee = insee;

-- UPDATE TA_GG_DOSSIER SET DOS_NUM_SHORT=num_short WHERE ID_DOS = :NEW.ID_DOS;

END TA_DOSSIER_SHORTNUM;
/
ALTER TRIGGER "GEO"."TA_DOSSIER_SHORTNUM" DISABLE;

CREATE OR REPLACE TRIGGER "GEO"."TA_GG_DOSSIER"
BEFORE INSERT ON "GEO"."TA_GG_DOSSIER"
FOR EACH ROW
BEGIN
	select TA_GG_DOSSIER_SEQ.nextval into :new.ID_DOS from dual;
END;
/
ALTER TRIGGER "GEO"."TA_GG_DOSSIER" DISABLE;
