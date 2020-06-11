-- Création de la vue des communes actuelles de la MEL via la BdTopo de l'IGN avec les données historiques des populations communales 1876-2017 calculées sur la base de la géographie des communes en 2019. 

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW admin_communes_mel_recensement_historique
	(
    identifiant, 
    code_insee, 
    nom, 
	PMUN06, 
	PMUN07, 
	PMUN08, 
	PMUN09, 
	PMUN10, 
	PMUN11, 
	PMUN12, 
	PMUN13, 
	PMUN14, 
	PMUN15, 
	PMUN16, 
	PMUN17, 
	PSDC62, 
	PSDC68, 
	PSDC75, 
	PSDC82, 
	PSDC90, 
	PSDC99, 
	PTOT1876, 
	PTOT1881, 
	PTOT1886, 
	PTOT1891, 
	PTOT1896, 
	PTOT1901, 
	PTOT1906, 
	PTOT1911, 
	PTOT1921, 
	PTOT1926, 
	PTOT1931, 
	PTOT36, 
	PTOT54, 
    geom,
    CONSTRAINT "admin_communes_mel_recensement_historique_PK" PRIMARY KEY("IDENTIFIANT") DISABLE
	)
AS
-- Sous-requête pour pivoter la table TA_RECENSEMENT pour ensuite la joindre aux données des communes.
WITH 
	NOMBRE_HABITANT AS (
	SELECT
		*
	FROM
		(
		SELECT
			c.code AS CODE_INSEE,
			lc.valeur AS RECENSEMENT,
			r.population AS POPULATION,
			CONCAT(CONCAT(CONCAT(CONCAT(s.nom_source,  ' - '), o.acronyme),  ' - '), a.date_acquisition) AS source
		FROM
			ta_recensement r
		INNER JOIN ta_code c ON c.objectid = r.fid_code
		INNER JOIN ta_libelle l ON l.objectid = r.fid_recensement
		INNER JOIN ta_correspondance_libelle cl ON cl.fid_libelle = l.objectid
		INNER JOIN ta_libelle_court lc ON lc.objectid = cl.fid_libelle_court
		INNER JOIN ta_libelle_long ll ON ll.objectid = l.fid_libelle_long
		INNER JOIN ta_famille_libelle fl ON fl.fid_libelle_long = ll.objectid
		INNER JOIN ta_famille f ON f.objectid = fl.fid_famille
		INNER JOIN ta_metadonnee m ON m.objectid = r.fid_metadonnee
		INNER JOIN ta_source s ON s.objectid = m.fid_source
		INNER JOIN ta_organisme o ON o.objectid = m.fid_organisme
		INNER JOIN ta_date_acquisition a ON a.objectid = m.fid_acquisition
		WHERE
			f.valeur = 'Recensement'
		)
	PIVOT(
		SUM(population)
		FOR recensement
		IN(
			'PMUN06' AS PMUN06, 
			'PMUN07' AS PMUN07, 
			'PMUN08' AS PMUN08, 
			'PMUN09' AS PMUN09, 
			'PMUN10' AS PMUN10, 
			'PMUN11' AS PMUN11, 
			'PMUN12' AS PMUN12, 
			'PMUN13' AS PMUN13, 
			'PMUN14' AS PMUN14, 
			'PMUN15' AS PMUN15, 
			'PMUN16' AS PMUN16, 
			'PMUN17' AS PMUN17, 
			'PSDC62' AS PSDC62, 
			'PSDC68' AS PSDC68, 
			'PSDC75' AS PSDC75, 
			'PSDC82' AS PSDC82, 
			'PSDC90' AS PSDC90, 
			'PSDC99' AS PSDC99, 
			'PTOT1876' AS PTOT1876, 
			'PTOT1881' AS PTOT1881, 
			'PTOT1886' AS PTOT1886, 
			'PTOT1891' AS PTOT1891, 
			'PTOT1896' AS PTOT1896, 
			'PTOT1901' AS PTOT1901, 
			'PTOT1906' AS PTOT1906, 
			'PTOT1911' AS PTOT1911, 
			'PTOT1921' AS PTOT1921, 
			'PTOT1926' AS PTOT1926, 
			'PTOT1931' AS PTOT1931, 
			'PTOT36' AS PTOT36, 
			'PTOT54' AS PTOT54
			)
		)
	)
