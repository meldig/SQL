--------------------------------------------------------
-------- REQUETE_MAJ_NUMERO_DOSSIER_TABLES_TEMP --------
--------------------------------------------------------

--Requete permettant la mise à jour du numero de dossier des elements (GEO_REF)
/*

METHODOLOGIE

1. Créer un dossier pour les elements avec des numéros de dossier inexistant (IC et RECOL) -> 1
2. Mise à jour 1 des GEO_REF des tables GPS qui ne commencent ni par REC ni IC mais qui sont des dossiers de recolement
3. Mise à jour 2 des GEO_REF des table GPS qui ne commencent ni par REC ni IC mais qui sont des dossiers de IC
4. Mise à jour du GEO_REF pour retirer les caractères alphabetiques
5. Mise à jour des tables de log

*/


-----------------------------------------------
-- 1. Gestion de la table TEMP_PTTOPO. --
-----------------------------------------------

UPDATE G_GESTIONGEO.TEMP_PTTOPO
SET ID_DOS = '1'
WHERE ID_DOS NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


----------------------------------------------------------------------------------------
-- 2. Mise à jour des numéros de dossier des tables TA_POINT_TOPO_F et TA_LIG_TOPO_F. --
----------------------------------------------------------------------------------------

-- 2.1. TEMP_TA_POINT_TOPO_F
MERGE INTO G_GESTIONGEO.TEMP_TA_POINT_TOPO_F a
USING
	(
		SELECT
			a.OBJECTID AS OBJECTID,
			a.GEO_REF AS GEO_REF
		FROM
			G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS a
	)b
ON(a.OBJECTID = b.OBJECTID)
WHEN MATCHED THEN
UPDATE SET a.GEO_REF = b.GEO_REF
;

COMMIT;

-- 2.2. TEMP_TA_LIG_TOPO_F
MERGE INTO G_GESTIONGEO.TEMP_TA_LIG_TOPO_F a
USING
	(
		SELECT
			a.OBJECTID AS OBJECTID,
			a.GEO_REF AS GEO_REF
		FROM
			G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP a
	)b
ON(a.OBJECTID = b.OBJECTID)
WHEN MATCHED THEN
UPDATE SET a.GEO_REF = b.GEO_REF
;

COMMIT;

-- 2.3. TEMP_TA_POINT_TOPO_GPS
MERGE INTO G_GESTIONGEO.TEMP_TA_LIG_TOPO_F a
USING
	(
		SELECT
			a.OBJECTID AS OBJECTID,
			a.GEO_REF AS GEO_REF
		FROM
			G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1 a
	)b
ON(a.OBJECTID = b.OBJECTID)
WHEN MATCHED THEN
UPDATE SET a.GEO_REF = b.GEO_REF
;

COMMIT;

-- 2.4. TEMP_TA_POINT_TOPO_GPS
MERGE INTO G_GESTIONGEO.TEMP_TA_LIG_TOPO_F a
USING
	(
		SELECT
			a.OBJECTID AS OBJECTID,
			a.GEO_REF AS GEO_REF
		FROM
			G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS a
	)b
ON(a.OBJECTID = b.OBJECTID)
WHEN MATCHED THEN
UPDATE SET a.GEO_REF = b.GEO_REF
;

COMMIT;


-----------------------------------------------
-- 3. Gestion de la table TA_POINT_TOPO_GPS. --
-----------------------------------------------

-- 3.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.
UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 3.2. Mise à 1 des GEO_REF à NULL
UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

COMMIT;

-- 3.3. Suppression des caractères 'IC' des GEO_REF
UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 3.4. suppression des caractères 'REC' des GEO_REF 
UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 3.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER
UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


--------------------------------------------
-- 4. Gestion de la table TA_LIG_TOPO_GPS.--
--------------------------------------------

-- 4.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 4.2. Mise à 1 des GEO_REF à NULL

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

COMMIT;

-- 4.3. Suppression des caractères 'IC' des GEO_REF

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 4.4. suppression des caractères 'REC' des GEO_REF 

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 4.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


----------------------------------------------
-- 5. Gestion de la table TA_POINT_TOPO_FIN --
----------------------------------------------

-- 5.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 5.2. Mise à 1 des GEO_REF à NULL

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

COMMIT;

-- 5.3. Suppression des caractères 'IC' des GEO_REF

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 5.4. suppression des caractères 'REC' des GEO_REF 

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 5.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


