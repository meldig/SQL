-- Requete sql necessaire à la l'insertion de la nomenclature OCS2D


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


--------------------------------------------------------------------------------
-- INSERTION DE LA NOMENCLATURE COUVERT USAGE DES DONNEES OCS2D
--------------------------------------------------------------------------------
-- 9. Rassemblement dans une seule vue des nomenclatures US et CS des données OCS2D
 CREATE VIEW G_GEO.CS_US_OCS2D AS
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


-- 10. Vue simplifiant la nomenclature OCS2D usage pour faciliter sa normalisation.
CREATE VIEW G_GEO.OCS2D_NOMENCLATURE_COUVERT_USAGE AS 
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


-- 11. Insertion des libelles courts dans TA_LIBELLE_COURT
MERGE INTO G_GEO.TA_LIBELLE_COURT tlc
USING
	(
	SELECT DISTINCT
		libelle_court AS valeur
	FROM
		G_GEO.OCS2D_NOMENCLATURE_COUVERT_USAGE
	) temp
ON (temp.valeur = tlc.valeur)
WHEN NOT MATCHED THEN
INSERT (tlc.valeur)
VALUES (temp.valeur)
;


-- 12. Insertion des libelles longs dans TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG tl
USING
	(
	SELECT DISTINCT
		libelle_long AS valeur
	FROM
		G_GEO.OCS2D_NOMENCLATURE_COUVERT_USAGE
	) temp
ON (temp.valeur = tl.valeur)
WHEN NOT MATCHED THEN
INSERT (tl.valeur)
VALUES (temp.valeur)
;


-- 13. Insertion de la famille dans TA_FAMILLE
MERGE INTO G_GEO.TA_FAMILLE tf
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


-- 14. Insertion des relations dans TA_FAMILLE_LIBELLE pour les libelles de la famille OCS2D COUVERT DU SOL
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE tfl
USING
	(
	SELECT
		f.objectid fid_famille,
		l.objectid fid_libelle_long
    FROM
        G_GEO.TA_FAMILLE f,
        G_GEO.TA_LIBELLE_LONG l
	WHERE 
		f.valeur = 'COUVERT DU SOL' AND
		l.valeur IN
			(
			SELECT DISTINCT
				libelle_long
			FROM
				G_GEO.OCS2D_NOMENCLATURE_COUVERT_USAGE
			WHERE
				SOURCE = 'CS'
			)
		) temp
