-- Insertion des données dans la table TA_RECENSEMENT
INSERT INTO ta_recensement(fid_code,population,fid_recensement,fid_metadonnee)
-- CTE pour selection les différentes metadonnees suivant le millesime du recensement
with annee as
    (
    SELECT
        m.objectid,
        a.millesime
    FROM
        ta_metadonnee m
    INNER JOIN ta_source s ON m.fid_source = s.objectid
    INNER JOIN ta_date_acquisition a ON m.fid_acquisition = a.objectid
    WHERE 
        s.nom_source = 'Historique des populations communales - Recensements de la population 1876-2017'
    ),
-- CTE pour mettre les données de la table de recensement en forme avant insertion. Mettre les données dans une colonne plutot que d'avoir une colonne par recensement
    population as
    (
    SELECT
        codgeo,
        recensement,
        habitant
    FROM
    feuil1
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
    lc.objectid AS RECENSEMENT,
    CASE
        WHEN lc.libelle_court = 'PMUN17'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2017')
        WHEN lc.libelle_court = 'PMUN16'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2016')
        WHEN lc.libelle_court = 'PMUN15'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2015')
        WHEN lc.libelle_court = 'PMUN14'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2014')
        WHEN lc.libelle_court = 'PMUN13'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2013')
        WHEN lc.libelle_court = 'PMUN12'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2012')
        WHEN lc.libelle_court = 'PMUN11'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2011')
        WHEN lc.libelle_court = 'PMUN10'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2010')
        WHEN lc.libelle_court = 'PMUN09'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2009')
        WHEN lc.libelle_court = 'PMUN08'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2008')
        WHEN lc.libelle_court = 'PMUN07'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2007') 
        WHEN lc.libelle_court = 'PMUN06'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/2006') 
        WHEN lc.libelle_court = 'PSDC99'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1999') 
        WHEN lc.libelle_court = 'PSDC90'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1990') 
        WHEN lc.libelle_court = 'PSDC82'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1982') 
        WHEN lc.libelle_court = 'PSDC75'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1975') 
        WHEN lc.libelle_court = 'PSDC68'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1968') 
        WHEN lc.libelle_court = 'PSDC62'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1962')
        WHEN lc.libelle_court = 'PTOT54'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1954')
        WHEN lc.libelle_court = 'PTOT36'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1936')
        WHEN lc.libelle_court = 'PTOT1931'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1931')
        WHEN lc.libelle_court = 'PTOT1926'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1926')
        WHEN lc.libelle_court = 'PTOT1921'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1921')
        WHEN lc.libelle_court = 'PTOT1911'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1911')
        WHEN lc.libelle_court = 'PTOT1906'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1906')
        WHEN lc.libelle_court = 'PTOT1901'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1901')
        WHEN lc.libelle_court = 'PTOT1896'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1896')
        WHEN lc.libelle_court = 'PTOT1891'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1891')
        WHEN lc.libelle_court = 'PTOT1886'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1886')
        WHEN lc.libelle_court = 'PTOT1881'
        THEN
            (
            SELECT
                objectid
            FROM
                annee
            WHERE
                annee.millesime = '01/01/1881')
        WHEN lc.libelle_court = 'PTOT1876'
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
INNER JOIN ta_libelle_court lc ON p.recensement = lc.libelle_court
INNER JOIN ta_libelle l ON c.fid_libelle = l.objectid
;