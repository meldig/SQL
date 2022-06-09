-- Création de la vue présentant les données OCS2D au dernier millesime: VM_OCS2D_MULTIDATE_SCOT

-- 0. Suppression de l'ancienne vue matérialisée

DROP INDEX VM_OCS2D_MULTIDATE_SCOT_SIDX;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'VM_OCS2D_MULTIDATE_SCOT';
DROP MATERIALIZED VIEW VM_OCS2D_MULTIDATE_SCOT;


/*
1. Creation des vues matérialisées successives pour créer la vue matérialisée VM_OCS2D_MULTIDATE_SCOT.
*/

-- 1.1. libelle_relation
CREATE MATERIALIZED VIEW LIBELLE_RELATION AS (
	SELECT 
	    ggp.fid_libelle_parent AS fid_libelle_niv_0,
	    gp.fid_libelle_parent AS fid_libelle_niv_1,
	    p.fid_libelle_parent AS fid_libelle_niv_2,
	    p.fid_libelle_fils AS fid_libelle_niv_3
	FROM
	    G_OCS2D.ta_ocs2d_libelle_relation ggp
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_relation gp
	ON ggp.fid_libelle_fils = gp.fid_libelle_parent
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_relation p
	ON gp.fid_libelle_fils = p.fid_libelle_parent
	);


-- 1.2. COUVERT_USAGE
CREATE MATERIALIZED VIEW COUVERT_USAGE AS
	(
	SELECT
		libelle_relation.fid_libelle_niv_0,
        tlc_niv_0.valeur AS code_niveau_0,
		tll_niv_0.valeur AS libelle_long_niv_0,
		libelle_relation.fid_libelle_niv_1,
		CAST(tlc_niv_1.valeur AS NUMBER(38,0)) AS code_niveau_1,
		tll_niv_1.valeur AS libelle_long_niv_1,
		libelle_relation.fid_libelle_niv_2,
		CAST(tlc_niv_2.valeur AS NUMBER(38,0)) AS code_niveau_2,
		tll_niv_2.valeur AS libelle_long_niv_2,
		libelle_relation.fid_libelle_niv_3,
		CAST(tlc_niv_3.valeur AS NUMBER(38,0)) AS code_niveau_3,
		tll_niv_3.valeur AS libelle_long_niv_3,
		tlc_niv_0.valeur || tlc_niv_1.valeur || '.' || tlc_niv_2.valeur || '.' || tlc_niv_3.valeur AS libelle_court_niv_3
	FROM
		libelle_relation 
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_correspondance tc_niv_0 ON libelle_relation.fid_libelle_niv_0 = tc_niv_0.fid_libelle 
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_correspondance tc_niv_1 ON libelle_relation.fid_libelle_niv_1 = tc_niv_1.fid_libelle
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_correspondance tc_niv_2 ON libelle_relation.fid_libelle_niv_2 = tc_niv_2.fid_libelle
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_correspondance tc_niv_3 ON libelle_relation.fid_libelle_niv_3 = tc_niv_3.fid_libelle
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_court tlc_niv_0 ON tc_niv_0.fid_libelle_court = tlc_niv_0.objectid 
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_court tlc_niv_1 ON tc_niv_1.fid_libelle_court = tlc_niv_1.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_court tlc_niv_2 ON tc_niv_2.fid_libelle_court = tlc_niv_2.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_court tlc_niv_3 ON tc_niv_3.fid_libelle_court = tlc_niv_3.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle tl_niv_0 ON libelle_relation.fid_libelle_niv_0 = tl_niv_0.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle tl_niv_1 ON libelle_relation.fid_libelle_niv_1 = tl_niv_1.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle tl_niv_2 ON libelle_relation.fid_libelle_niv_2 = tl_niv_2.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle tl_niv_3 ON libelle_relation.fid_libelle_niv_3 = tl_niv_3.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_long tll_niv_0 ON tl_niv_0.fid_libelle_long = tll_niv_0.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_long tll_niv_1 ON tl_niv_1.fid_libelle_long = tll_niv_1.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_long tll_niv_2 ON tl_niv_2.fid_libelle_long = tll_niv_2.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_libelle_long tll_niv_3 ON tl_niv_3.fid_libelle_long = tll_niv_3.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_famille_libelle tfl_niv_0 ON tfl_niv_0.fid_libelle = tl_niv_0.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_famille_libelle tfl_niv_1 ON tfl_niv_1.fid_libelle = tl_niv_1.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_famille_libelle tfl_niv_2 ON tfl_niv_2.fid_libelle = tl_niv_2.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_famille_libelle tfl_niv_3 ON tfl_niv_3.fid_libelle= tl_niv_3.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_famille tf_niv_0 ON tfl_niv_0.fid_famille = tf_niv_0.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_famille tf_niv_1 ON tfl_niv_1.fid_famille = tf_niv_1.objectid
	INNER JOIN G_OCS2D.ta_ocs2d_famille tf_niv_2 ON tfl_niv_2.fid_famille = tf_niv_2.objectid
	INNER JOIN
		G_OCS2D.ta_ocs2d_famille tf_niv_3 ON tfl_niv_3.fid_famille = tf_niv_3.objectid
	WHERE
	    tlc_niv_0.valeur = 'CS'
    	OR 
		tlc_niv_0.valeur = 'US'
	);


