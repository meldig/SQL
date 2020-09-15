CREATE OR REPLACE FORCE VIEW "G_SIDU"."V_LM_VOIE_IGN"
  (
    "OBJECTID",
    "INSEE",
    "COMMUNE",
    "NOM_VOIE",
    "RIVOLI",
    "GEOM", 
CONSTRAINT "PK_V_LM_VOIE_IGN" PRIMARY KEY ("OBJECTID") DISABLE) AS 
SELECT
    CAST(trc.cnumtrc + voi.cnumcom * 100000 AS NUMBER (38)),
    com.numcom + 59000,
    com.nom,
    typ.lityvoie || ' ' || voi.cnomvoi1,
    voi.ccodrvo,
    trc.geom
FROM
    g_sidu.voievoi voi
INNER JOIN g_sidu.typevoie typ ON typ.ccodtvo = voi.ccodtvo
INNER JOIN g_sidu.voiecvt cvt ON cvt.ccomvoi = voi.ccomvoi
INNER JOIN g_sidu.iltatrc trc ON trc.cnumtrc = cvt.cnumtrc
INNER JOIN geo.lm_95_communes com ON com.numcom = voi.cnumcom
WHERE
    trc.cdvaltro = 'V'
    AND cvt.cvalide = 'V'
    AND voi.cdvalvoi = 'V'
;

COMMENT ON TABLE "G_SIDU"."V_LM_VOIE_IGN" IS 'Vue des tronçons à livrer à l''IGN.';
COMMENT ON COLUMN "V_LM_VOIE_IGN"."OBJECTID" IS 'Clé primaire de la table. Objectid créer par concaténation du numéro de tronçon + numéro de commune * 100000.';
COMMENT ON COLUMN "V_LM_VOIE_IGN"."INSEE" IS 'Numéro INSEE de la commune d''appartenance du tronçon.';
COMMENT ON COLUMN "V_LM_VOIE_IGN"."COMMUNE" IS 'Nom de la commune.';
COMMENT ON COLUMN "V_LM_VOIE_IGN"."NOM_VOIE" IS 'Nom de la voie.';
COMMENT ON COLUMN "V_LM_VOIE_IGN"."RIVOLI" IS 'Code RIVOLI de la voie.';
COMMENT ON COLUMN "V_LM_VOIE_IGN"."GEOM" IS 'Géométrie du tronçon.';