-- Sélection principale des éléments de la vue. Utilisation des données de la sous requête isolant les données du recensement et des données liées aux communes
SELECT
    b.code AS identifiant, 
    b.code AS code_insee, 
    d.nom, 
	nombre_habitant.PMUN06, 
	nombre_habitant.PMUN07, 
	nombre_habitant.PMUN08, 
	nombre_habitant.PMUN09, 
	nombre_habitant.PMUN10, 
	nombre_habitant.PMUN11, 
	nombre_habitant.PMUN12, 
	nombre_habitant.PMUN13, 
	nombre_habitant.PMUN14, 
	nombre_habitant.PMUN15, 
	nombre_habitant.PMUN16, 
	nombre_habitant.PMUN17, 
	nombre_habitant.PSDC62, 
	nombre_habitant.PSDC68, 
	nombre_habitant.PSDC75, 
	nombre_habitant.PSDC82, 
	nombre_habitant.PSDC90, 
	nombre_habitant.PSDC99, 
	nombre_habitant.PTOT1876, 
	nombre_habitant.PTOT1881, 
	nombre_habitant.PTOT1886, 
	nombre_habitant.PTOT1891, 
	nombre_habitant.PTOT1896, 
	nombre_habitant.PTOT1901, 
	nombre_habitant.PTOT1906, 
	nombre_habitant.PTOT1911, 
	nombre_habitant.PTOT1921, 
	nombre_habitant.PTOT1926, 
	nombre_habitant.PTOT1931, 
	nombre_habitant.PTOT36, 
	nombre_habitant.PTOT54, 
    c.geom
FROM
    ta_identifiant_commune a
    INNER JOIN ta_code b ON a.fid_identifiant = b.objectid
    INNER JOIN ta_commune c ON a.fid_commune = c.objectid
    INNER JOIN ta_nom d ON c.fid_nom = d.objectid
    INNER JOIN ta_metadonnee e ON c.fid_metadonnee = e.objectid
    INNER JOIN ta_source f ON e.fid_source = f.objectid
    INNER JOIN ta_organisme h ON e.fid_organisme = h.objectid
    INNER JOIN ta_date_acquisition j ON e.fid_acquisition = j.objectid
    INNER JOIN ta_libelle p ON b.fid_libelle = p.objectid
    INNER JOIN ta_libelle_long q ON p.fid_libelle_long = q.objectid
    INNER JOIN nombre_habitant ON nombre_habitant.code_insee = b.code
WHERE
    q.valeur = 'code insee'
;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE admin_communes_mel_recensement_historique IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.identifiant IS 'Clé primaire de la vue.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.code_insee IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.nom IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN06 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2006';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN07 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2007';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN08 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2008';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN09 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2009';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN10 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2010';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN11 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2011'; 
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN12 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2012';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN13 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2013';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN14 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2014';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN15 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2015';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN16 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2016';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PMUN17 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population municipale en 2017';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PSDC62 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population sans double compte en 1962';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PSDC68 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population sans double compte en 1968';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PSDC75 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population sans double compte en 1975';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PSDC82 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population sans double compte en 1982';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PSDC90 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population sans double compte en 1990';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PSDC99 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population sans double compte en 1999';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1876 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1876';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1881 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1881';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1886 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1886';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1891 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1891';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1896 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1896';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1901 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1901';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1906 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1906';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1911 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1911';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1921 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1921';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1926 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1926';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT1931 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1931';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT36 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019.  Population Totale en 1936';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.PTOT54 IS 'Historique des population communales 1876-2017 calculés sur la base de la géographie des communes en 2019. Population Totale en 1954';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.geom IS 'Géométrie de chaque commune - de type polygone.';

-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'admin_communes_mel_recensement_historique',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 4. Création de l'index spatial
CREATE INDEX admin_communes_mel_recensement_historique_SIDX
ON admin_communes_mel_recensement_historique(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);