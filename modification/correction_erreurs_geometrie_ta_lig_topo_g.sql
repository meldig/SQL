SET SERVEROUTPUT ON
DECLARE
BEGIN
SAVEPOINT POINT_SAVE_TA_LIG_TOPO_G;

/*
Cette procédure a pour objectif de corriger les erreurs de géométrie présentes dans la table TA_LIG_TOPO_G.
Les erreurs corrigées ci-dessous sont celles identifiées dans la table, ça ne veut pas dire que tous les types d'erreurs sont corrigés. Seuls ceux qui ont été identifiés le sont.
*/

-- Correction de l'erreur 13342 -> une géométrie de type arc doit obligatoirement disposer d'au moins 3 sommets.
UPDATE GEO.TA_LIG_TOPO_G t
    SET t.geom = SDO_UTIL.SIMPLIFY(t.geom, 0.005, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(t.geom, 0.005), 0, 5) = '13342';
    
-- Correction de l'erreur 13356 -> Une géométrie dispose de sommets en doublons
UPDATE GEO.TA_LIG_TOPO_G a
    SET a.geom = SDO_UTIL.RECTIFY_GEOMETRY(a.geom, 0.005)
WHERE
    SUBSTR(SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(a.geom, 0.005), 0, 5) = '13356';

-- Suppression des géométries NULL
DELETE 
FROM 
	GEO.TA_LIG_TOPO_G a 
WHERE 
	a.geom IS NULL;

-- Suppression des géométries d'un type autre que ligne ou multiligne
DELETE
FROM
    GEO.TA_LIG_TOPO_G a
WHERE
    a.geom.sdo_gtype NOT IN(2002, 2006);
    
COMMIT;

-- En cas d'erreur une exception est levée et un rollback effectué, empêchant ainsi toute modification de se faire et de retourner à l'état de la table précédent.
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('L''erreur ' || SQLCODE || 'est survenue. Un rollback a été effectué : ' || SQLERRM(SQLCODE));
        ROLLBACK TO POINT_SAVE_TA_LIG_TOPO_G;
END;