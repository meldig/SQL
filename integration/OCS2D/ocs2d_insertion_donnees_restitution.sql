-- Commande d'insertion des données dans les tables du schéma g_ocs2d à partir des tables présentent sur le schéma G_DALC.

-- 1. table TA_OCS2D_4_POSTES_2005_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_4_POSTES_2005_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		"4_POSTES" AS poste,
		"4_POSTES_LIBELLE" AS poste_libelle,
		PERIMETRE AS perimetre,
		SURFACE_M2 AS surface_m2,
		SURFACE_HA AS surface_ha,
		METADONNEE AS metadonnee,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_4_POSTES_2005_SCOT
	) b
ON (a.identifiant = b.identifiant
AND a.poste = b.poste
AND a.poste_libelle = b.poste_libelle
AND a.perimetre = b.perimetre
AND a.surface_m2 = b.surface_m2
AND a.surface_ha = b.surface_ha
AND a.metadonnee = b.metadonnee)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.poste, a.poste_libelle, a.perimetre, a.surface_m2, a.surface_ha, a.metadonnee, a.geom)
VALUES (b.identifiant, b.poste, b.poste_libelle, b.perimetre, b.surface_m2, b.surface_ha, b.metadonnee, b.geom)
;


-- 2. table TA_OCS2D_4_POSTES_2015_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_4_POSTES_2015_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		"4_POSTES" AS poste,
		"4_POSTES_LIBELLE" AS poste_libelle,
		PERIMETRE AS perimetre,
		SURFACE_M2 AS surface_m2,
		SURFACE_HA AS surface_ha,
		METADONNEE AS metadonnee,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_4_POSTES_2015_SCOT
	) b
ON (a.identifiant = b.identifiant
AND a.poste = b.poste
AND a.poste_libelle = b.poste_libelle
AND a.perimetre = b.perimetre
AND a.surface_m2 = b.surface_m2
AND a.surface_ha = b.surface_ha
AND a.metadonnee = b.metadonnee)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.poste, a.poste_libelle, a.perimetre, a.surface_m2, a.surface_ha, a.metadonnee, a.geom)
VALUES (b.identifiant, b.poste, b.poste_libelle, b.perimetre, b.surface_m2, b.surface_ha, b.metadonnee, b.geom)
;


-- 3. table TA_OCS2D_4_POSTES_2020_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_4_POSTES_2020_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		"4_POSTES" AS poste,
		"4_POSTES_LIBELLE" AS poste_libelle,
		PERIMETRE AS perimetre,
		SURFACE_M2 AS surface_m2,
		SURFACE_HA AS surface_ha,
		METADONNEE AS metadonnee,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_4_POSTES_2020_SCOT
	) b
ON (a.identifiant = b.identifiant
AND a.poste = b.poste
AND a.poste_libelle = b.poste_libelle
AND a.perimetre = b.perimetre
AND a.surface_m2 = b.surface_m2
AND a.surface_ha = b.surface_ha
AND a.metadonnee = b.metadonnee)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.poste, a.poste_libelle, a.perimetre, a.surface_m2, a.surface_ha, a.metadonnee, a.geom)
VALUES (b.identifiant, b.poste, b.poste_libelle, b.perimetre, b.surface_m2, b.surface_ha, b.metadonnee, b.geom)
;


-- 4. table TA_OCS2D_21_POSTES_2005_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_21_POSTES_2005_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		"21_POSTES" AS poste,
		"21_POSTES_LIBELLE" AS poste_libelle,
		PERIMETRE AS perimetre,
		SURFACE_M2 AS surface_m2,
		SURFACE_HA AS surface_ha,
		METADONNEE AS metadonnee,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_21_POSTES_2005_SCOT
	) b