-- 1.3. INDICE
CREATE MATERIALIZED VIEW INDICE AS
    (
	SELECT
	    b.objectid AS IDENTIFIANT,
	    d.OBJECTID AS FID_INDICE,
	    CAST(f.valeur AS NUMBER(38,0)) AS INDICE
	FROM
	    G_OCS2D.TA_OCS2D_MILLESIME a
	    INNER JOIN G_OCS2D.TA_OCS2D b ON b.objectid = a.fid_ocs2d
	    INNER JOIN G_OCS2D.TA_OCS2D_RELATION_LIBELLE c ON c.fid_ocs2d_millesime = a.objectid
	    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE d ON d.objectid = c.fid_libelle
	    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE e ON e.fid_libelle = d.OBJECTID
	    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT f ON f.OBJECTID = e.fid_libelle_court
	    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG g ON g.objectid = d.fid_libelle_long
	    INNER join G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE h on h.fid_libelle = d.objectid
	    inner join G_OCS2D.TA_OCS2D_FAMILLE i ON i.objectid = h.fid_famille
	WHERE
	    UPPER(i.objectid) = 5
    );


-- 1.4. OCS2D_SOURCE
CREATE MATERIALIZED VIEW OCS2D_SOURCE AS (
    SELECT DISTINCT
	    a.objectid AS fid_ocs2d,
	    LISTAGG (d.valeur, ' / ') WITHIN GROUP (order by d.valeur) AS source
    FROM
        G_OCS2D.TA_OCS2D_MILLESIME a
        INNER JOIN G_OCS2D.TA_OCS2D_RELATION_SOURCE c ON c.fid_ocs2d_millesime = a.objectid
        INNER JOIN G_OCS2D.TA_OCS2D_SOURCE d ON d.objectid = c.fid_ocs2d_source
    GROUP BY a.objectid
    );


-- 1.5. OCS2D_COMMENTAIRE
CREATE MATERIALIZED VIEW OCS2D_COMMENTAIRE AS (
    SELECT DISTINCT
	    a.objectid AS fid_ocs2d,
	    LISTAGG (d.valeur, ' / ') WITHIN GROUP (order by d.valeur) AS commentaire
    FROM
        G_OCS2D.TA_OCS2D_MILLESIME a
        INNER JOIN G_OCS2D.TA_OCS2D_RELATION_COMMENTAIRE c ON c.fid_ocs2d_millesime = a.objectid
        INNER JOIN G_OCS2D.TA_OCS2D_COMMENTAIRE d ON d.objectid = c.fid_ocs2d_commentaire
    GROUP BY a.objectid
    );


-- 1.6.1. MILLESIME
CREATE MATERIALIZED VIEW MILLESIME AS (
    SELECT DISTINCT
        a.objectid,
        LISTAGG (da.MILLESIME, ' / ') WITHIN GROUP (order by da.MILLESIME) AS MILLESIME,
        s.nom_source || ' - ' || o.acronyme || ' - ' || e.valeur AS SOURCE
    FROM
        G_OCS2D.TA_OCS2D a
        INNER JOIN G_OCS2D.TA_OCS2D_MILLESIME b ON b.fid_ocs2d = a.objectid
        INNER JOIN G_GEO.TA_METADONNEE m ON b.fid_metadonnee = m.objectid
        INNER JOIN G_GEO.TA_SOURCE s ON s.objectid = m.fid_source
        INNER JOIN G_GEO.TA_DATE_ACQUISITION da ON da.objectid = m.fid_acquisition
        INNER JOIN G_GEO.TA_PROVENANCE p ON p.objectid = m.fid_provenance
        LEFT JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME mo ON mo.fid_metadonnee = m.objectid
        LEFT JOIN G_GEO.TA_ORGANISME o ON o.objectid = mo.fid_organisme
        LEFT JOIN G_GEO.TA_METADONNEE_RELATION_ECHELLE me ON me.fid_metadonnee = m.objectid
        LEFT JOIN G_GEO.TA_ECHELLE e ON e.objectid = me.fid_echelle
	WHERE
	    s.objectid = 163
		AND
		    da.millesime IN (to_date('01/01/2005'),to_date('01/01/2015'),to_date('01/01/2020'))
		AND
		    da.date_acquisition = to_date('18/12/2021')
		AND
		    p.url = 'https://cloud.sirs-fr.com/index.php/s/MGSLBai7pweRXLJ'
		AND
		    o.acronyme = 'CLS'
		AND 
		    e.valeur = 5000
    GROUP BY a.objectid, s.nom_source || ' - ' || o.acronyme || ' - ' || e.valeur
	);

-- 1.6.2. Index sur la table OCS2D_ATTRIBUT
CREATE INDEX MILLESIME_INDX ON "G_OCS2D"."MILLESIME" ("OBJECTID");

