-- Fichier regroupant les différentes requêtes nécessaires à l'insertion des éléments issus de la Base Permanente des Equipements BPE.

-- 1. Insertion de la source dans G_GEO.TA_SOURCE.
MERGE INTO G_GEO.TA_SOURCE a
USING
	(
		SELECT 'Base Permanente des Equipements' AS NOM_SOURCE,'Inventaire des équipements présents sur le territoire' AS description FROM DUAL
    ) b
ON (a.nom_source = b.nom_source
AND a.description = b.description)
WHEN NOT MATCHED THEN
INSERT (a.nom_source,a.description)
VALUES (b.nom_source,b.description)
;


-- 2. Insertion de la provenance dans G_GEO.TA_PROVENANCE
MERGE INTO G_GEO.TA_PROVENANCE a
USING
    (
    	SELECT 'https://www.insee.fr/fr/statistiques/3568638?sommaire=3568656' AS url,'Données en téléchargement libre' AS methode_acquisition FROM DUAL
   	) b
ON (a.url = b.url
AND a.methode_acquisition = b.methode_acquisition)
WHEN NOT MATCHED THEN
INSERT (a.url,a.methode_acquisition)
VALUES(b.url,b.methode_acquisition)
;


-- 3. Insertion des données dans G_GEO.TA_DATE_ACQUISITION
MERGE INTO G_GEO.TA_DATE_ACQUISITION a
USING
	(
		SELECT TO_DATE('15/09/2020') AS DATE_ACQUISITION, TO_DATE('01/01/2019') AS MILLESIME,'rjault' AS OBTENTEUR FROM DUAL
	) b
ON (a.date_acquisition = b.date_acquisition
AND a.millesime = b.millesime)
WHEN NOT MATCHED THEN
INSERT (a.date_acquisition,a.millesime)
VALUES (b.date_acquisition,b.millesime)
;


-- 4. Insertion des données dans G_GEO.TA_ORGANISME
MERGE INTO G_GEO.TA_ORGANISME a
USING
	(
		SELECT 'INSEE' AS ACRONYME, 'Institut National de la Statistique et des Etudes Economiques' AS NOM_ORGANISME FROM DUAL
	) b
ON (a.acronyme = b.acronyme)
WHEN NOT MATCHED THEN
INSERT (a.acronyme,a.nom_organisme)
VALUES(b.acronyme,b.nom_organisme)
;


-- 5. Insertion des échelles dans G_GEO.TA_ECHELLE
/*
Afin de qualifier au mieux les coordonnées(x,y) diffusées, un indicateur de qualité de celle-ci est misà disposition pour chaque équipement. Il comporte cinq modalités:
bonne : l'écart des coordonnées (x,y) fournies avec la réalité du terrain est inférieur à 100 m ;
acceptable : l'écart maximum des coordonnées (x,y) fournies avec la réalité du terrain est compris entre 100 m et 500 m ;
mauvaise : l'écart maximum des coordonnées (x,y) fournies avec la réalité du terrain est supérieur à 500 m et des imputations aléatoires ont pu être effectuées ;
non géolocalisé : pas de coordonnées (x,y) fournies dans les domaines disponibles cette année en géolocalisation car cette dernière a été impossible à réaliser au regard des adresses contenues dans les référentiels géographiques actuels de l'Insee ;
type_équipement_non_géolocalisé_cette_année : pas de coordonnées (x,y) fournies car les équipements concernés appartiennent à des domaines d'équipements dont la géolocalisation n'est pas mise à disposition cette année.
Cette distinction permet de develloper 4 echelles pour l'utilisation des données.
si l'indicateur est bon: l'echelle d'utilisation sera 1/10000,
si l'indicateur est acceptable: l'echelle d'utilisation sera 1/30000,
si l'indicateur est mauvaise: l'echelle d'utilisation sera 1/50000,
si l'équipement n'est pas géolocalisé ou alors pas cette année: l'echelle d'utilisation sera 1/1000000
*/
/*
MERGE INTO G_GEO.TA_ECHELLE a
USING
	(
		SELECT '10000' AS VALEUR FROM DUAL
		UNION SELECT '30000' AS VALEUR FROM DUAL
		UNION SELECT '50000' AS VALEUR FROM DUAL
		UNION SELECT '1000000' AS VALEUR FROM DUAL
	) b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES(b.valeur)
;
*/