ON (a.identifiant = b.identifiant
AND a.poste = b.poste
AND a.poste_libelle = b.poste_libelle
AND a.perimetre = b.perimetre
AND a.surface_m2 = b.surface_m2
AND a.surface_ha = b.surface_ha
AND a.metadonnee = b.metadonnee)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.poste, a.poste_libelle, a.perimetre, a.surface_m2, a.surface_ha, a.metadonnee, a.geom)
VALUES (b.identifiant, b.poste, b.poste_libelle, b.perimetre, b.surface_m2, b.surface_ha, b.metadonnee, b.geom)
;


-- 5. table TA_OCS2D_21_POSTES_2015_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_21_POSTES_2015_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		"21_POSTES" AS poste,
		"21_POSTES_LIBELLE" AS poste_libelle,
		PERIMETRE AS perimetre,
		SURFACE_M2 AS surface_m2,
		SURFACE_HA AS surface_ha,
		METADONNEE AS metadonnee,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_21_POSTES_2015_SCOT
	) b
ON (a.identifiant = b.identifiant
AND a.poste = b.poste
AND a.poste_libelle = b.poste_libelle
AND a.perimetre = b.perimetre
AND a.surface_m2 = b.surface_m2
AND a.surface_ha = b.surface_ha
AND a.metadonnee = b.metadonnee)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.poste, a.poste_libelle, a.perimetre, a.surface_m2, a.surface_ha, a.metadonnee, a.geom)
VALUES (b.identifiant, b.poste, b.poste_libelle, b.perimetre, b.surface_m2, b.surface_ha, b.metadonnee, b.geom)
;


-- 6. table TA_OCS2D_21_POSTES_2020_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_21_POSTES_2020_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		"21_POSTES" AS poste,
		"21_POSTES_LIBELLE" AS poste_libelle,
		PERIMETRE AS perimetre,
		SURFACE_M2 AS surface_m2,
		SURFACE_HA AS surface_ha,
		METADONNEE AS metadonnee,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_21_POSTES_2020_SCOT
	) b
ON (a.identifiant = b.identifiant
AND a.poste = b.poste
AND a.poste_libelle = b.poste_libelle
AND a.perimetre = b.perimetre
AND a.surface_m2 = b.surface_m2
AND a.surface_ha = b.surface_ha
AND a.metadonnee = b.metadonnee)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.poste, a.poste_libelle, a.perimetre, a.surface_m2, a.surface_ha, a.metadonnee, a.geom)
VALUES (b.identifiant, b.poste, b.poste_libelle, b.perimetre, b.surface_m2, b.surface_ha, b.metadonnee, b.geom)
;




-- 7. table TA_OCS2D_2005_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_2005_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		CS_NIVEAU_1 AS cs_niveau_1,
		LIBCS_NIVEAU_1 AS libcs_niveau_1,
		CS_NIVEAU_2 AS cs_niveau_2,
		LIBCS_NIVEAU_2 AS libcs_niveau_2,
		CS_NIVEAU_3 AS cs_niveau_3,
		LIBCS AS libcs,
		CS AS cs,
		US_NIVEAU_1 AS us_niveau_1,
		LIBUS_NIVEAU_1 AS libus_niveau_1,
		US_NIVEAU_2 AS us_niveau_2,
		LIBUS_NIVEAU_2 AS libus_niveau_2,
		US_NIVEAU_3 AS us_niveau_3,
		LIBUS AS libus,
		US AS us,
		"4_POSTES" AS "4_POSTES",
		"4_POSTES_LIBELLE" AS "4_POSTES_LIBELLE",
		"21_POSTES" AS "21_POSTES",
		"21_POSTES_LIBELLE" AS "21_POSTES_LIBELLE",
		INDICE AS indice,
		"SOURCE" AS "SOURCE",
		"COMMENT" AS "COMMENT",
        METADONNEE AS metadonnee,
        PERIMETRE AS perimetre,
        SURFACE_M2 AS surface_m2,
        SURFACE_HA AS surface_ha,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_2005_SCOT
	) b
