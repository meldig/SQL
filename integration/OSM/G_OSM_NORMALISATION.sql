-- MISE EN FORME DES DONNEES OSM EN BASE

-- 1. UNPIVOT DE LA TABLE DES DONNEES OSM MULTIPOLYGON: TEMP_OSM_MULTIPOLYGONE DANS LA TABLE TEMP_OSM_UNPIVOT_MULTIPOLYGONE.

SET SERVEROUTPUT ON
DECLARE
    chaine VARCHAR2(20000);
    
BEGIN
    FOR i IN (SELECT column_name FROM USER_TAB_COLUMNS WHERE table_name = 'TEMP_OSM_MULTIPOLYGONE' AND DATA_TYPE = 'VARCHAR2') LOOP
        IF i.column_name <> 'OTHER_TAGS' THEN
            chaine := TRIM('' || chaine || '"' || i.column_name || '"' || ''|| ',' || CHR(10));
        END IF;
    END LOOP;

-- EXECUTION DE LA REQUETE
EXECUTE IMMEDIATE '
    CREATE TABLE G_OSM.TEMP_OSM_UNPIVOT_MULTIPOLYGONE AS  
    SELECT
        OBJECTID,
        KEY,
        VALEUR
    FROM
        G_OSM.TEMP_OSM_MULTIPOLYGONE
    UNPIVOT
        (valeur for (KEY) IN
        ('||
        -- soustraction de la chaine pour les deux derniers caractères, la dernière virgule et le dernier saut de ligne
            SUBSTR(chaine, 0,length(chaine) - 2)
        || '))
    ';

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
END;
/


-- 2. UNPIVOT DE LA TABLE DES DONNEES OSM POINT: TEMP_OSM_POINT DANS LA TABLE TEMP_OSM_UNPIVOT_POINT.
SET SERVEROUTPUT ON
DECLARE
    chaine VARCHAR2(20000);
    
BEGIN
    FOR i IN (SELECT column_name FROM USER_TAB_COLUMNS WHERE table_name = 'TEMP_OSM_POINT' AND DATA_TYPE = 'VARCHAR2') LOOP
        IF i.column_name <> 'OTHER_TAGS' THEN
            chaine := TRIM('' || chaine || '"' || i.column_name || '"' || ''|| ',' || CHR(10));
        END IF;
    END LOOP;

-- EXECUTION DE LA REQUETE
EXECUTE IMMEDIATE '
    CREATE TABLE G_OSM.TEMP_OSM_UNPIVOT_POINT AS  
    SELECT
        OBJECTID,
        KEY,
        VALEUR
    FROM
        G_OSM.TEMP_OSM_POINT
    UNPIVOT
        (valeur for (KEY) IN
        ('||
        -- soustraction de la chaine pour les deux derniers caractères, la dernière virgule et le dernier saut de ligne
            SUBSTR(chaine, 0,length(chaine) - 2)
        || '))
    ';

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
END;
/


-- 3. MISE A JOUR DE LA TABLE TA_METADONNEE

-- 3.1. Insertion du millésime, date d'insertion et nom de l'obtenteur des données dans TA_DATE_ACQUISITION;
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
    USING(
        SELECT 
            TO_DATE(sysdate, 'dd/mm/yy') AS date_insertion, 
            '01/01/' || (EXTRACT(YEAR FROM sysdate)-1) AS date_millesime,
            sys_context('USERENV','OS_USER') AS nom_obtenteur 
        FROM DUAL
    )t
    ON (
            a.date_acquisition = t.date_insertion 
            AND a.millesime = t.date_millesime
            AND a.nom_obtenteur = t.nom_obtenteur
        )
WHEN NOT MATCHED THEN
    INSERT (a.date_acquisition, a.millesime, a.nom_obtenteur)
    VALUES(t.date_insertion, t.date_millesime, t.nom_obtenteur);


-- 3.2. Insertion de la provenance des données dans TA_PROVENANCE;

MERGE INTO G_GEO.TA_PROVENANCE a
    USING(
        SELECT 
            'http://download.geofabrik.de/europe/france/nord-pas-de-calais.html' AS url,
            'La base de données OPEN STREET MAP est un projet collaboratif de cartographie en ligne qui vise à constituer une base de données géographiques libre du monde. Les données sont diffusées sous la licence ODbL. Les données OSM ont donc été téléchargée depuis le site de de GEOFABRIK, sans demande préalable.' AS methode
        FROM
            DUAL
    )t
    ON(
        a.url = t.url AND a.methode_acquisition = t.methode
    )
WHEN NOT MATCHED THEN
    INSERT(a.url, a.methode_acquisition)
    VALUES(t.url, t.methode);


-- 3.3. Insertion de la provenance des données dans TA_PROVENANCE;

MERGE INTO G_GEO.TA_SOURCE a
    USING(
        SELECT 
            'OSM' AS nom_source, 
            'OpenStreetMap (OSM) est un projet collaboratif de cartographie en ligne qui vise à constituer une base de données géographiques libre du monde' AS description
        FROM DUAL
    )t
    ON (
            a.nom_source = t.nom_source 
            AND a.description = t.description
        )
WHEN NOT MATCHED THEN
    INSERT (a.nom_source, a.description)
    VALUES(t.nom_source, t.description);

-- 3.4. Insertion des données dans G_GEO.TA_ORGANISME

MERGE INTO G_GEO.TA_ORGANISME a
USING
	(
		SELECT 'Geofabrik' AS NOM_ORGANISME FROM DUAL
	) b
ON (a.nom_organisme = b.nom_organisme)
WHEN NOT MATCHED THEN
INSERT (a.nom_organisme)
VALUES(b.nom_organisme)
;

-- 3.5. Insertion des clés étrangères dans la table pivot TA_METADONNEE;

MERGE INTO G_GEO.TA_METADONNEE a
    USING(
        SELECT 
            b.objectid AS fid_source,
            c.objectid AS fid_acquisition,
            d.objectid AS fid_provenance
        FROM
            G_GEO.TA_SOURCE b,
            G_GEO.TA_DATE_ACQUISITION c,
            G_GEO.TA_PROVENANCE d
        WHERE
            UPPER(b.nom_source) = UPPER('OSM')
            AND c.millesime = (SELECT '01/01/' || (EXTRACT(YEAR FROM sysdate)-1) AS Annee FROM DUAL)
            AND c.nom_obtenteur = sys_context('USERENV','OS_USER')
            AND d.url = 'http://download.geofabrik.de/europe/france/nord-pas-de-calais.html'
            AND d.methode_acquisition = 'La base de données OPEN STREET MAP est un projet collaboratif de cartographie en ligne qui vise à constituer une base de données géographiques libre du monde. Les données sont diffusées sous la licence ODbL. Les données OSM ont donc été téléchargée depuis le site de de GEOFABRIK, sans demande préalable.'
    )t
    ON(
        a.fid_source = t.fid_source 
        AND a.fid_acquisition = t.fid_acquisition
        AND a.fid_provenance = t.fid_provenance
    )
WHEN NOT MATCHED THEN
    INSERT(a.fid_source, a.fid_acquisition, a.fid_provenance)
    VALUES(t.fid_source, t.fid_acquisition, t.fid_provenance);


-- 3.6. Insertion des clés étrangères dans la table pivot TA_METADONNEE;

MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
USING
    (
        SELECT
            b.objectid AS fid_metadonnee,
            f.objectid AS fid_organisme
        FROM
            G_GEO.TA_METADONNEE b
            INNER JOIN G_GEO.TA_SOURCE c ON c.objectid = b.fid_source
            INNER JOIN G_GEO.TA_DATE_ACQUISITION d ON d.objectid = b.fid_acquisition
            INNER JOIN G_GEO.TA_PROVENANCE e ON e.objectid = b.fid_provenance,
            G_GEO.TA_ORGANISME f
        WHERE
            c.nom_source = 'OSM'
		AND d.millesime = (SELECT '01/01/' || (EXTRACT(YEAR FROM sysdate)-1) AS Annee FROM DUAL)
		AND d.nom_obtenteur = sys_context('USERENV','OS_USER')
        AND e.url = 'http://download.geofabrik.de/europe/france/nord-pas-de-calais.html'
        AND e.methode_acquisition = 'La base de données OPEN STREET MAP est un projet collaboratif de cartographie en ligne qui vise à constituer une base de données géographiques libre du monde. Les données sont diffusées sous la licence ODbL. Les données OSM ont donc été téléchargée depuis le site de de GEOFABRIK, sans demande préalable.'
        AND f.nom_organisme IN ('Geofabrik')
    )b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_organisme = b.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(b.fid_metadonnee, b.fid_organisme)
;

-- 4. INSERTION DES DONNEES MULTIPOLYGONE DANS LA TABLE TA_OSM

MERGE INTO G_OSM.TA_OSM a
USING
    (
    SELECT
        b.objectid AS objectid,
        c.objectid AS fid_metadonnee
    FROM
        G_OSM.TEMP_MULTIPOLYGONE_OSM b,
        G_GEO.TA_METADONNEE c
        INNER JOIN G_GEO.ta_source d ON d.objectid = c.fid_source
        INNER JOIN G_GEO.ta_date_acquisition e ON e.objectid = c.fid_acquisition
        INNER JOIN G_GEO.ta_provenance f ON f.objectid = c.fid_provenance
        INNER JOIN G_GEO.ta_metadonnee_relation_organisme g ON g.fid_metadonnee = c.objectid
        INNER JOIN G_GEO.ta_organisme h ON h.objectid = g.fid_organisme
    WHERE
            d.nom_source = 'OSM'
        AND e.millesime = (SELECT '01/01/' || (EXTRACT(YEAR FROM sysdate)-1) AS Annee FROM DUAL)
        AND e.nom_obtenteur = sys_context('USERENV','OS_USER')
        AND f.url = 'http://download.geofabrik.de/europe/france/nord-pas-de-calais.html'
        AND f.methode_acquisition = 'La base de données OPEN STREET MAP est un projet collaboratif de cartographie en ligne qui vise à constituer une base de données géographiques libre du monde. Les données sont diffusées sous la licence ODbL. Les données OSM ont donc été téléchargée depuis le site de de GEOFABRIK, sans demande préalable.'
        AND h.nom_organisme IN ('Geofabrik')
    )b
ON (a.objectid = b.objectid
AND a.fid_metadonnee = b.fid_metadonnee)
WHEN NOT MATCHED THEN
INSERT (a.objectid, a.fid_metadonnee)
VALUES (b.objectid, b.fid_metadonnee)
;


-- 5. INSERTION DES DONNEES POINTS DANS LA TABLE TA_OSM

MERGE INTO G_OSM.TA_OSM a
USING
    (
    SELECT
        b.objectid AS objectid,
        c.objectid AS fid_metadonnee
    FROM
        G_OSM.TEMP_POINTS_OSM b,
        G_GEO.TA_METADONNEE c
        INNER JOIN G_GEO.ta_source d ON d.objectid = c.fid_source
        INNER JOIN G_GEO.ta_date_acquisition e ON e.objectid = c.fid_acquisition
        INNER JOIN G_GEO.ta_provenance f ON f.objectid = c.fid_provenance
        INNER JOIN G_GEO.ta_metadonnee_relation_organisme g ON g.fid_metadonnee = c.objectid
        INNER JOIN G_GEO.ta_organisme h ON h.objectid = g.fid_organisme
    WHERE
            d.nom_source = 'OSM'
        AND e.millesime = (SELECT '01/01/' || (EXTRACT(YEAR FROM sysdate)-1) AS Annee FROM DUAL)
        AND e.nom_obtenteur = sys_context('USERENV','OS_USER')
        AND f.url = 'http://download.geofabrik.de/europe/france/nord-pas-de-calais.html'
        AND f.methode_acquisition = 'La base de données OPEN STREET MAP est un projet collaboratif de cartographie en ligne qui vise à constituer une base de données géographiques libre du monde. Les données sont diffusées sous la licence ODbL. Les données OSM ont donc été téléchargée depuis le site de de GEOFABRIK, sans demande préalable.'
        AND h.nom_organisme IN ('Geofabrik')
    )b
ON (a.objectid = b.objectid
AND a.fid_metadonnee = b.fid_metadonnee)
WHEN NOT MATCHED THEN
INSERT (a.objectid, a.fid_metadonnee)
VALUES (b.objectid, b.fid_metadonnee)
;


-- 6. INSERTION DES DONNEES DANS LA TABLE TA_OSM_GEOM

INSERT INTO G_OSM.TA_OSM_GEOM(GEOM)
SELECT
    GEOM
FROM
    G_OSM.TEMP_OSM_MULTIPOLYGONE
-- Sous requete dans le WHERE pour n'insérer que les nouvelles géométrie pas encore présente dans la table
WHERE
    objectid not IN
        (
        SELECT
            a.objectid
        FROM
            G_OSM.TEMP_OSM_MULTIPOLYGONE a,
            G_OSM.TA_OSM_GEOM b
        WHERE
            ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(a.GEOM)))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(b.GEOM))))
        )
