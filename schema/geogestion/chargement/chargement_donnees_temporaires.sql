------------------------------------------------
-------- CHARGEMENT DONNEES TEMPORAIRES --------
------------------------------------------------

-- Creation table de sauvegarde des anciens elements avec le numero de dossier
  
CREATE TABLE G_GESTIONGEO.TA_GG_ELEMENT_NUMERO_DOSSIER AS 
WITH CTE AS
		(
		SELECT
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_POINT_TOPO_GPS' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_POINT_TOPO_GPS@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_LIG_TOPO_GPS' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_LIG_TOPO_GPS@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			CAST(ID_DOS AS VARCHAR2(10 BYTE)) AS NUMERO_DOSSIER,
			'PTTOPO' AS TABLE_SOURCE,
			NULL AS VALIDITE
		FROM
			GEO.PTTOPO@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_POINT_TOPO_F' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_POINT_TOPO_F@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_LIG_TOPO_F' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_LIG_TOPO_F@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_POINT_TOPO_F_LOG' AS TABLE_SOURCE,
			NULL AS VALIDITE
		FROM
			GEO.TA_POINT_TOPO_F_LOG@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_LIG_TOPO_F_LOG' AS TABLE_SOURCE,
			NULL AS VALIDITE
		FROM
			GEO.TA_LIG_TOPO_F_LOG@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_SUR_TOPO_G' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_SUR_TOPO_G@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_SUR_TOPO_G_LOG' AS TABLE_SOURCE,
			NULL AS VALIDITE
		FROM
			GEO.TA_SUR_TOPO_G_LOG@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_LIG_TOPO_G' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_LIG_TOPO_G@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_LIG_TOPO_G_LOG' AS TABLE_SOURCE,
			NULL AS VALIDITE
		FROM
			GEO.TA_LIG_TOPO_G_LOG@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_LIG_TOPO_GPS_BACKUP' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_LIG_TOPO_GPS_BACKUP@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1@DBL_CUDL_GEO
		UNION ALL
		SELECT 
			OBJECTID AS OBJECTID,
			GEO_REF AS NUMERO_DOSSIER,
			'TA_LIG_TOPO_IC' AS TABLE_SOURCE,
			GEO_ON_VALIDE AS VALIDITE
		FROM
			GEO.TA_LIG_TOPO_IC@DBL_CUDL_GEO
		)
SELECT
	ROWNUM AS OBJECTID,
	OBJECTID AS IDENTIFIANT_OBJET,
	NUMERO_DOSSIER,
	TABLE_SOURCE,
	VALIDITE
FROM
	CTE
;


-- Creation des tables temporaire contenant les données de l'application GESTIONGEO provenant de l'instance CUDL

-- 1. Table TA_POINT_TOPO_GPS
CREATE TABLE TEMP_TA_POINT_TOPO_GPS AS
SELECT * FROM GEO.TA_POINT_TOPO_GPS@DBL_CUDL_GEO WHERE GEO_REF NOT LIKE 'IC_%';

CREATE INDEX TEMP_TA_POINT_TOPO_GPS_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_GPS_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_GPS_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_GPS_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_GPS(CLA_INU) TABLESPACE G_ADT_INDX;


-- 2. Table TA_LIG_TOPO_GPS
CREATE TABLE TEMP_TA_LIG_TOPO_GPS AS
SELECT * FROM GEO.TA_LIG_TOPO_GPS@DBL_CUDL_GEO WHERE GEO_REF NOT LIKE 'IC_%';

CREATE INDEX TEMP_TA_LIG_TOPO_GPS_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS(CLA_INU) TABLESPACE G_ADT_INDX;


-- 3. Table PTTOPO
CREATE TABLE TEMP_PTTOPO AS
SELECT a.* FROM GEO.PTTOPO@DBL_CUDL_GEO a;

CREATE INDEX TEMP_PTTOPO_OBJECTID_IDX ON G_GESTIONGEO.TEMP_PTTOPO(OBJECTID) TABLESPACE G_ADT_INDX;


