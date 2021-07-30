-- CREATION DE LA VUE MATERIALISEE G_OSM.VM_OSM_PIVOT_POINT.
-- Vue proposant les équipements OSM points et les centroids(point on surface) des polygones OSM actuellement disponible sur le territoire de la MEL avec les principaux mots clé pivotés en colonne


--1. CREATION DE LA VUE MATERIALISEE.
CREATE MATERIALIZED VIEW G_OSM.VM_OSM_PIVOT_POINT
	(
	 	OBJECTID,
		OSM_ID,
		OSM_WAY_ID,
		AMENITY,
		NAME,
		"NATURAL",
		BICYCLE_PARKING,
		"ACCESS",
		LEISURE,
		SCHOOL_FR,
		SPORT,
		PARKING,
		RELIGION,
		BUILDING,
		LANDUSE,	
		CAPACITY,
		SEATS,
		HEIGHT,
	    SOURCE,
		GEOM
	)
USING INDEX
TABLESPACE G_ADT_INDX
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
-- SELECTION DES POINTS OSM.
WITH ATTRIBUT AS (
	SELECT
	    DISTINCT 
	        a.OBJECTID,
            a.FID_METADONNEE,
			b.AMENITY,
			c.NAME,
			d."NATURAL",
			e.BICYCLE_PARKING,
			f."ACCESS",
			g.LEISURE,
			h.SCHOOL_FR,
			i.SPORT,
			j.PARKING,
			k.RELIGION,
			l.BUILDING,
			m.LANDUSE,
			-- CARACTERISTIQUE QUANTITATIF.
			n.OSM_ID,
			o.OSM_WAY_ID,
			p.CAPACITY,
			q.SEATS,
			r.HEIGHT
	FROM
	    G_OSM.TA_OSM a
	    -- SELECTION DES PRINCIPAUX ATTRIBUTS.
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS AMENITY
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'AMENITY'
	    			) b
	    			ON b.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS NAME
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'NAME'
	    			) c
	    			ON c.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS "NATURAL"
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'NATURAL'
	    			) d
	    			ON d.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS BICYCLE_PARKING
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'BICYCLE_PARKING'
	    			) e
	    			ON e.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS "ACCESS"
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'ACCESS'
	    			) f
	    			ON f.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS LEISURE
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'LEISURE'
	    			) g
	    			ON g.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS SCHOOL_FR
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'SCHOOL_FR'
	    			) h
	    			ON h.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS SPORT
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'SPORT'
	    			) i
	    			ON i.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS PARKING
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE 
					WHERE
					    KEY = 'PARKING'
	    			) j
	    			ON j.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS RELIGION
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE 
					WHERE
					    KEY = 'RELIGION'
	    			) k
	    			ON k.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS BUILDING
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE 
					WHERE
					    KEY = 'BUILDING'
	    			) l
	    			ON l.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS LANDUSE
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE
					WHERE
					    KEY = 'LANDUSE'
	    			) m
	    			ON m.FID_OSM = a.OBJECTID
	    			-- SELECTION DES PRINCIPAUX ATTRIBUTS QUANTITATIFS.
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS OSM_ID
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE
					WHERE
					    KEY = 'OSM_ID'
	    			) n
	    			ON n.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS OSM_WAY_ID
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE
					WHERE
					    KEY = 'OSM_WAY_ID'
	    			) o
	    			ON o.FID_OSM = a.OBJECTID	  
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS CAPACITY
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE 
					WHERE
					    KEY = 'CAPACITY'
	    			) p
	    			ON p.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS SEATS
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE 
					WHERE
					    KEY = 'SEATS'
	    			) q
	    			ON q.FID_OSM = a.OBJECTID
	    LEFT JOIN (
					SELECT
					    FID_OSM,
					    VALEUR AS HEIGHT
					FROM
					    G_OSM.TA_OSM_CARACTERISTIQUE_QUANTITATIVE 
					WHERE
					    KEY = 'HEIGHT'
	    			) r
	    			ON r.FID_OSM = a.OBJECTID
		INNER JOIN G_GEO.TA_METADONNEE me ON me.objectid = a.fid_metadonnee
	    INNER JOIN G_GEO.TA_DATE_ACQUISITION aq ON aq.objectid = me.fid_acquisition
	WHERE
		EXTRACT(YEAR from aq.date_acquisition)=TO_CHAR(sysdate, 'yyyy')
	GROUP BY
	        a.OBJECTID,
            a.FID_METADONNEE,            
			b.AMENITY,
			c.NAME,
			d."NATURAL",
			e.BICYCLE_PARKING,
			f."ACCESS",
			g.LEISURE,
			h.SCHOOL_FR,
			i.SPORT,
			j.PARKING,
			k.RELIGION,
			l.BUILDING,
			m.LANDUSE,
			-- CARACTERISTIQUE QUANTITATIFS.
			n.OSM_ID,
			o.OSM_WAY_ID,
			p.CAPACITY,
			q.SEATS,
			r.HEIGHT
	        )
-- SELECTION PRINCIPAL
SELECT
        a.OBJECTID,
		a.OSM_ID,
		a.OSM_WAY_ID,
		a.AMENITY,
		a.NAME,
		a."NATURAL",
		a.BICYCLE_PARKING,
		a."ACCESS",
		a.LEISURE,
		a.SCHOOL_FR,
		a.SPORT,
		a.PARKING,
		a.RELIGION,
		a.BUILDING,
		a.LANDUSE,
		a.CAPACITY,
		a.SEATS,
		a.HEIGHT,
		so.nom_source || ' - ' || no.nom_organisme || ' - ' || aq.MILLESIME AS SOURCE,
		d.GEOM