;


-- 7. INSERTION DES DONNES DANS LA TABLE TA_OSM_POINT_GEOM

INSERT INTO G_OSM.TA_OSM_POINT_GEOM(GEOM)
SELECT 
    GEOM
FROM
    G_OSM.TEMP_OSM_POINT a
-- le WHERE permet de selectionner uniquement les géométries uniques et non les doublons
WHERE
    OBJECTID NOT IN
        (SELECT OBJECTID_b
            FROM
                (SELECT
                        a.OBJECTID AS OBJECTID_a,
                        b.OBJECTID AS OBJECTID_b
                    FROM
                        G_OSM.TEMP_OSM_POINT a,
                        G_OSM.TEMP_OSM_POINT b
                    WHERE
                        a.OBJECTID < b.OBJECTID
                    AND
                        ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(a.GEOM))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(b.GEOM)))
                    AND
                        a.GEOM IS NOT NULL
                    AND
                        b.GEOM IS NOT NULL
                )
        )
-- le AND permet de ne pas insérer des géométrie déja existante dans la table.
AND
    OBJECTID not IN
        (SELECT
            a.OBJECTID
        FROM
            G_OSM.TEMP_OSM_POINT a,
            G_OSM.TA_OSM_POINT_GEOM b
        WHERE
            ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(a.GEOM))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(b.GEOM)))
        AND
            a.GEOM IS NOT NULL
        AND
            b.GEOM IS NOT NULL
            );

