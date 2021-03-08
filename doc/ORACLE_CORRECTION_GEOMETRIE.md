Correction des erreurs de géométrie sour Oracle:

Requete pour afficher le code des erreurs:

```SQL
	SELECT
	    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(#COLONNE_GEOMETRIQUE#, 0.005), 0, 5) AS ERREUR,
	    COUNT(a.CLE_PRIMAIRE) AS Nombre
	FROM
	    TABLE a
	WHERE
	    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(#COLONNE_GEOMETRIQUE#, 0.005)<>'TRUE'
	GROUP BY
	    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(#COLONNE_GEOMETRIQUE#, 0.005), 0, 5);
```

|Code erreur | Signification | méthode de correction |
|------------|---------------|-----------------------|
|13028 |Invalid Gtype in the SDO_GEOMETRY object. | MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,1)|
|13033 |Invalid data in the SDO_ELEM_INFO_ARRAY in SDO_GEOMETRY object. |
|13034 |There is invalid data in the SDO_ORDINATE_ARRAY field of the SDO_GEOMETRY object. The coordinates in this field do not make up a valid geometry. There may be NULL values for X, Y, or both.
|13342 |an arc geometry has fewer than three coordinates. |SDO_UTIL.SIMPLIFY(#COLONNE GEOMETRIQUE#, 0.005, 0.005)|
|13343 |A polygon geometry has fewer than four coordinates. |SDO_UTIL.SIMPLIFY(#COLONNE GEOMETRIQUE#, 0.005, 0.005)|
|13349 |polygon boundary crosses itself. The boundary of a polygon intersects itself. |SDO_UTIL.RECTIFY_GEOMETRY(#COLONNE GEOMETRIQUE#, 0.005)|
|13350 |two or more rings of a complex polygon touch. The inner or outer rings of a complex polygon touch. |SDO_AGGR_UNION(SDOAGGRTYPE(#COLONNE GEOMETRIQUE#, 0.005)|
|13351 |two or more rings of a complex polygon overlap. The inner or outer rings of a complex polygon overlap. |
|13356 |adjacent points in a geometry are redundant. There are repeated points in the sequence of coordinates. |SDO_UTIL.RECTIFY_GEOMETRY(#COLONNE GEOMETRIQUE#, 0.005)|
|13366 |invalid combination of interior exterior rings. In an Oracle Spatial geometry, interior and exterior rings are not used consistently. |SDO_AGGR_UNION(SDOAGGRTYPE(#COLONNE GEOMETRIQUE#, 0.005)|
|13367 |wrong orientation for interior/exterior rings. In an Oracle Spatial geometry, the exterior and/or interior rings are not oriented correctly. |SDO_UTIL.RECTIFY_GEOMETRY(#COLONNE GEOMETRIQUE#, 0.005)|