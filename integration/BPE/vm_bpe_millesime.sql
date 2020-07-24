-- Création de la vue BPE millesimé. Table regroupant les données de la Base Permanente des Equipement
/*
DROP MATERIALIZED VIEW g_geo.vm_bpe_millesime_mel;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'VM_BPE_MILLESIME_MEL';
*/
-- 1. Création de la vue

CREATE MATERIALIZED VIEW vm_bpe_millesime_mel
(
    OBJECTID,
    CODE_INSEE,
    COMMUNE,
    TYPEQU,
    CANT,
    CL_PELEM,
    CL_PGE,
    EP,
    INT,
    RPIC,
    SECT,
    COUVERT,
    ECLAIRE,
    NB_AIREJEU,
    NB_SALLES,
    SOURCE,
    geom
)
AS

-- 1. Selection des équipements
WITH 
	millesime AS (
		SELECT
		    a.objectid AS id_mtd,
		    b.nom_source AS nom_source,
		    d.Max_millesime AS millesime
		FROM
		    ta_source b
		    INNER JOIN ta_metadonnee a ON a.fid_source = b.objectid
		    INNER JOIN (
		    			SELECT c.objectid, MAX(c.millesime) AS Max_millesime
		    			FROM
		    				ta_date_acquisition c
		    			GROUP BY c.objectid, c.millesime
		    			ORDER BY c.millesime DESC)d ON d.objectid = a.fid_acquisition
		WHERE
		    b.nom_source = 'Base Permanente des Equipements'
		    AND ROWNUM = 1
		),
	echelle AS (
	    SELECT
            DISTINCT
            b.objectid AS ID_MTD,
	        LISTAGG(d.valeur, ';')
	        WITHIN GROUP(ORDER BY d.valeur) AS echelle
	    FROM
	    ta_bpe a
	    -- métadonnée
	        INNER JOIN ta_metadonnee b ON b.objectid = a.fid_metadonnee
	        INNER JOIN ta_metadonnee_relation_echelle c ON c.fid_metadonnee = b.objectid
	        INNER JOIN ta_echelle d ON d.objectid = c.fid_echelle
	    GROUP BY a.objectid, b.objectid
	    ),
	equipement AS (
	SELECT 
	    gp.fid_libelle_parent AS fid_libelle_niv_1,
	    p.fid_libelle_parent AS fid_libelle_niv_2,
	    p.fid_libelle_fils AS fid_libelle_niv_3
	FROM
	    ta_libelle_relation gp
	INNER JOIN ta_libelle_relation p ON gp.fid_libelle_fils = p.fid_libelle_parent
	),
	TYPEQU AS
	(
	SELECT
		equipement.fid_libelle_niv_3,
		concat(tlc_niv_1.valeur,concat(tlc_niv_2.valeur,tlc_niv_3.valeur)) AS libelle_court_niv_3,
		tll_niv_3.valeur AS libelle_long_niv_3
	FROM
		equipement 
	INNER JOIN ta_libelle_correspondance tc_niv_1 ON equipement.fid_libelle_niv_1 = tc_niv_1.fid_libelle
	INNER JOIN ta_libelle_correspondance tc_niv_2 ON equipement.fid_libelle_niv_2 = tc_niv_2.fid_libelle
	INNER JOIN ta_libelle_correspondance tc_niv_3 ON equipement.fid_libelle_niv_3 = tc_niv_3.fid_libelle
	INNER JOIN ta_libelle_court tlc_niv_1 ON tc_niv_1.fid_libelle_court = tlc_niv_1.objectid
	INNER JOIN ta_libelle_court tlc_niv_2 ON tc_niv_2.fid_libelle_court = tlc_niv_2.objectid
	INNER JOIN ta_libelle_court tlc_niv_3 ON tc_niv_3.fid_libelle_court = tlc_niv_3.objectid
	INNER JOIN ta_libelle tl_niv_1 ON equipement.fid_libelle_niv_1 = tl_niv_1.objectid
	INNER JOIN ta_libelle tl_niv_2 ON equipement.fid_libelle_niv_2 = tl_niv_2.objectid
	INNER JOIN ta_libelle tl_niv_3 ON equipement.fid_libelle_niv_3 = tl_niv_3.objectid
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
		libelle_court_niv_3
	),