-- 8. INSERTION DES DONNEES DANS LA TABLE TA_OSM_RELATION_POINT_GEOM

MERGE INTO TA_OSM_RELATION_POINT_GEOM a
USING
    (
    SELECT
        a.objectid AS fid_osm,
        b.objectid AS fid_osm_point_geom
    FROM
        G_OSM.TEMP_OSM_POINT a,
        G_OSM.TA_OSM_POINT_GEOM b
    WHERE
        ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(a.GEOM))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(b.GEOM)))
    )b
ON (a.fid_osm = b.fid_osm
AND a.fid_osm_point_geom = b.fid_osm_point_geom)
WHEN NOT MATCHED THEN
INSERT (a.fid_osm, a.fid_osm_point_geom)
VALUES (b.fid_osm, b.fid_osm_point_geom)
;

-- 9. INSERTION DES DONNEES DANS LA TABLE TA_OSM_RELATION_GEOM

MERGE INTO TA_OSM_RELATION_GEOM a
USING
    (
    SELECT
        a.objectid AS fid_osm,
        b.objectid AS fid_osm_geom
    FROM
        G_OSM.TEMP_OSM_MULTIPOLYGONE a,
        G_OSM.TA_OSM_GEOM b
    WHERE
        ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(a.GEOM)))) = ORA_HASH(TO_CHAR(SDO_UTIL.TO_WKTGEOMETRY(SDO_GEOM.SDO_CENTROID(b.GEOM))))
    )b