-- 6. Insertion des données dans G_GEO.TA_METADONNEE
MERGE INTO G_GEO.TA_METADONNEE a
USING
	(
		SELECT 
	    a.objectid AS FID_SOURCE,
	    b.objectid AS FID_ACQUISITION,
	    c.objectid AS FID_PROVENANCE
		FROM
		    G_GEO.TA_SOURCE a,
		    G_GEO.TA_DATE_ACQUISITION b,
		    G_GEO.TA_PROVENANCE c
		WHERE
		    a.nom_source = 'Base Permanente des Equipements'
		AND
		    b.millesime IN ('01/01/2019')
		AND
		    b.date_acquisition = '15/09/2020'
		AND
		    c.url = 'https://www.insee.fr/fr/statistiques/3568638?sommaire=3568656'
		AND
			c.methode_acquisition = 'Données en téléchargement libre'
	)b
ON (a.fid_source = b.fid_source
AND a.fid_acquisition = b.fid_acquisition
AND a.fid_provenance = b.fid_provenance)
WHEN NOT MATCHED THEN
INSERT (a.fid_source,a.fid_acquisition,a.fid_provenance)
VALUES(b.fid_source ,b.fid_acquisition,b.fid_provenance)
;


-- 7. Insertion des données dans la table G_GEO.TA_METADONNEE_RELATION_ORGANISME
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
            b.nom_source = 'Base Permanente des Equipements'
		AND
		    c.millesime IN ('01/01/2019')
		AND
		    c.date_acquisition = '15/09/2020'
        AND
            d.url = 'https://www.insee.fr/fr/statistiques/3568638?sommaire=3568656'
        AND
            e.nom_organisme IN ('Institut National de la Statistique et des Etudes Economiques')
    )b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_organisme = b.fid_organisme)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_organisme)
VALUES(b.fid_metadonnee, b.fid_organisme)
;

/*
-- 8. Insertion des données dans la table G_GEO.TA_METADONNEE_RELATION_ECHELLE
MERGE INTO ta_metadonnee_relation_echelle a
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
		    b.nom_source = 'Base Permanente des Equipements'
		AND
		    c.date_acquisition = '06/04/2020'
		AND
		    c.millesime = '01/01/2018'
		AND
		    d.url = 'https://www.insee.fr/fr/statistiques/3568638?sommaire=3568656'
		AND
		    f.nom_organisme IN ('Institut National de la Statistique et des Etudes Economiques')
		AND
		    g.valeur IN ('10000','30000','50000','1000000')
    )b
ON(a.fid_metadonnee = b.fid_metadonnee
AND a.fid_echelle = b.fid_echelle)
WHEN NOT MATCHED THEN
INSERT(a.fid_metadonnee, a.fid_echelle)
VALUES(b.fid_metadonnee, b.fid_echelle)
;
*/

-- 9. Création de la vue G_GEO.BPE_NOMENCLATURE_LISTE pour simplifier son insertion
CREATE OR REPLACE VIEW G_GEO.BPE_NOMENCLATURE_LISTE AS
SELECT DISTINCT
	LC_niv_0 AS libelle_court, 
	LL_niv_0 AS libelle_long,
	'niv_0' AS niveau
FROM G_GEO.BPE_NOMENCLATURE
UNION ALL
SELECT DISTINCT
	LC_niv_1 AS libelle_court, 
	LL_niv_1 AS libelle_long,
	'niv_1' AS niveau
FROM G_GEO.BPE_NOMENCLATURE
UNION ALL
SELECT DISTINCT
	LC_niv_2 AS libelle_court, 
	LL_niv_2 AS libelle_long,
	'niv_2' AS niveau
FROM G_GEO.BPE_NOMENCLATURE
UNION ALL
SELECT DISTINCT
	LC_niv_3 AS libelle_court, 
	LL_niv_3 AS libelle_long,
	'niv_3' AS niveau
FROM
	G_GEO.BPE_NOMENCLATURE;


-- 10. Insertion des libelles courts dans G_GEO.TA_LIBELLE_COURT
MERGE INTO G_GEO.TA_LIBELLE_COURT a
USING
	(
	SELECT DISTINCT
		libelle_court
	FROM
		G_GEO.BPE_NOMENCLATURE_LISTE
	) b
ON (a.valeur = b.libelle_court)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.libelle_court)
;


-- 11. Insertion des libelles longs dans G_GEO.TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
USING
	(
	SELECT DISTINCT
		libelle_long
	FROM
		G_GEO.BPE_NOMENCLATURE_LISTE
	) b
ON (a.valeur = b.libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.libelle_long)
;


