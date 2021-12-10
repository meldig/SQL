/*
Vérification du bon déroulé de l'export des données dans les tables de production de GESTIONGEO.
*/

-- Comparaison du nombre d'entités dans les tables d'import et les tables finales
SELECT
    'TA_GG_AGENT' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TA_GG_AGENT
GROUP BY
    'TA_GG_AGENT'
UNION ALL
SELECT
    'TEMP_TA_GG_AGENT' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TEMP_TA_GG_AGENT
GROUP BY
    'TEMP_TA_GG_AGENT'
UNION ALL
SELECT
    'TA_GG_DOSSIER' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TA_GG_DOSSIER
GROUP BY
    'TA_GG_DOSSIER'
UNION ALL
SELECT
    'TEMP_TA_GG_DOSSIER' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TEMP_TA_GG_DOSSIER
GROUP BY
    'TEMP_TA_GG_DOSSIER'
UNION ALL
SELECT
    'TEMP_TA_GG_ETAT' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TEMP_TA_GG_ETAT
GROUP BY
    'TEMP_TA_GG_ETAT'
UNION ALL
SELECT
    'TA_GG_ETAT' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TA_GG_ETAT
GROUP BY
    'TA_GG_ETAT'
UNION ALL
SELECT
    'TA_GG_FAMILLE' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TA_GG_FAMILLE
GROUP BY
    'TA_GG_FAMILLE'
UNION ALL
SELECT
    'TEMP_TA_GG_FAMILLE' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TEMP_TA_GG_FAMILLE
GROUP BY
    'TEMP_TA_GG_FAMILLE'
UNION ALL
SELECT
    'TA_GG_GEO' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TA_GG_GEO
GROUP BY
    'TA_GG_GEO'
UNION ALL
SELECT
    'TEMP_TA_GG_GEO' AS NomTable,
    COUNT(*) AS NbrEntites
FROM
    G_GESTIONGEO.TEMP_TA_GG_GEO
GROUP BY
    'TEMP_TA_GG_GEO';
/*
Résultats attendus :
- 5 entités de plus dans TA_GG_AGENT que dans TEMP_GG_AGENT ;
- Même nombre d'entités dans les autres tables ;
*/
-- Vérification que chaque périmètre est associé à un et un seul dossier
SELECT
    id_dos
FROM
    G_GESTIONGEO.TA_GG_GEO
GROUP BY
    id_dos
HAVING
    COUNT(id_dos) > 1;
-- Résultat attendu : aucune ligne

-- Vérification de la validité des géométries de TA_GG_GEO  
SELECT
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) AS ERREUR,
    COUNT(a.id_geom) AS Nombre
FROM
    G_GESTIONGEO.TA_GG_GEO a
WHERE
    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005)<>'TRUE'
GROUP BY
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5);
-- Résultat attendu : aucune ligne