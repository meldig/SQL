/*
Objectif : désactiver les données bâties dont la géométrie comporte des arcs et les recréer sans ces arcs.
Procédure : 
*/

-- 1. insertion de nouvelle données avec les mêmes données attributaires, mais des lignes à la places des arcs
INSERT INTO ta_sur_topo_g(
    CLA_INU,
    GEO_REF,
    GEO_INSEE,
    GEOM,
    GEO_DV,
    GEO_DF,
    GEO_ON_VALIDE,
    GEO_TEXTE,
    GEO_TYPE,
    GEO_NMN,
    GEO_DS,
    GEO_NMS,
    GEO_DM
)

WITH
    select_bati AS(
        SELECT
           *
        FROM
            ta_sur_topo_g a
        WHERE
            a.cla_inu IN(206, 216, 348, 357, 232, 364, 804, 805, 806)
    )
    
    SELECT 
        a.CLA_INU,
        a.GEO_REF,
        a.GEO_INSEE,
        SDO_GEOM.SDO_ARC_DENSIFY(a.GEOM,0.005,'arc_tolerance=0.005 unit=m'),
        a.GEO_DV,
        a.GEO_DF,
        a.GEO_ON_VALIDE,
        a.GEO_TEXTE,
        a.GEO_TYPE,
        a.GEO_NMN,
        a.GEO_DS,
        a.GEO_NMS,
        a.GEO_DM
    FROM
        select_bati a
    WHERE
        geo.get_info(a.geom,1) IN(4, 1005, 2005)
        OR geo.get_info(a.geom,2) IN (4, 1005, 2005)
        OR geo.get_info(a.geom,3) IN (4, 1005, 2005);

-- 2. Mise à jour des données disposant d'arcs, en passant tous les geo_on_valide à 1.
UPDATE 
    (
        SELECT
           *
        FROM
            ta_sur_topo_g a
        WHERE
            a.cla_inu IN(206, 216, 348, 357, 232, 364, 804, 805, 806)
    )

SET a.geo_on_valide = 1
    WHERE
        geo.get_info(select_bati.geom,1) IN(4, 1005, 2005)
        OR geo.get_info(select_bati.geom,2) IN (4, 1005, 2005)
        OR geo.get_info(select_bati.geom,3) IN (4, 1005, 2005);