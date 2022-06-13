  CREATE OR REPLACE FORCE VIEW "G_SIDU"."V_BAL_BAN_IGN"
    (
      "CLE_INTEROP",
      "UID_ADRESSE",
      "VOIE_NOM",
      "NUMERO",
      "SUFFIXE",
      "COMMUNE_NOM",
      "POSITION",
      "X",
      "Y",
      "LONG",
      "LAT",
      "SOURCE",
      "DATE_DER_MAJ",
      CONSTRAINT "PK_V_BAL_BAN_IGN" PRIMARY KEY ("CLE_INTEROP") DISABLE) AS 
    SELECT
        CASE
          WHEN seu.nsseui IS NULL
          THEN 59000+seu.cnumcom||'_'||voi.ccodrvo||'_'||seu.nuseui
          ELSE 59000+seu.cnumcom||'_'||voi.ccodrvo||'_'||seu.nuseui||'_'||lower(seu.nsseui)
        END cle_interop,
        seu.idseui uid_adresse,
        typ.lityvoie || ' ' || voi.cnomvoi1,
        seu.nuseui numero,
        seu.nsseui suffixe,
        initcap(com.nom_minus) commune_nom,
        'entrée' position,
        seu.geom.sdo_point.x x93,
        seu.geom.sdo_point.y y93,
        sdo_cs.transform(seu.geom,4128).sdo_point.x longitude,
        sdo_cs.transform(seu.geom,4128).sdo_point.y latitude,
        'MEL' src,
        seu.cdtmseuil date_maj
    FROM
        g_sidu.iltaseu seu
    INNER JOIN g_sidu.iltasit sit ON sit.idseui = seu.idseui
    INNER JOIN g_sidu.iltatrc trc ON trc.cnumtrc = sit.cnumtrc 
    INNER JOIN g_sidu.voiecvt cvt ON cvt.cnumtrc = trc.cnumtrc
    INNER JOIN g_sidu.voievoi voi ON voi.ccomvoi = cvt.ccomvoi
    INNER JOIN g_sidu.typevoie typ ON typ.ccodtvo = voi.ccodtvo
    INNER JOIN geo.lm_95_communes com ON com.numcom = seu.cnumcom
    WHERE
        seu.nuseui<9000
    AND
        seu.cnumcom   = cvt.cnumcom
    AND
        cvt.cvalide = 'V'
    AND
        voi.cdvalvoi = 'V'
    AND
        trc.cdvaltro = 'V'
;

COMMENT ON TABLE "G_SIDU"."V_BAL_BAN_IGN" IS 'Vue des adresses au format BAL à livrer à l''IGN';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."CLE_INTEROP" IS 'Clé d''interopérabilité: INSSE + _ + FANTOIR + _ + numéro d''adresse + _ + suffixe. Le tout en minuscule';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."UID_ADRESSE" IS  'identifiant unique d''adresse';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."VOIE_NOM" IS 'Nom de la voie';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."NUMERO" IS 'Numéro de l''adresse';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."SUFFIXE" IS 'Suffixe de l''adresse';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."COMMUNE_NOM" IS 'Nom de la commune';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."POSITION" IS 'Position de l''adresse';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."X" IS 'Coordonnée X';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."Y" IS 'Coordonnée Y';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."LONG" IS 'Longitude';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."LAT" IS 'Latitude';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."SOURCE" IS 'Source de l''adresse';
COMMENT ON COLUMN "V_BAL_BAN_IGN"."DATE_DER_MAJ" IS 'Date de la dernière mise à jour';