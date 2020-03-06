/*
Création de la vue des communes actuelles de la MEL via la BdTopo de l'IGN 
*/
CREATE OR REPLACE FORCE VIEW g_referentiel.adm_communes_mel (
    identifiant,
    entite_adm,
    code_adm,
    nom_a,
    nom_b,
    nom_c,
    surf_km2,
    geom,
    source,
    CONSTRAINT "adm_communes_mel_PK" PRIMARY KEY("IDENTIFIANT") DISABLE
)
AS
 WITH
 v_main_selection AS(
    SELECT
        a.fid_commune,
        b.code AS code_adm,
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
    
    v_selection_entite_adm AS(
    SELECT
        a.objectid,
        b.libelle AS entite_adm
    FROM
        g_geo.ta_commune a
        INNER JOIN g_geo.ta_libelle b ON a.fid_lib_type_commune = b.objectid
    )

    SELECT
        rownum AS identifiant,
        b.entite_adm,
        a.code_adm,
        LOWER(a.nom) AS nom_minuscule,
        '' AS nom_b,
        '' AS nom_c,
        a.surf_km2,
        a.geom,
        a.source
    FROM
        v_main_selection a,
        v_selection_entite_adm b 
    WHERE
        a.fid_commune = b.objectid;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE g_referentiel.adm_communes_mel IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.identifiant IS 'Clé primaire de la vue.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.entite_adm IS 'Types d''entités contenues dans la vue. Exemple : commune simple.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.code_adm IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.nom_a IS 'Nom de chaque commune de la MEL en minuscule.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.nom_b IS 'Etiquette format intermédiaire.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.nom_c IS 'Etiquette format court.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.surf_km2 IS 'Surface des communes en km².';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.geom IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel.source IS 'Source de la donnée avec l''organisme créateur de la source.';

-- 3. Don du droit de lecture de la vue au schéma G_REFERENTIEL_LEC
GRANT SELECT ON adm_communes_mel TO G_REFERENTIEL_LEC;

/*
Création de la vue des communes de la MEL90 via la BdTopo de l'IGN 
*/

-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.adm_communes_mel90 (
    identifiant,
    entite_adm,
    code_adm,
    nom_a,
    nom_b,
    nom_c,
    surf_km2,
    geom,
    source,
    CONSTRAINT "adm_communes_mel90_PK" PRIMARY KEY ("IDENTIFIANT") DISABLE
)
AS
 WITH
 v_main_selection AS(
    SELECT
        a.fid_commune,
        b.code AS code_adm,
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

    v_selection_entite_adm AS(
    SELECT
        a.objectid,
        b.libelle AS entite_adm
    FROM
        g_geo.ta_commune a
        INNER JOIN g_geo.ta_libelle b ON a.fid_lib_type_commune = b.objectid
    )
    
    SELECT
        rownum AS identifiant,
        b.entite_adm,
        a.code_adm,
        LOWER(a.nom) AS nom_a,
        '' AS nom_b,
        '' AS nom_c,
        a.surf_km2,
        a.geom,
        a.source
    FROM
        v_main_selection a,
        v_selection_entite_adm b 
    WHERE
        a.fid_commune = b.objectid;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE g_referentiel.adm_communes_mel90 IS 'Vue proposant les communes de la MEL - quand elle se composait de 90 communes - extraites de la BdTopo de l''IGN.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.identifiant IS 'Clé primaire de la vue.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.entite_adm IS 'Types d''entités contenues dans la vue. Exemple : commune simple.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.code_adm IS 'Code INSEE de chaque commune.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.nom_a IS 'Nom de chaque commune de la MEL en minuscule.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.nom_b IS 'Etiquette format intermédiaire.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.nom_c IS 'Etiquette format court.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.surf_km2 IS 'Surface des communes en km².';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.geom IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel90.source IS 'Source de la donnée avec l''organisme créateur de la source.';

-- 3. Don du droit de lecture de la vue au schéma G_REFERENTIEL_LEC
GRANT SELECT ON adm_communes_mel90 TO G_REFERENTIEL_LEC;

/*
Création de la vue des communes françaises avec les municipalités frontalières belges actuelles de la BdTopo de l'IGN français et belge.
Précision : la frontière des municipalités belges a été modifiée afin d'obtenir une frontière jointive avec les communes françaises.

DROP VIEW adm_communes_mel_actuelles_et_belgique;
*/
-- 1. Création de la vue
CREATE OR REPLACE FORCE VIEW g_referentiel.adm_communes_mel_belgique
 (
    identifiant,
    entite_adm,
    code_adm,
    nom_a,
    nom_b,
    nom_c,
    surf_km2,
    geom,
    source,
    CONSTRAINT "adm_communes_mel_belgique_PK" PRIMARY KEY("IDENTIFIANT") DISABLE
)
AS
WITH
 v_main_selection AS(
    SELECT
        b.code AS code_adm,
        a.fid_commune,
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
        k.libelle IN('code insee', 'code ins')
        AND g.fid_zone_administrative IN(1, 3, 4, 5)
        AND sysdate BETWEEN g.debut_validite AND g.fin_validite
    ),

    v_selection_entite_adm AS(
    SELECT
        a.objectid,
        b.libelle AS entite_adm
    FROM
        g_geo.ta_commune a
        INNER JOIN g_geo.ta_libelle b ON a.fid_lib_type_commune = b.objectid
    )
    
    SELECT
        rownum AS identifiant,
        REPLACE(b.entite_adm, 'aux contours frontaliers modifiés', '') AS entite_adm,
        a.code_adm,
        LOWER(a.nom) AS nom_a,
        '' AS nom_b,
        '' AS nom_c,
        a.surf_km2,
        a.geom,
        a.source
    FROM
        v_main_selection a,
        v_selection_entite_adm b 
    WHERE
        a.fid_commune = b.objectid;

-- 2. Création des commentaires de table et de colonnes
COMMENT ON TABLE g_referentiel.adm_communes_mel_belgique IS 'Vue proposant les communes actuelles de la MEL extraites de la BdTopo de l''IGN avec les municipalités belges frontalières issues de l''IGN belge dont les frontières ont été modifiées afin d''obtenir une frontière jointive avec les communes françaises.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.identifiant IS 'Clé primaire de la vue.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.entite_adm IS 'Types d''entités contenues dans la vue. Exemple : commune simple.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.code_adm IS 'Code INSEE pour les communes / Code INS pour les municipalités.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.nom_a IS 'Nom de chaque commune de la MEL et de chaque municipalités belges frontalières.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.nom_b IS 'Etiquette format intermédiaire.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.nom_c IS 'Etiquette format court.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.geom IS 'Géométrie de chaque commune - de type polygone.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.surf_km2 IS 'Surface de chaque commune, municipalité en km² arrondie à deux décimales.';
COMMENT ON COLUMN g_referentiel.adm_communes_mel_belgique.source IS 'Source de la donnée avec l''organisme créateur, la source et son millésime.';

-- 3. Don du droit de lecture de la vue au schéma G_REFERENTIEL_LEC
GRANT SELECT ON adm_communes_mel_belgique TO G_REFERENTIEL_LEC;