/*
Requêtes nécessaires à la création de la vue matérialisée G_REFERENTIEL.ADMIN_IRIS.
Cette vue materialisée à pour but de restituer les données IRIS aux millesimes le plus récent.
*/

-- 1. Table temporaire pour selectionner les communes au dernier millesime.
-- 1.1. Création de la table temporaire TEMP_COMMUNES_VM pour selectionner les communes au dernier millesime.
CREATE TABLE G_REFERENTIEL.TEMP_COMMUNES_VM(
	CODE_INSEE VARCHAR2(4000 BYTE),
	NOM_COMMUNE VARCHAR2(4000 BYTE),
	GEOM SDO_GEOMETRY
	);


-- 1.2. Création des metadonnees spatiales.
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
	)
VALUES(
    'TEMP_COMMUNES_VM',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
	);


-- 1.3. Création de l'index spatial
CREATE INDEX TEMP_COMMUNES_VM_SIDX
ON G_REFERENTIEL.TEMP_COMMUNES_VM(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
	'sdo_indx_dims=2, 
	layer_gtype=MULTIPOLYGON, 
	tablespace=G_ADT_INDX, 
	work_tablespace=DATA_TEMP'
	);


-- 1.4. Insertion des communes dans la table temporaire G_REFERENTIEL.TEMP_COMMUNES_VM
MERGE INTO G_REFERENTIEL.TEMP_COMMUNES_VM a
	USING
		(
		WITH millesime AS (
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
				)
				SELECT 
					codeco.valeur AS CODE_INSEE,
					nomc.valeur AS NOM_COMMUNE,
                    co.geom
				FROM
					G_GEO.TA_IDENTIFIANT_COMMUNE ti
				INNER JOIN G_GEO.TA_CODE codeco ON codeco.objectid = ti.fid_identifiant
				INNER JOIN G_GEO.TA_COMMUNE co ON co.objectid = ti.fid_commune
				INNER JOIN G_GEO.TA_NOM nomc ON nomc.objectid = co.fid_nom
				INNER JOIN G_GEO.TA_LIBELLE lco ON lco.objectid = codeco.fid_libelle
				INNER JOIN G_GEO.TA_LIBELLE_LONG llco ON llco.objectid = lco.fid_libelle_long
				INNER JOIN G_GEO.TA_ZA_COMMUNES zc ON zc.fid_commune = co.objectid
				INNER JOIN G_GEO.TA_ZONE_ADMINISTRATIVE za ON za.objectid = zc.fid_zone_administrative
				INNER JOIN G_GEO.TA_NOM nomza ON nomza.objectid = za.fid_nom
				INNER JOIN G_GEO.TA_METADONNEE mc ON mc.objectid = co.fid_metadonnee
				INNER JOIN G_GEO.TA_SOURCE so ON so.objectid = mc.fid_source
				INNER JOIN G_GEO.TA_DATE_ACQUISITION dc ON dc.objectid = mc.fid_acquisition,
                millesime millesime
				WHERE
					UPPER(llco.valeur) = UPPER('code insee')
				AND
					UPPER(nomza.valeur) IN (UPPER('Oise'), UPPER('Pas-de-Calais'), UPPER('Nord'), UPPER('Somme'), UPPER('Aisne'))
				AND
					UPPER(so.nom_source)  = UPPER('BDTOPO')
				AND
					dc.millesime = millesime.millesime
		)b
ON(a.CODE_INSEE = b.CODE_INSEE
AND a.NOM_COMMUNE = b.NOM_COMMUNE)
WHEN NOT MATCHED THEN
INSERT (a.CODE_INSEE, a.NOM_COMMUNE, a.geom)
VALUES (b.CODE_INSEE, b.NOM_COMMUNE, b.geom);



-- 2.1. Table temporaire pour selectionner les aires d'intersection entre les communes et les IRIS
CREATE TABLE G_REFERENTIEL.TEMP_COMMUNES_SURFACES(
	CODE_INSEE VARCHAR2(4000 BYTE),
	NOM_COMMUNE VARCHAR2(4000 BYTE),
    iris_objectid NUMBER (38,0),
	AREA NUMBER (38,10)
	);


-- 2.2. insertion des données dans la table temporaire G_REFERENTIEL.TEMP_COMMUNES_SURFACES
MERGE INTO G_REFERENTIEL.TEMP_COMMUNES_SURFACES a
	USING
		(
		WITH millesime AS (
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
		         UPPER(b.nom_source) =  UPPER('Contours...IRIS')
			)
			SELECT 
				co.CODE_INSEE AS CODE_INSEE,
				co.NOM_COMMUNE AS NOM_COMMUNE,
				i.objectid AS iris_objectid,
				sdo_geom.sdo_area(
					sdo_geom.sdo_intersection(co.geom, ig.geom, 0.005),
					0.005,
					'unit=sq_m'
				) area
			FROM
				G_REFERENTIEL.TEMP_COMMUNES_VM co,
				G_GEO.TA_IRIS i
			INNER JOIN G_GEO.TA_IRIS_GEOM ig ON ig.objectid = i.fid_iris_geom
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
			INNER JOIN millesime millesime ON millesime.id_mtd = i.fid_metadonnee
			WHERE
				SDO_RELATE(co.geom, ig.geom, 'mask=ANYINTERACT') = 'TRUE'
			AND 
				 UPPER(llf.valeur) =  UPPER('identifiants de zone statistique')
			AND
				 UPPER(fi.valeur) =  UPPER('type de zone IRIS')
		)b
