/*
Suppression de l'index spatial de la table d'import que l'on remplace par un nouveau sur le bon TABLESPACE.
*/

-- 1. Suppression de l'index spatial de TEMP_COMMUNES
SET SERVEROUTPUT ON
DECLARE
    v_index_name VARCHAR2(50);
BEGIN
    SELECT
        INDEX_NAME
        INTO v_index_name
    FROM
        ALL_INDEXES
    WHERE
        TABLE_NAME = 'TEMP_COMMUNES'
        AND INDEX_TYPE = 'DOMAIN';
        
    EXECUTE IMMEDIATE 'DROP INDEX '|| v_index_name;
END;
/
-- 2. Création du nouvel index spatial de TEMP_COMMUNES
CREATE INDEX TEMP_COMMUNES_SIDX
ON TEMP_COMMUNES(ORA_GEOMETRY)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');
/
-- 3. Suppression de l'index spatial de TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE
SET SERVEROUTPUT ON
DECLARE
    v_index_name VARCHAR2(50);
BEGIN
    SELECT
        INDEX_NAME
        INTO v_index_name
    FROM
        ALL_INDEXES
    WHERE
        TABLE_NAME = 'TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE'
        AND INDEX_TYPE = 'DOMAIN';
        
    EXECUTE IMMEDIATE 'DROP INDEX '|| v_index_name;
END;
/
-- 4. Création du nouvel index spatial de TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE
CREATE INDEX TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE_SIDX
ON TEMP_COMMUNE_ASSOCIEE_OU_DELEGUEE(ORA_GEOMETRY)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');
/