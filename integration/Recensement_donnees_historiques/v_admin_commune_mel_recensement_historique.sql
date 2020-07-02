-- Création de la vue des communes actuelles de la MEL via la BdTopo de l'IGN avec les données historiques des populations communales 1876-2017 calculées sur la base de la géographie des communes en 2019. 

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW admin_communes_mel_recensement_historique
	(
    identifiant, 
    code_insee, 
    nom, 
	recensement,
	population,
	source,
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
			a.valeur AS CODE_INSEE,
			e.valeur AS RECENSEMENT,
			b.population AS POPULATION,
			CONCAT(CONCAT(CONCAT(CONCAT(j.nom_source,  ' - '), l.acronyme),  ' - '), m.millesime) AS source
		FROM
			ta_recensement b
		INNER JOIN ta_code a ON a.objectid = b.fid_code
		INNER JOIN ta_libelle c ON c.objectid = b.fid_lib_recensement
		INNER JOIN ta_libelle_correspondance d ON d.fid_libelle = c.objectid
		INNER JOIN ta_libelle_court e ON e.objectid = d.fid_libelle_court
		INNER JOIN ta_libelle_long f ON f.objectid = c.fid_libelle_long
		INNER JOIN ta_famille_libelle g ON g.fid_libelle_long = f.objectid
		INNER JOIN ta_famille h ON h.objectid = g.fid_famille
		INNER JOIN ta_metadonnee i ON i.objectid = b.fid_metadonnee
		INNER JOIN ta_source j ON j.objectid = i.fid_source
		INNER JOIN ta_metadonnee_relation_organisme k ON i.objectid = k.fid_metadonnee
		INNER JOIN ta_organisme l ON k.fid_organisme = l.objectid
		INNER JOIN ta_date_acquisition m ON m.objectid = i.fid_acquisition
		WHERE
			h.valeur = 'Recensement'
		)
	)
-- Sélection principale des éléments de la vue. Utilisation des données de la sous requête isolant les données du recensement et des données liées aux communes
SELECT
    b.valeur AS identifiant, 
    b.valeur AS code_insee, 
    d.valeur AS nom, 
	nombre_habitant.population,
    nombre_habitant.recensement,
	CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(f.nom_source,  ' - '), h.acronyme),  ' - '), j.millesime), ' - '), nombre_habitant.source) AS source,
    c.geom
FROM
    ta_identifiant_commune a
    INNER JOIN ta_code b ON a.fid_identifiant = b.objectid
    INNER JOIN ta_commune c ON a.fid_commune = c.objectid
    INNER JOIN ta_nom d ON c.fid_nom = d.objectid
    INNER JOIN ta_metadonnee e ON c.fid_metadonnee = e.objectid
    INNER JOIN ta_source f ON e.fid_source = f.objectid
    INNER JOIN ta_metadonnee_relation_organisme g ON e.objectid = g.fid_metadonnee
    INNER JOIN ta_organisme h ON g.fid_organisme = h.objectid
    INNER JOIN ta_date_acquisition j ON e.fid_acquisition = j.objectid
    INNER JOIN ta_libelle p ON b.fid_libelle = p.objectid
    INNER JOIN ta_libelle_long q ON p.fid_libelle_long = q.objectid
    INNER JOIN nombre_habitant ON nombre_habitant.code_insee = b.valeur
WHERE
    q.valeur = 'code insee'
;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE admin_communes_mel_recensement_historique IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.identifiant IS 'Clé primaire de la vue.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.code_insee IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.nom IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.population IS 'Nombre d''habitant au sein de la commune calculé sur la base de la géographie des communes en 2019.';
COMMENT ON COLUMN admin_communes_mel_recensement_historique.recensement IS 'Type de recensement';
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