ON (temp.fid_famille = tfl.fid_famille
AND temp.fid_libelle_long = tfl.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (tfl.fid_famille,tfl.fid_libelle_long)
VALUES (temp.fid_famille,temp.fid_libelle_long)
;

-- 15. Insertion des relations dans TA_FAMILLE_LIBELLE pour les libelles de la famille OCS2D USAGE DU SOL
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE tfl
USING
	(
	SELECT
		f.objectid fid_famille,
		l.objectid fid_libelle_long
    FROM
        G_GEO.TA_FAMILLE f,
        G_GEO.TA_LIBELLE_LONG l
	WHERE 
		f.valeur = 'USAGE DU SOL' AND
		l.valeur IN
			(
			SELECT DISTINCT
				libelle_long
			FROM
				G_GEO.OCS2D_NOMENCLATURE_COUVERT_USAGE
			WHERE
				SOURCE = 'US'
			)
		) temp
ON (temp.fid_famille = tfl.fid_famille
AND temp.fid_libelle_long = tfl.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (tfl.fid_famille,tfl.fid_libelle_long)
VALUES (temp.fid_famille,temp.fid_libelle_long)
;

-- 16. Creation vue des relations
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


-- 17. creation de la table FUSION_OCS2D_COUVERT_USAGE pour normaliser les données.
CREATE TABLE G_GEO.FUSION_OCS2D_COUVERT_USAGE AS
(SELECT
    d.objectid AS objectid,
    b.objectid AS fid_libelle_long,
    a.libelle_long,
    c.objectid AS fid_libelle_court,
    a.libelle_court,
    a.niveau
FROM
    G_GEO.TA_LIBELLE d,
	G_GEO.OCS2D_NOMENCLATURE_COUVERT_USAGE a
JOIN G_GEO.TA_LIBELLE_LONG b ON b.valeur = a.libelle_long
LEFT JOIN G_GEO.TA_LIBELLE_COURT c ON c.valeur = a.libelle_court);


-- 18. Insertion des données dans la table temporaire fusion utilisation de la séquence de la table TA_LIBELLE
INSERT INTO G_GEO.FUSION_OCS2D_COUVERT_USAGE
with CTE as (
        SELECT
            MAX(objectid) AS objectid_max
        FROM
            G_GEO.TA_LIBELLE
            )
SELECT
-- attention à la séquence utilisée
    CTE.objectid_max + ROWNUM AS objectid,
-- attention à la séquence utilisée
    b.objectid AS fid_libelle_long,
    a.libelle_long,
    c.objectid AS fid_libelle_court,
    a.libelle_court,
    a.niveau
FROM
    G_GEO.OCS2D_NOMENCLATURE_COUVERT_USAGE a
JOIN TA_LIBELLE_LONG b ON b.valeur = a.libelle_long
LEFT JOIN TA_LIBELLE_COURT c ON c.valeur = a.libelle_court,
CTE;


-- 19. Insertion des données dans ta_libelle
MERGE INTO G_GEO.TA_LIBELLE l
USING
	(
	SELECT
		objectid, 
		fid_libelle_long
	FROM 
        G_GEO.FUSION_OCS2D_COUVERT_USAGE
	) temp
ON (temp.objectid = l.objectid
AND temp.fid_libelle_long = l.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (l.objectid,l.fid_libelle_long)
VALUES (temp.objectid,temp.fid_libelle_long)
;


-- 20. Insertion des données dans ta_correspondance_libelle
MERGE INTO G_GEO.TA_LIBELLE_CORRESPONDANCE tc
USING
	(
	SELECT
		objectid, 
		fid_libelle_court
	FROM 
        G_GEO.FUSION_OCS2D_COUVERT_USAGE
	) temp
ON (temp.objectid = tc.fid_libelle
AND temp.fid_libelle_court = tc.fid_libelle_court)
WHEN NOT MATCHED THEN
INSERT (tc.fid_libelle,tc.fid_libelle_court)
VALUES (temp.objectid,temp.fid_libelle_court)
;


-- 21. Insertion des données dans ta_relation_libelle
MERGE INTO G_GEO.TA_LIBELLE_RELATION tr
USING 
	(
	SELECT
	    ff.objectid fid_libelle_fils,
	    fp.objectid fid_libelle_parent
	FROM
	    G_GEO.FUSION_OCS2D_COUVERT_USAGE ff,
	    G_GEO.FUSION_OCS2D_COUVERT_USAGE fp,
	    G_GEO.CS_US_OCS2D_RELATION o
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


-- 22. Insertion des indices OCS2D
-- 22.1. Insertion de la famille Indice de confiance à la photo-interprétation OCS2D dans la table G_GEO.TA_FAMILLE.
MERGE INTO G_GEO.TA_FAMILLE a
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


-- 22.2. Insertion des libelles des Indices dans la table G_GEO.TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
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


-- 22.3. Insertion des relations indice OCS2D et famille dans la table G_GEO.TA_FAMILLE_LIBELLE
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING
    (
    SELECT
        a.objectid AS fid_famille,
        b.objectid AS fid_libelle_long
    FROM
        G_GEO.TA_FAMILLE a,
        G_GEO.TA_LIBELLE_LONG b
    WHERE
        UPPER(a.valeur) = UPPER('Indice de confiance à la photo-interprétation OCS2D')
        AND UPPER(b.valeur) IN 
                            (
                            UPPER('photo-interprétation fiable'),
                            UPPER('photo-interprétation problématique – pas de donnée exogène ou de terrain pour soutenir l’interprétation'),
                            UPPER('données exogènes utilisées (précision de la référence biblio dans le champ source)'),
                            UPPER('« dire d’expert »  (connaissances personnelles locales)'),
                            UPPER('validation terrain')
                            )
    )b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN 
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES (b.fid_famille,b.fid_libelle_long)
;


-- 22.4. Insertion des données dans G_GEO.TA_LIBELLE
MERGE INTO G_GEO.TA_LIBELLE a
USING
    (
    SELECT
        a.objectid AS fid_libelle_long
    FROM
        G_GEO.TA_LIBELLE_LONG a
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


-- 22.5. Insertion des libelles courts des Indices dans la table TA_LIBELLE_COURT
MERGE INTO G_GEO.TA_LIBELLE_COURT a
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


-- 22.6. Insertion des relations Libelles courts et libelle dans la table TA_LIBELLE_CORRESPONDANCE
MERGE INTO G_GEO.TA_LIBELLE_CORRESPONDANCE a
USING
    (
    SELECT
        a.objectid AS fid_libelle,
        e.objectid AS fid_libelle_court
    FROM
        G_GEO.TA_LIBELLE a
        INNER JOIN G_GEO.TA_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
        INNER JOIN G_GEO.TA_FAMILLE_LIBELLE c ON c.fid_libelle_long = b.objectid
        INNER JOIN G_GEO.TA_FAMILLE d ON d.objectid = c.fid_famille,
        G_GEO.TA_LIBELLE_COURT e
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


-- 23. Suppression des tables et des vues utilisés seulement pour l'insertion de la nomenclature.
-- 23.1. Suppression de la table temporaire CS_US_OCS2D
DROP TABLE CS_US_OCS2D CASCADE CONSTRAINTS PURGE;

-- 23.2. Suppression de la table temporaire FUSION_OCS2D_COUVERT_USAGE
DROP TABLE FUSION_OCS2D_COUVERT_USAGE CASCADE CONSTRAINTS PURGE;

-- 23.3. Suppression de la vue CS_US_OCS2D
DROP VIEW CS_US_OCS2D CASCADE CONSTRAINTS;

-- 23.4. Suppression de la vue OCS2D_NOMENCLATURE_COUVERT_USAGE
DROP VIEW OCS2D_NOMENCLATURE_COUVERT_USAGE CASCADE CONSTRAINTS;

-- 23.5. Suppression de la vue CS_US_OCS2D_relation
DROP VIEW CS_US_OCS2D_relation CASCADE CONSTRAINTS;

-- 23.6. Suppression de la vue ocs2d_nomenclature_couvert_usage
DROP VIEW ocs2d_nomenclature_couvert_usage CASCADE CONSTRAINTS;