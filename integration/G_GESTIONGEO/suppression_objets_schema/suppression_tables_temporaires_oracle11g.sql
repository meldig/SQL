-- Suppresion des tables temporaires ayant servi à corriger les données dans Oracle 11g

-- Suppression des métadonnées spatiales
DELETE FROM USER_SDO_GEOM_METADATA
WHERE TABLE_NAME = 'TEMP_TA_GG_GEO';
COMMIT;

-- Suppression des tables
DROP TABLE GEO.TEMP_TA_GG_GEO CASCADE CONSTRAINTS;
DROP TABLE GEO.TEMP_TA_GG_DOSSIER CASCADE CONSTRAINTS;

-- Suppression des index
--DROP INDEX GEO.TEMP_TA_GG_GEO_SIDX;

-- Suppression des séquences
DROP SEQUENCE SEQ_TEMP_TA_GG_GEO;
DROP SEQUENCE SEQ_TEMP_TA_GG_DOSSIER;