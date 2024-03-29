-- Requete SQL créant deux vues synthétisant la nomenclature OCS2D. Ces vues simplifient la normalisation des données.

-- vue de la nomenclature v_nomenclature_ocs2d_usage
CREATE OR REPLACE VIEW v_nomenclature_ocs2d_usage AS
WITH cte1 AS
	(
	SELECT 
	    ggp.fid_libelle_parent AS fid_libelle_niv_0,
	    gp.fid_libelle_parent AS fid_libelle_niv_1,
	    p.fid_libelle_parent AS fid_libelle_niv_2,
	    p.fid_libelle_fils AS fid_libelle_niv_3
	FROM
	    G_OCS2D.TA_OCS2D_LIBELLE_RELATION ggp
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_RELATION gp
	ON ggp.fid_libelle_fils = gp.fid_libelle_parent
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_RELATION p
	ON gp.fid_libelle_fils = p.fid_libelle_parent
	)
	SELECT
		cte1.fid_libelle_niv_0,
		tlc_niv_0.valeur AS libelle_court_niv_0,
		tll_niv_0.valeur AS libelle_long_niv_0,
		cte1.fid_libelle_niv_1,
		tlc_niv_0.valeur || tlc_niv_1.valeur AS libelle_court_niv_1,
		tll_niv_1.valeur AS libelle_long_niv_1,		
		cte1.fid_libelle_niv_2,
		tlc_niv_0.valeur || tlc_niv_1.valeur || '.' || tlc_niv_2.valeur AS libelle_court_niv_2,
		tll_niv_2.valeur AS libelle_long_niv_2,
		cte1.fid_libelle_niv_3,
		tlc_niv_0.valeur || tlc_niv_1.valeur || '.' || tlc_niv_2.valeur || '.' || tlc_niv_3.valeur AS libelle_court_niv_3,
		tll_niv_3.valeur AS libelle_long_niv_3
	FROM
		cte1 
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc_niv_0 ON cte1.fid_libelle_niv_0 = tc_niv_0.fid_libelle 
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc_niv_1 ON cte1.fid_libelle_niv_1 = tc_niv_1.fid_libelle
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc_niv_2 ON cte1.fid_libelle_niv_2 = tc_niv_2.fid_libelle
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc_niv_3 ON cte1.fid_libelle_niv_3 = tc_niv_3.fid_libelle
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc_niv_0 ON tc_niv_0.fid_libelle_court = tlc_niv_0.objectid 
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc_niv_1 ON tc_niv_1.fid_libelle_court = tlc_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc_niv_2 ON tc_niv_2.fid_libelle_court = tlc_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc_niv_3 ON tc_niv_3.fid_libelle_court = tlc_niv_3.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE tl_niv_0 ON cte1.fid_libelle_niv_0 = tl_niv_0.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE tl_niv_1 ON cte1.fid_libelle_niv_1 = tl_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE tl_niv_2 ON cte1.fid_libelle_niv_2 = tl_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE tl_niv_3 ON cte1.fid_libelle_niv_3 = tl_niv_3.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG tll_niv_0 ON tl_niv_0.fid_libelle_long = tll_niv_0.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG tll_niv_1 ON tl_niv_1.fid_libelle_long = tll_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG tll_niv_2 ON tl_niv_2.fid_libelle_long = tll_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG tll_niv_3 ON tl_niv_3.fid_libelle_long = tll_niv_3.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE tfl_niv_0 ON tfl_niv_0.fid_libelle = tl_niv_0.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE tfl_niv_1 ON tfl_niv_1.fid_libelle = tl_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE tfl_niv_2 ON tfl_niv_2.fid_libelle = tl_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE tfl_niv_3 ON tfl_niv_3.fid_libelle = tl_niv_3.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE tf_niv_0 ON tfl_niv_0.fid_famille = tf_niv_0.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE tf_niv_1 ON tfl_niv_1.fid_famille = tf_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE tf_niv_2 ON tfl_niv_2.fid_famille = tf_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE tf_niv_3 ON tfl_niv_3.fid_famille = tf_niv_3.objectid
WHERE
	UPPER(tlc_niv_0.valeur) = UPPER('US')
	AND
    UPPER(tf_niv_0.valeur) = UPPER('usage DU SOL')
    AND
    UPPER(tf_niv_1.valeur) = UPPER('usage DU SOL')
    AND
    UPPER(tf_niv_2.valeur) = UPPER('usage DU SOL')
    AND
    UPPER(tf_niv_3.valeur) = UPPER('usage DU SOL')
ORDER BY
	libelle_court_niv_0,
	libelle_court_niv_1,
	libelle_court_niv_2,
	libelle_court_niv_3;


