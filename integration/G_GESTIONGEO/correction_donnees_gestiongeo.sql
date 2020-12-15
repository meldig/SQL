-- Modification dans TA_GEO_CORRECT_DOUBLONS d'un ID_GEOM qui n'est plus dans TA_GG_GEO   
UPDATE GEO.TA_GEO_CORRECT_DOUBLONS a
SET a.ID_GEOM = 9426
WHERE a.objectid = 44;
COMMIT;

-- Suppression d'un doublon de DOS_NUM (130090239) dans TA_GEO_CORRECT_DOUBLONS
DELETE 
FROM GEO.TA_GEO_CORRECT_DOUBLONS a
WHERE a.OBJECTID = 91;

/* Correction des erreurs de géométrie dans TEMP_GEO_CORRECTION via SDO_UTIL.RECTIFY_GEOMETRY
Rappel - les erreurs que cette fonction corrige sont :
- 13349 : le polygone l'intersecte lui-même ;
- 13356 : le polygone a des sommets redondants ;
- 13367 : les anneaux intérieurs et/ou extérieurs ont une mauvaise orientation ;

UPDATE GEO.TEMP_GEO_CORRECTION a
SET a.GEOM = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(
        SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 
        0, 
        5
    ) IN ('13349', '13356', '13367')
    AND SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005).SDO_GTYPE IN(2003, 2007)
    AND SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(
            SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005),
            0.005
        ) = 'TRUE';
*/
-- Correction d'une partie des goémétries posant problème pour la fusion du dossier 186500311   
UPDATE GEO.TEMP_GEO_CORRECTION a
SET a.GEOM = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    a.ID_GEOM IN(12575, 12645, 12689, 12585);

-- Fusion des polygones d'un même dossier
MERGE INTO GEO.TEMP_GEO_CORRECTION a
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
                    INNER JOIN GEO.TEMP_GEO_CORRECTION b ON b.ID_GEOM = a.ID_GEOM
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
                                        --186500311,
                                        153780097,
                                        163780407,
                                        161630711
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
                GEO.TEMP_GEO_CORRECTION b
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
    GEO.TEMP_GEO_CORRECTION a
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
                                        --186500311,
                                        153780097,
                                        163780407,
                                        161630711
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
                                        --186500311,
                                        153780097,
                                        163780407,
                                        161630711
                                    )
                                
                        )
;


-- Passage de certains dossiers/périmètres en clôturés
-- Résultats attendus : 4 lignes éditées
UPDATE GEO.TEMP_GEO_CORRECTION a
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

-- Suppression des polygones à supprimer de TEMP_GEO_CORRECTION
DELETE
FROM 
    GEO.TEMP_GEO_CORRECTION a
WHERE
    a.ID_GEOM IN(4547, 85);


-- Vérification ds doublons
SELECT
    a.dos_num
FROM
    TEMP_GEO_CORRECTION a
WHERE
    a.DOS_NUM <> 186500311
GROUP BY a.dos_num
HAVING
    COUNT(a.dos_num) > 1;
    
SELECT *
FROM
    TA_GEO_CORRECT_DOUBLONS
WHERE
    DOS_NUM IN(
        161430214,
101960145,
102860526,
103280549,
103030163,
203600428,
170090076,
163280679,
163281074,
103160408,
102020497,
102860525,
105530454,
103500394,
103280411,
153600258,
161961077,
103430570,
102860124,
102860531,
102560032,
206480421,
162200383,
130090239
    );
    