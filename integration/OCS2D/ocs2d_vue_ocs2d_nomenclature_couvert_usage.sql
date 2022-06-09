/*
Vue créer pour simplifier l'insertion de la nomclature en base.
*/

CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GEO"."OCS2D_NOMENCLATURE_COUVERT_USAGE" ("LIBELLE_COURT", "LIBELLE_LONG", "NIVEAU", "SOURCE") AS 
SELECT DISTINCT
    niv_0_libelle_court AS libelle_court, 
    niv_0_libelle libelle_long,
    'niv_0' AS niveau,
    NIV_0_libelle_court AS source
FROM oc_us_ocs2d
UNION ALL
SELECT DISTINCT 
    niv_1_libelle_court AS libelle_court, 
    niv_1_libelle libelle_long,
    'niv_1' AS niveau,
    NIV_0_libelle_court AS source
FROM oc_us_ocs2d
UNION ALL
SELECT DISTINCT 
    niv_2_libelle_court AS libelle_court, 
    niv_2_libelle libelle_long,
    'niv_2' AS niveau,
    NIV_0_libelle_court AS source
FROM oc_us_ocs2d
UNION ALL
SELECT DISTINCT 
    niv_3_libelle_court AS libelle_court, 
    niv_3_libelle AS libelle_long,
    'niv_3' AS niveau,
    NIV_0_libelle_court AS source
FROM
    oc_us_ocs2d;