-- 1.7. POSTE
CREATE MATERIALIZED VIEW POSTE AS (
	SELECT
	    cast(f.valeur AS NUMBER(38,0)) AS poste,
	    a.objectid AS fid_libelle,
	    b.valeur AS Libelle,
	    d.valeur AS FAMILLE
	FROM
	    G_OCS2D.TA_OCS2D_LIBELLE a
	    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
	    INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE c ON c.fid_libelle = a.objectid
	    INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE d ON d.objectid = c.fid_famille
	    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE e ON e.fid_libelle = a.objectid
	    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT f ON f.objectid = e.fid_libelle_court
	WHERE
	    UPPER(d.valeur) IN (UPPER('Nomenclature « 4 postes »'),UPPER('Nomenclature « 21 postes »'))
	);


-- 1.8.1. OCS2D_ATTRIBUT
CREATE MATERIALIZED VIEW OCS2D_ATTRIBUT AS (
	SELECT
		a.objectid AS IDENTIFIANT,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2005')
			THEN cu.code_niveau_1
		END) AS cs05_niveau_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2005')
			THEN cu.libelle_long_niv_1
		END) AS cs05_libelle_long_niv_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2005')
			THEN cu.code_niveau_2
		END) AS cs05_niveau_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2005')
			THEN cu.libelle_long_niv_2
		END) AS cs05_libelle_long_niv_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2005')
			THEN cu.code_niveau_3
		END) AS cs05_niveau_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2005')
			THEN cu.libelle_long_niv_3
		END) AS cs05_libelle_long_niv_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2005')
			THEN cu.fid_libelle_niv_3
		END) AS fid_cs05,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2005')
			THEN cu.libelle_court_niv_3
		END) AS cs05,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2005')
			THEN cu.code_niveau_1
		END) AS us05_niveau_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2005')
			THEN cu.libelle_long_niv_1
		END) AS us05_libelle_long_niv_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2005')
			THEN cu.code_niveau_2
		END) AS us05_niveau_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2005')
			THEN cu.libelle_long_niv_2
		END) AS us05_libelle_long_niv_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2005')
			THEN cu.code_niveau_3
		END) AS us05_niveau_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2005')
			THEN cu.libelle_long_niv_3
		END) AS us05_libelle_long_niv_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2005')
			THEN cu.fid_libelle_niv_3
		END) AS fid_us05,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2005')
			THEN cu.libelle_court_niv_3
		END) AS us05,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2005')
			THEN i.INDICE
		END) AS indice05,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2005')
			THEN os.source
		END) AS source05,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2005')
			THEN oc.commentaire
		END) AS comment05,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2015')
			THEN cu.code_niveau_1
		END) AS cs15_niveau_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2015')
			THEN cu.libelle_long_niv_1
		END) AS cs15_libelle_long_niv_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2015')
			THEN cu.code_niveau_2
		END) AS cs15_niveau_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2015')
			THEN cu.libelle_long_niv_2
		END) AS cs15_libelle_long_niv_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2015')
			THEN cu.code_niveau_3
		END) AS cs15_niveau_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2015')
			THEN cu.libelle_long_niv_3
		END) AS cs15_libelle_long_niv_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2015')
			THEN cu.fid_libelle_niv_3
		END) AS fid_cs15,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2015')
			THEN cu.libelle_court_niv_3
		END) AS cs15,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2015')
			THEN cu.code_niveau_1
		END) AS us15_niveau_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2015')
			THEN cu.libelle_long_niv_1
		END) AS us15_libelle_long_niv_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2015')
			THEN cu.code_niveau_2
		END) AS us15_niveau_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2015')
			THEN cu.libelle_long_niv_2
		END) AS us15_libelle_long_niv_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2015')
			THEN cu.code_niveau_3
		END) AS us15_niveau_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2015')
			THEN cu.libelle_long_niv_3
		END) AS us15_libelle_long_niv_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2015')
			THEN cu.fid_libelle_niv_3
		END) AS fid_us15,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2015')
			THEN cu.libelle_court_niv_3
		END) AS us15,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2015')
			THEN i.INDICE
		END) AS indice15,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2015')
			THEN os.source
		END) AS source15,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2015')
			THEN oc.commentaire
		END) AS comment15,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2020')
			THEN cu.code_niveau_1
		END) AS cs20_niveau_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2020')
			THEN cu.libelle_long_niv_1
		END) AS cs20_libelle_long_niv_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2020')
			THEN cu.code_niveau_2
		END) AS cs20_niveau_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2020')
			THEN cu.libelle_long_niv_2
		END) AS cs20_libelle_long_niv_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2020')
			THEN cu.code_niveau_3
		END) AS cs20_niveau_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2020')
			THEN cu.libelle_long_niv_3
		END) AS cs20_libelle_long_niv_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2020')
			THEN cu.fid_libelle_niv_3
		END) AS fid_cs20,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'CS' AND da.millesime = to_date('01/01/2020')
			THEN cu.libelle_court_niv_3
		END) AS cs20,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2020')
			THEN cu.code_niveau_1
		END) AS us20_niveau_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2020')
			THEN cu.libelle_long_niv_1
		END) AS us20_libelle_long_niv_1,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2020')
			THEN cu.code_niveau_2
		END) AS us20_niveau_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2020')
			THEN cu.libelle_long_niv_2
		END) AS us20_libelle_long_niv_2,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2020')
			THEN cu.code_niveau_3
		END) AS us20_niveau_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2020')
			THEN cu.libelle_long_niv_3
		END) AS us20_libelle_long_niv_3,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2020')
			THEN cu.fid_libelle_niv_3
		END) AS fid_us20,
		MAX(CASE
			WHEN UPPER(cu.code_niveau_0) = 'US' AND da.millesime = to_date('01/01/2020')
			THEN cu.libelle_court_niv_3
		END) AS us20,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2020')
			THEN i.INDICE
		END) AS indice20,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2020')
			THEN os.source
		END) AS source20,
		MAX(CASE
			WHEN da.millesime = to_date('01/01/2020')
			THEN oc.commentaire
		END) AS comment20
	FROM
		G_OCS2D.TA_OCS2D a
		INNER JOIN G_OCS2D.TA_OCS2D_MILLESIME b ON b.fid_ocs2d = a.objectid
		INNER JOIN G_OCS2D.TA_OCS2D_RELATION_LIBELLE c ON c.fid_ocs2d_millesime = b.objectid
		INNER JOIN couvert_usage cu ON cu.fid_libelle_niv_3 = c.fid_libelle
		INNER JOIN indice i ON i.IDENTIFIANT = a.objectid
		LEFT JOIN ocs2d_source os ON os.fid_ocs2d = b.objectid
		LEFT JOIN ocs2d_commentaire oc ON oc.fid_ocs2d = b.objectid
		INNER JOIN millesime mi ON mi.objectid = a.objectid
		INNER JOIN G_GEO.TA_METADONNEE m ON b.fid_metadonnee = m.objectid
        INNER JOIN G_GEO.TA_SOURCE s ON s.objectid = m.fid_source
        INNER JOIN G_GEO.TA_DATE_ACQUISITION da ON da.objectid = m.fid_acquISition
        INNER JOIN G_GEO.TA_PROVENANCE p ON p.objectid = m.fid_provenance
        LEFT JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME mo ON mo.fid_metadonnee = m.objectid
        LEFT JOIN G_GEO.TA_ORGANISME o ON o.objectid = mo.fid_organISme
        LEFT JOIN G_GEO.TA_METADONNEE_RELATION_ECHELLE me ON me.fid_metadonnee = m.objectid
        LEFT JOIN G_GEO.TA_ECHELLE e ON e.objectid = me.fid_echelle
    WHERE da.millesime IN (to_date('01/01/2005'),to_date('01/01/2015'),to_date('01/01/2020'))
	GROUP BY a.objectid
	);

