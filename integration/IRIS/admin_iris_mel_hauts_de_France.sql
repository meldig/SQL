-- Création de la vue IRIS
/*
DROP MATERIALIZED VIEW g_geo.vm_admin_iris_hauts_de_france;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'VM_ADMIN_IRIS_HAUTS_DE_FRANCE';
*/
-- 1. Création de la vue

CREATE MATERIALIZED VIEW vm_admin_iris_hauts_de_france
	(
	identifiant,
	code_iris,
	nom_iris,
	type_iris,
	code_insee,
	nom_commune,
	source,
	geom
	)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
-- sous requête pour sélectionner les IRIS et leus informations*/
WITH 
/*
1. Sous requête pour selectionner le millésime le plus récent
*/
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
		    b.nom_source = 'Contours...IRIS'
		    AND ROWNUM = 1
		),
/*
-1. Sous requête pour selectionner les organismes producteurs sur une seule ligne
*/
  organisme AS (
		SELECT
            DISTINCT
		    b.objectid AS ID_MTD,
		    LISTAGG(d.acronyme, ';')
		    WITHIN GROUP(ORDER BY d.acronyme) AS acronyme
		FROM
		ta_iris a
		-- métadonnée
		    INNER JOIN ta_metadonnee b ON b.objectid = a.fid_metadonnee
		    INNER JOIN ta_metadonnee_relation_organisme c ON c.fid_metadonnee = b.objectid
		    INNER JOIN ta_organisme d ON d.objectid = c.fid_organisme,
		    millesime e
		WHERE
		    b.objectid = e.id_mtd
	    GROUP BY a.objectid, b.objectid
	    ),
/*
-2. sous requete pour selectionner les communes qui croisent les zones IRIS
*/
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
		INNER JOIN ta_libelle lco ON lco.objectid = codeco.fid_libelle
		INNER JOIN ta_libelle_long llco ON llco.objectid = lco.fid_libelle_long
		INNER JOIN ta_za_communes zc ON zc.fid_commune = co.objectid
		INNER JOIN ta_zone_administrative za ON za.objectid = zc.fid_zone_administrative
		INNER JOIN ta_nom nomza ON nomza.objectid = za.fid_nom,
			ta_iris i
		INNER JOIN ta_iris_geom ig ON ig.objectid = i.fid_iris_geom
		INNER JOIN millesime mi ON mi.id_mtd = i.fid_metadonnee
		WHERE
			SDO_ANYINTERACT(ig.geom, co.geom) = 'TRUE'
		AND
			llco.valeur = 'code insee'
		AND
			nomza.valeur = 'Hauts-de-France'
		),
/*
-3. sous requete pour selectionner la commune recouverte principalement par une zone iris afin de définier la commune de localisation de la zone IRIS
*/
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
			FROM
				commune_surface
			GROUP BY iris_objectid) groupe_cs
			ON cs.iris_objectid = groupe_cs.iris_objectid
			AND cs.area = groupe_cs.maxArea
		)
/*
-4. requete principale pour sélectionner les IRIS avec leurs métadonnées et leurs communes de localisation
*/
	SELECT
		CAST(csm.CODE_INSEE || codei.valeur AS INT) AS identifiant,
		csm.CODE_INSEE || codei.valeur AS code_iris,
		nomi.valeur AS nom_iris,
		lci.valeur AS type_iris,
		csm.CODE_INSEE AS code_insee,
		csm.NOM_COMMUNE AS nom_commune,
		s.nom_source || ' - ' || o.acronyme || ' - ' || e.valeur || ' - ' || ml.MILLESIME AS source,
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
	INNER JOIN millesime ml ON ml.id_mtd = i.fid_metadonnee
    INNER JOIN ta_metadonnee m ON m.objectid = ml.id_mtd
    INNER JOIN ta_metadonnee_relation_echelle me ON me.fid_metadonnee = m.objectid
    INNER JOIN ta_echelle e ON e.objectid = me.fid_echelle
    INNER JOIN ta_source s ON s.objectid = m.fid_source
    INNER JOIN commune_surface_max csm ON csm.iris_objectid = i.objectid
    INNER JOIN organisme o ON o.ID_MTD = ml.id_mtd
	;



-- 2. Création des commentaires de table et de colonnes

COMMENT ON MATERIALIZED VIEW vm_admin_iris_hauts_de_france IS 'Vue proposant les IRIS actuelles de la MEL extraites des données Contours...IRIS de l''INSEE coproduites avec l''IGN.';
COMMENT ON COLUMN vm_admin_iris_hauts_de_france.identifiant IS 'Clé primaire de la vue, code de la zone IRIS.';
COMMENT ON COLUMN vm_admin_iris_hauts_de_france.code_iris IS 'code de la zone IRIS.';
COMMENT ON COLUMN vm_admin_iris_hauts_de_france.nom_iris IS 'Nom de la zone IRIS.';
COMMENT ON COLUMN vm_admin_iris_hauts_de_france.type_iris IS 'Type de zone IRIS.';
COMMENT ON COLUMN vm_admin_iris_hauts_de_france.code_insee IS 'Code insee de la commune de la zone iris';
COMMENT ON COLUMN vm_admin_iris_hauts_de_france.nom_commune IS 'Nom de la commune de la zone IRIS';
COMMENT ON COLUMN vm_admin_iris_hauts_de_france.source IS 'metadonnée de la vue';
COMMENT ON COLUMN vm_admin_iris_hauts_de_france.geom IS 'Géométrie de chaque iris - de type polygone.';


-- 3. Création des métadonnées spatiales

INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'vm_admin_iris_hauts_de_france',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);


-- 4. Création de la clé primaire
ALTER MATERIALIZED VIEW vm_admin_iris_hauts_de_france 
ADD CONSTRAINT vm_admin_iris_haut_de_france_PK 
PRIMARY KEY (IDENTIFIANT);


-- 5. Création de l'index spatial
CREATE INDEX vm_admin_iris_hauts_de_france_SIDX
ON vm_admin_iris_hauts_de_france(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);