/*
Les données sont extraites de la table source dans plusieurs tables
Les relations sont uniquement de type 1-n entre ces tables et la géométrie-source
*/

CREATE TABLE t_ocs2d_type_source AS
SELECT DISTINCT
  SOURCE15 AS SOURCE
FROM "OCS_2D"
ORDER BY SOURCE15;

CREATE TABLE t_ocs2d_type_couverture AS
SELECT DISTINCT
  CS15 AS CS,
  SUBSTR(CS15,3,1) AS NV1,
  SUBSTR(CS15,5,1) AS NV2,
  SUBSTR(CS15,7,1) AS NV3
FROM "OCS_2D"
ORDER BY NV1, NV2, NV3;

CREATE TABLE t_ocs2d_type_usage AS
SELECT DISTINCT
  US15 AS US,
  SUBSTR(US15,3,1) AS NV1,
  SUBSTR(US15,5,1) AS NV2,
  SUBSTR(US15,7,1) AS NV3
FROM "OCS_2D"
ORDER BY NV1, NV2, NV3;

CREATE TABLE t_ocs2d_type_indice AS
SELECT DISTINCT
  INDICE15 AS INDICE
FROM "OCS_2D"
ORDER BY INDICE15;

CREATE TABLE t_ocs2d_type_commentaire AS
SELECT DISTINCT
  COMMENT15 AS COMMENT
FROM "OCS_2D"
WHERE COMMENT15 IS NOT NULL
ORDER BY COMMENT15;


CREATE TABLE t_ocs2d_donnees AS
SELECT
 fid AS OBJECT_ID,
 geom,
 '2' AS id_millesime,
 t_ocs2d_type_indice.ROWID AS id_indice,
 t_ocs2d_type_usage.ROWID AS id_usage,
 t_ocs2d_type_couverture.ROWID AS id_couverture,
 t_ocs2d_type_source.ROWID AS id_source,
 t_ocs2d_type_commentaire2.ROWID AS id_commentaire
FROM "OCS_2D"
LEFT JOIN "t_ocs2d_type_indice" ON OCS_2D.INDICE15 = t_ocs2d_type_indice.INDICE
LEFT JOIN "t_ocs2d_type_usage" ON OCS_2D.US15 = t_ocs2d_type_usage.US
LEFT JOIN "t_ocs2d_type_couverture" ON OCS_2D.CS15 = t_ocs2d_type_couverture.CS
LEFT JOIN "t_ocs2d_type_source" ON OCS_2D.SOURCE15 = t_ocs2d_type_source.SOURCE
LEFT JOIN "t_ocs2d_type_commentaire" ON OCS_2D.COMMENT15 = t_ocs2d_type_commentaire.COMMENT