-- 1.8.2. Index sur la table OCS2D_ATTRIBUT
CREATE INDEX OCS2D_ATTRIBUT_INDX ON "G_OCS2D"."OCS2D_ATTRIBUT" ("IDENTIFIANT");

-- 1.9.1. OCS2D_POSTE
CREATE MATERIALIZED VIEW OCS2D_POSTE AS (
	SELECT
		a.objectid AS IDENTIFIANT,
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 4 postes »') AND da.millesime = to_date('01/01/2005')
            THEN po.poste
        END) AS "CODE_4_POSTES_05",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 4 postes »') AND da.millesime = to_date('01/01/2005')
        	THEN po.libelle
        END) AS "LIBELLE_4_POSTES_05",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 21 postes »') AND da.millesime = to_date('01/01/2005')
        	THEN po.poste
        END) AS "CODE_21_POSTES_05",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 21 postes »') AND da.millesime = to_date('01/01/2005')
        	THEN po.libelle
        END) AS "LIBELLE_21_POSTES_05",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 4 postes »') AND da.millesime = to_date('01/01/2015')
        	THEN po.poste
        END) AS "CODE_4_POSTES_15",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 4 postes »') AND da.millesime = to_date('01/01/2015')
        	THEN po.libelle
        END) AS "LIBELLE_4_POSTES_15",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 21 postes »') AND da.millesime = to_date('01/01/2015')
        	THEN po.poste
        END) AS "CODE_21_POSTES_15",
		MAX(CASE 
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 21 postes »') AND da.millesime = to_date('01/01/2015')
        	THEN po.libelle
        END) AS "LIBELLE_21_POSTES_15",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 4 postes »') AND da.millesime = to_date('01/01/2020')
        	THEN po.poste
        END) AS "CODE_4_POSTES_20",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 4 postes »') AND da.millesime = to_date('01/01/2020')
        	THEN po.libelle
        END) AS "LIBELLE_4_POSTES_20",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 21 postes »') AND da.millesime = to_date('01/01/2020')
        	THEN po.poste
        END) AS "CODE_21_POSTES_20",
		MAX(CASE
            WHEN UPPER(po.famille) = UPPER('Nomenclature « 21 postes »') AND da.millesime = to_date('01/01/2020')
        	THEN po.libelle
        END) AS "LIBELLE_21_POSTES_20"
	FROM
		G_OCS2D.TA_OCS2D a
		INNER JOIN G_OCS2D.TA_OCS2D_MILLESIME b ON b.fid_ocs2d = a.objectid
		INNER JOIN G_OCS2D.TA_OCS2D_RELATION_LIBELLE c ON c.fid_ocs2d_millesime = b.objectid
		INNER JOIN poste po ON po.fid_libelle = c.fid_libelle
		INNER JOIN G_GEO.TA_METADONNEE m ON b.fid_metadonnee = m.objectid
        INNER JOIN G_GEO.TA_SOURCE s ON s.objectid = m.fid_source
        INNER JOIN G_GEO.TA_DATE_ACQUISITION da ON da.objectid = m.fid_acquISition
        INNER JOIN G_GEO.TA_PROVENANCE p ON p.objectid = m.fid_provenance
        LEFT JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME mo ON mo.fid_metadonnee = m.objectid
        LEFT JOIN G_GEO.TA_ORGANISME o ON o.objectid = mo.fid_organISme
        LEFT JOIN G_GEO.TA_METADONNEE_RELATION_ECHELLE me ON me.fid_metadonnee = m.objectid
        LEFT JOIN G_GEO.TA_ECHELLE e ON e.objectid = me.fid_echelle
    WHERE da.millesime IN (to_date('01/01/2005'),to_date('01/01/2015'),to_date('01/01/2020'))
	GROUP BY a.objectid
	);