ON (a.fid_osm = b.fid_osm
AND a.fid_osm_geom = b.fid_osm_geom)
WHEN NOT MATCHED THEN
INSERT (a.fid_osm, a.fid_osm_geom)
VALUES (b.fid_osm, b.fid_osm_geom)
;

-- 10. INSERTION DES DONNEES DANS LA TABLE TA_OSM_CARACTERISTIQUE_QUANTITATIVE

MERGE INTO G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE a
USING
    (
    SELECT
        DISTINCT    
        b.objectid AS FID_OSM,
        b.key AS KEY,
        CAST(b.valeur AS NUMBER(38))AS VALEUR
    FROM
        G_OSM.TEMP_OSM_UNPIVOT_MULTIPOLYGONE b
    WHERE
        REGEXP_LIKE(b.VALEUR,'^[0-9]+$')
    )c
ON (a.FID_OSM = c.FID_OSM
AND a.KEY = c.KEY
AND a.VALEUR = c.VALEUR)
WHEN NOT MATCHED THEN
INSERT (a.FID_OSM, a.KEY, a.VALEUR)
VALUES (c.FID_OSM, c.KEY, c.VALEUR)
;

-- 11. INSERTION DES DONNEES DANS LA TABLE TA_OSM_CARACTERISTIQUE_QUANTITATIVE

