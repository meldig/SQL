-- Initialisation de la table TA_GG_DOMAINE avec les categorie de la vue ELYX_DATA.V_TA_CLASSE_CAT.

-- 1. Ajout des categories dans la table G_GESTIONGEO.TA_GG_DOMAINE
MERGE INTO G_GESTIONGEO.TA_GG_DOMAINE a
USING
	(
		SELECT
			DISTINCT CATEGORIE AS DOMAINE
		FROM
			G_GESTIONGEO.TEMP_V_TA_CLASSE_CAT
	)b
ON(TRIM(LOWER(a.DOMAINE)) = TRIM(LOWER(b.DOMAINE)))
WHEN NOT MATCHED THEN
INSERT (a.DOMAINE)
VALUES (b.DOMAINE);

COMMIT;

/

-- 2. Ajout des codes des classe qui ne sont pas déjà présents dans la table G_GESTIONGEO.Ta_GG_CLASSE 
MERGE INTO G_GESTIONGEO.TA_GG_CLASSE a
USING
	(
		SELECT
			DISTINCT
			a.CLA_INU AS OBJECTID,
			TRIM(LOWER(a.cla_code)) AS LIBELLE_COURT,
			TRIM(LOWER(a.cla_li)) AS LIBELLE_LONG,
			1 AS VALIDITE
		FROM
			G_GESTIONGEO.TEMP_V_TA_CLASSE_CAT a
        WHERE
            TRIM(LOWER(a.cla_li)) IS NOT NULL
	)b
ON (a.objectid = b.objectid
AND TRIM(LOWER(a.libelle_court)) = TRIM(LOWER(b.libelle_court))
AND TRIM(LOWER(a.libelle_long)) = TRIM(LOWER(b.libelle_long)))
WHEN NOT MATCHED THEN
INSERT (a.OBJECTID, a.LIBELLE_COURT, a.LIBELLE_LONG, a.VALIDITE)
VALUES (b.OBJECTID, b.LIBELLE_COURT, b.LIBELLE_LONG, b.VALIDITE)
;

COMMIT;

/

-- 3. Ajout des relations entre les codes des classes et les domaines dans la table G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE
MERGE INTO G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE a
USING
	(
		SELECT
			a.cla_inu AS FID_CLASSE,
			b.objectid AS FID_DOMAINE
		FROM
			TEMP_V_TA_CLASSE_CAT a
			INNER JOIN TA_GG_CLASSE c ON a.CLA_INU = c.OBJECTID
			INNER JOIN TA_GG_DOMAINE b ON TRIM(LOWER(a.CATEGORIE)) = TRIM(LOWER(b.DOMAINE))
	)b
ON (a.FID_CLASSE = b.FID_CLASSE
AND a.FID_DOMAINE = b.FID_DOMAINE)
WHEN NOT MATCHED THEN
INSERT (a.FID_CLASSE, a.FID_DOMAINE)
VALUES (b.FID_CLASSE, b.FID_DOMAINE)
;

COMMIT;

-- 4. Ajout des domaines Classe des elements lineaires et Classe des elements ponctuels relevés par les géomètres.
MERGE INTO G_GESTIONGEO.TA_GG_DOMAINE a
USING
	(
		SELECT TRIM(LOWER('Classe des elements ponctuels')) AS DOMAINE FROM DUAL UNION
		SELECT TRIM(LOWER('Classe des elements lineaires')) AS DOMAINE FROM DUAL 
	)b
ON(TRIM(LOWER(a.DOMAINE)) = TRIM(LOWER(b.DOMAINE)))
WHEN NOT MATCHED THEN
INSERT (a.DOMAINE)
VALUES (b.DOMAINE);

COMMIT;


-- 5. Insertion des relations classe - domaine des elements ponctuels relevés par les geometres.
MERGE INTO G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE a
USING
	(
		SELECT
			a.objectid AS FID_CLASSE,
			b.objectid AS FID_DOMAINE
		FROM
			TA_GG_CLASSE a,
			TA_GG_DOMAINE b
		WHERE
			a.objectid IN (SELECT DISTINCT(CLA_INU) FROM TEMP_TA_POINT_TOPO_GPS UNION SELECT DISTINCT(CLA_INU) FROM TEMP_TA_POINT_TOPO_F UNION SELECT DISTINCT(CLA_INU) FROM TEMP_TA_POINT_TOPO_F_LOG)
			AND TRIM(LOWER(b.DOMAINE )) = TRIM(LOWER('Classe des elements ponctuels'))
	)b
