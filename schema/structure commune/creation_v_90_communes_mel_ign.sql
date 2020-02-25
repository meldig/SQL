/*
Création de la vue des 90 communes de la BdTopo de l'IGN 
*/
DROP VIEW adm_90_communes_mel_ign;

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.adm_90_communes_mel_ign (
    nom,
    code_insee,
    code_postal,
    geom,
    source,
    aire_km2,
    CONSTRAINT "adm_90_communes_mel_ign_PK" PRIMARY KEY ("CODE_INSEE") DISABLE
)
AS
 WITH
 v_main_selection AS(
    SELECT
        a.fid_commune,
        b.code AS code_insee,
        d.nom,
        c.geom,
        CONCAT(CONCAT(CONCAT(CONCAT(h.acronyme, ' - '), f.nom_source), ' - '),  EXTRACT(YEAR FROM j.millesime))AS source,
        ROUND(SDO_GEOM.SDO_AREA(c.geom, 0.005, 'unit=SQ_KILOMETER'), 2) AS aire_km2
    FROM
        g_geo.ta_identifiant_commune a
        INNER JOIN g_geo.ta_code b ON a.fid_identifiant = b.objectid
        INNER JOIN g_geo.ta_commune c ON a.fid_commune = c.objectid
        INNER JOIN g_geo.ta_nom d ON c.fid_nom = d.objectid
        INNER JOIN g_geo.ta_metadonnee e ON c.fid_metadonnee = e.objectid
        INNER JOIN g_geo.ta_source f ON e.fid_source = f.objectid
        INNER JOIN g_geo.ta_za_communes g ON c.objectid = g.fid_commune
        INNER JOIN g_geo.ta_organisme h ON e.fid_organisme = h.objectid
        INNER JOIN g_geo.ta_date_acquisition j ON e.fid_acquisition = j.objectid
    WHERE
        b.fid_libelle = 1
        AND g.fid_zone_administrative = 1
        AND g.debut_validite = '01/01/2017'
        AND g.fin_validite = '31/12/2019'
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
COMMENT ON TABLE adm_90_communes_mel_ign IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN adm_90_communes_mel_ign.NOM IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN adm_90_communes_mel_ign.CODE_INSEE IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN adm_90_communes_mel_ign.CODE_POSTAL IS 'Code Postal de chaque commune.';
COMMENT ON COLUMN adm_90_communes_mel_ign.GEOM IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN adm_90_communes_mel_ign.SOURCE IS 'Source de la donnée avec l''organisme créateur de la source.';