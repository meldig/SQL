DELETE FROM user_sdo_geom_metadata WHERE table_name = 'VM_OCS2D_EVOLUTION_IMPROBABLE';
DROP INDEX VM_OCS2D_EVOLUTION_IMPROBABLE_SIDX;
DROP INDEX VM_OCS2D_EVOLUTION_IMPROBABLE_IDENTIFIANT_IDX;
DROP INDEX VM_OCS2D_EVOLUTION_IMPROBABLE_TYPE_ERREUR_IDX;
DROP INDEX VM_OCS2D_EVOLUTION_IMPROBABLE_REQUETE_IDX;
DROP MATERIALIZED VIEW VM_OCS2D_EVOLUTION_IMPROBABLE;

----------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------3. Création de la VM VM_OCS2D_EVOLUTION_IMPROBABLE-----------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

-- Creation d'une vue pour afficher les polygones OCS2D avec des évolutions improbable
--1. Creation
CREATE MATERIALIZED VIEW G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE
    (
    OBJECTID,
    IDENTIFIANT,
    TYPE_ERREUR,
    REQUETE,
    GEOM
    )
USING INDEX
TABLESPACE G_ADT_INDX
REFRESH ON DEMAND
DISABLE QUERY REWRITE AS
 WITH C_1 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            CASE a.CS20
                                WHEN 'CS1.1.2' THEN 'Surface non bati avec utilisation à des fins agricole'
                                WHEN 'CS1.2.1' THEN 'Surface à matériaux mineraux - pierre - terre avec utilisation à des fins agricole'
                                WHEN 'CS1.2.2' THEN 'Surface composées d''autres matériaux avec utilisation à des fins agricole'
                            END TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et ' || 'US20' || ' en ' || a.US20 as REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 IN ('CS1.1.2','CS1.2.1','CS1.2.2') AND SUBSTR(a.US20,1,3) IN ('US7','US1')
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_2 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'Couvert du sol en surface non baties alors que l''utilisation est chantier' AS TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM 
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE      
                            a.CS20 = 'CS1.1.2' AND a.US20 = 'US6.1.1'
                        AND
                            a.FID_METADONNEE = 530
                    ),

            C_3 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'Couvert du sol en autres formations herbacées alors que l''utilisation est autre' AS TYPE_ERREUR,
                            'CS6.6.0 et US7.0.0' AS REQUETE,
                            a.GEOM 
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE      
                            a.CS20 = 'CS6.6.0' AND a.US20 = 'US7.0.0'
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_4 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            CASE a.CS20
                                WHEN 'CS2.1.1' THEN 'Sable, estran avec utilisation du sol différent de autre'
                                WHEN 'CS2.1.2' THEN 'dunes avec utilisation du sol différent de autre'
                                WHEN 'CS2.2.0' THEN 'pierre rochers et falaises avec utilisation du sol différent de autre'
                                WHEN 'CS3.1.1' THEN 'Plan d''eau avec utilisation du sol différent de autre'
                                WHEN 'CS3.1.2' THEN 'Cours d''eau avec utilisation du sol différent de autre'
                                WHEN 'CS3.2.1' THEN 'Estuaire avec utilisation du sol différent de autre'
                                WHEN 'CS3.2.2' THEN 'Mer avec utilisation du sol différent de autre'
                                WHEN 'CS4.1.1' THEN 'Feuillus sur dunes avec utilisation du sol différent de autre'
                                WHEN 'CS4.2.1' THEN 'Conifères sur dunes avec utilisation du sol différent de autre'
                                WHEN 'CS4.3.1' THEN 'Peuplemùents mixtes sur dunes avec utilisation du sol différent de autre'
                                WHEN 'CS5.1.1' THEN 'Fourrés et broussailles avec utilisation du sol différent de autre'
                                WHEN 'CS5.1.2' THEN 'Fourrés humides avec utilisation du sol différent de autre'
                                WHEN 'CS5.1.3' THEN 'Végétations arbustives sur dunes avec utilisation du sol différent de autre'
                                WHEN 'CS5.2.1' THEN 'Landes sèches avec utilisation du sol différent de autre'
                                WHEN 'CS5.2.2' THEN 'Landes humides avec utilisation du sol différent de autre'
                                WHEN 'CS6.4.1' THEN 'Formation herbacées humides continentales avec utilisation du sol différent de autre'
                                WHEN 'CS6.4.2' THEN 'Formation herbacées humides maritimes avec utilisation du sol différent de autre'
                                WHEN 'CS6.5.0' THEN 'Formation herbacées sur dunes avec utilisation du sol différent de autre'
                            END TYPE_ERREUR,
                            a.CS20 || ' ' || 'et usage différent de US7.0.0' AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 IN ('CS2.1.1','CS2.1.2','CS2.2.0','CS3.1.1','CS3.1.2','CS3.2.1','CS3.2.2','CS4.1.1','CS4.2.1','CS4.3.1','CS5.1.1','CS5.1.2','CS5.1.3','CS5.2.1','CS5.2.2','CS6.4.1','CS6.4.2', 'CS6.5.0') AND a.US20 <> 'US7.0.0'
                            AND a.US20 <> a.US15
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_5 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            CASE a.CS20
                                WHEN 'CS4.1.1' THEN 'feuillus sur dunes avec utilisation autre que à vocation sylvicole ou usage indeterminé'
                                WHEN 'CS4.2.1' THEN 'conifères sur dunes avec utilisation autre que  à vocation sylvicole ou usage indeterminé'
                                WHEN 'CS4.3.1' THEN 'peuplement sur dunes avec utilisation autre que  à vocation sylvicole ou usage indeterminé'
                            END TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 IN ('CS4.1.1','CS4.2.1','CS4.3.1') AND a.US20 <> 'US1.2.4'
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_6 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'Verger et petit fruit non codé en prairie ou culture permanente' AS TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 = 'CS4.4.0' AND a.US20 NOT IN ('US1.1.1','US1.1.5')
                        AND
                            a.FID_METADONNEE = 530
                    ), 
            C_7 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            CASE a.CS20
                                WHEN 'CS6.1.1' THEN 'Prairies mésophiles avec utilisation non codée prairies ou bandes enherbées'
                                WHEN 'CS6.1.2' THEN 'Prairies humide avec utilisation non codée prairies ou bandes enherbées'
                            END TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 IN ('CS6.1.1','CS6.1.2') AND a.US20 NOT IN ('US1.1.1','US1.1.2')
                        AND
                            a.FID_METADONNEE = 530
                    ),  
            C_8 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'Terre arable non codé en culture annuelle, horticulture ou autoconsommation' AS TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 = ('CS6.3.0') AND a.US20 NOT IN ('US1.1.3','US1.1.4','US1.1.6')
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_9 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            CASE a.US20
                                WHEN 'US1.1.1' THEN 'Utilisation du sol en prairie avec codage du couvert autre que prairie mésophiles, prairie humide, verger'
                                WHEN 'US1.1.2' THEN 'Utilisation du sol en bande enherbée avec codage du couvert autre que prairie mésophiles, prairie humide, verger'
                            END TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 NOT IN ('CS6.1.1','CS6.1.2','CS4.4.0') AND a.US20 IN ('US1.1.1','US1.1.2')
                        AND
                            a.FID_METADONNEE = 530
                    ), 
            C_10 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            CASE a.US20
                                WHEN 'US1.1.3' THEN 'Couvert du sol codé autrement qu''en terre arable avec utilisation cultures annuelles'
                                WHEN 'US1.1.4' THEN 'Couvert du sol codé autrement qu''en terre arable avec horticulture'
                                WHEN 'US1.1.6' THEN 'Couvert du sol codé autrement qu''en terre arable avec autoconsommation'
                            END TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 <> ('CS6.3.0') AND a.US20 IN ('US1.1.3','US1.1.4','US1.1.6')
                        AND
                            a.FID_METADONNEE = 530
                    ), 
            C_11 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'Utilisation du sol en zone de coupe pour un couvert autre que autres formations herbacées, surfaces à minéraux - pierre - terre ou fourrés et broussailles' AS TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 NOT IN ('CS6.6.0','CS1.2.1','CS5.1.1') AND a.US20 = ('US1.2.1')
                        AND
                            a.FID_METADONNEE = 530
                    ), 
            C_12 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'Couvert feuillus et utilisation différent de peuplerais' AS TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 <> ('CS4.1.2') AND a.US20 = ('US1.2.2')
                        AND
                            a.FID_METADONNEE = 530
                    ), 
            C_13 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'Couvert autre que peuplerais, connifère, peuplerais mixtes ou indeterminé alors que l''utilisation est plantation récente' AS TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            a.CS20 NOT IN ('CS4.1.2','CS4.2.2','CS4.3.2') AND a.US20 = ('US1.2.3')
                        AND
                            a.FID_METADONNEE = 530
                    ), 
            C_14 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'Couvert autre que feuillus, connifère ou peuplement mixte alors que l''utilisation est a vocation sylvicole ou usage indéterminé' AS TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            SUBSTR(a.CS20,1,5) NOT IN ('CS4.1','CS4.2','CS4.3') AND a.US20 = ('US1.2.4')
                        AND
                            a.FID_METADONNEE = 530
                    ), 
            C_15 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            CASE a.US20
                                WHEN 'US1.3.2' THEN 'Usage terrils en exploitation, rare'
                                WHEN 'US1.4.0' THEN 'Usage Aquaculture, pisciculture, rare'
                                WHEN 'US2.1.2' THEN 'Zone de stockage gaz et hydrocarbure, rare'
                            END TYPE_ERREUR,
                            'CS20' || ' en ' || a.CS20 || ' et US20 en ' || a.US20 AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE 
                            a.US20 IN ('US1.3.2','US1.4.0','US2.1.2')
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_16 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            CASE a.US20
                                WHEN 'CS6.2.0' THEN 'Couvert en Pelouse naturelle, rare'
                            END TYPE_ERREUR,
                            'Couvert en CS6.2.0' AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE 
                            a.CS20 IN ('CS6.2.0')
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_17 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'EVOLUTION DES COUVERTURES PEU PROBABLES' AS TYPE_ERREUR,
                            a.CS20 || ' ' || 'en 2020' || ' ' || 'et' || ' ' || a.CS15 || ' ' || 'en 2015' AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            (
                            (a.CS20 = 'CS1.1.2' AND a.CS15 <> 'CS1.1.2') OR
                            (a.CS20 = 'CS3.1.2' AND a.CS15 <> 'CS3.1.2') OR
                            (a.CS20 = 'CS3.1.1' AND a.CS15 <> 'CS3.1.1') OR
                            (SUBSTR(a.CS20,1,3) = 'CS5' AND a.CS15 = 'CS1.2.1') OR
                            (SUBSTR(a.CS20,1,3) = 'CS4' AND CS15 = 'CS1.2.1') OR
                            (a.CS20 = 'CS4.1.3' AND a.CS15 = 'CS4.1.2') OR
                            (a.CS20 = 'CS4.1.2' AND a.CS15 = 'CS4.1.3') OR
                            (a.CS20 = 'CS6.1.1' AND a.CS15 = 'CS6.1.2') OR
                            (a.CS20 = 'CS5.1.1' AND a.CS15 = 'CS5.1.2') OR
                            (a.CS20 = 'CS6.6.0' AND a.CS15 = 'CS6.4.1') OR
                            (a.CS20 = 'CS5.2.1' AND a.CS15 = 'CS5.2.2')
                            )
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_18 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'EVOLUTION DES COUVERTURES PEU PROBABLES' AS TYPE_ERREUR,
                            a.CS20 || ' ' || 'en 2020' || ' ' || 'et' || ' ' || a.US15 || ' ' || 'en 2015' AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            (
                            (SUBSTR(a.CS20,1,3) = 'CS4' AND a.US15 = 'US1.2.1') OR
                            (a.CS20 = 'CS1.2.1' AND a.US15 = 'US4') OR
                            (a.CS20 = 'CS1.2.1' AND a.US15 = 'US6') OR
                            (a.CS20 = 'CS1.1.2' AND a.US15 = 'US5') OR
                            (a.CS20 = 'CS6.1.2' AND a.US15 = 'US6.1.1') OR
                            (a.CS20 = 'CS5.1.2' AND a.US15 = 'US5.1.1') OR
                            (a.CS20 = 'CS6.4.1' AND a.US15 = 'US6.6.6') OR
                            (a.CS20 = 'CS5.2.2' AND a.US15 = 'US5.2.1') OR
                            (a.CS20 = 'CS6.6.0' AND a.US20 = 'US7.0.0' AND a.US20 <> a.US15)
                            )
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_19 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'EVOLUTION DES USAGES PEU PROBABLES' AS TYPE_ERREUR,
                            a.US20 || ' ' || 'en 2020' || ' ' || 'et' || ' ' || a.US15 || ' ' || 'en 2015' AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            (
                            (SUBSTR(a.US20,1,3) = 'US6' AND SUBSTR(a.US15,1,3) = 'US6') OR
                            (a.US20 = 'US6.2.1' AND (SUBSTR(a.US15,1,3) <> 'US2')) OR
                            (a.US20 = 'US6.2.2' AND (SUBSTR(a.US15,1,3) NOT IN ('US3','US4','US5')) OR
                            (a.US20 = 'US6.2.3' AND SUBSTR(a.US15,1,3) <> 'US1'))
                            )
                        AND
                            a.FID_METADONNEE = 530
                        ),
            C_20 AS
                    (
                        SELECT
                            a.OBJECTID AS IDENTIFIANT,
                            'EVOLUTION DES USAGES PEU PROBABLES' AS TYPE_ERREUR,
                            a.US20 || ' ' || 'en 2020' || ' ' || 'et' || ' ' || a.US15 || ' ' || 'en 2015' AS REQUETE,
                            a.GEOM
                        FROM
                            G_OCS2D.ta_ocs2d_multidate_controle a
                        WHERE
                            (
                            (a.US20 = 'US3.1.4' AND a.US15 = 'US1.1.7') OR
                            (a.US20 = 'US3.1.4' AND a.US15 = 'US1.1.3') OR
                            (a.US20 = 'US4.2.1' AND a.US15 = 'US2.1.1') OR
                            (a.US20 = 'US4.4.0' AND a.US15 = 'US1.1.1') OR
                            (a.US20 = 'US4.4.0' AND a.US15 = 'US7.0.0') OR
                            (a.US20 = 'US4.5.0' AND a.US15 = 'US3.1.1') OR
                            (a.US20 = 'US1.1.7' AND a.US15 = 'US5.1.2') OR
                            (a.US20 = 'US3.1.1' AND a.US15 = 'US2.1.1')
                            )
                        AND
                            a.FID_METADONNEE = 530
                    ),
            C_F AS
                    (
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_1
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_2
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_3
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_4
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_5
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_6
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_7
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_8
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_9
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_10
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_11
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_12
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_13
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_14
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_15
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_16
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_17
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_18
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_19
                        UNION ALL
                        SELECT
                            IDENTIFIANT,
                            TYPE_ERREUR,
                            REQUETE,
                            GEOM
                        FROM
                            C_20
                        )
        SELECT
            ROWNUM AS OBJECTID,
            C_F.IDENTIFIANT AS IDENTIFIANT,
            C_F.TYPE_ERREUR AS TYPE_ERREUR,
            C_F.REQUETE AS REQUETE,
            C_F.GEOM AS GEOM
        FROM
            C_F
            ;

