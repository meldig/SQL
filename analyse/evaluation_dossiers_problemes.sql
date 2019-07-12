-- sans géométries mais dans TA_GG_GEO (=2)
SELECT
  COUNT(DOS_NUM)
FROM GEO.TA_GG_GEO
WHERE SDO_GEOM.SDO_AREA(GEOM, 2) IS NULL;

-- dans TA_GG_DOSSIER et GEO
SELECT
  COUNT(TA_GG_DOSSIER.ID_DOS),
  COUNT(TA_GG_GEO.ID_DOS)
FROM GEO.TA_GG_DOSSIER
JOIN GEO.TA_GG_GEO ON TA_GG_GEO.ID_DOS = TA_GG_DOSSIER.ID_DOS;

-- surfaces anormalement basses pour des dossiers
SELECT
  TA_GG_GEO.DOS_NUM,
  SDO_GEOM.SDO_AREA(GEOM, 2)
FROM GEO.TA_GG_GEO
JOIN GEO.TA_GG_DOSSIER ON TA_GG_GEO.ID_DOS = TA_GG_DOSSIER.ID_DOS
WHERE
  TA_GG_DOSSIER.FAM_ID != 2
  AND SDO_GEOM.SDO_AREA(GEOM, 2) < 10
ORDER BY TA_GG_GEO.DOS_NUM

-- doublon de numéro dans GG_GEO (367 !)
WITH source AS (
SELECT
  DOS_NUM,
  COUNT(DOS_NUM) AS nbr
FROM GEO.TA_GG_GEO
GROUP BY DOS_NUM)

SELECT DOS_NUM, nbr
FROM source
WHERE nbr > 1
ORDER BY nbr DESC;

-- doublon dans TA_GG_DOSSIER
WITH source AS (
SELECT
  DOS_NUM,
  COUNT(DOS_NUM) AS nbr
FROM GEO.TA_GG_DOSSIER
GROUP BY DOS_NUM)

SELECT DOS_NUM, nbr
FROM source
WHERE nbr > 1
ORDER BY nbr DESC;

-- vue listant les erreurs les plus courantes
CREATE TABLE "erreurs_simples" AS
SELECT
  CAST("id_geom" AS INTEGER) AS ID_GEOM,
  CAST("dos_num" AS INTEGER) AS DOS_NUM,
  ST_IsEmpty(GEOMETRY) AS IsEmpty,
  ST_GeometryType(GEOMETRY) AS GeometryType,
  ST_IsValidReason(GEOMETRY) AS IsValidReason,
  ST_NumGeometries(GEOMETRY) AS NumGeometries,
--ST_MakeValid(GEOMETRY) AS MakeValid,
  ST_IsValidReason(ST_MakeValid(GEOMETRY)) AS IsValidPerhaps,
  ST_MakeValid(GEOMETRY) AS GEOMETRY
FROM "v_acq_erreur_geom"
WHERE IsEmpty != 1
