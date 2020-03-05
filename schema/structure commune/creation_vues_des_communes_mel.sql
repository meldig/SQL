/*
Création de la vue des communes actuelles de la MEL via la BdTopo de l'IGN 
*/
CREATE OR REPLACE FORCE VIEW g_referentiel.admin_communes_mel (
    objectid,
    entite,
    code_insee,
    nom_a,
    surf_km2,
    geom,
    source,
    CONSTRAINT "admin_communes_mel_PK" PRIMARY KEY("OBJECTID") DISABLE
)
AS
 WITH
 v_main_selection AS(
    SELECT
        a.fid_commune,
        b.code AS code_insee,
        d.nom,
        c.geom,
        ROUND(SDO_GEOM.SDO_AREA(c.geom, 0.005, 'unit=SQ_KILOMETER'), 2) AS surf_km2,
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
        INNER JOIN g_geo.ta_libelle p ON b.fid_libelle = p.objectid
    WHERE
        p.libelle = 'code insee'
        AND g.fid_zone_administrative = 1
        AND sysdate BETWEEN g.debut_validite AND g.fin_validite   
    ),
    
    v_selection_entite AS(
    SELECT
        a.objectid,
        b.libelle AS entite
    FROM
        g_geo.ta_commune a
        INNER JOIN g_geo.ta_libelle b ON a.fid_lib_type_commune = b.objectid
    )

    SELECT
        rownum AS objectid,
        b.entite,
        a.code_insee,
        LOWER(a.nom) AS nom_minuscule,
        a.surf_km2,
        a.geom,
        a.source
    FROM
        v_main_selection a,
        v_selection_entite b 
    WHERE
        a.fid_commune = b.objectid;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE g_referentiel.admin_communes_mel IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel.objectid IS 'Clé primaire de la vue.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel.entite IS 'Types d''entités contenues dans la vue. Exemple : commune simple.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel.code_insee IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel.nom_a IS 'Nom de chaque commune de la MEL en minuscule.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel.surf_km2 IS 'Surface des communes en km².';
COMMENT ON COLUMN g_referentiel.admin_communes_mel.geom IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel.source IS 'Source de la donnée avec l''organisme créateur de la source.';


/*
Création de la vue des communes de la MEL90 via la BdTopo de l'IGN 
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.admin_communes_mel90 (
    objectid,
    entite,
    code_insee,
    nom_a,
    surf_km2,
    geom,
    source,
    CONSTRAINT "admin_communes_mel90_PK" PRIMARY KEY ("CODE_INSEE") DISABLE
)
AS
 WITH
 v_main_selection AS(
    SELECT
        a.fid_commune,
        b.code AS code_insee,
        d.nom,
        c.geom,
        ROUND(SDO_GEOM.SDO_AREA(c.geom, 0.005, 'unit=SQ_KILOMETER'), 2) AS surf_km2,
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

    v_selection_entite AS(
    SELECT
        a.objectid,
        b.libelle AS entite
    FROM
        g_geo.ta_commune a
        INNER JOIN g_geo.ta_libelle b ON a.fid_lib_type_commune = b.objectid
    )
    
    SELECT
        rownum AS objectid,
        b.entite,
        a.code_insee,
        LOWER(a.nom) AS nom_a,
        a.surf_km2,
        a.geom,
        a.source
    FROM
        v_main_selection a,
        v_selection_entite b 
    WHERE
        a.fid_commune = b.objectid;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE g_referentiel.admin_communes_mel90 IS 'Vue proposant les communes de la MEL - quand elle se composait de 90 communes - extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel90.objectid IS 'Clé primaire de la vue.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel90.entite IS 'Types d''entités contenues dans la vue. Exemple : commune simple.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel90.code_insee IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel90.nom_a IS 'Nom de chaque commune de la MEL en minuscule.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel90.surf_km2 IS 'Surface des communes en km².';
COMMENT ON COLUMN g_referentiel.admin_communes_mel90.geom IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN g_referentiel.admin_communes_mel90.source IS 'Source de la donnée avec l''organisme créateur de la source.';