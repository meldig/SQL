/*
Requêtes SQL utilisées pour normaliser les données issues de la base historique des populations communales. Recensements de la population 1876-2017.
Cette base fournit les données de populations de 1876 à 2017 pour les communes de France continentale, de 1936 à 2017 pour les communes de Corse et de 1954 ou 1962 à 2017 pour les communes des DOM (hors Mayotte).
*/


-- Insertion des données dans la table TA_RECENSEMENT
INSERT INTO ta_recensement(fid_code,population,fid_lib_recensement,fid_metadonnee)
-- CTE pour selectionner les différentes metadonnees suivant le millesime du recensement
WITH annee AS (
    SELECT
        m.objectid,
        a.millesime
    FROM
        ta_metadonnee m
    INNER JOIN
        ta_source s
    ON m.fid_source = s.objectid
    INNER JOIN
        ta_date_acquisition a
    ON m.fid_acquisition = a.objectid
    WHERE 
        s.nom_source = 'Historique des populations communales - Recensements de la population 1876-2017'
    ),
-- CTE pour mettre les données de la table de recensement en forme avant insertion. Mettre les données dans une colonne plutot que d'avoir une colonne par recensement
    population AS (
    SELECT
        codgeo,
        recensement,
        habitant
    FROM
    recensement
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
        )
-- selection des données avec le fid metadonnee suivant l'année du recensement.
SELECT
    c.objectid AS code,
    p.habitant,
    l.objectid AS RECENSEMENT,
    CASE
        WHEN lc.valeur = 'PMUN17'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2017')
        WHEN lc.valeur = 'PMUN16'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2016')
        WHEN lc.valeur = 'PMUN15'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2015')
        WHEN lc.valeur = 'PMUN14'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2014')
        WHEN lc.valeur = 'PMUN13'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2013')
        WHEN lc.valeur = 'PMUN12'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2012')
        WHEN lc.valeur = 'PMUN11'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2011')
        WHEN lc.valeur = 'PMUN10'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2010')
        WHEN lc.valeur = 'PMUN09'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2009')
        WHEN lc.valeur = 'PMUN08'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2008')
        WHEN lc.valeur = 'PMUN07'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2007') 
        WHEN lc.valeur = 'PMUN06'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2006') 
        WHEN lc.valeur = 'PSDC99'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1999') 
        WHEN lc.valeur = 'PSDC90'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1990') 
        WHEN lc.valeur = 'PSDC82'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1982') 
        WHEN lc.valeur = 'PSDC75'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1975') 
        WHEN lc.valeur = 'PSDC68'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1968') 
        WHEN lc.valeur = 'PSDC62'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1962')
        WHEN lc.valeur = 'PTOT54'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1954')
        WHEN lc.valeur = 'PTOT36'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1936')
        WHEN lc.valeur = 'PTOT1931'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1931')
        WHEN lc.valeur = 'PTOT1926'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1926')
        WHEN lc.valeur = 'PTOT1921'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1921')
        WHEN lc.valeur = 'PTOT1911'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1911')
        WHEN lc.valeur = 'PTOT1906'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1906')
        WHEN lc.valeur = 'PTOT1901'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1901')
        WHEN lc.valeur = 'PTOT1896'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1896')
        WHEN lc.valeur = 'PTOT1891'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1891')
        WHEN lc.valeur = 'PTOT1886'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1886')
        WHEN lc.valeur = 'PTOT1881'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1881')
        WHEN lc.valeur = 'PTOT1876'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1876')
            END AS metadonnee
FROM
    population p
    INNER JOIN ta_code c ON p.codgeo = c.code
    INNER JOIN ta_libelle cl ON c.fid_libelle = cl.objectid
    INNER JOIN ta_libelle_long cll ON cl.fid_libelle_long = cll.objectid
    INNER JOIN ta_famille_libelle cfl ON cll.objectid = cfl.fid_libelle_long
    INNER JOIN ta_famille cf ON cfl.fid_famille = cf.objectid    
    INNER JOIN ta_libelle_court lc ON p.recensement = lc.valeur
    INNER JOIN ta_correspondance_libelle tc ON lc.objectid = tc.fid_libelle_court 
    INNER JOIN ta_libelle l ON tc.fid_libelle = l.objectid
    INNER JOIN ta_libelle_long ll ON l.fid_libelle_long = ll.objectid
    INNER JOIN ta_famille_libelle fl ON ll.objectid = fl.fid_libelle_long
    INNER JOIN ta_famille f ON fl.fid_famille = f.objectid
    WHERE
    f.valeur = 'Recensement'
    AND
    cll.valeur = 'code insee'
    AND
    cf.valeur = 'Identifiant de zone administrative'
;