MERGE INTO TA_OSM_CARACTERISTIQUE a
USING
    (
    SELECT
        DISTINCT
        b.objectid AS FID_OSM,
        b.key AS KEY,
        b.valeur AS VALEUR
    FROM
        G_OSM.TEMP_OSM_UNPIVOT_MULTIPOLYGONE b
    WHERE
        b.valeur not in
            (
                SELECT 
                    c.valeur
                FROM 
                    TEMP_OSM_UNPIVOT_MULTIPOLYGONE c
                WHERE
                    REGEXP_LIKE(c.VALEUR,'^[0-9]+$')
            )
    )d
ON (a.FID_OSM = d.FID_OSM
AND a.KEY = d.KEY
AND a.VALEUR = d.VALEUR)
WHEN NOT MATCHED THEN
INSERT (a.FID_OSM, a.KEY, a.VALEUR)
VALUES (d.FID_OSM, d.KEY, d.VALEUR)
;




-- 12. INSERTION DES DONNEES DANS LA TABLE TA_OSM_CARACTERISTIQUE_QUANTITATIVE POUR LES POINTS

MERGE INTO G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE a
USING
    (
    SELECT
        DISTINCT    
        b.objectid AS FID_OSM,
        b.key AS KEY,
        CAST(b.valeur AS NUMBER(38))AS VALEUR
    FROM
        G_OSM.TEMP_OSM_UNPIVOT_POINT b
    WHERE
        REGEXP_LIKE(b.VALEUR,'^[0-9]+$')
    )c
ON (a.FID_OSM = c.FID_OSM
AND a.KEY = c.KEY
AND a.VALEUR = c.VALEUR)
WHEN NOT MATCHED THEN
INSERT (a.FID_OSM, a.KEY, a.VALEUR)
VALUES (c.FID_OSM, c.KEY, c.VALEUR)
;

-- 13. INSERTION DES DONNEES DANS LA TABLE TA_OSM_CARACTERISTIQUE

MERGE INTO TA_OSM_CARACTERISTIQUE a
USING
    (
    SELECT
        DISTINCT
        b.objectid AS FID_OSM,
        b.key AS KEY,
        b.valeur AS VALEUR
    FROM
        G_OSM.TEMP_OSM_UNPIVOT_POINT b
    WHERE
        b.valeur not in
            (
                SELECT 
                    c.valeur
                FROM 
                    G_OSM.TEMP_OSM_UNPIVOT_POINT c
                WHERE
                    REGEXP_LIKE(c.VALEUR,'^[0-9]+$')
            )
    )d
ON (a.FID_OSM = d.FID_OSM
AND a.KEY = d.KEY
AND a.VALEUR = d.VALEUR)
WHEN NOT MATCHED THEN
INSERT (a.FID_OSM, a.KEY, a.VALEUR)
VALUES (d.FID_OSM, d.KEY, d.VALEUR)
;