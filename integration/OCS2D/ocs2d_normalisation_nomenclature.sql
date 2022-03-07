-- Normalisation des nomenclature OCS2D
/*
Insertion des metadonnées
*/

-- 1. Insertion de la source dans TA_SOURCE
MERGE INTO G_GEO.TA_SOURCE s
USING 
    (
        SELECT 'OCS2D' AS nom,'Le référentiel OCS2D est une base de données diachronique d''occupation du sol en 2 dimensions sur les départements du Nord et du PAS-de-Calais. Pour chaque portion de territoire interprété, il décrit de façon précise le couvert du sol et l''usage du sol.' AS description FROM DUAL
    ) temp
ON (temp.nom = s.nom_source
AND temp.description = s.description)
WHEN NOT MATCHED THEN
INSERT (s.nom_source,s.description)
VALUES (temp.nom,temp.description)
;


-- 2. Insertion de la provenance dans TA_PROVENANCE
MERGE INTO G_GEO.TA_PROVENANCE p
USING
    (
        SELECT 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ' AS url,'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020' AS methode_acquisition FROM DUAL
    ) temp
ON (p.url = temp.url
AND p.methode_acquisition = temp.methode_acquisition)
WHEN NOT MATCHED THEN
INSERT (p.url,p.methode_acquisition)
VALUES(temp.url,temp.methode_acquisition)
;


-- 3. Insertion des données dans TA_DATE_ACQUISITION
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
USING
    (
        SELECT TO_DATE('18/12/21') AS DATE_ACQUISITION, TO_DATE('01/01/20') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
        UNION
        SELECT TO_DATE('18/12/21') AS DATE_ACQUISITION, TO_DATE('01/01/15') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
        UNION
        SELECT TO_DATE('18/12/21') AS DATE_ACQUISITION, TO_DATE('01/01/05') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
    ) temp
ON (temp.date_acquisition = a.date_acquisition
AND temp.millesime = a.millesime)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition,a.millesime)
VALUES (temp.date_acquisition,temp.millesime)
;


-- 4. Insertion des données dans TA_ORGANISME
MERGE INTO G_GEO.TA_ORGANISME a
USING
    (
        SELECT 'CLS' AS ACRONYME, 'Collecte Localisation Satellites' AS NOM_ORGANISME FROM DUAL
    ) temp
ON (a.acronyme = temp.acronyme)
WHEN NOT MATCHED THEN
INSERT (a.acronyme,a.nom_organisme)
VALUES(temp.acronyme,temp.nom_organisme)
;


-- 5. Insertion des données dans TA_ECHELLE
MERGE INTO G_GEO.TA_ECHELLE e
USING
    (
        SELECT '5000' AS VALEUR FROM DUAL
    ) temp
ON (e.valeur = temp.valeur)
WHEN NOT MATCHED THEN
INSERT (e.valeur)
VALUES(temp.valeur)
;


