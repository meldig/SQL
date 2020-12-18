SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAUVEGARDE_TA_GG_GEO;

-- Désactivation de la clé étrangère de TA_GG_GEO qui dispose de l'option ON DELETE CASCADE vers TA_GG_DOSSIER
EXECUTE IMMEDIATE 'ALTER TABLE GEO.TA_GG_GEO DISABLE CONSTRAINT TA_GG_GEO_ID_DOS_FK';

-- Suppression des polygones à supprimer de TA_GG_GEO
DELETE
FROM 
    GEO.TA_GG_GEO a
WHERE
    a.ID_GEOM IN(4547, 83, 85, 2496, 652, 12648);

/* Correction des erreurs de géométrie dans TA_GG_GEO via SDO_UTIL.RECTIFY_GEOMETRY
Rappel - les erreurs que cette fonction corrige sont :
- 13349 : le polygone l'intersecte lui-même ;
- 13356 : le polygone a des sommets redondants ;
- 13367 : les anneaux intérieurs et/ou extérieurs ont une mauvaise orientation ;
- Attention : un polygone peut être concerné par plusieurs erreurs et dans ce cas la correction d'une erreur peut aussi résoudre une ou plusieurs autres erreurs sur ce même polygone.
*/

-- Erreur 13343 : suppression des polygones qui sont manifestement des erreurs : 1. ce sont des lignes de type 2003 ; 2.leur suppression n'impacte pas les périmètres des dossiers 
DELETE FROM GEO.TA_GG_GEO a
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13343';
    
-- Erreur 13028 : correction du SDO_ELEM_INFO_ARRAY de chaque entité
UPDATE GEO.TA_GG_GEO a
SET a.geom.SDO_ELEM_INFO = MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1)
WHERE
 SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.GEOM, 0.005) = '13028';

-- Erreur 13349
UPDATE GEO.TA_GG_GEO a
    SET a.GEOM = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13349';
    
-- Erreur 13356
UPDATE GEO.TA_GG_GEO a
    SET a.GEOM = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13356';
    
-- Erreur 13367
UPDATE GEO.TA_GG_GEO a
    SET a.GEOM = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13367';

-- Fusion des polygones d'un même dossier
MERGE INTO GEO.TA_GG_GEO a
    USING(
        WITH
            C_1 AS(
                SELECT
                    a.ID_GEOM,
                    b.ID_DOS,
                    b.CLASSE_DICT,
                    a.DOS_NUM
                FROM
                    GEO.TA_GEO_CORRECT_DOUBLONS a
                    INNER JOIN GEO.TA_GG_GEO b ON b.ID_GEOM = a.ID_GEOM
                WHERE
                    a.ACTION IN('fusionnner',
                                'fusionnjer',
                                'fusionner',
                                'Fusionner',
                                'fusionneer',
                                'fusiojnner',
                                ' fusionner',
                                'fusioonner'
                                )
                    OR a.DOS_NUM IN(
                                        133500235,
                                        85120572,
                                        103600230,
                                        112790021,
                                        113430583,
                                        163780748,
                                        164260850,
                                        161631099,
                                        166110706,
                                        166700676,
                                        172990464,
                                        181430299,
                                        181630451,
                                        173780331,
                                        175120447,
                                        175240403,
                                        180440448,
                                        185530481,
                                        181930445,
                                        183670438,
                                        184100135,
                                        184870312,
                                        186500311,
                                        153780097,
                                        163780407,
                                        161630711,
                                        105530454
                                    )
            ),
            C_2 AS (
                SELECT
                b.DOS_NUM,
                SDO_AGGR_UNION(
                    SDOAGGRTYPE(b.geom, 0.005)
                ) AS GEOM
            FROM
                C_1 a,
                GEO.TA_GG_GEO b
            WHERE
                b.DOS_NUM = a.DOS_NUM
            GROUP BY
                b.DOS_NUM
            )
            SELECT
                a.ID_GEOM,
                a.ID_DOS,
                a.CLASSE_DICT,
                a.DOS_NUM,
                b.GEOM,
                SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(b.GEOM, 0.005) AS STATUT
            FROM
                C_1 a,
                C_2 b
            WHERE
                a.DOS_NUM = b.DOS_NUM
    )t
    ON (a.ID_GEOM = t.ID_GEOM AND t.STATUT = 'TRUE')
