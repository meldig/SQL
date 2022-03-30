/*
-- Modification dans TA_GEO_CORRECT_DOUBLONS d'un ID_GEOM qui n'est plus dans TA_GG_GEO   
UPDATE GEO.TA_GEO_CORRECT_DOUBLONS a
SET a.ID_GEOM = 9426
WHERE a.objectid = 44;

-- Suppression d'un doublon de DOS_NUM (130090239) dans TA_GEO_CORRECT_DOUBLONS
DELETE 
FROM GEO.TA_GEO_CORRECT_DOUBLONS a
WHERE a.OBJECTID = 91;

-- Insertion de dossiers manquants dans TA_GEO_CORRECT_DOUBLONS
INSERT INTO GEO.TA_GEO_CORRECT_DOUBLONS(ID_GEOM, DOS_NUM, GEOM, ACTION)
SELECT
    a.ID_GEOM,
    a.DOS_NUM,
    a.GEOM,
    'fusionner'
FROM
    GEO.TA_GG_GEO a
WHERE
    a.ID_GEOM IN(
        2855,
        3800,
        3877,
        5091,
        5119,
        5165,
        5171,
        5470,
        5503,
        5519,
        5533,
        5736,
        5760,
        5846,
        6013,
        8539,
        8576,
        28658,
        28776
    );
*/
/* En cas de nouveaux doublons présents dans TA_GG_GEO proccédez comme suit :
1. Tous les doublons présents dans la même commune sont fusionnés ;
2. Les doublons présents sur des communes différentes doivent avoir leur propre dossier (il faut donc en créer) ;
3. En cas de doute, envoyez la liste des DOS_NUM posant problème à Gaëlle en lui demandant ce qu'il faut fusionner (cf. methodo_correction_et_migration_gestiongeo.mdown);
4. Une fois que vous avez reçu la lsite des DOS_NUM dont il faut fusionner les géométries, coller ces DOS_NUM dans le WHERE du MERGE ci-dessous en supprimant les valeurs déjà présentes dans le code ci-dessous.
*/
MERGE INTO GEO.TA_GEO_CORRECT_DOUBLONS a
    USING(
        WITH 
            C_1 AS(
                SELECT
                    MIN(a.ID_GEOM) AS ID_GEOM,
                    a.DOS_NUM
                FROM
                    GEO.TA_GG_GEO a
                WHERE
                    a.DOS_NUM = 226560179
                GROUP BY
                    a.DOS_NUM
                HAVING
                    COUNT(a.DOS_NUM) > 1
            )
            SELECT
                a.ID_GEOM,
                a.DOS_NUM,
                a.GEOM,
                'fusion' AS ACTION
            FROM
                GEO.TA_GG_GEO a,
                C_1 b
            WHERE
                a.ID_GEOM = b.ID_GEOM
        )t
    ON (a.ID_GEOM = t.ID_GEOM)
WHEN NOT MATCHED THEN
    INSERT(a.ID_GEOM, a.DOS_NUM, a.GEOM, a.ACTION)
    VALUES(t.ID_GEOM, t.DOS_NUM, t.GEOM, t.ACTION);