-- 1.9.1. Index sur la table OCS2D_POSTE
CREATE INDEX OCS2D_POSTE_INDX ON "G_OCS2D"."OCS2D_POSTE" ("IDENTIFIANT");

-- 2. Création de la vue
CREATE MATERIALIZED VIEW VM_OCS2D_MULTIDATE_SCOT
	(
	identifiant,
	cs05_niveau_1,
	libcs05_niveau_1,
	cs05_niveau_2,
	libcs05_niveau_2,
	cs05_niveau_3,
	libcs05,
	cs05,
	us05_niveau_1,
	libus05_niveau_1,
	us05_niveau_2,
	libus05_niveau_2,
	us05_niveau_3,
	libus05,
	us05,
	code_4_postes_05,
	libelle_4_postes_05,
	code_21_postes_05,
	libelle_21_postes_05,
	indice05,
	source05,
	comment05,
	cs15_niveau_1,
	libcs15_niveau_1,
	cs15_niveau_2,
	libcs15_niveau_2,
	cs15_niveau_3,
	libcs15,
	cs15,
	us15_niveau_1,
	libus15_niveau_1,
	us15_niveau_2,
	libus15_niveau_2,
	us15_niveau_3,
	libus15,
	us15,
	code_4_postes_15,
	libelle_4_postes_15,
	code_21_postes_15,
	libelle_21_postes_15,
	indice15,
	source15,
	comment15,
	evol05_15,
	cs20_niveau_1,
	libcs20_niveau_1,
	cs20_niveau_2,
	libcs20_niveau_2,
	cs20_niveau_3,
	libcs20,
	cs20,
	us20_niveau_1,
	libus20_niveau_1,
	us20_niveau_2,
	libus20_niveau_2,
	us20_niveau_3,
	libus20,
	us20,
	code_4_postes_20,
	libelle_4_postes_20,
	code_21_postes_20,
	libelle_21_postes_20,
	indice20,
	source20,
	comment20,
	evol15_20,
	perimetre,
	surface_m2,
	surface_ha,
	metadonnee,
	geom
	)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE
