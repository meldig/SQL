-- Création de la vue IRIS

-- 1. Création de la vue

CREATE OR REPLACE FORCE VIEW admin_iris_mel
	(
	identifiant,
	code_iris,
	nom_iris,
	type_iris,
	code_insee,
	nom_commune,
	source,
	geom,
    CONSTRAINT "admin_iris_mel_PK" PRIMARY KEY("IDENTIFIANT") DISABLE
	)
AS
-- sous requête pour sélectionner les IRIS et leus informations
WITH 
-- Sous requête pour selectionner le millésime le plus récent
	millesime AS (
	SELECT 
		i.objectid AS OBJECTID,
		MAX(a.MILLESIME) AS MILLESIME
	FROM
		ta_iris i
	-- métadonnée
	INNER JOIN ta_metadonnee m ON m.objectid = i.fid_metadonnee
	INNER JOIN ta_source s ON s.objectid = m.fid_source
	INNER JOIN ta_provenance p ON p.objectid = m.fid_provenance
	INNER JOIN ta_date_acquisition a ON a.objectid = m.fid_acquisition
	INNER JOIN ta_metadonnee_relation_organisme mo ON mo.fid_metadonnee = m.objectid
	INNER JOIN ta_organisme o ON o.objectid = mo.fid_organisme
	INNER JOIN ta_echelle e ON e.objectid = m.fid_echelle
    GROUP BY i.objectid
	),
    
	commune_surface AS(
	SELECT 
		codeco.valeur AS CODE_INSEE,
		nomc.valeur AS NOM_COMMUNE,
		i.objectid AS iris_objectid,
		sdo_geom.sdo_area(
			sdo_geom.sdo_intersection(
			co.geom, ig.geom, 0.5),
			0.5, 'unit=sq_m') area
	FROM
		ta_identifiant_commune ti
	INNER JOIN ta_code codeco ON codeco.objectid = ti.fid_identifiant
	INNER JOIN ta_commune co ON co.objectid = ti.fid_commune
	INNER JOIN ta_nom nomc ON nomc.objectid = co.fid_nom
	INNER JOIN ta_libelle lco ON lco.objectid = co.fid_lib_type_commune
	INNER JOIN ta_libelle_long llco ON llco.objectid = lco.fid_libelle_long
	INNER JOIN ta_famille_libelle flco ON flco.fid_libelle_long = llco.objectid
	INNER JOIN ta_famille fco ON fco.objectid = flco.fid_famille,
	 	ta_iris i
	INNER JOIN ta_iris_geom ig ON ig.objectid = i.fid_iris_geom
	WHERE
		SDO_ANYINTERACT (co.geom, ig.geom) = 'TRUE'
	AND
		fco.valeur = 'types de commune'
	),
	-- sous requete pour selectionner la commune recouverte principalement par une zone iris afin de définier la commune de localisation de la zone IRIS
	commune_surface_max AS(
	SELECT
		cs.CODE_INSEE AS CODE_INSEE,
		cs.NOM_COMMUNE AS NOM_COMMUNE,
		cs.iris_objectid AS iris_objectid
	FROM
		commune_surface cs 
	INNER JOIN
		(
		SELECT
			iris_objectid,
			MAX(area) AS maxArea
		FROM commune_surface
		GROUP BY iris_objectid) groupe_cs
		ON cs.iris_objectid = groupe_cs.iris_objectid
		AND cs.area = groupe_cs.maxArea
		)
-- requete principale pour sélectionner les IRIS avec leurs métadonnées et leurs communes de localisation
	SELECT
		i.objectid AS identifiant,
		CONCAT(csm.CODE_INSEE,codei.valeur) AS code_iris,
		nomi.valeur AS nom_iris,
		lci.valeur AS type_iris,
		csm.CODE_INSEE AS code_insee,		
		csm.NOM_COMMUNE AS nom_commune,
		s.nom_source || oinsee.acronyme || oign.acronyme || e.valeur || ml.MILLESIME AS source,
		g.geom
	FROM
		ta_iris i
	INNER JOIN ta_nom nomi ON nomi.objectid = i.fid_nom
	INNER JOIN ta_code codei ON codei.objectid = i.fid_code
	-- distinction pour ne selectonner que les IRIS
	INNER JOIN ta_libelle lc ON lc.objectid = codei.fid_libelle
	INNER JOIN ta_libelle_long llc ON llc.objectid = lc.fid_libelle_long
	-- distinction pour le type d'IRIS
	INNER JOIN ta_libelle li ON li.objectid = i.fid_lib_type
	INNER JOIN ta_libelle_long lli ON lli.objectid = li.fid_libelle_long
	INNER JOIN ta_famille_libelle fli ON fli.fid_libelle_long = lli.objectid
	INNER JOIN ta_famille fi ON fi.objectid = fli.fid_famille
	INNER JOIN ta_libelle_correspondance cli ON cli.fid_libelle = li.objectid
	INNER JOIN ta_libelle_court lci ON lci.objectid = cli.fid_libelle_court
	INNER JOIN ta_iris_geom g ON g.objectid = i.fid_iris_geom
	-- jointure des metadonnees avec l'organisme INSEE
    INNER JOIN ta_metadonnee m ON m.objectid = i.fid_metadonnee
    INNER JOIN ta_echelle e ON e.objectid = m.fid_echelle
    INNER JOIN ta_source s ON s.objectid = m.fid_source
    INNER JOIN ta_metadonnee_relation_organisme mo ON mo.fid_metadonnee = m.objectid
    INNER JOIN ta_organisme oinsee ON oinsee.objectid = mo.fid_organisme
    INNER JOIN millesime ml ON ml.objectid = i.objectid
    INNER JOIN commune_surface_max csm ON csm.iris_objectid = i.objectid
	-- jointure des metadonnees avec l'organisme IGN
    INNER JOIN ta_metadonnee mign ON mign.objectid = i.fid_metadonnee
    INNER JOIN ta_metadonnee_relation_organisme moign ON moign.fid_metadonnee = mign.objectid
    INNER JOIN ta_organisme oign ON oign.objectid = moign.fid_organisme
    WHERE
    	oign.acronyme = 'IGN'
    AND
    	oinsee.acronyme = 'INSEE'
	;


-- 2. Création des commentaires de table et de colonnes

COMMENT ON TABLE admin_iris_mel IS 'Vue proposant les IRIS actuelles de la MEL extraites des données Contours...IRIS de l''INSEE coproduites avec l''IGN.';
COMMENT ON COLUMN admin_iris_mel.identifiant IS 'Clé primaire de la vue, code de la zone IRIS.';
COMMENT ON COLUMN admin_iris_mel.code_iris IS 'code de la zone IRIS.';
COMMENT ON COLUMN admin_iris_mel.nom_iris IS 'Nom de la zone IRIS.';
COMMENT ON COLUMN admin_iris_mel.type_iris IS 'Type de zone IRIS.';
COMMENT ON COLUMN admin_iris_mel.code_insee IS 'Code insee de la commune de la zone iris';
COMMENT ON COLUMN admin_iris_mel.nom_commune IS 'Nom de la commune de la zone IRIS';
COMMENT ON COLUMN admin_iris_mel.source IS 'metadonnée de la vue';
COMMENT ON COLUMN admin_iris_mel.geom IS 'Géométrie de chaque iris - de type polygone.';


-- 3. Création des métadonnées spatiales

INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'admin_iris_mel',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);