-- 4. Table TA_POINT_TOPO_F
CREATE TABLE TEMP_TA_POINT_TOPO_F AS
SELECT * FROM GEO.TA_POINT_TOPO_F@DBL_CUDL_GEO
WHERE OBJECTID NOT IN (SELECT OBJECTID FROM GEO.TA_POINT_TOPO_GPS@DBL_CUDL_GEO WHERE GEO_REF LIKE ('IC_%'))
OR GEO_REF NOT LIKE ('IC%')
;

CREATE INDEX TEMP_TA_POINT_TOPO_F_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_F(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_F_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_F(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_F_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_F(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_F_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_F(CLA_INU) TABLESPACE G_ADT_INDX;


-- 5. Table TA_LIG_TOPO_F
CREATE TABLE TEMP_TA_LIG_TOPO_F AS
SELECT * FROM GEO.TA_LIG_TOPO_F@DBL_CUDL_GEO
WHERE OBJECTID NOT IN (SELECT OBJECTID FROM GEO.TA_LIG_TOPO_GPS@DBL_CUDL_GEO WHERE GEO_REF LIKE ('IC_%'))
OR GEO_REF NOT LIKE ('IC%');

CREATE INDEX TEMP_TA_LIG_TOPO_F_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_F(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_F_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_F(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_F_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_F(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_F_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_F(CLA_INU) TABLESPACE G_ADT_INDX;


-- 6. Table TA_POINT_TOPO_F_LOG
CREATE TABLE TEMP_TA_POINT_TOPO_F_LOG AS
SELECT * FROM GEO.TA_POINT_TOPO_F_LOG@DBL_CUDL_GEO
WHERE FID_IDENTIFIANT NOT IN (SELECT OBJECTID FROM GEO.TA_LIG_TOPO_GPS@DBL_CUDL_GEO WHERE GEO_REF LIKE ('IC_%'))
OR GEO_REF NOT LIKE ('IC%');

CREATE INDEX TEMP_TA_POINT_TOPO_F_LOG_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_F_LOG_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_F_LOG_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG(CLA_INU) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_POINT_TOPO_F_LOG_MODIFICATION_IDX ON G_GESTIONGEO.TEMP_TA_POINT_TOPO_F_LOG(MODIFICATION) TABLESPACE G_ADT_INDX;


-- 7. Table TA_LIG_TOPO_F_LOG
CREATE TABLE TEMP_TA_LIG_TOPO_F_LOG AS
SELECT * FROM GEO.TA_LIG_TOPO_F_LOG@DBL_CUDL_GEO
WHERE FID_IDENTIFIANT NOT IN (SELECT OBJECTID FROM GEO.TA_LIG_TOPO_GPS@DBL_CUDL_GEO WHERE GEO_REF LIKE ('IC_%'))
OR GEO_REF NOT LIKE ('IC%');

CREATE INDEX TEMP_TA_LIG_TOPO_F_LOG_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_F_LOG_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_F_LOG_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG(CLA_INU) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_F_LOG_MODIFICATION_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_F_LOG(MODIFICATION) TABLESPACE G_ADT_INDX;


-- 8. Table TA_SUR_TOPO_G
CREATE TABLE TEMP_TA_SUR_TOPO_G AS
SELECT * FROM GEO.TA_SUR_TOPO_G@DBL_CUDL_GEO;

CREATE INDEX TEMP_TA_SUR_TOPO_G_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_SUR_TOPO_G(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_SUR_TOPO_G_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_SUR_TOPO_G(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_SUR_TOPO_G_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_SUR_TOPO_G(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_SUR_TOPO_G_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_SUR_TOPO_G(CLA_INU) TABLESPACE G_ADT_INDX;


-- 9. Table TA_SUR_TOPO_G_LOG
CREATE TABLE TEMP_TA_SUR_TOPO_G_LOG AS
SELECT * FROM GEO.TA_SUR_TOPO_G_LOG@DBL_CUDL_GEO;

CREATE INDEX TEMP_TA_SUR_TOPO_G_LOG_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_SUR_TOPO_G_LOG_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_SUR_TOPO_G_LOG_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG(CLA_INU) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_SUR_TOPO_G_LOG_MODIFICATION_IDX ON G_GESTIONGEO.TEMP_TA_SUR_TOPO_G_LOG(MODIFICATION) TABLESPACE G_ADT_INDX;


-- 10. Table TA_LIG_TOPO_G
CREATE TABLE TEMP_TA_LIG_TOPO_G AS
SELECT * FROM GEO.TA_LIG_TOPO_G@DBL_CUDL_GEO;

CREATE INDEX TEMP_TA_LIG_TOPO_G_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_G(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_G_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_G(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_G_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_G(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_G_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_G(CLA_INU) TABLESPACE G_ADT_INDX;


-- 11. Table TA_LIG_TOPO_G_LOG
CREATE TABLE TEMP_TA_LIG_TOPO_G_LOG AS
SELECT * FROM GEO.TA_LIG_TOPO_G_LOG@DBL_CUDL_GEO;

CREATE INDEX TEMP_TA_LIG_TOPO_G_LOG_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_G_LOG(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_G_LOG_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_G_LOG(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_G_LOG_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_G_LOG(CLA_INU) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_G_LOG_MODIFICATION_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_G_LOG(MODIFICATION) TABLESPACE G_ADT_INDX;


-- 12. Table TA_LIG_TOPO_GPS_BACKUP
CREATE TABLE TEMP_TA_LIG_TOPO_GPS_BACKUP AS
SELECT * FROM GEO.TA_LIG_TOPO_GPS_BACKUP@DBL_CUDL_GEO
WHERE OBJECTID NOT IN (SELECT OBJECTID FROM GEO.TA_LIG_TOPO_GPS@DBL_CUDL_GEO WHERE GEO_REF LIKE ('IC_%'))
OR GEO_REF NOT LIKE 'IC_%';

CREATE INDEX TEMP_TA_LIG_TOPO_GPS_BACKUP_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_BACKUP_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_BACKUP_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_BACKUP_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_BACKUP(CLA_INU) TABLESPACE G_ADT_INDX;


-- 13. TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1
CREATE TABLE TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1 AS
SELECT * FROM GEO.TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1@DBL_CUDL_GEO
WHERE OBJECTID NOT IN (SELECT OBJECTID FROM GEO.TA_LIG_TOPO_GPS@DBL_CUDL_GEO WHERE GEO_REF LIKE ('IC_%'))
OR GEO_REF NOT LIKE 'IC_%';

CREATE INDEX TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_GPS_GEO_ON_VALIDE_1(CLA_INU) TABLESPACE G_ADT_INDX;


-- 14. TA_LIG_TOPO_IC
CREATE TABLE TEMP_TA_LIG_TOPO_IC AS
SELECT * FROM GEO.TA_LIG_TOPO_IC@DBL_CUDL_GEO;

CREATE INDEX TEMP_TA_LIG_TOPO_IC_OBJECTID_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_IC(OBJECTID) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_IC_GEO_NMN_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_IC(GEO_NMN) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_IC_GEO_NMS_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_IC(GEO_NMS) TABLESPACE G_ADT_INDX;
CREATE INDEX TEMP_TA_LIG_TOPO_IC_CLA_INU_IDX ON G_GESTIONGEO.TEMP_TA_LIG_TOPO_IC(CLA_INU) TABLESPACE G_ADT_INDX;


/*
-- 15. _V_TA_CLASSE_CAT
CREATE TABLE TEMP_V_TA_CLASSE_CAT AS
SELECT * FROM ELYX_DATA.V_TA_CLASSE_CAT@   // DBL_CUDL_GEO//;
*/
/
