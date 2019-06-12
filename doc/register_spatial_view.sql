-- https://gerardnico.com/oracle_spatial/metadata

insert into user_sdo_geom_metadata (table_name,column_name,diminfo,srid) values ('TABLE_NAME','GEOM_COLUMN_NAME', sdo_dim_array(sdo_dim_element('X',80000,100000,0.005),sdo_dim_element('Y',425000,450000,0.005)), 32039);

/*
...where the X, Y values define the minimum bounding box of the spatial data. In this case, the values are minX=80000, minY=425000, maxX=100000, maxY=450000 and the SRID value is 32039.
Spatial Views
If you create a spatial view in an Oracle database you also need to add information to the metadata table for the view to be defined. If you don't do this you will see the view in a table list with the Oracle (non-spatial) reader but not the Oracle Spatial Object reader. To add the metadata information use a command similar to this:
*/

INSERT INTO user_sdo_geom_metadata (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) VALUES
VALUES (
  'TA_ACQ_GG_TERRITOIRE', 'GEOM',
  SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 0, 20, 0.005),
  SDO_DIM_ELEMENT('Y', 0, 20, 0.005)
  ),
2154
);