ON (
	a.IDENTIFIANT = b.identifiant
	AND a.CS_NIVEAU_1 = b.cs_niveau_1
	AND a.LIBCS_NIVEAU_1 = b.libcs_niveau_1
	AND a.CS_NIVEAU_2 = b.cs_niveau_2
	AND a.LIBCS_NIVEAU_2 = b.libcs_niveau_2
	AND a.CS_NIVEAU_3 = b.cs_niveau_3
	AND a.LIBCS = b.libcs
	AND a.CS = b.cs
	AND a.US_NIVEAU_1 = b.us_niveau_1
	AND a.LIBUS_NIVEAU_1 = b.libus_niveau_1
	AND a.US_NIVEAU_2 = b. us_niveau_2
	AND a.LIBUS_NIVEAU_2 = b.libus_niveau_2
	AND a.US_NIVEAU_3 = b.us_niveau_3
	AND a.LIBUS = b.libus
	AND a.US = b.us
	AND a."4_POSTES" = b."4_POSTES"
	AND a."4_POSTES_LIBELLE" = b."4_POSTES_LIBELLE"
	AND a."21_POSTES" = b."21_POSTES"
	AND a."21_POSTES_LIBELLE" = b."21_POSTES_LIBELLE"
	AND a.INDICE = b.indice
	AND a."SOURCE" = b."SOURCE"
	AND a."COMMENT" = b."COMMENT"
    AND a.METADONNEE = b.metadonnee
	AND a.PERIMETRE = b.perimetre
    AND a.SURFACE_M2 = b.surface_m2
    AND a.SURFACE_HA = b.surface_ha
)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.cs_niveau_1, a.libcs_niveau_1, a.cs_niveau_2, a.libcs_niveau_2, a.cs_niveau_3, a.libcs, a.cs, a.us_niveau_1, a.libus_niveau_1, a.us_niveau_2, a.libus_niveau_2, a.us_niveau_3, a.libus, a.us, a."4_POSTES", a."4_POSTES_LIBELLE", a."21_POSTES", a."21_POSTES_LIBELLE", a.indice, a."SOURCE", a."COMMENT", a.metadonnee, a.perimetre, a.surface_m2, a.surface_ha, a.geom)
VALUES (b.identifiant, b.cs_niveau_1, b.libcs_niveau_1, b.cs_niveau_2, b.libcs_niveau_2, b.cs_niveau_3, b.libcs, b.cs, b.us_niveau_1, b.libus_niveau_1, b.us_niveau_2, b.libus_niveau_2, b.us_niveau_3, b.libus, b.us, b."4_POSTES", b."4_POSTES_LIBELLE", b."21_POSTES", b."21_POSTES_LIBELLE", b.indice, b."SOURCE", b."COMMENT", b.metadonnee, b.perimetre, b.surface_m2, b.surface_ha, b.geom)
;


-- 8. table TA_OCS2D_2015_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_2015_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		CS_NIVEAU_1 AS cs_niveau_1,
		LIBCS_NIVEAU_1 AS libcs_niveau_1,
		CS_NIVEAU_2 AS cs_niveau_2,
		LIBCS_NIVEAU_2 AS libcs_niveau_2,
		CS_NIVEAU_3 AS cs_niveau_3,
		LIBCS AS libcs,
		CS AS cs,
		US_NIVEAU_1 AS us_niveau_1,
		LIBUS_NIVEAU_1 AS libus_niveau_1,
		US_NIVEAU_2 AS us_niveau_2,
		LIBUS_NIVEAU_2 AS libus_niveau_2,
		US_NIVEAU_3 AS us_niveau_3,
		LIBUS AS libus,
		US AS us,
		"4_POSTES" AS "4_POSTES",
		"4_POSTES_LIBELLE" AS "4_POSTES_LIBELLE",
		"21_POSTES" AS "21_POSTES",
		"21_POSTES_LIBELLE" AS "21_POSTES_LIBELLE",
		EVOL05_15 AS evol05_15,
		INDICE AS indice,
		"SOURCE" AS "SOURCE",
		"COMMENT" AS "COMMENT",
		METADONNEE AS metadonnee,
        PERIMETRE AS perimetre,
        SURFACE_M2 AS surface_m2,
        SURFACE_HA AS surface_ha,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_2015_SCOT
	) b
