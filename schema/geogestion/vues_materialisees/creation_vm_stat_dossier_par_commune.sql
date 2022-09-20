/*
Création de la vue VM_STAT_DOSSIER_PAR_COMMUNE regroupant les informations des dossiers de levés nécessaires à leur gestion par les géomètres et les photo-interprètes.
*/
/*
DROP MATERIALIZED VIEW G_GESTIONGEO.VM_STAT_DOSSIER_PAR_COMMUNE;
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'VM_STAT_DOSSIER_PAR_COMMUNE';
*/

CREATE MATERIALIZED VIEW G_GESTIONGEO.VM_STAT_DOSSIER_PAR_COMMUNE("OBJECTID", "CODE_INSEE", "COMMUNE", "ETAT", "NOMBRE_DOSSIER", "GEOM")
REFRESH FORCE ON DEMAND START WITH TO_DATE('2022/09/20 12:00:00', 'YYYY/MM/DD HH:MI:SS') NEXT(SYSDATE+6/24)
DISABLE QUERY REWRITE AS
  WITH
    C_1 AS(
        SELECT
            a.code_insee,
            b.fid_etat_avancement,
            COUNT(b.objectid) AS nombre_dossier
        FROM
            G_GESTIONGEO.TA_GG_GEO a
            INNER JOIN G_GESTIONGEO.TA_GG_DOSSIER b ON b.fid_perimetre = a.objectid
        GROUP BY
            a.code_insee,
            b.fid_etat_avancement
    )
    
    SELECT
        rownum,
        a.code_insee,
        b.nom AS commune,
        c.libelle_long AS etat,
        a.nombre_dossier,
        SDO_GEOM.SDO_CENTROID(b.geom, 0.001)
    FROM
        C_1 a
        INNER JOIN G_REFERENTIEL.MEL_COMMUNE b ON b.code_insee = a.code_insee
        INNER JOIN G_GESTIONGEO.TA_GG_ETAT_AVANCEMENT c ON c.objectid = a.fid_etat_avancement;

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'VM_STAT_DOSSIER_PAR_COMMUNE',
    'GEOM',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 3. Création de la clé primaire
ALTER MATERIALIZED VIEW VM_STAT_DOSSIER_PAR_COMMUNE 
ADD CONSTRAINT VM_STAT_DOSSIER_PAR_COMMUNE_PK 
PRIMARY KEY (OBJECTID);

-- 4. Création de l'index spatial
CREATE INDEX VM_STAT_DOSSIER_PAR_COMMUNE_SIDX
ON G_GESTIONGEO.VM_STAT_DOSSIER_PAR_COMMUNE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POINT, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

COMMENT ON COLUMN "G_GESTIONGEO"."VM_STAT_DOSSIER_PAR_COMMUNE"."OBJECTID" IS 'Clé primaire de la VM.';
COMMENT ON COLUMN "G_GESTIONGEO"."VM_STAT_DOSSIER_PAR_COMMUNE"."CODE_INSEE" IS 'Code INSEE de la commune';
COMMENT ON COLUMN "G_GESTIONGEO"."VM_STAT_DOSSIER_PAR_COMMUNE"."COMMUNE" IS 'Nom de la commune';
COMMENT ON COLUMN "G_GESTIONGEO"."VM_STAT_DOSSIER_PAR_COMMUNE"."ETAT" IS 'Etats d''avancement des dossiers.';
COMMENT ON COLUMN "G_GESTIONGEO"."VM_STAT_DOSSIER_PAR_COMMUNE"."NOMBRE_DOSSIER" IS 'Nombre de dossiers créés par état et commune.';
COMMENT ON COLUMN "G_GESTIONGEO"."VM_STAT_DOSSIER_PAR_COMMUNE"."GEOM" IS 'Champ géométrique du centroïde de la commune.';
COMMENT ON MATERIALIZED VIEW "G_GESTIONGEO"."VM_STAT_DOSSIER_PAR_COMMUNE"  IS 'Vue matérialisée statistique comptant le nombre de dossiers créés par état et commune.';

/