-- 2. Commentaire
COMMENT ON MATERIALIZED VIEW G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE IS 'Vue qui présente les évolutions improbables';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE.OBJECTID IS 'Clé primaire de la VM';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE.IDENTIFIANT IS 'Identifiant du polygone';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE.TYPE_ERREUR IS 'Type d''observation faite sur l''évolution du polygone entre les millesimes 2015 et 2020';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE.REQUETE IS 'Code observée entre les deux millesimes';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE.GEOM IS 'Géomtrie du polygones';

-- 1.3. Création de la clé primaire
ALTER MATERIALIZED VIEW G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE
ADD CONSTRAINT VM_OCS2D_EVOLUTION_IMPROBABLE_PK 
PRIMARY KEY (OBJECTID);

-- 3. Metadonnee
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'VM_OCS2D_EVOLUTION_IMPROBABLE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 680041.099999997, 730745.000000005, 0.001),SDO_DIM_ELEMENT('Y', 7030203.99999884, 7082570.8999989, 0.001)),
    2154
);
COMMIT;


-- 4. Création de l'index spatial sur le champ geom
CREATE INDEX VM_OCS2D_EVOLUTION_IMPROBABLE_SIDX
ON G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- 5. INDEX
CREATE INDEX VM_OCS2D_EVOLUTION_IMPROBABLE_IDENTIFIANT_IDX ON G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE(IDENTIFIANT)
    TABLESPACE G_ADT_INDX;

