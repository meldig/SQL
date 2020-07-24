-- relation bpe
CREATE OR REPLACE VIEW V_NOMENCLATURE_EQUIPEMENT_BPE AS
WITH cte1 AS
	(
	SELECT 
	    gp.fid_libelle_parent AS fid_libelle_niv_1,
	    p.fid_libelle_parent AS fid_libelle_niv_2,
	    p.fid_libelle_fils AS fid_libelle_niv_3
	from
	    ta_libelle_relation gp
	INNER JOIN ta_libelle_relation p
	ON gp.fid_libelle_fils = p.fid_libelle_parent
	)
	SELECT
		cte1.fid_libelle_niv_1,
		tlc_niv_1.valeur AS libelle_court_niv_1,
		tll_niv_1.valeur AS libelle_long_niv_1,		
		cte1.fid_libelle_niv_2,
		concat(tlc_niv_1.valeur,tlc_niv_2.valeur) AS libelle_court_niv_2,
		tll_niv_2.valeur AS libelle_long_niv_2,
		cte1.fid_libelle_niv_3,
		concat(tlc_niv_1.valeur,concat(tlc_niv_2.valeur,tlc_niv_3.valeur)) AS libelle_court_niv_3,
		tll_niv_3.valeur AS libelle_long_niv_3
	FROM
		cte1 
	INNER JOIN ta_libelle_correspondance tc_niv_1 ON cte1.fid_libelle_niv_1 = tc_niv_1.fid_libelle
	INNER JOIN ta_libelle_correspondance tc_niv_2 ON cte1.fid_libelle_niv_2 = tc_niv_2.fid_libelle
	INNER JOIN ta_libelle_correspondance tc_niv_3 ON cte1.fid_libelle_niv_3 = tc_niv_3.fid_libelle
	INNER JOIN ta_libelle_court tlc_niv_1 ON tc_niv_1.fid_libelle_court = tlc_niv_1.objectid
	INNER JOIN ta_libelle_court tlc_niv_2 ON tc_niv_2.fid_libelle_court = tlc_niv_2.objectid
	INNER JOIN ta_libelle_court tlc_niv_3 ON tc_niv_3.fid_libelle_court = tlc_niv_3.objectid
	INNER JOIN ta_libelle tl_niv_1 ON cte1.fid_libelle_niv_1 = tl_niv_1.objectid
	INNER JOIN ta_libelle tl_niv_2 ON cte1.fid_libelle_niv_2 = tl_niv_2.objectid
	INNER JOIN ta_libelle tl_niv_3 ON cte1.fid_libelle_niv_3 = tl_niv_3.objectid
	INNER JOIN ta_libelle_long tll_niv_1 ON tl_niv_1.fid_libelle_long = tll_niv_1.objectid
	INNER JOIN ta_libelle_long tll_niv_2 ON tl_niv_2.fid_libelle_long = tll_niv_2.objectid
	INNER JOIN ta_libelle_long tll_niv_3 ON tl_niv_3.fid_libelle_long = tll_niv_3.objectid
	INNER JOIN ta_famille_libelle tfl_niv_1 ON tfl_niv_1.fid_libelle_long = tll_niv_1.objectid
	INNER JOIN ta_famille_libelle tfl_niv_2 ON tfl_niv_2.fid_libelle_long = tll_niv_2.objectid
	INNER JOIN ta_famille_libelle tfl_niv_3 ON tfl_niv_3.fid_libelle_long = tll_niv_3.objectid
	INNER JOIN ta_famille tf_niv_1 ON tfl_niv_1.fid_famille = tf_niv_1.objectid
	INNER JOIN ta_famille tf_niv_2 ON tfl_niv_2.fid_famille = tf_niv_2.objectid
	INNER JOIN ta_famille tf_niv_3 ON tfl_niv_3.fid_famille = tf_niv_3.objectid
WHERE
    tf_niv_1.valeur = 'BPE'
    AND
    tf_niv_2.valeur = 'BPE'
    AND
    tf_niv_3.valeur = 'BPE'
ORDER BY
	libelle_court_niv_1,
	libelle_court_niv_2,
	libelle_court_niv_3
;