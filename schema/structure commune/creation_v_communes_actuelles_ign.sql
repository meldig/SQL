/*
Création de la vue des communes actuelles de la BdTopo de l'IGN 
*/
CREATE OR REPLACE FORCE VIEW g_referentiel.adm_communes_mel_actuelles (
    objectid,
    nom_minuscule,
    nom_majuscule,
    code_insee,
    code_postal,
    geom,
    aire_km2,
    source,
    CONSTRAINT "adm_communes_actuelles_mel_PK" PRIMARY KEY("OBJECTID") DISABLE
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
        INNER JOIN g_geo.ta_libelle p ON c.fid_lib_type_commune = p.objectid
    WHERE
        p.libelle = 'commune simple'
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
COMMENT ON TABLE g_referentiel.adm_communes_actuelles_mel IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN g_referentiel.adm_communes_actuelles_mel.OBJECTID IS 'Clé primaire de la vue.';
COMMENT ON COLUMN g_referentiel.adm_communes_actuelles_mel.NOM IS 'Nom de chaque commune de la MEL.';
COMMENT ON COLUMN g_referentiel.adm_communes_actuelles_mel.CODE_INSEE IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN g_referentiel.adm_communes_actuelles_mel.CODE_POSTAL IS 'Code Postal de chaque commune.';
COMMENT ON COLUMN g_referentiel.adm_communes_actuelles_mel.GEOM IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN g_referentiel.adm_communes_actuelles_mel.SOURCE IS 'Source de la donnée avec l''organisme créateur, la source et son millésime.';
COMMENT ON COLUMN g_referentiel.adm_communes_actuelles_mel.aire_km2 IS 'Surface de chaque commune en km² arrondie à deux decimales.';

