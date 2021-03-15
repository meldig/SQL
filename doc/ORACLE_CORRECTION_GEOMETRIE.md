Correction des erreurs de géométrie sour Oracle:

Requete pour afficher les différents types de géométries présents dans une table

```SQL
SELECT
	t.#COLONNE_GEOMETRIQUE#.sdo_gtype,
	count(t.#COLONNE_GEOMETRIQUE#.sdo_gtype)
FROM
	#TABLE# t
GROUP BY t.#COLONNE_GEOMETRIQUE#.sdo_gtype
```

le type de géométrie d'un objet dans Oracle se définit avec un code en 4 chiffres sous le format: DLXX ou:

* D: Identifie le nombre de dimensions: 2, 3, 4
* L: identifie la dimension de mesure de référencement linéaire pour une géométrie de système de référencement linéaire (LRS) en trois dimensions.
* XX: Identifie le type de géométrie:
    * 01: Point
    * 02: Ligne ou courbe
    * 03: Polygone ou surface
    * 04: Collection
    * 05: Multipoint
    * 06: Polyligne ou polycourbe
    * 07: Multi-polygones ou multi-surfaces
    * 08: Solide
    * 09: Multi-solides

Requete pour afficher le code des erreurs:

```SQL
	SELECT
	    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.#COLONNE_GEOMETRIQUE#, 0.005), 0, 5) AS ERREUR,
	    COUNT(a.CLE_PRIMAIRE) AS Nombre
	FROM
	    #TABLE# a
	WHERE
	    SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.#COLONNE_GEOMETRIQUE#, 0.005)<>'TRUE'
	GROUP BY
	    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.#COLONNE_GEOMETRIQUE#, 0.005), 0, 5);
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

Exemple de requete de correction

1. Utilisation de la fonction SDO_UTIL.SIMPLIFY

```SQL
-- Correction de l'erreur 13342
UPDATE #TABLE# t
    SET t.#COLONNE_GEOMETRIQUE# = SDO_UTIL.SIMPLIFY(t.#COLONNE_GEOMETRIQUE#, 0.005, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(t.#COLONNE_GEOMETRIQUE#, 0.005), 0, 5) = '13342';
```


2. Utilisation de la fonction SDO_UTIL.RECTIFY_GEOMETRY

```SQL
-- Correction de l'erreur 13356 -> Une géométrie dispose de sommets en doublons
UPDATE #TABLE# a
    SET a.#COLONNE_GEOMETRIQUE# = SDO_UTIL.RECTIFY_GEOMETRY(a.#COLONNE_GEOMETRIQUE#, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.#COLONNE_GEOMETRIQUE#, 0.005), 0, 5) = '13356';
```


3. Utilisation de la fonction SDO_AGGR_UNION(SDOAGGRTYPE)

```SQL
-- Erreur 13366 et 13350
UPDATE #TABLE# a
    SET a.#COLONNE_GEOMETRIQUE# = (
                    SELECT
                        SDO_AGGR_UNION(SDOAGGRTYPE(b.#COLONNE_GEOMETRIQUE#, 0.005))
                    FROM
                        #TABLE# b
                    WHERE
                        a.objectid = b.objectid
                )
    WHERE
        SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.#COLONNE_GEOMETRIQUE#, 0.005), 0, 5) IN ('13366', '13350');
```


4. Utilisation de la fonction SDO_GEOM.SDO_BUFFER

```SQL
-- Correction des polygones ne disposant que de trois sommets au lieu des quatre minimum requis
UPDATE #TABLE# a
SET a.#COLONNE_GEOMETRIQUE# = SDO_GEOM.SDO_BUFFER(a.#COLONNE_GEOMETRIQUE#, 0, 0.005)
WHERE
    SDO_UTIL.GETNUMVERTICES(a.#COLONNE_GEOMETRIQUE#)=3
;
```


5. Utilisation de la fonction SDO_GEOM.SDO_SELF_UNION

```SQL
UPDATE #TABLE# a
SET a.#COLONNE_GEOMETRIQUE# = SDO_GEOM.SDO_SELF_UNION(a.#COLONNE_GEOMETRIQUE#, 0.005)
WHERE
SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.#COLONNE_GEOMETRIQUE#, 0.005), 0, 5) IN ('13349');
```