-- 2. Sous requete pour selection chaque attribut et les mettre sous forme de colonne
	VARIABLE AS (
	SELECT
	    lf.objectid AS fid_libelle_court_fils,
	    lcf.valeur AS libelle_court_fils,
	    lp.objectid AS fid_libelle_court_parent,
	    lcp.valeur AS libelle_court_parent
	FROM
	ta_libelle_relation tr 
	INNER JOIN ta_libelle lf ON lf.objectid = tr.fid_libelle_fils
	INNER JOIN ta_libelle lp ON lp.objectid = tr.fid_libelle_parent
	INNER JOIN ta_libelle_correspondance lclf ON lclf.fid_libelle = lf.objectid
	INNER JOIN ta_libelle_court lcf ON lcf.objectid = lclf.fid_libelle_court
	INNER JOIN ta_libelle_correspondance lclp ON lclp.fid_libelle = lp.objectid
	INNER JOIN ta_libelle_court lcp ON lcp.objectid = lclp.fid_libelle_court
	INNER JOIN ta_libelle_long llf ON llf.objectid = lf.fid_libelle_long
	INNER JOIN ta_libelle_long llp ON llp.objectid = lp.fid_libelle_long
	INNER JOIN ta_famille_libelle flf ON flf.fid_libelle_long = llf.objectid
	INNER JOIN ta_famille ff ON ff.objectid = flf.fid_famille
	INNER JOIN ta_famille_libelle flp ON flp.fid_libelle_long = llp.objectid
	INNER JOIN ta_famille fp ON fp.objectid = flp.fid_famille
	WHERE
	ff.valeur = 'BPE'
	AND
	fp.valeur = 'BPE'
	),
	ATTRIBUT AS (
		SELECT
		bpe.objectid,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'CANT' THEN VARIABLE.libelle_court_fils
        END) AS CANT,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'CL_PELEM' THEN VARIABLE.libelle_court_fils
        END) AS CL_PELEM,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'CL_PGE' THEN VARIABLE.libelle_court_fils
        END) AS CL_PGE,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'EP' THEN VARIABLE.libelle_court_fils
        END) AS EP,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'INT' THEN VARIABLE.libelle_court_fils
        END) AS INT,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'RPIC' THEN VARIABLE.libelle_court_fils
        END) AS RPIC,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'SECT' THEN VARIABLE.libelle_court_fils
        END) AS SECT,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'COUVERT' THEN VARIABLE.libelle_court_fils
        END) AS COUVERT,
        MAX(CASE  
            WHEN VARIABLE.libelle_court_parent = 'ECLAIRE' THEN VARIABLE.libelle_court_fils
        END) AS ECLAIRE
	FROM
		ta_bpe bpe
 	LEFT JOIN ta_bpe_caracteristique bpecv ON bpecv.fid_bpe = bpe.objectid
	INNER JOIN VARIABLE ON VARIABLE.fid_libelle_court_fils = bpecv.fid_libelle
	GROUP BY bpe.objectid
	),
	ATTRIBUTQ AS (
	SELECT
		bpe.objectid,
	    (CASE
	        WHEN ll.valeur = 'Nombre d''aires de pratique d''un même type au sein de l''équipement' THEN bpecq.nombre
	    END) AS NB_AIREJEU,
	    (CASE
	        WHEN ll.valeur = 'Nombre de salles par théâtre ou cinéma' THEN bpecq.nombre
    	END) AS NB_SALLES
    FROM
    	ta_bpe bpe
    LEFT JOIN ta_bpe_caracteristique_quantitative bpecq ON bpecq.fid_bpe = bpe.objectid
	INNER JOIN ta_libelle l ON l.objectid = bpecq.fid_libelle
    INNER JOIN ta_libelle_long ll ON ll.objectid = l.fid_libelle_long
	INNER JOIN ta_famille_libelle fl ON fl.fid_libelle_long = ll.objectid
	INNER JOIN ta_famille f ON f.objectid = fl.fid_famille
	WHERE f.valeur = 'BPE'
	)
