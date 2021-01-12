SET SERVEROUTPUT ON
BEGIN
SAVEPOINT POINT_SAVE_TEMP_TA_GG_GEO;

-- 2. Suppression des polygones à supprimer de TEMP_TA_GG_GEO
DELETE
FROM 
    GEO.TEMP_TA_GG_GEO a
WHERE
    a.ID_GEOM IN(38085, 43040, 40317, 38084, 38579);

/* 
-- 3. Correction des erreurs de géométries
Correction des erreurs de géométrie dans TEMP_TA_GG_GEO via SDO_UTIL.RECTIFY_GEOMETRY
Rappel - les erreurs que cette fonction corrige sont :
- 13349 : le polygone l'intersecte lui-même ;
- 13356 : le polygone a des sommets redondants ;
- 13367 : les anneaux intérieurs et/ou extérieurs ont une mauvaise orientation ;
- Attention : un polygone peut être concerné par plusieurs erreurs et dans ce cas la correction d'une erreur peut aussi résoudre une ou plusieurs autres erreurs sur ce même polygone.
*/
-- Erreur 13343 : suppression des polygones qui sont manifestement des erreurs : 1. ce sont des lignes de type 2003 ; 2.leur suppression n'impacte pas les périmètres des dossiers 
DELETE FROM GEO.TEMP_TA_GG_GEO a
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13343';
    
-- Erreur 13028 : correction du SDO_ELEM_INFO_ARRAY de chaque entité
UPDATE GEO.TEMP_TA_GG_GEO a
SET a.geom.SDO_ELEM_INFO = MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1)
WHERE
 SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005) = '13028';

-- Erreur 13349
UPDATE GEO.TEMP_TA_GG_GEO a
    SET a.geom = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13349';
    
-- Erreur 13356
UPDATE GEO.TEMP_TA_GG_GEO a
    SET a.geom = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13356';
    
-- Erreur 13367
UPDATE GEO.TEMP_TA_GG_GEO a
    SET a.geom = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13367';