WHEN MATCHED THEN
    UPDATE
        SET a.GEOM = t.GEOM;

-- Suppression des entités ayant servi à la fusion
DELETE
FROM 
    GEO.TA_GG_GEO a
WHERE
    a.DOS_NUM IN (
                    SELECT 
                        DOS_NUM
                    FROM
                        GEO.TA_GEO_CORRECT_DOUBLONS a
                    WHERE
                        a.ACTION IN(
                            'fusionnner',
                            'fusionnjer',
                            'fusionner',
                            'Fusionner',
                            'fusionneer',
                            'fusiojnner',
                            ' fusionner',
                            'fusioonner'
                                )
                    OR a.DOS_NUM IN(
                                        133500235,
                                        85120572,
                                        103600230,
                                        112790021,
                                        113430583,
                                        163780748,
                                        164260850,
                                        161631099,
                                        166110706,
                                        166700676,
                                        172990464,
                                        181430299,
                                        181630451,
                                        173780331,
                                        175120447,
                                        175240403,
                                        180440448,
                                        185530481,
                                        181930445,
                                        183670438,
                                        184100135,
                                        184870312,
                                        186500311,
                                        153780097,
                                        163780407,
                                        161630711,
                                        105530454
                                    )
                        
                )
    AND a.ID_GEOM NOT IN (
                            SELECT 
                                ID_GEOM
                            FROM
                                GEO.TA_GEO_CORRECT_DOUBLONS a
                            WHERE
                                a.ACTION IN(
                                    'fusionnner',
	                                'fusionnjer',
	                                'fusionner',
	                                'Fusionner',
	                                'fusionneer',
	                                'fusiojnner',
	                                ' fusionner',
                                    'fusioonner'
                                )
                    OR a.DOS_NUM IN(
                                        133500235,
                                        85120572,
                                        103600230,
                                        112790021,
                                        113430583,
                                        163780748,
                                        164260850,
                                        161631099,
                                        166110706,
                                        166700676,
                                        172990464,
                                        181430299,
                                        181630451,
                                        173780331,
                                        175120447,
                                        175240403,
                                        180440448,
                                        185530481,
                                        181930445,
                                        183670438,
                                        184100135,
                                        184870312,
                                        186500311,
                                        153780097,
                                        163780407,
                                        161630711,
                                        105530454
                                    )
                                
                        )
;


-- Passage de certains dossiers/périmètres en clôturés
-- Résultats attendus : 4 lignes éditées
UPDATE GEO.TA_GG_GEO a
    SET a.ETAT_ID = 9
WHERE
    a.DOS_NUM IN(
                    SELECT b.DOS_NUM
                    FROM
                        GEO.TA_GG_GEO b
                    WHERE
                        b.DOS_NUM IN(
                                        202860388,
                                        203680443,
                                        20320445,
                                        202020446,
                                        202520447
                                    )
                )
;
-- Résultats attendus : 4 lignes éditées
UPDATE GEO.TA_GG_DOSSIER a
    SET a.ETAT_ID = 9
WHERE
    a.DOS_NUM IN(
                    SELECT b.DOS_NUM
                    FROM
                        GEO.TA_GG_DOSSIER b
                    WHERE
                        b.DOS_NUM IN(
                                        202860388,
                                        203680443,
                                        20320445,
                                        202020446,
                                        202520447
                                    )
                )
;