-- 6. Insertion des données dans TA_METADONNEE
-- 6.1:  pour le millesime 2005
MERGE INTO G_GEO.TA_METADONNEE m
USING
    (
    SELECT 
        s.objectid AS SOURCE,
        a.objectid AS ACQUISITION,
        p.objectid AS PROVENANCE
    FROM
        G_GEO.TA_SOURCE s,
        G_GEO.TA_DATE_ACQUISITION a,
        G_GEO.TA_PROVENANCE p
    WHERE
        (s.nom_source = 'OCS2D'
    AND
        a.millesime IN ('01/01/2005')
    AND
        a.date_acquisition = '18/12/2021'
    AND
        p.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
    AND
        p.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020')
    ) temp
ON (temp.SOURCE = m.fid_source
AND temp.ACQUISITION = m.fid_acquisition
AND temp.PROVENANCE = m.fid_provenance)
WHEN NOT MATCHED THEN
INSERT (fid_source,fid_acquisition,fid_provenance)
VALUES(temp.SOURCE,temp.ACQUISITION,temp.PROVENANCE)
;


-- 6.2:  pour le millesime 2015
MERGE INTO G_GEO.TA_METADONNEE m
USING
    (
    SELECT 
        s.objectid AS SOURCE,
        a.objectid AS ACQUISITION,
        p.objectid AS PROVENANCE
    FROM
        G_GEO.TA_SOURCE s,
        G_GEO.TA_DATE_ACQUISITION a,
        G_GEO.TA_PROVENANCE p
    WHERE
        (s.nom_source = 'OCS2D'
    AND
        a.millesime IN ('01/01/2015')
    AND
        a.date_acquisition = '18/12/2021'
    AND
        p.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
    AND
        p.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020')
    ) temp
ON (temp.SOURCE = m.fid_source
AND temp.ACQUISITION = m.fid_acquisition
AND temp.PROVENANCE = m.fid_provenance)
WHEN NOT MATCHED THEN
INSERT (fid_source,fid_acquisition,fid_provenance)
VALUES(temp.SOURCE,temp.ACQUISITION,temp.PROVENANCE)
;


-- 6.3:  pour le millesime 2020
MERGE INTO G_GEO.TA_METADONNEE m
USING
    (
    SELECT 
        s.objectid AS SOURCE,
        a.objectid AS ACQUISITION,
        p.objectid AS PROVENANCE
    FROM
        G_GEO.TA_SOURCE s,
        G_GEO.TA_DATE_ACQUISITION a,
        G_GEO.TA_PROVENANCE p
    WHERE
        (s.nom_source = 'OCS2D'
    AND
        a.millesime IN ('01/01/2020')
    AND
        a.date_acquisition = '18/12/2021'
    AND
        p.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
    AND
        p.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020')
    ) temp
ON (temp.SOURCE = m.fid_source
AND temp.ACQUISITION = m.fid_acquisition
AND temp.PROVENANCE = m.fid_provenance)
WHEN NOT MATCHED THEN
INSERT (fid_source,fid_acquisition,fid_provenance)
VALUES(temp.SOURCE,temp.ACQUISITION,temp.PROVENANCE)
;


-- 7. Insertion des données dans la table TA_METADONNEE_RELATION_ORGANISME
-- 7.1. pour le millesime 2005
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
USING
    (
    SELECT
        a.objectid AS fid_metadonnee,
        e.objectid AS fid_organisme
    FROM
        G_GEO.TA_METADONNEE a
    INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
    INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
    INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid,
        G_GEO.TA_ORGANISME e
    WHERE
        (b.nom_source = 'OCS2D'
    AND
        c.date_acquisition = '18/12/2021'
    AND
        c.millesime IN ('01/01/2005')
    AND
        d.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ' 
    AND
        d.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020'
    AND
        e.acronyme IN ('CLS'))
    ) temp
ON(a.fid_metadonnee = temp.fid_metadonnee
AND a.fid_organisme = temp.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(temp.fid_metadonnee, temp.fid_organisme)
;

-- 7.2. pour le millesime 2015
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
USING
    (
    SELECT
        a.objectid AS fid_metadonnee,
        e.objectid AS fid_organisme
    FROM
        G_GEO.TA_METADONNEE a
    INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
    INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
    INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid,
        G_GEO.TA_ORGANISME e
    WHERE
        (b.nom_source = 'OCS2D'
    AND
        c.date_acquisition = '18/12/2021'
    AND
        c.millesime IN ('01/01/2015')
    AND
        d.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
    AND
        d.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020'
    AND
        e.acronyme IN ('CLS'))
    )temp
ON(a.fid_metadonnee = temp.fid_metadonnee
AND a.fid_organisme = temp.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(temp.fid_metadonnee, temp.fid_organisme)
;


-- 7.3. pour le millesime 2020
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ORGANISME a
USING
    (
    SELECT
        a.objectid AS fid_metadonnee,
        e.objectid AS fid_organisme
    FROM
        G_GEO.TA_METADONNEE a
    INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
    INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
    INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid,
        G_GEO.TA_ORGANISME e
    WHERE
        (b.nom_source = 'OCS2D'
    AND
        c.date_acquisition = '18/12/2021'
    AND
        c.millesime IN ('01/01/2020')
    AND
        d.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
    AND
        d.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020'
    AND
        e.acronyme IN ('CLS'))
    )temp
ON(a.fid_metadonnee = temp.fid_metadonnee
AND a.fid_organisme = temp.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(temp.fid_metadonnee, temp.fid_organisme)
;


-- 8. Insertion des données dans la table TA_METADONNEE_RELATION_ECHELLE
-- 8.1. pour le millesime 2005
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ECHELLE a
USING
    (
    SELECT
        a.objectid AS fid_metadonnee,
        g.objectid AS fid_echelle
    FROM
        G_GEO.TA_METADONNEE a
    INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
    INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
    INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME e ON e.fid_metadonnee = a.objectid
    INNER JOIN G_GEO.TA_ORGANISME f ON f.objectid = e.fid_organisme,
        G_GEO.TA_ECHELLE g
    WHERE
        (b.nom_source = 'OCS2D'
    AND
        c.date_acquisition = '18/12/2021'
    AND
        c.millesime IN ('01/01/2005')
    AND
        d.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
    AND
        d.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020'
    AND
        f.acronyme IN ('CLS')
    AND
        g.valeur IN ('5000'))
    )temp
ON(a.fid_metadonnee = temp.fid_metadonnee
AND a.fid_echelle = temp.fid_echelle)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_echelle)
VALUES(temp.fid_metadonnee, temp.fid_echelle)
;



-- 8. Insertion des données dans la table TA_METADONNEE_RELATION_ECHELLE
-- 8.2. pour le millesime 2015
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ECHELLE a
USING
    (
    SELECT
        a.objectid AS fid_metadonnee,
        g.objectid AS fid_echelle
    FROM
        G_GEO.TA_METADONNEE a
    INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
    INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
    INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME e ON e.fid_metadonnee = a.objectid
    INNER JOIN G_GEO.TA_ORGANISME f ON f.objectid = e.fid_organisme,
        G_GEO.TA_ECHELLE g
    WHERE
        (b.nom_source = 'OCS2D'
    AND
        c.date_acquisition = '18/12/2021'
    AND
        c.millesime IN ('01/01/2015')
    AND
        d.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
    AND
    d.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020'
    AND
        f.acronyme IN ('CLS')
    AND
        g.valeur IN ('5000'))
    )temp
ON(a.fid_metadonnee = temp.fid_metadonnee
AND a.fid_echelle = temp.fid_echelle)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_echelle)
VALUES(temp.fid_metadonnee, temp.fid_echelle)
;


-- 8.3. pour le millesime 2020
MERGE INTO G_GEO.TA_METADONNEE_RELATION_ECHELLE a
USING
    (
    SELECT
        a.objectid AS fid_metadonnee,
        g.objectid AS fid_echelle
    FROM
        G_GEO.TA_METADONNEE a
    INNER JOIN G_GEO.TA_SOURCE b ON b.objectid = a.fid_source
    INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON a.fid_acquisition = c.objectid
    INNER JOIN G_GEO.TA_PROVENANCE d ON a.fid_provenance = d.objectid
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME e ON e.fid_metadonnee = a.objectid
    INNER JOIN G_GEO.TA_ORGANISME f ON f.objectid = e.fid_organisme,
        G_GEO.TA_ECHELLE g
    WHERE
        (b.nom_source = 'OCS2D'
    AND
        c.date_acquisition = '18/12/2021'
    AND
        c.millesime IN ('01/01/2020')
    AND
        d.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
    AND
        d.methode_acquisition = 'Donnée OCS2D finale corrigée par CLS. Téléchargée depuis le serveur CLS, disponible également sur le serveur infogeo, donnée externe, CLS sous le nom OCS2d_mel_Multidate_2005_2015_2020'
    AND
        f.acronyme IN ('CLS')
    AND
        g.valeur IN ('5000'))
    )temp
ON(a.fid_metadonnee = temp.fid_metadonnee
AND a.fid_echelle = temp.fid_echelle)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_echelle)
VALUES(temp.fid_metadonnee, temp.fid_echelle)
;

/*
Insertion des nomenclature 4 et 21 postes OCS2D
*/

-- 9.Insertion des familles "4 postes" et "21 postes"
MERGE INTO G_OCS2D.TA_OCS2D_FAMILLE a
USING
    (
    SELECT
        'nomenclature « 4 postes »' AS valeur
    FROM
        DUAL
    UNION
    SELECT
        'nomenclature « 21 postes »' AS valeur
    FROM
        DUAL
    )b
ON(UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN INSERT
(a.valeur)
VALUES (b.valeur)
; 
COMMIT;


-- 10. insertion des libelles des libelles dans la table G_OCS2D.TA_LIBELLE_LONG
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_LONG a
USING
    (
    SELECT 'Espaces artificialisés' AS valeur FROM DUAL UNION
    SELECT 'Espaces agricoles' AS valeur FROM DUAL UNION 
    SELECT 'Espaces naturels, semi-naturels' AS valeur FROM DUAL UNION
    SELECT 'Infrastructures' AS valeur FROM DUAL UNION
    SELECT 'Bâti de l’habitat' FROM DUAL UNION
    SELECT 'Bâti des exploitations agricoles' FROM DUAL UNION
    SELECT 'Bâti commercial' FROM DUAL UNION
    SELECT 'Bâti industriel et autres activités économiques' FROM DUAL UNION
    SELECT 'Bâti des services et transports' FROM DUAL UNION
    SELECT 'Autres bâtis' FROM DUAL UNION
    SELECT 'Routes' FROM DUAL UNION
    SELECT 'Voies ferrées' FROM DUAL UNION
    SELECT 'Zones aéroportuaires' FROM DUAL UNION
    SELECT 'Canaux et rivières navigables' FROM DUAL UNION
    SELECT 'Espaces non végétalisés de l''habitat' FROM DUAL UNION
    SELECT 'Espaces végétalisés de l''habitat' FROM DUAL UNION
    SELECT 'Autres espaces artificialisés non végétalisés' FROM DUAL UNION
    SELECT 'Autres espaces artificialisés végétalisés' FROM DUAL UNION
    SELECT 'Prairies' FROM DUAL UNION
    SELECT 'Cultures annuelles' FROM DUAL UNION
    SELECT 'Autres terres agricoles' FROM DUAL UNION
    SELECT 'Surfaces en eau' FROM DUAL UNION
    SELECT 'Espaces boisés' FROM DUAL UNION
    SELECT 'Espaces végétalisés non boisés' FROM DUAL UNION
    SELECT 'Espaces non végétalisés' FROM DUAL
    )b
ON(UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN INSERT
(a.valeur)
VALUES (b.valeur)
; 
COMMIT;


-- 11. insertion des libellés dans la table TA_OCS2D_LIBELLE
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE a
USING
    (
    SELECT
        a.objectid AS fid_libelle_long
    FROM
        G_OCS2D.TA_OCS2D_LIBELLE_LONG a
    WHERE
        UPPER(a.valeur) IN 
                        (
                        UPPER('Espaces artificialisés'),
                        UPPER('Espaces agricoles'),
                        UPPER('Espaces naturels, semi-naturels'),
                        UPPER('Infrastructures'),
                        UPPER('Bâti de l’habitat'),
                        UPPER('Bâti des exploitations agricoles'),
                        UPPER('Bâti commercial'),
                        UPPER('Bâti industriel et autres activités économiques'),
                        UPPER('Bâti des services et transports'),
                        UPPER('Autres bâtis'),
                        UPPER('Routes'),
                        UPPER('Voies ferrées'),
                        UPPER('Zones aéroportuaires'),
                        UPPER('Canaux et rivières navigables'),
                        UPPER('Espaces non végétalisés de l''habitat'),
                        UPPER('Espaces végétalisés de l''habitat'),
                        UPPER('Autres espaces artificialisés non végétalisés'),
                        UPPER('Autres espaces artificialisés végétalisés'),
                        UPPER('Prairies'),
                        UPPER('Cultures annuelles'),
                        UPPER('Autres terres agricoles'),
                        UPPER('Surfaces en eau'),
                        UPPER('Espaces boisés'),
                        UPPER('Espaces végétalisés non boisés'),
                        UPPER('Espaces non végétalisés')
                        )
    )b
ON (a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN 
INSERT (a.fid_libelle_long)
VALUES (b.fid_libelle_long)
;
COMMIT;


-- 12. insertion des libelles dans la table G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE 
MERGE INTO G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE a
USING
    (
    SELECT
        a.objectid AS fid_famille,
        b.objectid AS fid_libelle
    FROM
        G_OCS2D.TA_OCS2D_FAMILLE a,
        G_OCS2D.TA_OCS2D_LIBELLE b
        INNER JOIN TA_OCS2D_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
    WHERE
        (
        UPPER(a.valeur) = UPPER('famille « 4 libelles »')
        AND UPPER(c.valeur) IN 
                            (
                            UPPER('Espaces artificialisés'),
                            UPPER('Espaces agricoles'),
                            UPPER('Espaces naturels, semi-naturels'),
                            UPPER('Infrastructures')
                            )
        )
        OR
        (
        UPPER(a.valeur) = UPPER('famille « 21 libelles »')
        AND UPPER(c.valeur) IN 
                            (
                            UPPER('Bâti de l’habitat'),
                            UPPER('Bâti des exploitations agricoles'),
                            UPPER('Bâti commercial'),
                            UPPER('Bâti industriel et autres activités économiques'),
                            UPPER('Bâti des services et transports'),
                            UPPER('Autres bâtis'),
                            UPPER('Routes'),
                            UPPER('Voies ferrées'),
                            UPPER('Zones aéroportuaires'),
                            UPPER('Canaux et rivières navigables'),
                            UPPER('Espaces non végétalisés de l''habitat'),
                            UPPER('Espaces végétalisés de l''habitat'),
                            UPPER('Autres espaces artificialisés non végétalisés'),
                            UPPER('Autres espaces artificialisés végétalisés'),
                            UPPER('Prairies'),
                            UPPER('Cultures annuelles'),
                            UPPER('Autres terres agricoles'),
                            UPPER('Surfaces en eau'),
                            UPPER('Espaces boisés'),
                            UPPER('Espaces végétalisés non boisés'),
                            UPPER('Espaces non végétalisés')
                            )
        )
    )b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN 
INSERT (a.fid_famille,a.fid_libelle)
VALUES (b.fid_famille,b.fid_libelle)
;
COMMIT;


-- 13. Insertion des libelles courts des Indices dans la table TA_OCS2D_LIBELLE_COURT
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_COURT a
USING
    (
    SELECT '1' AS valeur FROM DUAL UNION
    SELECT '2' AS valeur FROM DUAL UNION
    SELECT '3' AS valeur FROM DUAL UNION
    SELECT '4' AS valeur FROM DUAL UNION
    SELECT '5' AS valeur FROM DUAL UNION
    SELECT '6' AS valeur FROM DUAL UNION
    SELECT '7' AS valeur FROM DUAL UNION
    SELECT '8' AS valeur FROM DUAL UNION
    SELECT '9' AS valeur FROM DUAL UNION
    SELECT '10' AS valeur FROM DUAL UNION
    SELECT '11' AS valeur FROM DUAL UNION
    SELECT '12' AS valeur FROM DUAL UNION
    SELECT '13' AS valeur FROM DUAL UNION
    SELECT '14' AS valeur FROM DUAL UNION
    SELECT '15' AS valeur FROM DUAL UNION
    SELECT '16' AS valeur FROM DUAL UNION
    SELECT '17' AS valeur FROM DUAL UNION
    SELECT '18' AS valeur FROM DUAL UNION
    SELECT '19' AS valeur FROM DUAL UNION
    SELECT '20' AS valeur FROM DUAL UNION
    SELECT '21' AS valeur FROM DUAL
    )b
ON (UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN 
INSERT (a.valeur)
VALUES (b.valeur)
;
COMMIT;


-- 14. Insertion des relations Libelles courts et libelle dans la table TA_LIBELLE_CORRESPONDANCE des éléments de la nomclature 4 libelles.
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE a
USING
    (
    SELECT
        a.objectid AS fid_libelle,
        e.objectid AS fid_libelle_court
    FROM
        G_OCS2D.TA_OCS2D_LIBELLE a
        INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE c ON c.fid_libelle = a.objectid
        INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE d ON d.objectid = c.fid_famille,
        G_OCS2D.TA_OCS2D_LIBELLE_COURT e
    WHERE
        UPPER(d.valeur) = UPPER('famille « 4 libelles »')
        AND
            (
            (UPPER(e.valeur) = '1' AND UPPER(b.valeur) = UPPER('Espaces artificialisés')) OR
            (UPPER(e.valeur) = '2' AND UPPER(b.valeur) = UPPER('Espaces agricoles')) OR
            (UPPER(e.valeur) = '3' AND UPPER(b.valeur) = UPPER('Espaces naturels, semi-naturels')) OR
            (UPPER(e.valeur) = '4' AND UPPER(b.valeur) = UPPER('Infrastructures'))
            )
    )b
ON (a.fid_libelle = b.fid_libelle
AND a.fid_libelle_court = b.fid_libelle_court)
WHEN NOT MATCHED THEN 
INSERT (a.fid_libelle,a.fid_libelle_court)
VALUES (b.fid_libelle,b.fid_libelle_court)
;
COMMIT;


-- 15. Insertion des relations Libelles courts et libelle dans la table TA_LIBELLE_CORRESPONDANCE des éléments de la nomclature 21 libelles.
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE a
USING
    (
    SELECT
        a.objectid AS fid_libelle,
        e.objectid AS fid_libelle_court
    FROM
        G_OCS2D.TA_OCS2D_LIBELLE a
        INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE c ON c.fid_libelle = a.objectid
        INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE d ON d.objectid = c.fid_famille,
        G_OCS2D.TA_OCS2D_LIBELLE_COURT e
    WHERE
        UPPER(d.valeur) = UPPER('famille « 21 libelles »')
        AND
            (
            (UPPER(e.valeur) = '1' AND UPPER(b.valeur) = UPPER('Bâti de l’habitat')) OR
            (UPPER(e.valeur) = '2' AND UPPER(b.valeur) = UPPER('Bâti des exploitations agricoles')) OR
            (UPPER(e.valeur) = '3' AND UPPER(b.valeur) = UPPER('Bâti commercial')) OR
            (UPPER(e.valeur) = '4' AND UPPER(b.valeur) = UPPER('Bâti industriel et autres activités économiques')) OR
            (UPPER(e.valeur) = '5' AND UPPER(b.valeur) = UPPER('Bâti des services et transports')) OR
            (UPPER(e.valeur) = '6' AND UPPER(b.valeur) = UPPER('Autres bâtis')) OR
            (UPPER(e.valeur) = '7' AND UPPER(b.valeur) = UPPER('Routes')) OR
            (UPPER(e.valeur) = '8' AND UPPER(b.valeur) = UPPER('Voies ferrées')) OR
            (UPPER(e.valeur) = '9' AND UPPER(b.valeur) = UPPER('Zones aéroportuaires')) OR
            (UPPER(e.valeur) = '10' AND UPPER(b.valeur) = UPPER('Canaux et rivières navigables')) OR
            (UPPER(e.valeur) = '11' AND UPPER(b.valeur) = UPPER('Espaces non végétalisés de l''habitat')) OR
            (UPPER(e.valeur) = '12' AND UPPER(b.valeur) = UPPER('Espaces végétalisés de l''habitat')) OR
            (UPPER(e.valeur) = '13' AND UPPER(b.valeur) = UPPER('Autres espaces artificialisés non végétalisés')) OR
            (UPPER(e.valeur) = '14' AND UPPER(b.valeur) = UPPER('Autres espaces artificialisés végétalisés')) OR
            (UPPER(e.valeur) = '15' AND UPPER(b.valeur) = UPPER('Prairies')) OR
            (UPPER(e.valeur) = '16' AND UPPER(b.valeur) = UPPER('Cultures annuelles')) OR
            (UPPER(e.valeur) = '17' AND UPPER(b.valeur) = UPPER('Autres terres agricoles')) OR
            (UPPER(e.valeur) = '18' AND UPPER(b.valeur) = UPPER('Surfaces en eau')) OR
            (UPPER(e.valeur) = '19' AND UPPER(b.valeur) = UPPER('Espaces boisés')) OR
            (UPPER(e.valeur) = '20' AND UPPER(b.valeur) = UPPER('Espaces végétalisés non boisés')) OR
            (UPPER(e.valeur) = '21' AND UPPER(b.valeur) = UPPER('Espaces non végétalisés'))
            )
    )b
ON (a.fid_libelle = b.fid_libelle
AND a.fid_libelle_court = b.fid_libelle_court)
WHEN NOT MATCHED THEN 
INSERT (a.fid_libelle,a.fid_libelle_court)
VALUES (b.fid_libelle,b.fid_libelle_court)
;
COMMIT;


/*
Insertion des nomenclature COUVERT/USAGE OCS2D
*/
-- 16. Rassemblement dans une seule vue des nomenclatures US et CS des données OCS2D
 CREATE VIEW G_OCS2D.CS_US_OCS2D AS
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


-- 17. Vue simplifiant la nomenclature OCS2D usage pour faciliter sa normalisation.
CREATE VIEW G_OCS2D.OCS2D_NOMENCLATURE_COUVERT_USAGE AS 
SELECT DISTINCT
    niv_0_libelle_court AS libelle_court, 
    niv_0_libelle libelle_long,
    'niv_0' AS niveau,
    NIV_0_libelle_court AS source
FROM CS_US_OCS2D
UNION ALL
SELECT DISTINCT 
    niv_1_libelle_court AS libelle_court, 
    niv_1_libelle libelle_long,
    'niv_1' AS niveau,
    NIV_0_libelle_court AS source
FROM CS_US_OCS2D
UNION ALL
SELECT DISTINCT 
    niv_2_libelle_court AS libelle_court, 
    niv_2_libelle libelle_long,
    'niv_2' AS niveau,
    NIV_0_libelle_court AS source
FROM CS_US_OCS2D
UNION ALL
SELECT DISTINCT 
    niv_3_libelle_court AS libelle_court, 
    niv_3_libelle AS libelle_long,
    'niv_3' AS niveau,
    NIV_0_libelle_court AS source
FROM
    CS_US_OCS2D;


-- 18. Creation vue des relations
CREATE VIEW G_GEO.CS_US_OCS2D_RELATION AS
SELECT DISTINCT
    niv_1_libelle_court AS lcf,
    niv_1_libelle AS llf,
    niv_0_libelle_court AS lcp,
    niv_0_libelle AS llp
FROM G_GEO.CS_US_OCS2D
UNION ALL SELECT DISTINCT
    niv_2_libelle_court AS lcf,
    niv_2_libelle AS llf,
    niv_1_libelle_court AS lcp,
    niv_1_libelle AS llf
FROM G_GEO.CS_US_OCS2D
UNION ALL SELECT DISTINCT
    niv_3_libelle_court AS lcf,
    niv_3_libelle AS llf,
    niv_2_libelle_court AS lcp,
    niv_2_libelle AS llf
FROM G_GEO.CS_US_OCS2D;


-- 19. Insertion des libelles courts de la nomenclature couvert et usage dans la table TA_OCS2D_LIBELLE_COURT
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc
USING
	(
	SELECT DISTINCT
		libelle_court AS valeur
	FROM
		G_OCS2D.OCS2D_NOMENCLATURE_COUVERT_USAGE
	) temp
ON (temp.valeur = tlc.valeur)
WHEN NOT MATCHED THEN
INSERT (tlc.valeur)
VALUES (temp.valeur)
;
COMMIT;


-- 20. Insertion des libelles courts de la nomenclature couvert et usage dans la table TA_OCS2D_LIBELLE_LONG
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_LONG tl
USING
	(
	SELECT DISTINCT
		libelle_long AS valeur
	FROM
		G_OCS2D.OCS2D_NOMENCLATURE_COUVERT_USAGE
	) temp
ON (temp.valeur = tl.valeur)
WHEN NOT MATCHED THEN
INSERT (tl.valeur)
VALUES (temp.valeur)
;
COMMIT;

-- 21. Insertion des familles USAGE DU SOL et 'COUVERT DU SOL'" dans la table TA_OCS2D_FAMILLE.
MERGE INTO G_OCS2D.TA_OCS2D_FAMILLE tf
USING
	(
		SELECT 'USAGE DU SOL' AS valeur FROM DUAL
		UNION
		SELECT 'COUVERT DU SOL' AS valeur FROM DUAL
	)temp
ON (temp.valeur = tf.valeur)
WHEN NOT MATCHED THEN
INSERT (tf.valeur)
VALUES (temp.valeur)
;
COMMIT;


-- 22. creation de la table FUSION_OCS2D_COUVERT_USAGE pour normaliser les données.
CREATE TABLE G_OCS2D.FUSION_TA_OCS2D_COUVERT_USAGE AS
(
SELECT distinct
    d.objectid AS objectid,
    b.objectid AS fid_libelle_long,
    a.libelle_long,
    c.objectid AS fid_libelle_court,
    a.libelle_court,
    a.niveau,
    a.source
FROM
    G_OCS2D.TA_OCS2D_LIBELLE d,
	G_OCS2D.OCS2D_NOMENCLATURE_COUVERT_USAGE a
JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG b ON b.valeur = a.libelle_long
LEFT JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT c ON c.valeur = a.libelle_court
);

-- 23. Suppression des éléments de la table
DELETE FROM FUSION_TA_OCS2D_COUVERT_USAGE;
COMMIT;

-- 24. Insertion des données dans la table temporaire fusion utilisation de la séquence de la table TA_LIBELLE
INSERT INTO G_OCS2D.FUSION_TA_OCS2D_COUVERT_USAGE
with CTE as (
        SELECT
            MAX(objectid) AS objectid_max
        FROM
            G_OCS2D.TA_OCS2D_LIBELLE
            )
SELECT
-- attention à la séquence utilisée
    CTE.objectid_max + ROWNUM AS objectid,
-- attention à la séquence utilisée
    b.objectid AS fid_libelle_long,
    a.libelle_long,
    c.objectid AS fid_libelle_court,
    a.libelle_court,
    a.niveau,
    a.source
FROM
    G_OCS2D.OCS2D_NOMENCLATURE_COUVERT_USAGE a
JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG b ON b.valeur = a.libelle_long
LEFT JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT c ON c.valeur = a.libelle_court,
CTE;
COMMIT;

-- 25.  Insertion des libelles de la nomenclature USAGE et COUVERT dans la table TA_OCS2D_LIBELLE
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE l
USING
	(
	SELECT
		objectid, 
		fid_libelle_long as fid_libelle_long
	FROM 
        G_OCS2D.FUSION_TA_OCS2D_COUVERT_USAGE
	) temp
ON (temp.objectid = l.objectid
AND temp.fid_libelle_long = l.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (l.objectid,l.fid_libelle_long)
VALUES (temp.objectid,temp.fid_libelle_long)
;
COMMIT;

-- 26. Insertion des relations FAMILLE LIBELLE dans la table TA_FAMILLE_LIBELLE
MERGE INTO G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE l
USING
	(
	WITH CTE AS 
		(
		SELECT
			'US' AS SOURCE,
			a.objectid
		FROM
			G_OCS2D.TA_OCS2D_FAMILLE a
		WHERE
			UPPER(a.valeur) = UPPER('USAGE DU SOL')
		UNION
		SELECT
			'CS' AS SOURCE,
			a.objectid
		FROM
			G_OCS2D.TA_OCS2D_FAMILLE a
		WHERE
			UPPER(a.valeur) = UPPER('COUVERT DU SOL')
		)
	SELECT
		a.objectid as fid_libelle,
		CTE.objectid as fid_famille
	FROM 
        G_OCS2D.FUSION_TA_OCS2D_COUVERT_USAGE a
    INNER JOIN CTE ON a.source = CTE.source
	) temp
ON (temp.fid_libelle = l.fid_libelle
AND temp.fid_famille = l.fid_famille)
WHEN NOT MATCHED THEN
INSERT (l.fid_libelle,l.fid_famille)
VALUES (temp.fid_libelle,temp.fid_famille)
;
COMMIT;

-- 27. Insertion des relations entres les libelles dans la table TA_OCS2D_LIBELLE_RELATION.
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_RELATION tr
USING 
	(
	SELECT
	    ff.objectid fid_libelle_fils,
	    fp.objectid fid_libelle_parent
	FROM
	    G_OCS2D.FUSION_TA_OCS2D_COUVERT_USAGE ff,
	    G_OCS2D.FUSION_TA_OCS2D_COUVERT_USAGE fp,
	    G_OCS2D.CS_US_OCS2D_RELATION o
	WHERE
	        ff.libelle_court = o.lcf
	    AND
	        ff.libelle_long = o.llf
	    AND
	        fp.libelle_court =o.lcp
	    AND
	        fp.libelle_long =o.llp
	    AND
	    (
	        (ff.niveau = 'niv_1' AND fp.niveau = 'niv_0')
	    OR 
	        (ff.niveau = 'niv_2' AND fp.niveau = 'niv_1')
	    OR 
	        (ff.niveau = 'niv_3' AND fp.niveau = 'niv_2')
	    )
	)temp
ON (temp.fid_libelle_fils = tr.fid_libelle_fils
AND temp.fid_libelle_parent = tr.fid_libelle_parent)
WHEN NOT MATCHED THEN
INSERT (tr.fid_libelle_fils,tr.fid_libelle_parent)
VALUES (temp.fid_libelle_fils,temp.fid_libelle_parent)
;
COMMIT;


-- 28. Insertion des données dans ta_correspondance entre les libelles et les libelles courts dans la table TA_OCS2D_LIBELLE_CORRESPONDANCES
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc
USING
	(
	SELECT
		objectid AS fid_libelle, 
		fid_libelle_court AS fid_libelle_court
	FROM 
        G_OCS2D.FUSION_TA_OCS2D_COUVERT_USAGE
	) temp
ON (temp.fid_libelle = tc.fid_libelle
AND temp.fid_libelle_court = tc.fid_libelle_court)
WHEN NOT MATCHED THEN
INSERT (tc.fid_libelle,tc.fid_libelle_court)
VALUES (temp.fid_libelle,temp.fid_libelle_court)
;
COMMIT;

/*
Insertion de la nomenclature des indices de photo-interpretation.
*/
-- 29. Insertion de la famille Indice de confiance à la photo-interprétation OCS2D dans la table G_OCS2D.TA_OCS2D_FAMILLE.
MERGE INTO G_OCS2D.TA_OCS2D_FAMILLE a
USING
    (
    SELECT
        'Indice de confiance à la photo-interprétation OCS2D' AS valeur
    FROM
        DUAL
    ) b
ON (UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN 
INSERT (a.valeur)
VALUES (b.valeur);
COMMIT;

-- 30 Insertion des libelles des Indices dans la table G_OCS2D.TA_LIBELLE_LONG
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_LONG a
USING
    (
    SELECT 'photo-interprétation fiable' AS valeur FROM DUAL UNION
    SELECT 'photo-interprétation problématique – pas de donnée exogène ou de terrain pour soutenir l’interprétation' AS valeur FROM DUAL UNION
    SELECT 'données exogènes utilisées (précision de la référence biblio dans le champ source)' AS valeur FROM DUAL UNION
    SELECT '« dire d’expert »  (connaissances personnelles locales)' AS valeur FROM DUAL UNION
    SELECT 'validation terrain' AS valeur FROM DUAL
    )b
ON (UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN 
INSERT (a.valeur)
VALUES (b.valeur);
COMMIT;

-- 31. Insertion des données dans G_OCS2D.TA_LIBELLE
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE a
USING
    (
    SELECT
        a.objectid AS fid_libelle_long
    FROM
        G_OCS2D.TA_OCS2D_LIBELLE_LONG a
    WHERE
        UPPER(a.valeur) IN 
                        (
                        UPPER('photo-interprétation fiable'),
                        UPPER('photo-interprétation problématique – pas de donnée exogène ou de terrain pour soutenir l’interprétation'),
                        UPPER('données exogènes utilisées (précision de la référence biblio dans le champ source)'),
                        UPPER('« dire d’expert »  (connaissances personnelles locales)'),
                        UPPER('validation terrain')
                        )
    )b
ON (a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN 
INSERT (a.fid_libelle_long)
VALUES (b.fid_libelle_long)
;
COMMIT;

-- 32. Insertion des relations indice OCS2D et famille dans la table G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE
MERGE INTO G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE a
USING
    (
	SELECT
        a.objectid AS fid_famille,
        b.objectid AS fid_libelle
    FROM
        G_OCS2D.TA_OCS2D_FAMILLE a,
        G_OCS2D.TA_OCS2D_LIBELLE b
        INNER JOIN TA_OCS2D_LIBELLE_LONG c ON c.objectid = b.fid_libelle_long
    WHERE
        UPPER(a.valeur) = UPPER('Indice de confiance à la photo-interprétation OCS2D')
        AND UPPER(c.valeur) IN 
                            (
                            UPPER('photo-interprétation fiable'),
                            UPPER('photo-interprétation problématique – pas de donnée exogène ou de terrain pour soutenir l’interprétation'),
                            UPPER('données exogènes utilisées (précision de la référence biblio dans le champ source)'),
                            UPPER('« dire d’expert »  (connaissances personnelles locales)'),
                            UPPER('validation terrain')
                            )
    )b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle = b.fid_libelle)
WHEN NOT MATCHED THEN 
INSERT (a.fid_famille,a.fid_libelle)
VALUES (b.fid_famille,b.fid_libelle)
;
COMMIT;

-- 33. Insertion des libelles courts des Indices dans la table TA_LIBELLE_COURT
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_COURT a
USING
    (
    SELECT '1' AS valeur FROM DUAL UNION
    SELECT '2' AS valeur FROM DUAL UNION
    SELECT '3' AS valeur FROM DUAL UNION
    SELECT '4' AS valeur FROM DUAL UNION
    SELECT '5' AS valeur FROM DUAL
    )b
ON (UPPER(a.valeur) = UPPER(b.valeur))
WHEN NOT MATCHED THEN 
INSERT (a.valeur)
VALUES (b.valeur);
COMMIT;

-- 34. Insertion des relations Libelles courts et libelle dans la table TA_LIBELLE_CORRESPONDANCE
MERGE INTO G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE a
USING
    (
    SELECT
        a.objectid AS fid_libelle,
        e.objectid AS fid_libelle_court
    FROM
        G_OCS2D.TA_OCS2D_LIBELLE a
        INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE c ON c.fid_libelle = a.objectid
        INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE d ON d.objectid = c.fid_famille,
        G_OCS2D.TA_OCS2D_LIBELLE_COURT e
    WHERE
        UPPER(d.valeur) = UPPER('Indice de confiance à la photo-interprétation OCS2D')
        AND
            (
            (UPPER(e.valeur) = '1' AND UPPER(b.valeur) = UPPER('photo-interprétation fiable')) OR
            (UPPER(e.valeur) = '2' AND UPPER(b.valeur) = UPPER('photo-interprétation problématique – pas de donnée exogène ou de terrain pour soutenir l’interprétation')) OR
            (UPPER(e.valeur) = '3' AND UPPER(b.valeur) = UPPER('données exogènes utilisées (précision de la référence biblio dans le champ source)')) OR
            (UPPER(e.valeur) = '4' AND UPPER(b.valeur) = UPPER('« dire d’expert »  (connaissances personnelles locales)')) OR
            (UPPER(e.valeur) = '5' AND UPPER(b.valeur) = UPPER('validation terrain'))
            )
    )b
ON (a.fid_libelle = b.fid_libelle
AND a.fid_libelle_court = b.fid_libelle_court)
WHEN NOT MATCHED THEN 
INSERT (a.fid_libelle,a.fid_libelle_court)
VALUES (b.fid_libelle,b.fid_libelle_court)
;
COMMIT;


-- 35. Insertion des relations couvert / usage / poste dans la table TA_OCS2D_RELATION_LIBELLE_NOMENCLATURE
MERGE INTO TA_OCS2D_LIBELLE_RELATION_NOMENCLATURE a
USING
    (
    SELECT DISTINCT
        fid_libelle_cs,
        fid_libelle_us,
        fid_libelle_poste
    FROM
        (
        -- SELECTION NOMENCLATURE 4 POSTES
        -- 2005
        SELECT DISTINCT
            a.fid_libelle_niv_3 AS fid_libelle_cs,
            b.fid_libelle_niv_3 AS fid_libelle_us,
            c.fid_libelle AS fid_libelle_poste
        FROM
            temp_ocs2d_mel_multidate_2005_2015_2020 temp
            INNER JOIN V_NOMENCLATURE_OCS2D_OCCUPATION a ON a."LIBELLE_COURT_NIV_3" = temp.cs05
            INNER JOIN V_NOMENCLATURE_OCS2D_USAGE b ON b."LIBELLE_COURT_NIV_3" = temp.us05
            INNER JOIN V_NOMENCLATURE_OCS2D_4_POSTES c ON c.poste = temp."4POSTES_05"
        UNION
        -- 2015
        SELECT DISTINCT
            a.fid_libelle_niv_3 AS fid_libelle_cs,
            b.fid_libelle_niv_3 AS fid_libelle_us,
            c.fid_libelle AS fid_libelle_poste
        FROM
            temp_ocs2d_mel_multidate_2005_2015_2020 temp
            INNER JOIN V_NOMENCLATURE_OCS2D_OCCUPATION a ON a."LIBELLE_COURT_NIV_3" = temp.cs15
            INNER JOIN V_NOMENCLATURE_OCS2D_USAGE b ON b."LIBELLE_COURT_NIV_3" = temp.us15
            INNER JOIN V_NOMENCLATURE_OCS2D_4_POSTES c ON c.poste = temp."4POSTES_15"
        UNION
        -- 2020
        SELECT DISTINCT
            a.fid_libelle_niv_3 AS fid_libelle_cs,
            b.fid_libelle_niv_3 AS fid_libelle_us,
            c.fid_libelle AS fid_libelle_poste
        FROM
            temp_ocs2d_mel_multidate_2005_2015_2020 temp
            INNER JOIN V_NOMENCLATURE_OCS2D_OCCUPATION a ON a."LIBELLE_COURT_NIV_3" = temp.cs20
            INNER JOIN V_NOMENCLATURE_OCS2D_USAGE b ON b."LIBELLE_COURT_NIV_3" = temp.us20
            INNER JOIN V_NOMENCLATURE_OCS2D_4_POSTES c ON c.poste = temp."4POSTES_20"
        UNION
        -- SELECTION NOMENCLATURE 21 POSTES
        -- 2005
        SELECT DISTINCT
            a.fid_libelle_niv_3 AS fid_libelle_cs,
            b.fid_libelle_niv_3 AS fid_libelle_us,
            c.fid_libelle AS fid_libelle_poste
        FROM
            temp_ocs2d_mel_multidate_2005_2015_2020 temp
            INNER JOIN V_NOMENCLATURE_OCS2D_OCCUPATION a ON a."LIBELLE_COURT_NIV_3" = temp.cs05
            INNER JOIN V_NOMENCLATURE_OCS2D_USAGE b ON b."LIBELLE_COURT_NIV_3" = temp.us05
            INNER JOIN V_NOMENCLATURE_OCS2D_21_POSTES c ON c.poste = temp."21_P_05"
        UNION
        -- 2015
        SELECT DISTINCT
            a.fid_libelle_niv_3 AS fid_libelle_cs,
            b.fid_libelle_niv_3 AS fid_libelle_us,
            c.fid_libelle AS fid_libelle_poste
        FROM
            temp_ocs2d_mel_multidate_2005_2015_2020 temp
            INNER JOIN V_NOMENCLATURE_OCS2D_OCCUPATION a ON a."LIBELLE_COURT_NIV_3" = temp.cs15
            INNER JOIN V_NOMENCLATURE_OCS2D_USAGE b ON b."LIBELLE_COURT_NIV_3" = temp.us15
            INNER JOIN V_NOMENCLATURE_OCS2D_21_POSTES c ON c.poste = temp."21_P_15"
        UNION
        -- 2020
        SELECT DISTINCT
            a.fid_libelle_niv_3 AS fid_libelle_cs,
            b.fid_libelle_niv_3 AS fid_libelle_us,
            c.fid_libelle AS fid_libelle_poste
        FROM
            temp_ocs2d_mel_multidate_2005_2015_2020 temp
            INNER JOIN V_NOMENCLATURE_OCS2D_OCCUPATION a ON a."LIBELLE_COURT_NIV_3" = temp.cs20
            INNER JOIN V_NOMENCLATURE_OCS2D_USAGE b ON b."LIBELLE_COURT_NIV_3" = temp.us20
            INNER JOIN V_NOMENCLATURE_OCS2D_21_POSTES c ON c.poste = temp."21_P_20"
        )
    )temp
ON (a.fid_libelle_cs = temp.fid_libelle_cs
AND a.fid_libelle_us = temp.fid_libelle_us
AND a.fid_libelle_poste = temp.fid_libelle_poste)
WHEN NOT MATCHED THEN INSERT
(a.fid_libelle_cs, a.fid_libelle_us, a.fid_libelle_poste)
VALUES(temp.fid_libelle_cs, temp.fid_libelle_us, temp.fid_libelle_poste)
;


/*
Remise à jour des séquences.
*/
-- 36. TA_OCS2D_FAMILLE
-- 36.1. Suppression de la séquence SEQ_TA_OCS2D_FAMILLE_OBJECTID
DROP SEQUENCE SEQ_TA_OCS2D_FAMILLE_OBJECTID;

-- 36.2. Creation de la sequence SEQ_TA_OCS2D_FAMILLE_OBJECTID avec la bonne incrémentation de départ.
SET SERVEROUTPUT ON
DECLARE
    v_new_id NUMBER(38,0);

    BEGIN
    -- Sélection de l'identifiant à partir duquel faire reprendre l'incrémentation
        SELECT
            MAX(OBJECTID) + 1
            INTO v_new_id
        FROM
            G_OCS2D.TA_OCS2D_FAMILLE;

    -- Création de la séquence SEQ_TA_OCS2D_FAMILLE_OBJECTID
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_OCS2D_FAMILLE_OBJECTID INCREMENT BY 1 START WITH ' || v_new_id;
    END;

    /

-- 37. TA_OCS2D_LIBELLE_LONG

-- 37.1. Suppression de la séquence SEQ_TA_OCS2D_LIBELLE_LONG_OBJECTID
DROP SEQUENCE SEQ_TA_OCS2D_LIBELLE_LONG_OBJECTID;

-- 37.2. Creation de la sequence SEQ_TA_OCS2D_LIBELLE_LONG_OBJECTID avec la bonne incrémentation de départ.
SET SERVEROUTPUT ON
DECLARE
    v_new_id NUMBER(38,0);

    BEGIN
    -- Sélection de l'identifiant à partir duquel faire reprendre l'incrémentation
        SELECT
            MAX(OBJECTID) + 1
            INTO v_new_id
        FROM
            G_OCS2D.TA_OCS2D_LIBELLE_LONG;

    -- Création de la séquence SEQ_TA_OCS2D_LIBELLE_LONG_OBJECTID
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_OCS2D_LIBELLE_LONG_OBJECTID INCREMENT BY 1 START WITH ' || v_new_id;
    END;

    /

-- 38. TA_OCS2D_LIBELLE
-- 38.1. Suppression de la séquence SEQ_TA_OCS2D_GEOM_OBJECTID
DROP SEQUENCE SEQ_TA_OCS2D_LIBELLE_OBJECTID;

-- 38.2. Creation de la sequence SEQ_TA_OCS2D_GEOM_OBJECTID avec la bonne incrémentation de départ.
SET SERVEROUTPUT ON
DECLARE
    v_new_id NUMBER(38,0);

    BEGIN
    -- Sélection de l'identifiant à partir duquel faire reprendre l'incrémentation
        SELECT
            MAX(OBJECTID) + 1
            INTO v_new_id
        FROM
            G_OCS2D.TA_OCS2D_LIBELLE;

    -- Création de la séquence SEQ_TA_OCS2D_LIBELLE_OBJECTID
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_OCS2D_LIBELLE_OBJECTID INCREMENT BY 1 START WITH ' || v_new_id;
    END;

    /

-- 39. TA_OCS2D_FAMILLE_LIBELLE
-- 39.1. Suppression de la séquence SEQ_TA_OCS2D_FAMILLE_LIBELLE_OBJECTID
DROP SEQUENCE SEQ_TA_OCS2D_FAMILLE_LIBELLE_OBJECTID;

-- 39.2. Creation de la sequence SEQ_TA_OCS2D_GEOM_OBJECTID avec la bonne incrémentation de départ.
SET SERVEROUTPUT ON
DECLARE
    v_new_id NUMBER(38,0);

    BEGIN
    -- Sélection de l'identifiant à partir duquel faire reprendre l'incrémentation
        SELECT
            MAX(OBJECTID) + 1
            INTO v_new_id
        FROM
            G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE;

    -- Création de la séquence SEQ_TA_OCS2D_FAMILLE_LIBELLE_OBJECTID
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_OCS2D_FAMILLE_LIBELLE_OBJECTID INCREMENT BY 1 START WITH ' || v_new_id;
    END;

    /

-- 40. TA_OCS2D_LIBELLE_COURT
-- 40.1. Suppression de la séquence SEQ_TA_OCS2D_LIBELLE_COURT_OBJECTID
DROP SEQUENCE SEQ_TA_OCS2D_LIBELLE_COURT_OBJECTID;

-- 40.2. Creation de la sequence SEQ_TA_OCS2D_LIBELLE_COURT_OBJECTID avec la bonne incrémentation de départ.
SET SERVEROUTPUT ON
DECLARE
    v_new_id NUMBER(38,0);

    BEGIN
    -- Sélection de l'identifiant à partir duquel faire reprendre l'incrémentation
        SELECT
            MAX(OBJECTID) + 1
            INTO v_new_id
        FROM
            G_OCS2D.TA_OCS2D_LIBELLE_COURT;

    -- Création de la séquence SEQ_TA_OCS2D_LIBELLE_COURT_OBJECTID
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_OCS2D_LIBELLE_COURT_OBJECTID INCREMENT BY 1 START WITH ' || v_new_id;
    END;

    /

-- 41. TA_OCS2D_LIBELLE_CORRESPONDANCE
-- 41.1. Suppression de la séquence SEQ_TA_OCS2D_LIBELLE_CORRESPONDANCE_OBJECTID
DROP SEQUENCE SEQ_TA_OCS2D_LIBELLE_CORRESPONDANCE_OBJECTID;

-- 41.2. Creation de la sequence SEQ_TA_OCS2D_LIBELLE_CORRESPONDANCE_OBJECTID avec la bonne incrémentation de départ.
SET SERVEROUTPUT ON
DECLARE
    v_new_id NUMBER(38,0);

    BEGIN
    -- Sélection de l'identifiant à partir duquel faire reprendre l'incrémentation
        SELECT
            MAX(OBJECTID) + 1
            INTO v_new_id
        FROM
            G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE;

    -- Création de la séquence SEQ_TA_OCS2D_LIBELLE_CORRESPONDANCE_OBJECTID
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_OCS2D_LIBELLE_CORRESPONDANCE_OBJECTID INCREMENT BY 1 START WITH ' || v_new_id;
    END;

    /

-- 42. TA_OCS2D_LIBELLE_RELATION
-- 42.1. Suppression de la séquence SEQ_TA_OCS2D_LIBELLE_RELATION_OBJECTID
DROP SEQUENCE SEQ_TA_OCS2D_LIBELLE_OBJECTID;

-- 42.2. Creation de la sequence SEQ_TA_OCS2D_LIBELLE_RELATION_OBJECTID avec la bonne incrémentation de départ.
SET SERVEROUTPUT ON
DECLARE
    v_new_id NUMBER(38,0);

    BEGIN
    -- Sélection de l'identifiant à partir duquel faire reprendre l'incrémentation
        SELECT
            MAX(OBJECTID) + 1
            INTO v_new_id
        FROM
            G_OCS2D.TA_OCS2D_LIBELLE_RELATION;

    -- Création de la séquence SEQ_TA_OCS2D_LIBELLE_RELATION_OBJECTID
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_OCS2D_LIBELLE_RELATION_OBJECTID INCREMENT BY 1 START WITH ' || v_new_id;
    END;

    /

-- 43. TA_OCS2D_LIBELLE_RELATION_NOMENCLATURE
-- 43.1. Suppression de la séquence SEQ_TA_OCS2D_LIBELLE_RELATION_NOMENCLATURE_OBJECTID
DROP SEQUENCE SEQ_TA_OCS2D_LIBELLE_RELATION_NOMENCLATURE_OBJECTID;

-- 43.2. Creation de la sequence SEQ_TA_OCS2D_GEOM_OBJECTID avec la bonne incrémentation de départ.
SET SERVEROUTPUT ON
DECLARE
    v_new_id NUMBER(38,0);

    BEGIN
    -- Sélection de l'identifiant à partir duquel faire reprendre l'incrémentation
        SELECT
            MAX(OBJECTID) + 1
            INTO v_new_id
        FROM
            G_OCS2D.TA_OCS2D_LIBELLE_RELATION_NOMENCLATURE;

    -- Création de la séquence SEQ_TA_OCS2D_LIBELLE_RELATION_NOMENCLATURE_OBJECTID
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_TA_OCS2D_LIBELLE_RELATION_NOMENCLATURE_OBJECTID INCREMENT BY 1 START WITH ' || v_new_id;
    END;

    /

-- 44. Suppression des tables et des vues utilisés seulement pour l'insertion de la nomenclature.
-- 44.1. Suppression de la table temporaire CS_US_OCS2D
DROP TABLE CS_US_OCS2D CASCADE CONSTRAINTS PURGE;

-- 44.2. Suppression de la table temporaire FUSION_OCS2D_COUVERT_USAGE
DROP TABLE FUSION_OCS2D_COUVERT_USAGE CASCADE CONSTRAINTS PURGE;

-- 44.3. Suppression de la vue CS_US_OCS2D
DROP VIEW CS_US_OCS2D CASCADE CONSTRAINTS;

-- 44.4. Suppression de la vue OCS2D_NOMENCLATURE_COUVERT_USAGE
DROP VIEW OCS2D_NOMENCLATURE_COUVERT_USAGE CASCADE CONSTRAINTS;

-- 44.5. Suppression de la vue CS_US_OCS2D_relation
DROP VIEW CS_US_OCS2D_relation CASCADE CONSTRAINTS;

-- 44.6. Suppression de la vue ocs2d_nomenclature_couvert_usage
DROP VIEW ocs2d_nomenclature_couvert_usage CASCADE CONSTRAINTS;