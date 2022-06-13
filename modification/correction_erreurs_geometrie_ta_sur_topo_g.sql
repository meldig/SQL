SET SERVEROUTPUT ON
DECLARE
BEGIN
SAVEPOINT POINT_SAVE_TA_SUR_TOPO_G;

/*
Cette procédure a pour objectif de corriger les erreurs de géométrie présentes dans la table TA_SUR_TOPO_G.
Les erreurs corrigées ci-dessous sont celles identifiées dans la table, ça ne veut pas dire que tous les types d'erreurs sont corrigés. Seuls ceux qui ont été identifiés le sont.
*/
-- Erreur 13349 -> auto intersection
UPDATE GEO.TA_SUR_TOPO_G a
    SET a.geom = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13349';
    
-- Erreur 13356 -> géométries disposant de sommets en doublons
UPDATE GEO.TA_SUR_TOPO_G a
    SET a.geom = SDO_GEOM.SDO_BUFFER(a.geom, 0, 0.001)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13356';
    
-- Erreur 13367 -> Mauvaise orientation des anneaux intérieurs/extérieurs
UPDATE GEO.TA_SUR_TOPO_G a
    SET a.geom = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13367';

-- Erreur 13366 et 13350 ainsi que les géométries de type 2004
UPDATE GEO.TA_SUR_TOPO_G a
    SET a.geom = (
                    SELECT
                        SDO_AGGR_UNION(SDOAGGRTYPE(b.geom, 0.001))
                    FROM
                        GEO.TA_SUR_TOPO_G b
                    WHERE
                        a.objectid = b.objectid
                )
    WHERE
        SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) IN ('13366', '13350')
        OR a.geom.sdo_gtype = 2004;

-- Suppression des entités ne disposant pas de géométrie
DELETE FROM GEO.TA_SUR_TOPO_G a
WHERE SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = 'NULL';

-- Correction des polygones ne disposant que de trois sommets au lieu des quatre minimum requis
UPDATE GEO.TA_SUR_TOPO_G a
SET a.geom = SDO_GEOM.SDO_BUFFER(a.geom, 0, 0.005)
WHERE
    SDO_UTIL.GETNUMVERTICES(a.geom)=3
;

-- Suppression des objets de type point (qui n'ont rien à faire dans cette table)
DELETE FROM GEO.TA_SUR_TOPO_G a
WHERE a.geom.sdo_gtype = 2001;

-- Suppression des objets de type ligne
DELETE FROM GEO.TA_SUR_TOPO_G a
WHERE a.geom.sdo_gtype = 2002;

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

-- Seconde partie des corrections
-- Erreur 13349 -> auto intersection - Correction des objets dont les corrections précédentes auraient pu provoquer cette erreur
UPDATE GEO.TA_SUR_TOPO_G a
    SET a.geom = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13349';
    
-- Erreur 13356 -> géométries disposant de sommets en doublons - correction de cette erreur que les corrections ci-dessus n'ont pu corriger
UPDATE GEO.TA_SUR_TOPO_G a
    SET a.geom = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13356';

-- Transformation du type collection en type polygone. Cette requête résulte des transformations dues aux requêtes précédentes
UPDATE GEO.TA_SUR_TOPO_G a
    SET a.geom = (
                    SELECT
                        SDO_AGGR_UNION(SDOAGGRTYPE(b.geom, 0.001))
                    FROM
                        GEO.TA_SUR_TOPO_G b
                    WHERE
                        a.objectid = b.objectid
                )
    WHERE
        a.geom.sdo_gtype = 2004;

-- Correction des arcs : tout arc est transformé en lignes simples
UPDATE GEO.TA_SUR_TOPO_G a
SET a.geom = sdo_geom.sdo_arc_densify(a.GEOM,0.005,'arc_tolerance=0.05 unit=m')
WHERE
    geo.get_info(a.geom,2)=1005
    OR geo.get_info(a.geom,2)=1003 and geo.get_info(a.geom,3) in (4,2);

COMMIT;

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute modification de se faire et de retourner à l'état de la table précédent.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAVE_TA_SUR_TOPO_G;
END;