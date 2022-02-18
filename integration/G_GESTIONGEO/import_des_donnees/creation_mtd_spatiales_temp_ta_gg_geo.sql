/*
Insertion des métadonnées spatiales de TEMP_TA_GG_GEO afin d'avoir un SRID pour les données de cette table après leur import
*/
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'TEMP_TA_GG_GEO',
    'ORA_GEOMETRY',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

/
