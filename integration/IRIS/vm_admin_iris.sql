/*
1 Creation de la vue
Requêtes nécessaires à la création de la vue matérialisée G_REFERENTIEL.ADMIN_IRIS.
Cette vue materialisée à pour but de restituer les données IRIS aux millesimes le plus récent.
*/

/*
-- 1.1. Creation de la vue materialisée G_REFERENTIEL.ADMIN_IRIS.
-- 1.2. Suppression de la vue G_REFERENTIEL.ADMIN_IRIS, et des métadonnées si elle existe déjà.
*/
DROP MATERIALIZED VIEW G_REFERENTIEL.ADMIN_IRIS;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'ADMIN_IRIS';


-- 1.3. Création de la vue
CREATE MATERIALIZED VIEW G_REFERENTIEL.ADMIN_IRIS
	(
	IDENTIFIANT,
	ANNEE,
	CODE_IRIS,
	NOM_IRIS,
	TYPE_IRIS,
	LIBELLE_TYPE_IRIS,
	CODE_INSEE,
	NOM_COMMUNE,
	SOURCE,
	GEOM
	)
USING INDEX
TABLESPACE G_ADT_INDX
REFRESH ON DEMAND
FORCE  
DISABLE QUERY REWRITE AS

-- sous requete pour les millesime et les organismes
WITH 
/*
-- 1.4. Sous requête pour selectionner le millésime le plus récent
*/
	millesime AS (
	    SELECT
	        a.objectid AS id_mtd,
	        c.millesime AS millesime
	    FROM
	        G_GEO.TA_METADONNEE a
	        INNER JOIN G_GEO.TA_SOURCE b ON a.fid_source = b.objectid
	        INNER JOIN G_GEO.TA_DATE_ACQUISITION c ON c.objectid = a.fid_acquisition
	    WHERE
	        c.millesime IN(
	                    SELECT
	                        MAX(b.millesime) as MILLESIME
	                    FROM
	                        G_GEO.TA_METADONNEE a
	                    INNER JOIN G_GEO.TA_DATE_ACQUISITION  b ON a.fid_acquisition = b.objectid 
	                    INNER JOIN G_GEO.TA_SOURCE c ON c.objectid = a.fid_source
	                    WHERE UPPER(c.nom_source) = UPPER('Contours...IRIS')
	                    )
	    AND
	        UPPER(b.nom_source) = UPPER('Contours...IRIS')
		),
/*
-- 1.5. Sous requête pour selectionner les organismes producteurs sur une seule ligne
*/
  	organisme AS (
		SELECT
            DISTINCT
		    b.objectid AS ID_MTD,
		    LISTAGG(d.acronyme, ';')
		    WITHIN GROUP(ORDER BY d.acronyme) AS acronyme
		FROM
		G_GEO.TA_IRIS a
		-- métadonnée
		    INNER JOIN G_GEO.TA_METADONNEE b ON b.objectid = a.fid_metadonnee
		    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME c ON c.fid_metadonnee = b.objectid
		    INNER JOIN G_GEO.TA_ORGANISME d ON d.objectid = c.fid_organisme,
		    millesime e
		WHERE
		    b.objectid = e.id_mtd
	    GROUP BY a.objectid, b.objectid
	    )
