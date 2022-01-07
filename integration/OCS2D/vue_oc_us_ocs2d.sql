  CREATE OR REPLACE FORCE EDITIONABLE VIEW "G_GEO"."OC_US_OCS2D" ("NIV_0_LIBELLE_COURT", "NIV_0_LIBELLE", "NIV_1_LIBELLE_COURT", "NIV_1_LIBELLE", "NIV_2_LIBELLE_COURT", "NIV_2_LIBELLE", "NIV_3_LIBELLE_COURT", "NIV_3_LIBELLE") AS 
  WITH CTE_1 AS
    (
    SELECT DISTINCT
        'CS' AS niv_0_libelle_court,
        'COUVERT DU SOL' AS niv_0_libelle,
        SUBSTR(CS1_CODE,3,1) AS niv_1_libelle_court,
        CS1_LIBELLE AS niv_1_libelle,
        SUBSTR(CS2_CODE,5,1) AS niv_2_libelle_court,
        CS2_LIBELLE AS niv_2_libelle,
        SUBSTR(CS3_CODE,7,1) AS niv_3_libelle_court,
        CS3_LIBELLE AS niv_3_libelle
    FROM
        OCS2D_CS
    ORDER BY
        niv_0_libelle_court,
        niv_1_libelle_court,
        niv_2_libelle_court,
        niv_3_libelle_court
    ),
CTE_2 AS
    (
    SELECT DISTINCT
        'US' AS niv_0_libelle_court,
        'USAGE DU SOL' AS niv_0_libelle,
        SUBSTR(US1_CODE,3,1) AS niv_1_libelle_court,
        US1_LIBELLE AS niv_1_libelle,
        SUBSTR(US2_CODE,5,1) AS niv_2_libelle_court,
        US2_LIBELLE AS niv_2_libelle,
        SUBSTR(US3_CODE,7,1) AS niv_3_libelle_court,
        US3_LIBELLE AS niv_3_libelle
    FROM
        OCS2D_US
    ORDER BY
        niv_0_libelle_court,
        niv_1_libelle_court,
        niv_2_libelle_court,
        niv_3_libelle_court
    )
SELECT
        niv_0_libelle_court,
        niv_0_libelle,
        niv_1_libelle_court,
        niv_1_libelle,
        niv_2_libelle_court,
        niv_2_libelle,
        niv_3_libelle_court,
        niv_3_libelle
FROM
    CTE_1
UNION ALL
SELECT
        niv_0_libelle_court,
        niv_0_libelle,
        niv_1_libelle_court,
        niv_1_libelle,
        niv_2_libelle_court,
        niv_2_libelle,
        niv_3_libelle_court,
        niv_3_libelle
FROM
    CTE_2;