-- 12. Insertion de la famille 'BPE' dans la table G_GEO.TA_FAMILLE
MERGE INTO TA_FAMILLE a
USING
	(
		SELECT 'BPE' AS VALEUR FROM DUAL
	)b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;


-- 13. Insertion des relations familles-libelles dans G_GEO.TA_FAMILLE_LIBELLE
MERGE INTO TA_FAMILLE_LIBELLE a
USING
	(
	SELECT
		f.objectid fid_famille,
		l.objectid fid_libelle_long
    FROM
        G_GEO.TA_FAMILLE f,
        G_GEO.TA_LIBELLE_LONG l
	WHERE 
		f.valeur = 'BPE' AND
		l.valeur IN
			(
			SELECT DISTINCT
				libelle_long
			FROM
				G_GEO.BPE_NOMENCLATURE_LISTE
			)
		) b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES (b.fid_famille,b.fid_libelle_long)
;


-- 14. Creation d'une vue des relations entre les libelles 'BPE' pour faciliter l'insertion des libelles
CREATE OR REPLACE VIEW G_GEO.G_GEO.BPE_RELATION AS
SELECT DISTINCT
    lc_niv_1 AS lcf,
    ll_niv_1 AS llf,
    lc_niv_0 AS lcp,
    ll_niv_0 AS llp
FROM G_GEO.BPE_NOMENCLATURE
UNION All SELECT DISTINCT
    lc_niv_2 AS lcf,
    ll_niv_2 AS llf,
    lc_niv_1 AS lcp,
    ll_niv_1 AS llp
FROM G_GEO.BPE_NOMENCLATURE
UNION All SELECT DISTINCT
    lc_niv_3 AS lcf,
    ll_niv_3 AS llf,
    lc_niv_2 AS lcp,
    ll_niv_2 AS llp
FROM G_GEO.BPE_NOMENCLATURE;



-- 15. creation de la table G_GEO.BPE_FUSION pour normaliser les données.
-- Cette table est nécessaire pour récuperer l'ensemble des objectids des libellés et ainsi pouvoir insérer en base les correspondances entres les libellés longs et libellés courts ainsi que les relations en les libellés fils et parents.
SET SERVEROUTPUT ON
DECLARE
--  variable pour récuperer le nom de la séquence de la table.
    v_sequence VARCHAR2(200);
