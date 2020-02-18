/*
Création de la vue des communes actuelles de la BdTopo de l'IGN
*/
DROP VIEW v_communes_actuelles_ign;

-- 1. Création de la vue matérialisée
CREATE OR REPLACE FORCE VIEW g_referentiel.v_communes_actuelles_ign (
    nom,
    code_insee,
    code_postal,
    geom,
    source,
    CONSTRAINT "V_COMMUNES_ACTUELLES_IGN_PK" PRIMARY KEY ("CODE_INSEE") DISABLE
)
AS
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
COMMENT ON TABLE v_communes_actuelles_ign IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN v_communes_actuelles_ign.NOM IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN v_communes_actuelles_ign.CODE_INSEE IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN v_communes_actuelles_ign.CODE_POSTAL IS 'Code Postal de chaque commune.';
COMMENT ON COLUMN v_communes_actuelles_ign.GEOM IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN v_communes_actuelles_ign.SOURCE IS 'Source de la donnée avec l''organisme créateur de la source.';