CREATE INDEX VM_OCS2D_EVOLUTION_IMPROBABLE_TYPE_ERREUR_IDX ON G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE(TYPE_ERREUR)
    TABLESPACE G_ADT_INDX;

CREATE INDEX VM_OCS2D_EVOLUTION_IMPROBABLE_REQUETE_IDX ON G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE(REQUETE)
    TABLESPACE G_ADT_INDX;

-- 6. Affectation du droit de sélection sur les objets de la table aux administrateurs
GRANT SELECT ON G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE TO G_ADMIN_SIG;

----------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------4. Création de la VM VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE----------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
DROP MATERIALIZED VIEW VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE;

--1. Création de la vue matérialisée 
CREATE MATERIALIZED VIEW G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE
    (
    OBJECTID,
    OCCURENCE,
    REQUETE
    )
USING INDEX
TABLESPACE G_AST_INDEX
REFRESH ON DEMAND
DISABLE QUERY REWRITE AS

    WITH CTE_1 AS 
            (
            SELECT
                COUNT(REQUETE) AS OCCURENCE,
                REQUETE AS REQUETE
            FROM
                VM_OCS2D_EVOLUTION_IMPROBABLE
            GROUP BY
                REQUETE
            )
    SELECT
        ROWNUM AS OBJECTID,
        CTE_1.OCCURENCE AS OCCURENCE,
        CTE_1.REQUETE AS REQUETE
    FROM
        CTE_1
    ;

-- 2. Commentaire
COMMENT ON MATERIALIZED VIEW G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE IS 'Vue qui présente les occurrences des évolutions improbables de la vue V_OCS2D_EVOLUTION_IMPROBABLE';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE.OBJECTID IS 'Clé primaire de la table';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE.OCCURENCE IS 'Nombre d''occurence de l''observation';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE.REQUETE IS 'Requete executee';

-- 4. Affection du droit de lecture aux admins
GRANT SELECT ON G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE TO G_ADMIN_SIG;

----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------5. Gestion des droits--------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

-- Affectation de droits de lecture
GRANT SELECT ON G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE TO G_OCS2D_R;
GRANT SELECT ON G_OCS2D.VM_OCS2D_EVOLUTION_IMPROBABLE_OCCURENCE TO G_OCS2D_R;