/*
Requêtes nécessaires à la suppression des table temporaire nécessaire à la création de la vue matérialisée G_REFERENTIEL.ADMIN_IRIS.
*/

-- 1. Suppression des tables temporaire.
-- 1.1. Suppresion de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_VM.
DROP TABLE G_REFERENTIEL.TEMP_COMMUNES_VM CASCADE CONSTRAINTS;
-- 1.1.1. Suppression des métadonnées de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_VM.
DELETE FROM USER_SDO_GEOM_METADATA WHERE table_name = 'TEMP_COMMUNES_VM';

-- 1.2. Suppression de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_SURFACES.
DROP TABLE G_REFERENTIEL.TEMP_COMMUNES_SURFACES CASCADE CONSTRAINTS;

-- 1.3. Suppression de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX.
DROP TABLE G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX CASCADE CONSTRAINTS;