-- Requète totale
	SELECT
		bpe.objectid,
		code.valeur AS CODE_INSEE,
        nom.valeur AS COMMUNE,
		TYPEQU.libelle_court_niv_3 AS TYPEQU,
        ATTRIBUT.CANT,
        ATTRIBUT.CL_PELEM,
        ATTRIBUT.CL_PGE,
        ATTRIBUT.EP,
        ATTRIBUT.INT,
        ATTRIBUT.RPIC,
        ATTRIBUT.SECT,
        ATTRIBUT.COUVERT,
        ATTRIBUT.ECLAIRE,
        ATTRIBUTQ.NB_AIREJEU,
        ATTRIBUTQ.NB_SALLES,
   		s.nom_source || ' - ' || o.acronyme || ' - ' || e.echelle || ' - ' || millesime.MILLESIME AS source,
		bpeg.geom
	FROM
		ta_bpe bpe
	LEFT JOIN ta_bpe_caracteristique bpect ON bpect.fid_bpe = bpe.objectid
	INNER JOIN TYPEQU ON TYPEQU.fid_libelle_niv_3 = bpect.fid_libelle
	LEFT JOIN ATTRIBUT ON ATTRIBUT.objectid = bpe.objectid
	LEFT JOIN ATTRIBUTQ ON ATTRIBUTQ.objectid = bpe.objectid
	INNER JOIN ta_bpe_relation_geom bperg ON bperg.fid_bpe = bpe.objectid
	INNER JOIN ta_bpe_geom bpeg ON bpeg.objectid = bperg.fid_bpe_geom
	INNER JOIN ta_metadonnee m ON m.objectid = bpe.fid_metadonnee
	INNER JOIN ta_source s ON s.objectid = m.fid_source
    INNER JOIN ta_metadonnee_relation_organisme mo ON mo.fid_metadonnee = M.objectid
    INNER JOIN ta_organisme o ON o.objectid = mo.fid_organisme
    INNER JOIN millesime ON millesime.ID_MTD = bpe.fid_metadonnee
    INNER JOIN echelle e ON e.ID_MTD = bpe.fid_metadonnee
    INNER JOIN ta_bpe_relation_code bpec ON bpec.fid_bpe = bpe.objectid
    INNER JOIN ta_code code ON code.objectid = bpec.fid_code
    INNER JOIN ta_identifiant_commune ic ON ic.fid_identifiant = code.objectid
    INNER JOIN ta_commune commune ON ic.fid_commune = commune.objectid
    INNER JOIN ta_nom nom ON commune.fid_nom = nom.objectid
    INNER JOIN ta_libelle p ON code.fid_libelle = p.objectid
    INNER JOIN ta_libelle_long pl ON p.fid_libelle_long = pl.objectid
    INNER JOIN ta_metadonnee mco ON mco.objectid = commune.fid_metadonnee
    INNER JOIN ta_source so ON so.objectid = mco.fid_source
    INNER JOIN ta_date_acquisition ao ON ao.objectid = mco.fid_acquisition
	WHERE
    pl.valeur = 'code insee'
    AND so.nom_source = 'BDTOPO'
    AND substr(ao.millesime,7,2) = '19'
;


-- 2. CREATION DES COMMENTAIRE DE LA VUE ET DES COLONNES
COMMENT ON MATERIALIZED VIEW vm_bpe_millesime_mel IS 'Vue proposant les équipements actuellement disponible sur le territoire de la MEL';
COMMENT ON COLUMN vm_bpe_millesime_mel.OBJECTID IS 'Identifiant de l''equipement';
COMMENT ON COLUMN vm_bpe_millesime_mel.CODE_INSEE IS 'Code de la commune d''implantation de l''équipement';
COMMENT ON COLUMN vm_bpe_millesime_mel.COMMUNE IS 'Commune d''implantation de l''equipement';
COMMENT ON COLUMN vm_bpe_millesime_mel.TYPEQU IS 'type d''équipement';
COMMENT ON COLUMN vm_bpe_millesime_mel.CANT IS 'Présence ou absence d''une cantine';
COMMENT ON COLUMN vm_bpe_millesime_mel.CL_PELEM IS 'Présence ou absence d''une classe pré-élémentaire en école élémentaire';
COMMENT ON COLUMN vm_bpe_millesime_mel.CL_PGE IS 'Présence ou absence d''une classe préparatoire aux grandes écoles en lycée';
COMMENT ON COLUMN vm_bpe_millesime_mel.EP IS 'Appartenance ou non à un dispositif d''éducation prioritaire';
COMMENT ON COLUMN vm_bpe_millesime_mel.INT IS 'Présence ou absence d''un internat';
COMMENT ON COLUMN vm_bpe_millesime_mel.RPIC IS 'Présence ou absence d''un regroupement pédagogique intercommunal concentré';
COMMENT ON COLUMN vm_bpe_millesime_mel.SECT IS 'Appartenance au secteur publice ou privé d''enseignement';
COMMENT ON COLUMN vm_bpe_millesime_mel.COUVERT IS 'Equipement couvert ou non';
COMMENT ON COLUMN vm_bpe_millesime_mel.ECLAIRE IS 'Equipement éclairé ou non';
COMMENT ON COLUMN vm_bpe_millesime_mel.NB_AIREJEU IS 'Nombre d''aires de pratique d''un même type au sein de l''equipement';
COMMENT ON COLUMN vm_bpe_millesime_mel.NB_SALLES IS 'Nombre de salles par théâtre ou cinéma';
COMMENT ON COLUMN vm_bpe_millesime_mel.SOURCE IS 'Source de la donnée avec l''organisme créateur de la source.';
COMMENT ON COLUMN vm_bpe_millesime_mel.geom IS 'Géométrie de chaque équipement';


-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'vm_bpe_millesime_mel',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);


-- 4. Création de la clé primaire
ALTER MATERIALIZED VIEW vm_bpe_millesime_mel 
ADD CONSTRAINT vm_bpe_millesime_mel_PK 
PRIMARY KEY ("OBJECTID");


-- 5. Création de l'index spatial
CREATE INDEX vm_admin_iris_mel_SIDX
ON vm_bpe_millesime_mel(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POINT, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);