/*
-- 1.6. sous requete totale
*/
	SELECT
		CAST(csm.CODE_INSEE || codei.valeur AS INT) AS IDENTIFIANT,
		extract(year from millesime.millesime) AS ANNEE,
		TO_CHAR(csm.CODE_INSEE || codei.valeur) AS CODE_IRIS,
		nomi.valeur AS NOM_IRIS,
		lci.valeur AS TYPE_IRIS,
		lli.valeur AS LIBELLE_TYPE_IRIS,
		TO_CHAR(csm.CODE_INSEE) AS CODE_INSEE,
		csm.NOM_COMMUNE AS NOM_COMMUNE,
		s.nom_source || ' - ' || o.acronyme || ' - ' || e.valeur || ' - ' || millesime.millesime AS SOURCE,
		g.geom
	FROM
		G_GEO.TA_IRIS i
		INNER JOIN G_GEO.TA_NOM nomi ON nomi.objectid = i.fid_nom
		INNER JOIN G_GEO.TA_CODE codei ON codei.objectid = i.fid_code
		-- distinction pour ne selectonner que les IRIS
		INNER JOIN G_GEO.TA_LIBELLE lc ON lc.objectid = codei.fid_libelle
		INNER JOIN G_GEO.TA_LIBELLE_LONG llc ON llc.objectid = lc.fid_libelle_long
		INNER JOIN G_GEO.TA_FAMILLE_LIBELLE llcf ON llcf.fid_libelle_long = llc.objectid
		INNER JOIN G_GEO.TA_FAMILLE llf ON llf.objectid = llcf.fid_famille
		-- distinction pour le type d'IRIS
		INNER JOIN G_GEO.TA_LIBELLE li ON li.objectid = i.fid_lib_type
		INNER JOIN G_GEO.TA_LIBELLE_LONG lli ON lli.objectid = li.fid_libelle_long
		INNER JOIN G_GEO.TA_FAMILLE_LIBELLE fli ON fli.fid_libelle_long = lli.objectid
		INNER JOIN G_GEO.TA_FAMILLE fi ON fi.objectid = fli.fid_famille
		INNER JOIN G_GEO.TA_LIBELLE_CORRESPONDANCE cli ON cli.fid_libelle = li.objectid
		INNER JOIN G_GEO.TA_LIBELLE_COURT lci ON lci.objectid = cli.fid_libelle_court
		INNER JOIN G_GEO.TA_IRIS_GEOM g ON g.objectid = i.fid_iris_geom
		-- jointure des metadonnees avec l'organisme INSEE
		INNER JOIN millesime millesime ON millesime.id_mtd = i.fid_metadonnee
	    INNER JOIN G_GEO.TA_METADONNEE m ON m.objectid = millesime.id_mtd
	    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ECHELLE me ON me.fid_metadonnee = m.objectid
	    INNER JOIN G_GEO.TA_ECHELLE e ON e.objectid = me.fid_echelle
	    INNER JOIN G_GEO.TA_SOURCE s ON s.objectid = m.fid_source
	    INNER JOIN G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX csm ON csm.iris_objectid = i.objectid
	    INNER JOIN organisme o ON o.ID_MTD = m.objectid
    WHERE
    	UPPER(fi.valeur) = UPPER('type de zone IRIS')
    AND
    	UPPER(llf.valeur) = UPPER('identifiants de zone statistique')
	;
    

-- 2. Création des commentaires de table et de colonnes
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.IDENTIFIANT IS 'Clé primaire de la vue, code de la zone IRIS.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.ANNEE IS 'Annee du millesime.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.CODE_IRIS IS 'code de la zone IRIS.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.NOM_IRIS IS 'Nom de la zone IRIS.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.TYPE_IRIS IS 'Type de zone IRIS.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.LIBELLE_TYPE_IRIS IS 'Libelle du type de zone IRIS.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.CODE_INSEE IS 'Code insee de la commune de la zone iris';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.NOM_COMMUNE IS 'Nom de la commune de la zone IRIS';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.SOURCE IS 'metadonnée de la vue';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_IRIS.GEOM IS 'Géométrie de chaque iris - de type polygone.';


-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
	)
VALUES(
    'ADMIN_IRIS',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
	);


-- 4. Création de la clé primaire
ALTER MATERIALIZED VIEW G_REFERENTIEL.ADMIN_IRIS 
ADD CONSTRAINT admin_iris_PK
PRIMARY KEY (IDENTIFIANT)
USING INDEX TABLESPACE "G_ADT_INDX";


-- 5. Création de l'index spatial
CREATE INDEX admin_iris_SIDX
ON G_REFERENTIEL.ADMIN_IRIS(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
	'sdo_indx_dims=2, 
	layer_gtype=MULTIPOLYGON, 
	tablespace=G_ADT_INDX, 
	work_tablespace=DATA_TEMP'
	);