ON (a.FID_CLASSE = b.FID_CLASSE
AND a.FID_DOMAINE = b.FID_DOMAINE)
WHEN NOT MATCHED THEN
INSERT (a.FID_CLASSE, a.FID_DOMAINE)
VALUES (b.FID_CLASSE, b.FID_DOMAINE)
;

COMMIT;


-- 6. Insertion des relations classe - domaine des elements lineraires relevés par les geometres
MERGE INTO G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE a
USING
	(
		SELECT
			a.objectid AS FID_CLASSE,
			b.objectid AS FID_DOMAINE
		FROM
			TA_GG_CLASSE a,
			TA_GG_DOMAINE b
		WHERE
			a.objectid IN (SELECT DISTINCT(CLA_INU) FROM TEMP_TA_LIG_TOPO_GPS UNION SELECT DISTINCT(CLA_INU) FROM TEMP_TA_LIG_TOPO_F UNION SELECT DISTINCT(CLA_INU) FROM TEMP_TA_LIG_TOPO_F_LOG)
			AND TRIM(LOWER(b.DOMAINE )) = TRIM(LOWER('Classe des elements lineaires'))
	)b
ON (a.FID_CLASSE = b.FID_CLASSE
AND a.FID_DOMAINE = b.FID_DOMAINE)
WHEN NOT MATCHED THEN
INSERT (a.FID_CLASSE, a.FID_DOMAINE)
VALUES (b.FID_CLASSE, b.FID_DOMAINE)
;

COMMIT;


-- 7. Ajout des domaines Classe des elements ponctuels representes par un rectangle ou un cercle.
MERGE INTO G_GESTIONGEO.TA_GG_DOMAINE a
USING
	(
		SELECT TRIM(LOWER('Classe des elements ponctuels représentes par un rectangle')) AS DOMAINE FROM DUAL UNION
		SELECT TRIM(LOWER('Classe des elements ponctuels représentes par un cercle')) AS DOMAINE FROM DUAL 
	)b
ON(TRIM(LOWER(a.DOMAINE)) = TRIM(LOWER(b.DOMAINE)))
WHEN NOT MATCHED THEN
INSERT (a.DOMAINE)
VALUES (b.DOMAINE);

COMMIT;


-- 8. Insertion des relations classe - avec le domaine Classe des elements ponctuels représentes par un rectangle
MERGE INTO G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE a
USING
	(
		SELECT
			a.objectid AS FID_CLASSE,
			b.objectid AS FID_DOMAINE
		FROM
			TA_GG_CLASSE a,
			TA_GG_DOMAINE b
		WHERE
			a.objectid IN ('66','29','100','31','45','36','33','172','188','89','84','83','741','116','64','75','38','76','59','111','137','168','40','167','71','70','88','107','179','73','164','178','162','191','161','142','114','93','740','63','545','670','690','691','53','121','52','37','39','56','82','108','81','736','141','139','405','547','126','160','132','30','151','119','133','79','185','118','32','158','125','120','109','55','176','96')
			AND TRIM(LOWER(b.DOMAINE )) = TRIM(LOWER('Classe des elements ponctuels représentes par un rectangle'))
	)b
ON (a.FID_CLASSE = b.FID_CLASSE
AND a.FID_DOMAINE = b.FID_DOMAINE)
WHEN NOT MATCHED THEN
INSERT (a.FID_CLASSE, a.FID_DOMAINE)
VALUES (b.FID_CLASSE, b.FID_DOMAINE)
;

COMMIT;


-- 9. Insertion des relations classe - avec le domaine Classe des elements ponctuels représentes par un rectangle
MERGE INTO G_GESTIONGEO.TA_GG_RELATION_CLASSE_DOMAINE a
USING
	(
		SELECT
			a.objectid AS FID_CLASSE,
			b.objectid AS FID_DOMAINE
		FROM
			TA_GG_CLASSE a,
			TA_GG_DOMAINE b
		WHERE
			a.objectid IN ('28','738','146','170','187','110','115','48','739','105','130','760','157','46','129','761','737','147','123','1290','122','50','155','156','152')
			AND TRIM(LOWER(b.DOMAINE )) = TRIM(LOWER('Classe des elements ponctuels représentes par un cercle'))
	)b
ON (a.FID_CLASSE = b.FID_CLASSE
AND a.FID_DOMAINE = b.FID_DOMAINE)
WHEN NOT MATCHED THEN
INSERT (a.FID_CLASSE, a.FID_DOMAINE)
VALUES (b.FID_CLASSE, b.FID_DOMAINE)
;

COMMIT;



/


