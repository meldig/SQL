/*
Création de la table ADMIN_COMMUNES_MEL95 qui regroupe toutes les communes de la MEL95 issues de la BdTopo2019.
*/
-- 1. Création de la table
CREATE TABLE G_REFERENTIEL.ADMIN_COMMUNES_MEL95(IDENTIFIANT, CODE_INSEE, NOM, GEOM)
AS
SELECT
    CAST(a.valeur AS NUMBER(38,0)) AS identifiant,
    a.valeur AS code_insee,
    d.valeur AS nom,
    c.geom
FROM
    -- Communes de la MEL
    G_GEO.TA_CODE a
    INNER JOIN G_GEO.TA_IDENTIFIANT_COMMUNE b ON b.fid_identifiant = a.objectid
    INNER JOIN G_GEO.TA_COMMUNE c ON c.objectid = b.fid_commune
    INNER JOIN G_GEO.TA_NOM d ON d.objectid = c.fid_nom
    INNER JOIN G_GEO.TA_LIBELLE e ON e.objectid = a.fid_libelle
    INNER JOIN G_GEO.TA_LIBELLE_LONG f ON f.objectid = e.fid_libelle_long
    INNER JOIN G_GEO.TA_ZA_COMMUNES g ON g.fid_commune = c.objectid
    INNER JOIN G_GEO.TA_ZONE_ADMINISTRATIVE h ON h.objectid = g.fid_zone_administrative
    INNER JOIN G_GEO.TA_NOM i ON i.objectid = h.fid_nom
    INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = c.fid_lib_type_commune
    INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
    -- MTD
    INNER JOIN G_GEO.TA_METADONNEE l ON l.objectid = c.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE m ON m.objectid = l.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME n ON n.fid_metadonnee = l.objectid
    INNER JOIN G_GEO.TA_ORGANISME o ON o.objectid = n.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION p ON p.objectid = l.fid_acquisition
WHERE
    UPPER(f.valeur) = UPPER('code insee')
    AND UPPER(k.valeur) = UPPER('commune simple')
    AND UPPER(i.acronyme) = UPPER('mel')
    AND g.debut_validite = '01/01/20'
    AND g.fin_validite = '31/12/20'
    AND UPPER(m.nom_source) = UPPER('bdtopo')
    AND UPPER(o.acronyme) = UPPER('ign')
;

-- 2. Création des commentaires de VM et des colonnes
COMMENT ON TABLE G_REFERENTIEL.ADMIN_COMMUNES_MEL95 IS 'Table proposant les communes de la MEL95 extraites de la BdTopo2019 de l''IGN.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNES_MEL95.IDENTIFIANT IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNES_MEL95.CODE_INSEE IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNES_MEL95.NOM IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNES_MEL95.GEOM IS 'Géométrie de chaque commune.';

-- 3. Création de la clé primaire
ALTER TABLE G_REFERENTIEL.ADMIN_COMMUNES_MEL95 
ADD CONSTRAINT ADMIN_COMMUNES_MEL95_PK 
PRIMARY KEY (IDENTIFIANT);

-- 4. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ADMIN_COMMUNES_MEL95',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);
COMMIT;

-- 5. Création des indexes
-- 5.1. Création de l'index spatial
CREATE INDEX ADMIN_COMMUNES_MEL95_SIDX
ON G_REFERENTIEL.ADMIN_COMMUNES_MEL95(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
  'sdo_indx_dims=2, 
  layer_gtype=MULTIPOLYGON, 
  tablespace=G_ADT_INDX, 
  work_tablespace=DATA_TEMP'
);

-- 5.2. Création des indexes non-spatiaux
CREATE INDEX ADMIN_COMMUNES_MEL95_CODE_INSEE_IDX ON G_REFERENTIEL.ADMIN_COMMUNES_MEL95(CODE_INSEE)
    TABLESPACE G_ADT_INDX; 
CREATE INDEX ADMIN_COMMUNES_MEL95_NOM_IDX ON G_REFERENTIEL.ADMIN_COMMUNES_MEL95(NOM)
    TABLESPACE G_ADT_INDX;

-- 6. Don du droit de lecture de la VM au schéma G_REFERENTIEL_LEC et aux administrateurs
GRANT SELECT ON G_REFERENTIEL.ADMIN_COMMUNES_MEL95 TO G_REFERENTIEL_LEC;
GRANT SELECT ON G_REFERENTIEL.ADMIN_COMMUNES_MEL95 TO G_REFERENTIEL_MAJ;
GRANT SELECT ON G_REFERENTIEL.ADMIN_COMMUNES_MEL95 TO G_ADMIN_SIG;