-- Fichier de creation des indexes
-- Code pour recréer les indexes afin de remplir plus rapidement les tables avec 


-- TA_PTTOPO_INTEGRATION
CREATE INDEX TA_PTTOPO_INTEGRATION_SIDX
ON G_GESTIONGEO.TA_PTTOPO_INTEGRATION(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_GG_RECUPERATION_Z_ETAPE_4
CREATE INDEX TA_GG_RECUPERATION_Z_ETAPE_4_SIDX
ON G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_4(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_GG_RECUPERATION_Z_ETAPE_5
CREATE INDEX TA_GG_RECUPERATION_Z_ETAPE_5_SIDX
ON G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_GG_RECUPERATION_Z_ETAPE_5_MUF_TOPO

CREATE INDEX TA_GG_RECUPERATION_Z_ETAPE_5_MUF_TOPO_SIDX
ON G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_TOPO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO

CREATE INDEX TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO_SIDX
ON G_GESTIONGEO.TA_GG_RECUPERATION_Z_ETAPE_5_MUF_SANS_TOPO(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_RTGE_POINT_INTEGRATION
CREATE INDEX TA_RTGE_POINT_INTEGRATION_SIDX
ON G_GESTIONGEO.TA_RTGE_POINT_INTEGRATION(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_RTGE_POINT_INTEGRATION_LOG
CREATE INDEX TA_RTGE_POINT_INTEGRATION_LOG_SIDX
ON G_GESTIONGEO.TA_RTGE_POINT_INTEGRATION_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_RTGE_POINT_PRODUCTION
CREATE INDEX TA_RTGE_POINT_PRODUCTION_SIDX
ON G_GESTIONGEO.TA_RTGE_POINT_PRODUCTION(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_RTGE_POINT_PRODUCTION_LOG
CREATE INDEX TA_RTGE_POINT_PRODUCTION_LOG_SIDX
ON G_GESTIONGEO.TA_RTGE_POINT_PRODUCTION_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=POINT, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_RTGE_LINEAIRE_INTEGRATION
CREATE INDEX TA_RTGE_LINEAIRE_INTEGRATION_SIDX
ON G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_RTGE_LINEAIRE_INTEGRATION_LOG
CREATE INDEX TA_RTGE_LINEAIRE_INTEGRATION_LOG_SIDX
ON G_GESTIONGEO.TA_RTGE_LINEAIRE_INTEGRATION_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_RTGE_LINEAIRE_PRODUCTION
CREATE INDEX TA_RTGE_LINEAIRE_PRODUCTION_SIDX
ON G_GESTIONGEO.TA_RTGE_LINEAIRE_PRODUCTION(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_RTGE_LINEAIRE_PRODUCTION_LOG
CREATE INDEX TA_RTGE_LINEAIRE_PRODUCTION_LOG_SIDX
ON G_GESTIONGEO.TA_RTGE_LINEAIRE_PRODUCTION_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_IC_LINEAIRE
CREATE INDEX TA_IC_LINEAIRE_SIDX
ON G_GESTIONGEO.TA_IC_LINEAIRE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_IC_LINEAIRE_LOG
CREATE INDEX TA_IC_LINEAIRE_LOG_SIDX
ON G_GESTIONGEO.TA_IC_LINEAIRE_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_OCSMEL
CREATE INDEX TA_OCSMEL_SIDX
ON G_GESTIONGEO.TA_OCSMEL(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_OCSMEL_LOG
CREATE INDEX TA_OCSMEL_LOG_SIDX
ON G_GESTIONGEO.TA_OCSMEL_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_OCSMEL_LINEAIRE
CREATE INDEX TA_OCSMEL_LINEAIRE_SIDX
ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');


-- TA_OCSMEL_LINEAIRE_LOG
CREATE INDEX TA_OCSMEL_LINEAIRE_LOG_SIDX
ON G_GESTIONGEO.TA_OCSMEL_LINEAIRE_LOG(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTILINE, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');

/