ON (
	a.IDENTIFIANT = b.identifiant
	AND a.CS_NIVEAU_1 = b.cs_niveau_1
	AND a.LIBCS_NIVEAU_1 = b.libcs_niveau_1
	AND a.CS_NIVEAU_2 = b.cs_niveau_2
	AND a.LIBCS_NIVEAU_2 = b.libcs_niveau_2
	AND a.CS_NIVEAU_3 = b.cs_niveau_3
	AND a.LIBCS = b.libcs
	AND a.CS = b.cs
	AND a.US_NIVEAU_1 = b.us_niveau_1
	AND a.LIBUS_NIVEAU_1 = b.libus_niveau_1
	AND a.US_NIVEAU_2 = b. us_niveau_2
	AND a.LIBUS_NIVEAU_2 = b.libus_niveau_2
	AND a.US_NIVEAU_3 = b.us_niveau_3
	AND a.LIBUS = b.libus
	AND a.US = b.us
	AND a."4_POSTES" = b."4_POSTES"
	AND a."4_POSTES_LIBELLE" = b."4_POSTES_LIBELLE"
	AND a."21_POSTES" = b."21_POSTES"
	AND a."21_POSTES_LIBELLE" = b."21_POSTES_LIBELLE"
	AND a.EVOL05_15 = b.evol05_15
	AND a.INDICE = b.indice
	AND a."SOURCE" = b."SOURCE"
	AND a."COMMENT" = b."COMMENT"
	AND a.METADONNEE = b.metadonnee
	AND a.PERIMETRE = b.perimetre
    AND a.SURFACE_M2 = b.surface_m2
    AND a.SURFACE_HA = b.surface_ha
)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.cs_niveau_1, a.libcs_niveau_1, a.cs_niveau_2, a.libcs_niveau_2, a.cs_niveau_3, a.libcs, a.cs, a.us_niveau_1, a.libus_niveau_1, a.us_niveau_2, a.libus_niveau_2, a.us_niveau_3, a.libus, a.us, a."4_POSTES", a."4_POSTES_LIBELLE", a."21_POSTES", a."21_POSTES_LIBELLE", a.evol05_15, a.indice, a."SOURCE", a."COMMENT", a.metadonnee, a.perimetre, a.surface_m2, a.surface_ha, a.geom)
VALUES (b.identifiant, b.cs_niveau_1, b.libcs_niveau_1, b.cs_niveau_2, b.libcs_niveau_2, b.cs_niveau_3, b.libcs, b.cs, b.us_niveau_1, b.libus_niveau_1, b.us_niveau_2, b.libus_niveau_2, b.us_niveau_3, b.libus, b.us, b."4_POSTES", b."4_POSTES_LIBELLE", b."21_POSTES", b."21_POSTES_LIBELLE", b.evol05_15, b.indice, b."SOURCE", b."COMMENT", b.metadonnee, b.perimetre, b.surface_m2, b.surface_ha, b.geom)
;


