-- Procédure pour mettre à jour les Z des lignes de la table TA_RTGE_LINEAIRE_INTEGRATION.

/*
Cette procédure a pour objectif de remplacer la procédure RECUP_ALTI dans le cadre de l'intégration des dossiers de recolement en base.
Etape de la procédure:
    1. Conversion de la géométrie en WKT
    2. Extraction des sous éléments des géométrie en WKT
    3. Extraction des sommets des sous éléments
    4. Requete spatiale pour affecté à chaque sommet le Z du point topo le plus proche.
    5. Mise à zero de l'altitude du sommet si le point n'est pas situé sur un point topo ou s'il est situé sur deux point topo
    6. Regroupement des sommets par sous entité.
    7. Conversion en SDO_GEOM
    8. Union des sous element pour chaque ligne mère
    9. Mise à jour de la projection
    10. Mise à jour de la table TA_RTGE_LINEAIRE_INTEGRATION
*/


CREATE OR REPLACE PROCEDURE MISE_A_JOUR_Z_TA_RTGE_LINEAIRE_INTEGRATION(IDENTIFIANT_DOSSIER NUMBER)
IS
BEGIN
    -- 1. Insertion des données dans la table TA_GG_RECUPERATION_Z_ETAPE_1.
    -- geometrie de chaque ligne en type WKT
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1 a
    USING 
        (
        SELECT
            a.objectid AS OBJECTID_LIGNE,
            a.FID_NUMERO_DOSSIER,
            -- On remplace le '),' qui sépare chaque sous element par ');' afin de rendre plus aisé la séléction des sous éléments
            SUBSTR(
                   sdo_util.to_wktgeometry(SDO_CS.MAKE_2D(a.geom)),
                   1,
                   INSTR(sdo_util.to_wktgeometry(SDO_CS.MAKE_2D(a.geom)),'(',1)
                    ) TYPE_WKT_LIGNE_GEOMETRY,
        REPLACE(
            SUBSTR
                (
                -- parametre 1. chaine en entrée
                sdo_util.to_wktgeometry(SDO_CS.MAKE_2D(a.geom)),
                -- parametre 2. Caractere de départ: position du premier '(' inutile
                INSTR(sdo_util.to_wktgeometry(SDO_CS.MAKE_2D(a.geom)),'(',1)+1,
                -- parametre 3. Caractère de fin, taille de la sous chaine de travail
                LENGTH(
                        SUBSTR(
                                sdo_util.to_wktgeometry(SDO_CS.MAKE_2D(a.geom)),
                                INSTR(sdo_util.to_wktgeometry(SDO_CS.MAKE_2D(a.geom)),'(',1)+1))-1
                ),'), ',');'
                )GEOM
        FROM
            G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION a
        WHERE
            a.FID_NUMERO_DOSSIER = IDENTIFIANT_DOSSIER
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.FID_NUMERO_DOSSIER, a.TYPE_WKT_LIGNE_GEOMETRY, a.GEOM)
    VALUES(b.OBJECTID_LIGNE, b.FID_NUMERO_DOSSIER, b.TYPE_WKT_LIGNE_GEOMETRY, b.GEOM)
    ;

    -- 2. Insertion des données dans la table TA_GG_RECUPERATION_Z_ETAPE_2.
    -- Géométrie de chaque type en WKT. la colonne TYPE_WKT_LIGNE_GEOMETRY permet de savoir si la ligne est de type curviligne ou non. Utile pour recomposer la ligne à la fin du traitement
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE,
            ROWNUM as OBJECTID_ELEMENT_LIGNE,
            a.TYPE_WKT_LIGNE_GEOMETRY,
            substr(REGEXP_SUBSTR(GEOM,'[^;]+',1,level), 1, instr(REGEXP_SUBSTR(GEOM,'[^;]+',1,level),'(',1)) as TYPE_WKT_ELEMENT_GEOMETRY,
            CASE
                WHEN REGEXP_SUBSTR(GEOM,'[^;]+',1,level) NOT LIKE '%I%' THEN to_clob('LINESTRING (') || REGEXP_SUBSTR(GEOM,'[^;]+',1,level) || ')'
                ELSE REGEXP_SUBSTR(GEOM,'[^;]+',1,level)
            END as GEOM
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1 a
        CONNECT BY objectid_ligne = PRIOR objectid_ligne
        AND PRIOR SYS_GUID() IS NOT NULL
        AND LEVEL < REGEXP_COUNT(GEOM,'[^;]+')+1
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.TYPE_WKT_LIGNE_GEOMETRY, a.TYPE_WKT_ELEMENT_GEOMETRY, a.GEOM)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.TYPE_WKT_LIGNE_GEOMETRY, b.TYPE_WKT_ELEMENT_GEOMETRY, b.GEOM)
    ;


    -- TA_GG_RECUPERATION_Z_ETAPE_3
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3 a
    -- recreation de la geometrie de la ligne en type sdo_geom
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE,
            a.TYPE_WKT_ELEMENT_GEOMETRY,
            SDO_UTIL.FROM_WKTGEOMETRY(a.geom) as geom
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2 a
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.TYPE_WKT_ELEMENT_GEOMETRY, a.GEOM)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.TYPE_WKT_ELEMENT_GEOMETRY, b.GEOM)
    ;


    -- TA_GG_RECUPERATION_Z_ETAPE_4
    -- insertion de tous les sommets composant la ligne dans la table (sans le z)
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE as OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE as OBJECTID_ELEMENT_LIGNE,
            t.id as OBJECTID_SOMMET,
            t.X as COORD_X,
            t.Y as COORD_Y,
            t.Z as COORD_Z,
            SDO_GEOMETRY(2001, 2154,SDO_POINT_TYPE(t.X,t.Y,t.Z),NULL, NULL) as GEOM
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_3 a,
            TABLE
            (SDO_UTIL.GETVERTICES(a.geom)) t
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE
    AND a.OBJECTID_SOMMET = b.OBJECTID_SOMMET)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.OBJECTID_SOMMET, a.COORD_X, a.COORD_Y, a.COORD_Z, a.GEOM)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.OBJECTID_SOMMET, b.COORD_X, b.COORD_Y, b.COORD_Z, b.GEOM)
    ;



    -- TA_GG_RECUPERATION_Z_ETAPE_5
    -- Attention WHERE pour ne pas selectonner les sommets qui sont égaux à deux points topo
    -- selection pour chaque sommet de son altitude apporter par la table TA_PTTOPO_INTEGRATION dans le cas ou il ne superpose qu'avec un seul point topo.
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE AS OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE AS OBJECTID_ELEMENT_LIGNE,
            a.OBJECTID_SOMMET AS OBJECTID_SOMMET,
            a.COORD_X AS COORD_X,
            a.COORD_Y AS COORD_Y,
            b.ALT AS COORD_Z
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4 a
            LEFT JOIN 
                (
                    SELECT 
                        COUNT(OBJECTID_LIGNE), OBJECTID_LIGNE, OBJECTID_ELEMENT_LIGNE, OBJECTID_SOMMET 
                    FROM (
                            SELECT
                                a.OBJECTID_LIGNE AS OBJECTID_LIGNE,
                                a.OBJECTID_ELEMENT_LIGNE AS OBJECTID_ELEMENT_LIGNE,
                                a.OBJECTID_SOMMET AS OBJECTID_SOMMET,
                                a.COORD_X AS COORD_X,
                                a.COORD_Y AS COORD_Y,
                                b.ALT AS COORD_Z
                            FROM
                                G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4 a,
                                G_GESTIONGEO.TA_PTTOPO_INTEGRATION b
                            WHERE
                                b.FID_NUMERO_DOSSIER = IDENTIFIANT_DOSSIER
                                AND SDO_EQUAL(b.geom, a.geom) = 'TRUE'
                                )
                    GROUP BY OBJECTID_LIGNE, OBJECTID_ELEMENT_LIGNE, OBJECTID_SOMMET
                    HAVING COUNT(OBJECTID_LIGNE) >1
                )c
                ON a.OBJECTID_LIGNE = c.OBJECTID_LIGNE 
                AND a.OBJECTID_ELEMENT_LIGNE = c.OBJECTID_ELEMENT_LIGNE
                AND a.OBJECTID_SOMMET = c.OBJECTID_SOMMET,
                G_GESTIONGEO.TA_PTTOPO_INTEGRATION b
        WHERE
            b.FID_NUMERO_DOSSIER = IDENTIFIANT_DOSSIER
            AND SDO_EQUAL(b.geom, a.geom) = 'TRUE'
            AND c.OBJECTID_LIGNE IS NULL
            AND c.OBJECTID_ELEMENT_LIGNE IS NULL
            AND c.OBJECTID_SOMMET IS NULL
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE
    AND a.OBJECTID_SOMMET = b.OBJECTID_SOMMET)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.OBJECTID_SOMMET, a.COORD_X, a.COORD_Y, a.COORD_Z)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.OBJECTID_SOMMET, b.COORD_X, b.COORD_Y, b.COORD_Z)
    ;



    -- TA_GG_RECUPERATION_Z_ETAPE_6
    -- altitude = 0 pour tous les sommets qui ne se superpose pas à un point de la table TA_PTTOPO_INTEGRATION
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE AS OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE AS OBJECTID_ELEMENT_LIGNE,
            a.OBJECTID_SOMMET AS OBJECTID_SOMMET,
            a.COORD_X AS COORD_X,
            a.COORD_Y AS COORD_Y,
            0 AS COORD_Z
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4 a
            LEFT JOIN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5 b ON b.OBJECTID_LIGNE = a.OBJECTID_LIGNE
            AND b.OBJECTID_ELEMENT_LIGNE = a.OBJECTID_ELEMENT_LIGNE
            AND b.OBJECTID_SOMMET = a.OBJECTID_SOMMET
        WHERE 
            b.OBJECTID_LIGNE IS NULL
            AND b.OBJECTID_ELEMENT_LIGNE IS NULL
            AND b. OBJECTID_SOMMET  IS NULL
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE
    AND a.OBJECTID_SOMMET = b.OBJECTID_SOMMET)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.OBJECTID_SOMMET, a.COORD_X, a.COORD_Y, a.COORD_Z)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.OBJECTID_SOMMET, b.COORD_X, b.COORD_Y, b.COORD_Z)
    ;


    -- TA_GG_RECUPERATION_Z_ETAPE_7
    -- Union des sommets ayant une altitude ou non
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_7 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE AS OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE AS OBJECTID_ELEMENT_LIGNE,
            a.OBJECTID_SOMMET AS OBJECTID_SOMMET,
            a.COORD_X AS COORD_X,
            a.COORD_Y AS COORD_Y,
            a.COORD_Z AS COORD_Z
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5 a
        UNION
        SELECT
            a.OBJECTID_LIGNE as OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE AS OBJECTID_ELEMENT_LIGNE,
            a.OBJECTID_SOMMET AS OBJECTID_SOMMET,
            a.COORD_X AS COORD_X,
            a.COORD_Y AS COORD_Y,
            a.COORD_Z AS COORD_Z
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_6 a
        ORDER BY OBJECTID_LIGNE, OBJECTID_ELEMENT_LIGNE, OBJECTID_SOMMET ASC
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE
    AND a.OBJECTID_SOMMET = b.OBJECTID_SOMMET)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.OBJECTID_SOMMET, a.COORD_X, a.COORD_Y, a.COORD_Z)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.OBJECTID_SOMMET, b.COORD_X, b.COORD_Y, b.COORD_Z)
    ;


    -- TA_GG_RECUPERATION_Z_ETAPE_8
    -- conversion des sommets en type wkt
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE AS OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE AS OBJECTID_ELEMENT_LIGNE,
            a.OBJECTID_SOMMET AS OBJECTID_SOMMET,
            SUBSTR
                (
                sdo_util.to_wktgeometry(SDO_GEOMETRY(3001, 2154,SDO_POINT_TYPE(a.coord_x,a.coord_y,a.coord_z),NULL, NULL)),
                INSTR(sdo_util.to_wktgeometry(SDO_GEOMETRY(3001, 2154,SDO_POINT_TYPE(a.coord_x,a.coord_y,a.coord_z),NULL, NULL)),'(',1)+1,
                LENGTH(
                        SUBSTR(
                                sdo_util.to_wktgeometry(SDO_GEOMETRY(3001, 2154,SDO_POINT_TYPE(a.coord_x,a.coord_y,a.coord_z),NULL, NULL)),
                                INSTR(sdo_util.to_wktgeometry(SDO_GEOMETRY(3001, 2154,SDO_POINT_TYPE(a.coord_x,a.coord_y,a.coord_z),NULL, NULL)),'(',1)+1
                                ))-1
                )GEOM
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_7 a
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE
    AND a.OBJECTID_SOMMET = b.OBJECTID_SOMMET)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.OBJECTID_SOMMET, a.GEOM)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.OBJECTID_SOMMET, b.GEOM)
    ;


    -- TA_GG_RECUPERATION_Z_ETAPE_9
    -- enchainement des sommets sur ligne avant conversion en sdo_geom
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE as OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE as OBJECTID_ELEMENT_LIGNE,
            LISTAGG (a.geom, ',') WITHIN GROUP (ORDER BY a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.objectid_sommet) AS GEOM
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_8 a
        GROUP BY
            a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.GEOM)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.GEOM)
    ;


    -- TA_GG_RECUPERATION_Z_ETAPE_10
    -- reconstitution de la chaine WKT complete avec le type de ligne et conversion en sdo_geom
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE AS OBJECTID_LIGNE,
            a.OBJECTID_ELEMENT_LIGNE AS OBJECTID_ELEMENT_LIGNE,
            CASE 
                WHEN TRIM(CAST(a.TYPE_WKT_ELEMENT_GEOMETRY as VARCHAR2(4000))) is null
                    THEN SDO_UTIL.FROM_WKTGEOMETRY(a.TYPE_WKT_LIGNE_GEOMETRY || TRIM(CAST(b.geom as VARCHAR2(4000))) || ')')
                ELSE
                    SDO_UTIL.FROM_WKTGEOMETRY(a.TYPE_WKT_ELEMENT_GEOMETRY || TRIM(CAST(b.geom as VARCHAR2(4000))) || ')')
                END GEOM
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_2 a 
            INNER JOIN G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_9 b 
                                                        ON a.objectid_ligne = b.objectid_ligne 
                                                        AND a.objectid_element_ligne = b.objectid_element_ligne
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
    AND a.OBJECTID_ELEMENT_LIGNE = b.OBJECTID_ELEMENT_LIGNE)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.OBJECTID_ELEMENT_LIGNE, a.GEOM)
    VALUES(b.OBJECTID_LIGNE, b.OBJECTID_ELEMENT_LIGNE, b.GEOM)
    ;


    -- TA_GG_RECUPERATION_Z_ETAPE_11
    MERGE INTO G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11 a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE,
            b.FID_NUMERO_DOSSIER,
            SDO_AGGR_UNION(SDOAGGRTYPE(a.geom, 0.001)) AS GEOM
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_10 a,
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_1 b
        WHERE
            a.OBJECTID_LIGNE = b.OBJECTID_LIGNE
        GROUP BY
            a.OBJECTID_LIGNE,b.FID_NUMERO_DOSSIER
        )b
    ON (a.OBJECTID_LIGNE = b.OBJECTID_LIGNE)
    WHEN NOT MATCHED THEN 
    INSERT(a.OBJECTID_LIGNE, a.FID_NUMERO_DOSSIER, a.GEOM)
    VALUES(b.OBJECTID_LIGNE, b.FID_NUMERO_DOSSIER, b.GEOM)
    ;

    -- Mise à jour du système de projection des géométrie avant la mise à jour de la table TA_RTGE_LINEAIRE_INTEGRATION
    UPDATE G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11 a
    SET a.GEOM.SDO_SRID = 2154
    WHERE a.GEOM IS NOT NULL
    ;

    -- Insertion des nouvelles géométries dans la table TA_RTGE_LINEAIRE_INTEGRATION
    MERGE INTO G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION a
    USING 
        (
        SELECT
            a.OBJECTID_LIGNE AS OBJECTID,
            a.FID_NUMERO_DOSSIER AS FID_NUMERO_DOSSIER,
            a.GEOM AS GEOM
        FROM
            G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_11 a
        )b
    ON (a.OBJECTID = b.OBJECTID
    AND a.FID_NUMERO_DOSSIER = b.FID_NUMERO_DOSSIER)
    WHEN MATCHED THEN UPDATE SET a.GEOM = b.GEOM
    ;

COMMIT;

END MISE_A_JOUR_Z_TA_RTGE_LINEAIRE_INTEGRATION;

/
