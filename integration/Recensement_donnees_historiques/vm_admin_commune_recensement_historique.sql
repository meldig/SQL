-- Création de la vue des communes actuelles de la MEL via la BdTopo de l'IGN avec les données historiques des populations communales 1876-2017 calculées sur la base de la géographie des communes en 2019. 

-- 1. Création de la vue
CREATE MATERIALIZED VIEW G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE(
    identifiant, 
    code_insee, 
    nom, 
    recensement,
    description_recensement,
    population,
    source,
    geom,
)
REFRESH ON DEMAND
FORCE
DISABLE QUERY REWRITE AS

-- Sélection principale des éléments de la vue. Utilisation des données de la sous requête isolant les données du recensement et des données liées aux communes
SELECT
    b.valeur AS identifiant, 
    b.valeur AS code_insee, 
    d.valeur AS nom,
    r.valeur AS recensement,
    n.valeur AS description_recensement,
    l.population AS population,
    f.nom_source || ' - ' || h.acronyme || ' - ' || i.millesime || ' - ' || t.nom_source || ' - ' || v.acronyme || ' - ' || w.millesime AS source,
    c.geom
FROM
-- phase de selection des communes
    G_GEO.TA_IDENTIFIANT_COMMUNE a
    INNER JOIN G_GEO.TA_CODE b ON b.objectid = a.fid_identifiant
    INNER JOIN G_GEO.TA_COMMUNE c ON c.objectid = a.fid_commune
    INNER JOIN G_GEO.TA_NOM d ON d.objectid = c.fid_nom
    INNER JOIN G_GEO.TA_METADONNEE e ON e.objectid = c.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE f ON f.objectid = e.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME g ON g.fid_metadonnee = e.objectid
    INNER JOIN G_GEO.TA_ORGANISME h ON h.objectid = g.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION i ON i.objectid = e.fid_acquisition
    INNER JOIN G_GEO.TA_LIBELLE j ON j.objectid = b.fid_libelle
    INNER JOIN G_GEO.TA_LIBELLE_LONG k ON k.objectid = j.fid_libelle_long
-- phase de selection des valeurs de recensement
    INNER JOIN G_GEO.TA_RECENSEMENT l ON l.fid_code = b.objectid
    INNER JOIN G_GEO.TA_LIBELLE m ON m.objectid = l.fid_lib_recensement
    INNER JOIN G_GEO.TA_LIBELLE_LONG n ON n.objectid = m.fid_libelle_long
    INNER JOIN G_GEO.TA_FAMILLE_LIBELLE o ON o.fid_libelle_long = n.objectid
    INNER JOIN G_GEO.TA_FAMILLE p ON p.objectid = o.fid_famille
    INNER JOIN G_GEO.TA_LIBELLE_CORRESPONDANCE q ON q.fid_libelle = m.objectid
    INNER JOIN G_GEO.TA_LIBELLE_COURT r ON r.objectid = q.fid_libelle_court
    INNER JOIN G_GEO.TA_METADONNEE s ON s.objectid = l.fid_metadonnee
    INNER JOIN G_GEO.TA_SOURCE t ON t.objectid = s.fid_source
    INNER JOIN G_GEO.TA_METADONNEE_RELATION_ORGANISME u ON u.fid_metadonnee = s.objectid
    INNER JOIN G_GEO.TA_ORGANISME v ON v.objectid = u.fid_organisme
    INNER JOIN G_GEO.TA_DATE_ACQUISITION w ON w.objectid = s.fid_acquisition
    WHERE
        f.nom_source = 'BDTOPO'
    AND
        i.millesime = '01/01/2019'
    AND
        k.valeur = 'code insee'
    AND
        UPPER(p.valeur) = 'RECENSEMENT'
    AND
        t.description = 'Les statistiques sont proposées dans la géographie communale en vigueur au 01/01/2019 pour la France hors Mayotte, afin que leurs comparaisons dans le temps se fassent sur un champ géographique stable.'
;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE.identifiant IS 'Clé primaire de la vue.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE.code_insee IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE.nom IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE.recensement IS 'Type de recensement';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE.description_recensement IS 'Description du recensement';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE.population IS 'Nombre d''habitant au sein de la commune calculé sur la base de la géographie des communes en 2019.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE.source IS 'Information sur les metadonnées des données utilisées pour créer la vue matérialisée.';
COMMENT ON COLUMN G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE.geom IS 'Géométrie de chaque commune - de type polygone.';

-- 3. Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);


-- 4. Création de la clé primaire
ALTER MATERIALIZED VIEW G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT 
ADD CONSTRAINT ADMIN_COMMUNE_RECENSEMENT_PK
PRIMARY KEY (IDENTIFIANT)
USING INDEX TABLESPACE "G_ADT_INDX";


-- 5. Création de l'index spatial
CREATE INDEX ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE_SIDX
ON G_REFERENTIEL.ADMIN_COMMUNE_RECENSEMENT_HISTORIQUE(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS(
    'sdo_indx_dims=2, 
    layer_gtype=MULTIPOLYGON, 
    tablespace=G_ADT_INDX, 
    work_tablespace=DATA_TEMP'
    );