FROM
	ATTRIBUT a
	INNER JOIN G_OSM.TA_OSM b ON b.OBJECTID = a.OBJECTID
	INNER JOIN G_OSM.TA_OSM_RELATION_POINT_GEOM c ON c.fid_osm = b.objectid
	INNER JOIN G_OSM.TA_OSM_POINT_GEOM d ON d.OBJECTID = c.fid_osm_point_geom
	INNER JOIN G_GEO.TA_METADONNEE me ON me.objectid = a.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE so ON so.objectid = me.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME mro ON mro.fid_metadonnee = me.objectid
    INNER JOIN G_GEO.TA_ORGANISME no ON no.objectid = mro.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION aq ON aq.objectid = me.fid_acquisition
-- UNION POUR SELECTIONNER LES CENTROIDS (POINT ON SURFACE) DES POLYGONES 
UNION ALL
SELECT
        a.OBJECTID,
		a.OSM_ID,
		a.OSM_WAY_ID,
		a.AMENITY,
		a.NAME,
		a."NATURAL",
		a.BICYCLE_PARKING,
		a."ACCESS",
		a.LEISURE,
		a.SCHOOL_FR,
		a.SPORT,
		a.PARKING,
		a.RELIGION,
		a.BUILDING,
		a.LANDUSE,
		a.CAPACITY,
		a.SEATS,
		a.HEIGHT,
		so.nom_source || ' - ' || no.nom_organisme || ' - ' || aq.MILLESIME || ' ' || 'CENTROID MULTIPOLYGONES OSM' AS SOURCE,
    	SDO_GEOM.SDO_CENTROID(d.GEOM) AS GEOM
FROM
	ATTRIBUT a
	INNER JOIN G_OSM.TA_OSM b ON b.OBJECTID = a.OBJECTID
	INNER JOIN G_OSM.TA_OSM_RELATION_GEOM c ON c.fid_osm = b.objectid
	INNER JOIN G_OSM.TA_OSM_GEOM d ON d.OBJECTID = c.fid_osm_geom
	INNER JOIN G_GEO.TA_METADONNEE me ON me.objectid = a.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE so ON so.objectid = me.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME mro ON mro.fid_metadonnee = me.objectid
    INNER JOIN G_GEO.TA_ORGANISME no ON no.objectid = mro.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION aq ON aq.objectid = me.fid_acquisition;

-- 2. CREATION DES COMMENTAIRES DE LA VUE ET DES COLONNES.
COMMENT ON MATERIALIZED VIEW G_OSM.VM_OSM_PIVOT_POINT IS 'Vue proposant les équipements OSM points et les centroids des polygones OSM actuellement disponibles sur le territoire de la MEL avec les principaux mots clé pivotés en colonne';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.OBJECTID IS 'Clé primaire de la table';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.OSM_ID IS 'Identifiant OSM de l''élement OSM';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.OSM_WAY_ID IS 'Identifiant OSM de l''élement WAY OSM';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.AMENITY IS 'Type de l''équipent utile et important cartographié: école, crêche, bureau de poste';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.NAME IS 'Nom de l''équipement';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT."NATURAL" IS 'Type de l''équipement OSM naturel: arbre';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.BICYCLE_PARKING IS 'Type de parking pour vélos: stand, bollard'
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT."ACCESS" IS 'Accessibilité de l''équipement: public, privé, client';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.LEISURE IS 'Type d''équipement de loisir cartographié: parc, terrain de jeu';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.SCHOOL_FR IS 'Niveau de l''école française: maternelle, primaire, college';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.SPORT IS 'Type d''équipement sportif cartographié: bowling, judo';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.PARKING IS 'Type de parking: surface, souterrain';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.RELIGION IS 'Religion concernée par l''équipement: chrétien, musulman...';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.BUILDING IS 'Type de batiment; école, hôpital, église';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.LANDUSE IS 'Utilisation du sol: industielle, loisir...';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.CAPACITY IS 'Capacité de l''équipement';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.SEATS IS 'Nombre de place assise de l''équipement';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.HEIGHT IS 'Hauteur de l''équipement';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.SOURCE IS 'Source de la donnée';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_POINT.GEOM IS 'Géométrie de l''équipement';


-- 3. CREATION DE LA CLE PRIMAIRE.
ALTER MATERIALIZED VIEW VM_OSM_PIVOT_POINT
ADD CONSTRAINT VM_OSM_PIVOT_POINT_PK
PRIMARY KEY (OBJECTID);


-- 4. AJOUT DES METADONNEE.
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME,
    COLUMN_NAME,
    DIMINFO,
    SRID
)
VALUES(
    'VM_OSM_PIVOT_POINT',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)),
    2154
);
COMMIT;


-- 5. CREATION DE L'INDEX SPATIAL.
CREATE INDEX VM_OSM_PIVOT_POINT_SIDX
ON G_OSM.VM_OSM_PIVOT_POINT(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2,
  layer_gtype=POINT,
  tablespace=G_ADT_INDX,
  work_tablespace=DATA_TEMP'
);