-----------------------------------------------
-- 6. Gestion de la table TA_POINT_TOPO_FIN. --
-----------------------------------------------

-- 6.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 6.2. Mise à 1 des GEO_REF à NULL

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

-- 6.3. Suppression des caractères 'IC' des GEO_REF

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 6.4. suppression des caractères 'REC' des GEO_REF 

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 6.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


-----------------------------------------------
-- 7. Gestion de la table TA_POINT_TOPO_FIN. --
-----------------------------------------------

-- 7.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 7.2. Mise à 1 des GEO_REF à NULL

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

COMMIT;

-- 7.3. Suppression des caractères 'IC' des GEO_REF

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 7.4. suppression des caractères 'REC' des GEO_REF 

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 7.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


-----------------------------------------------
-- 8. Gestion de la table TA_POINT_TOPO_FIN. --
-----------------------------------------------

-- 8.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 8.2. Mise à 1 des GEO_REF à NULL

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

COMMIT;

-- 8.3. Suppression des caractères 'IC' des GEO_REF

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 8.4. suppression des caractères 'REC' des GEO_REF 

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 8.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER

UPDATE G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


------------------------------------------------
-- 9. Gestion de la table TA_POINT_TOPO_F_LOG --
------------------------------------------------

MERGE INTO G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG a
USING
	(
		SELECT
			a.OBJECTID AS FID_IDENTIFIANT,
			a.GEO_REF AS GEO_REF
		FROM
			G_GESTIONGEO.TEMP_TA_POINT_TOPO_F a
	)b
ON(a.FID_IDENTIFIANT = b.FID_IDENTIFIANT)
WHEN MATCHED THEN
UPDATE SET a.GEO_REF = b.GEO_REF
;

COMMIT;


-----------------------------------------------
-- 10. Gestion de la table TA_LIG_TOPO_F_LOG --
-----------------------------------------------

MERGE INTO G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG a
USING
	(
		SELECT
			a.OBJECTID AS FID_IDENTIFIANT,
			a.GEO_REF AS GEO_REF
		FROM
			G_GESTIONGEO.TEMP_TA_LIG_TOPO_F a
	)b
ON(a.FID_IDENTIFIANT = b.FID_IDENTIFIANT)
WHEN MATCHED THEN
UPDATE SET a.GEO_REF = b.GEO_REF
;

COMMIT;


--------------------------------------------------
-- 11. Gestion de la table TA_POINT_TOPO_F_LOG. --
--------------------------------------------------

-- 11.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 11.2. Mise à 1 des GEO_REF à NULL

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

COMMIT;

-- 11.3. Suppression des caractères 'IC' des GEO_REF

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 11.4. suppression des caractères 'REC' des GEO_REF 

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 11.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER

UPDATE G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


--------------------------------------------------
-- 12. Gestion de la table TA_POINT_TOPO_F_LOG. --
--------------------------------------------------

-- 12.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 12.2. Mise à 1 des GEO_REF à NULL

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

COMMIT;

-- 12.3. Suppression des caractères 'IC' des GEO_REF

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 12.4. suppression des caractères 'REC' des GEO_REF 

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 12.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;


--------------------------------------------
-- 4. Gestion de la table TA_LIG_TOPO_GPS.--
--------------------------------------------

-- 13.1. Mise à 1 des GEO_REF qui ne commencent ni par REC ni par IC.

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP
SET GEO_REF = '1'
WHERE 
	GEO_REF NOT LIKE 'IC_%'
    AND GEO_REF NOT LIKE 'REC_%';

COMMIT;

-- 13.2. Mise à 1 des GEO_REF à NULL

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP
SET GEO_REF = '1'
WHERE GEO_REF IS NULL;

COMMIT;

-- 13.3. Suppression des caractères 'IC' des GEO_REF

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP
SET GEO_REF = REPLACE(GEO_REF,'IC_','')
WHERE GEO_REF LIKE 'IC_%';

COMMIT;

-- 13.4. suppression des caractères 'REC' des GEO_REF 

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP
SET GEO_REF = REPLACE(GEO_REF,'REC_','')
WHERE GEO_REF LIKE 'REC_%';

COMMIT;

-- 13.5. Mise à 1 des GEO_REF non présents dans G_GESTIONGEO.TEMP_TA_GG_DOSSIER

UPDATE G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP
SET GEO_REF = '1'
WHERE GEO_REF NOT IN (SELECT OBJECTID FROM TA_GG_DOSSIER);

COMMIT;

/
