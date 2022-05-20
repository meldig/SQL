-- CREATION DE LA VUE MATERIALISEE G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.
-- Vue proposant les équipements polygones OSM actuellement disponibles sur le territoire de la MEL avec les principaux mots clés pivotés en colonnes

--1. CREATION DE LA VUE MATERIALISEE.
CREATE MATERIALIZED VIEW G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE
	(
	    OBJECTID,
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
WITH ATTRIBUT AS (
SELECT
	    DISTINCT 
	        a.OBJECTID,
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
			o.OSM_WAY_ID,
			p.CAPACITY,
			q.SEATS,
			r.HEIGHT,
            so.nom_source || ' - ' || no.nom_organisme || ' - ' || aq.MILLESIME AS source
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
	    INNER JOIN G_GEO.TA_SOURCE so ON so.objectid = me.fid_source
	    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME mro ON mro.fid_metadonnee = me.objectid
	    INNER JOIN G_GEO.TA_ORGANISME no ON no.objectid = mro.fid_organisme
	    INNER JOIN G_GEO.TA_DATE_ACQUISITION aq ON aq.objectid = me.fid_acquisition
	WHERE
		EXTRACT(YEAR from aq.date_acquisition)=TO_CHAR(sysdate, 'yyyy')
	GROUP BY
	        a.OBJECTID,
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
			o.OSM_WAY_ID,
			p.CAPACITY,
			q.SEATS,
			r.HEIGHT,
            so.nom_source,
            no.nom_organisme,
            aq.MILLESIME
	)
SELECT
        a.OBJECTID,
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
		a.source,
		d.GEOM
FROM
	ATTRIBUT a
	INNER JOIN G_OSM.TA_OSM b ON b.OBJECTID = a.OBJECTID
	INNER JOIN G_OSM.TA_OSM_RELATION_GEOM c ON c.fid_osm = b.objectid
	INNER JOIN G_OSM.TA_OSM_GEOM d ON d.OBJECTID = c.fid_osm_geom
WHERE
    a.OBJECTID IS NOT NULL OR
	a.OSM_WAY_ID IS NOT NULL OR
	a.AMENITY IS NOT NULL OR
	a.NAME IS NOT NULL OR
	a."NATURAL" IS NOT NULL OR
	a.BICYCLE_PARKING IS NOT NULL OR
	a."ACCESS" IS NOT NULL OR
	a.LEISURE IS NOT NULL OR
	a.SCHOOL_FR IS NOT NULL OR
	a.SPORT IS NOT NULL OR
	a.PARKING IS NOT NULL OR
	a.RELIGION IS NOT NULL OR
	a.BUILDING IS NOT NULL OR
	a.LANDUSE IS NOT NULL OR
	a.CAPACITY IS NOT NULL OR
	a.SEATS IS NOT NULL OR
	a.HEIGHT IS NOT NULL OR
	a.source IS NOT NULL
;


-- 2. CREATION DES COMMENTAIRES DE LA VUE ET DES COLONNES.
COMMENT ON MATERIALIZED VIEW G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE IS 'Vue proposant les équipements polygones OSM actuellement disponibles sur le territoire de la MEL avec les principaux mots clés pivotés en colonnes';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.OBJECTID IS 'Clé primaire de la table';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.OSM_WAY_ID IS 'Identifiant OSM de l''élement WAY OSM';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.AMENITY IS 'Type de l''équipent utile et important cartographié: école, crêche, bureau de poste';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.NAME IS 'Nom de l''équipement';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE."NATURAL" IS 'Type de l''équipement OSM naturel: arbre';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.BICYCLE_PARKING IS 'Type de parking pour vélos: stand, bollard';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE."ACCESS" IS 'Accessibilité de l''équipement: public, privé, client';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.LEISURE IS 'Type d''équipement de loisir cartographié: parc, terrain de jeu';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.SCHOOL_FR IS 'Niveau de l''école française: maternelle, primaire, college';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.SPORT IS 'Type d''équipement sportif cartographié: bowling, judo';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.PARKING IS 'Type de parking: surface, souterrain';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.RELIGION IS 'Religion concernée par l''équipement: chrétien, musulman...';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.BUILDING IS 'Type de batiment; école, hôpital, église';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.LANDUSE IS 'Utilisation du sol: industielle, loisir...';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.CAPACITY IS 'Capacité de l''équipement';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.SEATS IS 'Nombre de place assise de l''équipement';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.HEIGHT IS 'Hauteur de l''équipement';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.SOURCE IS 'Source de la donnée';
COMMENT ON COLUMN G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE.GEOM IS 'Géométrie de l''équipement';

-- 3. CREATION DE LA CLE PRIMAIRE.
ALTER MATERIALIZED VIEW VM_OSM_PIVOT_MULTIPOLYGONE
ADD CONSTRAINT VM_OSM_PIVOT_MULTIPOLYGONE_PK 
PRIMARY KEY (OBJECTID);


-- 4. CREATION DES METADONNEE.
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'VM_OSM_PIVOT_MULTIPOLYGONE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;


-- 5. . CREATION DE L'INDEX SPATIAL.
CREATE INDEX VM_OSM_PIVOT_MULTIPOLYGONE_SIDX
ON G_OSM.VM_OSM_PIVOT_MULTIPOLYGONE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);