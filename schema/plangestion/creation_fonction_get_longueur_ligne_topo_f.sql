-- Creation d'une fonction pour calculer la longueur des éléments présents dans la table TA_LIG_TOPO_F
CREATE OR REPLACE FUNCTION GET_LONGUEUR_LIGNE_TOPO_F(v_objectid NUMBER) RETURN NUMBER

DETERMINISTIC
AS
v_longeur NUMBER(38,2);
BEGIN
    SELECT
    -- Selection de la longueur de la ligne
        ROUND(SDO_LRS.MEASURE_RANGE(SDO_LRS.CONVERT_TO_LRS_GEOM(SDO_CS.MAKE_2D(a.geom))),2) into v_longeur
    FROM
        GEO.TA_LIG_TOPO_F a
    WHERE
        a.objectid = v_objectid
        ;
RETURN v_longeur;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '00000';
END GET_LONGUEUR_LIGNE_TOPO_F;