-- Création de deux nouveaux dossiers dans TEMP_DOSSIER_CORRECTION. Ces dossiers correspondront aux périmètres présents dans TA_GG_GEO dont le DOS_NUM = 5332, mais ne disposant pas de dossier dans TEMP_DOSSIER_CORRECTION pour le moment.
INSERT INTO GEO.TA_GG_DOSSIER(ID_DOS, SRC_ID,ETAT_ID,USER_ID,FAM_ID,DOS_DC,DOS_PRECISION,DOS_DMAJ,DOS_RQ,DOS_DT_FIN,DOS_PRIORITE,DOS_IDPERE,DOS_DT_DEB_TR,DOS_DT_FIN_TR,DOS_DT_CMD_SAI,DOS_INSEE,DOS_VOIE,DOS_MAO,DOS_ENTR,ORDER_ID,DOS_NUM,DOS_OLD_ID,DOS_DT_DEB_LEVE,DOS_DT_FIN_LEVE,DOS_DT_PREV, DOS_URL_FILE)
SELECT
    45829,
    a.SRC_ID,
    a.ETAT_ID,
    a.USER_ID,
    a.FAM_ID,
    a.DOS_DC,
    a.DOS_PRECISION,
    a.DOS_DMAJ,
    a.DOS_RQ,
    a.DOS_DT_FIN,
    a.DOS_PRIORITE,
    a.DOS_IDPERE,
    a.DOS_DT_DEB_TR,
    a.DOS_DT_FIN_TR,
    a.DOS_DT_CMD_SAI,
    a.DOS_INSEE,
    3501303,
    a.DOS_MAO,
    a.DOS_ENTR,
    a.ORDER_ID,
    163500142,
    a.DOS_OLD_ID,
    a.DOS_DT_DEB_LEVE,
    a.DOS_DT_FIN_LEVE,
    a.DOS_DT_PREV,
    'RECOL/163500142_59350_rue_du_ballon/'
FROM
    GEO.TA_GG_DOSSIER a
WHERE
    a.DOS_NUM = 163500137;

INSERT INTO GEO.TA_GG_DOSSIER(ID_DOS, SRC_ID,ETAT_ID,USER_ID,FAM_ID,DOS_DC,DOS_PRECISION,DOS_DMAJ,DOS_RQ,DOS_DT_FIN,DOS_PRIORITE,DOS_IDPERE,DOS_DT_DEB_TR,DOS_DT_FIN_TR,DOS_DT_CMD_SAI,DOS_INSEE,DOS_VOIE,DOS_MAO,DOS_ENTR,ORDER_ID,DOS_NUM,DOS_OLD_ID,DOS_DT_DEB_LEVE,DOS_DT_FIN_LEVE,DOS_DT_PREV, DOS_URL_FILE)
SELECT
    45830,
    a.SRC_ID,
    a.ETAT_ID,
    a.USER_ID,
    a.FAM_ID,
    a.DOS_DC,
    a.DOS_PRECISION,
    a.DOS_DMAJ,
    a.DOS_RQ,
    a.DOS_DT_FIN,
    a.DOS_PRIORITE,
    a.DOS_IDPERE,
    a.DOS_DT_DEB_TR,
    a.DOS_DT_FIN_TR,
    a.DOS_DT_CMD_SAI,
    a.DOS_INSEE,
    a.DOS_VOIE,
    a.DOS_MAO,
    a.DOS_ENTR,
    a.ORDER_ID,
    163500169,  
    a.DOS_OLD_ID,
    a.DOS_DT_DEB_LEVE,
    a.DOS_DT_FIN_LEVE,
    a.DOS_DT_PREV,
    'RECOL/163500169_59350_rue_de_la_communaute/'
FROM
    GEO.TA_GG_DOSSIER a
WHERE
    a.DOS_NUM = 163500137;

MERGE INTO GEO.TA_GG_GEO a
	USING(
			SELECT
				b.ID_DOS,
				b.DOS_NUM
			FROM
				GEO.TA_GG_DOSSIER b
			WHERE
				b.DOS_NUM IN(163500142, 163500169)
		)t
ON (a.DOS_NUM = t.DOS_NUM)
WHEN MATCHED THEN
	UPDATE 
		SET a.ID_DOS = t.ID_DOS;    
COMMIT;
-- Réactivation de la clé étrangère de TA_GG_GEO qui dispose de l'option ON DELETE CASCADE vers TA_GG_DOSSIER
EXECUTE IMMEDIATE 'ALTER TABLE GEO.TA_GG_GEO ENABLE CONSTRAINT TA_GG_GEO_ID_DOS_FK';

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAUVEGARDE_TA_GG_GEO;
END;
/