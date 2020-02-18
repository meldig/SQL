DROP MATERIALIZED VIEW vm_communes_actuelles_ign;
DELETE FROM user_sdo_geom_metadata WHERE table_name = 'vm_communes_actuelles_ign';
/*
Création de la vue matérialisée des communes actuelles de la BdTopo de l'IGN
*/

-- 1. Création de la vue matérialisée
CREATE MATERIALIZED VIEW g_referentiel.vm_communes_actuelles_ign (
    nom,
    code_insee,
    code_postal,
    geom,
    source
)

REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS
 WITH
 v_main_selection AS(
    SELECT
        a.fid_commune,
        b.code AS code_insee,
        d.nom,
        c.geom,
        CONCAT(CONCAT(f.nom_source, ' - '), h.acronyme) AS source
    FROM
        g_geo.ta_identifiant_commune a
        INNER JOIN g_geo.ta_code b ON a.fid_identifiant = b.objectid
        INNER JOIN g_geo.ta_commune c ON a.fid_commune = c.objectid
        INNER JOIN g_geo.ta_nom d ON c.fid_nom = d.objectid
        INNER JOIN g_geo.ta_metadonnee e ON c.fid_metadonnee = e.objectid
        INNER JOIN g_geo.ta_source f ON e.fid_source = f.objectid
        INNER JOIN g_geo.ta_za_communes g ON c.objectid = g.fid_commune
        INNER JOIN g_geo.ta_organisme h ON e.fid_organisme = h.objectid
    WHERE
        b.fid_libelle = 1
        AND g.fid_zone_administrative = 1
        AND sysdate BETWEEN g.debut_validite AND g.fin_validite
    ),
    
    v_code_postal AS(
    SELECT
        a.fid_commune,
        b.code AS code_postal
    FROM
        g_geo.ta_identifiant_commune a
        INNER JOIN g_geo.ta_code b ON a.fid_identifiant = b.objectid
    WHERE
        b.fid_libelle = 2
    )
    SELECT
        a.nom,
        a.code_insee,
        b.code_postal,
        a.geom,
        a.source
    FROM
        v_main_selection a,
        v_code_postal b 
    WHERE
        a.fid_commune = b.fid_commune;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON MATERIALIZED VIEW "vm_communes_actuelles_ign" IS 'Vue matérialisée proposant les communes actuelles de la MEL.';
COMMENT ON COLUMN "vm_communes_actuelles_ign"."NOM" IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN "vm_communes_actuelles_ign"."CODE_INSEE" IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN "vm_communes_actuelles_ign"."CODE_POSTAL" IS 'Code Postal de chaque commune.';
COMMENT ON COLUMN "vm_communes_actuelles_ign"."GEOM" IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN "vm_communes_actuelles_ign"."SOURCE" IS 'Source de la donnée avec l''organisme créateur de la source.';

-- 2. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'vm_communes_actuelles_ign',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

ALTER MATERIALIZED VIEW vm_communes_actuelles_ign
ADD CONSTRAINT vm_communes_actuelles_ign_PK PRIMARY KEY (code_insee)DISABLE;

CREATE INDEX vm_communes_actuelles_ign_SIDX
ON vm_communes_actuelles_ign(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=POLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);