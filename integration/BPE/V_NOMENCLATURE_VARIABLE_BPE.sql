CREATE OR REPLACE VIEW V_NOMENCLATURE_VARIABLES_BPE AS
    SELECT
        lp.objectid AS fid_libelle_court_parent,
        lcp.valeur AS libelle_court_parent,
        llp.valeur AS libelle_long_parent,
        lf.objectid AS fid_libelle_court_fils,
        lcf.valeur AS libelle_court_fils,
        llf.valeur AS libelle_long_fils
    FROM
    ta_libelle_relation tr
    INNER JOIN
    ta_libelle lf ON lf.objectid = tr.fid_libelle_fils
    INNER JOIN
    ta_libelle lp ON lp.objectid = tr.fid_libelle_parent
    INNER JOIN
    ta_libelle_correspondance lclf ON lclf.fid_libelle = lf.objectid
    INNER JOIN
    ta_libelle_court lcf ON lcf.objectid = lclf.fid_libelle_court
    INNER JOIN
    ta_libelle_correspondance lclp ON lclp.fid_libelle = lp.objectid
    INNER JOIN
    ta_libelle_court lcp ON lcp.objectid = lclp.fid_libelle_court
    INNER JOIN
    ta_libelle_long llf ON llf.objectid = lf.fid_libelle_long
    INNER JOIN
    ta_libelle_long llp ON llp.objectid = lp.fid_libelle_long
    INNER JOIN
    ta_famille_libelle flf ON flf.fid_libelle_long = llf.objectid
    INNER JOIN 
    ta_famille ff ON ff.objectid = flf.fid_famille
    INNER JOIN
    ta_famille_libelle flp ON flp.fid_libelle_long = llp.objectid
    INNER JOIN 
    ta_famille fp ON fp.objectid = flp.fid_famille
    where
    ff.valeur = 'BPE'
    AND
    fp.valeur = 'BPE'
    -- AND pour ne pas selectionner les libellés qui font référence aux TYPEQU
    AND
    lcp.valeur not LIKE '_'
    UNION SELECT
        lp.objectid AS fid_libelle_court_parent,
        lcp.valeur AS libelle_court_parent,
        llp.valeur AS libelle_long_parent,
        NULL AS fid_libelle_court_fils,
        NULL AS libelle_court_fils,
        NULL AS libelle_long_fils
    FROM
    TA_LIBELLE lp
    INNER JOIN
    ta_libelle_correspondance lclp ON lclp.fid_libelle = lp.objectid
    INNER JOIN
    ta_libelle_court lcp ON lcp.objectid = lclp.fid_libelle_court
    INNER JOIN
    ta_libelle_long llp ON llp.objectid = lp.fid_libelle_long
    INNER JOIN
    ta_famille_libelle flp ON flp.fid_libelle_long = llp.objectid
    INNER JOIN 
    ta_famille fp ON fp.objectid = flp.fid_famille
    WHERE
    fp.valeur = 'BPE'
    AND
    lcp.valeur not LIKE '_'
    AND
    lp.objectid NOT IN (SELECT fid_libelle_fils FROM ta_libelle_relation)
    AND
    lp.objectid NOT IN (SELECT fid_libelle_parent FROM ta_libelle_relation)
;