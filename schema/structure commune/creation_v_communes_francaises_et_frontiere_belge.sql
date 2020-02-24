/*
Création de la vue des communes françaises avec les municipalités frontalières belges actuelles de la BdTopo de l'IGN français et belge
*/
DROP VIEW adm_communes_mel_actuelles_et_belgique;

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.adm_communes_mel_actuelles_et_belgique (
    OBJECTID,
    identifiant_unique,
    nom_minuscule,
    nom_majuscule,
    geom,
    aire_km2,
    source,
    CONSTRAINT "adm_communes_mel_actuelles_ign_PK" PRIMARY KEY("OBJECTID") DISABLE
)
AS
SELECT
        ROWNUM AS objectid,
        b.code AS identifiant_unique,
        LOWER(d.nom) AS nom_minuscule,
        UPPER(d.nom) AS nom_majuscule,
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
    WHERE
        sysdate BETWEEN g.debut_validite AND g.fin_validite
        AND b.fid_libelle IN(1, 281) 
        AND g.fid_zone_administrative IN(1, 3, 4, 5)
;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE adm_communes_mel_actuelles_et_belgique IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN avec les municipalités belges frontalières.';
COMMENT ON COLUMN adm_communes_mel_actuelles_et_belgique.OBJECTID IS 'Clé primaire de chaque enregistrement.';
COMMENT ON COLUMN adm_communes_mel_actuelles_et_belgique.IDENTIFIANT_UNIQUE IS 'Code INSEE pour les communes / Code INS pour les municipalités.';
COMMENT ON COLUMN adm_communes_mel_actuelles_et_belgique.NOM IS 'Nom de chaque commune de la MEL et de chaque municipalités belges frontalières.';
COMMENT ON COLUMN adm_communes_mel_actuelles_et_belgique.GEOM IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN adm_communes_mel_actuelles_et_belgique.aire_km2 IS 'Surface de chaque commune, municipalité en km² arrondie à deux decimales.';
COMMENT ON COLUMN adm_communes_mel_actuelles_et_belgique.SOURCE IS 'Source de la donnée avec l''organisme créateur, la source et son millésime.';