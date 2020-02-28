/*
Création de la vue des 90 communes de la BdTopo de l'IGN 
*/
DROP VIEW adm_communes_mel_90;

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.adm_communes_mel_90 (
    objectid,
    nom_minuscule,
    nom_majuscule,
    code_insee,
    code_postal,
    geom,
    aire_km2,
    source,
    CONSTRAINT "adm_communes_mel_90_PK" PRIMARY KEY ("CODE_INSEE") DISABLE
)
AS
 WITH
 v_main_selection AS(
    SELECT
        a.fid_commune,
        b.code AS code_insee,
        d.nom,
        c.geom,
        ROUND(SDO_GEOM.SDO_AREA(c.geom, 0.005, 'unit=SQ_KILOMETER'), 2) AS aire_km2,
        CONCAT(CONCAT(CONCAT(CONCAT(h.acronyme, ' - '), f.nom_source), ' - '),  EXTRACT(YEAR FROM j.millesime))AS source
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
        INNER JOIN g_geo.ta_libelle k ON b.fid_libelle = k.objectid
    WHERE
        k.libelle = 'code insee'
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
        INNER JOIN g_geo.ta_libelle c ON b.fid_libelle = c.objectid
    WHERE
        c.libelle = 'code postal'
    )
    SELECT
        rownum AS objectid,
        LOWER(a.nom) AS nom_minuscule,
        UPPER(a.nom) AS nom_majuscule,
        a.code_insee,
        b.code_postal,
        a.geom,
        a.aire_km2,
        a.source
    FROM
        v_main_selection a,
        v_code_postal b 
    WHERE
        a.fid_commune = b.fid_commune;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE g_referentiel.adm_communes_mel_90 IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_90.NOM_MINUSCULE IS 'Nom de chaque commune de la MEL en minuscule.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_90.NOM_MAJUSCULE IS 'Nom de chaque commune de la MEL en majuscule.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_90.CODE_INSEE IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_90.CODE_POSTAL IS 'Code Postal de chaque commune.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_90.GEOM IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_90.SOURCE IS 'Source de la donnée avec l''organisme créateur de la source.';