AS
-- Sous requête selection des différents usages des sols.
	SELECT
		a.OBJECTID AS identifiant,
		oa.cs05_niveau_1 AS cs05_niveau_1,
		oa.cs05_libelle_long_niv_1 AS libcs05_niveau_1,
		oa.cs05_niveau_2 AS cs05_niveau_2,
		oa.cs05_libelle_long_niv_2 AS libcs05_niveau_2,
		oa.cs05_niveau_3 AS cs05_niveau_3,
		oa.cs05_libelle_long_niv_3 AS libcs05,
		oa.cs05 AS cs05,
		oa.us05_niveau_1 AS us05_niveau_1,
		oa.us05_libelle_long_niv_1 AS libus05_niveau_1,
		oa.us05_niveau_2 AS us05_niveau_2,
		oa.us05_libelle_long_niv_2 AS libus05_niveau_2,
		oa.us05_niveau_3 AS us05_niveau_3,
		oa.us05_libelle_long_niv_3 AS libus05,
		oa.us05 AS us05,
		op.code_4_postes_05,
		op.libelle_4_postes_05,
		op.code_21_postes_05,
		op.libelle_21_postes_05,
		oa.indice05,
		oa.source05,
		oa.comment05,
		oa.cs15_niveau_1 AS cs15_niveau_1,
		oa.cs15_libelle_long_niv_1 AS libcs15_niveau_1,
		oa.cs15_niveau_2 AS cs15_niveau_2,
		oa.cs15_libelle_long_niv_2 AS libcs15_niveau_2,
		oa.cs15_niveau_3 AS cs15_niveau_3,
		oa.cs15_libelle_long_niv_3 AS libcs15,
		oa.cs15 AS cs15,
		oa.us15_niveau_1 AS us15_niveau_1,
		oa.us15_libelle_long_niv_1 AS libus15_niveau_1,
		oa.us15_niveau_2 AS us15_niveau_2,
		oa.us15_libelle_long_niv_2 AS libus15_niveau_2,
		oa.us15_niveau_3 AS us15_niveau_3,
		oa.us15_libelle_long_niv_3 AS libus15,
		oa.us15 AS us15,
		op.code_4_postes_15,
		op.libelle_4_postes_15,
		op.code_21_postes_15,
		op.libelle_21_postes_15,
		oa.indice15,
		oa.source15,
		oa.comment15,
		CASE
			WHEN oa.cs05 <> oa.cs15 AND oa.us05 <> oa.us15 THEN 1
			ELSE 2
		END evol05_15,
		oa.cs20_niveau_1 AS cs20_niveau_1,
		oa.cs20_libelle_long_niv_1 AS libcs20_niveau_1,
		oa.cs20_niveau_2 AS cs20_niveau_2,
		oa.cs20_libelle_long_niv_2 AS libcs20_niveau_2,
		oa.cs20_niveau_3 AS cs20_niveau_3,
		oa.cs20_libelle_long_niv_3 AS libcs20,
		oa.cs20 AS cs20,
		oa.us20_niveau_1 AS us20_niveau_1,
		oa.us20_libelle_long_niv_1 AS libus20_niveau_1,
		oa.us20_niveau_2 AS us20_niveau_2,
		oa.us20_libelle_long_niv_2 AS libus20_niveau_2,
		oa.us20_niveau_3 AS us20_niveau_3,
		oa.us20_libelle_long_niv_3 AS libus20,
		oa.us20 AS us20,
		op.code_4_postes_20,
		op.libelle_4_postes_20,
		op.code_21_postes_20,
		op.libelle_21_postes_20,
		oa.indice20,
		oa.source20,
		oa.comment20,
		CASE
			WHEN oa.cs15 <> oa.cs20 AND oa.us15 <> oa.us20 THEN 1
			ELSE 2
		END evol15_20,
		SDO_GEOM.SDO_LENGTH(b.geom) as perimetre,
		SDO_GEOM.SDO_AREA(b.geom,0.001) as surface_m2,
		SDO_GEOM.SDO_AREA(b.geom,0.001)/10000 as surface_ha,
		mi.source || ' - ' ||mi.millesime as metadonnee,
		b.geom
	FROM
		G_OCS2D.TA_OCS2D a
		INNER JOIN ocs2d_attribut oa ON oa.identifiant = a.objectid
		INNER JOIN ocs2d_poste op ON op.identifiant = a.objectid
		INNER JOIN G_OCS2D.TA_OCS2D_GEOM b ON b.objectid = a.fid_ocs2d_geom
		INNER JOIN millesime mi ON mi.objectid = a.objectid
	;


-- 4. Creation des commentaires de la vues materialisée VM_OCS2D_MULTIDATE_SCOT
-- 4.1. Commentaire sur la vue matérialisée
COMMENT ON MATERIALIZED VIEW VM_OCS2D_MULTIDATE_SCOT IS 'Vue proposant les données OCS2D au format multidate.';