-- 4. Fusion des polygones de TEMP_TA_GG_GEO disposant du même DOS_NUM (appartenant donc au même dossier)
MERGE INTO GEO.TEMP_TA_GG_GEO a
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
                    INNER JOIN GEO.TEMP_TA_GG_GEO b ON b.ID_GEOM = a.ID_GEOM
                WHERE
                    a.ACTION = 'fusion'
                    --AND a.DOS_NUM <> 186500311
            ),
            C_2 AS (
                SELECT
                b.DOS_NUM,
                SDO_AGGR_UNION(
                    SDOAGGRTYPE(b.geom, 0.005)
                ) AS GEOM
            FROM
                C_1 a,
                GEO.TEMP_TA_GG_GEO b
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
        SET a.geom = t.GEOM;

-- 5. Suppression des entités ayant servi à la fusion, sauf celles dont la géométrie a été mise à jour par la requête précédente (cf. point 4).
DELETE
FROM 
    GEO.TEMP_TA_GG_GEO a
WHERE
    a.DOS_NUM IN (
                    SELECT 
                        DOS_NUM
                    FROM
                        GEO.TA_GEO_CORRECT_DOUBLONS a
                    WHERE
                        a.ACTION = 'fusion'
                        --AND a.DOS_NUM <> 186500311                        
                )
    AND a.ID_GEOM NOT IN (
                            SELECT 
                                ID_GEOM
                            FROM
                                GEO.TA_GEO_CORRECT_DOUBLONS a
                            WHERE
                                a.ACTION = 'fusion'
                                --AND a.DOS_NUM <> 186500311
                                
                        )
;


-- 6. Passage de certains dossiers/périmètres en clôturés
-- Résultats attendus : 4 lignes éditées
UPDATE GEO.TEMP_TA_GG_GEO a
    SET a.ETAT_ID = 9
WHERE
    a.DOS_NUM IN(
                    SELECT b.DOS_NUM
                    FROM
                        GEO.TEMP_TA_GG_GEO b
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
UPDATE GEO.TEMP_TA_GG_DOSSIER a
    SET a.ETAT_ID = 9
WHERE
    a.DOS_NUM IN(
                    SELECT b.DOS_NUM
                    FROM
                        GEO.TEMP_TA_GG_DOSSIER b
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

-- 7. Création de deux nouveaux dossiers dans TEMP_TA_GG_DOSSIER. Ces dossiers correspondront aux périmètres présents dans TEMP_TA_GG_GEO dont le DOS_NUM = 5332, mais ne disposant pas de dossier dans TEMP_TA_GG_DOSSIER pour le moment.
/*INSERT INTO GEO.TEMP_TA_GG_DOSSIER(ID_DOS, SRC_ID,ETAT_ID,USER_ID,FAM_ID,DOS_DC,DOS_PRECISION,DOS_DMAJ,DOS_RQ,DOS_DT_FIN,DOS_PRIORITE,DOS_IDPERE,DOS_DT_DEB_TR,DOS_DT_FIN_TR,DOS_DT_CMD_SAI,DOS_INSEE,DOS_VOIE,DOS_MAO,DOS_ENTR,ORDER_ID,DOS_NUM,DOS_OLD_ID,DOS_DT_DEB_LEVE,DOS_DT_FIN_LEVE,DOS_DT_PREV, DOS_URL_FILE)
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
    GEO.TEMP_TA_GG_DOSSIER a
WHERE
    a.DOS_NUM = 163500137;

INSERT INTO GEO.TEMP_TA_GG_DOSSIER(ID_DOS, SRC_ID,ETAT_ID,USER_ID,FAM_ID,DOS_DC,DOS_PRECISION,DOS_DMAJ,DOS_RQ,DOS_DT_FIN,DOS_PRIORITE,DOS_IDPERE,DOS_DT_DEB_TR,DOS_DT_FIN_TR,DOS_DT_CMD_SAI,DOS_INSEE,DOS_VOIE,DOS_MAO,DOS_ENTR,ORDER_ID,DOS_NUM,DOS_OLD_ID,DOS_DT_DEB_LEVE,DOS_DT_FIN_LEVE,DOS_DT_PREV, DOS_URL_FILE)
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
    GEO.TEMP_TA_GG_DOSSIER a
WHERE
    a.DOS_NUM = 163500137;
*/
/*SELECT
    MAX(ID_DOS) + 1
FROM
    GEO.TEMP_TA_GG_DOSSIER;*/
-- 7.2. Création d'un nouveau dossier pour un périmètre en doublon
INSERT INTO GEO.TEMP_TA_GG_DOSSIER(SRC_ID,ETAT_ID,USER_ID,FAM_ID,DOS_DC,DOS_PRECISION,DOS_DMAJ,DOS_RQ,DOS_DT_FIN,DOS_PRIORITE,DOS_IDPERE,DOS_DT_DEB_TR,DOS_DT_FIN_TR,DOS_DT_CMD_SAI,DOS_INSEE,DOS_VOIE,DOS_MAO,DOS_ENTR,ORDER_ID,DOS_NUM,DOS_OLD_ID,DOS_DT_DEB_LEVE,DOS_DT_FIN_LEVE,DOS_DT_PREV, DOS_URL_FILE)
SELECT
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
    213500049,  
    a.DOS_OLD_ID,
    a.DOS_DT_DEB_LEVE,
    a.DOS_DT_FIN_LEVE,
    a.DOS_DT_PREV,
    a.DOS_URL_FILE
FROM
    GEO.TEMP_TA_GG_DOSSIER a
WHERE
    a.DOS_NUM = 213500004;

-- 8. Mise à jour de l'ID_DOS des deux polygones mentionnés au point 7 avec l'ID_DOS créés lors de l'exécution des requêtes du point 7.
/*MERGE INTO GEO.TEMP_TA_GG_GEO a
    USING(
            SELECT
                b.ID_DOS,
                b.DOS_NUM
            FROM
                GEO.TEMP_TA_GG_DOSSIER b
            WHERE
                b.DOS_NUM IN(163500142, 163500169)
        )t
ON (a.DOS_NUM = t.DOS_NUM)
WHEN MATCHED THEN
    UPDATE 
        SET a.ID_DOS = t.ID_DOS;
*/
-- 8.2. Mise à jour de l'ID_DOS du périmètre dont le DOS_NUM = 213500004;
MERGE INTO GEO.TEMP_TA_GG_GEO a
    USING(
            SELECT
                b.ID_DOS,
                b.DOS_NUM
            FROM
                GEO.TEMP_TA_GG_DOSSIER b
            WHERE
                b.DOS_NUM = 213500049
        )t
ON (a.ID_GEOM = 46478)
WHEN MATCHED THEN
    UPDATE 
        SET a.ID_DOS = t.ID_DOS, a.DOS_NUM = t.DOS_NUM;

-- 9. Correction des faux doublons du champ DOS_ENTR de la table TEMP_TA_GG_DOSSIER
MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN(' .ETUDIS', ' ETUDIS','ETUDIS')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'ETUDIS';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('COLAS','COLAS NORD PICARDIE')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'COLAS NORD PICARDIE';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('E.J.M (Lille)','EJM')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'EJM';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('GECITEC','GESITEC','GACITEC')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'GECITEC';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('IDTP', 'ID TP')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'IDTP';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('NORD DT','NORD-DT')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'NORD DT';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('RAMERI','RAMERY','RAMERY SA')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'RAMERY';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('S.A.V.N.', 'SAVN')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'SAVN';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('UF Cartographie des territoires','UF Cartographie des territoires ')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'UF Cartographie des territoires';

MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
    USING(
        SELECT
            b.ID_DOS
        FROM
            GEO.TEMP_TA_GG_DOSSIER b
        WHERE
            b.DOS_ENTR IN('T.P.R.N.', 'TPRN')
    )t
ON (a.ID_DOS = t.ID_DOS)
WHEN MATCHED THEN
UPDATE SET a.DOS_ENTR = 'TPRN';

COMMIT;

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAVE_TEMP_TA_GG_GEO;
END;
/