-- corp de la procédure.
BEGIN
-- recupere le nom de la sequence
    BEGIN
    SELECT s.NAME INTO v_sequence
        FROM
           sys.IDNSEQ$ os
           INNER JOIN sys.obj$ t ON (t.obj# = os.obj#)
           INNER JOIN sys.obj$ s ON (s.obj# = os.seqobj#)
           INNER JOIN sys.col$ c ON (c.obj# = t.obj# AND c.col# = os.intcol#)
           INNER JOIN all_users u ON (u.user_id = t.owner#)
        WHERE t.NAME = 'G_GEO.TA_LIBELLE'
        AND u.username = 'G_GEO';
    DBMS_OUTPUT.PUT_LINE(v_sequence || '.nextval');
    END;
-- execution de la requete
    BEGIN
    EXECUTE IMMEDIATE
    'CREATE TABLE G_GEO.BPE_FUSION AS
    SELECT
    -- Attention à la séquence utilisée
          '||v_sequence||'.nextval as objectid,
    -- Attention à la séquence utilisée
          b.objectid AS fid_libelle_long,
          a.libelle_long,
          c.objectid AS fid_libelle_court,
          a.libelle_court,
          a.niveau
      FROM
          G_GEO.BPE_NOMENCLATURE_LISTE a
      JOIN
          G_GEO.TA_LIBELLE_LONG b ON b.valeur = a.libelle_long
      LEFT JOIN
          G_GEO.TA_LIBELLE_COURT c ON c.valeur = a.libelle_court';
      END;
END;
/


-- 17. Insertion des 'objectid' et des 'fid_libelle_long' grâce à la table temporaire G_GEO.BPE_FUSION(voir 13., 14.)
MERGE INTO G_GEO.TA_LIBELLE a
USING
    (
    SELECT
        objectid, 
        fid_libelle_long
    FROM
        G_GEO.BPE_FUSION
    ) b
ON (a.objectid = b.objectid
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.objectid,a.fid_libelle_long)
VALUES (b.objectid,b.fid_libelle_long)
;


-- 18. Insertion des données dans G_GEO.TA_CORRESPONDANCE_LIBELLE grâce à la table temporaire G_GEO.BPE_FUSION(voir 13., 14.)
MERGE INTO G_GEO.TA_CORRESPONDANCE_LIBELLE a
USING
	(
	SELECT
		objectid,
		fid_libelle_court
	FROM
        G_GEO.BPE_FUSION
	) b
ON (a.fid_libelle = b.objectid
AND a.fid_libelle_court = b.fid_libelle_court)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle,a.fid_libelle_court)
VALUES (b.objectid,b.fid_libelle_court)
;


-- 19. Insertion des données dans ta_relation_libelle(hiérarchie des libelles comme par exemple A1(services publics > A101(police)) grâce à la table temporaire G_GEO.BPE_FUSION(voir 13., 14.)
MERGE INTO ta_libelle_relation a
USING 
	(
	SELECT
	    a.objectid fid_libelle_fils,
        a.libelle_long libelle_long_fils,
        a.libelle_court libelle_court_fils,
	    b.objectid fid_libelle_parent,
        b.libelle_long libelle_long_parent,
        b.libelle_court libelle_court_parent
	FROM
	    G_GEO.BPE_FUSION a,
	    G_GEO.BPE_FUSION b,
	    G_GEO.BPE_RELATION c
	WHERE
	        a.libelle_court = c.lcf
	    AND
	        a.libelle_long = c.llf
	    AND
	        b.libelle_court =c.lcp
	    AND
	        b.libelle_long =c.llp
	    AND
	    (
	        (a.niveau = 'niv_1' AND b.niveau = 'niv_0')
	    OR 
	        (a.niveau = 'niv_2' AND b.niveau = 'niv_1')
	    OR 
	        (a.niveau = 'niv_3' AND b.niveau = 'niv_2')
	    )
    AND
    	a.objectid IN (SELECT objectid FROM G_GEO.TA_LIBELLE)
    AND
    	b.objectid IN (SELECT objectid FROM G_GEO.TA_LIBELLE)
	)b
ON (a.fid_libelle_fils = b.fid_libelle_fils
AND a.fid_libelle_parent = b.fid_libelle_parent)
WHEN NOT MATCHED THEN
INSERT (a.fid_libelle_fils,a.fid_libelle_parent)
VALUES (b.fid_libelle_fils,b.fid_libelle_parent)
;


-------------------------------------------------------------------------------------------------------
-- Partie 2: Insertion des libellés liés aux variables propres aux équipements enseignement et sportif
-------------------------------------------------------------------------------------------------------


-- 20. Ajout d'une colonne dans la table temporaire d'import des libelles pour ajouter les identifians des libelles de niveau 1 (COUVERT/ECLAIRE...).
ALTER TABLE G_GEO.BPE_VARIABLE ADD
	lo_1 NUMBER(38,0)
;


-- 21. Création et insertion des libelles et des identifiants à partir de la sequence de la table G_GEO.TA_LIBELLE
-- dans une table temporaire pour pouvoir attribuer des identifiants unique à des libelles utilisés par plusieurs variables
SET SERVEROUTPUT ON
DECLARE
--  variable pour récuperer le nom de la séquence de la table.
    v_sequence VARCHAR2(200);
-- corp de la procédure.
BEGIN
-- recupere le nom de la sequence
    BEGIN
    SELECT s.NAME INTO v_sequence
        FROM
           sys.IDNSEQ$ os
           INNER JOIN sys.obj$ t ON (t.obj# = os.obj#)
           INNER JOIN sys.obj$ s ON (s.obj# = os.seqobj#)
           INNER JOIN sys.col$ c ON (c.obj# = t.obj# AND c.col# = os.intcol#)
           INNER JOIN all_users u ON (u.user_id = t.owner#)
        WHERE t.NAME = 'G_GEO.TA_LIBELLE'
        AND u.username = 'G_GEO';
    DBMS_OUTPUT.PUT_LINE(v_sequence || '.nextval');
    END;
-- execution de la requete
    BEGIN
    EXECUTE IMMEDIATE
    'CREATE TABLE G_GEO.FUSION_BPE_VARIABLE AS
    SELECT
        a.ll_niv_1,
      -- Attention à la séquence utilisée
          '||v_sequence||'.nextval as lo_1
      -- Attention à la séquence utilisée
      FROM 
        (
          SELECT DISTINCT ll_niv_1
          FROM G_GEO.BPE_VARIABLE
        ) a';
      END;
END;
/


-- 23. Insertion des identifiants de niveau 1 dans la table d'import des libelles
MERGE INTO G_GEO.BPE_VARIABLE a
USING 
	G_GEO.FUSION_BPE_VARIABLE b
ON(a.ll_niv_1 = b.ll_niv_1)
WHEN MATCHED THEN
UPDATE SET a.lo_1 = b.lo_1
WHERE a.lo_1 IS NULL;


-- 24. Ajout de la colonne lo_2 dans la table temporaire d'import des libelles pour ajouter les identifiants unique aux libelles de niveau 2.
-- Cela permet d'attibuer des identifiants différents à un même libelle utilisé par des états différents (exemple 'Sans objet').
ALTER TABLE G_GEO.BPE_VARIABLE ADD
    lo_2 NUMBER(38,0)
;

-- 25. insertion des identifiants de niveau 2 en utilisant la séquence de la table G_GEO.TA_LIBELLE
SET SERVEROUTPUT ON
DECLARE
--  variable pour récuperer le nom de la séquence de la table.
    v_sequence VARCHAR2(200);
-- corp de la procédure.
BEGIN
-- recupere le nom de la sequence
    BEGIN
    SELECT s.NAME INTO v_sequence
        FROM
           sys.IDNSEQ$ os
           INNER JOIN sys.obj$ t ON (t.obj# = os.obj#)
           INNER JOIN sys.obj$ s ON (s.obj# = os.seqobj#)
           INNER JOIN sys.col$ c ON (c.obj# = t.obj# AND c.col# = os.intcol#)
           INNER JOIN all_users u ON (u.user_id = t.owner#)
        WHERE t.NAME = 'G_GEO.TA_LIBELLE'
        AND u.username = 'G_GEO';
    DBMS_OUTPUT.PUT_LINE(v_sequence || '.nextval');
    END;
-- execution de la requete
    BEGIN
    EXECUTE IMMEDIATE
    'UPDATE G_GEO.BPE_VARIABLE SET lo_2 =' || v_sequence || '.nextval WHERE lc_niv_2 IS NOT NULL';
    END;
END;
/


-- 26. creation de la vue pour inserer les libelles longs et courts
--/!\ aussi necessaire à la normalisation des données
CREATE OR REPLACE VIEW G_GEO.BPE_VARIABLE_LISTE AS
SELECT DISTINCT 
	LC_niv_1 AS libelle_court, 
	LL_niv_1 AS libelle_long,
	'niv_1' AS niveau
FROM G_GEO.BPE_VARIABLE
UNION ALL
SELECT DISTINCT 
	LC_niv_2 AS libelle_court, 
	LL_niv_2 AS libelle_long,
	'niv_2' AS niveau
FROM G_GEO.BPE_VARIABLE
WHERE LC_niv_2 IS NOT NULL
AND LL_niv_2 IS NOT NULL;


-- 27. Insertion des libelles courts dans G_GEO.TA_LIBELLE_COURT
MERGE INTO G_GEO.TA_LIBELLE_COURT a
USING
    (
    SELECT DISTINCT
        libelle_court
    FROM
        G_GEO.BPE_VARIABLE_LISTE
    ) b
ON (a.valeur = b.libelle_court)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.libelle_court)
;


-- 28. Insertion des libelles longs dans G_GEO.TA_LIBELLE_LONG
MERGE INTO G_GEO.TA_LIBELLE_LONG a
USING
	(
	SELECT DISTINCT
		libelle_long
	FROM
		G_GEO.BPE_VARIABLE_LISTE
	) b
ON (a.valeur = b.libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.libelle_long)
;


-- 29. Insertion de la famille dans G_GEO.TA_FAMILLE
MERGE INTO G_GEO.TA_FAMILLE a
USING
	(
		SELECT 'BPE' AS VALEUR FROM DUAL
	)b
ON (a.valeur = b.valeur)
WHEN NOT MATCHED THEN
INSERT (a.valeur)
VALUES (b.valeur)
;


-- 30. Insertion des relations dans G_GEO.TA_FAMILLE_LIBELLE
MERGE INTO G_GEO.TA_FAMILLE_LIBELLE a
USING
	(
	SELECT
		a.objectid fid_famille,
		b.objectid fid_libelle_long
    FROM
        G_GEO.TA_FAMILLE a,
        G_GEO.TA_LIBELLE_LONG b
	WHERE 
		a.valeur = 'BPE' AND
		b.valeur IN
			(
			SELECT DISTINCT
				libelle_long
			FROM
				G_GEO.BPE_VARIABLE_LISTE
			)
		) b
ON (a.fid_famille = b.fid_famille
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.fid_famille,a.fid_libelle_long)
VALUES (b.fid_famille,b.fid_libelle_long)
;


-- 31. Insertion dans G_GEO.TA_LIBELLE des libelles de niveau 1
MERGE INTO G_GEO.TA_LIBELLE a
USING
    (
    SELECT
        distinct a.lo_1 objectid,
        b.objectid fid_libelle_long
    FROM
        G_GEO.BPE_VARIABLE a
    INNER JOIN G_GEO.TA_LIBELLE_LONG b ON a.ll_niv_1 = b.valeur
    INNER JOIN G_GEO.TA_FAMILLE_LIBELLE c ON b.objectid = c.fid_libelle_long
    INNER JOIN G_GEO.TA_FAMILLE d ON c.fid_famille = d.objectid
    WHERE
        d.valeur = 'BPE'
    )b
ON(a.objectid = b.objectid
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.objectid,a.fid_libelle_long)
VALUES (b.objectid,b.fid_libelle_long)
;


-- 32. Insertion dans G_GEO.TA_LIBELLE des libelles de niveau 2
MERGE INTO G_GEO.TA_LIBELLE a
USING
    (
	    SELECT
	        a.lo_2 objectid,
	        b.objectid fid_libelle_long
	    FROM
	        G_GEO.BPE_VARIABLE a
	    INNER JOIN G_GEO.TA_LIBELLE_LONG b ON a.ll_niv_2 = b.valeur
	    INNER JOIN G_GEO.TA_FAMILLE_LIBELLE c ON b.objectid = c.fid_libelle_long
	    INNER JOIN G_GEO.TA_FAMILLE d ON c.fid_famille = d.objectid
	    WHERE
        d.valeur = 'BPE'
    )b
ON(a.objectid = b.objectid
AND a.fid_libelle_long = b.fid_libelle_long)
WHEN NOT MATCHED THEN
INSERT (a.objectid,a.fid_libelle_long)
VALUES (b.objectid,b.fid_libelle_long)
;

-- 33. Insertion des correspondance dans la table G_GEO.TA_CORRESPONDANCE_LIBELLE
MERGE INTO G_GEO.TA_CORRESPONDANCE_LIBELLE a
USING
	(
		SELECT 
		    distinct a.ll_niv_1 AS libelle_long,
		    a.lo_1 AS fid_libelle,
		    a.lc_niv_1 AS libelle_court,
		    b.objectid as fid_libelle_court
		FROM
		    G_GEO.BPE_VARIABLE a
		INNER JOIN
		    G_GEO.TA_LIBELLE_COURT b ON a.lc_niv_1 = b.valeur
	    WHERE
	        lo_1
		    IN
		      	(SELECT OBJECTID FROM G_GEO.TA_LIBELLE)
				UNION ALL
				SELECT
				    distinct a.ll_niv_2 AS libelle_long,
				    a.lo_2 AS fid_libelle,
				    a.lc_niv_2 AS libelle_court,
				    b.objectid AS fid_libelle_court
				FROM
				    G_GEO.BPE_VARIABLE a
				INNER JOIN
				    G_GEO.TA_LIBELLE_COURT b ON a.lc_niv_2 = b.valeur
			    WHERE
			        lo_2
			    IN
			      (SELECT OBJECTID FROM G_GEO.TA_LIBELLE)
	)b
ON(a.fid_libelle = b.fid_libelle
AND a.fid_libelle_court = b.fid_libelle_court)
WHEN not matched THEN
INSERT(a.fid_libelle, a.fid_libelle_court)
VALUES (b.fid_libelle, b.fid_libelle_court)
;


-- 34. Insertion des relations dans la table G_GEO.TA_RELATION_LIBELLE

MERGE INTO G_GEO.TA_RELATION_LIBELLE a
USING
	(
	    SELECT
	        lo_2 fid_libelle_fils,
	        lo_1 fid_libelle_parent
	    FROM
	        G_GEO.BPE_VARIABLE
	    WHERE
	        ll_niv_2 IS NOT NULL
	    AND
	    	lo_2 IN (SELECT objectid FROM G_GEO.TA_LIBELLE)
	    AND
	    	lo_1 IN (SELECT objectid FROM G_GEO.TA_LIBELLE)
	)b
ON(a.fid_libelle_fils = b.fid_libelle_fils
AND a.fid_libelle_parent = b.fid_libelle_parent)
WHEN not matched THEN
INSERT(a.fid_libelle_fils, a.fid_libelle_parent)
VALUES (b.fid_libelle_fils, b.fid_libelle_parent);