-- 8. table TA_OCS2D_2020_SCOT
MERGE INTO G_OCS2D.TA_OCS2D_2020_SCOT a
USING
	(
	SELECT
		IDENTIFIANT AS identifiant,
		CS_NIVEAU_1 AS cs_niveau_1,
		LIBCS_NIVEAU_1 AS libcs_niveau_1,
		CS_NIVEAU_2 AS cs_niveau_2,
		LIBCS_NIVEAU_2 AS libcs_niveau_2,
		CS_NIVEAU_3 AS cs_niveau_3,
		libcs AS libcs,
		CS AS cs,
		US_NIVEAU_1 AS us_niveau_1,
		LIBUS_NIVEAU_1 AS libus_niveau_1,
		US_NIVEAU_2 AS us_niveau_2,
		LIBUS_NIVEAU_2 AS libus_niveau_2,
		US_NIVEAU_3 AS us_niveau_3,
		libus AS libus,
		US AS us,
		"4_POSTES" AS "4_POSTES",
		"4_POSTES_LIBELLE" AS "4_POSTES_LIBELLE",
		"21_POSTES" AS "21_POSTES",
		"21_POSTES_LIBELLE" AS "21_POSTES_LIBELLE",
		EVOL15_20 AS evol15_20,
		INDICE AS indice,
		"SOURCE" AS "SOURCE",
		"COMMENT" AS "COMMENT",
		METADONNEE AS metadonnee,
        PERIMETRE AS perimetre,
        SURFACE_M2 AS surface_m2,
        SURFACE_HA AS surface_ha,
		GEOM AS geom
	FROM
		G_DALC.TA_OCS2D_2020_SCOT
	) b
ON (
	a.IDENTIFIANT = b.identifiant
	AND a.CS_NIVEAU_1 = b.cs_niveau_1
	AND a.LIBCS_NIVEAU_1 = b.libcs_niveau_1
	AND a.CS_NIVEAU_2 = b.cs_niveau_2
	AND a.LIBCS_NIVEAU_2 = b.libcs_niveau_2
	AND a.CS_NIVEAU_3 = b.cs_niveau_3
	AND a.LIBCS = b.libcs
	AND a.CS = b.cs
	AND a.US_NIVEAU_1 = b.us_niveau_1
	AND a.LIBUS_NIVEAU_1 = b.libus_niveau_1
	AND a.US_NIVEAU_2 = b. us_niveau_2
	AND a.LIBUS_NIVEAU_2 = b.libus_niveau_2
	AND a.US_NIVEAU_3 = b.us_niveau_3
	AND a.LIBUS = b.libus
	AND a.US = b.us
	AND a."4_POSTES" = b."4_POSTES"
	AND a."4_POSTES_LIBELLE" = b."4_POSTES_LIBELLE"
	AND a."21_POSTES" = b."21_POSTES"
	AND a."21_POSTES_LIBELLE" = b."21_POSTES_LIBELLE"
	AND a.EVOL15_20 = b.evol15_20
	AND a.INDICE = b.indice
	AND a."SOURCE" = b."SOURCE"
	AND a."COMMENT" = b."COMMENT"
	AND a.PERIMETRE = b.perimetre
    AND a.SURFACE_M2 = b.surface_m2
    AND a.SURFACE_HA = b.surface_ha
	AND a.METADONNEE = b.metadonnee
)
WHEN NOT MATCHED
THEN INSERT (a.identifiant, a.cs_niveau_1, a.libcs_niveau_1, a.cs_niveau_2, a.libcs_niveau_2, a.cs_niveau_3, a.libcs, a.cs, a.us_niveau_1, a.libus_niveau_1, a.us_niveau_2, a.libus_niveau_2, a.us_niveau_3, a.libus, a.us, a."4_POSTES", a."4_POSTES_LIBELLE", a."21_POSTES", a."21_POSTES_LIBELLE", a.evol15_20, a.indice, a."SOURCE", a."COMMENT", a.metadonnee, a.perimetre, a.surface_m2, a.surface_ha, a.geom)
VALUES (b.identifiant, b.cs_niveau_1, b.libcs_niveau_1, b.cs_niveau_2, b.libcs_niveau_2, b.cs_niveau_3, b.libcs, b.cs, b.us_niveau_1, b.libus_niveau_1, b.us_niveau_2, b.libus_niveau_2, b.us_niveau_3, b.libus, b.us, b."4_POSTES", b."4_POSTES_LIBELLE", b."21_POSTES", b."21_POSTES_LIBELLE", b.evol15_20, b.indice, b."SOURCE", b."COMMENT", b.metadonnee, b.perimetre, b.surface_m2, b.surface_ha, b.geom)
;