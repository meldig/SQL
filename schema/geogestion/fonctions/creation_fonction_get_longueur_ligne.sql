---------------------------------
-- CREATION_FONCTION_GET_LONGUEUR_LIGNE --
---------------------------------

create or replace FUNCTION GET_LONGUEUR_LIGNE(v_geometry MDSYS.SDO_GEOMETRY, v_table_name VARCHAR2) RETURN NUMBER DETERMINISTIC
-- Cette fonction a pour objectif de calculer la longueur des lignes simples arrondie aux deux décimales après la virgule
    AS
    v_longueur NUMBER(38,2);
    v_diminfo SDO_DIM_ARRAY;
    BEGIN
        SELECT 
            diminfo INTO v_diminfo 
        FROM 
            USER_SDO_GEOM_METADATA 
        WHERE
            table_name = v_table_name;

        v_longueur:= ROUND(SDO_GEOM.SDO_LENGTH(SDO_CS.MAKE_2D(v_geometry,2154)),2);
        RETURN v_longueur;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         RETURN 9999999.99;
    END GET_LONGUEUR_LIGNE;

/
