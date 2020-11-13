/*
Requêtes SQL utilisées pour normaliser les données issues de la base historique des populations communales. Recensements de la population 1876-2017.
Cette base fournit les données de populations de 1876 à 2017 pour les communes de France continentale, de 1936 à 2017 pour les communes de Corse et de 1954 ou 1962 à 2017 pour les communes des DOM (hors Mayotte).
*/


-- Insertion des données dans la table G_GEO.TA_RECENSEMENT
MERGE INTO G_GEO.TA_RECENSEMENT a
-- CTE pour selectionner les différentes metadonnees suivant le millesime du recensement
USING
    (
    WITH
        annee AS (
            SELECT
                a.objectid,
                b.millesime
            FROM
                G_GEO.TA_METADONNEE a
            INNER JOIN G_GEO.TA_DATE_ACQUISITION b ON a.fid_acquisition = b.objectid
            INNER JOIN G_GEO.TA_SOURCE c ON a.fid_source = c.objectid
            INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid
            INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME e ON a.objectid = e.fid_metadonnee
            INNER JOIN G_GEO.TA_ORGANISME f ON e.fid_organisme = f.objectid
            WHERE
                b.date_acquisition = TO_DATE(SYSDATE,'dd/mm/yy')
            AND b.millesime BETWEEN '01/01/1876' AND '01/01/2017'
            AND b.nom_obtenteur = SYS_CONTEXT('USERENV','OS_USER')
            AND UPPER(c.nom_source) = UPPER('Recensements de la population 1876-2017')
            AND UPPER(d.url) = UPPER('https://www.insee.fr/fr/statistiques/3698339#consulter')
            AND UPPER(f.nom_organisme) = UPPER('Institut National de la Statistique et des Etudes Economiques')
            ),
    -- CTE pour mettre les données de la table de recensement en forme avant insertion. Mettre les données dans une colonne plutot que d'avoir une colonne par recensement
        population AS (
            SELECT
                codgeo,
                recensement,
                habitant
            FROM
            G_GEO.TEMP_RECENSEMENT
            UNPIVOT
                (habitant for (recensement) IN
                (PMUN17 AS 'PMUN17',
                PMUN16 AS 'PMUN16',
                PMUN15 AS 'PMUN15',
                PMUN14 AS 'PMUN14',
                PMUN13 AS 'PMUN13',
                PMUN12 AS 'PMUN12',
                PMUN11 AS 'PMUN11',
                PMUN10 AS 'PMUN10',
                PMUN09 AS 'PMUN09',
                PMUN08 AS 'PMUN08',
                PMUN07 AS 'PMUN07',
                PMUN06 AS 'PMUN06',
                PSDC99 AS 'PSDC99',
                PSDC90 AS 'PSDC90',
                PSDC82 AS 'PSDC82',
                PSDC75 AS 'PSDC75',
                PSDC68 AS 'PSDC68',
                PSDC62 AS 'PSDC62',
                PTOT54 AS 'PTOT54',
                PTOT36 AS 'PTOT36',
                PTOT1931 AS 'PTOT1931',
                PTOT1926 AS 'PTOT1926',
                PTOT1921 AS 'PTOT1921',
                PTOT1911 AS 'PTOT1911',
                PTOT1906 AS 'PTOT1906',
                PTOT1901 AS 'PTOT1901',
                PTOT1896 AS 'PTOT1896',
                PTOT1891 AS 'PTOT1891',
                PTOT1886 AS 'PTOT1886',
                PTOT1881 AS 'PTOT1881',
                PTOT1876 AS 'PTOT1876'))
            WHERE
                DEP IN ('02','59','60','62','80')
                )
    -- selection des données avec le fid metadonnee suivant l'année du recensement.
    SELECT
      a.objectid AS fid_code,
      b.habitant AS population ,
      g.objectid AS fid_lib_recensement,
      CASE
        WHEN UPPER(e.valeur) = 'PMUN17'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2017')
        WHEN UPPER(e.valeur) = 'PMUN16'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2016')
        WHEN UPPER(e.valeur) = 'PMUN15'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2015')
        WHEN UPPER(e.valeur) = 'PMUN14'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2014')
        WHEN UPPER(e.valeur) = 'PMUN13'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2013')
        WHEN UPPER(e.valeur) = 'PMUN12'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2012')
        WHEN UPPER(e.valeur) = 'PMUN11'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2011')
        WHEN UPPER(e.valeur) = 'PMUN10'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2010')
        WHEN UPPER(e.valeur) = 'PMUN09'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2009')
        WHEN UPPER(e.valeur) = 'PMUN08'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2008')
        WHEN UPPER(e.valeur) = 'PMUN07'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2007')
        WHEN UPPER(e.valeur) = 'PMUN06'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/2006')
        WHEN UPPER(e.valeur) = 'PSDC99'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1999')
        WHEN UPPER(e.valeur) = 'PSDC90'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1990')
        WHEN UPPER(e.valeur) = 'PSDC82'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1982')
        WHEN UPPER(e.valeur) = 'PSDC75'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1975')
        WHEN UPPER(e.valeur) = 'PSDC68'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1968')
        WHEN UPPER(e.valeur) = 'PSDC62'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1962')
        WHEN UPPER(e.valeur) = 'PTOT54'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1954')
        WHEN UPPER(e.valeur) = 'PTOT36'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1936')
        WHEN UPPER(e.valeur) = 'PTOT1931'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1931')
        WHEN UPPER(e.valeur) = 'PTOT1926'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1926')
        WHEN UPPER(e.valeur) = 'PTOT1921'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1921')
        WHEN UPPER(e.valeur) = 'PTOT1911'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1911')
        WHEN UPPER(e.valeur) = 'PTOT1906'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1906')
        WHEN UPPER(e.valeur) = 'PTOT1901'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1901')
        WHEN UPPER(e.valeur) = 'PTOT1896'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1896')
        WHEN UPPER(e.valeur) = 'PTOT1891'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1891')
        WHEN UPPER(e.valeur) = 'PTOT1886'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1886')
        WHEN UPPER(e.valeur) = 'PTOT1881'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1881')
        WHEN UPPER(e.valeur) = 'PTOT1876'
          THEN (
            SELECT objectid
            FROM annee
            WHERE annee.millesime = '01/01/1876')
        END AS fid_metadonnee
    FROM
        population b
    -- distinction des codes insee
        INNER JOIN G_GEO.TA_CODE a ON b.codgeo = a.valeur
        INNER JOIN G_GEO.TA_LIBELLE c ON a.fid_libelle = c.objectid
        INNER JOIN G_GEO.TA_LIBELLE_LONG d ON c.fid_libelle_long = d.objectid
    -- distinction des codes du recensement
        INNER JOIN G_GEO.TA_LIBELLE_COURT e ON b.recensement = e.valeur
        INNER JOIN G_GEO.TA_LIBELLE_CORRESPONDANCE f ON e.objectid = f.fid_libelle_court 
        INNER JOIN G_GEO.TA_LIBELLE g ON f.fid_libelle = g.objectid
        INNER JOIN G_GEO.TA_LIBELLE_LONG h ON g.fid_libelle_long = h.objectid
        INNER JOIN G_GEO.TA_FAMILLE_LIBELLE i ON h.objectid = i.fid_libelle_long
        INNER JOIN G_GEO.TA_FAMILLE j ON i.fid_famille = j.objectid
        WHERE
        UPPER(j.valeur) = 'RECENSEMENT'
        AND
        UPPER(d.valeur) = 'CODE INSEE'
    )b
ON (
    a.fid_code = b.fid_code
    AND a.population = b.population
    AND a.fid_lib_recensement = b.fid_lib_recensement
    AND a.fid_metadonnee = b.fid_metadonnee
    )
WHEN NOT MATCHED THEN
INSERT (a.fid_code, a.population, a.fid_lib_recensement, a.fid_metadonnee)
VALUES (b.fid_code, b.population, b.fid_lib_recensement, b.fid_metadonnee)
;