ON(a.CODE_INSEE = b.CODE_INSEE
AND a.iris_objectid = b.iris_objectid)
WHEN NOT MATCHED THEN
INSERT (a.CODE_INSEE, a.NOM_COMMUNE, a.iris_objectid, a.area)
VALUES (b.CODE_INSEE, b.NOM_COMMUNE, b.iris_objectid, b.area);


-- 3.1. Création de la table temporaire G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX pour séléctionner la commune ou l'aire d'intersection avec l'IRIS est maximale. 
CREATE TABLE G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX (
CODE_INSEE VARCHAR2(4000 BYTE),
NOM_COMMUNE VARCHAR(4000),
IRIS_objectid VARCHAR(4000)
);


-- 3.2. Insertion des aires maximales dans la table G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX.
MERGE INTO G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX a
	USING
		(
		SELECT
			cs.CODE_INSEE AS CODE_INSEE,
			cs.NOM_COMMUNE AS NOM_COMMUNE,
			cs.IRIS_OBJECTID AS IRIS_OBJECTID
		FROM
			G_REFERENTIEL.TEMP_COMMUNES_SURFACES cs 
		INNER JOIN
			(
				SELECT
					iris_objectid,
					MAX(area) AS maxArea
				FROM
					G_REFERENTIEL.TEMP_COMMUNES_SURFACES
				GROUP BY IRIS_OBJECTID
			) groupe_cs
			ON cs.IRIS_OBJECTID = groupe_cs.IRIS_OBJECTID
			AND cs.area = groupe_cs.maxArea
		)b
ON(a.CODE_INSEE = b.CODE_INSEE
AND a.NOM_COMMUNE = b.NOM_COMMUNE
AND A.IRIS_OBJECTID = b.IRIS_OBJECTID)
WHEN NOT MATCHED THEN
INSERT (a.CODE_INSEE, a.NOM_COMMUNE, a.IRIS_OBJECTID)
VALUES (b.CODE_INSEE, b.NOM_COMMUNE, b.IRIS_OBJECTID);

/*
4 Creation de la vue
Requêtes nécessaires à la création de la vue matérialisée G_REFERENTIEL.ADMIN_IRIS.
Cette vue materialisée à pour but de restituer les données IRIS aux millesimes le plus récent.
*/

/*
-- 4.1. Creation de la vue materialisée G_REFERENTIEL.ADMIN_IRIS.
-- 4.2. Suppression de la vue G_REFERENTIEL.ADMIN_IRIS, et des métadonnées si elle existe déjà.
*/
DROP MATERIALIZED VIEW G_REFERENTIEL.ADMIN_IRIS;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'ADMIN_IRIS';

-- 4.3. Création de la vue
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
-- 4.4. Sous requête pour selectionner le millésime le plus récent
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
-- 4.5. Sous requête pour selectionner les organismes producteurs sur une seule ligne
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
-- 4.6. sous requete totale
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
    

-- 5. Création des commentaires de table et de colonnes
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


-- 6. Création des métadonnées spatiales
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


-- 7. Création de la clé primaire
ALTER MATERIALIZED VIEW G_REFERENTIEL.ADMIN_IRIS 
ADD CONSTRAINT admin_iris_PK
PRIMARY KEY (IDENTIFIANT)
USING INDEX TABLESPACE "G_ADT_INDX";


-- 8. Création de l'index spatial
CREATE INDEX admin_iris_SIDX
ON G_REFERENTIEL.ADMIN_IRIS(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
	'sdo_indx_dims=2, 
	layer_gtype=MULTIPOLYGON, 
	tablespace=G_ADT_INDX, 
	work_tablespace=DATA_TEMP'
	);

/*
Requêtes nécessaires à la suppression des table temporaire nécessaire à la création de la vue matérialisée G_REFERENTIEL.ADMIN_IRIS.
*/

-- 9. Suppression des tables temporaire
-- 9.1
DROP TABLE G_REFERENTIEL.TEMP_COMMUNES_VM CASCADE CONSTRAINTS;
DELETE FROM USER_SDO_GEOM_METADATA WHERE table_name = 'TEMP_COMMUNES_VM';

-- 9.2
DROP TABLE G_REFERENTIEL.TEMP_COMMUNES_SURFACES CASCADE CONSTRAINTS;

-- 9.3
DROP TABLE G_REFERENTIEL.TEMP_COMMUNES_SURFACES_MAX CASCADE CONSTRAINTS;