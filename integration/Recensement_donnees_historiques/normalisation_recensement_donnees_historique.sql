/*
Requêtes SQL utilisées pour normaliser les données issues de la base historique des populations communales. Recensements de la population 1876-2017.
Cette base fournit les données de populations de 1876 à 2017 pour les communes de France continentale, de 1936 à 2017 pour les communes de Corse et de 1954 ou 1962 à 2017 pour les communes des DOM (hors Mayotte).
*/


-- Insertion des données dans la table TA_RECENSEMENT
INSERT INTO ta_recensement(fid_code,population,fid_lib_recensement,fid_metadonnee)
-- CTE pour selectionner les différentes metadonnees suivant le millesime du recensement
WITH annee AS (
    SELECT
        a.objectid,
        b.millesime
    FROM
        ta_metadonnee a
    INNER JOIN ta_date_acquisition b ON a.fid_acquisition = b.objectid
    INNER JOIN ta_source c ON a.fid_source = c.objectid
    INNER JOIN ta_provenance d ON a.fid_provenance = d.objectid
    INNER JOIN ta_metadonnee_relation_organisme e ON a.objectid = e.fid_metadonnee
    INNER JOIN ta_organisme f ON e.fid_organisme = f.objectid
    WHERE
        b.date_acquisition = '06/04/2020'
    AND
        b.millesime BETWEEN '01/01/1876' AND '01/01/2017'
    AND
        c.nom_source = 'Recensements de la population 1876-2017'
    AND
        d.url = 'https://www.insee.fr/fr/statistiques/3698339#consulter'
    AND
        f.nom_organisme IN ('Institut National de la Statistique et des Etudes Economiques')
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
  a.objectid AS code_insee,
  b.habitant,
  g.objectid AS RECENSEMENT,
  CASE
    WHEN e.valeur = 'PMUN17'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2017')
    WHEN e.valeur = 'PMUN16'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2016')
        WHEN e.valeur = 'PMUN15'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2015')
    WHEN e.valeur = 'PMUN14'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2014')
    WHEN e.valeur = 'PMUN13'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2013')
    WHEN e.valeur = 'PMUN12'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2012')
    WHEN e.valeur = 'PMUN11'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2011')
    WHEN e.valeur = 'PMUN10'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2010')
    WHEN e.valeur = 'PMUN09'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2009')
    WHEN e.valeur = 'PMUN08'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2008')
    WHEN e.valeur = 'PMUN07'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2007')
    WHEN e.valeur = 'PMUN06'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/2006')
    WHEN e.valeur = 'PSDC99'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1999')
    WHEN e.valeur = 'PSDC90'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1990')
    WHEN e.valeur = 'PSDC82'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1982')
    WHEN e.valeur = 'PSDC75'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1975')
    WHEN e.valeur = 'PSDC68'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1968')
    WHEN e.valeur = 'PSDC62'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1962')
    WHEN e.valeur = 'PTOT54'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1954')
    WHEN e.valeur = 'PTOT36'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1936')
    WHEN e.valeur = 'PTOT1931'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1931')
    WHEN e.valeur = 'PTOT1926'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1926')
    WHEN e.valeur = 'PTOT1921'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1921')
    WHEN e.valeur = 'PTOT1911'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1911')
    WHEN e.valeur = 'PTOT1906'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1906')
    WHEN e.valeur = 'PTOT1901'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1901')
    WHEN e.valeur = 'PTOT1896'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1896')
    WHEN e.valeur = 'PTOT1891'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1891')
    WHEN e.valeur = 'PTOT1886'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1886')
    WHEN e.valeur = 'PTOT1881'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1881')
    WHEN e.valeur = 'PTOT1876'
      THEN (
        SELECT objectid
        FROM annee
        WHERE annee.millesime = '01/01/1876')
    END AS metadonnee
FROM
    population b
-- distinction des codes insee
    INNER JOIN ta_code a ON b.codgeo = a.valeur
    INNER JOIN ta_libelle c ON a.fid_libelle = c.objectid
    INNER JOIN ta_libelle_long d ON c.fid_libelle_long = d.objectid
-- distinction des codes du recensement
    INNER JOIN ta_libelle_court e ON b.recensement = e.valeur
    INNER JOIN ta_libelle_correspondance f ON e.objectid = f.fid_libelle_court 
    INNER JOIN ta_libelle g ON f.fid_libelle = g.objectid
    INNER JOIN ta_libelle_long h ON g.fid_libelle_long = h.objectid
    INNER JOIN ta_famille_libelle i ON h.objectid = i.fid_libelle_long
    INNER JOIN ta_famille j ON i.fid_famille = j.objectid
    WHERE
    j.valeur = 'Recensement'
    AND
    d.valeur = 'code insee'
;