-- 4.2. Commentaires sur les colonnes VM_OCS2D_MULTIDATE_SCOT
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.identifiant IS 'Clé primaire de la vue materialisee.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS05_NIVEAU_1 IS 'Code caractérisant le type de couvert du sol au niveau 1 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS05_NIVEAU_1 IS 'Libelle caractérisant le type de couvert du sol au niveau 1 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS05_NIVEAU_2 IS 'Code caractérisant le type de couvert du sol au niveau 2 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS05_NIVEAU_2 IS 'Libelle caractérisant le type de couvert du sol au niveau 2 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS05_NIVEAU_3 IS 'Code caractérisant le type de couvert du sol au niveau 3 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS05 IS 'Libelle caractérisant le type de couvert du sol au niveau 3 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS05 IS 'Code caractérisant le type de couvert du sol complet en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US05_NIVEAU_1 IS 'Code caractérisant l''usage du sol au niveau 1 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS05_NIVEAU_1 IS 'Libelle caractérisant l''usage du sol au niveau 1 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US05_NIVEAU_2 IS 'Code caractérisant l''usage du sol au niveau 2 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS05_NIVEAU_2 IS 'Libelle caractérisant l''usage du sol au niveau 2 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US05_NIVEAU_3 IS 'Code caractérisant l''usage du sol au niveau 3 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS05 IS 'Libelle caractérisant l''usage du sol au niveau 3 en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US05 IS 'Code caractérisant l''usage du sol complet en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CODE_4_POSTES_05 IS 'Poste de la nomenclature 4 postes à laquelle appartient la combinisaison CS/US du polygone en 2005';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBELLE_4_POSTES_05 IS 'Libelle du poste de la nomenclature 4 postes à laquelle appartient la combinisaison CS/US du polygone en 2005';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CODE_21_POSTES_05 IS 'Poste de la nomenclature 21 postes à laquelle appartient la combinisaison CS/US du polygone en 2005';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBELLE_21_POSTES_05 IS 'Libelle du poste de la nomenclature 21 postes à laquelle appartient la combinisaison CS/US du polygone en 2005';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.indice05 IS 'Indice de la qualite de la photo-interpretation de la zone OCS2D en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.source05 IS 'Données sources utilisées pour la production de la donnée OCS2D en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.comment05 IS 'Commentaire sur le polygone OCS2D en 2005.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS15_NIVEAU_1 IS 'Code caractérisant le type de couvert du sol au niveau 1 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS15_NIVEAU_1 IS 'Libelle caractérisant le type de couvert du sol au niveau 1 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS15_NIVEAU_2 IS 'Code caractérisant le type de couvert du sol au niveau 2 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS15_NIVEAU_2 IS 'Libelle caractérisant le type de couvert du sol au niveau 2 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS15_NIVEAU_3 IS 'Code caractérisant le type de couvert du sol au niveau 3 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS15 IS 'Libelle caractérisant le type de couvert du sol au niveau 3 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS15 IS 'Code caractérisant le type de couvert du sol complet en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US15_NIVEAU_1 IS 'Code caractérisant l''usage du sol au niveau 1 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS15_NIVEAU_1 IS 'Libelle caractérisant l''usage du sol au niveau 1 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US15_NIVEAU_2 IS 'Code caractérisant l''usage du sol au niveau 2 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS15_NIVEAU_2 IS 'Libelle caractérisant l''usage du sol au niveau 2 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US15_NIVEAU_3 IS 'Code caractérisant l''usage du sol au niveau 3 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS15 IS 'Libelle caractérisant l''usage du sol au niveau 3 en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US15 IS 'Code caractérisant l''usage du sol complet en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CODE_4_POSTES_15 IS 'Poste de la nomenclature 4 postes à laquelle appartient la combinisaison CS/US du polygone en 2015';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBELLE_4_POSTES_15 IS 'Libelle du poste de la nomenclature 4 postes à laquelle appartient la combinisaison CS/US du polygone en 2015';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CODE_21_POSTES_15 IS 'Poste de la nomenclature 21 postes à laquelle appartient la combinisaison CS/US du polygone en 2015';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBELLE_21_POSTES_15 IS 'Libelle du poste de la nomenclature 21 postes à laquelle appartient la combinisaison CS/US du polygone en 2015';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.indice15 IS 'Indice de la qualite de la photo-interpretation de la zone OCS2D en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.source15 IS 'Données sources utilisées pour la production de la donnée OCS2D en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.comment15 IS 'Commentaire sur le polygone OCS2D en 2015.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.evol05_15 IS 'Code qui caractérise une evolution en les millesime 2005 et 2015. 1 pas d''évolution des codes, 2 évolutions.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS20_NIVEAU_1 IS 'Code caractérisant le type de couvert du sol au niveau 1 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS20_NIVEAU_1 IS 'Libelle caractérisant le type de couvert du sol au niveau 1 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS20_NIVEAU_2 IS 'Code caractérisant le type de couvert du sol au niveau 2 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS20_NIVEAU_2 IS 'Libelle caractérisant le type de couvert du sol au niveau 2 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS20_NIVEAU_3 IS 'Code caractérisant le type de couvert du sol au niveau 3 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBCS20 IS 'Libelle caractérisant le type de couvert du sol au niveau 3 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CS20 IS 'Code caractérisant le type de couvert du sol complet en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US20_NIVEAU_1 IS 'Code caractérisant l''usage du sol au niveau 1 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS20_NIVEAU_1 IS 'Libelle caractérisant l''usage du sol au niveau 1 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US20_NIVEAU_2 IS 'Code caractérisant l''usage du sol au niveau 2 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS20_NIVEAU_2 IS 'Libelle caractérisant l''usage du sol au niveau 2 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US20_NIVEAU_3 IS 'Code caractérisant l''usage du sol au niveau 3 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBUS20 IS 'Libelle caractérisant l''usage du sol au niveau 3 en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.US20 IS 'Code caractérisant l''usage du sol complet en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CODE_4_POSTES_20 IS 'Poste de la nomenclature 4 postes à laquelle appartient la combinisaison CS/US du polygone en 2020';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBELLE_4_POSTES_20 IS 'Libelle du poste de la nomenclature 4 postes à laquelle appartient la combinisaison CS/US du polygone en 2020';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.CODE_21_POSTES_20 IS 'Poste de la nomenclature 21 postes à laquelle appartient la combinisaison CS/US du polygone en 2020';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.LIBELLE_21_POSTES_20 IS 'Libelle du poste de la nomenclature 21 postes à laquelle appartient la combinisaison CS/US du polygone en 2020';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.indice20 IS 'Indice de la qualite de la photo-interpretation de la zone OCS2D en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.source20 IS 'Données sources utilisées pour la production de la donnée OCS2D en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.comment20 IS 'Commentaire sur le polygone OCS2D en 2020.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.evol15_20 IS 'Code qui caractérise une evolution en les millesime 2015 et 2020. 1 pas d''évolution des codes, 2 évolutions.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.PERIMETRE IS 'Perimetre du polygone';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.SURFACE_M2 IS 'Surface du polygone en metre carre';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.SURFACE_HA IS 'Surface du polygone en hectare';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.METADONNEE IS 'Information sur la couche.';
COMMENT ON COLUMN G_OCS2D.VM_OCS2D_MULTIDATE_SCOT.GEOM IS 'Géométrie de chaque polygone - de type polygone.';


