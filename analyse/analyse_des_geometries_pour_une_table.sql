/*
	Sélection des types et des nombres de géométries présents dans une table.
*/

SELECT DISTINCT
	a.geom.sdo_gtype AS TYPE_GEOMETRIE,
	COUNT(a.objectid) AS NOMBRE_OBJETS
FROM
	#NOM_SCHEMA#.#NOM_TABLE# a
GROUP BY
	a.geom.sdo_gtype;


/*
Sélection des types d'erreurs de géométrie dans une table et du nombre d'objets concernés.
Pour faire fonctionner la requête ci-dessous, veuillez remplacer #NOM_SCHEMA# et #NOM_TABLE# par les noms du schéma et de la table concernés.
*/
SELECT
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) AS ERREUR,
    COUNT(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005)) AS Nombre
FROM
    #NOM_SCHEMA#.#NOM_TABLE# a
WHERE
    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005)<>'TRUE'
GROUP BY
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5);