-- vue de la nomenclature nomenclature_ocs2d_occupation
CREATE OR REPLACE VIEW v_nomenclature_ocs2d_couvert AS
WITH cte1 AS
	(
	SELECT 
	    ggp.fid_libelle_parent AS fid_libelle_niv_0,
	    gp.fid_libelle_parent AS fid_libelle_niv_1,
	    p.fid_libelle_parent AS fid_libelle_niv_2,
	    p.fid_libelle_fils AS fid_libelle_niv_3
	FROM
	    G_OCS2D.TA_OCS2D_LIBELLE_RELATION ggp
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_RELATION gp
	ON ggp.fid_libelle_fils = gp.fid_libelle_parent
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_RELATION p
	ON gp.fid_libelle_fils = p.fid_libelle_parent
	)
	SELECT
		cte1.fid_libelle_niv_0,
		tlc_niv_0.valeur AS libelle_court_niv_0,
		tll_niv_0.valeur AS libelle_long_niv_0,
		cte1.fid_libelle_niv_1,
		tlc_niv_0.valeur || tlc_niv_1.valeur AS libelle_court_niv_1,
		tll_niv_1.valeur AS libelle_long_niv_1,		
		cte1.fid_libelle_niv_2,
		tlc_niv_0.valeur || tlc_niv_1.valeur || '.' || tlc_niv_2.valeur AS libelle_court_niv_2,
		tll_niv_2.valeur AS libelle_long_niv_2,
		cte1.fid_libelle_niv_3,
		tlc_niv_0.valeur || tlc_niv_1.valeur || '.' || tlc_niv_2.valeur || '.' || tlc_niv_3.valeur AS libelle_court_niv_3,
		tll_niv_3.valeur AS libelle_long_niv_3
	FROM
		cte1 
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc_niv_0 ON cte1.fid_libelle_niv_0 = tc_niv_0.fid_libelle 
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc_niv_1 ON cte1.fid_libelle_niv_1 = tc_niv_1.fid_libelle
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc_niv_2 ON cte1.fid_libelle_niv_2 = tc_niv_2.fid_libelle
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE tc_niv_3 ON cte1.fid_libelle_niv_3 = tc_niv_3.fid_libelle
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc_niv_0 ON tc_niv_0.fid_libelle_court = tlc_niv_0.objectid 
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc_niv_1 ON tc_niv_1.fid_libelle_court = tlc_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc_niv_2 ON tc_niv_2.fid_libelle_court = tlc_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT tlc_niv_3 ON tc_niv_3.fid_libelle_court = tlc_niv_3.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE tl_niv_0 ON cte1.fid_libelle_niv_0 = tl_niv_0.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE tl_niv_1 ON cte1.fid_libelle_niv_1 = tl_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE tl_niv_2 ON cte1.fid_libelle_niv_2 = tl_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE tl_niv_3 ON cte1.fid_libelle_niv_3 = tl_niv_3.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG tll_niv_0 ON tl_niv_0.fid_libelle_long = tll_niv_0.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG tll_niv_1 ON tl_niv_1.fid_libelle_long = tll_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG tll_niv_2 ON tl_niv_2.fid_libelle_long = tll_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG tll_niv_3 ON tl_niv_3.fid_libelle_long = tll_niv_3.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE tfl_niv_0 ON tfl_niv_0.fid_libelle = tl_niv_0.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE tfl_niv_1 ON tfl_niv_1.fid_libelle = tl_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE tfl_niv_2 ON tfl_niv_2.fid_libelle = tl_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE tfl_niv_3 ON tfl_niv_3.fid_libelle = tl_niv_3.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE tf_niv_0 ON tfl_niv_0.fid_famille = tf_niv_0.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE tf_niv_1 ON tfl_niv_1.fid_famille = tf_niv_1.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE tf_niv_2 ON tfl_niv_2.fid_famille = tf_niv_2.objectid
	INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE tf_niv_3 ON tfl_niv_3.fid_famille = tf_niv_3.objectid
WHERE
	UPPER(tlc_niv_0.valeur) = UPPER('CS')
	AND
    UPPER(tf_niv_0.valeur) = UPPER('couvert DU SOL')
    AND
    UPPER(tf_niv_1.valeur) = UPPER('couvert DU SOL')
    AND
    UPPER(tf_niv_2.valeur) = UPPER('couvert DU SOL')
    AND
    UPPER(tf_niv_3.valeur) = UPPER('couvert DU SOL')
ORDER BY
	libelle_court_niv_0,
	libelle_court_niv_1,
	libelle_court_niv_2,
	libelle_court_niv_3
;

-- vue de la nomenclature 21_poste
CREATE OR REPLACE VIEW v_nomenclature_ocs2d_21_postes AS
SELECT
    f.objectid AS fid_libelle_court,
    cast(f.valeur AS NUMBER(38,0)) AS poste,
    a.objectid AS fid_libelle,
    b.valeur AS Libelle
FROM
    G_OCS2D.TA_OCS2D_LIBELLE a
    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE c ON c.fid_libelle = a.objectid
    INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE d ON d.objectid = c.fid_famille
    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE e ON e.fid_libelle = a.objectid
    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT f ON f.objectid = e.fid_libelle_court
WHERE
    UPPER(d.valeur) = UPPER('Nomenclature « 21 postes »')
ORDER BY cast(f.valeur AS NUMBER(38,0))
   ;


CREATE OR REPLACE VIEW v_nomenclature_ocs2d_4_postes AS
SELECT
    f.objectid AS fid_libelle_court,
    cast(f.valeur AS NUMBER(38,0)) AS poste,
    a.objectid AS fid_libelle,
    b.valeur AS Libelle
FROM
    G_OCS2D.TA_OCS2D_LIBELLE a
    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_LONG b ON b.objectid = a.fid_libelle_long
    INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE_LIBELLE c ON c.fid_libelle = a.objectid
    INNER JOIN G_OCS2D.TA_OCS2D_FAMILLE d ON d.objectid = c.fid_famille
    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_CORRESPONDANCE e ON e.fid_libelle = a.objectid
    INNER JOIN G_OCS2D.TA_OCS2D_LIBELLE_COURT f ON f.objectid = e.fid_libelle_court
WHERE
    UPPER(d.valeur) = UPPER('Nomenclature « 4 postes »')
ORDER BY cast(f.valeur AS NUMBER(38,0))
   ;