-- Requete SQL permettant de supprimer de la base de données la structure et les données liées aux zones IRIS

-- 1. Suppression du contenu des tables.
ALTER TABLE G_GEO.TA_IRIS
DROP CONSTRAINT TA_IRIS_FID_NOM_FK;

-- 2. Suppression des noms IRIS
DELETE FROM G_GEO.TA_NOM a
WHERE a.objectid IN
	(
		SELECT
			a.fid_nom
		FROM
			G_GEO.TA_IRIS
	);

-- 3. Suppression de la table G_GEO.TA_IRIS
DROP TABLE G_GEO.TA_IRIS CASCADES CONSTRAINT;

-- 4. Suppression de la table G_GEO.TA_IRIS
DROP TABLE G_GEO.TA_IRIS_GEOM CASCADES CONSTRAINT;

-- 5. Suppression de la table G_GEO.TA_IRIS_GEOM
DELETE FROM USER_SDO_GEOM_METADATE WHERE TABLE_NAME = 'TA_IRIS_GEOM'

-- 6. Suppression des correspondances liées aux libelles iris 
DELETE FROM G_GEO.TA_LIBELLE_CORRESPONDANCE
WHERE fid_libelle IN
	(
		SELECT
			l.objectid
		FROM
			G_GEO.TA_LIBELLE l 
	    INNER JOIN G_GEO.TA_LIBELLE_LONG ll ON l.fid_libelle_long = ll.objectid
	    INNER JOIN G_GEO.TA_FAMILLE_LIBELLE tfl ON tfl.fid_libelle_long = ll.objectid
	    INNER JOIN G_GEO.TA_FAMILLE f ON tfl.fid_famille = f.objectid
	    WHERE f.valeur = 'type de zone IRIS'
	 )
;

-- 7. Suppression des correspondances liées aux libelles iris 
DELETE FROM G_GEO.TA_LIBELLE l
WHERE objectid IN 
	(
		SELECT
			 l.objectid
		FROM
			G_GEO.TA_LIBELLE l 
    INNER JOIN G_GEO.TA_LIBELLE_LONG ll ON l.fid_libelle_long = ll.objectid
    INNER JOIN G_GEO.TA_FAMILLE_LIBELLE tfl ON tfl.fid_libelle_long = ll.objectid
    INNER JOIN G_GEO.TA_FAMILLE f ON tfl.fid_famille = f.objectid
    WHERE f.valeur = 'type de zone IRIS'
   )
;