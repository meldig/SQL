SET SERVEROUTPUT ON
DECLARE
    v_dos_num NUMBER(38,0);
BEGIN
SAVEPOINT POINT_SAVE_TEMP_TA_GG_GEO;

-- 1. Suppression des polygones à supprimer de TEMP_TA_GG_GEO
DELETE
FROM 
    GEO.TEMP_TA_GG_GEO a
WHERE
    a.ID_GEOM IN(38085, 43040, 40317, 38084, 38579);

/* 
-- 2. Correction des erreurs de géométries
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

-- 3. Fusion des polygones de TEMP_TA_GG_GEO disposant du même DOS_NUM (appartenant donc au même dossier)
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

-- 4. Suppression des entités ayant servi à la fusion, sauf celles dont la géométrie a été mise à jour par la requête précédente (cf. point 4).
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

-- 5. Création d'un nouveau dossier dans TEMP_TA_GG_DOSSIER. Ce dossier correspondra à l'un des deux périmètres présents dans TEMP_TA_GG_GEO dont le DOS_NUM = 213500004, mais étant présents sur deux communes différentes.
/*SELECT
    MAX(ID_DOS) + 1
FROM
    GEO.TEMP_TA_GG_DOSSIER;*/
-- 5.1. Création du DOS_NUM pour l'insertion d'un nouveau dossier
WITH
    C_1 AS(
        SELECT
            COUNT(a.ID_DOS) AS decompte
        FROM
            GEO.TEMP_TA_GG_DOSSIER a
        WHERE
            SUBSTR(TRUNC(a.DOS_DC, 'YEAR'), 7, 2) = SUBSTR(TRUNC(sysdate, 'YEAR'), 7, 2)
    ),

    C_2 AS(
        SELECT DISTINCT
            SUBSTR(TRUNC(sysdate, 'YEAR'), 7, 2) AS annee,
            SUBSTR(a.DOS_INSEE, 3,3) AS insee,
            CASE
                WHEN b.decompte >= 1000
                    THEN TO_CHAR(b.decompte)
                WHEN b.decompte >= 100
                    THEN '0'||TO_CHAR(b.decompte)
                WHEN b.decompte < 100
                    THEN '00'||TO_CHAR(b.decompte)
            END AS nbr_dossiers
        FROM
            GEO.TEMP_TA_GG_DOSSIER a,
            C_1 b
        WHERE
            a.DOS_NUM = 213500004
    )
    
    SELECT
        TO_NUMBER(annee||insee||nbr_dossiers, 999999999) AS DOS_NUM
        INTO v_dos_num
    FROM
        C_2;

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
    59328,
    a.DOS_VOIE,
    a.DOS_MAO,
    a.DOS_ENTR,
    a.ORDER_ID,
    v_dos_num,
    a.DOS_OLD_ID,
    a.DOS_DT_DEB_LEVE,
    a.DOS_DT_FIN_LEVE,
    a.DOS_DT_PREV,
    'IC/213500004_59350_avenue_leon_jouhaux/'
FROM
    GEO.TEMP_TA_GG_DOSSIER a
WHERE
    a.DOS_NUM = 213500004;

-- 5.2. Mise à jour de l'ID_DOS du périmètre dont le DOS_NUM = 213500004;
MERGE INTO GEO.TEMP_TA_GG_GEO a
    USING(
            SELECT
                b.ID_DOS,
                b.DOS_NUM
            FROM
                GEO.TEMP_TA_GG_DOSSIER b
            WHERE
                b.DOS_NUM = v_dos_num
        )t
ON (a.ID_GEOM = 46477)
WHEN MATCHED THEN
    UPDATE 
        SET a.ID_DOS = t.ID_DOS, a.DOS_NUM = t.DOS_NUM;

-- 6. Correction des faux doublons du champ DOS_ENTR de la table TEMP_TA_GG_DOSSIER
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

-- 7. Gestion des Pnoms des agents
-- 7.1. Harmonisation des pnoms de la table TA_GG_SOURCE
/*MERGE INTO GEO.TA_GG_SOURCE a
    USING(
            SELECT
                b.SRC_ID,
                CASE
                    WHEN b.SRC_ID = 34755
                        THEN 'acoupez'
                    WHEN b.SRC_ID = 38332
                        THEN 'chleclercq'
                    WHEN b.SRC_ID = 22917
                        THEN 'fnaerhuysen'
                    WHEN b.SRC_ID = 47280
                        THEN 'obecquaert'
                    WHEN b.SRC_ID = 34774
                        THEN 'pmartin'
                    WHEN b.SRC_ID = 28129
                        THEN 'pvanberselaert'
                    WHEN b.SRC_ID = 29916
                        THEN 'yaube'
                    WHEN b.SRC_ID = 196860
                        THEN 'fmorealle'
                END AS SRC_LIBEL
            FROM
                GEO.TA_GG_SOURCE b
            WHERE
                b.SRC_ID IN(34755, 38332, 22917, 47280, 34774, 28129, 29916, 196860)
            UNION ALL
            SELECT
                a.SRC_ID,
                LOWER(a.SRC_LIBEL) AS SRC_LIBEL
            FROM
                GEO.TA_GG_SOURCE a
            WHERE
                a.SRC_ID NOT IN(34755, 38332, 22917, 47280, 34774, 28129, 29916, 196860)
            )t
    ON (a.SRC_ID = t.SRC_ID)
WHEN MATCHED THEN
    UPDATE SET a.SRC_LIBEL = t.SRC_LIBEL;

-- 7.2. Ajout d'agents dans la table TA_GG_SOURCE
INSERT INTO GEO.TA_GG_SOURCE(src_id, src_libel, src_val)
VALUES(6068, 'rjault', 1);
INSERT INTO GEO.TA_GG_SOURCE(src_id, src_libel, src_val)
VALUES(5741, 'bjacq', 1);*/

-- 8. Correction des valeurs du champ TA_GG_DOSSIER.USER_ID absentes de TA_GG_SOURCE. Cette erreur est due à l'obsolescence de DynMap qui créé de lui-même un identifiant absent de TA_GG_SOURCE et ne désignant donc aucun utilisateur.
MERGE INTO GEO.TEMP_TA_GG_DOSSIER a
USING(
    SELECT
        id_dos,
        src_id,
        user_id
    FROM
        GEO.TEMP_TA_GG_DOSSIER
    WHERE
        user_id NOT IN(SELECT src_id FROM GEO.TA_GG_SOURCE)
)t
ON(a.id_dos = t.id_dos)
WHEN MATCHED THEN
    UPDATE SET a.user_id = t.src_id;
COMMIT;

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute insertion de se faire et de retourner à l'état des tables précédent l'insertion.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAVE_TEMP_TA_GG_GEO;
END;

/
