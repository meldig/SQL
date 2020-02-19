/*
Création de la vue des communes françaises avec les municipalités frontalières belges actuelles de la BdTopo de l'IGN français et belge
*/
DROP VIEW v_communes_mel_et_frontiere_belge;

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.v_communes_mel_et_frontiere_belge (
    nom,
    identifiant_unique,
    geom,
    source,
    CONSTRAINT "v_COMMUNES_MEL_ET_FRONTIERE_BELGE_PK" PRIMARY KEY ("IDENTIFIANT_UNIQUE") DISABLE
)
AS(
 SELECT
        b.code AS identifiant_unique,
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
        sysdate BETWEEN g.debut_validite AND g.fin_validite
        AND b.fid_libelle = 1 
        AND g.fid_zone_administrative = 1
    UNION ALL
    SELECT
            b.code AS identifiant_unique,
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
            sysdate BETWEEN g.debut_validite AND g.fin_validite
            AND b.fid_libelle = 281 
            AND g.fid_zone_administrative IN(3, 4, 5);
);

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE v_communes_mel_et_frontiere_belge IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN avec les municipalités belges frontalières.';
COMMENT ON COLUMN v_communes_mel_et_frontiere_belge.NOM IS 'Nom de chaque commune de la MEL et de chaque municipalités belges.';
COMMENT ON COLUMN v_communes_mel_et_frontiere_belge.IDENTIFIANT_UNIQUE IS 'Code INSEE pour les communes / Code INS pour les municipalités.';
COMMENT ON COLUMN v_communes_mel_et_frontiere_belge.GEOM IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN v_communes_mel_et_frontiere_belge.SOURCE IS 'Source de la donnée avec l''organisme créateur de la source.';