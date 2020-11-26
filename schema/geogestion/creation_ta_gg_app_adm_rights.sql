CREATE TABLE "GEO"."TA_GG_APP_ADM_RIGHTS"  (
	"GROUPE_DYNMAP" NUMBER(38,0),
	"PROFIL" NUMBER(38,0),
	"LABEL" VARCHAR2(20 BYTE)
)
TABLESPACE "DATA_GEO" ;
 COMMENT ON TABLE GEO.TA_GG_APP_ADM_RIGHTS IS 'Table listant et catégorisant les types d''utilisateurs de GestionGEO.';
 COMMENT ON COLUMN GEO.TA_GG_APP_ADM_RIGHTS.LABEL IS 'Libellé expliquant le profil utilisateur.';
 COMMENT ON COLUMN "GEO"."TA_GG_APP_ADM_RIGHTS"."GROUPE_DYNMAP" IS 'Id du groupe Dynmap (cf. MySQL)';
 COMMENT ON COLUMN "GEO"."TA_GG_APP_ADM_RIGHTS"."PROFIL" IS 'Profil (0: user, 1:gest, 2:adm)';