-- 5. Clé primaire
ALTER TABLE G_OCS2D.VM_OCS2D_MULTIDATE_SCOT
ADD CONSTRAINT VM_OCS2D_MULTIDATE_SCOT_PK 
PRIMARY KEY (IDENTIFIANT);


-- 6. Création des index des colonnes

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS05_NIVEAU_1_CS05_NIVEAU_2_CS05_NIVEAU_3"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS05_NIVEAU_1","CS05_NIVEAU_2","CS05_NIVEAU_3") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US05_NIVEAU_1_US05_NIVEAU_2_US05_NIVEAU_3"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US05_NIVEAU_1","US05_NIVEAU_2","US05_NIVEAU_3") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS05_US05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS05","US05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US05_CS05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US05","CS05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS15_NIVEAU_1_CS15_NIVEAU_2_CS15_NIVEAU_3"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS15_NIVEAU_1","CS15_NIVEAU_2","CS15_NIVEAU_3") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US15_NIVEAU_1_US15_NIVEAU_2_US15_NIVEAU_3"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US15_NIVEAU_1","US15_NIVEAU_2","US15_NIVEAU_3") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS15_US15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS15","US15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US15_CS15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US15","CS15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS20_NIVEAU_1_CS20_NIVEAU_2_CS20_NIVEAU_3"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS20_NIVEAU_1","CS20_NIVEAU_2","CS20_NIVEAU_3") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US20_NIVEAU_1_US20_NIVEAU_2_US20_NIVEAU_3"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US20_NIVEAU_1","US20_NIVEAU_2","US20_NIVEAU_3") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CS20_US20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CS20","US20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_US20_CS20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("US20","CS20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_4_POSTES_05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_4_POSTES_05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_LIBELLE_4_POSTES_05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("LIBELLE_4_POSTES_05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_4_POSTES_05_LIBELLE_4_POSTES_05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_4_POSTES_05","LIBELLE_4_POSTES_05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_21_POSTES_05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_21_POSTES_05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_LIBELLE_21_POSTES_05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("LIBELLE_21_POSTES_05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_21_POSTES_05_LIBELLE_21_POSTES_05"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_21_POSTES_05","LIBELLE_21_POSTES_05") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_4_POSTES_15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_4_POSTES_15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_LIBELLE_4_POSTES_15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("LIBELLE_4_POSTES_15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_4_POSTES_15_LIBELLE_4_POSTES_15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_4_POSTES_15","LIBELLE_4_POSTES_15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_21_POSTES_15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_21_POSTES_15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_LIBELLE_21_POSTES_15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("LIBELLE_21_POSTES_15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_21_POSTES_15_LIBELLE_21_POSTES_15"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_21_POSTES_15","LIBELLE_21_POSTES_15") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_4_POSTES_20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_4_POSTES_20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_LIBELLE_4_POSTES_20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("LIBELLE_4_POSTES_20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_4_POSTES_20_LIBELLE_4_POSTES_20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_4_POSTES_20","LIBELLE_4_POSTES_20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_21_POSTES_20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_21_POSTES_20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_LIBELLE_21_POSTES_20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("LIBELLE_21_POSTES_20") 
TABLESPACE G_ADT_INDX;

CREATE INDEX "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT_CODE_21_POSTES_20_LIBELLE_21_POSTES_20"
ON "G_OCS2D"."VM_OCS2D_MULTIDATE_SCOT" ("CODE_21_POSTES_20","LIBELLE_21_POSTES_20") 
TABLESPACE G_ADT_INDX;

-- 7. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'VM_OCS2D_MULTIDATE_SCOT',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.001), MDSYS.SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.001)), 
    2154
);


-- 8. Création de l'index spatial
CREATE INDEX VM_OCS2D_MULTIDATE_SCOT_SIDX
ON VM_OCS2D_MULTIDATE_SCOT(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);


-- 9. Gestion des droits
GRANT SELECT ON G_OCS2D.VM_OCS2D_MULTIDATE_SCOT TO G_OCS2D_LEC;
GRANT SELECT ON G_OCS2D.VM_OCS2D_MULTIDATE_SCOT TO G_OCS2D_MAJ;
GRANT SELECT ON G_OCS2D.VM_OCS2D_MULTIDATE_SCOT TO G_SERVICE_WEB;
GRANT SELECT ON G_OCS2D.VM_OCS2D_MULTIDATE_SCOT TO ISOGEO_LEC;

-- 10. Suppresion des index des vues matérialisées temporaire
DROP INDEX MILLESIME_INDX;
DROP INDEX OCS2D_ATTRIBUT_INDX;
DROP INDEX OCS2D_POSTE_INDX;

-- 11. Suppression des vues materialized temporaire
DROP MATERIALIZED VIEW libelle_relation;
DROP MATERIALIZED VIEW couvert_usage;
DROP MATERIALIZED VIEW INDICE;
DROP MATERIALIZED VIEW OCS2D_SOURCE;
DROP MATERIALIZED VIEW OCS2D_COMMENTAIRE;
DROP MATERIALIZED VIEW MILLESIME;
DROP MATERIALIZED VIEW POSTE;
DROP MATERIALIZED VIEW OCS2D_ATTRIBUT;
DROP MATERIALIZED VIEW OCS2D_POSTE;